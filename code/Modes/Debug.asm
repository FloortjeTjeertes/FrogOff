.export DEBUG

.import RENDER
.import RUNENTITYBEHAVIOUR


.proc DEBUG
.zeropage
    .importzp PPUMask
    Loaded: .res 1

.segment "CODE"
 


  ldx Loaded
    cpx #$00
    beq @Load
    bne @Continue
    @Load:
     jsr LOAD

  @Continue:
  jsr RENDER
  jsr RUNENTITYBEHAVIOUR
rts

LOAD:


    lda #$01
    jsr LOADBACKGROUND

  
    lda #%00011110   ;enable sprites and backgrounds for left most 8 pixels
    sta PPUMask

    lda #$01
    sta Loaded
    
    ; Load entities into the entity array
    ldx #$00
    jsr LOADENTITIE


    ldx #$01
    jsr LOADENTITIE

    ldx #$02
    jsr LOADENTITIE

    ; ldx #$0C
    ; jsr LOADENTITIE

   

rts

.import LOADBACKGROUND
.import LOADENTITIE
.import RENDER
.import RUNENTITIEBEHAVIOUR
.endproc