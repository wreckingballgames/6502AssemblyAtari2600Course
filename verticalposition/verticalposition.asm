    processor 6502

    include "vcs.h"
    include "macro.h"

    ; Start an uninitialized segment at $80 for var declaration.
    ; We have memory from $80 to $FF to work with, minus a few at
    ; the end if we use the stack.
    seg.u Variables
    org $80 ; Start of RIOT RAM (top half of zero page)
P0Height byte  ; Player sprite height
PlayerYPos byte ; Player sprite Y coordinate

  ; Start our ROM code segment
    seg Code
    org $F000

Reset:
    CLEAN_START

    ldx #$00
    stx COLUBK

    ; Initialize Variables
    lda #$B4
    sta PlayerYPos  ; PlayerYPos = #180 (#$B4)

    lda #$09
    sta P0Height  ; P0Height = #9 (#$09)

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

    ; Draw the 192 visible scanlines
    ldx #$C0  ; #192 = #$C0

Scanline:
    txa
    sec ; Always set the carry flag before subtracting
    sbc PlayerYPos  ; Subtract sprite Y coordinate
    cmp P0Height  ; Are we inside the sprite height bounds?
    bcc LoadBitmap  ; If result < SpriteHeight, branch to LoadBitmap (skip zeroing the accumulator)
    lda #$00

LoadBitmap:
    tay
    lda P0Bitmap,Y  ; P0Bitmap address + difference of current scanline and P0Height; load current slice of lookup table

    sta WSYNC ; Wait for next scanline

    sta GRP0  ; Set graphics for player 0 slice

    lda P0Color,Y ; Load player color from lookup table

    sta COLUP0  ; Set color for player 0 slice

    dex
    bne Scanline  ; If X is 0 (if all visible scanlines processed) then stop branching

Overscan:
    lda #$02
    sta VBLANK

    REPEAT 30
      sta WSYNC
    REPEND

    ; Decrement player Y coordinate
    dec PlayerYPos

    jmp StartFrame

; Lookup table for the player graphics bitmap
P0Bitmap:
    byte #$00
    byte #$28
    byte #$74
    byte #$FA
    byte #$FA
    byte #$FA
    byte #$FE
    byte #$6C
    byte #$30

; Lookup table for the player colors
P0Color:
    byte #$00
    byte #$40
    byte #$40
    byte #$40
    byte #$40
    byte #$42
    byte #$42
    byte #$44
    byte #$D2

    org $FFFC
    .word Reset
    .word Reset