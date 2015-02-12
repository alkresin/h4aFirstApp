@harbour jni\h4a_prg.prg -ic:\harbour\include -ojni\

@call setenv
@set NDK_LIBS_OUT=lib
%NDK_HOME%\prebuilt\windows\bin\make.exe -f %NDK_HOME%/build/core/build-local.mk %* >a1.out 2>a2.out