.export LOADBACKGROUND

.zeropage
    .exportzp MapDataAddress

MapDataAddress: .res 2

.segment "CODE"
.proc LOADBACKGROUND

 lda #%00000000   ;enable sprites and backgrounds for left most 8 pixels
 sta $2001
 sei

  lda #$28
  sta $2006 ;store most significant value 3f in ppu write address 3f.. (the adress where you store the address you want to write too in the ppu)
  lda #$C0
  sta $2006 ;store least significant value 00 in ppu write address ..00

  ldx #$00
  

  lda #$20    ; load the value 32 into the accumulator
  sta $2006   ; store the most significant byte in the PPU write address (0x2006)
  lda #$00    ; load the value 0 into the accumulator
  sta $2006   ; store the least significant byte in the PPU write address (0x2006)
  
  ldx #$00    ; load the value 0 into the X register

  
  :
    lda MAPDATA,x   ; load the value at the address stored in X and Y into the accumulator
    sta $2007   ; store the value in the PPU data register (0x2007)
    inx         ; increment the X register
    cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-

 ldx #$00    ; load the value 0 into the X register


  :
    lda MAPDATA+255,x   ; load the value at the address stored in X and Y into the accumulator
    sta $2007   ; store the value in the PPU data register (0x2007)
    inx         ; increment the X register
    cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
   
  ldx #$00    ; load the value 0 into the X register

  :
    lda MAPDATA+510,x   ; load the value at the address stored in X and Y into the accumulator
    sta $2007   ; store the value in the PPU data register (0x2007)
    inx         ; increment the X register
    cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
  ldx #$00    ; load the value 0 into the X register
   :
    lda MAPDATA+765,x   ; load the value at the address stored in X and Y into the accumulator
    sta $2007   ; store the value in the PPU data register (0x2007)
    inx         ; increment the X register
    cpx #$FF ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
  
  ldx #$00    ; load the value 0 into the X register
    :
    lda MAPDATA+1020,x   ; load the value at the address stored in X and Y into the accumulator
    sta $2007   ; store the value in the PPU data register (0x2007)
    inx         ; increment the X register
    cpx #$05 ; compare X with the value 4096 (the size of a nametable in bytes)
  bne :-
 

  cli

rts
MAPDATA:
 .incbin "../resource/titleScreen.nam"

.endproc

