tablelength = 2

META_LOOKUP_TABLE:
  ; Lookup table for meta sprite data
  .byte 04             ; player 1 sprite length/
  .addr META_TILE_DATA ; player 1 facing righ
  .byte 04             ; player 1 sprite length/
  .addr META_TILE_DATA+4 ; player 1 facing right
  .byte 04             ; player 1 sprite jump 
  .addr META_TILE_DATA+8 ; player 1 facing right
  .byte 08             ; player 1 sprite jump 
  .addr META_TILE_DATA+16 ; player 1 facing right

META_TILE_DATA:
  ; Individual tiles for each part of the meta sprite
  .byte $9A, $9B, $AA, $AB   ; Sprite 1 tiles 
  .byte $D0, $D1, $E0, $E1   ; Sprite 2 tiles 
  .byte $D2, $D3, $E2, $E3   ; Sprite 3 tiles
  .byte $A0, $A1, $A2, $A3,$B0,$B1,$C0,$C1   ; platform tiles

; atribute data
; 76543210
; ||||||||
; ||||||++- Palette (4 to 7) of sprite
; |||+++--- Unimplemented (read 0)
; ||+------ Priority (0: in front of background; 1: behind background)
; |+------- Flip sprite horizontally
; +-------- Flip sprite vertically

META_ATRIBUTE_DATA:
   .byte %00000000, %00000000, %00000000, %00000000 ; Sprite  atributes seperated per tile
   .byte %00000000, %00000000, %00000000, %00000000   ; Sprite player1  atributes seperated per tile 
   .byte %00000001, %00000001, %00000001, %00000001   ; Sprite player1 jump  atributes seperated per tile 
   .byte %00000000, %00000000, %00000000, %00000000   ; Sprite player1 jump  atributes seperated per tile 


META_POSITION_DATA_X:
  ; Individual positions for each part of the meta sprite
  .byte $00, $08, $00, $08 
  .byte $00, $08, $00, $08    
  .byte $00, $08, $00, $08   
  .byte $00, $08, $10, $18 ,$08,$10,$08,$10  

META_POSITION_DATA_Y:
  ; Individual positions for each part of the meta sprite
  .byte $00, $00, $08, $08
  .byte $00, $00, $08, $08
  .byte $00, $00, $08, $08   
  .byte $00, $00, $00, $00 ,$08,$08,$10,$10 



;-----------------------------------------------------------

