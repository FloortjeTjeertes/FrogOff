


@echo off

set outputname=game
set objfile=bin\%outputname%.o
set outnes=bin\%outputname%.nes
set OfileList=

REM Delete previous output files
del %objfile%
del %outnes%

REM Compile each assembly file in the "bin" folder
for %%f in (code\*.asm) do (
    echo Compiling "%%~nf.asm"
    
    "tools/ca65.exe" "%%~f" -o "bin\%%~nf.o" -t nes --debug-info
    if errorlevel 1 (
        echo Compilation failed.
        exit /b
    )

    REM Append the filename to the variable
    set OfileList=%OfileList% "bin\%%~nf.o"
    echo "bin\%%~nf.o" >> bin/tempfile.txt
)




echo tempfile.txt

REM Link the object files into an NES ROM
echo Linking "tools/ld65.exe" %OfileList% -o %outnes% -t nes --dbgfile bin\%outputname%.dbg

@REM make linking dynamic

@REM "tools/ld65.exe" %OfileList% -o %outnes% -t nes --dbgfile bin\%outputname%.dbg
"tools/ld65.exe" bin/nes.o bin/loadMetaSprite.o bin/loadBackground.o bin/TitleScreen.o  -o    bin/game.nes -t nes --dbgfile bin\game.dbg
if errorlevel 1 (
    echo Linking failed.
    REM Remove the temporary file
    DEL "tempfile.txt"
    exit /b
)

REM Run the NES ROM using the Mesen emulator
echo Running %outnes%
start "" "tools\Mesen.exe" %outnes% --debugger --trace

REM Cleanup: Delete the object file
del %objfile%
DEL "tempfile.txt"
