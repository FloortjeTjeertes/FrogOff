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
.segment "ZEROPAGE"

.segment "STARTUP"



RESET:

  sed          ; disable IRQs
  cld          ; disable decimal mode
  ldx #$40
  stx $4017    ; disable APU frame IRQ
  ldx #$FF
  txs          ; Set up stack
  inx          ; now X = 0
  stx $2000    ; disable NMI
  stx $2001    ; disable rendering
  stx $4010    ; disable DMC IRQs

  WAITVBLANK:
  BIT $2002 ;test if vblank is the same as address  2002 if negative flag is not high 
  BPL WAITVBLANK
  rts

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

  CLEANPPU:
  lda #$02 ;select most significant bite
  sta $4014 ;OAMDMA address
  nop
  rts
  

  lda #$3F
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$00
  sta $2006 ;store least significant value 00 in ppu write address ..00


.segment "CODE"


; program loop
LOOP:

mycode:
adc #$01
sta $6001
lda $6001
iny
cpy #$25
bne mycode

lda #$01
sta $6002
; endtest
jmp LOOP


VBLANK:
 
  rti

.segment "VECTORS"
    .word VBLANK
    .word RESET


.segment "CHARS"  