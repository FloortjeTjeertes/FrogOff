; loads entities into a list to be used by the stage.
; the entities in this stage     ;set the position of the entity to 0 (16 bits per coordinate)
    ;X position
    lda #$00
    sta EntityArray+4,y
    sta EntityArray+5,y
    
    ;Y position
    sta EntityArray+6,y
    sta EntityArray+7,y ;accessed and their behavior will be called by the stage.
; the entities loaded from a list of entities in the format .
; #$ForeGroundBackground,#$tileEntry, #$AIAddressLow , #$AIAddressHigh 
;
; stores in format 
; #$ForeGroundBackground,#$tileEntry, #$AIAddressLow , #$AIAddressHigh , #$XPositionLow , #$XPositionHigh , #$YPositionLow , #$YPositionHigh
;               +===========+
;               |  EXPORTS  |                         
;               +===========+
;  EntityArrayLength = the amount of entities in the Array/Stage
;
;


;start address of entity array
EntityArray = $03F8 
MaxLength = 10
Index = $00

.export LOADENTITIE

.proc LOADENTITIE
.zeropage
  .exportzp EntityArrayLength , EmptySpace
  EntityArrayLength: .res 1
  EmptySpace: .res 1
  Length: .res 1
  

.segment "CODE"
 ldy #$00


 lda EntityArrayLength
 ;if index is first place in array skip empty space check
 cmp #$00 
 beq @LOAD
 
;  jsr @increaser

 ;if the index is not the same as the empty space do not use the empty space index as the index
 cmp EmptySpace
 bne @LOAD
 ldy EmptySpace
@LOAD:
    lda Length
    tay 


    iny 
    iny 
    iny 
    iny 
    iny 
    iny 
    iny 
    iny     

    ;maybe us a table whit pointers pointing to the start of each entities data

    ;load options into the array
    lda Entities,x
    sta EntityArray,y

    ;load the tile entry low byte
    lda Entities+1,x
    sta EntityArray+1,y

    lda Entities+2,x
    sta EntityArray+2,y
    

    ;load the AI address low byte
    lda Entities+3,x
    sta EntityArray+3,y

    ;load the AI address high byte
    lda Entities+4,x
    sta EntityArray+4,y




    ;set the position of the entity to 0 (16 bites per coordinate)
    ;X position
    lda #$00
    sta EntityArray+5,y
    sta EntityArray+6,y
    
    ;Y position
    sta EntityArray+7,y
    sta EntityArray+8,y

  
    inc EntityArrayLength


    
    tya 
    sta Length
rts 

@increaser:
  :
    cpx EntityArrayLength
    bne @skip
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny 
     iny  
     inx    
    bne  :-
  @skip:
rts






.include "../Lists/Entities.asm"

.endproc

