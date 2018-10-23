; ----------------------------------------------------------------------------
; Wait.s:
; ----------------------------------------------------------------------------
;				Extensions WAIT
; ----------------------------------------------------------------------------

.ifdef With::WAIT

	.ifdef Included::WAIT
		.error "*** Fichier Wait.s déjà inclus!"

	.else
		Included::WAIT = 1
		verbose 3, "Ajout du mot WAIT"

		; ----------------------------------------------------------------------------
		; WAIT
		; ----------------------------------------------------------------------------
		declare "WAIT"
		        .word   DOCOL
		        .word   ZERO
		        .word   POF
		        .word   LE664
		        .word   SWAP
		LE640:
		        .word   DUP
		        .word   LIT
		        .word   timeH
		        .word   CAT
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LE640
		        .word   DROP
		LE650:
		        .word   DUP
		        .word   LIT
		        .word   timeM
		        .word   CAT
		        .word   EQUAL
		        .word   ZBRANCH
		        .word   LE650
		        .word   DROP
		        .word   BRANCH
		        .word   LE69E
		LE664:
		        .word   ONE
		        .word   POF
		        .word   LE680
		        .word   LIT
		        .word   $42
		        .word   STORE
		LE670:
		        .word   LIT
		        .word   $42
		        .word   AT
		        .word   ZEQUAL
		        .word   ZBRANCH
		        .word   LE670
		        .word   BRANCH
		        .word   LE69E
		LE680:
		        .word   TWO
		        .word   POF
		        .word   LE69C
		        .word   LIT
		        .word   $44
		        .word   STORE
		LE68C:
		        .word   LIT
		        .word   $44
		        .word   AT
		        .word   ZEQUAL
		        .word   ZBRANCH
		        .word   LE68C
		        .word   BRANCH
		        .word   LE69E
		LE69C:
		        .word   DROP
		LE69E:
		        .word   SEMIS

.endif

.endif
