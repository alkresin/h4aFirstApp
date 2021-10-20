#!/bin/bash
. ./setenv.sh

if ! [ -e bin ]; then
   mkdir bin
   chmod a+w+r+x bin
fi
if ! [ -e obj ]; then
   mkdir obj
   chmod a+w+r+x obj
fi
if ! [ -e lib ]; then
   mkdir lib
   chmod a+w+r+x lib
fi

./clear.sh
./ndkbuild.sh
if [ -f lib/$NDK_TARGET/libharb4andr.so ];
then
   ./comp.sh
else
   echo "Errors while compiling C sources"
   read -n1 -r -p "Press any key to continue..."
fi
