    processor 6502
    seg Code
    org $F000

Start:
    lda #100

    clc ; Always clear the carry flag before calling adc
    adc #5

    sec ; Always set the carry flag before calling sbc
    sbc #10

    jmp Start ; Get in the habit of using an infinite loop to scrutinize instructions

    org $FFFC
    .word Start
    .word Start