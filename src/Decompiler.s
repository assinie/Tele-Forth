; ----------------------------------------------------------------------------
; Decompiler.s:
; ----------------------------------------------------------------------------
;				Mini Décompilateur
; ----------------------------------------------------------------------------

.ifdef With::DECOMPILER

	.ifdef Included::DECOMPILER
		.error "*** Fichier Decompiler.s déjà inclus!"

	.else
		Included::DECOMPILER = 1

		verbose 3, "Ajout du mini décompilateur"

		; ----------------------------------------------------------------------------
		; \C
		; ----------------------------------------------------------------------------
		declare "\C", "backslash_C"
		        .word   DOCOL
		        .word   DUP
		        .word   UDOT
		        .word   WCOUNT
		        .word   TWOP
		        .word   NFA
		        .word   IDDOT
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; \L
		; ----------------------------------------------------------------------------
		declare "\L", "backslash_L"
		        .word   DOCOL
		        .word   DUP
		        .word   UDOT
		        .word   WCOUNT
		        .word   DOT
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; \S<space>
		; /?\ "\S " fait bien 3 caractères mais la longeur indiquée est: $82!
		; ----------------------------------------------------------------------------
		declare "\S ", "backslash_S"
		        .word   DOCOL
		        .word   DUP
		        .word   UDOT
		        .word   COUNT
		        .word   LIT
		        .word   $22
		        .word   EMIT
		        .word   TWODUP
		        .word   TYPE
		        .word   LIT
		        .word   $22
		        .word   EMIT
		        .word   BL
		        .word   EMIT
		        .word   PLUS
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; \J
		; ----------------------------------------------------------------------------
		declare "\J", "backslash_J"
		        .word   DOCOL
		        .word   DUP
		        .word   UDOT
		        .word   WCOUNT
		        .word   DUP
		        .word   UDOT
		        .word   AT
		        .word   TWOP
		        .word   NFA
		        .word   IDDOT
		        .word   SEMIS
		; ----------------------------------------------------------------------------
		; \D
		; ----------------------------------------------------------------------------
		declare "\D", "backslash_D"
		        .word   DOCOL
		        .word   OVER
		        .word   UDOT
		        .word   ZERO
		        .word   PDO
		LD04A:
		        .word   COUNT
		        .word   DOT
		        .word   PLOOP
		        .word   LD04A
		        .word   SEMIS

	.endif
.endif
