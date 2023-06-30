
META_LOOKUP_TABLE:
  ; Lookup table for meta sprite data
  .byte 04             ; player 1 sprite length/
  .addr META_TILE_DATA ; player 1 facing right

META_TILE_DATA:
  ; Individual tiles for each part of the meta sprite
  .byte $9A, $9B, $AA, $AB   ; Sprite 1 tiles 
  .byte $9C, $9D, $AC, $AD   ; Sprite 2 tiles 

META_COLOR_DATA:
   .byte $02, $02, $02, $02 ; Sprite 1 color
   .byte $07, $07, $07, $AD   ; Sprite 2 color 


META_POSITION_DATA:
  ; Individual positions for each part of the meta sprite
  ;     t1,  t2,  t3,  t4 ,etc
  .byte $08, $00,  $08, $08, $10, $00, $10,$08; Sprite sprite 1  Y positions

SPRITEDATA:
  .byte $08, $9a, $02, $00
  .byte $08, $9b, $02, $08
  .byte $10, $aa, $02, $00
  .byte $10, $ab, $02, $08
  .byte $18, $9c, $07, $00
  .byte $18, $9d, $07, $08
  .byte $20, $ac, $07, $00
  .byte $20, $ad, $07, $08