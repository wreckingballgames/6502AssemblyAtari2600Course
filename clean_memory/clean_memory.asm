; Clean the zero page memory of Atari VCS.
	processor 6502

	seg code
	org $F000	; Define the code origin at $F000

start:
	sei	; Disable interrupts
	cld	; Disable BCD decimal math mode
	ldx #$FF	; Load the X register with #$FF
	txs	; Transfer X register's contents to stack pointer

; Clear the page zero region of memory ($00 to $FF).
; That includes all of RAM and the TIA's registers.
; Assumes X register contains #$FF
	lda #0	; A = 0
clean_memory_loop:
	sta $0,x	; Write contents of A (#0) to address in X
	dex	; X--
	bne clean_memory_loop	; if zero flag is not set, branch to clean_memory_loop (loop until X = 0)

; Fill the ROM size to exactly 4KB
	org $FFFC
	.word start	; Reset vector at $FFFC (where the program starts)
	.word start	; Interrupt vector at $FFFE (unused by Atari VCS)
