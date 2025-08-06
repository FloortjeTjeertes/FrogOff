; arguments
; 
; runs entitie behaviour
;
; inports: EntityArrayLength
; exports: xpos, ypos
;
; Local vars: Length, Adress, ModifyingCode
;
; uses: EntityArray


.export RUNENTITYBEHAVIOUR

EntityArray = $0400

; Length = $02
; Adress = $03 ;2 bytes
; SelectedEntityIndex =$05




.proc RUNENTITYBEHAVIOUR

.segment "LOCAL"
 
  
.zeropage 
 .importzp EntityArrayLength 
 .exportzp xpos, ypos

  xpos: .res 2
  ypos: .res 2
  ; Place ModifyingCode at a fixed, safe zero page address
  ModifyingCode = $F0  ; Use $F0-$F3 for the 4-byte indirect jump code
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
     cpx EntityArrayLength
     beq @endloop
      
      jsr SELECTENTITY

      jsr RUNBEHAVIOUR
      
      jsr CleanMemory

     ; Move to next entity (8 bytes per entity)
     lda SelectedEntityIndex
     clc
     adc #8
     sta SelectedEntityIndex

     ; Increment entity counter  
     inc Length
      
    jmp @loop
    @endloop:

    jsr CleanMemory
rts


SELECTENTITY:
 
 ldy SelectedEntityIndex
 ;Adress 2 bytes (word) in standard least significant byte first format
 lda EntityArray+3 ,y
 sta Adress
 lda EntityArray+4 ,y
 sta Adress+1

 ;Xposition 2 bytes (word)
 lda EntityArray+6 ,y
 sta xpos
 lda EntityArray+7 ,y
 sta xpos+1

 ;Yposition 2 bytes (word)
 lda EntityArray+8 ,y
 sta ypos
 lda EntityArray+9 ,y
 sta ypos+1

rts

RUNBEHAVIOUR:
 ; Store current registers to prevent corruption
 pha
 txa
 pha
 tya
 pha

 ; Build JSR instruction in a safe zero page area
 lda #$20           ; JSR opcode
 sta ModifyingCode
 lda Adress
 sta ModifyingCode+1
 lda Adress+1
 sta ModifyingCode+2
 lda #$60           ; RTS opcode
 sta ModifyingCode+3
 
 ; Call the AI function
 jsr ModifyingCode

 ; Restore registers
 pla
 tay
 pla
 tax
 pla

 ; Load entity index back into y
 ldy SelectedEntityIndex
  
 
 ;load posibly updated values back into array
 lda xpos
 sta EntityArray+5 ,y
 lda xpos+1
 sta EntityArray+6 ,y

 lda ypos
 sta EntityArray+7 ,y
 lda ypos+1
 sta EntityArray+8 ,y

rts

;maybe put this in diverent file
CleanMemory:
 ; Don't clear ANY zero page variables while entities are running!
 ; The ModifyingCode, xpos, ypos, etc. are all in zero page and being used
 
 ; Only clear non-zero page registers
 ldy #$00
 ldx #$00
 lda #$00

rts
.endproc