-- ���̃t�@�C���� AviUtl �̃e�L�X�g�I�u�W�F�N�g��X�N���v�g����t�B���^��
-- require("PSDToolKit") ���������ɓǂݍ��܂��t�@�C��
-- ���̃t�@�C�����ǂݍ��܂��Ƃ������Ƃ͐������t�@�C�����ǂݍ��߂Ă��Ȃ��̂ŁA
-- ��U�L���b�V���𖳌������p�X��ʂ�����ŉ��߂ēǂݍ���
package.loaded["PSDToolKit"] = nil
local origpath = package.path
package.path = obj.getinfo("script_path") .. "PSDToolKit\\?.lua"
local p = require("PSDToolKit")
package.path = origpath
return p
