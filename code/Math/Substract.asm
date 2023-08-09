; Substracts two 16-bit numbers
    num1 = $00 
	num2 = $02
	result = $04
.export SUBTRACT
.export num1, num2, result
    
.proc SUBTRACT
    sec				    ; set carry for borrow purpose
	lda num1+1
	sbc num2+1			; perform subtraction on the LSBs
	sta result+1
	lda num1			; do the same for the MSBs, with carry
	sbc num2			; set according to the previous result
	sta result
rts
.endproc