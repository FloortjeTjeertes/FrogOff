outputname = FrogOff
objfile = bin/$(outputname).o
outnes = bin/$(outputname).nes
OfileList = $(wildcard bin/*.o)

.PHONY: all clean run

all: $(outnes)

clean:
	rm -f $(objfile) $(outnes) bin/tempfile.txt

run: $(outnes)
	tools/Mesen $(outnes) --debugger --trace &

$(objfile): code/*.asm
	@echo "Compiling $(basename $(notdir $<)).asm"
	@tools/ca65 $< -o $@ -t nes --debug-info

$(outnes): $(OfileList)
	@echo "Linking $@"
	@tools/ld65 $(OfileList) -o $@ -t nes --dbgfile bin/$(outputname).dbg
	@echo "Running $@"
	@tools/Mesen $@ --debugger --trace &

