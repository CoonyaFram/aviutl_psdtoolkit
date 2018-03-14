local P = {}

P.name = "Shift �L�[�������Ȃ��� *.wav ���h���b�v�Œǉ��̃I�u�W�F�N�g�𐶐�"

P.priority = 0

function P.loadsetting()
  if P.setting ~= nil then
    return P.setting
  end
  local origpath = package.path
  package.path = GCMZDrops.scriptdir() .. "..\\script\\PSDToolKit\\?.lua"
  local ok, gui = pcall(require, "setting-gui")
  if not ok then gui = {} end
  local ok, user = pcall(require, "setting")
  if not ok then user = {} end
  P.setting = setmetatable(user, {__index = setmetatable(gui, {__index = require("default")})})
  package.path = origpath
  return P.setting
end

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

local function changefileext(filepath, ext)
  local old = filepath:match("[^.]+$")
  return filepath:sub(1, #filepath - #old) .. ext
end

local function fileexists(filepath)
  local f = io.open(filepath, "rb")
  if f ~= nil then
    f:close()
    return true
  end
  return false
end

local function fileread(filepath)
  local f = io.open(filepath, "rb")
  if f == nil then
    return nil
  end
  local b = f:read("*all")
  f:close()
  return b
end

function P.exaread(filepath, postfix)
  local basepath = GCMZDrops.scriptdir() .. "..\\script\\PSDToolKit\\exa\\"
  local inistr = nil
  if filepath ~= nil then
    filepath = basepath .. filepath .. "_" .. postfix .. ".exa"
    inistr = fileread(filepath)
    if inistr == nil then
      debug_print("�ǂݍ��ݎ��s: " .. filepath)
    end
  end
  if inistr == nil then
    filepath = basepath .. postfix .. ".exa"
    inistr = fileread(filepath)
  end
  if inistr ~= nil then
    debug_print("�g�p����G�C���A�X�t�@�C��: " .. filepath)
  else
    error("cannot read: " .. filepath)
  end
  return GCMZDrops.inistring(inistr)
end

function P.findexatype(ini)
  if ini:sectionexists("vo") then
    return "vo"
  elseif ini:sectionexists("ao") then
    return "ao"
  end
  error("unexpected alias file format")
end

function P.numitemsections(ini)
  local prefix = P.findexatype(ini)  
  local n = 0
  while ini:sectionexists(prefix .. "." .. n) do
    n = n + 1
  end
  return n
end

function P.insertexa(destini, srcini, index, layer)
  local prefix = P.findexatype(srcini)
  destini:set(index, "layer", layer)
  destini:set(index, "overlay", 1)
  for _, key in ipairs(srcini:keys(prefix)) do
    if key ~= "length" then
      destini:set(index, key, srcini:get(prefix, key, ""))
    end
  end
  if prefix == "ao" then
    destini:set(index, "audio", 1)
  end

  for i = 0, P.numitemsections(srcini) - 1 do
    local exosection = index .. "." .. i
    local section = prefix .. "." .. i
    for _, key in ipairs(srcini:keys(section)) do
      destini:set(exosection, key, srcini:get(section, key, ""))
    end
  end
end

local function fire(state, v)
  local setting = P.loadsetting()
  local firemode = setting.wav_firemode
  if v.overridefiremode ~= nil then
    -- ���̃X�N���v�g���� overridefiremode ������ǉ�����Ă����ꍇ��
    -- �ݒ���e�Ɋւ�炸������̔������[�h���̗p����
    firemode = v.overridefiremode
  end
  if firemode == 0 then
    return state.shift
  elseif firemode == 1 then
    if state.shift then
      return false
    end
    local txtfilepath = v.orgfilepath or v.filepath
    txtfilepath = txtfilepath:sub(1, #txtfilepath - 3) .. "txt"
    return fileexists(txtfilepath)
  end
  return false
end

function P.resolvepath(filepath, finder, setting)
  if finder == 1 then
    return filepath:match("([^\\]+)[\\][^\\]+$")
  elseif finder == 2 then
    return filepath:match("([^\\]+)%.[^.]+$")
  elseif finder == 3 then
    return filepath:match("([^\\]+)%.[^.]+$"):match("^[^_]+")
  elseif finder == 4 then
    return filepath:match("([^\\]+)%.[^.]+$"):match("^[^_]+_([^_]+)")
  elseif finder == 5 then
    return filepath:match("([^\\]+)%.[^.]+$"):match("^[^_]+_[^_]+_([^_]+)")
  elseif type(finder) == "function" then
    return finder(setting, filepath)
  end
  return nil
end

function P.ondrop(files, state)
  local setting = P.loadsetting()
  for i, v in ipairs(files) do
    -- �t�@�C���̊g���q�� wav �Ŕ������[�h�̏����𖞂����Ă�����
    if (v.filepath:match("[^.]+$"):lower() == "wav") and fire(state, v) then
      -- �e���v���[�g�p�ϐ�������
      local values = {
        WAV_START = 1,
        WAV_END = 1,
        WAV_PATH = v.filepath,
        LIPSYNC_START = 1,
        LIPSYNC_END = 1,
        LIPSYNC_PATH = v.filepath,
        MPSLIDER_START = 1,
        MPSLIDER_END = 1,
        SUBTITLE_START = 1,
        SUBTITLE_END = 1,
        SUBTITLE_TEXT = "",
      }
      local modifiers = {
        ENCODE_TEXT = function(v)
          return GCMZDrops.encodeexotextutf8(v)
        end,
        ENCODE_LUA_STRING = function(v)
          v = GCMZDrops.convertencoding(v, "sjis", "utf8")
          v = GCMZDrops.encodeluastring(v)
          v = GCMZDrops.convertencoding(v, "utf8", "sjis")
          return v
        end,
      }

      -- �v���W�F�N�g�ƃt�@�C���̏����擾����
      local proj = GCMZDrops.getexeditfileinfo()
      local fi = GCMZDrops.getfileinfo(v.filepath)

      -- ���������݂̃v���W�F�N�g�ŉ��t���[��������̂����v�Z����
      local wavlen = math.ceil((fi.audio_samples / proj.audio_rate) * proj.rate / proj.scale)

      -- �����𔽉f
      values.WAV_END = values.WAV_END + wavlen
      values.LIPSYNC_END = values.LIPSYNC_END + wavlen
      values.MPSLIDER_END = values.MPSLIDER_END + wavlen
      values.SUBTITLE_END = values.SUBTITLE_END + wavlen

      -- �I�t�Z�b�g�ƃ}�[�W���𔽉f
      values.LIPSYNC_START = values.LIPSYNC_START + setting.wav_lipsync_offset
      values.LIPSYNC_END = values.LIPSYNC_END + setting.wav_lipsync_offset
      values.MPSLIDER_START = values.MPSLIDER_START - setting.wav_mpslider_margin_left
      values.MPSLIDER_END = values.MPSLIDER_END + setting.wav_mpslider_margin_right
      values.SUBTITLE_START = values.SUBTITLE_START - setting.wav_subtitle_margin_left
      values.SUBTITLE_END = values.SUBTITLE_END + setting.wav_subtitle_margin_right

      -- �}�C�i�X�����ɐi��ł��܂�������߂�
      local ofs = math.min(values.LIPSYNC_START, values.MPSLIDER_START, values.SUBTITLE_START) - 1
      values.WAV_START = values.WAV_START - ofs
      values.WAV_END = values.WAV_END - ofs
      values.LIPSYNC_START = values.LIPSYNC_START - ofs
      values.LIPSYNC_END = values.LIPSYNC_END - ofs
      values.MPSLIDER_START = values.MPSLIDER_START - ofs
      values.MPSLIDER_END = values.MPSLIDER_END - ofs
      values.SUBTITLE_START = values.SUBTITLE_START - ofs
      values.SUBTITLE_END = values.SUBTITLE_END - ofs

      if setting.wav_subtitle > 0 then
        -- *.txt �����邩�T�����߂� *.wav �̊g���q�����������ւ���
        -- ���� orgfilepath ������Ȃ炻�����̖��O�����ɒT���Ȃ���΂Ȃ�Ȃ�
        local txtfilepath = changefileext(v.orgfilepath or v.filepath, "txt")
        local subtitle = fileread(txtfilepath)
        if subtitle ~= nil then
          -- �����G���R�[�f�B���O�� UTF-8 �ȊO�̎��� UTF-8 �֕ϊ�����
          local enc = setting.wav_subtitle_encoding
          if v.overridesubtitleencoding ~= nil then
            -- ���̃X�N���v�g���� overridesubtitleencoding ������ǉ�����Ă����ꍇ��
            -- �ݒ���e�Ɋւ�炸������̕����G���R�[�f�B���O���̗p����
            enc = v.overridesubtitleencoding
          end
          if enc ~= "utf8" then
            subtitle = GCMZDrops.convertencoding(subtitle, enc, "utf8")
          end
          -- BOM ������Ȃ珜������
          if subtitle:sub(1, 3) == "\239\187\191" then
            subtitle = subtitle:sub(4)
          end
          -- �u���p�������Ăяo��
          subtitle = setting:wav_subtitle_replacer(subtitle)
          -- setting.wav_subtitle �� 2 �̎��̓e�L�X�g���X�N���v�g�Ƃ��Đ��`����
          if setting.wav_subtitle == 2 then
            if subtitle:sub(-2) ~= "\r\n" then
              subtitle = subtitle .. "\r\n"
            end
            subtitle = setting.wav_subtitle_prefix .. "\r\n" .. setting:wav_subtitle_escape(subtitle) .. setting.wav_subtitle_postfix
          end
          values.SUBTITLE_TEXT = subtitle
        end
      end

      -- exo �t�@�C���̃w�b�_������g�ݗ���
      local oini = GCMZDrops.inistring("")
      oini:set("exedit", "width", proj.width)
      oini:set("exedit", "height", proj.height)
      oini:set("exedit", "rate", proj.rate)
      oini:set("exedit", "scale", proj.scale)
      oini:set("exedit", "length", math.max(values.WAV_END, values.LIPSYNC_END, values.MPSLIDER_END, values.SUBTITLE_END))
      oini:set("exedit", "audio_rate", proj.audio_rate)
      oini:set("exedit", "audio_ch", proj.audio_ch)

      -- �I�u�W�F�N�g�̑}��
      local filepath = P.resolvepath(v.orgfilepath or v.filepath, setting.wav_exafinder, setting)
      local index = 0

      -- �����p�G�C���A�X��g�ݗ���
      local aini = P.exaread(filepath, "wav")
      setting:wav_examodifler_wav(aini, values, modifiers)
      P.insertexa(oini, aini, index, index + 1)
      index = index + 1

      -- ���p�N�����p�G�C���A�X��g�ݗ���
      if setting.wav_lipsync == 1 then
        local aini = P.exaread(filepath, "lipsync")
        setting:wav_examodifler_lipsync(aini, values, modifiers)
        P.insertexa(oini, aini, index, index + 1)
        index = index + 1
      end

      -- ���ړI�X���C�_�[��g�ݗ���
      if setting.wav_mpslider > 0 then
        local aini = GCMZDrops.inistring("")
        setting:wav_examodifler_mpslider(aini, values, modifiers)
        P.insertexa(oini, aini, index, index + 1)
        index = index + 1
      end

      -- �����p�G�C���A�X��g�ݗ���
      if values.SUBTITLE_TEXT ~= "" then
        local aini = P.exaread(filepath, "subtitle")
        setting:wav_examodifler_subtitle(aini, values, modifiers)
        P.insertexa(oini, aini, index, index + 1)
        index = index + 1
      end

      local filepath = GCMZDrops.createtempfile("wav", ".exo")
      f, err = io.open(filepath, "wb")
      if f == nil then
        error(err)
      end
      f:write(tostring(oini))
      f:close()
      debug_print("["..P.name.."] �� " .. v.filepath .. " �� exo �t�@�C���ɍ����ւ��܂����B���̃t�@�C���� orgfilepath �Ŏ擾�ł��܂��B")
      files[i] = {filepath=filepath, orgfilepath=v.filepath}
    end
  end
  -- ���̃C�x���g�n���h���[�ɂ����������������̂ł����͏�� false
  return false
end

return P
