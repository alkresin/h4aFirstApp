#!/bin/bash

. ./h4a/setenv.sh

$ADB uninstall $PACKAGE
$ADB install bin/$APPNAME.apk

$ADB shell logcat -c
$ADB shell am start -n $PACKAGE/$PACKAGE.$MAIN_CLASS
$ADB shell logcat Harbour:I *:S > log.txt
#$ADB shell logcat  > log.txt

