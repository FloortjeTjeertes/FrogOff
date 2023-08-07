.export RUNENTITIEBEHAVIOUR

EntitieArray = $03FF
Length = $02
Adress = $03



.proc RUNENTITIEBEHAVIOUR

.segment "LOCAL"
.zeropage 
 .importzp EntitieArrayLength 
 .exportzp xpos, ypos

  xpos: .byte 2
  ypos: .byte 2

.segment "CODE"
 
    @loop:
     ldy Length 
     cpy EntitieArrayLength
     beq @endloop

     iny 
     sty Length 
      
      jsr SELECTENTITY

      jsr RUNBEHAVIOUR


     
     ;store the loop count on the stack
      
    jmp @loop
    @endloop:
rts


SELECTENTITY:

 ;Adress 2 bytes (word)
 lda EntitieArray+2 ,y
 sta Adress
 lda EntitieArray+3 ,y
 sta Adress+1

 ;Xposition 2 bytes (word)
 lda EntitieArray+4 ,y
 sta xpos
 lda EntitieArray+5 ,y
 sta xpos+1

 ;Yposition 2 bytes (word)
 lda EntitieArray+6 ,y
 sta ypos
 lda EntitieArray+7 ,y
 sta ypos+1

rts

RUNBEHAVIOUR:
 lda @Return
 pha 
 lda @Return+1
 pha 


 jmp (Adress)
 @Return:
rts

.endproc