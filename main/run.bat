@echo off
set /p myVar="file=Enter file: "

set ReplaceLine=751
set /A ReplaceLine-=1
set input_file=parser.y
set TempFile=temp_parser__.txt

if exist "%TempFile%" del "%TempFile%"

if "%myVar"=="" (
    color CF
    echo.This program must be called with an argument!
    pause
    goto :eof
)

set /a line_count=1

setlocal enabledelayedexpansion

< "%input_file%" (
    for /l %%N in (1,1,%ReplaceLine%) do (
        set /p line= || set "line="
        echo.!line!>> "%TempFile%"
    )
)
endlocal

set /A ReplaceLine+=1

echo     rog_code = fopen("%myVar%", "r");>> "%TempFile%"
more +%ReplaceLine% < "%input_file%">> "%TempFile%"
copy /y "%TempFile%" "%input_file%"
del "%TempFile%"

call compile.bat

call run_out.bat

goto :eof
