@call h4a\setenv

@rem reinstall and start APK on device
call %ADB% shell am start -n %PACKAGE%/%PACKAGE%.%MAIN_CLASS%
@pause

