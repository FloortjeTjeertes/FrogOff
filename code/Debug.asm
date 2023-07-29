.export DEBUG




.proc DEBUG
.zeropage
    .importzp RenderStatus
    Loaded: .res 1

.code
 


  ldx Loaded
    cpx #$00
    beq LOAD

rts

LOAD:
    lda #$1
    jsr LOADBACKGROUND

    lda #$01
    sta Loaded
    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta RenderStatus

    lda #$01
    sta Loaded
rts

.import LOADBACKGROUND

.endproc