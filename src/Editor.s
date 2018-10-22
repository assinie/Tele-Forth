; ----------------------------------------------------------------------------
; Vocabulaire EDITOR

.ifdef With::EDITOR_VOC

	.ifdef Included::EDITOR
		.out "Ajout entête du vocabulaire EDITOR"

		; ----------------------------------------------------------------------------
		; EDITOR
		; ----------------------------------------------------------------------------
		vocabulary_pfa "EDITOR"

	.else
		Included::EDITOR = 1

		.ifdef With::EDITOR_TEXT_LINE
			; ----------------------------------------------------------------------------
			; TEXT
			; Vocabulaire FORTH
			; ----------------------------------------------------------------------------
			declare "TEXT"
			        .word   DOCOL
			        .word   HERE
			        .word   CSLL
			        .word   ONEP
			        .word   BLANKS
			        .word   WORD
			        .word   HERE
			        .word   PAD
			        .word   CSLL
			        .word   ONEP
			        .word   CMOVE
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; LINE
			; Vocabulaire FORTH
			; ----------------------------------------------------------------------------
			declare "LINE"
			        .word   DOCOL
			        .word   DUP
			        .word   LIT
			        .word   $FFF0
			        .word   ANDforth
			        .word   LIT
			        .word   $17
			        .word   QERROR
			        .word   SCR
			        .word   AT
			        .word   PLINE
			        .word   DROP
			        .word   SEMIS

		.endif

		; ----------------------------------------------------------------------------
		; EDITOR
		; ----------------------------------------------------------------------------

		vocabulary "EDITOR",, immediate

		; ----------------------------------------------------------------------------
		; WHERE
		; ----------------------------------------------------------------------------
		add_to_voc "FORTH"

		declare "WHERE"
		        .word   DOCOL
		        .word   DUP
		        .word   B_SCR
		        .word   SLASH
		        .word   DUP
		        .word   SCR
		        .word   STORE
		        .word   PDOTQ

		        .byte   $08
		        .byte   "Ecran # "

		        .word   DECIMAL
		        .word   DOT
		        .word   SWAP
		        .word   CSLL
		        .word   SLMOD
		        .word   CSLL
		        .word   STAR
		        .word   ROT
		        .word   BLOCK
		        .word   PLUS
		        .word   CR
		        .word   CSLL
		        .word   TYPE
		        .word   CR
		        .word   HERE
		        .word   CAT
		        .word   SUB
		        .word   SPACES
		        .word   LIT
		        .word   $5E
		        .word   EMIT
		        .word   EDITOR
		        .word   QUIT
		        .word   SEMIS


		; ----------------------------------------------------------------------------
		; #LOCATE
		; ----------------------------------------------------------------------------
		add_to_voc "EDITOR"
		declare "#LOCATE", "DIGLOCATE"
		        .word   DOCOL
		        .word   RNUM
		        .word   AT
		        .word   CSLL
		        .word   SLMOD
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; #LEAD
		; ----------------------------------------------------------------------------
		declare "#LEAD", "DIGLEAD"
		        .word   DOCOL
		        .word   DIGLOCATE
		        .word   LINE
		        .word   SWAP
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; #LAG
		; ----------------------------------------------------------------------------
		declare "#LAG", "DIGLAG"
		        .word   DOCOL
		        .word   DIGLEAD
		        .word   DUPTOR
		        .word   PLUS
		        .word   CSLL
		        .word   RFROM
		        .word   SUB
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; -MOVE
		; ----------------------------------------------------------------------------
		declare "-MOVE", "DMOVE"
		        .word   DOCOL
		        .word   LINE
		        .word   CSLL
		        .word   CMOVE
		        .word   UPDATE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; H
		; ----------------------------------------------------------------------------
		declare "H"
		        .word   DOCOL
		        .word   LINE
		        .word   PAD
		        .word   ONEP
		        .word   CSLL
		        .word   DUP
		        .word   PAD
		        .word   CSTORE
		        .word   CMOVE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; E
		; ----------------------------------------------------------------------------
		declare "E"
		        .word   DOCOL
		        .word   LINE
		        .word   CSLL
		        .word   BLANKS
		        .word   UPDATE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; S
		; ----------------------------------------------------------------------------
		declare "S"
		        .word   DOCOL
		        .word   DUP
		        .word   ONE
		        .word   SUB
		        .word   LIT
		        .word   $0E
		        .word   PDO
		LF3E8:
		        .word   I
		        .word   LINE
		        .word   I
		        .word   ONEP
		        .word   DMOVE
		        .word   LIT
		        .word   $FFFF
		        .word   PPLOOP
		        .word   LF3E8
		        .word   E
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; D
		; ----------------------------------------------------------------------------
		declare "D"
		        .word   DOCOL
		        .word   DUP
		        .word   H
		        .word   LIT
		        .word   $0F
		        .word   DUP
		        .word   ROT
		        .word   PDO
		LF412:
		        .word   I
		        .word   ONEP
		        .word   LINE
		        .word   I
		        .word   DMOVE
		        .word   PLOOP
		        .word   LF412
		        .word   E
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; M
		; ----------------------------------------------------------------------------
		declare "M"
		        .word   DOCOL
		        .word   RNUM
		        .word   PSTORE
		        .word   CR
		        .word   SPACE
		        .word   DIGLEAD
		        .word   TYPE
		        .word   LIT
		        .word   $7E
		        .word   EMIT
		        .word   DIGLAG
		        .word   TYPE
		        .word   DIGLOCATE
		        .word   DOT
		        .word   DROP
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; T
		; ----------------------------------------------------------------------------
		declare "T"
		        .word   DOCOL
		        .word   DUP
		        .word   CSLL
		        .word   STAR
		        .word   RNUM
		        .word   STORE
		        .word   H
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; L
		; ----------------------------------------------------------------------------
		declare "L"
		        .word   DOCOL
		        .word   SCR
		        .word   AT
		        .word   LIST
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; R
		; ----------------------------------------------------------------------------
		declare "R", "Reditor"
		        .word   DOCOL
		        .word   PAD
		        .word   ONEP
		        .word   SWAP
		        .word   DMOVE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; P
		; ----------------------------------------------------------------------------
		declare "P"
		        .word   DOCOL
		        .word   ONE
		        .word   TEXT
		        .word   Reditor
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; I
		; ----------------------------------------------------------------------------
		declare "I", "Ieditor"
		        .word   DOCOL
		        .word   DUP
		        .word   S
		        .word   Reditor
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; TOP
		; ----------------------------------------------------------------------------
		declare "TOP"
		        .word   DOCOL
		        .word   ZERO
		        .word   RNUM
		        .word   STORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; CLEAR
		; ----------------------------------------------------------------------------
		declare "CLEAR"
		        .word   DOCOL
		        .word   SCR
		        .word   STORE
		        .word   LIT
		        .word   $10
		        .word   ZERO
		        .word   PDO
		LF4C4:
		        .word   I
		        .word   E
		        .word   PLOOP
		        .word   LF4C4
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; MATCH
		; ----------------------------------------------------------------------------
		declare "MATCH"
		        .word   DOCOL
		        .word   TOR
		        .word   TOR
		        .word   TWODUP
		        .word   RFROM
		        .word   R
		        .word   TWOSWAP
		        .word   RFROM
		        .word   SUB
		        .word   ZERO
		        .word   MAX
		        .word   OVER
		        .word   PLUS
		        .word   SWAP
		        .word   PDO
		LF4F4:
		        .word   TWODUP
		        .word   I
		        .word   SWAP
		        .word   SEQUAL
		        .word   ZBRANCH
		        .word   LF516
		        .word   I
		        .word   PLUS
		        .word   TOR
		        .word   TWODROP
		        .word   ZERO
		        .word   RFROM
		        .word   ROT
		        .word   SUB
		        .word   ZERO
		        .word   ZERO
		        .word   LEAVE
		LF516:
		        .word   PLOOP
		        .word   LF4F4
		        .word   TWODROP
		        .word   TOR
		        .word   ZEQUAL
		        .word   RFROM
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; 1LINE
		; ----------------------------------------------------------------------------
		declare "1LINE", "ONELINE"
		        .word   DOCOL
		        .word   DIGLAG
		        .word   PAD
		        .word   COUNT
		        .word   MATCH
		        .word   RNUM
		        .word   PSTORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; FIND
		; ----------------------------------------------------------------------------
		declare "FIND"
		        .word   DOCOL
		LF545:
		        .word   LIT
		        .word   $03FF
		        .word   RNUM
		        .word   AT
		        .word   LESS
		        .word   ZBRANCH
		        .word   LF563
		        .word   TOP
		        .word   PAD
		        .word   HERE
		        .word   CSLL
		        .word   ONEP
		        .word   CMOVE
		        .word   ZERO
		        .word   ERROR
		LF563:
		        .word   ONELINE
		        .word   ZBRANCH
		        .word   LF545
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; DELETE
		; ----------------------------------------------------------------------------
		declare "DELETE"
		        .word   DOCOL
		        .word   TOR
		        .word   DIGLAG
		        .word   PLUS
		        .word   R
		        .word   SUB
		        .word   DIGLAG
		        .word   R
		        .word   MINUS
		        .word   RNUM
		        .word   PSTORE
		        .word   DIGLEAD
		        .word   PLUS
		        .word   SWAP
		        .word   CMOVE
		        .word   RFROM
		        .word   BLANKS
		        .word   UPDATE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; N
		; ----------------------------------------------------------------------------
		declare "N", "Neditor"
		        .word   DOCOL
		        .word   FIND
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; F
		; ----------------------------------------------------------------------------
		declare "F"
		        .word   DOCOL
		        .word   ONE
		        .word   TEXT
		        .word   Neditor
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; B
		; ----------------------------------------------------------------------------
		declare "B"
		        .word   DOCOL
		        .word   PAD
		        .word   CAT
		        .word   MINUS
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; X
		; ----------------------------------------------------------------------------
		declare "X"
		        .word   DOCOL
		        .word   ONE
		        .word   TEXT
		        .word   FIND
		        .word   PAD
		        .word   CAT
		        .word   DELETE
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; TILL
		; ----------------------------------------------------------------------------
		declare "TILL"
		        .word   DOCOL
		        .word   DIGLEAD
		        .word   PLUS
		        .word   ONE
		        .word   TEXT
		        .word   ONELINE
		        .word   ZEQUAL
		        .word   ZERO
		        .word   QERROR
		        .word   DIGLEAD
		        .word   PLUS
		        .word   SWAP
		        .word   SUB
		        .word   DELETE
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; C
		; ----------------------------------------------------------------------------
		declare "C"
		        .word   DOCOL
		        .word   ONE
		        .word   TEXT
		        .word   PAD
		        .word   COUNT
		        .word   DIGLAG
		        .word   ROT
		        .word   OVER
		        .word   MIN
		        .word   TOR
		        .word   R
		        .word   RNUM
		        .word   PSTORE
		        .word   R
		        .word   SUB
		        .word   TOR
		        .word   DUP
		        .word   HERE
		        .word   R
		        .word   CMOVE
		        .word   HERE
		        .word   DIGLEAD
		        .word   PLUS
		        .word   RFROM
		        .word   CMOVE
		        .word   RFROM
		        .word   CMOVE
		        .word   UPDATE
		        .word   ZERO
		        .word   M
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; nu
		; ----------------------------------------------------------------------------
		declare "nu"
		        .word   DOCOL
		        .word   TOR
		        .word   LIT
		        .word   $10
		        .word   ZERO
		        .word   PDO
		LF65A:
		        .word   CR
		        .word   I
		        .word   LIT
		        .word   $03
		        .word   DOTR
		        .word   SPACE
		        .word   I
		        .word   OVER
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LF6A0
		        .word   QUERY
		        .word   ONE
		        .word   TEXT
		        .word   TIB
		        .word   AT
		        .word   CAT
		        .word   ZEQUAL
		        .word   ZBRANCH
		        .word   LF694
		        .word   LIT
		        .word   $08
		        .word   EMIT
		        .word   I
		        .word   SCR
		        .word   AT
		        .word   DOTLINE
		        .word   BRANCH
		        .word   LF69C
		LF694:
		        .word   I
		        .word   J
		        .word   EXECUTE
		        .word   ONEP
		LF69C:
		        .word   BRANCH
		        .word   LF6A8
		LF6A0:
		        .word   I
		        .word   SCR
		        .word   AT
		        .word   DOTLINE
		LF6A8:
		        .word   PLOOP
		        .word   LF65A
		        .word   RFROM
		        .word   TWODROP
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; NEW
		; ----------------------------------------------------------------------------
		declare "NEW"
	        .word   DOCOL
	        .word   LIT
	        .word   Reditor
	        .word   nu
	        .word   SEMIS

		; ----------------------------------------------------------------------------
		; UNDER
		; ----------------------------------------------------------------------------
		declare "UNDER"
		        .word   DOCOL
		        .word   ONEP
		        .word   LIT
		        .word   Ieditor
		        .word   nu
		        .word   SEMIS

		.ifdef With::EDITOR_SCRMOVE_SCRCOPY
			; ----------------------------------------------------------------------------
			; SCRMOVE
			; ----------------------------------------------------------------------------
			declare "SCRMOVE"
			        .word   DOCOL
			        .word   ABS
			        .word   TOR
			        .word   TWODUP
			        .word   LESS
			        .word   ZBRANCH
			        .word   LF700
			        .word   R
			        .word   ONES
			        .word   DUP
			        .word   DPLUS
			        .word   ZERO
			        .word   RFROM
			        .word   MINUS
			        .word   BRANCH
			        .word   LF704
			LF700:
			        .word   RFROM
			        .word   ZERO
			LF704:
			        .word   PDO
			LF706:
			        .word   TWODUP
			        .word   SWAP
			        .word   BLOCK
			        .word   TWOS
			        .word   STORE
			        .word   UPDATE
			        .word   FLUSH
			        .word   ONE
			        .word   ONE
			        .word   I
			        .word   ZLESS
			        .word   ZBRANCH
			        .word   LF722
			        .word   DMINUS
			LF722:
			        .word   DPLUS
			        .word   PLOOP
			        .word   LF706
			        .word   TWODROP
			        .word   SEMIS

			; ----------------------------------------------------------------------------
			; SCRCOPY
			; ----------------------------------------------------------------------------
			declare "SCRCOPY"
			        .word   DOCOL
			        .word   USING
			        .word   PDOTQ

			        .byte   $03
			        .byte   "de "

			        .word   LIT
			        .word   $03
			        .word   PICK
			        .word   DUP
			        .word   DOT
			        .word   PDOTQ

			        .byte   $02
			        .byte   "a "

			        .word   OVER
			        .word   PLUS
			        .word   DOT
			        .word   XFILE
			        .word   PDOTQ

			        .byte   $04
			        .byte   "vers"

			        .word   USING
			        .word   PDOTQ

			        .byte   $03
			        .byte   "de "

			        .word   OVER
			        .word   DUP
			        .word   DOT
			        .word   PDOTQ

			        .byte   $02
			        .byte   "a "

			        .word   OVER
			        .word   PLUS
			        .word   DOT
			        .word   XFILE
			        .word   PDOTQ

			        .byte   $06
			        .byte   "Copier"

			        .word   QOK
			        .word   ZBRANCH
			        .word   LF7AC
			        .word   ZERO
			        .word   PDO
			LF78C:
			        .word   OVER
			        .word   I
			        .word   PLUS
			        .word   BLOCK
			        .word   XFILE
			        .word   OVER
			        .word   I
			        .word   PLUS
			        .word   SWAP
			        .word   TWOS
			        .word   STORE
			        .word   XFILE
			        .word   PLOOP
			        .word   LF78C
			        .word   BRANCH
			        .word   LF7AE
			LF7AC:
			        .word   DROP
			LF7AE:
			        .word   TWODROP
			        .word   SEMIS

		.endif

	.endif

.endif
