; ----------------------------------------------------------------------------
; Extensions pour le Stratsed (Minimal)


.ifdef With::STRATSED_MINIMAL

	.ifndef Included::STRATSED_MINIMAL
		Included::STRATSED_MINIMAL = 1

		.out "Ajout du support STRATSED (minimal)"

		; ----------------------------------------------------------------------------
		; (DOS)
		; Appel de la procédure Stratsed $FFxx
		; ----------------------------------------------------------------------------
		code "(DOS)", "PDOS"
		LE6AA:
		        lda     flgtel
		        lsr
		        bcc     LE6B5
		        lda     #$08
		        jmp     LE6F2

		LE6B5:
		        sty     errnb
		        sty     bnkcib
		        lda     BOT,x
		        sta     vexbnk+1
		        dey
		        sty     vexbnk+2
		        stx     _XSAVE
		        php
		        tsx
		        dex
		        dex
		        dex
		        dex
		        stx     saves
		        lda     AYX_addr
		        ldy     AYX_addr+1
		        ldx     AYX_addr+2
		        lsr     PIO_addr
		        jsr     Exbnk
		        sta     AYX_addr
		        sty     AYX_addr+1
		        stx     AYX_addr+2
		        php
		        pla
		        sta     PIO_addr
		        plp
		        ldx     _XSAVE
		        lda     errnb
		LE6F2:
		        sta     BOT,x
		        jmp     NEXT

		; ----------------------------------------------------------------------------
		; DOS
		; Appel de la procédure Stratsed $FFxx avec vérification du code d'erreur
		; ----------------------------------------------------------------------------
		declare "DOS"
		        .word   DOCOL
		        .word   PDOS
		        .word   DUP
		        .word   LIT
		        .word   $80
		        .word   OR
		        .word   QERROR
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; FSTR
		; ----------------------------------------------------------------------------
		FSTR:
		        .byte   $82,$80
		        .byte   "A$      "
		        .byte   $82,$80
		        .byte   "B$      "
		        .byte   $82,$80
		        .byte   "C$      "
		        .byte   $82,$80
		        .byte   "D$      "
		        .byte   $FF

		; ----------------------------------------------------------------------------
		; FRW
		; ----------------------------------------------------------------------------
		FRW:
		        ldy     #$80
		        lda     hrs3
		        bpl     LE749
		        lda     BUFP
		        sta     $61
		        lda     BUFP+1
		        sta     $62
		        sty     $60
		        jmp     LE751

		LE749:
		        dey
		LE74A:
		        lda     ($61  ),y
		        sta     (BUFP),y
		        dey
		        bpl     LE74A
		LE751:
		        clc
		        lda     BUFP
		        adc     #$80
		        sta     BUFP
		        bcc     LE75C
		        inc     BUFP+1
		LE75C:
		        rts

		; ----------------------------------------------------------------------------
		; di
		; ----------------------------------------------------------------------------
		code "di"
		        sei
		        jmp     NEXT

		; ----------------------------------------------------------------------------
		; ei
		; ----------------------------------------------------------------------------
		code "ei"
		        cli
		        jmp     NEXT

		; ----------------------------------------------------------------------------
		; R/W
		; ----------------------------------------------------------------------------
		declare "R/W", "RSLW"
		        .word   DOCOL
		        .word   ZBRANCH
		        .word   LE787
		        .word   LIT
		        .word   $20
		        .word   BRANCH
		        .word   LE78B
		LE787:
		        .word   LIT
		        .word   $23
		LE78B:
		        .word   TOR
		        .word   OVER
		        .word   LIT
		        .word   BUFP
		        .word   STORE
		        .word   ONEP
		        .word   TWOSTAR
		        .word   ONEP
		        .word   DUP
		        .word   TWOS
		        .word   di
		        .word   PDO
		LE7A3:
		        .word   I
		        .word   LIT
		        .word   desalo
		        .word   STORE
		        .word   J
		        .word   PDOS
		        .word   LIT
		        .word   $0F
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LE7C1
		        .word   DUP
		        .word   B_BUF
		        .word   BLANKS
		        .word   LEAVE
		LE7C1:
		        .word   PLOOP
		        .word   LE7A3
		        .word   ei
		        .word   RFROMDROP
		        .word   DROP
		        .word   SEMIS

		.endif


	.else
		.error "*** Fichier Stratsed_minimal.voc déjà inclus!"
.endif
