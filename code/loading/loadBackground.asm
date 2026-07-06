.export LOADBACKGROUND

PPUSCROLL = $2005
PPUADDR = $2006
PPUDATA = $2007
PPUMASK = $2001
temp = $00
; MapDataAddress = $00
; PalleteAddress = $02
.proc LOADBACKGROUND
.zeropage
  MapDataAddress: .res 2
  PalleteAddress: .res 2


.segment "CODE"
   
    jsr GetBackgroundFromArray
    jsr LoadBackgroundPalletes
    jsr SetBackground


rts

;uses y as index to get the background from the array
GetBackgroundFromArray:
  sta temp
  cpy temp
  beq :+
  inx 
  inx 
  inx 
  inx 
  iny 
  tya 
  sta temp
  :

  

  lda BACKGROUNDLIST, x
  sta MapDataAddress
  lda BACKGROUNDLIST+1, x
  sta MapDataAddress+1

  lda BACKGROUNDLIST+2, x
  sta PalleteAddress
  lda BACKGROUNDLIST+3, x
  sta PalleteAddress+1

rts

LoadBackgroundPalletes:
  ; reset the PPU address latch before writing the palette address
  bit $2002
  lda #$3F
  sta $2006
  lda #$00
  sta $2006

  ldy #$00
LoadBackgroundPalletesLoop:
  lda (PalleteAddress), y
  sta $2007 ; write palette byte into PPU palette memory
  iny
  cpy #$10
  bne LoadBackgroundPalletesLoop

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




  
    :lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA              ; store the value in the PPU data register (0x2007)
     iny                      ; increment the Y register
     cpy #$FF                 ; compare Y with the value 4096 (the size of a nametable in bytes)
    bne :-

   ldy #$00    ; load the value 0 into the Y register



    jsr Increase

    :lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA         ; store the value in the PPU data register (0x2007)
     iny                 ; increment the Y register
     cpy #$FF 
    bne :-
   
    ldy #$00    ; load the value 0 into the Y register

    jsr Increase


    :lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA   ; store the value in the PPU data register (0x2007)
     iny         ; increment the Y register
     cpy #$FF 
    bne :-
    
    

    
    ldy #$00    ; load the value 0 into the Y register
    jsr Increase


    :lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA   ; store the value in the PPU data register (0x2007)
     iny         ; increment the Y register
     cpy #$FF 
    bne :-
  
  ldy #$00
  jsr Increase

   :lda (MapDataAddress),y   ; load the value at the address stored in X and Y into the accumulator
     sta PPUDATA   ; store the value in the PPU data register (0x2007)
     iny         ; increment the Y register
     cpy #$04 
    bne :-

 

   lda #$00
   sta PPUSCROLL
   lda #$00
   sta PPUSCROLL

  cli
 
rts


.include "../Lists/backgrounds.asm"


.endproc

