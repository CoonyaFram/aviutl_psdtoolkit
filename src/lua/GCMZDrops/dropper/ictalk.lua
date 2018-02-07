local P = {}

P.name = "Instant CTalk"

local wavP = require("psdtoolkit_wav")

function P.oninitmenu()
  return "Instant CTalk"
end

function P.onselect(index, state)
  local setting = wavP.loadsetting()
  local ret = require("ICTalk").open({parent=state.parent, format=setting.ictalk_format})
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
      state.shift = setting.ictalk_firemode == 1
      return {{filepath=wave, overridefiremode=0, overridesubtitleencoding="sjis"}}, state
    end
  end
  return nil
end

return P
