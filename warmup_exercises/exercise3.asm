    processor 6502
    seg Code
    org $F000

Start:
    lda #15

    tax
    tay
    txa
    tya

    ldx #6
    txa
    tay

    jmp Start ; I have no clue why it won't compile without this jmp

    .org $FFFC
    .word Start
    .word Start