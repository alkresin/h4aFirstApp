#!/bin/bash

. ./setenv.sh

$HRB_BIN/harbour jni/h4a_prg.prg -i$HRB_INC -ojni/

export NDK_LIBS_OUT=lib
$NDK_HOME/prebuilt/linux-x86_64/bin/make -f $NDK_HOME/build/core/build-local.mk "$@" >a1.out 2>a2.out
