    processor 6502
    seg Code
    org $F000

Start:
    ldy #10

Loop:
    tya
    sta $80,Y ; Store A in $80 + Y (indexed addressing mode)
    dey ; Decrement Y
    bpl Loop  ; Branch if PLus to Loop label (if dey has a positive result)
              ; When dey sets the negative flag, the looping behavior will end
    jmp Start

    org $FFFC
    .word Start
    .word Start