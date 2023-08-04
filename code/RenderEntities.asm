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
    sta metaSpriteIndex
    lda #$FF
    sta metaSpriteSlot

    lda #$00
    pha 
    @loop:
     pla    
     cmp EntitieArrayLength
     beq @endloop

     iny 

     lda EntitieArray,y
     and #%00000000
     cmp #$01
     beq RENDERINBACKGEOUND

     lda EntitieArray,y
     and #%00000001
     cmp #$01
     beq RENDERINFORGROUND
     
     ;store the loop count on the stack
     tya 
     pha  
     jmp @loop
    @endloop:
;  pla 
rts

RENDERINBACKGEOUND:
    lda EntitieArray+1,y
rts

RENDERINFORGROUND:
    lda EntitieArray+1,y
    sta metaSpriteIndex
    inc metaSpriteSlot
    jsr LOAD_META_SPRITE
rts

.endproc