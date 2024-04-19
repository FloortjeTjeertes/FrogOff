; test code for meta sprites
; FlyAnimate:
;   lda counter 
;   and #$07
;   cmp #$00
;   beq :+

;   lda #$03 
;   sta metaSpriteIndex
;   lda #$02
;   sta metaSpriteSlot
;   jsr LOAD_META_SPRITE   ; Initialize meta sprites
;   jmp @END
;   :

;     lda #$04 
;     sta metaSpriteIndex
;     lda #$02
;     sta metaSpriteSlot
;   jsr LOAD_META_SPRITE   ; Initialize meta sprites
  
;   @END:
   
; rts
