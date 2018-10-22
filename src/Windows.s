; ----------------------------------------------------------------------------
; Vocabulaire WINDOWS

.ifdef With::WINDOWS_VOC

	.ifdef Included::WINDOWS
		.out "Ajout entête du vocabulaire WINDOWS"

		; ----------------------------------------------------------------------------
		; WINDOWS
		; ----------------------------------------------------------------------------
			vocabulary_pfa "WINDOWS"

	.else
		.out "Ajout du vocabulaire WINDOWS"
		Included::WINDOWS = 1

		; ----------------------------------------------------------------------------
		; WINDOWS
		; ----------------------------------------------------------------------------
		vocabulary "WINDOWS",, immediate

		; ----------------------------------------------------------------------------
		; WINDOW:
		; ----------------------------------------------------------------------------
		declare "WINDOW:", "WINDOWCOL"
		        .word   DOCOL
		        .word   BUILDS
		        .word   ROT
		        .word   TOR
		        .word   ROT
		        .word   CCOMMA
		        .word   RFROM
		        .word   CCOMMA
		        .word   SWAP
		        .word   CCOMMA
		        .word   CCOMMA
		        .word   LIT
		        .word   SCRTXT
		        .word   COMMA
		        .word   DOES
		DOWINDOW:
		        .word   AYX
		        .word   TWOSTORE
		        .word   LIT
		        .word   XSCRSE
		        .word   MON
		        .word   LIT
		        .word   XCSSCR
		        .word   MON
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; MSGW
		; ----------------------------------------------------------------------------
		declare "MSGW"
		        .word   DODOES
		        .word   DOWINDOW
		        .byte   $00,$27,$00,$00,$80,$BB

		; ----------------------------------------------------------------------------
		; SCRW
		; ----------------------------------------------------------------------------
		declare "SCRW"
		        .word   DODOES
		        .word   DOWINDOW
		        .byte   $00,$27,$01,$1B,$80,$BB

		; ----------------------------------------------------------------------------
		; CURSOR
		; ----------------------------------------------------------------------------
		code "CURSOR"
		LE594:
		        stx     _XSAVE
		        lsr     BOT,x
		        lda     SECOND,x
		        tax
		        bcc     LE5A2
		        brk
		       .byte    XCSSCR                    ; Telemon
		        jmp     LE5A4

		LE5A2:
		        brk
		       .byte    XCOSCR                    ; Telemon
		LE5A4:
		        ldx     _XSAVE
		        jmp     POPTWO

		; ----------------------------------------------------------------------------
		; SCROLL
		; ----------------------------------------------------------------------------
		code "SCROLL"
		LE5B4:
		        lda     #$04
		        jsr     SETUP
		        stx     _XSAVE
		        lda     N+6
		        sta     SCRNB
		        ldx     N+4
		        ldy     N+2
		        lda     N
		        bne     LE5CC
		        brk
		       .byte   XSCROB                    ; Telemon
		        jmp     LE5CE

		LE5CC:
		        brk
		       .byte    XSCROH                    ; Telemon
		LE5CE:
		        ldx     _XSAVE
		        jmp     NEXT

.endif

.endif
