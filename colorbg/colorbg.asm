    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

START:
    ;CLEAN_START ; Macro to safely clear the memory

    ; Set background luminosity color to yellow
    lda #$1E  ; Load color into A ($1E is NTSC yellow)
    sta COLUBK  ; Store A to Background Luminance Address $09

    jmp START ; Repeat from START

    org $FFFC
    .word START
    .word START