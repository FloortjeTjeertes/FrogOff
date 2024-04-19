

; @Direction:
; #%00000000
;   ||||||||
;   |||||||+-- left
;   ||||||+--- down-left
;   |||||+---- down
;   ||||+----- down-right
;   |||+------ right
;   ||+------- up-right
;   |+-------- up
;   +--------- up-left


.export FLYPHYSICS

.proc FLYPHYSICS

.zeropage 
.importzp xpos , ypos 
.importzp counter
@Counter: .res 1
@Direction: .res 1
@initialise: .res 1

.segment "CODE"
  
  lda @initialise
  cmp #$01
  beq :+
  inc @initialise
  lda #%00010000
  sta @Direction
  
  lda #$7F
  sta ypos
  :


  jsr @BallPhysics
  ; jsr @MoveRight
rts 

@Rotate:
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

@BallPhysics:
 jsr @CheckColision

 lda @Direction
 and #%00010000
 cmp #%00010000
 beq @right

 lda @Direction
 and #%00001000
 cmp #%00001000
 beq @left



 @left:
  jsr @MoveLeft
 jmp @end

 @right:
  jsr @MoveRight
 jmp @end

 @end:

rts

@CheckColision:
  ; check if fly is at the right edge of screen
  lda xpos
  cmp #$F0
  bne :+

  ;set the bit for the left direction anouncing that left should be set
  lda @Direction
  ;unset right direction
  eor #%00010000
  ;set left direction
  ora #%00001000
  sta @Direction
  :

  ; check if fly is at the left edge of screen
  lda xpos
  cmp #$04
  bne :+
  ;set the bit for the right direction anouncing that right should be set
  lda @Direction
  ;unset left direction
  eor #%00001000
  ;set right direction
  ora #%00010000
  sta @Direction
  :

  ; janky hack to check colision but hey a test is a test
  lda $0404
  cmp xpos
  bne :+

    lda $0406
    cmp ypos
    bne :+

     ;set the bit for the right direction anouncing that right should be set
     lda @Direction
     ;unset left direction
     eor #%00001000
     ;set right direction
     ora #%00010000
     sta @Direction
  :

  

  :


rts

@MoveLeft:
 lda xpos
 sbc #$1
 sta xpos
rts

@MoveRight:
 lda xpos
 adc #$1
 sta xpos
rts

@Multiplier = 2
@CoordXHigh:  .byte 10*@Multiplier , 15*@Multiplier , 20*@Multiplier , 15*@Multiplier, 10*@Multiplier, 05*@Multiplier , 00*@Multiplier
@CoordXLow:   .byte 00 , 00 , 00 , 00, 00, 00 , 00

@CoordYHigh:  .byte 00*@Multiplier  , 05*@Multiplier , 10*@Multiplier , 15*@Multiplier, 20*@Multiplier ,15*@Multiplier ,10*@Multiplier
@CoordYLow:   .byte 00  , 00 , 00 , 00, 00 ,00 ,00

@FlyWidth: .byte 12
@FlyHeight: .byte 8

.endproc