
META_LOOKUP_TABLE:
  ; Lookup table for meta sprite data
  .byte 04             ; player 1 sprite length/
  .addr META_TILE_DATA ; player 1 facing right
  .byte 04             ; player 1 sprite length/
  .addr META_TILE_DATA+4 ; player 1 facing right

META_TILE_DATA:
  ; Individual tiles for each part of the meta sprite
  .byte $9A, $9B, $AA, $AB   ; Sprite 1 tiles 
  .byte $D0, $D1, $E0, $E1   ; Sprite 2 tiles 

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
   .byte %00000000, %00000000, %00000000, %00000000   ; Sprite 2  atributes seperated per tile 


META_POSITION_DATA_X:
  ; Individual positions for each part of the meta sprite
  .byte $00, $08, $00, $08 
  .byte $00, $08, $00, $08    
   

META_POSITION_DATA_Y:
  ; Individual positions for each part of the meta sprite
  .byte $00, $00, $08, $08
  .byte $00, $00, $08, $08



; SPRITEDATA:
;   .byte $08, $9a, $02, $00
;   .byte $08, $9b, $02, $08
;   .byte $10, $aa, $02, $00
;   .byte $10, $ab, $02, $08
;   .byte $18, $9c, $07, $00
;   .byte $18, $9d, $07, $08
;   .byte $20, $ac, $07, $00
;   .byte $20, $ad, $07, $08


