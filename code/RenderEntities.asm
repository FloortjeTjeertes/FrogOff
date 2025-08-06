;renders the entities on the correct layer either foreground or background
.export RENDER

.import LOAD_META_SPRITE
.import CLEAR_METASPRITES

EntityArray = $03F8


.proc RENDER
.segment "LOCAL"
  AnimationAddress = $05
  @Length = $02
  @index = $03


.zeropage
 .importzp EntityArrayLength 
 .importzp metaSpriteIndex , metaSpriteSlot
 .importzp  TotalSpriteLength
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

    ;clear all sprites
    jsr CLEAR_METASPRITES

   ;loop trough all the entities to render them 
   ;might make a check to assert if a entitie should be renderd or not
    @loop:

     ldy @Length 
     
     ldx @index
     cpx EntityArrayLength
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
    lda EntityArray+5,y
    sta xpos

    ;Y position
    lda EntityArray+7,y
    sta ypos

    
     lda EntityArray,y
     and #%00000000
     cmp #$01
     beq @background


     lda EntityArray,y
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
   lda #$00
   sta @Length
   sta @index
   sta TotalSpriteLength
rts


    RENDERINBACKGEOUND:
        lda EntityArray+1,y
    rts 

    RENDERINFORGROUND:
        ; might move this to seperate subroutine for animation



        ;load the tile entry low byte
        lda EntityArray+1,y
        sta AnimationAddress+1

        ;load the tile entry high byte
        lda EntityArray+2,y
        sta AnimationAddress


        ; ldy #$00
        ; lda (AnimationAddress), y
        ; sta metaSpriteIndex

        inc metaSpriteSlot
        jsr LOAD_META_SPRITE
    rts 


.endproc