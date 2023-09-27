;renders the entities on the correct layer either foreground or background
.export RENDER

.import LOAD_META_SPRITE

EntitieArray = $03F8


.proc RENDER
.segment "LOCAL"
  @Length = $02
  @index = $03
.zeropage
 .importzp EntitieArrayLength 
 .importzp metaSpriteIndex , metaSpriteSlot

.segment "CODE"

    ldy #$00
    ldx #$00
    lda #$00
    sta @Length
    sta @index
    sta metaSpriteIndex
    lda #$FF
    sta metaSpriteSlot


  
    @loop:

     ldy @Length 
     
     ldx @index
     cpx EntitieArrayLength
     beq @endloop

     iny
     iny
     iny
     iny
     iny
     iny
     iny
     iny

     sty @Length 


     lda EntitieArray,y
     and #%00000000
     cmp #$01
     beq @background


     lda EntitieArray,y
     and #%00000001
     cmp #$01
     beq @foreground


     @background:
        jsr RENDERINBACKGEOUND
        jmp @Continue

     @foreground:
        jsr RENDERINFORGROUND
     
     @Continue: 

     
      inx 
      stx @index
    jmp @loop

    @endloop:
;  pla 
   lda #$00
   sta @Length
   sta @index
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