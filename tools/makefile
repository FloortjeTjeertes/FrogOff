asm = ca65
link = ld65
Title = game

target: 
	$(asm) ../code/nes.asm -o ../bin/$(Title).o -g -t nes 
	$(link) ../bin/$(Title).o -o ../bin/$(Title).nes -t nes --dbgfile ../bin/game.dbg
clean: 
	rm ../bin/$(Title).nes
	rm ../bin/$(Title).o
