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
  
LOADSPRITES:
  lda SPRITEDATA,x
  sta $0200,x
  inx
  cpx #$20
  bne LOADSPRITES


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

  lda #%10000000 ;enable nmi change background to use second char set
  sta $2000  ;PPUCTRL ppu controll register
  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001




;
;program loop


  jsr DISPLAY_BACKGROUND



ldx #$00
ldy #$00

LOOP:
 jsr WAITVBLANK
txa
sta $0200
sta $0204
adc #$08
sta $0208
adc #$08
sta $020c

tya
sta $0203
adc #$08
sta $0207
sbc #$07
sta $020B
adc #$08
sta $020F

iny
inx

jmp LOOP


DISPLAY_BACKGROUND:


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
  

  cli

  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001
 

rts



test:
  lda #$3F
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta $2006 
  ldx $0000
  inx
  stx $0000
  lda $0000
  sta $2007 ; PPUDATA memory address to wright data to ppu (ppu puts this value in the adress defined in memory address from $2006) ppu auto increments memory address in $2006 on every wright in $2007
  lda #$26
  sta $2007
  lda #$27
  sta $2007
  lda #$28
  sta $2007
  cpx #$3f

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
  rti



PALLETEDATA:
  .byte $01,$2D,$3D,$30,$01,$36,$17,$0f,$01,$30,$21,$0f,$01,$27,$17,$0F  ;background palette data
  .byte $22,$16,$27,$18,$22,$16,$27,$18,$22,$16,$27,$18,$22,$16,$27,$18;sprite palette data

SPRITEDATA:
  .byte $09, $9a, $02, $00
  .byte $09, $9b, $02, $08
  .byte $11, $aa, $02, $00
  .byte $11, $ab, $02, $08
  .byte $19, $9c, $07, $00
  .byte $19, $9d, $07, $08
  .byte $21, $ac, $07, $00
  .byte $21, $ad, $07, $08

MAPDATA:
 .incbin "../resource/test.nam"


.segment "VECTORS"
    .word VBLANK
    .word RESET

.segment "CHARS"  
      .incbin "../resource/elementzones.chr"
      