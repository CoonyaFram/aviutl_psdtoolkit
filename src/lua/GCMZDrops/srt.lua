local P = {}

P.name = "SRT �t�@�C�����C���|�[�g"

P.priority = 0

-- ===========================================================
-- �ݒ�@��������
-- ===========================================================

-- �}�����[�h
--   0 - �����f�[�^���e�L�X�g�I�u�W�F�N�g�Ƃ��đ}��
--   1 - �����f�[�^���e�L�X�g�I�u�W�F�N�g�ɃX�N���v�g�Ƃ��đ}��
--
-- [�}�����[�h 1 �̎g����]
--   �}�����[�h 1 �ł́A���̂܂܂ł̓e�L�X�g�͕\������܂���B
--   �h���b�v�ɂ���đ}�����ꂽ�e�L�X�g�I�u�W�F�N�g��������
--   [���f�B�A�I�u�W�F�N�g�̒ǉ�]��[PSDToolKit]��[�e�L�X�g�@�����\���p]
--   �ŕ\���p�̃e�L�X�g�I�u�W�F�N�g��ǉ����邱�Ƃŕ\������܂��B
--   �����Ȃǂ̐ݒ�͑S�ĕ\���p�̃e�L�X�g�I�u�W�F�N�g���ōs���܂��B
P.insertmode = 1


-- SRT�t�@�C���̕����G���R�[�f�B���O
-- "sjis" �� "utf8" �Ŏw��
-- ���������ǂ���ɂ��Ă��}���O�Ɉ�U Shift_JIS �ɕϊ�����܂�
P.encoding = "utf8"

-- �����\��������
-- �b�Ŏw��
P.margin = 0

-- �X�N���v�g��������l�p
P.text_prefix = '<?s=[==['
P.text_postfix = ']==];require("PSDToolKit\\\\PSDToolKitLib").settext(s, obj, true);s=nil?>'

-- ===========================================================
-- �ݒ�@�����܂�
-- ===========================================================

function P.ondragenter(files, state)
  for i, v in ipairs(files) do
    if v.filepath:match("[^.]+$"):lower() == "srt" then
      -- �t�@�C���̊g���q�� srt �̃t�@�C�����������珈���ł������Ȃ̂� true
      return true
    end
  end
  return false
end

function P.ondragover(files, state)
  -- ondragenter �ŏ����ł������Ȃ��̂� ondragover �ł������ł������Ȃ̂Œ��ׂ� true
  return true
end

function P.ondragleave()
end

function texobj(n, layer, startf, endf, group, text)
  if P.insertmode == 1 then
    text = text:gsub("]==]", ']==].."]==]"..[==[')
    text = P.text_prefix .. "\r\n" .. text
    if text:sub(-2) ~= "\r\n" then
      text = text .. "\r\n"
    end
    text = text .. P.text_postfix
  end
  return [[
[]] .. n .. [[]
start=]] .. (startf+1) .. "\r\n" .. [[
end=]] .. (endf+1) .. "\r\n" .. [[
layer=]] .. layer .. "\r\n" .. [[
group=]] .. group .. "\r\n" .. [[
overlay=1
camera=0
[]] .. n .. [[.0]
_name=�e�L�X�g
�T�C�Y=34
�\�����x=0.0
�������ɌʃI�u�W�F�N�g=0
�ړ����W��ɕ\������=0
�����X�N���[��=0
B=0
I=0
type=0
autoadjust=0
soft=1
monospace=0
align=0
spacing_x=0
spacing_y=0
precision=1
color=ffffff
color2=000000
font=MS UI Gothic
text=]] .. GCMZDrops.encodeexotext(text) .. "\r\n" .. [[
[]] .. n .. [[.1]
_name=�W���`��
X=0.0
Y=0.0
Z=0.0
�g�嗦=100.00
�����x=0.0
��]=0.00
blend=0
]]
end

function parse(filepath)
  local f, err = io.open(filepath, "rb")
  if f == nil then
    error(err)
  end
  local srt = f:read("*all")
  f:close()
  if P.encoding ~= "sjis" then
    srt = GCMZDrops.convertencoding(srt, P.encoding, "sjis")
  end
  if srt:sub(-1) ~= "\n" then
    srt = srt .. "\r\n"
  end

  local r = {}
  local id = nil
  local text = ""
  local startf = nil
  local endf = nil
  local maxendf = 0
  for line in srt:gmatch("(.-)\r?\n") do
    if line ~= "" then
      local yet = true
      if yet and (id == nil) then
        local s = line:match("^%d+$")
        if s ~= nil then
          id = tonumber(s)
          yet = false
        end
      end
      if yet and (startf == nil)and(endf == nil) then
        local sh, sm, ss, sms, eh, em, es, ems = line:match("^(%d+):(%d%d):(%d%d),(%d%d%d) %-%-> (%d+):(%d%d):(%d%d),(%d%d%d)$")
        if sh ~= nil then
          startf = tonumber(sh)*60*60 + tonumber(sm)*60 + tonumber(ss) + tonumber(sms)/1000
          endf = tonumber(eh)*60*60 + tonumber(em)*60 + tonumber(es) + tonumber(ems)/1000
          yet = false
        end
      end
      if yet then
        text = text .. line .. "\r\n"
        yet = false
      end
    else
      if (id ~= nil)and(text ~= "")and(startf ~= nil)and(endf ~= nil) then
        endf = endf + P.margin
        table.insert(r, {id=id, s=startf, e=endf, text=text})
        if maxendf < endf then
          maxendf = endf
        end
      end
      id = nil
      text = ""
      startf = nil
      endf = nil
    end
  end
  -- �����K�v�Ȃ����ǁA���Ԏ��𖳎������z�u���ł���̂ňꉞ�΍�
  table.sort(r, function(a, b)
    return a.s < b.s
  end)
  return r, maxendf
end

function P.ondrop(files, state)
  for i, v in ipairs(files) do
    -- �t�@�C���̊g���q�� srt �Ȃ�
    if v.filepath:match("[^.]+$"):lower() == "srt" then
      -- �v���W�F�N�g�̏����擾����
      local proj = GCMZDrops.getexeditfileinfo()
      -- SRT �t�@�C�������
      local srt, len = parse(v.filepath)
      -- ���Ԃ�b����t���[���ɏ�������
      len = math.floor(len * proj.rate / proj.scale)
      -- exo �t�@�C����g�ݗ��Ă�
      local exo = ""
      exo = [[
[exedit]
width=]] .. proj.width .. "\r\n" .. [[
height=]] .. proj.height .. "\r\n" .. [[
rate=]] .. proj.rate .. "\r\n" .. [[
scale=]] .. proj.scale .. "\r\n" .. [[
length=]] .. len .. "\r\n" .. [[
audio_rate=]] .. proj.audio_rate .. "\r\n" .. [[
audio_ch=]] .. proj.audio_ch .. "\r\n" .. [[
]]
      local filepath = GCMZDrops.createtempfile("srt", ".exo")
      f, err = io.open(filepath, "wb")
      if f == nil then
        error(err)
      end
      f:write(exo)

      -- SRT �̓��e�ɏ]���ăe�L�X�g�I�u�W�F�N�g��}�����Ă���
      -- �����\�������ꍇ�͕\����̃��C���[���ς���
      -- �����A�}�����[�h1���ƌ��ǐ����������Ȃ��̂ł��܂�Ӗ��͂Ȃ�����
      local layers = {}
      local n = 0
      for i, t in ipairs(srt) do
        t.s = math.floor(t.s * proj.rate / proj.scale)
        t.e = math.floor(t.e * proj.rate / proj.scale)
        local found = nil
        for li, le in ipairs(layers) do
          if le < t.s then
            found = li
            break
          end
        end
        if found ~= nil then
          layers[found] = t.e
        else
          table.insert(layers, t.e)
          found = #layers
        end
        f:write(texobj(n, found, t.s, t.e, 1, t.text))
        n = n + 1
      end

      f:close()
      debug_print("["..P.name.."] �� " .. v.filepath .. " �� exo �t�@�C���ɍ����ւ��܂����B���̃t�@�C���� orgfilepath �Ŏ擾�ł��܂��B")
      files[i] = {filepath=filepath, orgfilepath=v.filepath}
    end
  end
  -- ���̃C�x���g�n���h���[�ɂ����������������̂ł����͏�� false
  return false
end

return P
