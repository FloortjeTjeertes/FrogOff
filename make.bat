@echo off
setlocal EnableDelayedExpansion

set outputname=FrogOff
set outnes=bin\%outputname%.nes
set "OfileList="

if not exist "bin" mkdir bin

del /q "bin\*.o" 2>nul
del /q "%outnes%" 2>nul
del /q "bin\tempfile.txt" 2>nul

for /r "code" %%f in (*.asm) do (
    echo %%~dpF | findstr /I /C:"\notImplementedYet\" >nul
    if not errorlevel 1 (
        echo Skipping unfinished file "%%~nf.asm"
    ) else (
        echo Compiling "%%~nf.asm"
        "tools\ca65.exe" "%%~f" -o "bin\%%~nf.o" -t nes --debug-info
        if errorlevel 1 (
            echo Compilation failed.
            del /q "bin\*.o" 2>nul
            exit /b 1
        )

        set "OfileList=!OfileList! "bin\%%~nf.o""
        echo "bin\%%~nf.o" >> bin\tempfile.txt
    )
)

echo Linking "tools\ld65.exe" %OfileList% -o %outnes% -t nes --dbgfile bin\%outputname%.dbg
"tools\ld65.exe" %OfileList% -o %outnes% -t nes --dbgfile bin\%outputname%.dbg
if errorlevel 1 (
    echo Linking failed.
    del /q "bin\tempfile.txt" 2>nul
    exit /b 1
)

echo Running %outnes%
start "" "tools\Mesen.exe" %outnes% --debugger --trace

del /q "bin\*.o"
