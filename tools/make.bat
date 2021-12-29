set filename=nes
set outputName=game

if exist ../bin/%outputName%.nes del ../bin/%outputName%.nes
ca65 ../code/%filename%.asm -o ../bin/%filename%.o -t nes --debug-info
ld65 ../bin/%filename%.o -o ../bin/%outputName%.nes -t nes 
sim65 ../bin/%filename%.o
if exist ..\bin\game.o del ..\bin\game.o
if exist ..\bin\game.nes  ..\bin\game.nes

