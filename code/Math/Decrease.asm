;decrease 16bit value whit a 8bit step value
;
 ValueToIncrease = $0
 StepValue = $2
.export DECREASE


.proc DECREASE
 	clc		
	lda ValueToIncrease+1
	sbc #StepValue
	sta ValueToIncrease+1
    bcc @CONTINUE             
    dec ValueToIncrease
    @CONTINUE:
rts 
.endproc
