    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

Reset:
    CLEAN_START

    ldx #$86    ; Blue color
    stx COLUBK  ; Set Color Luminance of Background

    lda #$1C    ; Yellow colow
    sta COLUPF  ; Set Color Luminance of Playfield

StartFrame:
    lda #$02
    sta VBLANK
    sta VSYNC

    ; Wait for three VSYNC scanlines
    ; DASM has this REPEAT block command that's neat
    ; Consider use cases for looping by hand and definitely look at how these commands really work
    REPEAT 3
        sta WSYNC
    REPEND

    lda #$00
    sta VSYNC

    REPEAT 37
        sta WSYNC
    REPEND
    sta VBLANK

    ; Set the CRLPF register to allow playfield reflection
    ldx #$01  ; CTRLPF register (D0 means reflect the PF)
    stx CTRLPF

    ; Draw the 192 visible scanlines

    ; Skip 7 scanlines with no PF set
    ldx #$00
    stx PF0 ; $0D
    stx PF1 ; $0E
    stx PF2 ; $0F
    REPEAT 5
        sta WSYNC
    REPEND

    ; Set the PF0 to 1110 (LSB first) and PF1-PF2 as 1111 1111
    ldx #$E0
    stx PF0

    ldx #$FF
    stx PF1
    stx PF2
    REPEAT 5
      sta WSYNC
    REPEND

    ; Set the next 164 lines only with PF0 third bit enabled
    ldx #$60
    stx PF0

    ldx #$00
    stx PF1

    ldx #$80
    stx PF2
    REPEAT 164
      sta WSYNC
    REPEND

    ; Set the PF0 to 1110 (LSB first) and PF1-PF2 as 1111 1111
    ldx #$E0
    stx PF0

    ldx #$FF
    stx PF1
    stx PF2
    REPEAT 5
      sta WSYNC
    REPEND

    ; Skip 5 vertical lines with no PF set
    ldx #$00
    stx PF0
    stx PF1
    stx PF2
    REPEAT 5
      sta WSYNC
    REPEND

    ; Output 30 more VBLANK overscan lines to complete our frame
    lda #$02
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND

    jmp StartFrame

    org $FFFC
    .word Reset
    .word Reset