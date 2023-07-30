
.export TITLESCREEN

OptionAmount = 01
OptionSteps = 18



.proc TITLESCREEN


.segment "ZEROPAGE"
    .importzp metaSpriteSlot
    .importzp metaSpriteIndex
    .importzp buttons
    .exportzp Mode
    .importzp RenderStatus
    Mode:  .res 1


    BackgroundLoaded: .res 1
    Loaded: .res 1
    Options: .res 1

.code
   .import LOADBACKGROUND
   .import LOAD_META_SPRITE
   .import AButton, BButton, SELECT, START, UP, DOWN, LEFT, RIGHT


    
    ldx Loaded
    cpx #$00
    beq LOAD
    
    jsr ControllerAction

   rts 
 
 LOAD:
    ldy #$00 
    jsr LOADBACKGROUND

    lda #$03
    sta metaSpriteIndex
    lda #$00
    sta metaSpriteSlot
    jsr LOAD_META_SPRITE

    lda $0200
    adc #$9a
    sta $0200
    
    lda $0204
    adc #$9a
    sta $0204

    lda $0208
    adc #$9a
    sta $0208


    lda $0203
    adc #$55
    sta $0203 
    
    lda $0207
    adc #$55
    sta $0207

    lda $020B
    adc #$55
    sta $020B


    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta RenderStatus

    lda #$01
    sta Loaded
 rts 

 ControllerAction:
    lda DOWN
    and buttons
    cmp DOWN
    beq NextOption

    lda UP
    and buttons
    cmp UP
    beq PreviousOption

    

    lda START
    and buttons
    cmp START
    beq StartOption

 rts 
 
 StartOption:
   ldx Options
   inx 
   stx Mode
 rts 

 NextOption:
   
    lda Options
    clc 
    cmp #$01
    beq :+
     inc Options
     jsr NextFlyPosition
    :
 rts 

 PreviousOption:
    lda Options
    clc 
    cmp #$00
    beq :+
      dec Options
      jsr PreviousFlyPosition
    : 
 rts 

 NextFlyPosition:
    lda $0200
    adc #$18
    sta $0200
    
    lda $0204
    adc #$18
    sta $0204

    lda $0208
    adc #$18
    sta $0208

 rts 

 PreviousFlyPosition:
    lda $0200
    sbc #$18
    sta $0200
    
    lda $0204
    sbc #$18
    sta $0204

    lda $0208
    sbc #$18
    sta $0208


 rts 


 
    

.endproc

