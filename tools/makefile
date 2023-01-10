asm = ca65
link = ld65


target: 
	$(asm) ../code/nes.asm -o ../bin/game.o -t nes
	$(link) ../bin/game.o -o ../bin/game.nes -t nes
clean: 
	rm ../bin/game.nes
	rm ../bin/game.o
