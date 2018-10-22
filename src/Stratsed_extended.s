; ----------------------------------------------------------------------------
; Extensions pour le Stratsed

.ifdef With::STRATSED

	.ifndef Included::STRATSED_EXTENDED
		Included::STRATSED_EXTENDED = 1


		.out "Ajout du support STRATSED (full)"

		; ----------------------------------------------------------------------------
		; DRIVE
		; ----------------------------------------------------------------------------
		declare "DRIVE"
		        .word   DOCOL
		        .word   DUP
		        .word   ZLESS
		        .word   OVER
		        .word   LIT
		        .word   $03
		        .word   GREAT
		        .word   OR
		        .word   LIT
		        .word   $1C
		        .word   QERROR
		        .word   LIT
		        .word   tabdrv
		        .word   OVER
		        .word   PLUS
		        .word   CAT
		        .word   ZEQUAL
		        .word   LIT
		        .word   $8A
		        .word   QERROR
		        .word   LIT
		        .word   drvdef
		        .word   CSTORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ST-R/W
		; ----------------------------------------------------------------------------
		declare "ST-R/W", "STRSLW"
		        .word   DOCOL
		        .word   TOR
		        .word   LIT
		        .word   piste
		        .word   CSTORE
		        .word   LIT
		        .word   secteu
		        .word   CSTORE
		        .word   LIT
		        .word   rwbuf
		        .word   STORE
		        .word   RFROM
		        .word   ZBRANCH
		        .word   LE832
		        .word   LIT
		        .word   $A1
		        .word   BRANCH
		        .word   LE836
		LE832:
		        .word   LIT
		        .word   XSVSEC
		LE836:
		        .word   DOS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; FILENAME
		; ----------------------------------------------------------------------------
		declare "FILENAME"
		        .word   DOCOL
		        .word   COUNT
		        .word   SWAP
		        .word   AYX
		        .word   TWOSTORE
		        .word   LIT
		        .word   XNOMFI
		        .word   MON
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ?FILE
		; ----------------------------------------------------------------------------
		declare "?FILE", "QFILE"
		        .word   DOCOL
		        .word   FILENAME
		        .word   AYX
		        .word   TWOP
		        .word   LIT
		        .word   $82
		        .word   CTST
		        .word   LIT
		        .word   $89
		        .word   QERROR
		        .word   LIT
		        .word   XTRVNM
		        .word   DOS
		        .word   PIO
		        .word   TWO
		        .word   CTST
		        .word   ZEQUAL
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; .FILE
		; ----------------------------------------------------------------------------
		declare ".FILE", "DOTFILE"
		        .word   DOCOL
		        .word   CR
		        .word   PDOTQ

		        .byte   $06
		        .byte   "Using "

		        .word   LIT
		        .word   ficnum
		        .word   CAT
		        .word   ONES
		        .word   LIT
		        .word   $0260
		        .word   STAR
		        .word   LIT
		        .word   DOSBUFFERS+768
		        .word   PLUS
		        .word   COUNT
		        .word   LIT
		        .word   $41
		        .word   PLUS
		        .word   EMIT
		        .word   PDOTQ

		        .byte   $01
		        .byte   "-"

		        .word   DUP
		        .word   LIT
		        .word   $09
		        .word   DTRAILING
		        .word   TYPE
		        .word   PDOTQ

		        .byte   $01
		        .byte   "."

		        .word   LIT
		        .word   $09
		        .word   PLUS
		        .word   LIT
		        .word   $03
		        .word   DTRAILING
		        .word   TYPE
		        .word   SPACE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; USING
		; ----------------------------------------------------------------------------
		declare "USING"
		        .word   DOCOL
		        .word   FLUSH
		        .word   LIT
		        .word   $08
		        .word   LIT
		        .word   ftype
		        .word   CSTORE
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   QFILE
		        .word   ZBRANCH
		        .word   LE91A
		        .word   LIT
		        .word   XCLOSE
		        .word   PDOS
		        .word   DROP
		        .word   LIT
		        .word   drvdef
		        .word   CAT
		        .word   LIT
		        .word   drive
		        .word   CSTORE
		        .word   LIT
		        .word   XOPEN
		        .word   DOS
		        .word   BRANCH
		        .word   LE991
		LE91A:
		        .word   LIT
		        .word   $81
		        .word   MESSAGE
		        .word   CR
		        .word   PDOTQ

		        .byte   $06
		        .byte   "Creer "

		        .word   HERE
		        .word   COUNT
		        .word   TYPE
		        .word   QOK
		        .word   ZBRANCH
		        .word   LE991
		        .word   LIT
		        .word   XCLOSE
		        .word   PDOS
		        .word   DROP
		        .word   ZERO
		        .word   LIT
		        .word   desalo
		        .word   STORE
		        .word   B_BUF
		        .word   LIT
		        .word   fisalo
		        .word   STORE
		        .word   LIT
		        .word   drvdef
		        .word   CAT
		        .word   LIT
		        .word   drive
		        .word   CSTORE
		        .word   LIT
		        .word   XOPEN
		        .word   DOS
		        .word   LIT
		        .word   FSTR
		        .word   LIT
		        .word   $06
		        .word   AT
		        .word   DUP
		        .word   LIT
		        .word   rwbuf
		        .word   STORE
		        .word   LIT
		        .word   $29
		        .word   CMOVE
		        .word   LIT
		        .word   $08
		        .word   AT
		        .word   LIT
		        .word   $0C
		        .word   PLUS
		        .word   AT
		        .word   AYX
		        .word   STORE
		        .word   LIT
		        .word   XSAY
		        .word   DOS
		LE991:
		        .word   DOTFILE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; XFILE
		; ----------------------------------------------------------------------------

		declare "XFILE"
		        .word   DOCOL
		        .word   FLUSH
		        .word   LIT
		        .word   ficnum
		        .word   LIT
		        .word   $03
		        .word   TOGGLE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; INIT
		; ----------------------------------------------------------------------------
		declare "INIT"
		        .word   DOCOL
		        .word   LIT
		        .word   XINITI
		        .word   DOS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; DIR
		; ----------------------------------------------------------------------------
		declare "DIR"
		        .word   DOCOL
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   FILENAME
		        .word   LIT
		        .word   XDIRN
		        .word   DOS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; DEL
		; ----------------------------------------------------------------------------
		declare "DEL"
		        .word   DOCOL
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   FILENAME
		        .word   LIT
		        .word   XDELN
		        .word   DOS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; COPY
		; ----------------------------------------------------------------------------
		declare "COPY"
		        .word   DOCOL
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   FILENAME
		        .word   LIT
		        .word   bufnom
		        .word   LIT
		        .word   $0100
		        .word   LIT
		        .word   $0D
		        .word   CMOVE
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   FILENAME
		        .word   LIT
		        .word   bufnom
		        .word   LIT
		        .word   $010D
		        .word   LIT
		        .word   $0D
		        .word   CMOVE
		        .word   LIT
		        .word   $80
		        .word   LIT
		        .word   vasalo0
		        .word   STORE
		        .word   LIT
		        .word   XCOPY
		        .word   DOS
		        .word   SEMIS


		; ----------------------------------------------------------------------------
		; STARTUP
		; ----------------------------------------------------------------------------
		.out "Ajout du mot STARTUP avec support StratSed"
		declare "STARTUP"
		        .word   DOCOL
		        .word   LIT
		        .word   $60
		        .word   ZERO
		        .word   LIT
		        .word   CallTel
		        .word   TWOSTORE
		        .word   LIT
		        .word   v2dra
		        .word   CAT
		        .word   LIT
		        .word   $07
		        .word   ANDforth
		        .word   LIT
		        .word   vnmi
		        .word   CSTORE
		        .word   LIT
		        .word   $04
		        .word   PORIGIN
		        .word   LIT
		        .word   vnmi+1
		        .word   STORE
		        .word   LIT
		        .word   flgtel
		        .word   ONE
		        .word   CTST
		        .word   ZBRANCH
		        .word   LEA81
		        .word   LIT
		        .word   $88
		        .word   MESSAGE
		        .word   BRANCH
		        .word   LEAFF
		LEA81:
		        .word   LIT
		        .word   DOSBUFFERS
		        .word   LIT
		        .word   $07C0
		        .word   ERASE
		        .word   LIT
		        .word   $02
		        .word   LIT
		        .word   nbfic
		        .word   CSTORE
		        .word   LIT
		        .word   DOSBUFFERS
		        .word   LIT
		        .word   tampfc
		        .word   STORE
		        .word   ONE
		        .word   LIT
		        .word   ficnum
		        .word   CSTORE
		        .word   LIT
		        .word   v2dra
		        .word   CAT
		        .word   LIT
		        .word   $07
		        .word   ANDforth
		        .word   LIT
		        .word   xfield
		        .word   CSTORE

			.ifdef With::AUTOSTART_SUPPORT
				.out "Ajout du support autostart (fichier: AUTOSTART_FILE)"
			        .word   LIT
			        .word   FRW
			        .word   LIT
			        .word   xfield+1
			        .word   STORE
			        .word   LIT
			        .word   $FFFF
			        .word   LIT
			        .word   bitmfc
			        .word   STORE

			        .word   PLITQ
			        .byte   .strlen(AUTOSTART_FILE)
			        .byte   AUTOSTART_FILE

			        .word   QFILE
			        .word   ZBRANCH
			        .word   LEAFF
			        .word   LIT
			        .word   $08
			        .word   LIT
			        .word   ftype
			        .word   CSTORE
			        .word   LIT
			        .word   XOPEN
			        .word   DOS
			        .word   ZERO
			        .word   BLK
			        .word   STORE
			        .word   LBRACKET
			        .word   RPSTORE
			        .word   ONE
			        .word   LOAD
			        .word   QUIT
			.endif
		LEAFF:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; SALO!
		; ----------------------------------------------------------------------------
		declare "SALO!", "SALOSTORE"
		        .word   DOCOL
		        .word   LIT
		        .word   vasalo0
		        .word   STORE
		        .word   LIT
		        .word   fisalo
		        .word   STORE
		        .word   LIT
		        .word   desalo
		        .word   STORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; $SAVE
		; ----------------------------------------------------------------------------
		declare "$SAVE", "DOLSAVE"
		        .word   DOCOL
		        .word   ZERO
		        .word   SALOSTORE
		        .word   LIT
		        .word   $40
		        .word   LIT
		        .word   ftype
		        .word   CSTORE
		        .word   LIT
		        .word   XSAVE
		        .word   DOS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; $LOAD
		; ----------------------------------------------------------------------------
		declare "$LOAD", "DOLLOAD"
		        .word   DOCOL
		        .word   ZERO
		        .word   LIT
		        .word   $8080
		        .word   SALOSTORE
		        .word   LIT
		        .word   XLOAD
		        .word   DOS
		        .word   LIT
		        .word   fisalo
		        .word   AT
		        .word   SEMIS

	.else
		.error "*** Fichier Stratsed_extended.voc déjà inclus!"
	.endif
.endif
