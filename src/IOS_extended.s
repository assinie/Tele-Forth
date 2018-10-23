; ----------------------------------------------------------------------------
; IOS_extended.s
; ----------------------------------------------------------------------------
;				Extensions du vocabulaire IOS
; ----------------------------------------------------------------------------

.ifdef With::IOSext_VOC

	.ifdef Included::IOS_EXTENDED

		.ifdef MINITEL
			verbose 3, "Ajout defer MINITEL"

			MINITEL_defer:
			        .word   NOOP

		.endif

	.else

		Included::IOS_EXTENDED = 1

		add_to_voc "IOS"

		; ----------------------------------------------------------------------------
		; Gestion port imprimante
		; ----------------------------------------------------------------------------
		.ifdef With::IOS_PRINTER
			verbose 3, "Ajout des extensions IOS/Imprimante"

			; ----------------------------------------------------------------------------
			; TSTLP
			; Appel Telemon XTSTLP ($1E)
			; ----------------------------------------------------------------------------
			declare "TSTLP"
			        .word   DOMON
			        .byte   XTSTLP

			; ----------------------------------------------------------------------------
			; VCOPY
			; Appel Telemon XHCVDT ($4B)
			; ----------------------------------------------------------------------------
			declare "VCOPY"
			        .word   DOMON
			        .byte   XHCVDT

			; ----------------------------------------------------------------------------
			; HCOPY
			; Appel Telemon XHCHRS ($4C)
			; ----------------------------------------------------------------------------
			declare "HCOPY"
			        .word   DOMON
			        .byte   $4C

			; ----------------------------------------------------------------------------
			; WCOPY
			; Appel Telemon XHCSCR ($4A)
			; ----------------------------------------------------------------------------
			declare "WCOPY"
			        .word   DOCOL
			        .word   LIT
			        .word   SCRNB
			        .word   CSTORE
			        .word   LIT
			        .word   XHCSCR
			        .word   MON
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; PEMIT
			; ----------------------------------------------------------------------------
			declare "PEMIT"
			        .word   DOCOL
			        .word   AYX
			        .word   CSTORE
			        .word   LIT
			        .word   XLPRBI
			        .word   MON
			        .word   SEMIS

		.endif

		; ----------------------------------------------------------------------------
		; Gestion port série
		; ----------------------------------------------------------------------------
		.ifdef With::IOS_SERIAL
			verbose 3, "Ajout des extensions IOS/Serie"

			; ----------------------------------------------------------------------------
			; SDUMP
			; Appel Telemon XSDUMP ($5C)
			; ----------------------------------------------------------------------------
			declare "SDUMP"
			        .word   DOMON
			        .byte   XSDUMP

			; ----------------------------------------------------------------------------
			; CONSOLE
			; Appel Telemon XCONSO ($5D)
			; ----------------------------------------------------------------------------
			declare "CONSOLE"
			        .word   DOMON
			        .byte   XCONSO

			; ----------------------------------------------------------------------------
			; SLOAD
			; ----------------------------------------------------------------------------
			declare "SLOAD"
			        .word   DOCOL
			        .word   PIO
			        .word   ONE
			        .word   CRST
			        .word   LIT
			        .word   XSLOAD
			        .word   MON
			        .word   LIT
			        .word   desalo
			        .word   AT
			        .word   LIT
			        .word   fisalo
			        .word   AT
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; SLOADA
			; ----------------------------------------------------------------------------
			declare "SLOADA"
			        .word   DOCOL
			        .word   PIO
			        .word   ONE
			        .word   CSET
			        .word   LIT
			        .word   desalo
			        .word   STORE
			        .word   LIT
			        .word   XSLOAD
			        .word   MON
			        .word   LIT
			        .word   fisalo
			        .word   AT
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; SSAVE
			; ----------------------------------------------------------------------------
			declare "SSAVE"
			        .word   DOCOL
			        .word   ZERO
			        .word   SALOSTORE
			        .word   LIT
			        .word   XSSAVE
			        .word   MON
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; SEMIT
			; ----------------------------------------------------------------------------
			declare "SEMIT"
			        .word   DOCOL
			        .word   AYX
			        .word   CSTORE
			        .word   LIT
			        .word   XSOUT
			        .word   MON
			        .word   SEMIS

		.endif

		; ----------------------------------------------------------------------------
		; Gestion Minitel
		; ----------------------------------------------------------------------------
		.ifdef With::IOS_MINITEL
			verbose 3, "Ajout des extensions IOS/Minitel"


			; ----------------------------------------------------------------------------
			; RING
			; Appel Telemon XRING ($62)
			; ----------------------------------------------------------------------------
			declare "RING"
			        .word   DOMON
			        .byte   XRING

			; ----------------------------------------------------------------------------
			; WCXFI
			; Appel Telemon XWCXFI ($63)
			; ----------------------------------------------------------------------------
			declare "WCXFI"
			        .word   DOMON
			        .byte   XWCXFI

			; ----------------------------------------------------------------------------
			; LIGNE
			; Appel Telemon XLIGNE ($64)
			; ----------------------------------------------------------------------------
			declare "LIGNE"
			        .word   DOMON
			        .byte   XLIGNE

			; ----------------------------------------------------------------------------
			; DECON
			; Appel Telemon XDECON ($65)
			; ----------------------------------------------------------------------------
			declare "DECON"
			        .word   DOMON
			        .byte   XDECON

			; ----------------------------------------------------------------------------
			; MLOAD
			; ----------------------------------------------------------------------------
			declare "MLOAD"
			        .word   DOCOL
			        .word   PIO
			        .word   ONE
			        .word   CRST
			        .word   LIT
			        .word   XMLOAD
			        .word   MON
			        .word   LIT
			        .word   desalo
			        .word   AT
			        .word   LIT
			        .word   fisalo
			        .word   AT
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; MLOADA
			; ----------------------------------------------------------------------------
			declare "MLOADA"
			        .word   DOCOL
			        .word   PIO
			        .word   ONE
			        .word   CSET
			        .word   LIT
			        .word   desalo
			        .word   STORE
			        .word   LIT
			        .word   XMLOAD
			        .word   MON
			        .word   LIT
			        .word   fisalo
			        .word   AT
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; MSAVE
			; ----------------------------------------------------------------------------
			declare "MSAVE"
			        .word   DOCOL
			        .word   ZERO
			        .word   SALOSTORE
			        .word   LIT
			        .word   XMSAVE
			        .word   MON
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; MEMIT
			; ----------------------------------------------------------------------------
			declare "MEMIT"
			        .word   DOCOL
			        .word   AYX
			        .word   CSTORE
			        .word   LIT
			        .word   XMOUT
			        .word   MON
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; MNTL
			; ----------------------------------------------------------------------------
			code "MNTL"
			        lda     #$03
			        sta     bnkcib
			        lda     BOT,x
			        sta     vexbnk+1
			        dey
			        sty     vexbnk+2
			        stx     _XSAVE
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
			        ldx     _XSAVE
			        jmp     POP

			; ----------------------------------------------------------------------------
			; MINITEL
			; ----------------------------------------------------------------------------
			declare "MINITEL"
			        .word   DODEFER
			        .word   MINITEL_defer

			; ----------------------------------------------------------------------------
			MNTL0:
			        .word   MINITEL
			        .word   $F215,$F217
			        rts

			MNTL1:
			        ldx     _XSAVE
			        lda     #>MNTL0
			        sta     IP+1
			        lda     #<MNTL0
			        sta     IP
			        jmp     NEXT

			; ----------------------------------------------------------------------------
			; SERVEUR
			; ----------------------------------------------------------------------------
			declare "SERVEUR"
			        .word   DOCOL
			        .word   LIT
			        .word   v2dra
			        .word   CAT
			        .word   LIT
			        .word   $07
			        .word   ANDforth
			        .word   LIT
			        .word   vaplic
			        .word   CSTORE
			        .word   LIT
			        .word   MNTL1
			        .word   LIT
			        .word   vaplic+1
			        .word   STORE
			        .word   AYX
			        .word   TWOP
			        .word   CSTORE
			        .word   LIT
			        .word   $C5
			        .word   MNTL
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; APLIC
			; ----------------------------------------------------------------------------
			declare "APLIC"
			        .word   DOCOL
			        .word   LIT
			        .word   hrs1
			        .word   STORE
			        .word   LIT
			        .word   $BF
			        .word   MNTL
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; TINPUT
			; ----------------------------------------------------------------------------
			declare "TINPUT"
			        .word   DOCOL
			        .word   LIT
			        .word   $60
			        .word   CSTORE
			        .word   LIT
			        .word   $BC
			        .word   MNTL
			        .word   LIT
			        .word   $61
			        .word   AT
			        .word   LIT
			        .word   $FF
			        .word   CAT
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; PAGE
			; ----------------------------------------------------------------------------
			declare "PAGE"
			        .word   DOCOL
			        .word   LIT
			        .word   RAM_START+35005
			        .word   LIT
			        .word   $07
			        .word   DTRAILING
			        .word   HERE
			        .word   CSTORE
			        .word   HERE
			        .word   COUNT
			        .word   CMOVE
			        .word   HERE
			        .word   SEMIS

		.endif

	.endif

.endif
