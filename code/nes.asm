.segment "HEADER"
    .byte "NES";characters nes  gets converted to hex value $4E $45 $53
    .byte $1a  ;ms dos end of line character
    .byte $02  ;2 * 16KB PRG ROM
    .byte $01  ; 1 * 8KB CHR ROM
    .byte %00000000 ;flags Mapper, mirroring, battery, trainer
    .byte $00 ; Mapper, VS/Playchoice, NES 2.0
    .byte $00 ;PRG-RAM size 
    .byte %00000001 ;TV system
    .byte %00000001 ;TV system, PRG-RAM presence    
    .byte $00,$00,$00,$00,$00 ;filler bytes

.segment "STARTUP"
WAITVBLANK:
    BIT $2002
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
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FF
  STA $0200, x
  INX
  BNE clrmem

 
  ;vblank wait

  JSR WAITVBLANK


.segment "ZEROPAGE"
flag: .res 1
counter: .res 1

.segment "CODE"








GAMELOOP:

; test

MYCODE:
adc #$01
sta $6001
lda $6001
iny
cpy #$25
BNE MYCODE

lda #$01
sta $6002
; endtest

ENDOFLOOP:

VBLANK:
 
  RTI

.segment "VECTORS"
    .word VBLANK
    .word RESET
    .word 0

.segment "CHARS"  