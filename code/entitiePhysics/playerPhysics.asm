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


.segment "CODE"

 jsr Falling
 
rts





;maybe move this to a generic file
;subpixel value 
@Grafity = 10
Falling:
 lda ypos
 sta ValueToIncrease
 lda ypos+1
 sta ValueToIncrease+1


 lda #$AA
 sta StepValue
 jsr INCREASE

 lda ValueToIncrease
 sta ypos
 lda ValueToIncrease+1
 sta ypos+1

rts

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