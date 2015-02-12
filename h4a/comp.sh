#!/bin/bash
. ./setenv.sh

$BUILD_TOOLS/aapt package -f -m -S res -J src -M AndroidManifest.xml -I $ANDROID_JAR
if [ "$?" -eq 0 ]
then
  echo "compile java sources"
  javac -d obj -cp $ANDROID_JAR -sourcepath src src/$PACKAGE_PATH/*.java
  if [ "$?" -eq 0 ]
  then
    echo "convert to .dex"
    $BUILD_TOOLS/dx --dex --output=bin/classes.dex obj
  else
    echo "java sources compiling error"
  fi
else
  echo "R.java creating error"
fi
read -n1 -r -p "Press any key to continue..."
