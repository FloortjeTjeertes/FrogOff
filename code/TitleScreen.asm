
.export TITLESCREEN


.zeropage
    BackgroundLoaded: .res 1
    Loaded: .res 1

.segment "CODE"
.import LOADBACKGROUND

.proc TITLESCREEN
    
    ldx Loaded
    cpx #$00
    beq LOAD
    

 rts

 
 LOAD:
    jsr LOADBACKGROUND

    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta $2001 

    lda #$01
    sta Loaded
 rts 





.endproc

