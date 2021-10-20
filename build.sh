#!/bin/bash

. ./h4a/setenv.sh

if ! [ -e bin ]; then
   mkdir bin
   chmod a+w+r+x bin
fi
if ! [ -e h4a/assets ]; then
   mkdir h4a/assets
   chmod a+w+r+x h4a/assets
fi

rm -f h4a/assets/*
rm -f h4a/*.keystore
rm -f bin/*

$HRB_BIN/harbour source/testhrb.prg -gh -q -i$HRB_INC -oh4a/assets/
if [ "$?" -eq 0 ]
then
  cd h4a
  $BUILD_TOOLS/aapt package -f -M AndroidManifest.xml -S res -I $ANDROID_JAR -F ../bin/$APPNAME.unsigned.apk bin
  $BUILD_TOOLS/aapt add ../bin/$APPNAME.unsigned.apk lib/armeabi-v7a/libharbour.so

  if [ "$?" -eq 0 ]
  then
    $BUILD_TOOLS/aapt add ../bin/$APPNAME.unsigned.apk lib/armeabi-v7a/libharb4andr.so
    $BUILD_TOOLS/aapt add ../bin/$APPNAME.unsigned.apk assets/testhrb.hrb

    echo "sign APK"
    keytool -genkey -v -keystore myrelease.keystore -alias key2 -keyalg RSA -keysize 2048 -validity 10000 -storepass passkey1 -keypass passkey1 -dname "CN=Alex K, O=Harbour, C=RU"
    jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore myrelease.keystore -storepass passkey1 -keypass passkey1 -signedjar ../bin/$APPNAME.signed.apk ../bin/$APPNAME.unsigned.apk key2
    $BUILD_TOOLS/zipalign -v 4 ../bin/$APPNAME.signed.apk ../bin/$APPNAME.apk
  fi
fi
cd ../
read -n1 -r -p "Press any key to continue..."
