; arguments
; 
; runs entitie behaviour
;
; inports: EntityArrayLength
; exports: xpos, ypos
;
; Local vars: Length, Address, ModifyingCode
;
; uses: EntityArray


.export RUNENTITYBEHAVIOUR

EntityArray = $0400

; Length = $02
; Address = $03 ;2 bytes
; SelectedEntityIndex =$05




.proc RUNENTITYBEHAVIOUR

.segment "LOCAL"
 
  
.zeropage 
 .importzp EntityArrayLength 
 .exportzp xpos, ypos

  xpos: .res 2
  ypos: .res 2
  ModifyingCode: .res 4
  ;maybe store these on the stack later
  Length: .res 2
  Address:.res 2
  SelectedEntityIndex: .res 1
.segment "CODE"
    ldy #$00
    ldx #$00
    lda #$00
    sta Length
    sta SelectedEntityIndex
 
    @loop:
     ldx Length 
     cpx EntityArrayLength
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
 ;Address 2 bytes (word)
 lda EntityArray+3 ,y
 sta Address
 lda EntityArray+4 ,y
 sta Address+1

 ;Xposition 2 bytes (word)
 lda EntityArray+5 ,y
 sta xpos
 lda EntityArray+6 ,y
 sta xpos+1

 ;Yposition 2 bytes (word)
 lda EntityArray+7 ,y
 sta ypos
 lda EntityArray+8 ,y
 sta ypos+1

rts

RUNBEHAVIOUR:

 
 lda #$20
 sta ModifyingCode
 lda Address
 sta ModifyingCode+1
 lda Address+1
 sta ModifyingCode+2

 lda #$60
 sta ModifyingCode+3
 
 ;maybe store registers on the stack here
 jsr ModifyingCode


 ;load entitie index back into y
 ldy SelectedEntityIndex
  
 
 ;load posibly updated values back into array
 lda xpos
 sta EntityArray+4 ,y
 lda xpos+1
 sta EntityArray+5 ,y

 lda ypos
 sta EntityArray+6 ,y
 lda ypos+1
 sta EntityArray+7 ,y

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