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
EntityArray = $0400 
MaxLength = 10
Index = $00

.export LOADENTITIE

.proc LOADENTITIE
.zeropage
  .exportzp EntityArrayLength ;, EmptySpace
  EntityArrayLength: .res 1
  TempEntityNum: .res 1

.segment "CODE"
@LOAD:
    stx TempEntityNum ; Store the current entity number in TempEntityNum

    lda EntityArrayLength ;load the length of the entity array     
    asl 
    asl 
    asl 
    clc 
    adc EntityArrayLength
    tay ; Y = offset for next entity (Length * 9 for runtime storage)

    ; Calculate source entity offset (entity number * 4 for source data)
    ; lda Length
    lda TempEntityNum 
    asl 
    asl  
    tax ; X = source offset (Length * 4)


    ;load entity data from the entities list
    ;maybe us a table with pointers pointing to the start of each entities data

    ;load options into the array
    lda Entities,x
    sta EntityArray,y

    ;load the tile entry low byte
    lda Entities+1,x
    sta EntityArray+1,y

    ;load the tile entry high byte
    lda Entities+2,x
    sta EntityArray+2,y
    

    ;load the AI address low byte
    lda Entities+3,x
    sta EntityArray+3,y

    ;load the AI address high byte
    lda Entities+4,x
    sta EntityArray+4,y

    ;set the position of the entity to 0 (16 bites per coordinate)
    ;clear the position
    lda #$00 

    ;set X position
    sta EntityArray+5,y
    sta EntityArray+6,y
    
    ;set Y position
    sta EntityArray+7,y
    sta EntityArray+8,y

  
    inc EntityArrayLength
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

