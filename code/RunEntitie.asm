; arguments
; 
; runs entitie behaviour
;
; inports: EntitieArrayLength
; exports: xpos, ypos
;
; Local vars: Length, Adress, ModifyingCode
;
; uses: EntitieArray


.export RUNENTITIEBEHAVIOUR

EntitieArray = $0400
Length = $02
Adress = $03
ModifyingCode = $05  



.proc RUNENTITIEBEHAVIOUR

.segment "LOCAL"
 
  
.zeropage 
 .importzp EntitieArrayLength 
 .exportzp xpos, ypos

  xpos: .res 2
  ypos: .res 2
  


.segment "CODE"
    ldy #$00
    ldx #$00
    lda #$00
    sta Length
 
    @loop:
     ldx Length 
     cpx EntitieArrayLength
     beq @endloop
      
      jsr SELECTENTITY

      jsr RUNBEHAVIOUR

     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 

     tya 
     inx 
     stx Length 

      
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
 lda #$20
 sta ModifyingCode
 lda Adress
 sta ModifyingCode+1
 lda Adress+1
 sta ModifyingCode+2

 lda #$60
 sta ModifyingCode+3
 
 jsr ModifyingCode

 ;load posibly updated values back into array
 lda xpos
 sta EntitieArray+4 ,y
 lda xpos+1
 sta EntitieArray+5 ,y

 lda ypos
 sta EntitieArray+6 ,y
 lda ypos+1
 sta EntitieArray+7 ,y

rts

.endproc