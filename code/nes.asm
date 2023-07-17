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

; .include "loadMetaSprite.asm"



.zeropage

buttons: .res 1 ; 1 byte for buttons
counter: .res 1 
ram: .res 1

; metaSpriteIndex: .res 1
; metaSpriteSlot: .res 1
.importzp metaSpriteSlot
.importzp metaSpriteIndex


; /test
SpriteCounter: .res 1 



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
  stx $2000    ; disable NMI
  stx $2001    ; disable rendering
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
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta $2006 ;store least significant value 00 in ppu write address ..00

  ldx #$00

LOADPALETTES:
  lda PALLETEDATA, x
  sta $2007 ; PPUDATA memory address to wright data to ppu (ppu puts this value in the adress defined in memory address from $2006) ppu auto increments memory address in $2006 on every wright in $2007
  inx 
  cpx #$20
  bne LOADPALETTES

  ldx #$00
  


  jsr LOADSPRITES





LOADBACKGROUND:

  lda #$20    ;load 20 into acumulator
  sta $2006   ;stores most significant byte in ppu
  lda #$00   ;stores least sugnificant byte in acumulator 
  sta $2006   ;stores least significant byte in ppu

  ldx #$00   ;load x with 0

  :
    txa       ;transfer x to acumulator
    sta $2007 ;stores acumulator in ppu address 2007
    inx
    cpx #$CE ;compare x with 255
  bne :-


;enable interupts
  cli

  lda #%10001000 ;enable nmi change background to use second char set
  sta $2000  ;PPUCTRL ppu controll register
  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001



.segment "CODE"

.import LOAD_META_SPRITE


;program loop
  jsr DISPLAYBACKGROUND
; clear c and y
  ldx #$00
  ldy #$00


  

LOOP:

 

  jsr CHECKBUTTONS

  
jmp LOOP

CHECKBUTTONS:
  lda DOWN 
  and buttons
  cmp DOWN
  beq MOVEDOWN

  lda UP
  and buttons
  cmp UP
  beq MOVEUP

  lda LEFT 
  and buttons
  cmp LEFT
  beq MOVELEFT

  lda RIGHT 
  and buttons
  cmp RIGHT
  beq MOVERIGHT

  lda AButton
  and buttons
  cmp AButton
  beq ABUTTON


  rts

ABUTTON:
 jsr WAITVBLANK
 jsr NextMetaSPrite
  ; lda #$01
  ; sta metaSpriteIndex
  ; jsr LOAD_META_SPRITE
rts

MOVEDOWN:
  iny
  jmp MOVE

MOVEUP:
  dey
  jmp MOVE

MOVERIGHT:
  inx
  jmp MOVE

MOVELEFT:
  dex
  jmp MOVE

MOVE:
  jsr MOVEBLOCK

  jsr WAITVBLANK

rts

; test code for meta sprites
NextMetaSPrite:
  ; ldx SpriteCounter
  ; cpx tablelength
  ; beq @l
  ;  inx  
  ;  jmp @l2
  ; @l:
  ;  ldx #$0
  ; @l2:
  ; stx SpriteCounter
  ; txa

  ; sta  metaSpriteIndex
  ; jsr LOAD_META_SPRITE
rts



; .include "loadMetaSprite.asm"

LOADSPRITES:
  lda #$00 
  sta metaSpriteIndex
  lda #$00
  sta metaSpriteSlot
  jsr LOAD_META_SPRITE   ; Initialize meta sprites

  lda #$02 
  sta metaSpriteIndex
  lda #$01
  sta metaSpriteSlot
  jsr LOAD_META_SPRITE 

rts


MOVEBLOCK:  ;move  the block sprite  (change it later to work whit any character that needs to be moved)

  tya
  sta $0200
  sta $0204
  adc #$07
  sta $0208
  sta $020c


  txa
  sta $0203
  sta $020B
  adc #$08
  sta $0207
  sta $020F


rts

DISPLAYBACKGROUND:


  lda #%00000000   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001
  sei

  lda #$28
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$C0
  sta $2006 ;store least significant value 00 in ppu write address ..00

  ldx #$00
  

  lda #$20    ; load the value 32 into the accumulator
  sta $2006   ; store the most significant byte in the PPU write address (0x2006)
  lda #$00    ; load the value 0 into the accumulator
  sta $2006   ; store the least significant byte in the PPU write address (0x2006)
  
  ldx #$00    ; load the value 0 into the X register

  
  :
  lda MAPDATA,x   ; load the value at the address stored in X and Y into the accumulator
  sta $2007   ; store the value in the PPU data register (0x2007)
  inx         ; increment the X register
  cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-

 ldx #$00    ; load the value 0 into the X register


  :
  lda MAPDATA+255,x   ; load the value at the address stored in X and Y into the accumulator
  sta $2007   ; store the value in the PPU data register (0x2007)
  inx         ; increment the X register
  cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
   
 ldx #$00    ; load the value 0 into the X register

  :
  lda MAPDATA+510,x   ; load the value at the address stored in X and Y into the accumulator
  sta $2007   ; store the value in the PPU data register (0x2007)
  inx         ; increment the X register
  cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
  ldx #$00    ; load the value 0 into the X register
   :
  lda MAPDATA+765,x   ; load the value at the address stored in X and Y into the accumulator
  sta $2007   ; store the value in the PPU data register (0x2007)
  inx         ; increment the X register
  cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
  
  ldx #$00    ; load the value 0 into the X register
    :
  lda MAPDATA+1020,x   ; load the value at the address stored in X and Y into the accumulator
  sta $2007   ; store the value in the PPU data register (0x2007)
  inx         ; increment the X register
  cpx #$05 ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
 

  cli

  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001
 

rts

BACKGROUNDFLICKER:
  lda #$3F
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta $2006 
  ldx ram
  inx
  stx ram
  lda ram
  sta $2007 ; PPUDATA memory address to wright data to ppu (ppu puts this value in the adress defined in memory address from $2006) ppu auto increments memory address in $2006 on every wright in $2007
  lda #$26
  sta $2007
  lda #$27
  sta $2007
  lda #$28
  sta $2007
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
  

WAITVBLANK:
  BIT $2002 ;test if vblank is the same as address  2002 if negative flag is not high 
  BPL WAITVBLANK

  rts


VBLANK: ;nmi or vblank what happens in the vblank
  LDA #$02 ;copy sprite data from 0200 -> ppu memory for display
  sta $4014
  jsr READCONTROLLER

rti



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




PALLETEDATA:
  .byte $00,$00,$10,$20,$07,$16,$25,$30,$00,$21,$31,$30,$00,$27,$06,$00  ;background palette data
  .byte $1F,$09,$29,$3A,$1F,$08,$09,$0D,$22,$16,$27,$18,$22,$16,$27,$18;sprite palette data


MAPDATA:
 .incbin "../resource/test.nam"


.segment "VECTORS"
    .word VBLANK
    .word RESET

.segment "CHARS"  
      .incbin "../resource/PlatformSprites.chr"
      .incbin "../resource/MovingSprites.chr"
