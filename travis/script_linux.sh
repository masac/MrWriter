#!/bin/bash

set -x

source /opt/qt*/bin/qt*-env.sh
mkdir build
cd build
qmake CONFIG+=release ..
make -j$(nproc)
cp -R ../appdir .
make INSTALL_ROOT=appdir install ; find appdir/
wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export VERSION=$(git rev-parse --short HEAD) # linuxdeployqt uses this for naming the file
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -appimage

find appdir -executable -type f -exec ldd {} \; | grep " => /usr" | cut -d " " -f 2-3 | sort | uniq
curl --upload-file MrWriter*.AppImage https://transfer.sh/MrWriter-git.$(git rev-parse --short HEAD)-x86_64.AppImage && echo ""
# wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
# bash upload.sh MrWriter*.AppImage*


