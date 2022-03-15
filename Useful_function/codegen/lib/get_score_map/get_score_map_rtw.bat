@echo off

@if not "%MINGW_ROOT%" == "" (@set "PATH=%PATH%;%MINGW_ROOT%")

cd .

if "%1"=="" ("D:\MATLAB\bin\win64\gmake"  -f get_score_map_rtw.mk all) else ("D:\MATLAB\bin\win64\gmake"  -f get_score_map_rtw.mk %1)
@if errorlevel 1 goto error_exit

exit 0

:error_exit
echo The make command returned an error of %errorlevel%
exit 1