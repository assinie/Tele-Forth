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

#ifdef WITH_CONTROL_FLOW

#ifndef CONTROL_INC
#define CONTROL_INC
#echo "Ajout de mots pour tests/boucles"


#ifdef NEED_MRKFROM
; MRK>_nfa
MRKFROM_nfa:
        .byte   $84
        .byte   "MRK"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
; MRK>
MRKFROM:
        .word   DOCOL
        .word   HERE
        .word   ZERO
        .word   COMMA
        .word   SEMIS

-last_forth_word_nfa = MRKFROM_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_MRKTO
; MRK<_nfa
MRKTO_nfa:
        .byte   $84
        .byte   "MRK"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
; MRK<
MRKTO:
        .word   DOCOL
        .word   HERE
        .word   SEMIS

-last_forth_word_nfa = MRKTO_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_MRKFROM
; RES>_nfa
RESFROM_nfa:
        .byte   $84
        .byte   "RES"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
; RES>
RESFROM:
        .word   DOCOL
        .word   HERE
        .word   SWAP
        .word   STORE
        .word   SEMIS

-last_forth_word_nfa = RESFROM_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_MRKTO
; RES<_nfa
RESTO_nfa:
        .byte   $84
        .byte   "RES"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
; RES<
RESTO:
        .word   DOCOL
        .word   COMMA
        .word   SEMIS
-last_forth_word_nfa = RESTO_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_IF_THEN_ELSE
#echo "Ajout des mots IF, ELSE, ENDIF"
IF_nfa:
        .byte   $C2
        .byte   "I"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   QCOMP
        .word   COMPILE
        .word   ZBRANCH
        .word   MRKFROM
        .word   ONE
        .word   SEMIS
; ----------------------------------------------------------------------------
ELSE_nfa:
        .byte   $C4
        .byte   "ELS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   IF_nfa
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
ENDIF_nfa:
        .byte   $C5
        .byte   "ENDI"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   ELSE_nfa
ENDIF:
        .word   DOCOL
        .word   ONE
        .word   QPAIRS
        .word   RESFROM
        .word   SEMIS

-last_forth_word_nfa = ENDIF_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_BEGIN
#echo "Ajout du mot BEGIN"
BEGIN_nfa:
        .byte   $C5
        .byte   "BEGI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   QCOMP
        .word   MRKTO
        .word   TWO
        .word   SEMIS

-last_forth_word_nfa = BEGIN_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_AGAIN
#echo "Ajout du mot AGAIN"
AGAIN_nfa:
        .byte   $C5
        .byte   "AGAI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   BRANCH
        .word   RESTO
        .word   SEMIS

-last_forth_word_nfa = AGAIN_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_UNTIL
#echo "Ajout du mot UNTIL"
UNTIL_nfa:
        .byte   $C5
        .byte   "UNTI"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
UNTIL:
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   ZBRANCH
        .word   RESTO
        .word   SEMIS

-last_forth_word_nfa = UNTIL_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_WHILE
#echo "Ajout du mot WHILE"
WHILE_nfa:
        .byte   $C5
        .byte   "WHIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   ZBRANCH
        .word   MRKFROM
        .word   LIT
        .word   $03
        .word   SEMIS

-last_forth_word_nfa = WHILE_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_REPEAT
#echo "Ajout du mot REPEAT"
REPEAT_nfa:
        .byte   $C6
        .byte   "REPEA"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

 -last_forth_word_nfa = REPEAT_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_DO
#echo "Ajout du mot DO"
DO_nfa:
        .byte   $C2
        .byte   "D"
        .byte   $CF
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   QCOMP
        .word   COMPILE
        .word   PDO
        .word   MRKTO
        .word   LIT
        .word   $04
        .word   SEMIS

-last_forth_word_nfa = DO_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_LOOP
#echo "Ajout du mot LOOP"
LOOP_nfa:
        .byte   $C4
        .byte   "LOO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   LIT
        .word   $04
        .word   QPAIRS
        .word   COMPILE
        .word   PLOOP
        .word   RESTO
        .word   SEMIS

-last_forth_word_nfa = LOOP_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_PLOOP
#echo "Ajout du mot +LOOP"
; +LOOP_nfa
PlusLOOP_nfa:
        .byte   $C5
        .byte   "+LOO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   LIT
        .word   $04
        .word   QPAIRS
        .word   COMPILE
        .word   PPLOOP
        .word   RESTO
        .word   SEMIS

-last_forth_word_nfa = PlusLOOP_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_CASE_OF_ENDCASE
#echo "Ajout des mots CASE, OF, ENDOF, ENDCASE"
CASE_nfa:
        .byte   $C4
        .byte   "CAS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   QCOMP
        .word   CSP
        .word   AT
        .word   STORECSP
        .word   LIT
        .word   $05
        .word   SEMIS
; ----------------------------------------------------------------------------
OF_nfa:
        .byte   $C2
        .byte   "O"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   CASE_nfa
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
; OF"_nfa
OFQUOT_nfa:
        .byte   $C3
        .byte   "OF"
        .byte   $A2
; ----------------------------------------------------------------------------
        .word   OF_nfa
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
ENDOF_nfa:
        .byte   $C5
        .byte   "ENDO"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   OFQUOT_nfa
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
ENDCASE_nfa:
        .byte   $C7
        .byte   "ENDCAS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   ENDOF_nfa
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

-last_forth_word_nfa = ENDCASE_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_IF_THEN_ELSE
#echo "Ajout du mot THEN"
; Alias de ENDIF
THEN_nfa:
        .byte   $C4
        .byte   "THE"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   ENDIF
        .word   SEMIS

-last_forth_word_nfa = THEN_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef NEED_UNTIL
#echo "Ajout du mot END"
; Alias de UNTIL
END_nfa:
        .byte   $C3
        .byte   "EN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   UNTIL
        .word   SEMIS

-last_forth_word_nfa = END_nfa
#endif

#else
#error "*** Fichier Control.asm déjà inclus!"
#endif

#endif
