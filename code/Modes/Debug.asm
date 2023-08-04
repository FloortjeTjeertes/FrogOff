.export DEBUG




.proc DEBUG
.zeropage
    .importzp PPUMask
    Loaded: .res 1

.segment "CODE"
 


  ldx Loaded
    cpx #$00
    beq LOAD

   jsr RENDER

rts

LOAD:
    lda #$01
    jsr LOADBACKGROUND

  
    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta PPUMask

    lda #$01
    sta Loaded
    
    ldx #$00
    jsr LOADENTITIE
    ldx #$00
    jsr LOADENTITIE

rts

.import LOADBACKGROUND
.import LOADENTITIE
.import RENDER
.endproc