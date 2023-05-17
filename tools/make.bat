set filename=nes
set outputname=game


del ..\bin\game.nes
echo %filename%
ca65 ../code/nes.asm -o  ../bin/game.o -t nes --debug-info -d
ld65 ../bin/game.o -o ../bin/game.nes -t nes --dbgfile ../bin/game.deb

del ..\bin\nes.o


