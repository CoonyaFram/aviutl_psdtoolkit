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

-- �����p�̃G�C���A�X�t�@�C��(*.exa)���ǂ̂悤�ɎQ�Ƃ��邩
-- ���̐ݒ���g���ƁA�h���b�v���ꂽ *.srt �t�@�C���̖��O�ɉ����ĕʂ̃G�C���A�X�t�@�C�����g�p�ł��܂��B
-- �G�C���A�X�t�@�C���� exa �t�H���_�[�̒��ɔz�u���ĉ������B
-- �Y������t�@�C����������Ȃ��ꍇ�� exa\srt.exa ������Ɏg�p����܂��B
--   0 - ��ɓ����t�@�C�����Q�Ƃ���
--     �h���b�v���ꂽ�t�@�C���Ɋւ�炸�ȉ��̃G�C���A�X�t�@�C�����g�p����܂��B
--       exa\srt.exa
--   1 - �t�@�C���������Ă���t�H���_�������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.srt �̎�
--       exa\MyFolder_srt.exa
--   2 - �t�@�C���������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.srt �̎�
--       exa\TKHS_Hello_World_srt.exa
--   3 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ�ŏ��̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.srt �̎�
--       exa\TKHS_srt.exa
--   4 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ2�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.srt �̎�
--       exa\Hello_srt.exa
--   5 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ3�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.srt �̎�
--       exa\World_srt.exa
P.exa_finder = 0

-- �G�C���A�X�t�@�C���̉��Ϗ���
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���B
P.exa_modifler_srt = function(exa, values, modifiers)
  exa:set("vo", "start", values.START + 1)
  exa:set("vo", "end", values.END + 1)
  exa:delete("vo", "length")
  exa:set("vo", "group", 1)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.TEXT))
end

-- �}�����[�h 1 �̎��Ɏg�p�����ړ����A�ڔ����ƃG�X�P�[�v����
P.text_prefix = '<?s=[==['
P.text_postfix = ']==];require("PSDToolKit\\\\PSDToolKitLib").settext(s, obj, true);s=nil?>'
P.text_escape = function(s)
  return s:gsub("]==]", ']==].."]==]"..[==[')
end

-- ===========================================================
-- �ݒ�@�����܂�
-- ===========================================================

local wavP = require("psdtoolkit_wav")

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

function P.parse(filepath)
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
      local srt, len = P.parse(v.filepath)

      local oini = GCMZDrops.inistring("")
      oini:set("exedit", "width", proj.width)
      oini:set("exedit", "height", proj.height)
      oini:set("exedit", "rate", proj.rate)
      oini:set("exedit", "scale", proj.scale)
      oini:set("exedit", "length", math.floor(len * proj.rate / proj.scale))
      oini:set("exedit", "audio_rate", proj.audio_rate)
      oini:set("exedit", "audio_ch", proj.audio_ch)
      
      -- SRT �̓��e�ɏ]���ăe�L�X�g�I�u�W�F�N�g��}�����Ă���
      -- �����\�������ꍇ�͕\����̃��C���[���ς���
      -- �����A�}�����[�h1���ƌ��ǐ����������Ȃ��̂ł��܂�Ӗ��͂Ȃ�����
      local textbase = tostring(wavP.exaread(wavP.resolvepath(v.filepath, P.exa_finder), "srt"))
      local values = {
        START = 0,
        END = 0,
        TEXT = ""
      }
      local modifiers = {
        ENCODE_TEXT = function(v)
          return GCMZDrops.encodeexotext(v)
        end
      }
      local layers = {}
      local n = 0
      for i, t in ipairs(srt) do
        local text = t.text
        -- �}�����[�h�� 1 �̎��̓e�L�X�g���X�N���v�g�Ƃ��Đ��`����
        if P.insertmode == 1 then
          if text:sub(-2) ~= "\r\n" then
            text = text .. "\r\n"
          end
          text = P.text_prefix .. "\r\n" .. P.text_escape(text) .. P.text_postfix
        end
        values.TEXT = text
        values.START = math.floor(t.s * proj.rate / proj.scale)
        values.END = math.floor(t.e * proj.rate / proj.scale)
        local found = nil
        for li, le in ipairs(layers) do
          if le < values.START then
            found = li
            break
          end
        end
        if found ~= nil then
          layers[found] = values.END
        else
          table.insert(layers, values.END)
          found = #layers
        end

        local aini = GCMZDrops.inistring(textbase)
        P.exa_modifler_srt(aini, values, modifiers)
        wavP.insertexa(oini, aini, n, found)
        n = n + 1
      end

      local filepath = GCMZDrops.createtempfile("srt", ".exo")
      local exo, err = io.open(filepath, "wb")
      if exo == nil then
        error(err)
      end
      exo:write(tostring(oini))
      exo:close()
      debug_print("["..P.name.."] �� " .. v.filepath .. " �� exo �t�@�C���ɍ����ւ��܂����B���̃t�@�C���� orgfilepath �Ŏ擾�ł��܂��B")
      files[i] = {filepath=filepath, orgfilepath=v.filepath}
    end
  end
  -- ���̃C�x���g�n���h���[�ɂ����������������̂ł����͏�� false
  return false
end

return P
