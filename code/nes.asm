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

WAITVBLANK:
  BIT $2002 ;test if vblank is the same as address  2002 if negative flag is not high 
  BPL WAITVBLANK
  RTS

RESET:

  SEI          ; disable IRQs
  CLD          ; disable decimal mode
  LDX #$40
  STX $4017    ; disable APU frame IRQ
  LDX #$FF
  TXS          ; Set up stack
  INX          ; now X = 0
  STX $2000    ; disable NMI
  STX $2001    ; disable rendering
  STX $4010    ; disable DMC IRQs
  JSR WAITVBLANK


clrmem:
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FF
  STA $0200, x
  LDA #$00
  INX
  BNE clrmem
  ;vblank wait

  JSR WAITVBLANK

  CLEANSPRITEMEM:
  LDA #$02 select most significant bite





.segment "CODE"


; test
sta #$00
LOOP:

mycode:
adc #$01
sta $6001
lda $6001
iny
cpy #$25
BNE mycode

lda #$01
sta $6002
; endtest
    JMP LOOP


VBLANK:
 
  RTI

.segment "VECTORS"
    .word VBLANK
    .word RESET


.segment "CHARS"  