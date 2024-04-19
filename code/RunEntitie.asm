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

; Length = $02
; Adress = $03 ;2 bytes
; SelectedEntityIndex =$05




.proc RUNENTITIEBEHAVIOUR

.segment "LOCAL"
 
  
.zeropage 
 .importzp EntitieArrayLength 
 .exportzp xpos, ypos

  xpos: .res 2
  ypos: .res 2
  ModifyingCode: .res 4
  ;maybe store these on the stack later
  Length: .res 2
  Adress:.res 2
  SelectedEntityIndex: .res 1
.segment "CODE"
    ldy #$00
    ldx #$00
    lda #$00
    sta Length
    sta SelectedEntityIndex
 
    @loop:
     ldx Length 
     cpx EntitieArrayLength
     beq @endloop
      
      jsr SELECTENTITY

      jsr RUNBEHAVIOUR
      
      jsr CleanMemory

     ldy  SelectedEntityIndex

     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 

     sty SelectedEntityIndex

     tya 

     ldx Length
     inx 
     stx Length 
    
   
      
    jmp @loop
    @endloop:

    jsr CleanMemory
rts


SELECTENTITY:
 
 ldy SelectedEntityIndex
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
 
 ;maybe store registers on the stack here
 jsr ModifyingCode


 ;load entitie index back into y
 ldy SelectedEntityIndex
  
 
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

;maybe put this in diverent file
CleanMemory:
 ldy #$00
 ldx #$00
 lda #$00
 ;clean local ram
 sta $00
 sta $01
 sta $02
 sta $03
 sta $04
 sta $05
 sta $08
 sta $09
 sta $0A
 sta $0B
 sta $0C
 sta $0D
 sta $0E
 sta $0F




 ldy #$00
 ldx #$00

rts
.endproc