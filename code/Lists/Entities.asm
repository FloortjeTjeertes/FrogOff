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

EntityLlength = 4

.import PLAYERPHYSICS
.import FLYPHYSICS

Entities:
.byte 00000001 ;status byte
.byte 01     ; 
.byte 00
; .addr Animations
.addr PLAYERPHYSICS

.byte 00000001 ;status byte
.byte 03       ;
.byte 00 
; .addr Animations
.addr FLYPHYSICS

.byte 00000001 ;status byte
.byte 01       ; 
.byte 00
.addr PLAYERPHYSICS

.byte 00000001 ;status byte
.byte 03       ;
.byte 00     
.addr FLYPHYSICS


;maybe us a table whit pointers pointing to the start of each entities data



;look up table for the animations that the entities can use
Animations:

.addr Animation

.include "../Lists/Animations.asm"
