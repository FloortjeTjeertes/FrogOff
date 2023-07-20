; $00 index of the meta sprite
; $01 length of the meta sprite
; metaSpriteSlot is the place from where the tile data is stored in the oam
.export  LOAD_META_SPRITE

.zeropage
  .exportzp  metaSpriteIndex := $00
  .exportzp  metaSpriteSlot := $01

  ; local variables
  Meta_Sprite_Start_Adress_last_byte: .res 1
  Meta_Sprite_Start_Adress_first_byte: .res 1
  MetaSpriteAtributeAdress: .res 2
  MetaSpriteXPositionAdress: .res 2
  MetaSpriteYPositionAdress: .res 2

  metaSpriteLength: .res 1
  metaOffset: .res 1
  temp: .res 1

.segment "CODE"
.proc LOAD_META_SPRITE

  


  ; Load meta sprite patterns
  ldy #$00
  ldx #$00

  ;get the offset of the meta sprite
  getLengthOfsetOfSprite:
    cpy  metaSpriteIndex               ; Initialize X register
    beq :+ 
    inx 
    inx 
    inx   
    iny 
    inc metaOffset
    inc metaOffset
    inc metaOffset
    inc metaOffset

  jmp getLengthOfsetOfSprite
  :


  ;set up the offset of the meta sprite lookup table
  ; ldx metaSpriteIndex               ; Initialize X register
  ldy #$00

  ; Load meta sprite tiles
  lda META_LOOKUP_TABLE, x      ;store length first
  sta metaSpriteLength     

  ;load the adress of the meta sprite                  
  lda META_LOOKUP_TABLE+1, x   ; load the second part of where the tile data is stored
  sta Meta_Sprite_Start_Adress_last_byte
  lda META_LOOKUP_TABLE+2, x   ; load the first part of where the tile data is stored
  sta Meta_Sprite_Start_Adress_first_byte  
  
  ; load metasprite Atributes
  lda META_LOOKUP_TABLE+3, x
  sta MetaSpriteAtributeAdress           
  lda META_LOOKUP_TABLE+4, x
  sta MetaSpriteAtributeAdress+1    

  ; load metasprite X position
  lda META_LOOKUP_TABLE+5, x
  sta MetaSpriteXPositionAdress           
  lda META_LOOKUP_TABLE+6, x
  sta MetaSpriteXPositionAdress+1  

  ; load metasprite Y position    
  lda META_LOOKUP_TABLE+7, x
  sta MetaSpriteYPositionAdress           
  lda META_LOOKUP_TABLE+8, x
  sta MetaSpriteYPositionAdress+1   

  ;ofsets the full metasprite in the oam
  ; Initialize Y register
  ; Initialize X register
  ldy #$00                    
  ldx #$00 
  lda #$00
  sta temp

  SetSpriteSlot:
    clc 
    cpy metaSpriteSlot
    beq EndSetSpriteSlot 
    ldx #$00       
      :
         lda temp
         clc 
         cpx metaSpriteLength
         beq :+
         inx  
         inc temp
         inc temp
         inc temp
         inc temp
         ;jump to the start of the loop
         jmp :- 
      :    
    iny 
    jmp SetSpriteSlot
  EndSetSpriteSlot:    
  tax  
    
  

  ;  get the length meta sprites that is before it in the list to get the ofset\
  lda metaOffset
  tax 
  clc 
  adc metaSpriteLength
  sta metaSpriteLength


  LOAD_TILE:


    ; \test 
    
   
   

    ; Load the tile data
    ; Store the tile data in the $0200 range
    ; lda META_TILE_DATA, x    
    lda (Meta_Sprite_Start_Adress_last_byte),y         
    sta $0201,x  

                

    ; Load the Y position data
    ; Store the Y position in the OAM address register
    lda (MetaSpriteYPositionAdress),y         
    sta $0200,x                  

    ; Load the attribute data
    ; Store the attribute data in the $0200 range
    lda (MetaSpriteAtributeAdress),y         
    sta $0202,x                 

    ; Load the X position data
    ; Store the X position in the $0200 range
    lda (MetaSpriteXPositionAdress),y         
    sta $0203,x                 

    ; Increment X register to load the next tile                          
    inx  
    inx 
    inx 
    inx 

    ; Increment y register to load the next position/tile
    ;check if the sprite has the length of the meta sprite
    iny                                                           
    cpy    metaSpriteLength                  

  ; If not, continue loading tiles    
  bne LOAD_TILE                

  rts


  .include "metasprites.asm"

.endproc