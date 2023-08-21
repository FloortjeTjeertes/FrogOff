.segment "HEADER"
    .byte "NES";characters nes  gets converted to hex value $4E $45 $53
    .byte $1A  ;ms dos end of line character
    .byte $02  ;2 * 16KB PRG ROM
    .byte $01  ; 1 * 8KB CHR ROM
    .byte %00000000 ;flags Mapper, mirroring, battery, trainer
    .byte $00 ; Mapper, VS/Playchoice, NES 2.0
    .byte $00 ;PRG-RAM size 
    .byte $00 ;TV system
    .byte $00 ;TV system, PRG-RAM presence   
    .byte $46, $52,$31,$4C,$59




JOYPAD1 = $4016
JOYPAD2 = $4017
CONTROLLER =$2000
PPUMASK = $2001
PPUSTATUS = $2002
OAMADDR = $2003
OAMDATA = $2004
PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007
Oam = $0200
Drawingbuf = $0300   

 
; .include "loadMetaSprite.asm"

 

.zeropage
 
 .globalzp buttons , PPUMask ,PPUControlStatus, XScroll, YScroll      

  ;reserving space for local vars should do this in the linker cfg but eh
  Local: .res 16
 .importzp metaSpriteSlot
 .importzp Mode
 .importzp metaSpriteIndex
 ;buttons imported from ButtonReading.asm
 .importzp PRESSEDBUTTONS1 ,RELEASEDBUTTONS1
  counter: .res 1 
  XScroll: .res 1
  YScroll: .res 1
  PPUControlStatus: .res 1 ;shadow of PPUCTRL (soft $2000)
  PPUMask:          .res 1 ;shadow of PPUMASK (soft $2001)
  needdma:          .res 1
  needdraw:         .res 1     
  needppureg:       .res 1   
  sleeping:         .res 1
.segment "STARTUP"


jsr WAITVBLANK

jsr CLEANPPU

RESET:
  sei          ; disable IRQs
  cld          ; disable decimal mode
  ldx #$40
  stx $4017    ; disable APU frame IRQ
  ldx #$FF
  txs          ; Set up stack
  inx          ; now X = 0
  stx CONTROLLER    ; disable NMI
  stx PPUMASK    ; disable rendering
  stx $4010    ; disable DMC IRQs
  
  lda #$00    ;store 0 in acumulator to clear counter
  sta counter ;store acumulator in counter (should be 0)

  jsr WAITVBLANK
 

CLRMEM:
  sta $0000, x
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$FF
  sta $0200, x
  lda #$00
  inx
  bne CLRMEM
  ;vblank wait


  jsr WAITVBLANK

  jsr CLEANPPU

  

  lda #$3F
  sta PPUADDR ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta PPUADDR ;store least significant value 00 in ppu write address ..00

  ldx #$00  

  lda #%10001000 ;enable nmi change background to use first char set
  sta CONTROLLER  ;PPUCTRL ppu controll register
  sta PPUControlStatus ;shadow of PPUCTRL (soft $2000)
  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta PPUMASK
  sta PPUMask ;shadow of PPUMASK (soft $2001)



.segment "CODE"



;program loop

; clear c and y
  ldx #$00
  ldy #$00

;set game in mode 0 (title screen)

lda #$00
sta Mode

LOOP:

  lda Mode
  cmp #$00
  bne :+
   jsr TITLESCREEN
  :
  lda Mode
  cmp #$01
  bne :+
    jsr SINGLEPLAYER
  :
  cmp #$02
  bne :+
    jsr DEBUG
  :

  jsr DoFrame
jmp LOOP



.import LOAD_META_SPRITE

.import LOADBACKGROUND

.import TITLESCREEN

.import SINGLEPLAYER

.import DEBUG

.import READCONTROLLER



CLEANPPU:
  lda #$02 ;select most significant bite
  sta $4014 ;OAMDMA address
  nop
rts
WAITVBLANK:
  BIT PPUSTATUS ;test if vblank is the same as address  2002 if negative flag is not high 
  BPL WAITVBLANK

rts

WaitFrame:
  inc sleeping
    @loop:
      lda sleeping
      bne @loop
rts

DoFrame:
     lda #1
     sta needdraw
     sta needdma
     sta needppureg
     jsr WaitFrame
     jsr READCONTROLLER
     inc counter
rts

; DoDrawing:

;   lda #$0300,x
;   sta PPUDATA,x
;   jmp DoDrawing

; rts

NMI: ;nmi or vblank what happens in the vblank


     pha         
     txa
     pha
     tya
     pha

     lda needdma
     beq :+
       lda #0      ; do sprite DMA
       sta $2003   ; conditional via the 'needdma' flag
       lda #>Oam
       sta $4014

  :  lda needdraw       ; do other PPU drawing (NT/Palette/whathaveyou)
     beq :+             ;  conditional via the 'needdraw' flag
       bit $2002        ; clear VBl flag, reset $2005/$2006 toggle
       ;jsr DoDrawing    ; draw the stuff from the drawing buffer
       dec needdraw

  :  lda needppureg
     beq :+
       lda PPUMask   ; copy buffered $2000/$2001 (conditional via needppureg)
       sta $2001
       lda PPUControlStatus
       sta $2000


       bit $2002
       lda XScroll    ; set X/Y scroll (conditional via needppureg)
       sta $2005
       lda YScroll
       sta $2005



   :
   ;music engine can go here

   
   lda #0         ; clear the sleeping flag so that WaitFrame will exit
   sta sleeping

     pla            ; restore regs and exit
     tay
     pla
     tax
     pla
     
rti




SELECTGAMEMODE:
       asl A
       tax
       lda GAMEMODES+1,x
       pha
       lda GAMEMODES,x
       pha
rts
GAMEMODES:
  .word TITLESCREEN-1 , SINGLEPLAYER-1, DEBUG-1

.global AButton, BButton, SELECT, START, UP, DOWN, LEFT, RIGHT
AButton:
 .byte %10000000
BButton:
 .byte %01000000
SELECT: 
 .byte %00100000
START:  
 .byte %00010000
UP:     
 .byte %00001000
DOWN:   
 .byte %00000100
LEFT:   
 .byte %00000010
RIGHT:  
 .byte %00000001






.segment "VECTORS"
    .word NMI
    .word RESET
.segment "CHARS"  
      .incbin "../resource/Tiles/PlatformSprites.chr"
      .incbin "../resource/Tiles/MovingSprites.chr"
