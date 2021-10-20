#!/bin/sh
. ./setenv.sh
rm -f src/$PACKAGE_PATH/R.java
rm -f assets/*
rm -f bin/*
rm -f *.out
rm -f -r lib
mkdir lib
chmod a+w+r+x lib
rm -f -r obj
mkdir obj
chmod a+w+r+x obj
