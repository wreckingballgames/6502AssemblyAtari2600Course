    processor 6502

    include "vcs.h"
    include "macro.h"

    seg.u Variables
    org $80
P0Height byte
PlayerYPos byte

    seg Code
    org $F000

Reset:
    CLEAN_START

    ldx #$86
    stx COLUBK

    ; Initialize variables
    lda #$B4
    sta PlayerYPos

    lda #$0C
    sta P0Height

StartFrame:
    lda #$02
    sta VBLANK
    sta VSYNC

    REPEAT 3
      sta WSYNC
    REPEND
    lda #$00
    sta VSYNC

    REPEAT 37
      sta WSYNC
    REPEND
    lda #$00
    sta VBLANK

    ; 192 visible scanlines
    ldx #$C0

Scanline:
    txa
    sec
    sbc PlayerYPos
    cmp P0Height
    bcc LoadBitmap
    lda #$00

LoadBitmap:
    tay
    lda P0Bitmap,Y

    sta WSYNC

    sta GRP0

    lda P0Color,Y

    sta COLUP0

    dex
    bne Scanline

Overscan:
    lda #$02
    sta VBLANK

    REPEAT 30
      sta WSYNC
    REPEND

    dec PlayerYPos

    jmp StartFrame

; Lookup table for player 0 graphics bitmap
P0Bitmap:
    byte #$00
    byte #$24
    byte #$42
    byte #$42
    byte #$66
    byte #$24
    byte #$24
    byte #$18
    byte #$18
    byte #$18
    byte #$66
    byte #$00

; Lookup table for the player 0 colors
P0Color:
    byte #$00
    byte #$1E
    byte #$1E
    byte #$1C
    byte #$1E
    byte #$1A
    byte #$1A
    byte #$1A
    byte #$1A
    byte #$1A
    byte #$1A
    byte #$86

    org $FFFC
    .word Reset
    .word Reset