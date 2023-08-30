;adds 2 16-bit numbers


    num1 = $00
	num2 = $02
	result := $04
.export ADD
.proc ADD
 
    clc				; clear carry
	lda num1+1
	adc num2+1			; add the LSBs
	sta result+1		; store sum of LSBs
	lda num1
	adc num2			; add the MSBs using carry from
	sta result			; the previous calculation
rts
.endproc