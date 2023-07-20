tablelength = 2

META_LOOKUP_TABLE:
  ; Lookup table for meta sprite data
  .byte 04               ; player 1 sprite length/
  .addr META_TILE_DATA   ; player 1 facing right
  .addr META_ATRIBUTE_DATA   
  .addr META_POSITION_DATA_X   
  .addr META_POSITION_DATA_Y   
  .byte 04               ; player 1 sprite length/
  .addr META_TILE_DATA+4 ; player 1 facing right
  .addr META_ATRIBUTE_DATA+4   
  .addr META_POSITION_DATA_X+4   
  .addr META_POSITION_DATA_Y+4 
  .byte 14               ; test
  .addr META_TILE_DATA+8
  .addr META_ATRIBUTE_DATA+8   
  .addr META_POSITION_DATA_X+8   
  .addr META_POSITION_DATA_Y+8 
  .byte 03                ; player 1 sprite jump 
  .addr META_TILE_DATA+16 ; player 1 sprite jump 
  .addr META_ATRIBUTE_DATA+16   
  .addr META_POSITION_DATA_X+16   
  .addr META_POSITION_DATA_Y+16

META_TILE_DATA:
  ; Individual tiles for each part of the meta sprite
  .byte $00, $01, $02, $03   ; Sprite 1 tiles 
  .byte $04, $05, $06, $07   ; Sprite 2 tiles 
  .byte $10, $11, $12, $13,$14,$15,$16,$17,$18,$19,$33,$44,$52,$53    ; Sprite 3 tiles
  .byte $08, $09, $08        ; fly/nat




; atribute data
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented (read 0)
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically

META_ATRIBUTE_DATA:
   .byte %00000000, %00000000, %00000000, %00000000   ; Sprite  atributes seperated per tile
   .byte %00000001, %00000001, %00000001, %00000001   ; Sprite player1 jump  atributes seperated per tile 
   .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000   
   .byte %00000010, %00000010, %00000011
META_POSITION_DATA_X:
  ; Individual positions for each part of the meta sprite
  .byte $00, $08, $00, $08 
  .byte $00, $08, $00, $08    
  .byte $00, $08, $10, $18, $20, $28, $30, $00, $08, $10, $18, $20 ,$28, $30     
  .byte $00, $08, $04   

META_POSITION_DATA_Y:
  ; Individual positions for each part of the meta sprite
  .byte $00, $00, $08, $08
  .byte $00, $00, $08, $08
  .byte $00, $00, $00, $00, $00, $00, $00, $08, $08, $08, $08, $08, $08, $08     
  .byte $10, $10, $08      



;-----------------------------------------------------------

