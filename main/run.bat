@echo off
set /p myVar="file=Enter file: "

set input_file=parser.y
set TempFile=temp_parser__.txt
setlocal enabledelayedexpansion
set "ReplaceLine="
for /f "tokens=1 delims=:" %%A in ('findstr /n /c:"rog_code = fopen" "%input_file%"') do (
    set "ReplaceLine=%%A"
)
set /A ReplaceLine-=1

if exist "%TempFile%" del "%TempFile%"

if "%myVar"=="" (
    color CF
    echo.This program must be called with an argument!
    pause
    goto :eof
)

set /a line_count=1


< "%input_file%" (
    for /l %%N in (1,1,%ReplaceLine%) do (
        set /p line= || set "line="
        echo.!line!>> "%TempFile%"
    )
)

set /A ReplaceLine+=1

echo     rog_code = fopen("%myVar%", "r");>> "%TempFile%"
more +%ReplaceLine% < "%input_file%">> "%TempFile%"
copy /y "%TempFile%" "%input_file%"
del "%TempFile%"
endlocal

call compile.bat

call run_out.bat

goto :eof
