@echo off
cd bin
..\7za.exe a -tzip ..\psdtoolkit.zip ^
  GCMZDrops.* GCMZDrops ^
  RelMovieHandle.* ^
  ZRamPreview.* ^
  ���񂵂��� ^
  �L���b�V���e�L�X�g.* ^
  AudioMixer.auf ^
  PSDToolKit.* PSDToolKit script ^
  PSDToolKit������.html PSDToolKitDocs
cd ..

cd bin_en
..\7za.exe a -tzip ..\psdtoolkit_enpatched.zip ^
  GCMZDrops.* GCMZDrops ^
  RelMovieHandle.* ^
  ZRamPreview.* ^
  ���񂵂��� ^
  �L���b�V���e�L�X�g.* ^
  AudioMixer.auf ^
  PSDToolKit.* PSDToolKit script ^
  PSDToolKit������.html PSDToolKitDocs
cd ..
