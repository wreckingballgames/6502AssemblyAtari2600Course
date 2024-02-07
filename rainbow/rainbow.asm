    processor 6502
    
    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

Start:
    CLEAN_START

    ; Start a new frame by turning on VBLANK and VSYNC
NextFrame:
    lda #2  ; Same as binary value %00000010
    sta VBLANK  ; Turn on VBLANK ($01)
    sta VSYNC ; Turn on VSYNC ($00)

    ; Generate the three lines of VSYNC
    sta WSYNC   ; First scanline ($02)
    sta WSYNC   ; Second scanline
    sta WSYNC   ; Third scanline

    lda #0
    sta VSYNC   ; Turn off VSYNC

    ; Let the TIA output the recommended 37 scanlines of VBLANK
    ldx #37   ; X = 37 (to count 37 scanlines)
LoopVBlank:
    sta WSYNC   ; Hit WSYNC and wait for the next scanline
    dex         ; X--
    bne LoopVBlank  ; Branch if Not Equal (last instruction did not set Zero flag)

    lda #0
    sta VBLANK  ; Turn off VBLANK

    ; Draw 192 visible scanlines
    ldx #192  ; X = 192 (to count visible scanlines)
LoopVisible:
    stx COLUBK    ; Store a color in Color-Luminance Background address ($09)
    ;(using x is an elegant way to do a different color on every scanline)
    sta WSYNC
    dex   ; X--
    bne LoopVisible   ; Loop while X != 0

    ; Output 30 VBLANK overscan lines
    lda #2
    sta VBLANK

    ldx #30
LoopOverscan:
    sta WSYNC
    dex
    bne LoopOverscan

    jmp NextFrame

    ;Complete my ROM size to 4KB
    org $FFFC
    .word Start
    .word Start