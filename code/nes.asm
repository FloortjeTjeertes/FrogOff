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

  lda #$20
  sta $2006 
  lda #$00
  sta $2006 

  ldx #$00

:
  txa 
  sta $2007
  inx
  cpx #$FF
  bne :-

  

;enable interupts
  cli

  lda #%10010000 ;enable nmi change background to use second char set
  sta $2000  ;PPUCTRL ppu controll register
  lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
  sta $2001

;program loop
LOOP:
lda $00
sta $1800


lda $01
sta $1800
jsr do_action

jmp LOOP

;test loop
Loopy:
nop
rts

do_action:
       asl $1800
       tax
       lda TABLE+1,x
       pha
       lda TABLE,x
       pha
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

TABLE: ;jmptable
  .word Loopy-1 ;

PALLETEDATA:
  .byte $22,$29,$1A,$0F,$22,$36,$17,$0f,$22,$30,$21,$0f,$22,$27,$17,$0F  ;background palette data
  .byte $22,$16,$27,$18,$22,$1A,$30,$27,$22,$16,$30,$27,$22,$0F,$36,$17  ;sprite palette data

SPRITEDATA:
  .byte $08, $00, $00, $08
  .byte $08, $01, $00, $10
  .byte $10, $02, $00, $08
  .byte $10, $03, $00, $10
  .byte $18, $04, $00, $08
  .byte $18, $05, $00, $10
  .byte $20, $06, $00, $08
  .byte $20, $07, $00, $10

.segment "VECTORS"
    .word VBLANK
    .word RESET

.segment "CHARS"  
      .incbin "../resource/hellomario.chr"