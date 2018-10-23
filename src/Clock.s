; ----------------------------------------------------------------------------
; Clock.s:
; ----------------------------------------------------------------------------
;				Extensions CLOCK
; ----------------------------------------------------------------------------

.ifdef With::CLOCK

	.ifdef Included::CLOCK
		.error "*** Fichier Clock.s déjà inclus!"

	.else
		Included::CLOCK = 1
		verbose 3, "Ajout du mot CLOCK"

		; ----------------------------------------------------------------------------
		; CLOCK
		; ----------------------------------------------------------------------------
		declare "CLOCK"
		        .word   DOCOL
		        .word   ZERO
		        .word   POF
		        .word   LE5ED
		        .word   LIT
		        .word   XCLCL
		        .word   MON
		        .word   BRANCH
		        .word   LE62D
		LE5ED:
		        .word   ONE
		        .word   POF
		        .word   LE60F
		        .word   LIT
		        .word   $28
		        .word   STAR
		        .word   PLUS
		        .word   LIT
		        .word   SCRTXT
		        .word   PLUS
		        .word   AYX
		        .word   STORE
		        .word   LIT
		        .word   XWRCLK
		        .word   MON
		        .word   BRANCH
		        .word   LE62D
		LE60F:
		        .word   TWO
		        .word   POF
		        .word   LE62B
		        .word   LIT
		        .word   timeS
		        .word   CSTORE
		        .word   LIT
		        .word   timeM
		        .word   CSTORE
		        .word   LIT
		        .word   timeH
		        .word   CSTORE
		        .word   BRANCH
		        .word   LE62D
		LE62B:
		        .word   DROP
		LE62D:
		        .word   SEMIS

	.endif

.endif
