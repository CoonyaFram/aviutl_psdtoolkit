@echo off
cd bin
..\7za.exe a -tzip ..\psdtoolkit.zip ^
  GCMZDrops.* GCMZDrops ^
  RelMovieHandle.* ^
  ZRamPreview.* ^
  ���񂵂��� ^
  AudioMixer.auf ^
  PSDToolKit.* PSDToolKit script ^
  PSDToolKit������.html PSDToolKitDocs
cd ..
