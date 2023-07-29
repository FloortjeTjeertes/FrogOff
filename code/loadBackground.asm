.export LOADBACKGROUND

PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007
PPUMASK = $2001

.zeropage

MapDataAddress: .res 2
PalleteAdress: .res 2

.segment "CODE"
.proc LOADBACKGROUND

 jsr GetBackgroundFromArray
 jsr LoadBackgroundPalletes
 jsr SetBackground


rts

GetBackgroundFromArray:

  ; make this use the table
  lda #<MAPDATA
  sta MapDataAddress
  lda #>MAPDATA
  sta MapDataAddress+1

  lda #<PALLETE
  sta PalleteAdress
  lda #>PALLETE
  sta PalleteAdress+1

rts

ldy #$00
LoadBackgroundPalletes:
  lda (PalleteAdress), y
  sta $2007 ; PPUDATA memory address to wright data to ppu (ppu puts this value in the adress defined in memory address from $2006) ppu auto increments memory address in $2006 on every wright in $2007
  iny 
  cpy #$10
  bne LoadBackgroundPalletes
rts

Increase:
   lda MapDataAddress+1
     adc #$00
     sta MapDataAddress+1

     lda MapDataAddress
     adc #$FF
     sta MapDataAddress
rts




SetBackground:

  lda #%00000000   ;enable sprites and backgrounds for left most 8 pixels
  sta PPUMASK
  sei

   lda #$28
   sta PPUADDR ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
   lda #$C0
   sta PPUADDR ;store least significant value 00 in ppu write address ..00

   ldx #$00
  

   lda #$20    ; load the value 32 into the accumulator
   sta PPUADDR   ; store the most significant byte in the PPU write address (0x2006)
   lda #$00    ; load the value 0 into the accumulator
   sta PPUADDR   ; store the least significant byte in the PPU write address (0x2006)
  
   ldy #$00    ; load the value 0 into the Y register




  
   :
     lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA              ; store the value in the PPU data register (0x2007)
     iny                      ; increment the Y register
     cpy #$FF                 ; compare Y with the value 4096 (the size of a nametable in bytes)
   bne :-

   ldy #$00    ; load the value 0 into the Y register



    jsr Increase

   :


     lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA         ; store the value in the PPU data register (0x2007)
     iny                 ; increment the Y register
     cpy #$FF 
   bne :-
   
   ldy #$00    ; load the value 0 into the Y register

       jsr Increase


    :
     lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA   ; store the value in the PPU data register (0x2007)
     iny         ; increment the Y register
     cpy #$FF 
    bne :-
    
     lda MapDataAddress+1
     adc #$00
     sta MapDataAddress+1

     lda MapDataAddress
     adc #$FF
     sta MapDataAddress
  

    :
     lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA   ; store the value in the PPU data register (0x2007)
     iny         ; increment the Y register
     cpy #$FF 
    bne :-



  

 

   lda #$00
   sta PPUSCROLL
   lda #$00
   sta PPUSCROLL

  cli
 
rts

.include "backgrounds.asm"


.endproc

