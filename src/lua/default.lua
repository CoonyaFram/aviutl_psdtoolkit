-- ============================================================
-- �����Ӂ�
-- ============================================================
--
-- ���̃t�@�C���ɂ͐ݒ�̃f�t�H���g�l�������Ă���܂����A
-- ����̓��[�U�[�����������邽�߂̃t�@�C���ł͂���܂���B
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- �ݒ��ύX���������͂��̃t�@�C��������������̂ł͂Ȃ��A
-- `setting.lua-template` �̃t�@�C������ `setting.lua` �ɕύX���A
-- `setting.lua` ���ɕK�v�Ȑݒ�݂̂��������ނ��ƂŐݒ肵�Ă��������B
--
-- ��L�̎菇�̒ʂ�ɍs�����ƂŁAPSDToolKit ���o�[�W�����A�b�v���鎞��
-- �ݒ肪�㏑�������̂�h�����Ƃ��ł��܂��B
--
-- �g�����̏ڂ�������͂�������Q�Ƃ��Ă��������B
-- https://github.com/oov/aviutl_psdtoolkit/wiki/Setting
--
-- ============================================================

local P = {}

P.wav_firemode = 0
P.wav_insertmode = 2
P.wav_uselab = true
P.wav_groupsubtitle = true
P.wav_subtitlemargin = 0
P.wav_subtitleencoding = "sjis"
P.wav_exafinder = 0
function P:wav_examodifler_wav(exa, values, modifiers)
  exa:set("ao", "start", 1)
  exa:set("ao", "end", values.WAV_LEN)
  exa:set("ao", "group", 1)
  exa:set("ao.0", "file", values.WAV_PATH)
end
function P:wav_examodifler_lipsync(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.WAV_LEN)
  exa:set("vo", "group", 1)
  exa:set("vo.0", "param", "file=" .. modifiers.ENCODE_LUA_STRING(values.LIPSYNC_PATH))
end
function P:wav_examodifler_subtitle(exa, values, modifiers)
  exa:set("vo", "start", 1)
  exa:set("vo", "end", values.SUBTITLE_LEN)
  exa:set("vo", "group", self.wav_groupsubtitle and 1 or 0)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.SUBTITLE))
end
function P:wav_subtitle_replacer(s) return s end
P.wav_subtitle_prefix = '<?s=[==['
function P:wav_subtitle_escape(s) return s:gsub(']==]', ']==].."]==]"..[==[') end
P.wav_subtitle_postfix = ']==];require("PSDToolKit").subtitle:set(s, obj, true);s=nil?>'

P.lab_exafinder = 0
function P:lab_examodifler(exa, values, modifiers)
  exa:set("vo", "start", values.START + 1)
  exa:set("vo", "end", values.END + 1)
  exa:set("vo", "group", 1)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.LIPSYNC))
end
P.lab_lipsync_prefix = '<?l='
function P:lab_lipsync_escape(s) return GCMZDrops.encodeluastring(s) end
P.lab_lipsync_postfix = ';require("PSDToolKit").talk:setphoneme(obj,l);l=nil?>'

P.srt_insertmode = 1
P.srt_encoding = "utf8"
P.srt_margin = 0
P.srt_exafinder = 0
function P:srt_examodifler(exa, values, modifiers)
  exa:set("vo", "start", values.START + 1)
  exa:set("vo", "end", values.END + 1)
  exa:set("vo", "group", 1)
  exa:set("vo.0", "text", modifiers.ENCODE_TEXT(values.SUBTITLE))
end
function P:srt_subtitle_replacer(s) return s end
P.srt_subtitle_prefix = '<?s=[==['
function P:srt_subtitle_escape(s) return s:gsub(']==]', ']==].."]==]"..[==[') end
P.srt_subtitle_postfix = ']==];require("PSDToolKit").subtitle:set(s, obj, true);s=nil?>'

P.ictalk_firemode = 1
P.ictalk_format = 3

return P