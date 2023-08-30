; +----------------------+
; |    player physics    |
; +----------------------+
;
; imports xpos, ypos



.export PLAYERPHYSICS

.import INCREASE
.importzp ValueToIncrease, StepValue

.proc PLAYERPHYSICS



.zeropage 
.importzp xpos , ypos
 speed: .byte 1 
 cycle: .byte 1

.segment "CODE"

 jsr Falling
 
 ldx #$00
 ldy #$00
rts



 
;maybe move this to a generic file
;subpixel value 
Falling:
 lda ypos
 sta ValueToIncrease
 lda ypos+1
 sta ValueToIncrease+1
 stx speed
 lda FallingValues,x 
 sta StepValue
 jsr INCREASE

 lda ValueToIncrease
 sta ypos
 lda ValueToIncrease+1
 sta ypos+1
 
 lda cycle
 cmp #$FF
 bne :+

 cpx #$03
 bne :+
 inc speed
  :
 inc cycle
rts

FallingValues:  .byte 50 , 100 , 200 , 255 

;check collision with the ground
;still a test
CheckCollision:
  lda ypos
  cmp #$A4
  bne @noColision
  lda ypos+1
  cmp #$CE
  bne @noColision
  
  

  @noColision:
rts

.endproc