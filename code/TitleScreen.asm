
.export TITLESCREEN

OptionAmount = 01
OptionSteps = 18
.zeropage
    .importzp metaSpriteSlot
    .importzp metaSpriteIndex
    .importzp buttons

    BackgroundLoaded: .res 1
    Loaded: .res 1
    Options: .res 1

.segment "CODE"
   .import LOADBACKGROUND
   .import LOAD_META_SPRITE
   .import AButton, BButton, SELECT, START, UP, DOWN, LEFT, RIGHT


.proc TITLESCREEN
    
    ldx Loaded
    cpx #$00
    beq LOAD
    
    jsr ControllerAction

 rts

 
 LOAD:
    jsr LOADBACKGROUND

    lda #$01
    sta Loaded

    lda #$03
    sta metaSpriteIndex
    lda #$00
    sta metaSpriteSlot
    jsr LOAD_META_SPRITE

    lda $0200
    adc #$99
    sta $0200
    
    lda $0204
    adc #$99
    sta $0204

    lda $0208
    adc #$99
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
    sta $2001 
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
 rts 

 
 NextOption:
    lda Options
    cmp #$01
    beq :+
    inc Options
    jsr NextFlyPosition
    :
 rts 

 PreviousOption:
    lda Options
    cmp #$00
    beq :+
    dec Options
    jsr PreviousFlyOption

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

 PreviousFlyOption:
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

