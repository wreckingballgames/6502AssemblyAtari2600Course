    processor 6502
    seg Code
    org $F000

Start:
    lda #1

Loop:
    clc
    adc #1
    cmp #10
    bne Loop

    jmp Start

    org $FFFC
    .word Start
    .word Start