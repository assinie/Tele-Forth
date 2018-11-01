; ----------------------------------------------------------------------------
; Control.s:
; ----------------------------------------------------------------------------
;                         Structures de contrôle
; ----------------------------------------------------------------------------
; test IF action_vrai ELSE action_faux ENDIF|THEN
; BEGIN boucle AGAIN
; BEGIN boucle test UNTIL|END
; BEGIN test WHILE boucle REPEAT
; fin+1 ini DO boucle LOOP
; fin+1 ini DO boucle increment +LOOP
; CASE selecteur choix1 OF action1 ENDOF choix2 OF action2 ...action_defaut ENDCASE
; ----------------------------------------------------------------------------

.ifdef With::CONTROL_FLOW

	.ifndef Included::CONTROL
		Included::CONTROL = 1
		verbose 3, "Ajout de mots pour tests/boucles"


		.ifdef Need::MRKFROM
		; ----------------------------------------------------------------------------
		; MRK>
		; ----------------------------------------------------------------------------
		declare "MRK>", "MRKFROM"
		        .word   DOCOL
		        .word   HERE
		        .word   ZERO
		        .word   COMMA
		        .word   SEMIS

		.endif

		.ifdef Need::MRKTO
		; ----------------------------------------------------------------------------
		; MRK<
		; ----------------------------------------------------------------------------
		declare "MRK<", "MRKTO"
		        .word   DOCOL
		        .word   HERE
		        .word   SEMIS

		.endif

		.ifdef Need::MRKFROM
		; ----------------------------------------------------------------------------
		; RES>
		; ----------------------------------------------------------------------------
		declare "RES>", "RESFROM"
		        .word   DOCOL
		        .word   HERE
		        .word   SWAP
		        .word   STORE
		        .word   SEMIS

		.endif

		.ifdef Need::MRKTO
		; ----------------------------------------------------------------------------
		; RES<
		; ----------------------------------------------------------------------------
		declare "RES<", "RESTO"
		        .word   DOCOL
		        .word   COMMA
		        .word   SEMIS
		.endif

		.ifdef With::IF_THEN_ELSE
		; ----------------------------------------------------------------------------
		; IF
		; ----------------------------------------------------------------------------
		declare "IF",, immediate
		        .word   DOCOL
		        .word   QCOMP
		        .word   COMPILE
		        .word   ZBRANCH
		        .word   MRKFROM
		        .word   ONE
		        .word   SEMIS
		; ----------------------------------------------------------------------------
		; ELSE
		; ----------------------------------------------------------------------------
		declare "ELSE",, immediate
		        .word   DOCOL
		        .word   ONE
		        .word   QPAIRS
		        .word   COMPILE
		        .word   BRANCH
		        .word   MRKFROM
		        .word   SWAP
		        .word   RESFROM
		        .word   ONE
		        .word   SEMIS
		; ----------------------------------------------------------------------------
		; ENDIF:
		; ----------------------------------------------------------------------------
		declare "ENDIF",, immediate
		        .word   DOCOL
		        .word   ONE
		        .word   QPAIRS
		        .word   RESFROM
		        .word   SEMIS

		.endif

		.ifdef Need::BEGIN
		; ----------------------------------------------------------------------------
		; BEGIN
		; ----------------------------------------------------------------------------
		declare "BEGIN",, immediate
		        .word   DOCOL
		        .word   QCOMP
		        .word   MRKTO
		        .word   TWO
		        .word   SEMIS

		.endif

		.ifdef Need::AGAIN
		; ----------------------------------------------------------------------------
		; AGAIN
		; ----------------------------------------------------------------------------
		declare "AGAIN",, immediate
		        .word   DOCOL
		        .word   TWO
		        .word   QPAIRS
		        .word   COMPILE
		        .word   BRANCH
		        .word   RESTO
		        .word   SEMIS

		.endif

		.ifdef Need::UNTIL
		; ----------------------------------------------------------------------------
		; UNTIL
		; ----------------------------------------------------------------------------
		declare "UNTIL",, immediate
		        .word   DOCOL
		        .word   TWO
		        .word   QPAIRS
		        .word   COMPILE
		        .word   ZBRANCH
		        .word   RESTO
		        .word   SEMIS

		.endif

		.ifdef Need::WHILE
		; ----------------------------------------------------------------------------
		; WHILE
		; ----------------------------------------------------------------------------
		declare "WHILE",, immediate
		        .word   DOCOL
		        .word   TWO
		        .word   QPAIRS
		        .word   COMPILE
		        .word   ZBRANCH
		        .word   MRKFROM
		        .word   LIT
		        .word   $03
		        .word   SEMIS

		.endif

		.ifdef Need::REPEAT
		; ----------------------------------------------------------------------------
		; REPEAT_nfa
		; ----------------------------------------------------------------------------
		declare "REPEAT",, immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $03
		        .word   QPAIRS
		        .word   COMPILE
		        .word   BRANCH
		        .word   SWAP
		        .word   RESTO
		        .word   RESFROM
		        .word   SEMIS

		.endif

		.ifdef Need::DO
		; ----------------------------------------------------------------------------
		; DO
		; ----------------------------------------------------------------------------
		declare "DO",, immediate
		        .word   DOCOL
		        .word   QCOMP
		        .word   COMPILE
		        .word   PDO
		        .word   MRKTO
		        .word   LIT
		        .word   $04
		        .word   SEMIS

		.endif

		.ifdef Need::LOOP
		; ----------------------------------------------------------------------------
		; LOOP
		; ----------------------------------------------------------------------------
		declare "LOOP",, immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $04
		        .word   QPAIRS
		        .word   COMPILE
		        .word   PLOOP
		        .word   RESTO
		        .word   SEMIS

		.endif

		.ifdef Need::PLOOP
		; ----------------------------------------------------------------------------
		; +LOOP
		; ----------------------------------------------------------------------------
		declare "+LOOP", "PlusLOOP", immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $04
		        .word   QPAIRS
		        .word   COMPILE
		        .word   PPLOOP
		        .word   RESTO
		        .word   SEMIS

		.endif

		.ifdef With::CASE_OF_ENDCASE
		; ----------------------------------------------------------------------------
		; CASE
		; ----------------------------------------------------------------------------
		declare "CASE",, immediate
		        .word   DOCOL
		        .word   QCOMP
		        .word   CSP
		        .word   AT
		        .word   STORECSP
		        .word   LIT
		        .word   $05
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; OF
		; ----------------------------------------------------------------------------
		declare "OF",, immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $05
		        .word   QPAIRS
		        .word   COMPILE
		        .word   POF
		        .word   MRKFROM
		        .word   LIT
		        .word   $06
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; OF"
		; ----------------------------------------------------------------------------
		declare 'OF"', "OFQUOT", immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $05
		        .word   QPAIRS
		        .word   COMPILE
		        .word   POFQUOT
		        .word   LIT
		        .word   $22
		        .word   WORD
		        .word   HERE
		        .word   CAT
		        .word   ONEP
		        .word   ALLOT
		        .word   MRKFROM
		        .word   LIT
		        .word   $06
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ENDOF
		; ----------------------------------------------------------------------------
		declare "ENDOF",, immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $06
		        .word   QPAIRS
		        .word   COMPILE
		        .word   BRANCH
		        .word   MRKFROM
		        .word   SWAP
		        .word   RESFROM
		        .word   LIT
		        .word   $05
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; ENDCASE
		; ----------------------------------------------------------------------------
		declare "ENDCASE",, immediate
		        .word   DOCOL
		        .word   LIT
		        .word   $05
		        .word   QPAIRS
		        .word   COMPILE
		        .word   DROP
		LDE01:
		        .word   SPat
		        .word   CSP
		        .word   AT
		        .word   SUB
		        .word   ZBRANCH
		        .word   LDE13
		        .word   RESFROM
		        .word   BRANCH
		        .word   LDE01
		LDE13:
		        .word   CSP
		        .word   STORE
		        .word   SEMIS

		.endif

		.ifdef With::IF_THEN_ELSE
		; ----------------------------------------------------------------------------
		; THEN
		; Alias de ENDIF
		; ----------------------------------------------------------------------------
		declare "THEN",, immediate
		        .word   DOCOL
		        .word   ENDIF
		        .word   SEMIS

		.endif

		.ifdef Need::UNTIL
		; ----------------------------------------------------------------------------
		; END
		; Alias de UNTIL
		; ----------------------------------------------------------------------------
		declare "END",, immediate
		        .word   DOCOL
		        .word   UNTIL
		        .word   SEMIS

		.endif

		.ifdef With::EXIT
		; ----------------------------------------------------------------------------
		; EXIT
		; Extension
		; ----------------------------------------------------------------------------
		code "EXIT"
		        pla
		        sta IP
		        pla
		        sta IP+1
		        jmp NEXT

		.endif

	.else
		.error "*** Fichier Control.asm déjà inclus!"
	.endif

.endif
