set filename=nes
set outputname=game


del .\bin\game.nes
echo %filename%
ca65 ./code/nes.asm -o ./bin/nes.o -t nes --debug-info
ld65 ./bin/nes.o -o ./bin/game.nes -t nes --dbgfile ./bin/game.dbg

del .\bin\nes.o


