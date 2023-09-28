.export PLAYERPHYSICS

.proc FLYPHYSICS

.zeropage 
.importzp xpos , ypos

.segment "CODE"

lda xpos
adc 
rts

.endproc