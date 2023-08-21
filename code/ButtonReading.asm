.export READCONTROLLER


JOYPAD1 = $4016
JOYPAD2 = $4017
CONTROLLER =$2000



.proc READCONTROLLER



.zeropage
  .exportzp  PRESSEDBUTTONS1 ,RELEASEDBUTTONS1

  LASTFRAMEBUTTONS1: .res 1
  PRESSEDBUTTONS1: .res 1
  RELEASEDBUTTONS1: .res 1
  @buttons: .res 1


.segment "CODE"
;shifts 1 every loop until 8 bits are shifted from the nes controller
;the status of the controller is stored every loop in the @buttons
    lda #$01 
    sta JOYPAD1 ;write 1 to joypad 1
    sta @buttons ;write 1 to @buttons
    lsr a   ; shifts 1 out of acumulator to make acumulator 0
    sta JOYPAD1 ;write aculumator (0) to joypad 1 (clears strobe bit and controller will keep stored value (pressed @buttons) static
    :                                                                    
      lda JOYPAD1 ;read joypad 1 into acumulator                           
      lsr a ;shift left shifts red byte to form a full 8 bits of the read controller                                                
      rol @buttons ;shift left to eventually put 1 in carry (looping trough all bits in the @buttons variable)      
    bcc :- ;branch to last ":" if carry flag is not set
    
    lda @buttons ;load @buttons into acumulator
    sta PRESSEDBUTTONS1

    ;Comparesthelastframebuttons with the current frame buttons
    ;might seperate this into a seperate function
    ;
    ; lda @buttons
    ; eor #%11111111
    ; and LASTFRAMEBUTTONS1
    ; sta RELEASEDBUTTONS1
    ; lda LASTFRAMEBUTTONS1
    ; eor #%11111111
    ; and @buttons
    ; sta PRESSEDBUTTONS1
rts

.endproc
