; loads entities into a list ot be used by the stage.
; the entities in this stage will be accessed and there behavior will be called by the stage.
; the entities loaded from a list of entities in the format .
; #$ForeGroundBackground,#$tileEntry, #$AIAddressLow , #$AIAddressHigh 
EntitieArray = $0400

.export LOADENTITIES

.proc LOADENTITIES


rts 




.endproc

