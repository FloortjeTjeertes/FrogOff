.segment "HEADER"
    .byte "NES"
    .byte $1a
    .byte $02
    .byte $01
    ; .byte %00000000
    ; .byte $00
    ; .byte $00
    ; .byte $00
    ; .byte $00
    ; .byte $00,$00,$00,$00,$00

.segment "STARTUP"
.segment "ZEROPAGE"
flag: .res 1
counter: .res 1

.segment "CODE"

WAITVBLANK:
:
    BIT $2002
    BPL :-
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
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE clrmem

  LDA #%10001000
  STA flag
   
  JSR WAITVBLANK




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