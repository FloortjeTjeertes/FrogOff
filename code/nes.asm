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

; .include "loadMetaSprite.asm"



.zeropage
 .importzp metaSpriteSlot
 .importzp Mode
 .importzp metaSpriteIndex
 .globalzp buttons , RenderStatus ,PPUControlStatus

  buttons: .res 1 ; 1 byte for buttons
  counter: .res 1 
  ; XScroll: .res 1
  ; YScroll: .res 1
  PPUControlStatus: .res 1 ;shadow of PPUCTRL
  RenderStatus: .res 1 ;shadow of PPUMASK
  ram: .res 1


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

  lda #%10001000 ;enable nmi change background to use second char set
  sta CONTROLLER  ;PPUCTRL ppu controll register
  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta PPUMASK



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


  
jmp LOOP



.import LOAD_META_SPRITE

.import LOADBACKGROUND

.import TITLESCREEN

.import SINGLEPLAYER

.import DEBUG



; test code for meta sprites
; FlyAnimate:
;   lda counter 
;   and #$07
;   cmp #$00
;   beq :+

;   lda #$03 
;   sta metaSpriteIndex
;   lda #$02
;   sta metaSpriteSlot
;   jsr LOAD_META_SPRITE   ; Initialize meta sprites
;   jmp @END
;   :

;     lda #$04 
;     sta metaSpriteIndex
;     lda #$02
;     sta metaSpriteSlot
;   jsr LOAD_META_SPRITE   ; Initialize meta sprites
  
;   @END:
   
; rts
BACKGROUNDFLICKER:
  lda #$3F
  sta PPUADDR ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta PPUADDR 
  ldx ram
  inx
  stx ram
  lda ram
  sta PPUDATA ; PPUDATA memory address to wright data to ppu (ppu puts this value in the adress defined in memory address from PPUADDR) ppu auto increments memory address in PPUADDR on every wright in PPUDATA
  lda #$26
  sta PPUDATA
  lda #$27
  sta PPUDATA
  lda #$28
  sta PPUDATA
  cpx #$3f

rts
;shifts 1 every loop until 8 bits are shifted from the nes controller
;the status of the controller is stored every loop in the buttons
READCONTROLLER: 
    lda #$01 
    sta JOYPAD1 ;write 1 to joypad 1
    sta buttons ;write 1 to buttons
    lsr a   ; shifts 1 out of acumulator to make acumulator 0
    sta JOYPAD1 ;write aculumator (0) to joypad 1 (clears strobe bit and controller will keep stored value (pressed buttons) static
    :                                                                    
      lda JOYPAD1 ;read joypad 1 into acumulator                           
      lsr a ;shift left shifts red byte to form a full 8 bits of the read controller                                                
      rol buttons ;shift left to eventually put 1 in carry (looping trough all bits in the buttons variable)      
    bcc :- ;branch to last ":" if carry flag is not set
rts
CLEANPPU:
  lda #$02 ;select most significant bite
  sta $4014 ;OAMDMA address
  nop
rts
WAITVBLANK:
  BIT PPUSTATUS ;test if vblank is the same as address  2002 if negative flag is not high 
  BPL WAITVBLANK

rts
NMI: ;nmi or vblank what happens in the vblank

  lda #$02 ;copy sprite data from 0200 -> ppu memory for display
  sta $4014

  lda RenderStatus
  sta PPUMASK ;enable/disable rendering

  jsr READCONTROLLER
  ; jsr FlyAnimate
  inc counter
  
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
