if not exist bin md bin
@call clear
@call ndkBuild
@if exist lib\%NDK_TARGET%\libharb4andr.so goto comp
@echo Errors while compiling C sources
@pause
@goto end

:comp
@call comp

:end