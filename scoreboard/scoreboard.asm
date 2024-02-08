    processor 6502

    include "macro.h"
    include "vcs.h"

    ; Start an uninitialized segment at $80 for variable declaration
    seg.u Variables
    org $80
P0Height ds 1 ; Defines one byte for player 0 height
P1Height ds 1 ; Defines one byte for player 1 height


    seg code
    org $F000

Reset:
    CLEAN_START

    ldx #$86  ; Set background to blue
    stx COLUBK

    lda #$0F   ; Set playfield to white
    sta COLUPF

    lda #$0A      ; A = #10
    sta P0Height  ; P0Height = #10
    sta P1Height  ; P1Height = #10

    lda #$48  ; Set player 0 color to light red
    sta COLUP0

    lda #$C6  ; Set player 1 color to light green
    sta COLUP1

    ldy #%00000010  ; CTRLPF D1 set to 1 means (score)
    sty CTRLPF

StartFrame:
    lda #$02  ; Turn VBLANK and VSYNC on
    sta VBLANK
    sta VSYNC

    REPEAT 3  ; Three frames of VSYNC before turning it off
      sta WSYNC
    REPEND
    lda #$00
    sta VSYNC

    REPEAT 37 ; 37 frames of VBLANK before turning it off
      sta WSYNC
    REPEND
    lda #$00
    sta VBLANK

VisibleScanlines:
    ; Display 10 empty scanlines
    REPEAT 10
      sta WSYNC
    REPEND

    ; Display 10 scanlines for the scoreboard number.
    ; Pulls data from an array of bytes defined at NumberBitmap.
    ldy #$00
ScoreboardLoop:
    lda NumberBitmap,Y  ; NumberBitmap address + value of register Y
    sta PF1
    sta WSYNC
    iny ; Increment Y
    cpy #$0A  ; Is Y 10? (Have we looped 10 times?)
    bne ScoreboardLoop  ; If not, repeat ScoreboardLoop

    lda #$00
    sta PF1 ; Disable playfield

    ; Draw 50 empty scanlines
    REPEAT 50
      sta WSYNC
    REPEND

    ldy #$00
Player0Loop:
    lda PlayerBitmap,Y
    sta GRP0  ; Graphics Register Player 0
    sta WSYNC
    iny
    cpy P0Height
    bne Player0Loop

    lda #$00
    sta GRP0  ; Disable player 0 graphics

    ldy #$00
Player1Loop:
    lda PlayerBitmap,Y
    sta GRP1  ; Graphics Register Player 1
    sta WSYNC
    iny
    cpy P1Height
    bne Player1Loop

    lda #$00
    sta GRP1  ; Disable player 1 graphics

    ; Draw the remaining 102 scanlines (192 - 90)
    REPEAT 102
      sta WSYNC
    REPEND

    ; 30 VBLANK overscan lines
    REPEAT 30
      sta WSYNC
    REPEND

    jmp StartFrame
    
    org $FFE0
PlayerBitmap:
    .byte #$7E
    .byte #$FF
    .byte #$99
    .byte #$FF
    .byte #$FF
    .byte #$FF
    .byte #$BD
    .byte #$C3
    .byte #$FF
    .byte #$7E

    org $FFF2
NumberBitmap:
    .byte #$0E
    .byte #$0E
    .byte #$02
    .byte #$02
    .byte #$0E
    .byte #$0E
    .byte #$08
    .byte #$08
    .byte #$0E
    .byte #$0E

    org $FFFC
    .word Reset
    .word Reset