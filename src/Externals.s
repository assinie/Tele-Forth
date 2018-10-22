; ----------------------------------------------------------------------------
; Modules externes

.ifdef With::EXTERNAL_HELPERS

	.ifdef Included::EXTERNALS_INC
		.error "*** Fichier Externals.voc déjà inclus!"

	.else
		Included::EXTERNALS_INC = 1
		.out "Ajout commandes externes EDIT, ASSEMBLER, CODE, ;CODE"

		; ----------------------------------------------------------------------------
		; EDIT
		; ----------------------------------------------------------------------------
		declare "EDIT"
		        .word   DOCOL
		        .word   PLITQ

		        .byte   $0C
		        .byte   "A-EDITOR.COM"

		        .word   PPOVLOAD
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ASSEMBLER
		; ----------------------------------------------------------------------------
		declare "ASSEMBLER",, immediate
		        .word   DOCOL
		        .word   ZERO
		        .word   PLITQ

		        .byte   $0F
		        .byte   "A-ASSEMBLER.COM"

		        .word   PPOVLOAD
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; CODE
		; ----------------------------------------------------------------------------
		declare "CODE"
		        .word   DOCOL
		        .word   ONE
		        .word   ASSEMBLER
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ;CODE
		; ----------------------------------------------------------------------------
		declare ";CODE", "SEMICODE"
		        .word   DOCOL
		        .word   TWO
		        .word   ASSEMBLER
		        .word   SEMIS

	.endif

.endif
