local P = {}

P.name = "Shift �L�[�������Ȃ��� *.wav ���h���b�v�Łu���p�N�����v��}��"

P.priority = 0

-- ===========================================================
-- �ݒ�@��������
-- ===========================================================

-- �������[�h
--   0 - Shift �L�[�������Ȃ��� *.wav �t�@�C�����h���b�v����Ɣ���
--   1 - *.wav �t�@�C���Ɠ����ꏊ�� *.txt ������Ɣ����AShift �L�[�Ŗ�����
P.firemode = 0

-- �}�����[�h
--   0 - ��ɉ����ƌ��p�N�����݂̂�}������
--   1 - �e�L�X�g�t�@�C����T���ăe�L�X�g�I�u�W�F�N�g�Ƃ��đ}��
--   2 - �e�L�X�g�t�@�C����T���ăe�L�X�g�I�u�W�F�N�g�ɃX�N���v�g��}��
--
-- [�}�����[�h 2 �̎g����]
--   �}�����[�h 2 �ł́A���̂܂܂ł̓e�L�X�g�͕\������܂���B
--   �h���b�v�ɂ���đ}�����ꂽ�e�L�X�g�I�u�W�F�N�g��������
--   [���f�B�A�I�u�W�F�N�g�̒ǉ�]��[PSDToolKit]��[�e�L�X�g�@�����\���p]
--   �ŕ\���p�̃e�L�X�g�I�u�W�F�N�g��ǉ����邱�Ƃŕ\������܂��B
--   �����Ȃǂ̐ݒ�͑S�ĕ\���p�̃e�L�X�g�I�u�W�F�N�g���ōs���܂��B
P.insertmode = 2

-- *.lab �t�@�C���i�^�C�~���O���t�@�C���j��
-- *.wav �Ɠ����t�H���_�[�ɓ����t�@�C�����ő��݂��鎞��
-- ���p�N������ *.lab ��D��I�Ɏg������ true �� false �Ŏw��
P.use_lab = true

-- ���C���[�ߖ񃂁[�h��L���ɂ��邩�� true �� false �Ŏw��
-- ���C���[�ߖ񃂁[�h�ł́u���p�N�����v���e�L�X�g�I�u�W�F�N�g��
-- �A�j���[�V�������ʂƂ��đ}�����邱�ƂŁA���C���[���P���ߖ񂵂܂��B
-- �e�L�X�g�I�u�W�F�N�g���������Z������ƁA���R�����������Ȃ��Ȃ�܂��B
P.save_layer = false

-- ���p�N�����̃p�����[�^�ݒ�͂����ɂ͂���܂���B
-- exa �t�H���_�ɂ��� lip.exa �̒��� track0, track1, track2 �����������Ă��������B
-- ���ꂼ�� LoCut, HiCut, Threshold �ɑΉ����Ă��܂��B

-- �e�L�X�g�I�u�W�F�N�g���ꏏ�ɃO���[�v�����邩�� true �� false �Ŏw��
P.text_group = true

-- �ǉ������e�L�X�g�I�u�W�F�N�g��
-- �w�肵���t���[������������������������
P.text_margin = 0

-- �e�L�X�g�t�@�C���̕����G���R�[�f�B���O
-- "sjis" �� "utf8" �Ŏw��
-- ���������ǂ���ɂ��Ă��}���O�Ɉ�U Shift_JIS �ɕϊ�����܂�
P.text_encoding = "sjis"

-- �����A�����A���p�N�����p�̃G�C���A�X�t�@�C��(*.exa)���ǂ̂悤�ɎQ�Ƃ��邩
-- ���̐ݒ���g���ƁA�h���b�v���ꂽ *.wav �t�@�C���̖��O�ɉ����ĕʂ̃G�C���A�X�t�@�C�����g�p�ł��܂��B
-- �G�C���A�X�t�@�C���� exa �t�H���_�[�̒��ɔz�u���ĉ������B
-- �Y������t�@�C����������Ȃ��ꍇ�� exa\text.exa / exa\wav.exa / exa\lip.exa ������Ɏg�p����܂��B
--   0 - ��ɓ����t�@�C�����Q�Ƃ���
--     �h���b�v���ꂽ�t�@�C���Ɋւ�炸�ȉ��̃G�C���A�X�t�@�C�����g�p����܂��B
--       ����: exa\text.exa
--       ����: exa\wav.exa
--       ���p�N����: exa\lip.exa
--   1 - �t�@�C���������Ă���t�H���_�������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: exa\MyFolder_text.exa
--       ����: exa\MyFolder_wav.exa
--       ���p�N����: exa\MyFolder_lip.exa
--   2 - �t�@�C���������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: exa\TKHS_Hello_World_text.exa
--       ����: exa\TKHS_Hello_World_wav.exa
--       ���p�N����: exa\TKHS_Hello_World_lip.exa
--   3 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ�ŏ��̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: exa\TKHS_text.exa
--       ����: exa\TKHS_wav.exa
--       ���p�N����: exa\TKHS_lip.exa
--   4 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ2�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: exa\Hello_text.exa
--       ����: exa\Hello_wav.exa
--       ���p�N����: exa\Hello_lip.exa
--   5 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ3�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: exa\World_text.exa
--       ����: exa\World_wav.exa
--       ���p�N����: exa\World_lip.exa
P.exa_finder = 0

-- �G�C���A�X�t�@�C���̉��Ϗ���
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���B
P.exa_modifler_text = function(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.TEXT_LEN)
  exa:delete("vo", "length")
  exa:set("vo", "group", P.text_group and 1 or 0)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.TEXT))
end
P.exa_modifler_wav = function(exa, values, modifiers)
  exa:set("ao", "start", 1)
  exa:set("ao", "end", values.WAV_LEN)
  exa:delete("ao", "length")
  exa:set("ao", "group", 1)
  exa:set("ao.0", "file", values.WAV_PATH)
end
P.exa_modifler_lip = function(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.WAV_LEN)
  exa:delete("vo", "length")
  exa:set("vo", "group", 1)
  exa:set("vo.0", "param", "file=" .. modifiers.ENCODE_LUA_STRING(values.LIP_PATH))
end

-- �}�����[�h 2 �̎��Ɏg�p�����ړ����A�ڔ����ƃG�X�P�[�v����
P.text_prefix = '<?s=[==['
P.text_postfix = ']==];require("PSDToolKit\\\\PSDToolKitLib").settext(s, obj, true);s=nil?>'
P.text_escape = function(s)
  return s:gsub("]==]", ']==].."]==]"..[==[')
end

-- ===========================================================
-- �ݒ�@�����܂�
-- ===========================================================

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
  local text = f:read("*all")
  f:close()
  return text
end

function P.exaread(filepath, postfix)
  local inistr = nil
  if filepath ~= nil then
    filepath = GCMZDrops.scriptdir() .. "exa\\" .. filepath .. "_" .. postfix .. ".exa"
    inistr = fileread(filepath)
    if inistr == nil then
      debug_print("�ǂݍ��ݎ��s: " .. filepath)
    end
  end
  if inistr == nil then
    filepath = GCMZDrops.scriptdir() .. "exa\\" .. postfix .. ".exa"
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
    destini:set(index, key, srcini:get(prefix, key, ""))
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
  local firemode = P.firemode
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

function P.resolvepath(filepath, finder)
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
    return finder(filepath)
  end
  return nil
end

function P.ondrop(files, state)
  for i, v in ipairs(files) do
    -- �t�@�C���̊g���q�� wav �Ŕ������[�h�̏����𖞂����Ă�����
    if (v.filepath:match("[^.]+$"):lower() == "wav") and fire(state, v) then
      -- �v���W�F�N�g�ƃt�@�C���̏����擾����
      local proj = GCMZDrops.getexeditfileinfo()
      local fi = GCMZDrops.getfileinfo(v.filepath)

      -- �e���v���[�g�p�ϐ�������
      local values = {
        TEXT = "",
        TEXT_LEN = 0,
        WAV_LEN = 0,
        WAV_PATH = v.filepath,
        LIP_PATH = v.filepath
      }
      local modifiers = {
        ENCODE_TEXT = function(v)
          return GCMZDrops.encodeexotext(v)
        end,
        ENCODE_LUA_STRING = function(v)
          v = GCMZDrops.convertencoding(v, "sjis", "utf8")
          v = GCMZDrops.encodeluastring(v)
          v = GCMZDrops.convertencoding(v, "utf8", "sjis")
          return v
        end
      }

      -- ���������݂̃v���W�F�N�g�ŉ��t���[��������̂����v�Z����
      values.WAV_LEN = math.ceil((fi.audio_samples / proj.audio_rate) * proj.rate / proj.scale)
      values.TEXT_LEN = values.WAV_LEN + P.text_margin

      if P.insertmode > 0 then
        -- *.txt �����邩�T�����߂� *.wav �̊g���q�����������ւ���
        -- ���� orgfilepath ������Ȃ炻�����̖��O�����ɒT���Ȃ���΂Ȃ�Ȃ�
        local txtfilepath = changefileext(v.orgfilepath or v.filepath, "txt")
        local text = fileread(txtfilepath)
        if text ~= nil then
          -- �����G���R�[�f�B���O�� Shift_JIS �ȊO�̎��� Shift_JIS �֕ϊ�����
          -- TODO: GCMZDrops.encodeexotext �� UTF-8 �̎󂯓�����\��
          local enc = P.text_encoding
          if v.overridetextencoding ~= nil then
            -- ���̃X�N���v�g���� overridetextencoding ������ǉ�����Ă����ꍇ��
            -- �ݒ���e�Ɋւ�炸������̕����G���R�[�f�B���O���̗p����
            enc = v.overridetextencoding
          end
          if enc ~= "sjis" then
            text = GCMZDrops.convertencoding(text, enc, "sjis")
          end
          -- �}�����[�h�� 2 �̎��̓e�L�X�g���X�N���v�g�Ƃ��Đ��`����
          if P.insertmode == 2 then
            if text:sub(-2) ~= "\r\n" then
              text = text .. "\r\n"
            end
            text = P.text_prefix .. "\r\n" .. P.text_escape(text) .. P.text_postfix
          end
          values.TEXT = text
        end
      end
      
      if P.use_lab then
        -- *.lab �����邩�T�����߂� *.wav �̊g���q�����������ւ���
        -- ���� orgfilepath ������Ȃ炻�����̖��O�����ɒT���Ȃ���΂Ȃ�Ȃ�
        local labfilepath = changefileext(v.orgfilepath or v.filepath, "lab")
        if fileexists(labfilepath) then
          if GCMZDrops.needcopy(labfilepath) then
            -- �������������ꏊ���P�v�I�ɗ��p�ł���ꏊ�ł͂Ȃ��ꍇ��
            -- avoiddup.lua �̋@�\�ň��S�n�тɃt�@�C�����R�s�[����
            local newlabfilepath, created = require("avoiddup").getfile(labfilepath)
            values.LIP_PATH = newlabfilepath
          else
            values.LIP_PATH = labfilepath
          end
        end
      end

      -- exo �t�@�C���̃w�b�_������g�ݗ���
      local oini = GCMZDrops.inistring("")
      oini:set("exedit", "width", proj.width)
      oini:set("exedit", "height", proj.height)
      oini:set("exedit", "rate", proj.rate)
      oini:set("exedit", "scale", proj.scale)
      oini:set("exedit", "length", (values.WAV_LEN < values.TEXT_LEN) and values.TEXT_LEN or values.WAV_LEN)
      oini:set("exedit", "audio_rate", proj.audio_rate)
      oini:set("exedit", "audio_ch", proj.audio_ch)

      -- �I�u�W�F�N�g�̑}��
      local filepath = P.resolvepath(v.orgfilepath or v.filepath, P.exa_finder)
      local index = 0
      
      -- �����p�G�C���A�X��g�ݗ���
      if values.TEXT ~= "" then
        local aini = P.exaread(filepath, "text")
        P.exa_modifler_text(aini, values, modifiers)
        if P.save_layer then
          -- ���C���[�ߖ񃂁[�h�̏ꍇ�͍Ō�Ɍ��p�N�����̃A�j���[�V�������ʂ�}��
          local prefix = P.findexatype(aini)
          local n = P.numitemsections(aini)
          local lastsection = prefix .. "." .. (n-1)
          local newsection = prefix .. "." .. n
          -- ��ԍŌ�̌��ʂ��ЂƂ��ɂ��炵�A�R�s�[���͈�U�폜
          for _, key in ipairs(aini:keys(lastsection)) do
            aini:set(newsection, key, aini:get(lastsection, key, ""))
            aini:delete(lastsection, key)
          end
          -- ���p�N�����̃J�X�^���I�u�W�F�N�g���G�C���A�X�t�@�C������ǂݍ����
          -- �A�j���[�V�������ʂɏ��������đ}������
          local lini = P.exaread(filepath, "lip")
          P.exa_modifler_lip(lini, values, modifiers)
          local lsection = P.findexatype(lini) .. ".0" -- TODO: ���ߑł�����Ȃ����������H
          for _, key in ipairs(lini:keys(lsection)) do
            aini:set(lastsection, key, lini:get(lsection, key, ""))
          end
          aini:set(lastsection, "_name", "�A�j���[�V��������")
        end
        P.insertexa(oini, aini, index, index + 1)
        index = index + 1
      end

      -- �����p�G�C���A�X��g�ݗ���
      local aini = P.exaread(filepath, "wav")
      P.exa_modifler_wav(aini, values, modifiers)
      P.insertexa(oini, aini, index, index + 1)
      index = index + 1

      -- ���p�N�����p�G�C���A�X��g�ݗ���
      if not P.save_layer then
        local aini = P.exaread(filepath, "lip")
        P.exa_modifler_lip(aini, values, modifiers)
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
