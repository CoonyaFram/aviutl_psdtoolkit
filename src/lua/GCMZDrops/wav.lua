local P = {}

-- �}�����[�h
--   0: �e�L�X�g�t�@�C���͒T���Ȃ�
--   1: �e�L�X�g�t�@�C����T���ăe�L�X�g�I�u�W�F�N�g�Ƃ��đ}��
--   2: �e�L�X�g�t�@�C����T���ăe�L�X�g�I�u�W�F�N�g�ɃX�N���v�g��}��
P.mode = 2

-- *.lab �t�@�C���i�^�C�~���O���t�@�C���j��
-- *.wav �Ɠ����t�H���_�[�ɓ����t�@�C�����ő��݂��鎞��
-- ���p�N������ *.lab ��D��I�Ɏg����
P.use_lab = true

-- �ǉ������e�L�X�g�I�u�W�F�N�g��
-- ���������w�肵���t���[����������������
P.text_margin = 0

P.name = "Shift �L�[�������Ȃ��� *.wav ���h���b�v�Łu���p�N�����v��}��"

P.priority = 0

function P.ondragenter(files, state)
  for i, v in ipairs(files) do
    if v.filepath:match("[^.]+$"):lower() == "wav" then
      -- �t�@�C���̊g���q�� wav �̃t�@�C�����������珈���ł������Ȃ̂� true
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

function fileexists(filepath)
  local f = io.open(filepath, "rb")
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

function P.ondrop(files, state)
  if not state.shift then
    -- �h���b�v���ꂽ���� shift �L�[��������Ă��Ȃ������牽�����Ȃ�
    return false
  end

  for i, v in ipairs(files) do
    -- �t�@�C���̊g���q�� wav ��������
    if v.filepath:match("[^.]+$"):lower() == "wav" then
      -- �v���W�F�N�g�ƃt�@�C���̏����擾����
      local proj = GCMZDrops.getexeditfileinfo()
      local fi = GCMZDrops.getfileinfo(v.filepath)
      -- ���������݂̃v���W�F�N�g�ŉ��t���[��������̂����v�Z����
      local len = math.ceil((fi.audio_samples / proj.audio_rate) * proj.rate / proj.scale)

      local text = ""
      if P.mode > 0 then
        -- *.txt �����邩�T�����߂� *.wav �̊g���q�����������ւ���
        -- ���� orgfilepath ������Ȃ炻�����̖��O�����ɒT���Ȃ���΂Ȃ�Ȃ�
        local txtfilepath = v.orgfilepath or v.filepath
        txtfilepath = txtfilepath:sub(1, #txtfilepath - 3) .. "txt"
        local f = io.open(txtfilepath, "rb")
        if f ~= nil then
          text = f:read("*all")
          f:close()
        end
      end

      local lipsync = v.filepath
      if P.use_lab then
        -- *.lab �����邩�T�����߂� *.wav �̊g���q�����������ւ���
        -- ���� orgfilepath ������Ȃ炻�����̖��O�����ɒT���Ȃ���΂Ȃ�Ȃ�
        local labfilepath = v.orgfilepath or v.filepath
        labfilepath = labfilepath:sub(1, #labfilepath - 3) .. "lab"
        if fileexists(labfilepath) then
          if GCMZDrops.needcopy(labfilepath) then
            -- �������������ꏊ���P�v�I�ɗ��p�ł���ꏊ�ł͂Ȃ��ꍇ��
            -- avoiddup.lua �̋@�\�ň��S�n�тɃt�@�C�����R�s�[����
            local newlabfilepath, created = require("avoiddup").getfile(labfilepath)
            lipsync = newlabfilepath
          else
            lipsync = labfilepath
          end
        end
      end

      -- �t�@�C���𒼐ړǂݍ��ޑ���� exo �t�@�C����g�ݗ��Ă�
      local exo = ""
      if P.mode == 0 then
        exo = [[
[exedit]
width=]] .. proj.width .. "\r\n" .. [[
height=]] .. proj.height .. "\r\n" .. [[
rate=]] .. proj.rate .. "\r\n" .. [[
scale=]] .. proj.scale .. "\r\n" .. [[
length=]] .. len .. "\r\n" .. [[
audio_rate=]] .. proj.audio_rate .. "\r\n" .. [[
audio_ch=]] .. proj.audio_ch .. "\r\n" .. [[
[0]
start=1
end=]] .. len .. "\r\n" .. [[
layer=1
group=1
overlay=1
audio=1
[0.0]
_name=�����t�@�C��
�Đ��ʒu=0.00
�Đ����x=100.0
���[�v�Đ�=0
����t�@�C���ƘA�g=0
file=]] .. v.filepath .. "\r\n" .. [[
[0.1]
_name=�W���Đ�
����=100.0
���E=0.0
[1]
start=1
end=]] .. len .. "\r\n" .. [[
layer=2
group=1
overlay=1
camera=0
[1.0]
_name=�J�X�^���I�u�W�F�N�g
track0=100.00
track1=1000.00
track2=20.00
track3=0.00
check0=0
type=0
filter=2
name=���p�N����@PSDToolKit
param=]] .. "file=" .. GCMZDrops.encodeluastring(lipsync) .. "\r\n" .. [[
[1.1]
_name=�W���`��
X=0.0
Y=0.0
Z=0.0
�g�嗦=100.00
�����x=0.0
��]=0.00
blend=0
]]
      elseif P.mode == 1 then
        exo = [[
[exedit]
width=]] .. proj.width .. "\r\n" .. [[
height=]] .. proj.height .. "\r\n" .. [[
rate=]] .. proj.rate .. "\r\n" .. [[
scale=]] .. proj.scale .. "\r\n" .. [[
length=]] .. (len + P.text_margin) .. "\r\n" .. [[
audio_rate=]] .. proj.audio_rate .. "\r\n" .. [[
audio_ch=]] .. proj.audio_ch .. "\r\n" .. [[
[0]
start=1
end=]] .. (len + P.text_margin) .. "\r\n" .. [[
layer=1
group=1
overlay=1
camera=0
[0.0]
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
[0.1]
_name=�W���`��
X=0.0
Y=0.0
Z=0.0
�g�嗦=100.00
�����x=0.0
��]=0.00
blend=0
[1]
start=1
end=]] .. len .. "\r\n" .. [[
layer=2
group=1
overlay=1
audio=1
[1.0]
_name=�����t�@�C��
�Đ��ʒu=0.00
�Đ����x=100.0
���[�v�Đ�=0
����t�@�C���ƘA�g=0
file=]] .. v.filepath .. "\r\n" .. [[
[1.1]
_name=�W���Đ�
����=100.0
���E=0.0
[2]
start=1
end=]] .. len .. "\r\n" .. [[
layer=3
group=1
overlay=1
camera=0
[2.0]
_name=�J�X�^���I�u�W�F�N�g
track0=100.00
track1=1000.00
track2=20.00
track3=0.00
check0=0
type=0
filter=2
name=���p�N����@PSDToolKit
param=]] .. "file=" .. GCMZDrops.encodeluastring(lipsync) .. "\r\n" .. [[
[2.1]
_name=�W���`��
X=0.0
Y=0.0
Z=0.0
�g�嗦=100.00
�����x=0.0
��]=0.00
blend=0
]]
      elseif P.mode == 2 then
        exo = [[
[exedit]
width=]] .. proj.width .. "\r\n" .. [[
height=]] .. proj.height .. "\r\n" .. [[
rate=]] .. proj.rate .. "\r\n" .. [[
scale=]] .. proj.scale .. "\r\n" .. [[
length=]] .. (len + P.text_margin) .. "\r\n" .. [[
audio_rate=]] .. proj.audio_rate .. "\r\n" .. [[
audio_ch=]] .. proj.audio_ch .. "\r\n" .. [[
[0]
start=1
end=]] .. (len + P.text_margin) .. "\r\n" .. [[
layer=1
group=1
overlay=1
camera=0
[0.0]
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
text=]] .. GCMZDrops.encodeexotext("<?_s=[==[\r\n" .. text .. "\r\n]==]?>") .. "\r\n" .. [[
[0.1]
_name=�W���`��
X=0.0
Y=0.0
Z=0.0
�g�嗦=100.00
�����x=0.0
��]=0.00
blend=0
[1]
start=1
end=]] .. len .. "\r\n" .. [[
layer=2
group=1
overlay=1
audio=1
[1.0]
_name=�����t�@�C��
�Đ��ʒu=0.00
�Đ����x=100.0
���[�v�Đ�=0
����t�@�C���ƘA�g=0
file=]] .. v.filepath .. "\r\n" .. [[
[1.1]
_name=�W���Đ�
����=100.0
���E=0.0
[2]
start=1
end=]] .. len .. "\r\n" .. [[
layer=3
group=1
overlay=1
camera=0
[2.0]
_name=�J�X�^���I�u�W�F�N�g
track0=100.00
track1=1000.00
track2=20.00
track3=0.00
check0=0
type=0
filter=2
name=���p�N����@PSDToolKit
param=]] .. "file=" .. GCMZDrops.encodeluastring(lipsync) .. "\r\n" .. [[
[2.1]
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
      local filepath = GCMZDrops.createtempfile("psd", ".exo")
      f, err = io.open(filepath, "wb")
      if f == nil then
        error(err)
      end
      f:write(exo)
      f:close()
      debug_print("["..P.name.."] �� " .. v.filepath .. " �� exo �t�@�C���ɍ����ւ��܂����B���̃t�@�C���� orgfilepath �Ŏ擾�ł��܂��B")
      files[i] = {filepath=filepath, orgfilepath=v.filepath}
    end
  end
  -- ���̃C�x���g�n���h���[�ɂ����������������̂ł����͏�� false
  return false
end

return P
