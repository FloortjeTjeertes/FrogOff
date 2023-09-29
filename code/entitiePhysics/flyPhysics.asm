.export FLYPHYSICS

.proc FLYPHYSICS

.zeropage 
.importzp xpos , ypos 
.importzp counter
@Counter: .res 1

.segment "CODE"

ldx @Counter
ldy #$00
lda #$00

; lda #$7F
; dec @FlyHeight
; sta xpos

; lda #$7f
; dec @FlyHeight
; sta ypos
     







    lda @CoordXHigh, X
    adc @FlyWidth
    sta xpos

    lda @CoordXLow, X
    sta xpos+1

    lda @CoordYHigh, X
    adc @FlyHeight
    sta ypos

    lda @CoordYLow, X
    sta ypos+1

    

    ; lda counter
    ; and #$1F
    ; cmp #$1F
    ; bne @skip



    inc @Counter
    
    cpx #$06
    bne @skip
    lda #$00
    sta @Counter

    @skip:

ldx #$00






rts
 
@CoordXHigh:  .byte 10 , 15 , 20 , 15, 10, 05 , 00
@CoordXLow:   .byte 00 , 00 , 00 , 00, 00, 00 , 00

@CoordYHigh:  .byte 00  , 05 , 10 , 15, 20 ,15 ,10
@CoordYLow:   .byte 00  , 00 , 00 , 00, 00 ,00 ,00

@FlyWidth: .byte 12
@FlyHeight: .byte 8

.endproc