;
; 
; #$ForeGroundBackground,#$tileEntry, #$AIAddressLow , #$AIAddressHigh 
;
; #$ForeGroundBackground i might turn in a status byte where each bite desides properties of the entities  like foreground or background 
; 
; #%00000000
;   ||||||||
;   |||||||+----> 0 = background 1 = foreground
;   ||||||+-----> 0 = not used yet
;   |||||+------> 0 = not used yet
;   ||||+-------> 0 = not used yet
;   |||+--------> 0 = not used yet
;   ||+---------> 0 = not used yet
;   |+----------> 0 = not used yet
;   +-----------> 0 = not used yet

.import PLAYERPHYSICS
.import FLYPHYSICS

Entities:
.byte 00000001 ;status byte
.byte 00       ; 
.addr PLAYERPHYSICS
.byte 00000001 ;status byte
.byte 03       ; 
.addr FLYPHYSICS
.byte 00000001 ;status byte
.byte 01       ; 
.addr PLAYERPHYSICS
