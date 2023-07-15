; $00 index of the meta sprite
; $01 length of the meta sprite
; metaSpriteSlot is the place from where the tile data is stored in the oam
.export  LOAD_META_SPRITE

.zeropage
  .exportzp  metaSpriteIndex := $00
  .exportzp  metaSpriteSlot := $01

  ; local variables
  Meta_Sprite_Start_Adress_first_byte: .res 1
  Meta_Sprite_Start_Adress_last_byte: .res 1
  metaSpriteLength: .res 1
  metaOffset: .res 1

.segment "CODE"
.proc LOAD_META_SPRITE





  ; Load meta sprite patterns
  ldy #$00
  ldx #$00

  ;get the offset of the meta sprite
  getLengOfsetOfSprite:
    cpy  metaSpriteIndex               ; Initialize X register
    beq :+
    inx 
    inx 
    inx 
    inx 
    iny 
  jmp getLengOfsetOfSprite
  :
  stx metaOffset


  ;set up the offset of the meta sprite lookup table
  ldx metaSpriteIndex               ; Initialize X register
  ldy #$00

  ; :
  ;   cpy metaSpriteIndex
  ;   beq :+ ;if x is 0 skip the next line

  ;   inx 
  ;   inx 
  ;   iny 
  ;   jmp :- ;jump to the start of the loop

  ; :

  ; Load meta sprite tiles
  lda META_LOOKUP_TABLE, x      ;store length first
  sta metaSpriteLength                     
  lda META_LOOKUP_TABLE+1, x   ; load the second part of where the tile data is stored
  sta Meta_Sprite_Start_Adress_last_byte
  lda META_LOOKUP_TABLE+2, x   ; load the first part of where the tile data is stored
  sta Meta_Sprite_Start_Adress_first_byte           

  ;ofsets the full metasprite in the oam
  SetSpriteSlot:
  ; Initialize Y register
  ; Initialize X register
  ldy #$00                    
  ldx #$00                     
  :
       cpy metaSpriteLength
       bne :+
       inx 

       ;jump to the start of the loop
       jmp :- 
  :    
      
  

  ;  get the length meta sprites that is before it in the list to get the ofset\
  lda metaOffset
  tay
  clc 
  adc metaSpriteLength
  sta metaSpriteLength


  LOAD_TILE:

    ; Load the tile data
    ; Store the tile data in the $0200 range
    lda META_TILE_DATA, y              
    sta $0201,x                  

    ; Load the Y position data
    ; Store the Y position in the OAM address register
    lda META_POSITION_DATA_Y, y   
    sta $0200,x                  

    ; Load the attribute data
    ; Store the attribute data in the $0200 range
    lda META_ATRIBUTE_DATA, y      
    sta $0202,x                 

    ; Load the X position data
    ; Store the X position in the $0200 range
    lda META_POSITION_DATA_X, y 
    sta $0203,x                 

    ; Increment X register to load the next tile                          
    inx  
    inx 
    inx 
    inx 

    tya 

    ; remove address from y  
    sbc Meta_Sprite_Start_Adress_last_byte  

    ; Increment Y register to load the next position/tile
    ;check if the sprite has the length of the meta sprite
    iny                                                           
    cpy    metaSpriteLength                  

  ; If not, continue loading tiles    
  bne LOAD_TILE                

  rts


  .include "metasprites.asm"

.endproc