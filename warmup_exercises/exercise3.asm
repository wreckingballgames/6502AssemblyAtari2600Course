    processor 6502
    seg Code
    org $F000

Start:
    lda #15
    tax
    tay
    txa
    tya

    .org $FFFC
    .word Start
    .word Start