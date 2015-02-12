@call setenv
@del src\%PACKAGE_PATH%\R.java
@del /q assets\*
@del /q bin\*
@del /q *.out
@rmdir /s /q lib
@md lib
@rmdir /s /q obj
@md obj
