@rem ���̉���
mkdir bin

@rem copy readme
copy /B /Y README.md bin\README.txt

@rem copy alias files
mkdir bin\PSDToolKit
copy /B /Y src\exa\NewObject.exa bin\PSDToolKit\PSDToolKit�I�u�W�F�N�g.exa
copy /B /Y src\exa\Render.exa bin\PSDToolKit\�I�u�W�F�N�g�`��.exa
copy /B /Y src\exa\SimpleView.exa bin\PSDToolKit\�V���v���r���[.exa
copy /B /Y src\exa\Blink.exa bin\PSDToolKit\�ڃp�`.exa
copy /B /Y src\exa\TalkDetector.exa bin\PSDToolKit\���p�N����.exa
copy /B /Y src\exa\LipSync.exa "bin\PSDToolKit\���p�N�@�J�̂�.exa"
copy /B /Y src\exa\LipSyncVowels.exa "bin\PSDToolKit\���p�N�@����������.exa"

@rem copy script files
mkdir bin\script
mkdir bin\script\PSDToolKit
copy /B /Y src\lua\PSDToolKitLib.lua bin\script\PSDToolKit\
copy /B /Y src\lua\@PSDToolKit.anm bin\script\PSDToolKit\
copy /B /Y src\lua\@PSDToolKit.obj bin\script\PSDToolKit\

@rem build src/go/assets/bindata.go
cd src/go/assets
go generate
cd ../../..

@rem build PSDToolKit.exe
cd src/go
go build -ldflags="-s" -o ../../bin/script/PSDToolKit/PSDToolKit.exe
cd ../../

@rem build lazarus projects
C:\lazarus\lazbuild.exe --build-all src/lazarus/auf.lpi src/lazarus/luadll.lpi
