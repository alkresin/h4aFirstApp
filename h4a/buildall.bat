@call clear
@call ndkBuild
@if exist lib\armeabi\libharb4andr.so goto comp
@echo Errors while compiling C sources
@pause
@goto end

:comp
@call comp

:end