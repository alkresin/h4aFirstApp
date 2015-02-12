@call setenv

@rem create R.java
call %BUILD_TOOLS%/aapt.exe package -f -m -S res -J src -M AndroidManifest.xml -I %ANDROID_JAR%
@if errorlevel 1 goto end

@rem compile, convert class dex and create APK
call %JAVA_HOME%/bin/javac -d obj -cp %ANDROID_JAR% -sourcepath src src/%PACKAGE_PATH%/*.java
@if errorlevel 1 goto end

call %BUILD_TOOLS%/dx.bat --dex --output=bin/classes.dex obj

:end
@pause
