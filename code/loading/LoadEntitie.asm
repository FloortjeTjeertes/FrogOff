; loads entities into a list ot be used by the stage.
; the entities in this stage will be accessed and there behavior will be called by the stage.
; the entities loaded from a list of entities in the format .
; #$ForeGroundBackground,#$tileEntry, #$AIAddressLow , #$AIAddressHigh 
;
;               +===========+
;               |  EXPORTS  |                         
;               +===========+
;  EntitieArrayLength = the amount of entities in the Array/Stage
;
;



EntitieArray = $03FF
MaxLength = 10

.export LOADENTITIE

.proc LOADENTITIE
.zeropage
  .exportzp EntitieArrayLength , EmptySpace
  EntitieArrayLength: .res 1
  EmptySpace: .res 1

.segment "CODE"
 ldx #$00

 ldy EntitieArrayLength

 ;if index is first place in array skip empty space check
 cmp #$00 
 beq @LOAD

 ;if the index is not the same as the empty space do not use the empty space index as the index
 cmp EmptySpace
 bne @LOAD
 ldy EmptySpace

@LOAD:
    iny 

    ;load options into the array
    lda Entities,x
    sta EntitieArray,y

    ;load the tile entry
    lda Entities+1,x
    sta EntitieArray+1,y

    ;load the AI address low byte
    lda Entities+2,x
    sta EntitieArray+2,y

    ;load the AI address high byte
    lda Entities+3,x
    sta EntitieArray+3,y
rts 


.include "../Lists/Entities.asm"

.endproc

