set filename=nes
set outputname=game


del ..\bin\game.nes
echo %filename%
ca65.exe ../code/nes.asm -o ../bin/game.o -t nes --debug-info
ld65.exe ../bin/game.o -o ../bin/game.nes -t nes --dbgfile ../bin/game.dbg

mesen.exe ../bin/game.nes --debugger --trace 

del ..\bin\game.o


