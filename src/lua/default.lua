-- ============================================================
-- �����Ӂ�
-- ============================================================
--
-- ���̃t�@�C���ɂ͐ݒ�̃f�t�H���g�l�������Ă���܂����A
-- ����̓��[�U�[�����������邽�߂̃t�@�C���ł͂���܂���B
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- �ݒ��ύX���������͂��̃t�@�C��������������̂ł͂Ȃ��A
-- `setting.lua-template` �̃t�@�C������ `setting.lua` �ɕύX���A
-- `setting.lua` ���ɏ������ނ��ƂŐݒ肵�Ă��������B
--
-- ��L�̎菇�̒ʂ�ɍs�����ƂŁAPSDToolKit ���o�[�W�����A�b�v���鎞��
-- �ݒ肪�㏑�������̂�h�����Ƃ��ł��܂��B
--
-- �g�����̏ڂ�������͂�������Q�Ƃ��Ă��������B
--
-- URL
--
-- ============================================================

local P = {}

-- ============================================================
-- *.wav �t�@�C�����g���ҏW�ɓ������񂾎��Ɂu���p�N�����v��u���������v���쐬���铮��Ɋւ���ݒ�
-- ============================================================

-- �������[�h - �ǂ̂悤�ɓ������ނƁu���p�N�����v���쐬���邩
--   0 - *.wav �t�@�C�����G�N�X�v���[���[�Œ͂񂾂��ƁA
--       Shift �L�[�������Ȃ���g���ҏW�ɓ������ނƁu���p�N�����v�������쐬
--   1 - �g���ҏW�ɓ������� *.wav �t�@�C���Ɠ����ꏊ�ɓ������O�� *.txt ������Ɓu���p�N�����v�������쐬
--       ������ Shift �L�[�������Ȃ���g���ҏW�ɓ������񂾏ꍇ�́u���p�N�����v���쐬���Ȃ�
P.wav_firemode = 0

-- �}�����[�h - �������O�� *.txt �����鎞�Ƀe�L�X�g�Ȃǂ��쐬���邩
--   0 - ��Ɂu�����v�Ɓu���p�N�����v�݂̂�}������
--   1 - �������O�� *.txt ������ꍇ�̓e�L�X�g�Ƃ��đ}��
--   2 - �������O�� *.txt ������ꍇ�́u���������v�Ƃ��đ}��
--
-- �u���������v�̎g����
--   �u���������v�́A���̂܂܂ł̓e�L�X�g�͉�ʂɕ\������܂���B�u���������v��������
--   [���f�B�A�I�u�W�F�N�g�̒ǉ�]��[PSDToolKit]��[�e�L�X�g�@�����\���p]
--   �Łu�e�L�X�g�@�����\���p�v��ǉ����A�u�������C���v�Ƀ��C���[�ԍ����w�肷�邱�Ƃŕ\������܂��B
--   �����Ȃǂ́u�e�L�X�g�@�����\���p�v�ōs�����ƂɂȂ邽�߁A�ʒu�╶���T�C�Y�Ȃǂ��ꊇ�ŕύX�ł��܂��B
P.wav_insertmode = 2

-- *.lab �t�@�C���i�^�C�~���O���t�@�C���j���g����
-- *.wav �Ɠ����t�H���_�[�ɓ����t�@�C�����ő��݂��鎞��
-- �u���p�N�����v�� *.lab ���g������ true �� false �Ŏw��
-- �L���ɂ��Ă� *.lab �����݂��Ȃ��ꍇ�͓���ɉe���͂���܂���
P.wav_uselab = true

-- �e�L�X�g�܂��́u���������v���ꏏ�ɃO���[�v�����邩
-- true �� false �Ŏw��
P.wav_groupsubtitle = true

-- �e�L�X�g�܂��́u���������v���w�肵���t���[������������������������
P.wav_subtitlemargin = 0

-- �������O�� *.txt �̕����G���R�[�f�B���O
-- "sjis" �� "utf8" �Ŏw��
-- ���������ǂ���ɂ��Ă��}���O�Ɉ�U Shift_JIS �ɕϊ�����܂�
P.wav_subtitleencoding = "sjis"

-- �u�����v�A�u���p�N�����v�A�����ăe�L�X�g�܂��́u���������v�̃G�C���A�X�t�@�C��(*.exa)���ǂ̂悤�ɎQ�Ƃ��邩
-- ���̐ݒ���g���ƁA�h���b�v���ꂽ *.wav �t�@�C���̖��O�ɉ����ĕʂ̃G�C���A�X�t�@�C�����g�p�ł��܂��B
-- �G�C���A�X�t�@�C���� `exa` �t�H���_�[�̒��ɔz�u���ĉ������B
-- �ȉ��̃��[���ŊY������t�@�C����������Ȃ��ꍇ�� wav.exa / lipsync.exa / subtitle.exa ������Ɏg�p����܂��B
--   0 - ��ɓ����t�@�C�����Q�Ƃ���
--     �h���b�v���ꂽ�t�@�C���Ɋւ�炸�ȉ��̃G�C���A�X�t�@�C�����g�p����܂��B
--       ����: wav.exa
--       ���p�N����: lipsync.exa
--       ����: subtitle.exa
--   1 - �t�@�C���������Ă���t�H���_�������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: MyFolder_wav.exa
--       ���p�N����: MyFolder_lipsync.exa
--       ����: MyFolder_subtitle.exa
--   2 - �t�@�C���������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: TKHS_Hello_World_wav.exa
--       ���p�N����: TKHS_Hello_World_lipsync.exa
--       ����: TKHS_Hello_World_subtitle.exa
--   3 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ�ŏ��̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: TKHS_wav.exa
--       ���p�N����: TKHS_lipsync.exa
--       ����: TKHS_subtitle.exa
--   4 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ2�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: Hello_wav.exa
--       ���p�N����: Hello_lipsync.exa
--       ����: Hello_subtitle.exa
--   5 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ3�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.wav �̎�
--       ����: World_wav.exa
--       ���p�N����: World_lipsync.exa
--       ����: World_subtitle.exa
P.wav_exafinder = 0

-- �G�C���A�X�t�@�C���̉��Ϗ���
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���
P.wav_examodifler_wav = function(exa, values, modifiers)
  exa:set("ao", "start", 1)
  exa:set("ao", "end", values.WAV_LEN)
  exa:delete("ao", "length")
  exa:set("ao", "group", 1)
  exa:set("ao.0", "file", values.WAV_PATH)
end
P.wav_examodifler_lipsync = function(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.WAV_LEN)
  exa:delete("vo", "length")
  exa:set("vo", "group", 1)
  exa:set("vo.0", "param", "file=" .. modifiers.ENCODE_LUA_STRING(values.LIPSYNC_PATH))
end
P.wav_examodifler_subtitle = function(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.SUBTITLE_LEN)
  exa:delete("vo", "length")
  exa:set("vo", "group", P.wav_groupsubtitle and 1 or 0)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.SUBTITLE))
end
  
-- wav_insertmode = 2 �̎��Ɏg�p�����u���������v�p�̐ړ����A�ڔ����A�G�X�P�[�v����
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���
P.wav_subtitle_prefix = '<?s=[==['
P.wav_subtitle_postfix = ']==];require("PSDToolKit").subtitle:set(s, obj, true);s=nil?>'
P.wav_subtitle_escape = function(s)
  return s:gsub("]==]", ']==].."]==]"..[==[')
end

-- ============================================================
-- *.lab �t�@�C�����g���ҏW�ɓ������񂾎��Ɂu���p�N�����v���쐬���铮��Ɋւ���ݒ�
-- ============================================================

-- �u���p�N�����v�̃G�C���A�X�t�@�C��(*.exa)���ǂ̂悤�ɎQ�Ƃ��邩
-- ���̐ݒ���g���ƁA�h���b�v���ꂽ *.lab �t�@�C���̖��O�ɉ����ĕʂ̃G�C���A�X�t�@�C�����g�p�ł��܂��B
-- �G�C���A�X�t�@�C���� `exa` �t�H���_�[�̒��ɔz�u���ĉ������B
-- �ȉ��̃��[���ŊY������t�@�C����������Ȃ��ꍇ�� lab.exa ������Ɏg�p����܂��B
--   0 - ��ɓ����t�@�C�����Q�Ƃ���
--     �h���b�v���ꂽ�t�@�C���Ɋւ�炸�ȉ��̃G�C���A�X�t�@�C�����g�p����܂��B
--       lab.exa
--   1 - �t�@�C���������Ă���t�H���_�������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.lab �̎�
--       MyFolder_lab.exa
--   2 - �t�@�C���������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.lab �̎�
--       TKHS_Hello_World_lab.exa
--   3 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ�ŏ��̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.lab �̎�
--       TKHS_lab.exa
--   4 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ2�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.lab �̎�
--       Hello_lab.exa
--   5 - �t�@�C�����̒��� _ �ŋ�؂�ꂽ3�߂̕��������ɂ���
--     ��: �h���b�v���ꂽ�t�@�C���� C:\MyFolder\TKHS_Hello_World.lab �̎�
--       World_lab.exa
P.lab_exafinder = 0

-- �G�C���A�X�t�@�C���̉��Ϗ���
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���
P.lab_examodifler = function(exa, values, modifiers)
  exa:set("vo", "start", values.START + 1)
  exa:set("vo", "end", values.END + 1)
  exa:delete("vo", "length")
  exa:set("vo", "group", 1)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.LIPSYNC))
end

P.lab_lipsync_prefix = '<?l='
P.lab_lipsync_postfix = ';require("PSDToolKit").talk:setphoneme(obj,l);l=nil?>'
P.lab_lipsync_escape = function(s)
  return GCMZDrops.encodeluastring(s)
end

-- ============================================================
-- *.srt �t�@�C�����g���ҏW�ɓ������񂾎��Ƀe�L�X�g�܂��́u���������v���쐬���铮��Ɋւ���ݒ�
-- ============================================================

-- �}�����[�h
--   0 - �e�L�X�g�Ƃ��đ}��
--   1 - �u���������v�Ƃ��đ}��
--
-- �u���������v�̎g����
--   �u���������v�́A���̂܂܂ł̓e�L�X�g�͉�ʂɕ\������܂���B�u���������v��������
--   [���f�B�A�I�u�W�F�N�g�̒ǉ�]��[PSDToolKit]��[�e�L�X�g�@�����\���p]
--   �Łu�e�L�X�g�@�����\���p�v��ǉ����A�u�������C���v�Ƀ��C���[�ԍ����w�肷�邱�Ƃŕ\������܂��B
--   �����Ȃǂ́u�e�L�X�g�@�����\���p�v�ōs�����ƂɂȂ邽�߁A�ʒu�╶���T�C�Y�Ȃǂ��ꊇ�ŕύX�ł��܂��B
P.srt_insertmode = 1

-- SRT�t�@�C���̕����G���R�[�f�B���O
-- "sjis" �� "utf8" �Ŏw��
-- ���������ǂ���ɂ��Ă��}���O�Ɉ�U Shift_JIS �ɕϊ�����܂�
P.srt_encoding = "utf8"

-- �����\��������
-- �b�Ŏw��
P.srt_margin = 0

-- �u���������v�̃G�C���A�X�t�@�C��(*.exa)���ǂ̂悤�ɎQ�Ƃ��邩
-- ���̐ݒ���g���ƁA�h���b�v���ꂽ *.srt �t�@�C���̖��O�ɉ����ĕʂ̃G�C���A�X�t�@�C�����g�p�ł��܂��B
-- �G�C���A�X�t�@�C���� `exa` �t�H���_�[�̒��ɔz�u���ĉ������B
-- �ȉ��̃��[���ŊY������t�@�C����������Ȃ��ꍇ�� srt.exa ������Ɏg�p����܂��B
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
P.srt_exafinder = 0

-- �G�C���A�X�t�@�C���̉��Ϗ���
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���
P.srt_examodifler = function(exa, values, modifiers)
  exa:set("vo", "start", values.START + 1)
  exa:set("vo", "end", values.END + 1)
  exa:delete("vo", "length")
  exa:set("vo", "group", 1)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.SUBTITLE))
end

-- srt_insertmode = 1 �̎��Ɏg�p�����u���������v�p�̐ړ����A�ڔ����A�G�X�P�[�v����
-- ��ʓI�ȗp�r�ł͕ύX����K�v�͂���܂���
P.srt_subtitle_prefix = '<?s=[==['
P.srt_subtitle_postfix = ']==];require("PSDToolKit").subtitle:set(s, obj, true);s=nil?>'
P.srt_subtitle_escape = function(s)
  return s:gsub("]==]", ']==].."]==]"..[==[')
end

-- ============================================================
-- Instant CTalk �Ɋւ���ݒ�
-- ��Instant CTalk �͎����I�ȋ@�\�Ȃ̂ŁA�����I�ɂ͑傫���ύX����邩������܂���
-- ============================================================

-- �������[�h
--   0 - ������ *.wav �t�@�C���h���b�v�Ƃ��ď�������
--   1 - ���p�N�����I�u�W�F�N�g����������B�����p�e�L�X�g���o�͂����ꍇ�͎����t�@�C�����쐬����
P.ictalk_firemode = 1

-- �t�@�C�����t�H�[�}�b�g
--   0 - ����ɂ���.wav
--   1 - 180116_172059_����ɂ���.wav
--   2 - �L������_����ɂ���.wav
--   3 - 180116_172059_�L������_����ɂ���.wav
P.ictalk_format = 3

return P