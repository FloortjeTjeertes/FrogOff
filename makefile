outputname = FrogOff
objdir = bin
outnes = $(objdir)/$(outputname).nes
OfileList = $(wildcard $(objdir)/*.o)
asmSources = $(shell find code -name '*.asm')
objFiles = $(patsubst code/%.asm,$(objdir)/%.o,$(asmSources))

.PHONY: all clean run

all: $(outnes)

clean:
	rm -f $(objFiles) $(outnes) $(objdir)/tempfile.txt

run: $(outnes)
	tools/Mesen $(outnes) --debugger --trace &

$(objdir)/%.o: code/%.asm
	@echo "Compiling $(notdir $<)"
	@mkdir -p $(dir $@)
	@tools/ca65 $< -o $@ -t nes --debug-info

$(outnes): $(objFiles)
	@echo "Linking $@"
	@tools/ld65 $(objFiles) -o $@ -t nes --dbgfile $(objdir)/$(outputname).dbg
	@echo "Running $@"
	@tools/Mesen $@ --debugger --trace &
