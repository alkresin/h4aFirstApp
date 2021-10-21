if not exist bin md bin
if not exist h4a\assets md h4a\assets
@call h4a/setenv

@del /q h4a\assets\*.*
@del /q h4a\*.keystore
@del /s /f /q bin\*.*

@harbour source\testhrb.prg /gh /q /i%HRB_INC% /oh4a\assets\
@if errorlevel 1 goto end

@cd h4a
call %BUILD_TOOLS%/aapt.exe package -f -M AndroidManifest.xml -S res -I %ANDROID_JAR% -F ../bin/%APPNAME%.unsigned.apk bin
call %BUILD_TOOLS%/aapt.exe add ../bin/%APPNAME%.unsigned.apk lib/%NDK_TARGET%/libharbour.so
@if errorlevel 1 goto end
call %BUILD_TOOLS%/aapt.exe add ../bin/%APPNAME%.unsigned.apk lib/%NDK_TARGET%/libharb4andr.so
call %BUILD_TOOLS%/aapt.exe add ../bin/%APPNAME%.unsigned.apk assets/testhrb.hrb

@rem sign APK
call %JAVA_HOME%/bin/keytool -genkey -v -keystore myrelease.keystore -alias key2 -keyalg RSA -keysize 2048 -validity 10000 -storepass passkey1 -keypass passkey1 -dname "CN=Alex K, O=Harbour, C=RU"
call %JAVA_HOME%/bin/jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore myrelease.keystore -storepass passkey1 -keypass passkey1 -signedjar ../bin/%APPNAME%.signed.apk ../bin/%APPNAME%.unsigned.apk key2
%BUILD_TOOLS%/zipalign -v 4 ../bin/%APPNAME%.signed.apk ../bin/%APPNAME%.apk
:end
@cd ../
@pause
