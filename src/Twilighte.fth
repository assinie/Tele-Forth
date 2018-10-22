; ----------------------------------------------------------------------------
; Extensions pour la carte Twilighte

#ifdef WITH_TWILIGHTE

#ifndef TWILIGHTE_INC
#define TWILIGHTE_INC
#echo "Ajout des extensions TWILIGHTE"

; ----------------------------------------------------------------------------
PBANK_nfa:
        .byte $86
        .byte "(BANK",")"+$80
        .word last_forth_word_nfa
PBANK:
        .word BANK_defer
; ----------------------------------------------------------------------------
BANKSTR_nfa:
        .byte $87
        .byte "BANKST","R"+$80
        .word PBANK_nfa
BANKSTR:
        .word BANKSTR_defer

-last_forth_word_nfa = BANKSTR_nfa

; ----------------------------------------------------------------------------
;: BANK: <BUILDS C, DOES> C000 SWAP C@ (BANK) ;  => 5 BANK: ORIX
;: BANK: <BUILDS SWAP , C, DOES> DUP @ SWAP 2+ C@ (BANK) ;  => C000 5 BANK: ORIX
BANKCOL_nfa:
        .byte $85
        .byte "BANK",":"+$80
        .word last_forth_word_nfa
BANKCOL
.(
        .word DOCOL
        .word BUILDS
        .word SWAP
        .word COMMA
        .word CCOMMA
        .word DOES

+DOBANK:
        .word DUP
        .word AT
        .word SWAP
        .word TWOP
        .word CAT
        .word PBANK
        .word SEMIS
.)
-last_forth_word_nfa = BANKCOL_nfa

; ----------------------------------------------------------------------------
;: BLIST CR 0 7 DO I DUP ." Bank " .  BANKSTR CR -1 +LOOP CR ;
BLIST_nfa:
        .byte $85
        .byte "BLIS","T"+$80
        .word last_forth_word_nfa
BLIST:
.(
        .word DOCOL
        .word CR
        .word ZERO
        .word LIT
        .word $07
        .word PDO
ZZloop:
        .word I
        .word DUP
        .word PDOTQ
        .byte $05
        .byte "Bank "
        .word DOT
        .word BANKSTR
        .word CR
        .word LIT
        .word $FFFF
        .word PPLOOP
        .word ZZloop
        .word CR
        .word SEMIS
.)
-last_forth_word_nfa = BLIST_nfa

; ----------------------------------------------------------------------------
;: BANK DEPTH 0= IF BLIST ELSE C000 SWAP (BANK) THEN ;
BANK_nfa:
        .byte $84
        .byte "BAN","K"+$80
        .word last_forth_word_nfa
BANK:
.(
        .word DOCOL
        .word DEPTH
        .word ZEQUAL
        .word ZBRANCH
        .word BANK_Else
        .word BLIST
        .word BRANCH
        .word BANK_Then

BANK_Else:
        .word LIT
        .word $C000
        .word SWAP
        .word PBANK
BANK_Then
        .word SEMIS
.)
-last_forth_word_nfa = BANK_nfa

; ----------------------------------------------------------------------------
; HEX C000 5 BANK: ORIX
ORIX_nfa:
        .byte $84
        .byte "ORI","X"+$80
        .word last_forth_word_nfa
ORIX:
.(
        .word DODOES
        .word DOBANK
        .word $C000
        .byte $05
.)
-last_forth_word_nfa = ORIX_nfa

#else

#echo "Ajout defers extensions TWILIGHTE"

EXBNK           = $040C
VEXBNK          = $0414
BNKCIB          = $0417

BANK_defer = RAM_START-2+(*-DictInitTable)
        lda BOT,x
        sta BNKCIB
        lda SECOND,x
        sta VEXBNK+1
        lda SECOND+1,x
        sta VEXBNK+2
        jmp EXBNK

#define VIA2_IORA $0321
BANKSTR_defer = RAM_START-2+(*-DictInitTable)
        ; Sauvegarde P
        php
        ; Interdire les interruptions
        sei
        ; Mise en place du vecteur IRQ pour la banque Basic
        ; $0244 jmp $02fa
        lda #$4c
        sta $0244
        lda #$fa
        sta $0245
        lda #$02
        sta $0246
        ; Récupère le n° de la banque sur la pile
        lda BOT,x
        and #$07
        sta BOT,x
        ; Sauvegarde la banque courante sur la pile
        lda VIA2_IORA
        sta BOT+1,x
        ; Activation de la banque demandée
        and #$f8
        ora BOT,x
        sta VIA2_IORA
        ; Sauvegarde de X au cas où Telemon le modifie
        txa
        pha
        ; Récupère l'adresse de la signature
        lda $fff8
        ldy $fff9
        ; Appel XWSTR0
        brk : .byte $14
        ; Restaure X
        pla
        tax
        ; Restaure la banque Forth
        lda BOT+1,x
        sta VIA2_IORA
        ; Restaure P
        plp
        ; Supprime le sommet de la pile et fin
        jmp POP

#endif

#endif
