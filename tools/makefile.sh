rm ../bin/game.nes
ca65 ../code/nes.asm -o ../bin/game.o -t nes
ld65 ../bin/game.o -o ../bin/game.nes -t nes
rm ../bin/game.o

ca65 ../blinktest.asm -o ../game.o -t nes
ld65 ../game.o -o ../game.nes -t nes
