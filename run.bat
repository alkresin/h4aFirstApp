@call h4a\setenv

@rem reinstall and start APK on device
call %ADB% uninstall %PACKAGE%
call %ADB% install bin/%APPNAME%.apk

call %ADB% shell logcat -c
call %ADB% shell am start -n %PACKAGE%/%PACKAGE%.%MAIN_CLASS%
call %ADB% shell logcat Harbour:I *:S > log.txt

