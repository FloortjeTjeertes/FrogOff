BACKGROUNDLIST:
    .addr MAPDATA
    .addr PALLETE
    .addr DebugSreen ; 960 = 30*32
    ; .addr MAPDATA+960  ; 960 = 30*32
    .addr PALLETE



;==============================================================================
MAPDATA:
 .incbin "../../resource/nameTables/titleScreen.nam"
DebugSreen:
 .incbin "../../resource/nameTables/Debug.nam"


PALLETE:
 .incbin "../../resource/palletes/TitleScreenPallete.bin"




