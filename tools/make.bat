


@echo off

set filename=nes
set outputname=game

del ..\bin\game.nes

echo %filename%

ca65.exe ../code/nes.asm -o ../bin/game.o -t nes --debug-info
if not errorlevel 1 (
    echo Compilation successful.
    ld65.exe ../bin/game.o -o ../bin/game.nes -t nes --dbgfile ../bin/game.dbg
    if not errorlevel 1 (
        echo Linking successful.
        mesen.exe ../bin/game.nes --debugger --trace
    ) else (
        echo Linking failed.
    )
) else (
    echo Compilation failed.
)

del ..\bin\game.o