del ../bin/game.nes
ca65 ../code/nes.asm -o ../bin/game.o -t nes
ld65 ../bin/game.o -o ../bin/game.nes -t nes
del ../bin/game.o

