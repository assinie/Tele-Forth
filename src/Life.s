; ----------------------------------------------------------------------------
; Vocabulaire LIFE

.ifdef With::LIFE_VOC

	.ifdef Included::LIFE
		.out "Ajout entête du vocabulaire LIFE"

		; ----------------------------------------------------------------------------
		; LIFE
		; ----------------------------------------------------------------------------
		vocabulary_pfa "LIFE"

	.else
		.out "Ajout du dictionaire LIFE"
		Included::LIFE = 1


		; ----------------------------------------------------------------------------
		; LIFE
		; ----------------------------------------------------------------------------
		vocabulary "LIFE",, immediate

		; ----------------------------------------------------------------------------
		; DXY
		; ----------------------------------------------------------------------------
		declare "DXY"
		        .word   DOVAR
		        .word   RAM_START+42

		; ----------------------------------------------------------------------------
		; NEWm
		; ----------------------------------------------------------------------------
		declare "NEWm"
		        .word   DOVAR
		        .word   RAM_START+44

		; ----------------------------------------------------------------------------
		; OLDm
		; ----------------------------------------------------------------------------
		declare "OLDm"
		        .word   DOVAR
		        .word   RAM_START+46

		; ----------------------------------------------------------------------------
		; WRKm
		; ----------------------------------------------------------------------------
		declare "WRKm"
		        .word   DOVAR
		        .word   RAM_START+48

		; ----------------------------------------------------------------------------
		; org^
		; ----------------------------------------------------------------------------
		declare "org^", "orgCARET"
		        .word   DOVAR
		        .word   RAM_START+50

		; ----------------------------------------------------------------------------
		; mid^
		; ----------------------------------------------------------------------------
		declare "mid^", "midCARET"
		        .word   DOVAR
		        .word   RAM_START+52

		; ----------------------------------------------------------------------------
		; end^
		; ----------------------------------------------------------------------------
		declare "end^", "endCARET"
		        .word   DOVAR
		        .word   RAM_START+54

		; ----------------------------------------------------------------------------
		; C:L
		; ----------------------------------------------------------------------------
		declare "C:L", "CCOLL"
		        .word   DOCOL
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LF823
		        .word   LIT
		        .word   $F0
		        .word   BRANCH
		        .word   LF827
		LF823:
		        .word   LIT
		        .word   $28
		LF827:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; L:C
		; ----------------------------------------------------------------------------
		declare "L:C", "LCOLC"
		        .word   DOCOL
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LF83F
		        .word   LIT
		        .word   IP
		        .word   BRANCH
		        .word   LF843
		LF83F:
		        .word   LIT
		        .word   $1B
		LF843:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; C*L
		; ----------------------------------------------------------------------------
		declare "C*L", "CSTARL"
		        .word   DOCOL
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LF85B
		        .word   LIT
		        .word   SCRTXT
		        .word   BRANCH
		        .word   LF85F
		LF85B:
		        .word   LIT
		        .word   $0438
		LF85F:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; m#
		; ----------------------------------------------------------------------------
		declare "m#", "mDIG"
		        .word   DOCOL
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LF87A
		        .word   LIT
		        .word   $FF0F
		        .word   OVER
		        .word   ULESS
		        .word   BRANCH
		        .word   LF87E
		LF87A:
		        .word   DUP
		        .word   ZLESS
		LF87E:
		        .word   ZBRANCH
		        .word   LF88A
		        .word   CSTARL
		        .word   PLUS
		        .word   BRANCH
		        .word   LF89A
		LF88A:
		        .word   CSTARL
		        .word   ONES
		        .word   OVER
		        .word   ULESS
		        .word   ZBRANCH
		        .word   LF89A
		        .word   CSTARL
		        .word   SUB
		LF89A:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		;TOKEN
		; ----------------------------------------------------------------------------
		constant "TOKEN",, $006F


		; ----------------------------------------------------------------------------
		; TXTORG
		; ----------------------------------------------------------------------------
		constant "TXTORG",, $BBA8

		; ----------------------------------------------------------------------------
		; PAINT
		; ----------------------------------------------------------------------------
		declare "PAINT"
		        .word   DOCOL
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LF8D3
		        .word   FB
		        .word   ZERO
		        .word   CCOLL
		        .word   USL
		        .word   CURSET
		        .word   BRANCH
		        .word   LF8E7
		LF8D3:
		        .word   ZBRANCH
		        .word   LF8DD
		        .word   TOKEN
		        .word   BRANCH
		        .word   LF8DF
		LF8DD:
		        .word   BL
		LF8DF:
		        .word   SWAP
		        .word   TXTORG
		        .word   PLUS
		        .word   CSTORE
		LF8E7:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; .CURSOR
		; ----------------------------------------------------------------------------
		declare ".CURSOR", "DOTCURSOR"
		        .word   DOCOL
		        .word   RNUM
		        .word   AT
		        .word   mDIG
		        .word   DUP
		        .word   RNUM
		        .word   STORE
		        .word   DUP
		        .word   NEWm
		        .word   mAT
		LF907:
		        .word   TWODUP
		        .word   ZEQUAL
		        .word   PAINT
		        .word   ONE
		        .word   TWO
		        .word   WAIT
		        .word   TWODUP
		        .word   PAINT
		        .word   TWO
		        .word   TWO
		        .word   WAIT
		        .word   QTERMINAL
		        .word   ZBRANCH
		        .word   LF907
		        .word   TWODROP
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; .GENE
		; ----------------------------------------------------------------------------
		declare ".GENE", "DOTGENE"
		        .word   DOCOL
		        .word   ZERO
		        .word   ZERO
		        .word   GOTOXY
		        .word   PDOTQ

		        .byte   $05
		        .byte   "Gene "

		        .word   DOT
		        .word   PDOTQ

		        .byte   $02
		        .byte   ": "

		        .word   midCARET
		        .word   AT
		        .word   orgCARET
		        .word   AT
		        .word   SUB
		        .word   TWOSL
		        .word   DOT
		        .word   PDOTQ

		        .byte   $02
		        .byte   "/ "

		        .word   endCARET
		        .word   AT
		        .word   orgCARET
		        .word   AT
		        .word   SUB
		        .word   TWOSL
		        .word   DOT
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; .mLEN
		; ----------------------------------------------------------------------------
		declare "mLEN", "DOTmLET"
		        .word   DOCOL
		        .word   CCOLL
		        .word   LCOLC
		        .word   LIT
		        .word   $08
		        .word   STARSL
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; m,
		; ----------------------------------------------------------------------------
		declare "m,", "mCOMMA"
		        .word   DOCOL
		        .word   HERE
		        .word   DUP
		        .word   ROT
		        .word   STORE
		        .word   DOTmLET
		        .word   DUP
		        .word   ALLOT
		        .word   ERASE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; m@
		; ----------------------------------------------------------------------------
		declare "m@", "mAT"
		        .word   DOCOL
		        .word   AT
		        .word   SWAP
		        .word   BMAP
		        .word   CTST
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; m!
		; ----------------------------------------------------------------------------
		declare "m!", "mSTORE"
		        .word   DOCOL
		        .word   AT
		        .word   SWAP
		        .word   BMAP
		        .word   TOGGLE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ^,
		; ----------------------------------------------------------------------------
		declare "^,", "CARETCOMMA"
		        .word   DOCOL
		        .word   DUPTOR
		        .word   AT
		        .word   STORE
		        .word   TWO
		        .word   RFROM
		        .word   PSTORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; around
		; ----------------------------------------------------------------------------
		declare "around"
		        .word   DOCOL
		        .word   ZERO
		        .word   DXY
		        .word   AT
		        .word   DUP
		        .word   LIT
		        .word   $10
		        .word   PLUS
		        .word   SWAP
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; INI
		; ----------------------------------------------------------------------------
		declare "INI"
		        .word   DOCOL
		        .word   HERE
		        .word   PAD
		        .word   DP
		        .word   STORE
		        .word   NEWm
		        .word   mCOMMA
		        .word   OLDm
			        .word   mCOMMA
		        .word   WRKm
		        .word   mCOMMA
		        .word   HERE
		        .word   DXY
		        .word   STORE
		        .word   LIT
		        .word   $FFFF
		        .word   COMMA
		        .word   ONE
		        .word   COMMA
		        .word   CCOLL
		        .word   DUP
		        .word   DUP
		        .word   MINUS
		        .word   COMMA
		        .word   COMMA
		        .word   DUP
		        .word   ONES
		        .word   DUP
		        .word   MINUS
		        .word   COMMA
		        .word   COMMA
		        .word   ONEP
		        .word   DUP
		        .word   MINUS
		        .word   COMMA
		        .word   COMMA
		        .word   HERE
		        .word   DUP
		        .word   orgCARET
		        .word   STORE
		        .word   midCARET
		        .word   STORE
		        .word   LCOLC
		        .word   TWOSL
		        .word   CCOLL
		        .word   STAR
		        .word   CCOLL
		        .word   TWOSL
		        .word   PLUS
		        .word   RNUM
		        .word   STORE
		        .word   DP
		        .word   STORE
		        .word   QHIRES
		        .word   ZBRANCH
		        .word   LFA67
		        .word   HIRES
		        .word   BRANCH
		        .word   LFA69
		LFA67:
		        .word   CLS
		LFA69:
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; QFN
		; ----------------------------------------------------------------------------
		declare "QFN"
		        .word   DOCOL
		        .word   ZERO
		        .word   ZERO
		        .word   GOTOXY
		        .word   LIT
		        .word   $28
		        .word   SPACES
		        .word   ZERO
		        .word   ZERO
		        .word   GOTOXY
		        .word   ZBRANCH
		        .word   LFA95
		        .word   PDOTQ

		        .byte   $05
		        .byte   "Load:"

		        .word   BRANCH
		        .word   LFA9D
		LFA95:
		        .word   PDOTQ

		        .byte   $05
		        .byte   "Save:"

		LFA9D:
		        .word   BLK
		        .word   AT
		        .word   TOR
		        .word   IN
		        .word   AT
		        .word   TOR
		        .word   ZERO
		        .word   BLK
		        .word   STORE
		        .word   QUERY
		        .word   BL
		        .word   WORD
		        .word   HERE
		        .word   FILENAME
		        .word   RFROM
		        .word   IN
		        .word   STORE
		        .word   RFROM
		        .word   BLK
		        .word   STORE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; GENE
		; ----------------------------------------------------------------------------
		declare "GENE"
		        .word   DOCOL
		        .word   NEWm
		        .word   AT
		        .word   DOTmLET
		        .word   TWODUP
		        .word   OLDm
		        .word   AT
		        .word   SWAP
		        .word   CMOVE
		        .word   WRKm
		        .word   AT
		        .word   SWAP
		        .word   CMOVE
		        .word   midCARET
		        .word   AT
		        .word   DUP
		        .word   DUP
		        .word   endCARET
		        .word   STORE
		        .word   orgCARET
		        .word   AT
		        .word   DUP
		        .word   midCARET
		        .word   STORE
		        .word   PDO
		LFB00:
		        .word   I
		        .word   AT
		        .word   around
		        .word   PDO
		LFB08:
		        .word   OVER
		        .word   I
		        .word   AT
		        .word   PLUS
		        .word   mDIG
		        .word   DUPTOR
		        .word   OLDm
		        .word   mAT
		        .word   ZBRANCH
		        .word   LFB22
		        .word   ONEP
		        .word   BRANCH
		        .word   LFB3A
		LFB22:
		        .word   R
		        .word   WRKm
		        .word   mAT
		        .word   ZEQUAL
		        .word   ZBRANCH
		        .word   LFB3A
		        .word   R
		        .word   WRKm
		        .word   mSTORE
		        .word   R
		        .word   endCARET
		        .word   CARETCOMMA
		LFB3A:
		        .word   RFROMDROP
		        .word   TWO
		        .word   PPLOOP
		        .word   LFB08
		        .word   LIT
		        .word   $0E
		        .word   ANDforth
		        .word   TWO
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LFB58
		        .word   midCARET
		        .word   CARETCOMMA
		        .word   BRANCH
		        .word   LFB62
		LFB58:
		        .word   DUP
		        .word   ZERO
		        .word   PAINT
		        .word   NEWm
		        .word   mSTORE
		LFB62:
		        .word   TWO
		        .word   PPLOOP
		        .word   LFB00
		        .word   endCARET
		        .word   AT
		        .word   SWAP
		        .word   PDO
		LFB70:
		        .word   I
		        .word   AT
		        .word   around
		        .word   PDO
		LFB78:
		        .word   OVER
		        .word   I
		        .word   AT
		        .word   PLUS
		        .word   mDIG
		        .word   OLDm
		        .word   mAT
		        .word   PLUS
		        .word   TWO
		        .word   PPLOOP
		        .word   LFB78
		        .word   LIT
		        .word   $03
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LFBAA
		        .word   DUP
		        .word   midCARET
		        .word   CARETCOMMA
		        .word   DUP
		        .word   ONE
		        .word   PAINT
		        .word   DUP
		        .word   NEWm
		        .word   mSTORE
		LFBAA:
		        .word   DROP
		        .word   TWO
		        .word   PPLOOP
		        .word   LFB70
		        .word   SEMIS


		.ifdef With::LIFE_DEMO

			add_to_voc "FORTH"

			; ----------------------------------------------------------------------------
			; DEMO
			; ----------------------------------------------------------------------------
			declare "DEMO"
			        .word   DOCOL
			        .word   LIT
			        .word   $49
			LFBC1:
			        .word   LIT
			        .word   $49
			        .word   POF
			        .word   LFBCF
			        .word   INI
			        .word   BRANCH
			        .word   LFD37
			LFBCF:
			        .word   LIT
			        .word   $08
			        .word   POF
			        .word   LFBE3
			        .word   LIT
			        .word   $FFFF
			        .word   RNUM
			        .word   PSTORE
			        .word   BRANCH
			        .word   LFD37
			LFBE3:
			        .word   LIT
			        .word   $09
			        .word   POF
			        .word   LFBF5
			        .word   ONE
			        .word   RNUM
			        .word   PSTORE
			        .word   BRANCH
			        .word   LFD37
		LFBF5:
			        .word   LIT
			        .word   $0A
			        .word   POF
			        .word   LFC07
			        .word   CCOLL
			        .word   RNUM
			        .word   PSTORE
			        .word   BRANCH
			        .word   LFD37
			LFC07:
			        .word   LIT
			        .word   $0B
			        .word   POF
			        .word   LFC1B
			        .word   CCOLL
			        .word   MINUS
			        .word   RNUM
			        .word   PSTORE
			        .word   BRANCH
			        .word   LFD37
			LFC1B:
			        .word   BL
			        .word   POF
			        .word   LFC77
			        .word   RNUM
			        .word   AT
			        .word   DUP
			        .word   NEWm
			        .word   mSTORE
			        .word   DUP
			        .word   NEWm
			        .word   mAT
			        .word   TWODUP
			        .word   PAINT
			        .word   ZBRANCH
			        .word   LFC41
			        .word   midCARET
			        .word   CARETCOMMA
			        .word   BRANCH
			        .word   LFC73
			LFC41:
			        .word   midCARET
			        .word   AT
			        .word   orgCARET
			        .word   AT
			        .word   PDO
			LFC4B:
			        .word   DUP
			        .word   I
			        .word   AT
			        .word   EQUAL
			        .word   ZBRANCH
			        .word   LFC6B
			        .word   LIT
			        .word   $FFFE
			        .word   midCARET
			        .word   PSTORE
			        .word   midCARET
			        .word   AT
			        .word   AT
			        .word   I
			        .word   STORE
			        .word   LEAVE
			LFC6B:
			        .word   TWO
			        .word   PPLOOP
			        .word   LFC4B
			        .word   DROP
			LFC73:
			        .word   BRANCH
			        .word   LFD37
			LFC77:
			        .word   LIT
			        .word   $0D
			        .word   POF
			        .word   LFCA7
			        .word   ZERO
			LFC81:
			        .word   orgCARET
			        .word   AT
			        .word   midCARET
			        .word   AT
			        .word   EQUAL
			        .word   QTERMSTOP
			        .word   OR
			        .word   ZEQUAL
			        .word   ZBRANCH
			        .word   LFCA1
			        .word   GENE
			        .word   ONEP
			        .word   DUP
			        .word   DOTGENE
			        .word   BRANCH
			        .word   LFC81
			LFCA1:
			        .word   DROP
			        .word   BRANCH
			        .word   LFD37
			LFCA7:
			        .word   LIT
			        .word   $53
			        .word   POF
			        .word   LFCC3
			        .word   ZERO
			        .word   QFN
			        .word   orgCARET
			        .word   AT
			        .word   midCARET
			        .word   AT
			        .word   ONES
			        .word   DOLSAVE
			        .word   BRANCH
			        .word   LFD37
			LFCC3:
			        .word   LIT
			        .word   $4C
			        .word   POF
			        .word   LFD21
			        .word   RNUM
			        .word   AT
			        .word   CCOLL
			        .word   LCOLC
			        .word   TWO
			        .word   STARSL
			        .word   SUB
			        .word   ONE
			        .word   QFN
			        .word   midCARET
			        .word   AT
			        .word   DUP
			        .word   DOLLOAD
			        .word   ONEP
			        .word   SWAP
			        .word   PDO
			LFCEB:
			        .word   DUP
			        .word   I
			        .word   AT
			        .word   PLUS
			        .word   mDIG
			        .word   DUP
			        .word   NEWm
			        .word   mAT
			        .word   ZBRANCH
			        .word   LFD05
			        .word   DROP
			        .word   BRANCH
			        .word   LFD15
			LFD05:
			        .word   DUP
			        .word   midCARET
			        .word   CARETCOMMA
			        .word   DUP
			        .word   NEWm
			        .word   mSTORE
			        .word   ONE
			        .word   PAINT
			LFD15:
			        .word   TWO
			        .word   PPLOOP
			        .word   LFCEB
			        .word   DROP
			        .word   BRANCH
			        .word   LFD37
			LFD21:
			        .word   LIT
			        .word   $03
			        .word   POF
			        .word   LFD2F
			        .word   SEMIS
			        .word   BRANCH
			        .word   LFD37
			LFD2F:
			        .word   LIT
			        .word   $07
			        .word   EMIT
			        .word   DROP
			LFD37:
			        .word   DOTCURSOR
			        .word   KEY
			        .word   BRANCH
			        .word   LFBC1
			        .word   SEMIS

		.endif

	.endif

.endif
