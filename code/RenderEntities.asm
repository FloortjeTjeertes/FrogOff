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
 .importzp  xpos, ypos

.segment "CODE"

    ldy #$00
    ldx #$00
    lda #$00
    sta @Length
    sta @index
    sta metaSpriteIndex
    lda #$FF
    sta metaSpriteSlot


   ;loop trough all the entities to render them 
   ;might make a check to assert if a entitie should be renderd or not
    @loop:

     ldy @Length 
     
     ldx @index
     cpx EntitieArrayLength
     beq @endloop

     ;increase the length for the array pointer by one entry length
     iny
     iny
     iny
     iny
     iny
     iny
     iny
     iny

     sty @Length 


    ;set the x and y position memory to the current (likely updated) position of the entity 16 bites per coordinate)
    ;sub pixels are ignored as they are not needed for the ppu
    ;X position
    lda EntitieArray+4,y
    sta xpos

    ;Y position
    lda EntitieArray+6,y
    sta ypos


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