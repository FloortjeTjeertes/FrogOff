.export DEBUG




.proc DEBUG
.zeropage
    .importzp PPUMask
    Loaded: .res 1

.code
 


  ldx Loaded
    cpx #$00
    beq LOAD

rts

LOAD:
    lda #$01
    jsr LOADBACKGROUND

  
    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta PPUMask

    lda #$01
    sta Loaded
rts

.import LOADBACKGROUND

.endproc