.export LOGINPUT

.import PRESSEDBUTTONS1

; PPU addresses for displaying debug info
PPUADDR = $2006
PPUDATA = $2007

.proc LOGINPUT
.zeropage
    @tempValue: .res 1

.segment "CODE"
    ; This routine displays the current input state on screen
    ; You can call this from your debug mode
    
    ; Wait for VBlank before writing to PPU
    lda needdma
    cmp #$01
    beq @exit  ; Skip if we're in the middle of DMA
    
    ; Set PPU address for debug display (top-right corner)
    lda #$20
    sta PPUADDR
    lda #$1C    ; Position $201C (top right area)
    sta PPUADDR
    
    ; Display each button state as characters
    lda PRESSEDBUTTONS1
    sta @tempValue
    
    ; Check A button (bit 7)
    lda @tempValue
    and #%10000000
    beq @notA
    lda #$41    ; ASCII 'A'
    jmp @writeA
@notA:
    lda #$2D    ; ASCII '-'
@writeA:
    sta PPUDATA
    
    ; Check B button (bit 6)
    lda @tempValue
    and #%01000000
    beq @notB
    lda #$42    ; ASCII 'B'
    jmp @writeB
@notB:
    lda #$2D    ; ASCII '-'
@writeB:
    sta PPUDATA
    
    ; Check Select button (bit 5)
    lda @tempValue
    and #%00100000
    beq @notSelect
    lda #$53    ; ASCII 'S'
    jmp @writeSelect
@notSelect:
    lda #$2D    ; ASCII '-'
@writeSelect:
    sta PPUDATA
    
    ; Check Start button (bit 4)
    lda @tempValue
    and #%00010000
    beq @notStart
    lda #$54    ; ASCII 'T'
    jmp @writeStart
@notStart:
    lda #$2D    ; ASCII '-'
@writeStart:
    sta PPUDATA
    
    ; Check Up (bit 3)
    lda @tempValue
    and #%00001000
    beq @notUp
    lda #$55    ; ASCII 'U'
    jmp @writeUp
@notUp:
    lda #$2D    ; ASCII '-'
@writeUp:
    sta PPUDATA
    
    ; Check Down (bit 2)
    lda @tempValue
    and #%00000100
    beq @notDown
    lda #$44    ; ASCII 'D'
    jmp @writeDown
@notDown:
    lda #$2D    ; ASCII '-'
@writeDown:
    sta PPUDATA
    
    ; Check Left (bit 1)
    lda @tempValue
    and #%00000010
    beq @notLeft
    lda #$4C    ; ASCII 'L'
    jmp @writeLeft
@notLeft:
    lda #$2D    ; ASCII '-'
@writeLeft:
    sta PPUDATA
    
    ; Check Right (bit 0)
    lda @tempValue
    and #%00000001
    beq @notRight
    lda #$52    ; ASCII 'R'
    jmp @writeRight
@notRight:
    lda #$2D    ; ASCII '-'
@writeRight:
    sta PPUDATA

@exit:
    rts

.endproc
