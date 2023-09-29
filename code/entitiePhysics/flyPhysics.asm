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


     






    ; lda counter
    lda #$6c

    adc @CoordXHigh, X
    adc @FlyWidth
    sta xpos

    lda @CoordXLow, X
    sta xpos+1

    ; lda counter
    lda #$50
    adc @CoordYHigh, X
    adc @FlyHeight
    sta ypos

    lda @CoordYLow, X
    sta ypos+1

    

    lda counter
    and #$03
    cmp #$03
    bne @skip



    inc @Counter
    
    cpx #$06
    bne @skip
    lda #$00
    sta @Counter

    @skip:

ldx #$00






rts

@Multiplier = 2
@CoordXHigh:  .byte 10*@Multiplier , 15*@Multiplier , 20*@Multiplier , 15*@Multiplier, 10*@Multiplier, 05*@Multiplier , 00*@Multiplier
@CoordXLow:   .byte 00 , 00 , 00 , 00, 00, 00 , 00

@CoordYHigh:  .byte 00*@Multiplier  , 05*@Multiplier , 10*@Multiplier , 15*@Multiplier, 20*@Multiplier ,15*@Multiplier ,10*@Multiplier
@CoordYLow:   .byte 00  , 00 , 00 , 00, 00 ,00 ,00

@FlyWidth: .byte 12
@FlyHeight: .byte 8

.endproc