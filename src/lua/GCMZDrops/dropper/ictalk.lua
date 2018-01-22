local P = {}

P.name = "Instant CTalk"

-- �������[�h
--   0 - ������ *.wav �t�@�C���h���b�v�Ƃ��ď�������
--   1 - ���p�N�����I�u�W�F�N�g����������B�����p�e�L�X�g���o�͂����ꍇ�͎����t�@�C�����쐬����
P.firemode = 1

-- �t�@�C�����t�H�[�}�b�g
--   0 - ����ɂ���.wav
--   1 - 180116_172059_����ɂ���.wav
--   2 - �L������_����ɂ���.wav
--   3 - 180116_172059_�L������_����ɂ���.wav
P.format = 3

function P.oninitmenu()
  return "Instant CTalk"
end

function P.onselect(index, state)
  local ret = require("ICTalk").open({parent=state.parent, format=P.format})
  if (ret ~= nil)and(ret.files ~= nil)and(#ret.files > 0) then
    local wave
    for i, v in ipairs(ret.files) do
      -- �쐬�������ׂẴt�@�C���͏���������ɍ폜����悤�ɓo�^
      GCMZDrops.deleteonfinish(v)
      if v:match("[^.]+$"):lower() == "wav" then
        wave = v
      end
    end
    if wave ~= nil then
      -- wav �}�����̔������[�h����� 0 �ŏ㏑�����A
      -- �V�t�g�L�[�������Ȃ���h���b�v�������̂Ƃ��ē����邱�Ƃ� wav �}�������𔭓�������
      -- �܂� Instant CTalk ����o�͂����e�L�X�g�t�@�C���͏�� Shift_JIS �Ȃ̂ŁA���̐ݒ���㏑������
      state.shift = P.firemode == 1
      return {{filepath=wave, overridefiremode=0, overridetextencoding="sjis"}}, state
    end
  end
  return nil
end

return P
