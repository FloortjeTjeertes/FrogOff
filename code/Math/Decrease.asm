;decrease 16bit value whit a 8bit step value
;
 ValueToDeCrease = $0
 StepValue2 = $2
.export DECREASE
.export  ValueToDeCrease  ,StepValue2

.proc DECREASE
 	clc		
	lda ValueToDeCrease+1
	sbc #StepValue2
	sta ValueToDeCrease+1
    bcc @CONTINUE             
    dec ValueToDeCrease
    @CONTINUE:
rts 
.endproc
