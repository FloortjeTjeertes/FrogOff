; $00 index of the meta sprite
; $01 length of the meta sprite
; metaSpriteSlot is the place from where the tile data is stored in the oam
.export  LOAD_META_SPRITE

OAM_START = $0200
OAM_END = $02FF
.zeropage
  .exportzp  metaSpriteIndex := $00
  .exportzp  metaSpriteSlot := $01
  .exportzp  TotalSpriteLength := $50
  .importzp  xpos, ypos
  .importzp SpriteTableSlot1, SpriteTableSlot2, SpriteTableSlot3, SpriteTableSlot4
  ; local variables
  Meta_Sprite_Start_Address_last_byte: .res 1
  Meta_Sprite_Start_Address_first_byte: .res 1
  MetaSpriteAttributeAddress: .res 2
  MetaSpriteXPositionAddress: .res 2
  MetaSpriteYPositionAddress: .res 2
  MetaSpritePalletteID: .res 1
  metaSpriteLength: .res 1
  ; TotalSpriteLength: .res 1
  metaOffset: .res 1
  metaSpritePalletteIndex: .res 1
  spriteSlotOffset: .res 1
  softwarePalletId: .res 1
  hardwarePalletId: .res 1

.segment "CODE"
.proc LOAD_META_SPRITE

  


  ; Load meta sprite patterns
  ldy #$00
  ldx #$00



  ;get the offset of the meta sprite
  getLengthOffsetOfSprite:
    cpy  metaSpriteIndex               ; Initialize X register
    beq :+ 
    ; increment once for the length
    inx 
    ;increment 2 times for the tilde data address
    inx 
    inx 
    ;increment 1 time for the palette
    inx

    ;increment 2 times for the attributes
    inx 
    inx 
    ;increment 2 times for the x position
    inx 
    inx 
    ;increment 2 times for the y position
    inx 
    inx 
    ;increment 1 time for the next meta sprite
    iny 

    ;increment the offset for one full oam tile (4 bytes)
    ; inc metaOffset
    ; inc metaOffset
    ; inc metaOffset
    ; inc metaOffset

  jmp getLengthOffsetOfSprite
  :


  ;set up the offset of the meta sprite lookup table
  ; ldx metaSpriteIndex               ; Initialize X register
  ldy #$00

  ; Load meta sprite tiles
  lda META_LOOKUP_TABLE, x      ;store length first
  sta metaSpriteLength     
  ;load the address of the meta sprite                  
  lda META_LOOKUP_TABLE+1, x   ; load the second part of where the tile data is stored
  sta Meta_Sprite_Start_Address_last_byte
  lda META_LOOKUP_TABLE+2, x   ; load the first part of where the tile data is stored
  sta Meta_Sprite_Start_Address_first_byte  
  

   ;Load the character palette
   lda #$00
   sta hardwarePalletId  ;zero out harwarePalletId

   lda META_SPRITE_PALETTES+1
   sta softwarePalletId
  
   cmp SpriteTableSlot1
   bne :+
   inc hardwarePalletId

   cmp SpriteTableSlot2
   bne :+
   inc hardwarePalletId

   cmp SpriteTableSlot3
   bne :+
   inc hardwarePalletId


   cmp SpriteTableSlot4
   bne :+
   inc hardwarePalletId
   ;check if character palette doesn't already exist
   ;check if marked for overwrite
   ;write palette
   ;temp store palette index
  :

  ; load metasprite Attributes
  lda META_LOOKUP_TABLE+3, x
  sta MetaSpriteAttributeAddress           
  lda META_LOOKUP_TABLE+4, x
  sta MetaSpriteAttributeAddress+1    

  ; load metasprite X position
  lda META_LOOKUP_TABLE+5, x
  sta MetaSpriteXPositionAddress           
  lda META_LOOKUP_TABLE+6, x
  sta MetaSpriteXPositionAddress+1  

  ; load metasprite Y position    
  lda META_LOOKUP_TABLE+7, x
  sta MetaSpriteYPositionAddress           
  lda META_LOOKUP_TABLE+8, x
  sta MetaSpriteYPositionAddress+1   

  ;ofsets the full metasprite in the oam
  ; Initialize Y register
  ; Initialize X register
  ldy #$00                    
  ldx #$00 
  lda #$00
  sta spriteSlotOffset

  SetSpriteSlot:
   

    clc 
    ; cpy metaSpriteSlot
    ; beq EndSetSpriteSlot 
    ldx #$00       
      :
         lda spriteSlotOffset
         clc 
        ;  cpx metaSpriteLength
         cpx TotalSpriteLength
         beq :+
         inx  
         inc spriteSlotOffset
         inc spriteSlotOffset
         inc spriteSlotOffset
         inc spriteSlotOffset
         ;jump to the start of the loop
         jmp :- 
      :    
    ; iny 
    ; jmp SetSpriteSlot
  EndSetSpriteSlot:    
  tax  
    
  

  ;store the length of the meta sprite and store it in the previous meta sprite length
  lda metaSpriteLength
  adc TotalSpriteLength
  sta TotalSpriteLength
  

  ldy #$00

  LOAD_TILE:

    ; Load the tile data
    ; Store the tile data in the $0200 range
    lda (Meta_Sprite_Start_Address_last_byte),y         
    sta OAM_START+1,x  
    ; Load the Y position data
    ; Store the Y position in the OAM address register
    lda (MetaSpriteYPositionAddress),y   
    adc ypos
    sta OAM_START,x 


    ; Load the attribute data
    ; Store the attribute data in the $0200 range
    lda (MetaSpriteAttributeAddress),y         
    sta OAM_START+2,x                 
    ; Load the X position data
    ; Store the X position in the $0200 range
    lda (MetaSpriteXPositionAddress),y      
    adc xpos
    sta OAM_START+3,x     

   



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
   
   ldy #$00
   ldx #$00
  rts


  


  .include "../Lists/metasprites.asm"

.endproc