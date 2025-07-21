# NES Fros Game - Detailed Memory Address Map

## Zero Page RAM ($0000-$00FF) - Variable Storage

| Address | Variable Name | Size | Module | Current Value/Usage | Notes |
|---------|---------------|------|--------|-------------------|-------|
| $0000-$000F | Local | 16 bytes | nes.asm | Reserved space | Local variable buffer |
| $0010 | counter | 1 byte | nes.asm | Incremented each frame | Frame counter |
| $0011 | XScroll | 1 byte | nes.asm | 0-255 | Horizontal scroll position |
| $0012 | YScroll | 1 byte | nes.asm | 0-255 | Vertical scroll position |
| $0013 | PPUControlStatus | 1 byte | nes.asm | Shadow of $2000 | PPU control shadow register |
| $0014 | PPUMask | 1 byte | nes.asm | Shadow of $2001 | PPU mask shadow register |
| $0015 | needdma | 1 byte | nes.asm | 0 or 1 | DMA flag (1=needs sprite DMA) |
| $0016 | needdraw | 1 byte | nes.asm | 0 or 1 | Drawing flag (1=needs PPU draw) |
| $0017 | needppureg | 1 byte | nes.asm | 0 or 1 | PPU register update flag |
| $0018 | sleeping | 1 byte | nes.asm | 0 or 1 | Frame sync flag (1=waiting) |
| $0019 | buttons | 1 byte | ButtonReading | Controller bits | Current button state |
| $001A | PRESSEDBUTTONS1 | 1 byte | ButtonReading | Button bits | Newly pressed buttons |
| $001B | RELEASEDBUTTONS1 | 1 byte | ButtonReading | Button bits | Newly released buttons |
| $001C | metaSpriteSlot | 1 byte | MetaSprite | 0-63 | Current sprite slot index |
| $001D | Mode | 1 byte | Game system | 0,1,2 | Game mode (0=Title, 1=Single, 2=Debug) |
| $001E | metaSpriteIndex | 1 byte | MetaSprite | Sprite index | Current sprite being processed |
| $001F | TotalSpriteLength | 1 byte | RenderEntities | 0-255 | Total sprites rendered this frame |

### Entity System Zero Page Variables
| Address | Variable Name | Size | Module | Current Value/Usage | Notes |
|---------|---------------|------|--------|-------------------|-------|
| $0020 | EntityArrayLength | 1 byte | LoadEntity | 0-32 | Number of active entities |
| $0021 | EmptySpace | 1 byte | LoadEntity | Array index | Gap management (unused) |
| $0022 | Length | 1 byte | LoadEntity | Byte offset | Entity loading working variable |
| $0023 | xpos | 1 byte | RunEntity | X position low | Entity X position low byte |
| $0024 | xpos+1 | 1 byte | RunEntity | X position high | Entity X position high byte |
| $0025 | ypos | 1 byte | RunEntity | Y position low | Entity Y position low byte |
| $0026 | ypos+1 | 1 byte | RunEntity | Y position high | Entity Y position high byte |
| $0027 | ModifyingCode | 1 byte | RunEntity | $20 (JSR) | Dynamic code byte 0 |
| $0028 | ModifyingCode+1 | 1 byte | RunEntity | AI addr low | Dynamic code byte 1 |
| $0029 | ModifyingCode+2 | 1 byte | RunEntity | AI addr high | Dynamic code byte 2 |
| $002A | ModifyingCode+3 | 1 byte | RunEntity | $60 (RTS) | Dynamic code byte 3 |
| $002B | Address | 1 byte | RunEntity | AI addr low | Entity AI address low byte |
| $002C | Address+1 | 1 byte | RunEntity | AI addr high | Entity AI address high byte |
| $002D | SelectedEntityIndex | 1 byte | RunEntity | 0-255 | Current entity being processed |

### Mode-Specific Zero Page Variables  
| Address | Variable Name | Size | Module | Current Value/Usage | Notes |
|---------|---------------|------|--------|-------------------|-------|
| $002E | Debug.Loaded | 1 byte | Debug.asm | 0 or 1 | Debug mode initialization flag |
| $002F | TitleScreen.Loaded | 1 byte | TitleScreen.asm | 0 or 1 | Title screen initialization flag |
| $0030 | TitleScreen.Options | 1 byte | TitleScreen.asm | Menu option | Selected menu option |
| $0031 | TitleScreen.Mode | 1 byte | TitleScreen.asm | Mode state | Title screen state |

### RenderEntities Local Variables
| Address | Variable Name | Size | Module | Current Value/Usage | Notes |
|---------|---------------|------|--------|-------------------|-------|
| $0032 | AnimationAddress | 1 byte | RenderEntities | Address low | Animation data pointer low |
| $0033 | @Length | 1 byte | RenderEntities | Loop counter | Render loop length |
| $0034 | @index | 1 byte | RenderEntities | Array index | Render loop index |

### Available Zero Page Space
| Address Range | Size | Status |
|---------------|------|--------|
| $0035-$00FF | 203 bytes | **FREE** - Available for expansion |

---

## System RAM ($0100-$07FF) - System Storage

### CPU Stack ($0100-$01FF)
| Address Range | Usage | Current Contents | Notes |
|---------------|-------|------------------|-------|
| $01FF | Stack top | Return addresses | Hardware stack (grows downward) |
| $01FE-$0180 | Active stack | Subroutine calls | Varies during execution |
| $0100-$017F | Deep stack | Nested calls | Used for deep call chains |

### OAM Sprite Buffer ($0200-$02FF)
| Address | Sprite# | Byte | Usage | Notes |
|---------|---------|------|-------|-------|
| $0200 | 0 | Y | Sprite Y position | First sprite Y coordinate |
| $0201 | 0 | Tile | Sprite tile ID | First sprite graphics |
| $0202 | 0 | Attr | Sprite attributes | Palette, flip, priority |
| $0203 | 0 | X | Sprite X position | First sprite X coordinate |
| $0204 | 1 | Y | Sprite Y position | Second sprite Y coordinate |
| ... | ... | ... | ... | Pattern continues |
| $02FC | 63 | Y | Last sprite Y | 64th sprite Y coordinate |
| $02FD | 63 | Tile | Last sprite tile | 64th sprite graphics |
| $02FE | 63 | Attr | Last sprite attr | 64th sprite attributes |
| $02FF | 63 | X | Last sprite X | 64th sprite X coordinate |

### Drawing Buffer ($0300-$03FF)
| Address Range | Usage | Current Contents | Notes |
|---------------|-------|------------------|-------|
| $0300-$03FF | Drawingbuf | PPU update data | Background/palette changes |

---

## Entity Array Storage ($0400-$04FF) - Entity Data

### Entity Array Structure (8 bytes per entity)
**Base Address: $0400**

| Entity | Address Range | Byte 0 | Byte 1 | Byte 2 | Byte 3 | Byte 4 | Byte 5 | Byte 6 | Byte 7 |
|--------|---------------|--------|--------|--------|--------|--------|--------|--------|--------|
| 0 | $0400-$0407 | ForeGround/Background | tileEntry | AIAddressLow | AIAddressHigh | XPositionLow | XPositionHigh | YPositionLow | YPositionHigh |
| 1 | $0408-$040F | ForeGround/Background | tileEntry | AIAddressLow | AIAddressHigh | XPositionLow | XPositionHigh | YPositionLow | YPositionHigh |
| 2 | $0410-$0417 | ForeGround/Background | tileEntry | AIAddressLow | AIAddressHigh | XPositionLow | XPositionHigh | YPositionLow | YPositionHigh |
| 3 | $0418-$041F | ForeGround/Background | tileEntry | AIAddressLow | AIAddressHigh | XPositionLow | XPositionHigh | YPositionLow | YPositionHigh |
| ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |
| 31 | $04F8-$04FF | ForeGround/Background | tileEntry | AIAddressLow | AIAddressHigh | XPositionLow | XPositionHigh | YPositionLow | YPositionHigh |

### Current Entity Values (Example with 3 loaded entities)
| Address | Entity | Field | Example Value | Hex | Notes |
|---------|--------|-------|---------------|-----|-------|
| $0400 | 0 | ForeGround/Background | %00000001 | $01 | Layer flags (foreground) |
| $0401 | 0 | tileEntry | Animation index | $03 | Tile/animation reference |
| $0402 | 0 | AIAddressLow | PLAYERPHYSICS low | $XX | AI function address low |
| $0403 | 0 | AIAddressHigh | PLAYERPHYSICS high | $XX | AI function address high |
| $0404 | 0 | XPositionLow | 0 | $00 | Initial X position low |
| $0405 | 0 | XPositionHigh | 0 | $00 | Initial X position high |
| $0406 | 0 | YPositionLow | 0 | $00 | Initial Y position low |
| $0407 | 0 | YPositionHigh | 0 | $00 | Initial Y position high |
| $0408 | 1 | ForeGround/Background | %00000001 | $01 | Layer flags (foreground) |
| $0409 | 1 | tileEntry | Animation index | $03 | Tile/animation reference |
| $040A | 1 | AIAddressLow | FLYPHYSICS low | $XX | AI function address low |
| $040B | 1 | AIAddressHigh | FLYPHYSICS high | $XX | AI function address high |
| $040C | 1 | XPositionLow | 0 | $00 | Initial X position low |
| $040D | 1 | XPositionHigh | 0 | $00 | Initial X position high |
| $040E | 1 | YPositionLow | 0 | $00 | Initial Y position low |
| $040F | 1 | YPositionHigh | 0 | $00 | Initial Y position high |

---

## ROM Memory ($8000-$FFFF) - Code and Data Storage

### PRG-ROM Bank 0 ($8000-$BFFF) - System Code
| Address Range | Function/Data | Size Est. | Content Description |
|---------------|---------------|-----------|---------------------|
| $8000-$801F | Header constants | 32B | JOYPAD1, PPUMASK, etc. definitions |
| $8020-$807F | System variables | 96B | Zero page variable definitions |
| $8080-$80FF | RESET routine | 128B | CPU initialization code |
| $8100-$817F | Memory clear | 128B | CLRMEM, CLEANPPU routines |
| $8180-$81FF | VBlank wait | 128B | WAITVBLANK routine |
| $8200-$827F | Main loop | 128B | LOOP, game mode dispatch |
| $8280-$82FF | Frame processing | 128B | DoFrame, WaitFrame |
| $8300-$83FF | NMI handler | 256B | VBlank interrupt processing |
| $8400-$847F | Input system | 128B | READCONTROLLER |
| $8480-$84FF | Button constants | 128B | AButton, BButton definitions |
| $8500-$BFFF | **Available** | ~14KB | Free space for expansion |

### PRG-ROM Bank 1 ($C000-$FFF9) - Game Logic  
| Address Range | Function/Data | Size Est. | Content Description |
|---------------|---------------|-----------|---------------------|
| $C000-$C1FF | TITLESCREEN | 512B | Title screen mode code |
| $C200-$C3FF | SINGLEPLAYER | 512B | Single player mode code |
| $C400-$C5FF | DEBUG | 512B | Debug mode code |
| $C600-$C7FF | LOADENTITIE | 512B | Entity loading system |
| $C800-$C9FF | RUNENTITYBEHAVIOUR | 512B | Entity AI processing |
| $CA00-$CBFF | RENDER | 512B | Entity rendering system |
| $CC00-$CDFF | Graphics system | 512B | LOAD_META_SPRITE, etc. |
| $CE00-$CFFF | Physics | 512B | playerPhysics, flyPhysics |
| $D000-$D0FF | GAMEMODES table | 256B | Jump table for modes |
| $D100-$D1FF | Button data | 256B | Button bit patterns |
| $D200-$D3FF | Entities list | 512B | Source entity definitions |
| $D400-$D5FF | Animations | 512B | Animation frame data |
| $D600-$D7FF | Metasprites | 512B | Sprite definitions |
| $D800-$D9FF | Backgrounds | 512B | Background data |
| $DA00-$DBFF | Math functions | 512B | Add.asm, Subtract.asm |
| $DC00-$FFF9 | **Available** | ~9KB | Free space for expansion |

### Interrupt Vectors ($FFFA-$FFFF)
| Address | Vector | Points To | Content |
|---------|--------|-----------|---------|
| $FFFA | NMI | ~$8300 | VBlank interrupt address |
| $FFFC | RESET | ~$8080 | Startup routine address |
| $FFFE | IRQ | ~$0000 | Unused interrupt (points to BRK) |

---

## CHR-ROM ($0000-$3FFF) - Graphics Data

### Pattern Table 0 ($0000-$0FFF) - Background Graphics
| Address Range | Tile Range | Content | Source File |
|---------------|------------|---------|-------------|
| $0000-$00FF | Tiles 0-15 | Platform tiles | PlatformSprites.chr |
| $0100-$01FF | Tiles 16-31 | Platform variations | PlatformSprites.chr |
| ... | ... | ... | ... |
| $0F00-$0FFF | Tiles 240-255 | Background elements | PlatformSprites.chr |

### Pattern Table 1 ($1000-$1FFF) - Sprite Graphics  
| Address Range | Tile Range | Content | Source File |
|---------------|------------|---------|-------------|
| $1000-$10FF | Tiles 0-15 | Player sprites | MovingSprites.chr |
| $1100-$11FF | Tiles 16-31 | Enemy sprites | MovingSprites.chr |
| ... | ... | ... | ... |
| $1F00-$1FFF | Tiles 240-255 | Effect sprites | MovingSprites.chr |

---

## Summary Tables

### Memory Usage by Region
| Region | Start | End | Total Size | Used | Free | Usage % |
|--------|-------|-----|------------|------|------|---------|
| Zero Page | $0000 | $00FF | 256B | ~53B | ~203B | 21% |
| System RAM | $0100 | $07FF | 1792B | ~768B | ~1KB | 43% |
| Entity Storage | $0400 | $04FF | 256B | Variable | Variable | Variable |
| PRG-ROM | $8000 | $FFFF | 32KB | ~10KB | ~22KB | 31% |
| CHR-ROM | $0000 | $3FFF | 8KB | 8KB | 0KB | 100% |

### Variable Access Speed by Location
| Location | Access Speed | Usage Recommendation |
|----------|-------------|---------------------|
| $00-$FF (Zero Page) | Fastest (3 cycles) | Most frequently used variables |
| $0100-$07FF (RAM) | Medium (4 cycles) | Arrays, buffers, less frequent data |
| $8000+ (ROM) | Medium (4 cycles) | Constants, lookup tables |

This detailed map shows exactly where every variable and value is stored in your NES program!
