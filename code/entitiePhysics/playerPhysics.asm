; +----------------------+
; |    player physics    |
; +----------------------+
;
; imports xpos, ypos



.export PLAYERPHYSICS

.import INCREASE , DECREASE , ADD
.import counter
.import AButton, BButton, SELECT, START, UP, DOWN, LEFT, RIGHT
.importzp ValueToIncrease, StepValue ,ValueToDeCrease
.importzp PRESSEDBUTTONS1

.proc PLAYERPHYSICS



.zeropage 
.importzp xpos , ypos
 duration: .byte 1
 loop:    .byte 1 
 NotFalling: .byte 1
 Jumping: .byte 1
.segment "CODE"
 
 jsr @ControllerAction


 lda NotFalling
 cmp #$01
 beq :+


 

 lda ypos
 cmp #$7f
 beq :+
  lda NotFalling
  cmp #$01
  beq :+
 
  jsr Falling
  

 :

 lda #$00
 sta NotFalling

 ldx #$00
 ldy #$00

rts

@ControllerAction:
   lda AButton
   and PRESSEDBUTTONS1
   cmp AButton
   beq @AButton

   lda LEFT
   and PRESSEDBUTTONS1
   cmp LEFT
   beq @left

   lda RIGHT
   and PRESSEDBUTTONS1
   cmp RIGHT
   beq @right

   jmp @endActions

   @left:
      jsr PlayerLeftAction
   jmp @endActions

   @right:
     jsr PlayerRightAction
   jmp @endActions


   @AButton:
     jsr PlayerJumpAction
   ;end of AButton
     
   @endActions:
   


rts


 
;maybe move this to a generic file
;makes the player fall whit a sertain amount of gravity
;subpixel value 
Falling:
 @length = 3
   

 lda ypos
 sta ValueToIncrease
 lda ypos+1
 sta ValueToIncrease+1

 
 ldx loop
 lda FallingValues,x 
 sta StepValue
 jsr INCREASE

 lda ValueToIncrease
 sta ypos
 lda ValueToIncrease+1
 sta ypos+1
 

 lda duration
 cmp Durations,x
 bne :+

  lda loop
  cmp #$03
  beq :+
  inc loop

  lda #$00
  sta duration
 :


 
 inc duration
 
rts


FallingValues:  .byte 80 , 100 , 200 , 255 
Durations:      .byte 20 , 10 , 5 , 2
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

PlayerLeftAction:

 lda xpos
 sta ValueToIncrease
 lda xpos+1
 sta ValueToIncrease+1

 
 lda #$F0
 sta StepValue
 jsr DECREASE

 lda ValueToIncrease
 sta xpos
 lda ValueToIncrease+1
 sta xpos+1

rts

PlayerRightAction:
 lda xpos
 sta ValueToIncrease
 lda xpos+1
 sta ValueToIncrease+1

 
 lda #$F0
 sta StepValue
 jsr INCREASE

 lda ValueToIncrease
 sta xpos
 lda ValueToIncrease+1
 sta xpos+1
rts

PlayerJumpAction:

 lda ypos
 sta ValueToDeCrease
 lda ypos+1
 sta ValueToDeCrease+1

 lda #$FF
 sta StepValue
 jsr DECREASE

 lda #$FF
 sta StepValue
 jsr DECREASE


  lda #$FF
 sta StepValue
 jsr DECREASE



 lda ValueToDeCrease
 sta ypos
 lda ValueToDeCrease+1
 sta ypos+1


 lda Jumping
 cmp #$05
 bne :+
  lda #$00
  sta NotFalling
  sta Jumping
  rts 
 :
 
 lda #$01
 sta NotFalling
 inc Jumping


rts 

.endproc