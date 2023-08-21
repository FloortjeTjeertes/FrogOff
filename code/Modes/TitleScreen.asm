
.export TITLESCREEN

OptionAmount = 01
OptionSteps = 18




.proc TITLESCREEN

.segment "LOCAL"
    Loaded: .res 1
    Options: .res 1

.segment "ZEROPAGE"
     
    .importzp metaSpriteSlot
    .importzp metaSpriteIndex
    .exportzp Mode
    .importzp PPUMask
    ;imports from ButtonReading.asm
    .importzp PRESSEDBUTTONS1, RELEASEDBUTTONS1
    Mode:  .res 1

.code
   .import LOADBACKGROUND
   .import LOAD_META_SPRITE
   .import AButton, BButton, SELECT, START, UP, DOWN, LEFT, RIGHT


    
    ldx Loaded
    cpx #$00
    beq @Load
    bne @Continue
    @Load:
     jsr LOAD 

    @Continue:

    
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
    sta PPUMask

    lda #$01
    sta Loaded

    lda #$00
    sta Options
 rts 

 ControllerAction:
    lda DOWN
    and PRESSEDBUTTONS1
    cmp DOWN
    beq NextOption

    lda UP
    and PRESSEDBUTTONS1
    cmp UP
    beq PreviousOption

    

    lda START
    and PRESSEDBUTTONS1
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

