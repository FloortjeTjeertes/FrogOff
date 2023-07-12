; metaSpriteIndex: .res 1
; metaSpriteSlot: .res 1

; Meta_Sprite_Start_Adress_first_byte: .res 1
; Meta_Sprite_Start_Adress_last_byte: .res 1
; metaSpriteLength: .res 1
; metaOffset: .res 1

;$00 index of the meta sprite
;$01 length of the meta sprite
;metaSpriteSlot is the place from where the tile data is stored in the oam

; $00 index of the meta sprite
; $01 length of the meta sprite
; metaSpriteSlot is the place from where the tile data is stored in the oam
LOAD_META_SPRITE:
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
  ldy #$00                     ; Initialize Y register
  ldx #$00                     ; Initialize X register
  :
       cpy metaSpriteLength
       bne :+
       inx 
     
       jmp :-  ;jump to the start of the loop
  :            ; end of ser sprite slot
      
  

  ;  get the length meta sprites that is before it in the list to get the ofset\
  lda metaOffset
  tay
  clc 
  adc metaSpriteLength
  sta metaSpriteLength

 

  
 

  

  LOAD_TILE:

  
    lda META_TILE_DATA, y                ; Load the tile data
    sta $0201,x                  ; Store the tile data in the $0200 range


    lda META_POSITION_DATA_Y, y   ; Load the Y position data
    sta $0200,x                   ; Store the Y position in the OAM address register


    lda META_ATRIBUTE_DATA, y      ; Load the attribute data
    sta $0202,x                 ; Store the attribute data in the $0200 range

    lda META_POSITION_DATA_X, y ; Load the X position data
    sta $0203,x                 ; Store the X position in the $0200 range

                             
    inx  ; Increment X register to load the next tile
    inx 
    inx 
    inx 

    tya 
    sbc Meta_Sprite_Start_Adress_last_byte                                                  ; remove address from y                 


    iny                                                        ; Increment Y register to load the next position/tile     
    cpy    metaSpriteLength                  ;check if the sprite has the length of the meta sprite
                        
  bne LOAD_TILE                 ; If not, continue loading tiles



 

rts