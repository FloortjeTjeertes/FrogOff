;renders the entities on the correct layer either foreground or background
.export RENDER

.import LOAD_META_SPRITE

EntitieArray = $03FF


.proc RENDER
.segment "LOCAL"
  
.zeropage
 .importzp EntitieArrayLength 
 .importzp metaSpriteIndex , metaSpriteSlot

.segment "CODE"

    ldy #$00
    ldx #$00
    lda #$00

    @loop:
     iny 
     lda EntitieArray,y
     and #%00000000
     beq RENDERINBACKGEOUND
     and #%00000001
     beq RENDERINFORGROUND

     
     cmp EntitieArrayLength
     bne @loop
    @endloop:

rts

RENDERINBACKGEOUND:
    lda EntitieArray+1,y
rts

RENDERINFORGROUND:
    lda EntitieArray+1,y
    jsr LOAD_META_SPRITE
rts

.endproc