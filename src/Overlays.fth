; ----------------------------------------------------------------------------
; Support Overlays (vocabulaire FORTH)

#ifdef WITH_OVERLAYS_SUPPORT
#echo "Ajout gestion OVERLAYS"

OV6502_nfa:
        .byte   $86
        .byte   "OV650"
        .byte   $B2
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
LEB68:
        .word   DOCOL
        .word   HERE
        .word   DUP
        .word   MINUS
        .word   LIT
        .word   $FF
        .word   ANDforth
        .word   DUP
        .word   ALLOT
        .word   BLANKS
        .word   SEMIS
; ----------------------------------------------------------------------------
; #IN_nfa
DIGIN_nfa:
        .byte   $83
        .byte   "#I"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   OV6502_nfa
; #IN
DIGIN:
        .word   DOCOL
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
        .word   NUMBER
        .word   DROP
        .word   RFROM
        .word   IN
        .word   STORE
        .word   RFROM
        .word   BLK
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
BMAP_nfa:
        .byte   $84
        .byte   "BMA"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DIGIN_nfa
BMAP:
        .word   LEBBB
; ----------------------------------------------------------------------------
LEBBB:
        lda     BOT,x
        and     #$07
        ldy     #$03
LEBC1:
        lsr     BOT+1,x
        ror     BOT,x
        dey
        bne     LEBC1
        tay
        clc
        lda     BOT,x
        adc     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        adc     SECOND+1,x
        sta     SECOND+1,x
        lda     #$00
        sta     BOT+1,x
        iny
        sec
LEBDC:
        rol
        dey
        bne     LEBDC
        sta     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
OVSAVE_nfa:
        .byte   $86
        .byte   "OVSAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   BMAP_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   CONTEXT
        .word   AT
        .word   AT
        .word   PFIND
        .word   ZEQUAL
        .word   ZERO
        .word   QERROR
        .word   DROP
        .word   DUP
        .word   NFA
        .word   HERE
        .word   ROT
        .word   LFA
        .word   AT
        .word   PFIND
        .word   ZEQUAL
        .word   LIT
        .word   $0A
        .word   QERROR
        .word   DROP
        .word   NFA
        .word   SWAP
        .word   OVER
        .word   LIT
        .word   $FF
        .word   ANDforth
        .word   OVER
        .word   LIT
        .word   $FF
        .word   ANDforth
        .word   OR
        .word   LIT
        .word   $0B
        .word   QERROR
        .word   HERE
        .word   DUPTOR
        .word   OVER
        .word   SUB
        .word   R
        .word   OVER
        .word   LIT
        .word   $08
        .word   SLASH
        .word   ONEP
        .word   DUP
        .word   ALLOT
        .word   ERASE
        .word   LATEST
        .word   COMMA
        .word   TWODUP
        .word   COMMA
        .word   COMMA
        .word   ZERO
        .word   PDO
LEC62:
        .word   COUNT
        .word   ROT
        .word   COUNT
        .word   ROT
        .word   XOR
        .word   ZBRANCH
        .word   LEC86
        .word   J
        .word   I
        .word   ONES
        .word   BMAP
        .word   CSET
        .word   ONEP
        .word   SWAP
        .word   ONEP
        .word   TWO
        .word   BRANCH
        .word   LEC8A
LEC86:
        .word   SWAP
        .word   ONE
LEC8A:
        .word   PPLOOP
        .word   LEC62
        .word   TWODROP
        .word   BL
        .word   WORD
        .word   HERE
        .word   QFILE
        .word   DROP
        .word   HERE
        .word   TWOS
        .word   AT
        .word   HERE
        .word   DOLSAVE
        .word   RFROM
        .word   DP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; (OVLOAD)_nfa
POVLOAD_nfa:
        .byte   $88
        .byte   "(OVLOAD"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   OVSAVE_nfa
; (OVLOAD)
POVLOAD:
        .word   DOCOL
        .word   QFILE
        .word   ZEQUAL
        .word   LIT
        .word   $81
        .word   QERROR
        .word   LEB68
        .word   HERE
        .word   DOLLOAD
        .word   LIT
        .word   $06
        .word   SUB
        .word   WCOUNT
        .word   SWAP
        .word   WCOUNT
        .word   SWAP
        .word   AT
        .word   HERE
        .word   SWAP
        .word   SUB
        .word   TOR
        .word   DUP
        .word   HERE
        .word   PLUS
        .word   OVER
        .word   ZERO
        .word   PDO
LECED:
        .word   DUP
        .word   I
        .word   BMAP
        .word   CTST
        .word   ZBRANCH
        .word   LED09
        .word   J
        .word   HERE
        .word   I
        .word   PLUS
        .word   PSTORE
        .word   TWO
        .word   BRANCH
        .word   LED0B
LED09:
        .word   ONE
LED0B:
        .word   PPLOOP
        .word   LECED
        .word   DROP
        .word   LATEST
        .word   HERE
        .word   PFA
        .word   LFA
        .word   STORE
        .word   ALLOT
        .word   RFROM
        .word   PLUS
        .word   DUP
        .word   CURRENT
        .word   AT
        .word   STORE
        .word   PFA
        .word   CFA
        .word   EXECUTE
        .word   SEMIS
; ----------------------------------------------------------------------------
; (+OVLOAD)_nfa
PPOVLOAD_nfa:
        .byte   $89
        .byte   "(+OVLOAD"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   POVLOAD_nfa
; (+OVLOAD)
PPOVLOAD:
        .word   DOCOL
        .word   DUP
        .word   QFILE
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LED57
        .word   COUNT
        .word   TYPE
        .word   LIT
        .word   $81
        .word   MESSAGE
        .word   SPstore
        .word   QUIT
LED57:
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   "Here="
; ----------------------------------------------------------------------------
        .word   HERE
        .word   LIT
        .word   $06
        .word   PLUS
        .word   UDOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   "Himem="
; ----------------------------------------------------------------------------
        .word   HIMEM
        .word   UDOT
        .word   CR
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $17
        .byte   "Ou voulez-vous reloger "


; ----------------------------------------------------------------------------
        .word   DUP
        .word   COUNT
        .word   TYPE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   "? "
; ----------------------------------------------------------------------------
        .word   DIGIN
        .word   LATEST
        .word   TOR
        .word   HERE
        .word   TOR
        .word   SWAP
        .word   DP
        .word   STORE
        .word   POVLOAD
        .word   R
        .word   DP
        .word   STORE
        .word   LIT
        .word   $FF81
        .word   COMMA
        .word   LATEST
        .word   COMMA
        .word   RFROM
        .word   CURRENT
        .word   AT
        .word   STORE
        .word   RFROM
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
OVLOAD_nfa:
        .byte   $86
        .byte   "OVLOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   PPOVLOAD_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   POVLOAD
        .word   SEMIS
; ----------------------------------------------------------------------------
; +OVLOAD_nfa
PlusOVLOAD_nfa:
        .byte   $87
        .byte   "+OVLOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   OVLOAD_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   PPOVLOAD
        .word   SEMIS

; ----------------------------------------------------------------------------
UNLINK_nfa:
        .byte   $86
        .byte   "UNLIN"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   PlusOVLOAD_nfa
        .word   DOCOL
        .word   LIT
        .word   RAM_START+27389
        .word   SPat
        .word   CONTEXT
        .word   AT
        .word   AT
        .word   PFIND
        .word   ZEQUAL
        .word   LIT
        .word   $05
        .word   QERROR
        .word   DROP
        .word   NIP
        .word   DUP
        .word   NFA
        .word   LIT
        .word   $20
        .word   TOGGLE
        .word   TWOS
        .word   DUP
        .word   AT
        .word   SWAP
        .word   TWOS
        .word   STORE
        .word   SEMIS

-last_forth_word_nfa = UNLINK_nfa
#endif

