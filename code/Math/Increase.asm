;increase 16bit value whit a 8bit step value
ValueToIncrease = $0
StepValue = $2


.export INCREASE
.export ValueToIncrease, StepValue
.proc INCREASE
	clc		
	lda ValueToIncrease+1
	adc StepValue
	sta ValueToIncrease+1
    bcc @CONTINUE             
    inc ValueToIncrease
    @CONTINUE:
rts
.endproc