; da65 V2.17 - Git 334e30c
; Created:    2018-06-14 23:41:53
; Input file: original/TeleForth.rom
; Page:       1


;        .setcpu "6502"

    * = $c000
#include "TeleForth.inc"


; ----------------------------------------------------------------------------
BOT             = $0000                        ; RES
SECOND          = $0002                        ; RESB
SCRNB           = $0028                        ; ??? Uniquement mis à jour par le mot SCROLL
hrs1            = $004D
hrs3            = $0051
hrsfb           = $0057
BUFP            = $0080                        ; Pointeur sur tampon Forth pour lecture/écriture
STACK           = $008C                        ; Pile des données (50 octets)
N               = $00C0
IP              = $00C8
W               = $00CB
UP              = $00CD
_XSAVE          = $00CF                        ; Ajout de '_' pour ne pas confondre avec l'appel Stratsed XSAVE
_TIB_           = $0100
tabdrv          = $0208
drvdef          = $020C
flgtel          = $020D
timeS           = $0211
timeM           = $0212
timeH           = $0213
scrX            = $0220
scrY            = $0224
hrspat          = $02AA
vnmi            = $02F4
virq            = $02FA
vaplic          = $02FD
v2dra           = $0321
Exbnk           = $040C
vexbnk          = $0414
bnkcib          = $0417
drive           = $0500
piste           = $0501
secteu          = $0502
rwbuf           = $0503                        ; Adresse tampon DOS pour lecture/écriture
errnb           = $0512
saves           = $0513
bufnom          = $0517
vasalo0         = $0528
ftype           = $052C
desalo          = $052D
fisalo          = $052F
tampfc          = $0542
bitmfc          = $0544
ficnum          = $0548
nbfic           = $0549
xfield          = $054C
CallTel         = $0560                        ; Routine d'appel d'une fonction Telemon. Initialisé à: 00 00 60 00 par (ABORT)
AYX_addr        = $0563                        ; Utilisé pour le passage des registres A,X,Y pour les appels MON
PIO_addr        = $0566                        ; Utilisé pour le passage du registre P pour les appels MON
_UAREA_         = $0800                        ; User Area (ex. CURRENT := $0822)
DOSBUFFERS      = $0840                        ; Tampons DOS pour 2 fichiers
_FIRST          = $1000                        ; Tampon pour 1 écran (FIRST)
RAM_START       = $1404                        ; Zone pour le dictionnaire (LIMIT) - 1er mot utilisateur à partir de $143C
SCRTXT          = $BB80                        ; Adresse de base de l'écran TEXT
; ----------------------------------------------------------------------------
ORIGIN:
        nop
        jmp     PCOLD1

; ----------------------------------------------------------------------------
        nop
        jmp     WARM1

; ----------------------------------------------------------------------------
        .word   $0201,$0E01
; ----------------------------------------------------------------------------
; adresse mot le plus récent: ROMend_nfa
NTOP:
        .word   ROMend_nfa
; ----------------------------------------------------------------------------
BSCH:
        .word   $007F
UAREA:
        .word   $0800
; (S0)
PS0:
        .word   $00BE
; (R0)
R0:
        .word   $01FF
PTIB:
        .word   $0100
PWIDTH:
        .word   $001F
PWARNING:
        .word   $0001
PFENCE:
        .word   RAM_START-2+(DictInitTableEnd-DictInitTable); C01C 3C 14
PDP:
        .word   RAM_START-2+(DictInitTableEnd-DictInitTable); C01E 3C 14
; ----------------------------------------------------------------------------
; adresse VOC-LINK du vocabulaire le plus récent: LIFE-LINK
PVOCLINK:
        .word   LIFE_LINK
; ----------------------------------------------------------------------------
SYSTEM:
        .word   $0004,$5ED2
; ----------------------------------------------------------------------------
PCOLD:
        .word   COLD
; ----------------------------------------------------------------------------
PCOLD1:
        lda     #$6C
        sta     W-1
        lda     UAREA
        sta     UP
        lda     UAREA+1
        sta     UP+1
        ldx     R0
        txs
        ldx     PS0
        lda     #>PCOLD
        sta     IP+1
        lda     #<PCOLD
        sta     IP
        jmp     NEXT

; ----------------------------------------------------------------------------
PWARM:
        .word   WARM
; ----------------------------------------------------------------------------
WARM1:
        lda     #>PWARM
        sta     IP+1
        lda     #<PWARM
        sta     IP
        jmp     RPSTORE_pfa

; ----------------------------------------------------------------------------
NOOP_nfa:
        .byte   $84
        .byte   "NOO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   $00
LC05C:
        .word   NEXT
; ----------------------------------------------------------------------------
NEXT:
        ldy     #$01
        lda     (IP),y
        sta     W+1
        dey
        lda     (IP),y
        sta     W
        clc
        lda     IP
        adc     #$02
        sta     IP
        bcc     LC074
        inc     IP+1
LC074:
        jmp     W-1

; ----------------------------------------------------------------------------
EXECUTE_nfa:
        .byte   $87
        .byte   "EXECUT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   NOOP_nfa
EXECUTE:
        .word   LC083
; ----------------------------------------------------------------------------
LC083:
        lda     BOT,x
        sta     W
        lda     BOT+1,x
        sta     W+1
        inx
        inx
        jmp     W-1

; ----------------------------------------------------------------------------
LIT_nfa:
        .byte   $83
        .byte   "LI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   EXECUTE_nfa
LIT:
        .word   LC098
; ----------------------------------------------------------------------------
LC098:
        lda     (IP),y
        pha
        inc     IP
        bne     LC0A1
        inc     IP+1
LC0A1:
        lda     (IP),y
        inc     IP
        bne     PUSH
        inc     IP+1
PUSH:
        dex
        dex
PUT:
        sta     BOT+1,x
        pla
        sta     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; Copie ACC mots de la pile vers N
SETUP:
        asl
        sta     N-1
        sta     NEXT+1
LC0B9:
        lda     BOT,x
        sta     N,y
        inx
        iny
        cpy     N-1
        bne     LC0B9
        ldy     #$00
        rts

; ----------------------------------------------------------------------------
; (+LOOP)_pfa
PPLOOP_pfa:
        lda     BOT+1,x
        pha
        pha
        lda     BOT,x
        inx
        inx
        stx     _XSAVE
        tsx
        inx
        inx
        clc
        adc     _TIB_+1,x
        sta     _TIB_+1,x
        pla
        adc     _TIB_+2,x
        sta     _TIB_+2,x
        pla
        bpl     LC100
        clc
        lda     _TIB_+1,x
        sbc     _TIB_+3,x
        lda     _TIB_+2,x
        sbc     _TIB_+4,x
        jmp     LC10D

; ----------------------------------------------------------------------------
; (LOOP)_pfa
PLOOP_pfa:
        stx     _XSAVE
        tsx
        inc     _TIB_+1,x
        bne     LC100
        inc     _TIB_+2,x
LC100:
        clc
        lda     _TIB_+3,x
        sbc     _TIB_+1,x
        lda     _TIB_+4,x
        sbc     _TIB_+2,x
LC10D:
        ldx     _XSAVE
        asl
        bcc     BRANCH_pfa
        pla
        pla
        pla
        pla
        jmp     BUMP

; ----------------------------------------------------------------------------
; (OF)_pfa
POF_pfa:
        inx
        inx
        lda     $FE,x
        cmp     BOT,x
        bne     BRANCH_pfa
        lda     $FF,x
        cmp     BOT+1,x
        bne     BRANCH_pfa
        inx
        inx
        jmp     BUMP

; ----------------------------------------------------------------------------
; 0BRANCH_pfa
ZBRANCH_pfa:
        inx
        inx
        lda     $FE,x
        ora     $FF,x
        beq     BRANCH_pfa
BUMP:
        clc
        lda     IP
        adc     #$02
        sta     IP
        bcc     LC13F
        inc     IP+1
LC13F:
        jmp     NEXT

; ----------------------------------------------------------------------------
BRANCH_pfa:
        lda     (IP),y
        pha
        iny
        lda     (IP),y
        sta     IP+1
        pla
        sta     IP
        jmp     NEXT+2

; ----------------------------------------------------------------------------
; (+LOOP)_nfa
PPLOOP_nfa:
        .byte   $87
        .byte   "(+LOOP"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   LIT_nfa
; (+LOOP)
PPLOOP:
        .word   PPLOOP_pfa
; ----------------------------------------------------------------------------
; (LOOP)_nfa
PLOOP_nfa:
        .byte   $86
        .byte   "(LOOP"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   PPLOOP_nfa
; (LOOP)
PLOOP:
        .word   PLOOP_pfa
; ----------------------------------------------------------------------------
; 0BRANCH_nfa
ZBRANCH_nfa:
        .byte   $87
        .byte   "0BRANC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   PLOOP_nfa
; 0BRANCH
ZBRANCH:
        .word   ZBRANCH_pfa
; ----------------------------------------------------------------------------
BRANCH_nfa:
        .byte   $86
        .byte   "BRANC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   ZBRANCH_nfa
BRANCH:
        .word   BRANCH_pfa
; ----------------------------------------------------------------------------
; (OF)_nfa
POF_nfa:
        .byte   $84
        .byte   "(OF"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   BRANCH_nfa
; (OF)
POF:
        .word   POF_pfa
; ----------------------------------------------------------------------------
; (OF")_nfa
POFQUOT_nfa:
        .byte   $85
        .byte   "(OF"
        .byte   $22,$A9
; ----------------------------------------------------------------------------
        .word   POF_nfa
; (OF")
POFQUOT:
        .word   DOCOL
        .word   DUP
        .word   RFROM
        .word   DUP
        .word   CAT
        .word   ONEP
        .word   TWODUP
        .word   PLUS
        .word   TOR
        .word   SEQUAL
        .word   ZBRANCH
        .word   LC1B1
        .word   DROP
        .word   RFROM
        .word   TWOP
        .word   BRANCH
        .word   LC1B5
LC1B1:
        .word   RFROM
        .word   AT
LC1B5:
        .word   TOR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?LEAVE_nfa
ZLEAVE_nfa:
        .byte   $86
        .byte   "?LEAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   POFQUOT_nfa
; ?LEAVE
ZLEAVE:
        .word   LC1C4
; ----------------------------------------------------------------------------
LC1C4:
        inx
        inx
        lda     $FE,x
        ora     $FF,x
        beq     LC1E0
LEAVE_pfa:
        sty     NEXT+2
        stx     _XSAVE
        tsx
        lda     _TIB_+1,x
        sta     _TIB_+3,x
        lda     _TIB_+2,x
        sta     _TIB_+4,x
        ldx     _XSAVE
LC1E0:
        jmp     NEXT

; ----------------------------------------------------------------------------
LEAVE_nfa:
        .byte   $85
        .byte   "LEAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   ZLEAVE_nfa
LEAVE:
        .word   LEAVE_pfa
; ----------------------------------------------------------------------------
; (DO)_nfa
PDO_nfa:
        .byte   $84
        .byte   "(DO"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   LEAVE_nfa
; (DO)
PDO:
        .word   LC1F6
; ----------------------------------------------------------------------------
LC1F6:
        lda     SECOND+1,x
        pha
        lda     SECOND,x
        pha
        lda     BOT+1,x
        pha
        lda     BOT,x
        pha
POPTWO:
        inx
        inx
POP:
        inx
        inx
        jmp     NEXT

; ----------------------------------------------------------------------------
I_nfa:
        .byte   $81,$C9
; ----------------------------------------------------------------------------
        .word   PDO_nfa
I:      .word   LC20F
; ----------------------------------------------------------------------------
LC20F:
        stx     _XSAVE
        tsx
        lda     _TIB_+1,x
        pha
        lda     _TIB_+2,x
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
R_nfa:
        .byte   $81,$D2
; ----------------------------------------------------------------------------
        .word   I_nfa
R:      .word   LC20F
; ----------------------------------------------------------------------------
J_nfa:
        .byte   $81,$CA
; ----------------------------------------------------------------------------
        .word   R_nfa
J:      .word   LC22A
; ----------------------------------------------------------------------------
LC22A:
        stx     _XSAVE
        tsx
        lda     _TIB_+5,x
        pha
        lda     _TIB_+6,x
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
DIGIT_nfa:
        .byte   $85
        .byte   "DIGI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   J_nfa
DIGIT:
        .word   LC243
; ----------------------------------------------------------------------------
LC243:
        sec
        lda     SECOND,x
        sbc     #$30
        bmi     LC262
        cmp     #$0A
        bmi     LC255
        sec
        sbc     #$07
        cmp     #$0A
        bmi     LC262
LC255:
        cmp     BOT,x
        bpl     LC262
        sta     SECOND,x
        lda     #$01
        pha
        tya
        jmp     PUT

; ----------------------------------------------------------------------------
LC262:
        tya
        pha
        inx
        inx
        jmp     PUT

; ----------------------------------------------------------------------------
; (FIND)_nfa
PFIND_nfa:
        .byte   $86
        .byte   "(FIND"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   DIGIT_nfa
; (FIND)
PFIND:
        .word   LC274
; ----------------------------------------------------------------------------
LC274:
        lda     #$02
        jsr     SETUP
        stx     _XSAVE
LC27B:
        ldy     #$00
        lda     (N),y
        eor     (N+2),y
        and     #$3F
        bne     LC2B2
LC285:
        iny
        lda     (N),y
        eor     (N+2),y
        asl
        bne     LC2B0
        bcc     LC285
        ldx     _XSAVE
        dex
        dex
        dex
        dex
        clc
        tya
        adc     #$05
        adc     N
        sta     SECOND,x
        ldy     #$00
        tya
        adc     N+1
        sta     SECOND+1,x
        sty     BOT+1,x
        lda     (N),y
        sta     BOT,x
        lda     #$01
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
LC2B0:
        bcs     LC2B7
LC2B2:
        iny
        lda     (N),y
        bpl     LC2B2
LC2B7:
        iny
        lda     (N),y
        tax
        iny
        lda     (N),y
        sta     N+1
        stx     N
        ora     N
        bne     LC27B
        ldx     _XSAVE
        lda     #$00
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
; S=_nfa
SEQUAL_nfa:
        .byte   $82
        .byte   "S"
        .byte   $BD
; ----------------------------------------------------------------------------
        .word   PFIND_nfa
; S=
SEQUAL:
        .word   LC2D5
; ----------------------------------------------------------------------------
LC2D5:
        lda     #$03
        jsr     SETUP
LC2DA:
        lda     (N+2),y
        eor     (N+4),y
        asl
        bne     LC2EE
        iny
        cpy     N
        bne     LC2DA
        lda     #$01
        pha
        lda     #$00
        jmp     PUSH

; ----------------------------------------------------------------------------
LC2EE:
        lda     #$00
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
ENCLOSE_nfa:
        .byte   $87
        .byte   "ENCLOS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SEQUAL_nfa
ENCLOSE:
        .word   LC300
; ----------------------------------------------------------------------------
LC300:
        lda     #$02
        jsr     SETUP
        txa
        sec
        sbc     #$08
        tax
        sty     SECOND+1,x
        sty     BOT+1,x
        lda     N
LC310:
        cmp     (N+2),y
        bne     LC322
        iny
        bne     LC310
        inc     N+3
        inc     $05  ,x
        inc     SECOND+1,x
        inc     BOT+1,x
        jmp     LC310

; ----------------------------------------------------------------------------
LC322:
        sty     $04  ,x
LC324:
        sty     SECOND,x
        lda     (N+2),y
        bne     LC33A
        sty     BOT,x
        tya
        cmp     $04  ,x
        bne     LC337
        inc     SECOND,x
        bne     LC337
        inc     SECOND+1,x
LC337:
        jmp     NEXT

; ----------------------------------------------------------------------------
LC33A:
        iny
        bne     LC343
        inc     N+3
        inc     SECOND+1,x
        inc     BOT+1,x
LC343:
        cmp     N
        bne     LC324
        sty     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
CMOVE_nfa:
        .byte   $85
        .byte   "CMOV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   ENCLOSE_nfa
CMOVE:
        .word   LC356
; ----------------------------------------------------------------------------
LC356:
        lda     #$03
        jsr     SETUP
LC35B:
        lda     (N+4),y
        cpy     N
        bne     LC368
        dec     N+1
        bpl     LC368
        jmp     NEXT

; ----------------------------------------------------------------------------
LC368:
        sta     (N+2),y
        iny
        bne     LC35B
        inc     N+5
        inc     N+3
        jmp     LC35B

; ----------------------------------------------------------------------------
; CMOVE>_nfa
CMOVEFROM_nfa:
        .byte   $86
        .byte   "CMOVE"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   CMOVE_nfa
; CMOVE>
CMOVEFROM:
        .word   LC37F
; ----------------------------------------------------------------------------
LC37F:
        lda     #$03
        jsr     SETUP
        ldy     N
        bne     LC38C
        lda     N+1
        beq     LC3AE
LC38C:
        clc
        lda     N+5
        adc     N+1
        sta     N+5
        clc
        lda     N+3
        adc     N+1
        sta     N+3
        jmp     LC3A2

; ----------------------------------------------------------------------------
LC39D:
        dey
        lda     (N+4),y
        sta     (N+2),y
LC3A2:
        cpy     #$00
        bne     LC39D
        dec     N+5
        dec     N+3
        dec     N+1
        bpl     LC39D
LC3AE:
        jmp     NEXT

; ----------------------------------------------------------------------------
; U*_nfa
USTAR_nfa:
        .byte   $82
        .byte   "U"
        .byte   $AA
; ----------------------------------------------------------------------------
        .word   CMOVEFROM_nfa
; U*
USTAR:
        .word   LC3B8
; ----------------------------------------------------------------------------
LC3B8:
        lda     SECOND,x
        sta     N
        sty     SECOND,x
        lda     SECOND+1,x
        sta     N+1
        sty     SECOND+1,x
        ldy     #$10
LC3C6:
        asl     SECOND,x
        rol     SECOND+1,x
        rol     BOT,x
        rol     BOT+1,x
        bcc     LC3E1
        clc
        lda     N
        adc     SECOND,x
        sta     SECOND,x
        lda     N+1
        adc     SECOND+1,x
        sta     SECOND+1,x
        bcc     LC3E1
        inc     BOT,x
LC3E1:
        dey
        bne     LC3C6
        jmp     NEXT

; ----------------------------------------------------------------------------
; U/_nfa
USL_nfa:
        .byte   $82
        .byte   "U"
        .byte   $AF
; ----------------------------------------------------------------------------
        .word   USTAR_nfa
; U/
USL:
        .word   LC3EE
; ----------------------------------------------------------------------------
LC3EE:
        lda     $04  ,x
        ldy     SECOND,x
        sty     $04  ,x
        asl
        sta     SECOND,x
        lda     $05  ,x
        ldy     SECOND+1,x
        sty     $05  ,x
        rol
        sta     SECOND+1,x
        lda     #$10
        sta     N
LC404:
        rol     $04  ,x
        rol     $05  ,x
        sec
        lda     $04  ,x
        sbc     BOT,x
        tay
        lda     $05  ,x
        sbc     BOT+1,x
        bcc     LC418
        sty     $04  ,x
        sta     $05  ,x
LC418:
        rol     SECOND,x
        rol     SECOND+1,x
        dec     N
        bne     LC404
        jmp     POP

; ----------------------------------------------------------------------------
AND_nfa:
        .byte   $83
        .byte   "AN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   USL_nfa
; AND (pour éviter la confusion avec l'instruction AND du 6502 par XA)
ANDforth:
        .word   LC42B
; ----------------------------------------------------------------------------
LC42B:
        lda     BOT,x
        and     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        and     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
OR_nfa:
        .byte   $82
        .byte   "O"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   AND_nfa
OR:
        .word   LC441
; ----------------------------------------------------------------------------
LC441:
        lda     BOT,x
        ora     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        ora     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
XOR_nfa:
        .byte   $83
        .byte   "XO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   OR_nfa
XOR:
        .word   LC458
; ----------------------------------------------------------------------------
LC458:
        lda     BOT,x
        eor     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        eor     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
NOT_nfa:
        .byte   $83
        .byte   "NO"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   XOR_nfa
NOT:
        .word   LC46F
; ----------------------------------------------------------------------------
LC46F:
        dey
        tya
        eor     BOT,x
        sta     BOT,x
        tya
        eor     BOT+1,x
        sta     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; ;S_nfa
SEMIS_nfa:
        .byte   $82
        .byte   ";"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   NOT_nfa
; ;S
SEMIS:
        .word   LC484
; ----------------------------------------------------------------------------
LC484:
        pla
        sta     IP
        pla
        sta     IP+1
        jmp     NEXT

; ----------------------------------------------------------------------------
; SP@_nfa
SPat_nfa:
        .byte   $83
        .byte   "SP"
        .byte   $C0
; ----------------------------------------------------------------------------
        .word   SEMIS_nfa
; SP@
SPat:
        .word   LC495
; ----------------------------------------------------------------------------
LC495:
        txa
PUSH0A:
        pha
        lda     #$00
        jmp     PUSH

; ----------------------------------------------------------------------------
; SP!_nfa
SPstore_nfa:
        .byte   $83
        .byte   "SP"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   SPat_nfa
; SP!
SPstore:
        .word   LC4A4
; ----------------------------------------------------------------------------
LC4A4:
        ldy     #$06
        lda     (UP),y
        tax
        jmp     NEXT

; ----------------------------------------------------------------------------
; RP!_nfa
RPSTORE_nfa:
        .byte   $83
        .byte   "RP"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   SPstore_nfa
; RP!
RPSTORE:
        .word   RPSTORE_pfa
; ----------------------------------------------------------------------------
; Appelé par PWARM
RPSTORE_pfa:
        stx     _XSAVE
        ldy     #$08
        lda     (UP),y
        tax
        txs
        ldx     _XSAVE
        sta     NEXT
        jmp     NEXT

; ----------------------------------------------------------------------------
; RP@_nfa
RPAT_nfa:
        .byte   $83
        .byte   "RP"
        .byte   $C0
; ----------------------------------------------------------------------------
        .word   RPSTORE_nfa
        .word   LC4CC
; ----------------------------------------------------------------------------
LC4CC:
        stx     _XSAVE
        tsx
        txa
        pha
        lda     #$01
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
; 2*_nfa
TWOSTAR_nfa:
        .byte   $82
        .byte   "2"
        .byte   $AA
; ----------------------------------------------------------------------------
        .word   RPAT_nfa
; 2*
TWOSTAR:
        .word   LC4DF
; ----------------------------------------------------------------------------
LC4DF:
        asl     BOT,x
        rol     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2/_nfa
TWOSL_nfa:
        .byte   $82
        .byte   "2"
        .byte   $AF
; ----------------------------------------------------------------------------
        .word   TWOSTAR_nfa
; 2/
TWOSL:
        .word   LC4ED
; ----------------------------------------------------------------------------
LC4ED:
        lda     BOT+1,x
        asl
        ror     BOT+1,x
        ror     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2**_nfa
TWOPOWER_nfa:
        .byte   $83
        .byte   "2*"
        .byte   $AA
; ----------------------------------------------------------------------------
        .word   TWOSL_nfa
        .word   LC4FF
; ----------------------------------------------------------------------------
LC4FF:
        ldy     BOT,x
        beq     LC521
        bpl     LC516
LC505:
        lda     SECOND+1,x
        asl
        ror     SECOND+1,x
        ror     SECOND,x
        ror     $05  ,x
        ror     $04  ,x
        iny
        bne     LC505
        jmp     LC521

; ----------------------------------------------------------------------------
LC516:
        asl     $04  ,x
        rol     $05  ,x
        rol     SECOND,x
        rol     SECOND+1,x
        dey
        bne     LC516
LC521:
        jmp     POP

; ----------------------------------------------------------------------------
; 1+_nfa
ONEP_nfa:
        .byte   $82
        .byte   "1"
        .byte   $AB
; ----------------------------------------------------------------------------
        .word   TWOPOWER_nfa
; 1+
ONEP:
        .word   LC52B
; ----------------------------------------------------------------------------
LC52B:
        inc     BOT,x
        bne     LC531
        inc     BOT+1,x
LC531:
        jmp     NEXT

; ----------------------------------------------------------------------------
; 1-_nfa
ONES_nfa:
        .byte   $82
        .byte   "1"
        .byte   $AD
; ----------------------------------------------------------------------------
        .word   ONEP_nfa
; 1-
ONES:
        .word   LC53B
; ----------------------------------------------------------------------------
LC53B:
        lda     BOT,x
        bne     LC541
        dec     BOT+1,x
LC541:
        dec     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2+_nfa
TWOP_nfa:
        .byte   $82
        .byte   "2"
        .byte   $AB
; ----------------------------------------------------------------------------
        .word   ONES_nfa
; 2+
TWOP:
        .word   DOCOL
        .word   ONEP
        .word   ONEP
        .word   SEMIS
; ----------------------------------------------------------------------------
; 2-_nfa
TWOS_nfa:
        .byte   $82
        .byte   "2"
        .byte   $AD
; ----------------------------------------------------------------------------
        .word   TWOP_nfa
; 2-
TWOS:
        .word   DOCOL
        .word   ONES
        .word   ONES
        .word   SEMIS
; ----------------------------------------------------------------------------
; >R_nfa
TOR_nfa:
        .byte   $82
        .byte   ">"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   TWOS_nfa
; >R
TOR:
        .word   LC567
; ----------------------------------------------------------------------------
LC567:
        lda     BOT+1,x
        pha
        lda     BOT,x
        pha
        inx
        inx
        jmp     NEXT

; ----------------------------------------------------------------------------
; R>_nfa
RFROM_nfa:
        .byte   $82
        .byte   "R"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   TOR_nfa
; R>
RFROM:
        .word   LC579
; ----------------------------------------------------------------------------
LC579:
        dex
        dex
        pla
        sta     BOT,x
        pla
        sta     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; DUP>R_nfa
DUPTOR_nfa:
        .byte   $85
        .byte   "DUP>"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   RFROM_nfa
; DUP>R
DUPTOR:
        .word   LC58E
; ----------------------------------------------------------------------------
LC58E:
        lda     BOT+1,x
        pha
        lda     BOT,x
        pha
        jmp     NEXT

; ----------------------------------------------------------------------------
; R>DROP_nfa
RFROMDROP_nfa:
        .byte   $86
        .byte   "R>DRO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DUPTOR_nfa
; R>DROP
RFROMDROP:
        .word   LC5A2
; ----------------------------------------------------------------------------
LC5A2:
        pla
        pla
        jmp     NEXT

; ----------------------------------------------------------------------------
; 0=_nfa
ZEQUAL_nfa:
        .byte   $82
        .byte   "0"
        .byte   $BD
; ----------------------------------------------------------------------------
        .word   RFROMDROP_nfa
; 0=
ZEQUAL:
        .word   LC5AE
; ----------------------------------------------------------------------------
LC5AE:
        lda     BOT+1,x
        sty     BOT+1,x
        ora     BOT,x
        bne     LC5B7
        iny
LC5B7:
        sty     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 0<_nfa
ZLESS_nfa:
        .byte   $82
        .byte   "0"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   ZEQUAL_nfa
; 0<
ZLESS:
        .word   LC5C3
; ----------------------------------------------------------------------------
LC5C3:
        asl     BOT+1,x
        sty     BOT+1,x
        tya
        rol
        sta     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 0>_nfa
ZGREAT_nfa:
        .byte   $82
        .byte   "0"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   ZLESS_nfa
; 0>
ZGREAT:
        .word   LC5D5
; ----------------------------------------------------------------------------
LC5D5:
        lda     BOT+1,x
        sty     BOT+1,x
        bmi     LC5E0
        ora     BOT,x
        beq     LC5E0
        iny
LC5E0:
        sty     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; =_nfa
EQUAL_nfa:
        .byte   $81,$BD
; ----------------------------------------------------------------------------
        .word   ZGREAT_nfa
; =
EQUAL:
        .word   DOCOL
        .word   SUB
        .word   ZEQUAL
        .word   SEMIS
; ----------------------------------------------------------------------------
; <_nfa
LESS_nfa:
        .byte   $81,$BC
; ----------------------------------------------------------------------------
        .word   EQUAL_nfa
; <
LESS:
        .word   DOCOL
        .word   SUB
        .word   ZLESS
        .word   SEMIS
; ----------------------------------------------------------------------------
; >_nfa
GREAT_nfa:
        .byte   $81,$BE
; ----------------------------------------------------------------------------
        .word   LESS_nfa
; >
GREAT:
        .word   DOCOL
        .word   SUB
        .word   ZGREAT
; ----------------------------------------------------------------------------
        .byte   $82
        .byte   $C4
; -_nfa
SUB_nfa:
        .byte   $81,$AD
; ----------------------------------------------------------------------------
        .word   GREAT_nfa
; -
SUB:
        .word   LC60F
; ----------------------------------------------------------------------------
LC60F:
        sec
        lda     SECOND,x
        sbc     BOT,x
        sta     SECOND,x
        lda     SECOND+1,x
        sbc     BOT+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; +_nfa
PLUS_nfa:
        .byte   $81,$AB
; ----------------------------------------------------------------------------
        .word   SUB_nfa
; +
PLUS:
        .word   LC625
; ----------------------------------------------------------------------------
LC625:
        clc
        lda     SECOND,x
        adc     BOT,x
        sta     SECOND,x
        lda     SECOND+1,x
        adc     BOT+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; D+_nfa
DPLUS_nfa:
        .byte   $82
        .byte   "D"
        .byte   $AB
; ----------------------------------------------------------------------------
        .word   PLUS_nfa
; D+
DPLUS:
        .word   LC63C
; ----------------------------------------------------------------------------
LC63C:
        clc
        lda     $06  ,x
        adc     SECOND,x
        sta     $06  ,x
        lda     $07  ,x
        adc     SECOND+1,x
        sta     $07  ,x
        lda     $04  ,x
        adc     BOT,x
        sta     $04  ,x
        lda     $05  ,x
        adc     BOT+1,x
        sta     $05  ,x
        jmp     POPTWO

; ----------------------------------------------------------------------------
MINUS_nfa:
        .byte   $85
        .byte   "MINU"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   DPLUS_nfa
MINUS:
        .word   LC662
; ----------------------------------------------------------------------------
LC662:
        sec
LC663:
        tya
        sbc     BOT,x
        sta     BOT,x
        tya
        sbc     BOT+1,x
        sta     BOT+1,x
        sty     NEXT
        jmp     NEXT

; ----------------------------------------------------------------------------
DMINUS_nfa:
        .byte   $86
        .byte   "DMINU"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   MINUS_nfa
DMINUS:
        .word   LC67E
; ----------------------------------------------------------------------------
LC67E:
        sec
        tya
        sbc     SECOND,x
        sta     SECOND,x
        tya
        sbc     SECOND+1,x
        sta     SECOND+1,x
        jmp     LC663

; ----------------------------------------------------------------------------
DROP_nfa:
        .byte   $84
        .byte   "DRO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DMINUS_nfa
DROP:
        .word   POP
; ----------------------------------------------------------------------------
NIP_nfa:
        .byte   $83
        .byte   "NI"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DROP_nfa
NIP:
        .word   LC69D
; ----------------------------------------------------------------------------
LC69D:
        lda     BOT,x
        sta     SECOND,x
        lda     BOT+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; 2DROP_nfa
TWODROP_nfa:
        .byte   $85
        .byte   "2DRO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   NIP_nfa
; 2DROP
TWODROP:
        .word   POPTWO
; ----------------------------------------------------------------------------
; S->D_nfa
STOD_nfa:
        .byte   $84
        .byte   "S->"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   TWODROP_nfa
; S->D
STOD:
        .word   LC6BB
; ----------------------------------------------------------------------------
LC6BB:
        lda     BOT+1,x
        bpl     LC6C0
        dey
LC6C0:
        tya
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
; -DUP_nfa
DDUP_nfa:
        .byte   $84
        .byte   "-DU"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   STOD_nfa
; -DUP
DDUP:
        .word   LC6CE
; ----------------------------------------------------------------------------
LC6CE:
        lda     BOT,x
        ora     BOT+1,x
        beq     LC6DE
LC6D4:
        dex
        dex
        lda     SECOND,x
        sta     BOT,x
        lda     SECOND+1,x
        sta     BOT+1,x
LC6DE:
        jmp     NEXT

; ----------------------------------------------------------------------------
DUP_nfa:
        .byte   $83
        .byte   "DU"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DDUP_nfa
DUP:
        .word   LC6D4
; ----------------------------------------------------------------------------
OVER_nfa:
        .byte   $84
        .byte   "OVE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   DUP_nfa
OVER:
        .word   LC6F2
; ----------------------------------------------------------------------------
LC6F2:
        lda     SECOND,x
        pha
        lda     SECOND+1,x
        jmp     PUSH

; ----------------------------------------------------------------------------
; 2DUP_nfa
TWODUP_nfa:
        .byte   $84
        .byte   "2DU"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   OVER_nfa
; 2DUP
TWODUP:
        .word   LC703
; ----------------------------------------------------------------------------
LC703:
        ldy     #$04
LC705:
        dex
        lda     $04  ,x
        sta     BOT,x
        dey
        bne     LC705
        jmp     NEXT

; ----------------------------------------------------------------------------
PICK_nfa:
        .byte   $84
        .byte   "PIC"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   TWODUP_nfa
PICK:
        .word   LC719
; ----------------------------------------------------------------------------
LC719:
        stx     _XSAVE
        lda     BOT,x
        asl
        clc
        adc     _XSAVE
        tax
        lda     BOT,x
        pha
        lda     BOT+1,x
        ldx     _XSAVE
        jmp     PUT

; ----------------------------------------------------------------------------
SWAP_nfa:
        .byte   $84
        .byte   "SWA"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   PICK_nfa
SWAP:
        .word   LC735
; ----------------------------------------------------------------------------
LC735:
        lda     BOT,x
        ldy     SECOND,x
        sta     SECOND,x
        sty     BOT,x
        lda     BOT+1,x
        ldy     SECOND+1,x
        sta     SECOND+1,x
        sty     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
ROT_nfa:
        .byte   $83
        .byte   "RO"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   SWAP_nfa
ROT:
        .word   LC750
; ----------------------------------------------------------------------------
LC750:
        lda     $04  ,x
        pha
        ldy     $05  ,x
        lda     SECOND,x
        sta     $04  ,x
        lda     SECOND+1,x
        sta     $05  ,x
        lda     BOT,x
        sta     SECOND,x
        lda     BOT+1,x
        sta     SECOND+1,x
        tya
        jmp     PUT

; ----------------------------------------------------------------------------
; 2SWAP_nfa
TWOSWAP_nfa:
        .byte   $85
        .byte   "2SWA"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   ROT_nfa
LC771:
        .word   DOCOL
        .word   ROT
        .word   TOR
        .word   ROT
        .word   RFROM
        .word   SEMIS
; ----------------------------------------------------------------------------
ROLL_nfa:
        .byte   $84
        .byte   "ROL"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   TWOSWAP_nfa
        .word   DOCOL
        .word   DUPTOR
        .word   PICK
        .word   SPat
        .word   DUP
        .word   TWOP
        .word   RFROM
        .word   TWOSTAR
        .word   CMOVEFROM
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
; +!_nfa
PSTORE_nfa:
        .byte   $82
        .byte   "+"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   ROLL_nfa
; +!
PSTORE:
        .word   LC7A1
; ----------------------------------------------------------------------------
LC7A1:
        clc
        lda     (BOT,x)
        adc     SECOND,x
        sta     (BOT,x)
        inc     BOT,x
        bne     LC7AE
        inc     BOT+1,x
LC7AE:
        lda     (BOT,x)
        adc     SECOND+1,x
        sta     (BOT,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
TOGGLE_nfa:
        .byte   $86
        .byte   "TOGGL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   PSTORE_nfa
TOGGLE:
        .word   LC7C2
; ----------------------------------------------------------------------------
LC7C2:
        lda     BOT,x
        eor     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
CSET_nfa:
        .byte   $84
        .byte   "CSE"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   TOGGLE_nfa
CSET:
        .word   LC7D4
; ----------------------------------------------------------------------------
LC7D4:
        lda     BOT,x
        ora     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
CRST_nfa:
        .byte   $84
        .byte   "CRS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CSET_nfa
CRST:
        .word   LC7E6
; ----------------------------------------------------------------------------
LC7E6:
        lda     BOT,x
        eor     #$FF
        and     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
CTST_nfa:
        .byte   $84
        .byte   "CTS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CRST_nfa
CTST:
        .word   LC7FA
; ----------------------------------------------------------------------------
LC7FA:
        lda     BOT,x
        and     (SECOND,x)
        sty     SECOND+1,x
        beq     LC803
        iny
LC803:
        sty     SECOND,x
        jmp     POP

; ----------------------------------------------------------------------------
; C!_nfa
CSTORE_nfa:
        .byte   $82
        .byte   "C"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   CTST_nfa
; C!
CSTORE:
        .word   LC80F
; ----------------------------------------------------------------------------
LC80F:
        lda     SECOND,x
        sta     (BOT,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; C@_nfa
CAT_nfa:
        .byte   $82
        .byte   "C"
        .byte   $C0
; ----------------------------------------------------------------------------
        .word   CSTORE_nfa
; C@
CAT:
        .word   LC81D
; ----------------------------------------------------------------------------
LC81D:
        lda     (BOT,x)
        sta     BOT,x
        sty     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
COUNT_nfa:
        .byte   $85
        .byte   "COUN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CAT_nfa
COUNT:
        .word   LC830
; ----------------------------------------------------------------------------
LC830:
        lda     (BOT,x)
        pha
        inc     BOT,x
        bne     LC839
        inc     BOT+1,x
LC839:
        tya
        jmp     PUSH

; ----------------------------------------------------------------------------
; !_nfa
STORE_nfa:
        .byte   $81,$A1
; ----------------------------------------------------------------------------
        .word   COUNT_nfa
; !
STORE:
        .word   LC843
; ----------------------------------------------------------------------------
LC843:
        lda     SECOND,x
        sta     (BOT,x)
        inc     BOT,x
        bne     LC84D
        inc     BOT+1,x
LC84D:
        lda     SECOND+1,x
        sta     (BOT,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; @_nfa
AT_nfa:
        .byte   $81,$C0
; ----------------------------------------------------------------------------
        .word   STORE_nfa
; @
AT:
        .word   LC85A
; ----------------------------------------------------------------------------
LC85A:
        lda     (BOT,x)
        pha
        inc     BOT,x
        bne     LC863
        inc     BOT+1,x
LC863:
        lda     (BOT,x)
        jmp     PUT

; ----------------------------------------------------------------------------
WCOUNT_nfa:
        .byte   $86
        .byte   "WCOUN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   AT_nfa
WCOUNT:
        .word   LC873
; ----------------------------------------------------------------------------
LC873:
        lda     (BOT,x)
        pha
        inc     BOT,x
        bne     LC87C
        inc     BOT+1,x
LC87C:
        lda     (BOT,x)
        inc     BOT,x
        bne     LC884
        inc     BOT+1,x
LC884:
        jmp     PUSH

; ----------------------------------------------------------------------------
; 2@_nfa
TWOAT_nfa:
        .byte   $82
        .byte   "2"
        .byte   $C0
; ----------------------------------------------------------------------------
        .word   WCOUNT_nfa
        .word   DOCOL
        .word   DUPTOR
        .word   TWOP
        .word   AT
        .word   RFROM
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
; 2!_nfa
TWOSTORE_nfa:
        .byte   $82
        .byte   "2"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   TWOAT_nfa
; 2!
TWOSTORE:
        .word   DOCOL
        .word   DUPTOR
        .word   STORE
        .word   RFROM
        .word   TWOP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; :_nfa
COLON_nfa:
        .byte   $C1,$BA
; ----------------------------------------------------------------------------
        .word   TWOSTORE_nfa
        .word   DOCOL
        .word   QEXEC
        .word   STORECSP
        .word   CURRENT
        .word   AT
        .word   CONTEXT
        .word   STORE
        .word   CREATE
        .word   RBRACKET
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOCOL:
        lda     IP+1
        pha
        lda     IP
        pha
        clc
        lda     #$02
        adc     W
        sta     IP
        tya
        adc     W+1
        sta     IP+1
        jmp     NEXT

; ----------------------------------------------------------------------------
CONSTANT_nfa:
        .byte   $88
        .byte   "CONSTAN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   COLON_nfa
CONSTANT:
        .word   DOCOL
        .word   CREATE
        .word   SMUDGE
        .word   COMMA
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOCON:
        ldy     #$02
        lda     (W),y
        pha
        iny
        lda     (W),y
        jmp     PUSH

; ----------------------------------------------------------------------------
; 0_nfa
ZERO_nfa:
        .byte   $81,$B0
; ----------------------------------------------------------------------------
        .word   CONSTANT_nfa
; 0
ZERO:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0000
; ----------------------------------------------------------------------------
; 1_nfa
ONE_nfa:
        .byte   $81,$B1
; ----------------------------------------------------------------------------
        .word   ZERO_nfa
; 1
ONE:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0001
; ----------------------------------------------------------------------------
; 2_nfa
TWO_nfa:
        .byte   $81,$B2
; ----------------------------------------------------------------------------
        .word   ONE_nfa
; 2
TWO:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0002
; ----------------------------------------------------------------------------
BL_nfa:
        .byte   $82
        .byte   "B"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   TWO_nfa
BL:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0020
; ----------------------------------------------------------------------------
VARIABLE_nfa:
        .byte   $88
        .byte   "VARIABL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   BL_nfa
        .word   DOCOL
        .word   CREATE
        .word   SMUDGE
        .word   HERE
        .word   TWOP
        .word   COMMA
        .word   COMMA
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOVAR:
        ldy     #$02
        lda     (W),y
        pha
        iny
        lda     (W),y
        jmp     PUSH

; ----------------------------------------------------------------------------
USER_nfa:
        .byte   $84
        .byte   "USE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   VARIABLE_nfa
        .word   DOCOL
        .word   CONSTANT
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOUSER:
        clc
        ldy     #$02
        lda     (W),y
        adc     UP
        pha
        lda     #$00
        adc     UP+1
        jmp     PUSH

; ----------------------------------------------------------------------------
; DOES>_nfa
DOES_nfa:
        .byte   $85
        .byte   "DOES"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   USER_nfa
; DOES>
DOES:
        .word   DOCOL
        .word   RFROM
        .word   LATEST
        .word   PFA
        .word   STORE
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DODOES:
        lda     IP+1
        pha
        lda     IP
        pha
        ldy     #$02
        lda     (W),y
        sta     IP
        sty     NEXT+2
        iny
        lda     (W),y
        sta     IP+1
        clc
        lda     #$04
        adc     W
        pha
        lda     #$00
        adc     W+1
        jmp     PUSH

; ----------------------------------------------------------------------------
S0_nfa:
        .byte   $82
        .byte   "S"
        .byte   $B0
; ----------------------------------------------------------------------------
        .word   DOES_nfa
S0:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0006
; ----------------------------------------------------------------------------
R0_nfa:
        .byte   $82
        .byte   "R"
        .byte   $B0
; ----------------------------------------------------------------------------
        .word   S0_nfa
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0008
; ----------------------------------------------------------------------------
TIB_nfa:
        .byte   $83
        .byte   "TI"
        .byte   $C2
; ----------------------------------------------------------------------------
        .word   R0_nfa
TIB:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $000A
; ----------------------------------------------------------------------------
WIDTH_nfa:
        .byte   $85
        .byte   "WIDT"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   TIB_nfa
WIDTH:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $000C
; ----------------------------------------------------------------------------
WARNING_nfa:
        .byte   $87
        .byte   "WARNIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   WIDTH_nfa
WARNING:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $000E
; ----------------------------------------------------------------------------
FENCE_nfa:
        .byte   $85
        .byte   "FENC"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   WARNING_nfa
FENCE:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0010
; ----------------------------------------------------------------------------
DP_nfa:
        .byte   $82
        .byte   "D"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   FENCE_nfa
DP:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0012
; ----------------------------------------------------------------------------
; VOC-LINK_nfa
VOCLINK_nfa:
        .byte   $88
        .byte   "VOC-LIN"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   DP_nfa
; VOC-LINK
VOCLINK:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0014
; ----------------------------------------------------------------------------
BLK_nfa:
        .byte   $83
        .byte   "BL"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   VOCLINK_nfa
BLK:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0016
; ----------------------------------------------------------------------------
IN_nfa:
        .byte   $82
        .byte   "I"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   BLK_nfa
IN:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0018
; ----------------------------------------------------------------------------
OUT_nfa:
        .byte   $83
        .byte   "OU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   IN_nfa
OUT:
        .word   DOUSER
; ----------------------------------------------------------------------------
LCA07:
        .word   $001A
; ----------------------------------------------------------------------------
SCR_nfa:
        .byte   $83
        .byte   "SC"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   OUT_nfa
SCR:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $001C
; ----------------------------------------------------------------------------
CONTEXT_nfa:
        .byte   $87
        .byte   "CONTEX"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   SCR_nfa
CONTEXT:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0020
; ----------------------------------------------------------------------------
CURRENT_nfa:
        .byte   $87
        .byte   "CURREN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CONTEXT_nfa
CURRENT:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0022
; ----------------------------------------------------------------------------
STATE_nfa:
        .byte   $85
        .byte   "STAT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   CURRENT_nfa
STATE:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0024
; ----------------------------------------------------------------------------
BASE_nfa:
        .byte   $84
        .byte   "BAS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   STATE_nfa
BASE:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0026
; ----------------------------------------------------------------------------
DPL_nfa:
        .byte   $83
        .byte   "DP"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   BASE_nfa
DPL:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0028
; ----------------------------------------------------------------------------
CSP_nfa:
        .byte   $83
        .byte   "CS"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DPL_nfa
CSP:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $002C
; ----------------------------------------------------------------------------
; R#_nfa
RNUM_nfa:
        .byte   $82
        .byte   "R"
        .byte   $A3
; ----------------------------------------------------------------------------
        .word   CSP_nfa
; R#
RNUM:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $002E
; ----------------------------------------------------------------------------
HLD_nfa:
        .byte   $83
        .byte   "HL"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   RNUM_nfa
HLD:
        .word   DOUSER
; ----------------------------------------------------------------------------
        .word   $0030
; ----------------------------------------------------------------------------
; +ORIGIN_nfa
PORIGIN_nfa:
        .byte   $87
        .byte   "+ORIGI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   HLD_nfa
; +ORIGIN
PORIGIN:
        .word   DOCOL
        .word   LIT
        .word   ORIGIN
        .word   PLUS
        .word   SEMIS
; ----------------------------------------------------------------------------
HERE_nfa:
        .byte   $84
        .byte   "HER"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   PORIGIN_nfa
HERE:
        .word   DOCOL
        .word   DP
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
ALLOT_nfa:
        .byte   $85
        .byte   "ALLO"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   HERE_nfa
ALLOT:
        .word   DOCOL
        .word   DP
        .word   PSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; C,_nfa
CCOMMA_nfa:
        .byte   $82
        .byte   "C"
        .byte   $AC
; ----------------------------------------------------------------------------
        .word   ALLOT_nfa
; C,
CCOMMA:
        .word   DOCOL
        .word   HERE
        .word   CSTORE
        .word   ONE
        .word   ALLOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; ,_nfa
COMMA_nfa:
        .byte   $81,$AC
; ----------------------------------------------------------------------------
        .word   CCOMMA_nfa
; ,
COMMA:
        .word   DOCOL
        .word   HERE
        .word   STORE
        .word   TWO
        .word   ALLOT
        .word   SEMIS
; ----------------------------------------------------------------------------
LATEST_nfa:
        .byte   $86
        .byte   "LATES"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   COMMA_nfa
LATEST:
        .word   DOCOL
        .word   CURRENT
        .word   AT
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
DEFINITIONS_nfa:
        .byte   $8B
        .byte   "DEFINITION"

        .byte   $D3
; ----------------------------------------------------------------------------
        .word   LATEST_nfa
DEFINITIONS:
        .word   DOCOL
        .word   CONTEXT
        .word   AT
        .word   CURRENT
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
IMMEDIATE_nfa:
        .byte   $89
        .byte   "IMMEDIAT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   DEFINITIONS_nfa
        .word   DOCOL
        .word   LATEST
        .word   LIT
        .word   $40
        .word   TOGGLE
        .word   SEMIS
; ----------------------------------------------------------------------------
SMUDGE_nfa:
        .byte   $86
        .byte   "SMUDG"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   IMMEDIATE_nfa
SMUDGE:
        .word   DOCOL
        .word   LATEST
        .word   LIT
        .word   $20
        .word   TOGGLE
        .word   SEMIS
; ----------------------------------------------------------------------------
TRAVERSE_nfa:
        .byte   $88
        .byte   "TRAVERS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SMUDGE_nfa
TRAVERSE:
        .word   DOCOL
        .word   SWAP
LCB2A:
        .word   OVER
        .word   PLUS
        .word   DUP
        .word   LIT
        .word   $80
        .word   CTST
        .word   ZBRANCH
        .word   LCB2A
        .word   SWAP
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
PFA_nfa:
        .byte   $83
        .byte   "PF"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   TRAVERSE_nfa
PFA:
        .word   DOCOL
        .word   ONE
        .word   TRAVERSE
        .word   LIT
        .word   $05
        .word   PLUS
        .word   SEMIS
; ----------------------------------------------------------------------------
NFA_nfa:
        .byte   $83
        .byte   "NF"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   PFA_nfa
NFA:
        .word   DOCOL
        .word   LIT
        .word   $05
        .word   SUB
        .word   LIT
        .word   $FFFF
        .word   TRAVERSE
        .word   SEMIS
; ----------------------------------------------------------------------------
CFA_nfa:
        .byte   $83
        .byte   "CF"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   NFA_nfa
CFA:
        .word   DOCOL
        .word   TWOS
        .word   SEMIS
; ----------------------------------------------------------------------------
LFA_nfa:
        .byte   $83
        .byte   "LF"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   CFA_nfa
LFA:
        .word   DOCOL
        .word   TWOS
        .word   TWOS
        .word   SEMIS
; ----------------------------------------------------------------------------
; <BUILDS_nfa
BUILDS_nfa:
        .byte   $87
        .byte   "<BUILD"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   LFA_nfa
; <BUILDS
BUILDS:
        .word   DOCOL
        .word   ZERO
        .word   CONSTANT
        .word   SEMIS
; ----------------------------------------------------------------------------
; (;CODE)_nfa
PSEMICODE_nfa:
        .byte   $87
        .byte   "(;CODE"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   BUILDS_nfa
; (;CODE)
PSEMICODE:
        .word   DOCOL
        .word   RFROM
        .word   LATEST
        .word   PFA
        .word   CFA
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
RECURSE_nfa:
        .byte   $C7
        .byte   "RECURS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   PSEMICODE_nfa
        .word   DOCOL
        .word   QCOMP
        .word   LATEST
        .word   PFA
        .word   CFA
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
SPACE_nfa:
        .byte   $85
        .byte   "SPAC"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   RECURSE_nfa
SPACE:
        .word   DOCOL
        .word   BL
        .word   EMIT
        .word   SEMIS
; ----------------------------------------------------------------------------
SPACES_nfa:
        .byte   $86
        .byte   "SPACE"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   SPACE_nfa
SPACES:
        .word   DOCOL
        .word   ZERO
        .word   MAX
        .word   DDUP
        .word   ZBRANCH
        .word   LCBF5
        .word   ZERO
        .word   PDO
LCBEF:
        .word   SPACE
        .word   PLOOP
        .word   LCBEF
LCBF5:
        .word   SEMIS
; ----------------------------------------------------------------------------
TYPE_nfa:
        .byte   $84
        .byte   "TYP"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SPACES_nfa
TYPE:
        .word   DOCOL
        .word   DDUP
        .word   ZBRANCH
        .word   LCC12
        .word   ZERO
        .word   PDO
LCC0A:
        .word   COUNT
        .word   EMIT
        .word   PLOOP
        .word   LCC0A
LCC12:
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
MOVE_nfa:
        .byte   $84
        .byte   "MOV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   TYPE_nfa
        .word   DOCOL
        .word   TOR
        .word   TWODUP
        .word   LESS
        .word   ZBRANCH
        .word   LCC31
        .word   RFROM
        .word   CMOVEFROM
        .word   BRANCH
        .word   LCC35
LCC31:
        .word   RFROM
        .word   CMOVE
LCC35:
        .word   SEMIS
; ----------------------------------------------------------------------------
FILL_nfa:
        .byte   $84
        .byte   "FIL"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   MOVE_nfa
FILL:
        .word   DOCOL
        .word   OVER
        .word   ZGREAT
        .word   ZBRANCH
        .word   LCC5E
        .word   SWAP
        .word   TOR
        .word   OVER
        .word   CSTORE
        .word   DUP
        .word   ONEP
        .word   RFROM
        .word   ONES
        .word   CMOVE
        .word   BRANCH
        .word   LCC62
LCC5E:
        .word   TWODROP
        .word   DROP
LCC62:
        .word   SEMIS
; ----------------------------------------------------------------------------
ERASE_nfa:
        .byte   $85
        .byte   "ERAS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   FILL_nfa
ERASE:
        .word   DOCOL
        .word   ZERO
        .word   FILL
        .word   SEMIS
; ----------------------------------------------------------------------------
BLANKS_nfa:
        .byte   $86
        .byte   "BLANK"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   ERASE_nfa
BLANKS:
        .word   DOCOL
        .word   BL
        .word   FILL
        .word   SEMIS
; ----------------------------------------------------------------------------
; -TRAILING_nfa
DTRAILING_nfa:
        .byte   $89
        .byte   "-TRAILIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   BLANKS_nfa
; -TRALING
DTRAILING:
        .word   DOCOL
        .word   DUP
        .word   ZERO
        .word   PDO
LCC99:
        .word   TWODUP
        .word   PLUS
        .word   ONES
        .word   CAT
        .word   BL
        .word   SUB
        .word   ZBRANCH
        .word   LCCAF
        .word   LEAVE
        .word   BRANCH
        .word   LCCB1
LCCAF:
        .word   ONES
LCCB1:
        .word   PLOOP
        .word   LCC99
        .word   SEMIS
; ----------------------------------------------------------------------------
DEPTH_nfa:
        .byte   $85
        .byte   "DEPT"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   DTRAILING_nfa
DEPTH:
        .word   DOCOL
        .word   SPat
        .word   S0
        .word   AT
        .word   SWAP
        .word   SUB
        .word   TWOSL
        .word   SEMIS
; ----------------------------------------------------------------------------
; D+-_nfa
DPM_nfa:
        .byte   $83
        .byte   "D+"
        .byte   $AD
; ----------------------------------------------------------------------------
        .word   DEPTH_nfa
; D+-
DPM:
        .word   DOCOL
        .word   ZLESS
        .word   ZBRANCH
        .word   LCCDF
        .word   DMINUS
LCCDF:
        .word   SEMIS
; ----------------------------------------------------------------------------
DABS_nfa:
        .byte   $84
        .byte   "DAB"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   DPM_nfa
DABS:
        .word   DOCOL
        .word   DUP
        .word   DPM
        .word   SEMIS
; ----------------------------------------------------------------------------
; +-_nfa
PM_nfa:
        .byte   $82
        .byte   "+"
        .byte   $AD
; ----------------------------------------------------------------------------
        .word   DABS_nfa
; +-
PM:
        .word   DOCOL
        .word   ZLESS
        .word   ZBRANCH
        .word   LCCFF
        .word   MINUS
LCCFF:
        .word   SEMIS
; ----------------------------------------------------------------------------
ABS_nfa:
        .byte   $83
        .byte   "AB"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   PM_nfa
ABS:
        .word   DOCOL
        .word   DUP
        .word   PM
        .word   SEMIS
; ----------------------------------------------------------------------------
MAX_nfa:
        .byte   $83
        .byte   "MA"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   ABS_nfa
MAX:
        .word   DOCOL
        .word   TWODUP
        .word   LESS
        .word   ZBRANCH
        .word   LCD21
        .word   SWAP
LCD21:
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
MIN_nfa:
        .byte   $83
        .byte   "MI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   MAX_nfa
MIN:
        .word   DOCOL
        .word   TWODUP
        .word   GREAT
        .word   ZBRANCH
        .word   LCD37
        .word   SWAP
LCD37:
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
; U<_nfa
ULESS_nfa:
        .byte   $82
        .byte   "U"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   MIN_nfa
; U<
ULESS:
        .word   DOCOL
        .word   ZERO
        .word   SWAP
        .word   ZERO
        .word   DMINUS
        .word   DPLUS
        .word   NIP
        .word   ZLESS
        .word   SEMIS
; ----------------------------------------------------------------------------
; M/MOD_nfa
MSLMOD_nfa:
        .byte   $85
        .byte   "M/MO"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   ULESS_nfa
; M/MOD
MSLMOD:
        .word   DOCOL
        .word   TOR
        .word   ZERO
        .word   R
        .word   USL
        .word   RFROM
        .word   SWAP
        .word   TOR
        .word   USL
        .word   RFROM
        .word   SEMIS
; ----------------------------------------------------------------------------
; M/_nfa
MSL_nfa:
        .byte   $82
        .byte   "M"
        .byte   $AF
; ----------------------------------------------------------------------------
        .word   MSLMOD_nfa
; M/
MSL:
        .word   DOCOL
        .word   OVER
        .word   TOR
        .word   TOR
        .word   DABS
        .word   R
        .word   ABS
        .word   USL
        .word   RFROM
        .word   R
        .word   XOR
        .word   PM
        .word   SWAP
        .word   RFROM
        .word   PM
        .word   SWAP
        .word   SEMIS
; ----------------------------------------------------------------------------
; /MOD_nfa
SLMOD_nfa:
        .byte   $84
        .byte   "/MO"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   MSL_nfa
; /MOD
SLMOD:
        .word   DOCOL
        .word   TOR
        .word   STOD
        .word   RFROM
        .word   MSL
        .word   SEMIS
; ----------------------------------------------------------------------------
; /_nfa
SLASH_nfa:
        .byte   $81,$AF
; ----------------------------------------------------------------------------
        .word   SLMOD_nfa
; /
SLASH:
        .word   DOCOL
        .word   SLMOD
        .word   NIP
        .word   SEMIS
; ----------------------------------------------------------------------------
MOD_nfa:
        .byte   $83
        .byte   "MO"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   SLASH_nfa
MOD:
        .word   DOCOL
        .word   SLMOD
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
; M*_nfa
MSTAR_nfa:
        .byte   $82
        .byte   "M"
        .byte   $AA
; ----------------------------------------------------------------------------
        .word   MOD_nfa
; M*
MSTAR:
        .word   DOCOL
        .word   TWODUP
        .word   XOR
        .word   TOR
        .word   ABS
        .word   SWAP
        .word   ABS
        .word   USTAR
        .word   RFROM
        .word   DPM
        .word   SEMIS
; ----------------------------------------------------------------------------
; *_nfa
STAR_nfa:
        .byte   $81,$AA
; ----------------------------------------------------------------------------
        .word   MSTAR_nfa
; *
STAR:
        .word   DOCOL
        .word   MSTAR
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
; */MOD_nfa
STARSLMOD_nfa:
        .byte   $85
        .byte   "*/MO"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   STAR_nfa
; */MOD
STARSLMOD:
        .word   DOCOL
        .word   TOR
        .word   MSTAR
        .word   RFROM
        .word   MSL
        .word   SEMIS
; ----------------------------------------------------------------------------
; */_nfa
STARSL_nfa:
        .byte   $82
        .byte   "*"
        .byte   $AF
; ----------------------------------------------------------------------------
        .word   STARSLMOD_nfa
; */
STARSL:
        .word   DOCOL
        .word   STARSLMOD
        .word   NIP
        .word   SEMIS
; ----------------------------------------------------------------------------
DECIMAL_nfa:
        .byte   $87
        .byte   "DECIMA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   STARSL_nfa
DECIMAL:
        .word   DOCOL
        .word   LIT
        .word   $0A
        .word   BASE
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
HEX_nfa:
        .byte   $83
        .byte   "HE"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   DECIMAL_nfa
HEX:
        .word   DOCOL
        .word   LIT
        .word   $10
        .word   BASE
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
BIN_nfa:
        .byte   $83
        .byte   "BI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   HEX_nfa
        .word   DOCOL
        .word   TWO
        .word   BASE
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
PAD_nfa:
        .byte   $83
        .byte   "PA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   BIN_nfa
PAD:
        .word   DOCOL
        .word   HERE
        .word   LIT
        .word   $44
        .word   PLUS
        .word   SEMIS
; ----------------------------------------------------------------------------
; <#_nfa
BDIGS_nfa:
        .byte   $82
        .byte   "<"
        .byte   $A3
; ----------------------------------------------------------------------------
        .word   PAD_nfa
; <#
BDIGS:
        .word   DOCOL
        .word   PAD
        .word   HLD
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
HOLD_nfa:
        .byte   $84
        .byte   "HOL"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   BDIGS_nfa
HOLD:
        .word   DOCOL
        .word   LIT
        .word   $FFFF
        .word   HLD
        .word   PSTORE
        .word   HLD
        .word   AT
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
SIGN_nfa:
        .byte   $84
        .byte   "SIG"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   HOLD_nfa
SIGN:
        .word   DOCOL
        .word   ROT
        .word   ZLESS
        .word   ZBRANCH
        .word   LCE95
        .word   LIT
        .word   $2D
        .word   HOLD
LCE95:
        .word   SEMIS
; ----------------------------------------------------------------------------
; #_nfa
DIG_nfa:
        .byte   $81,$A3
; ----------------------------------------------------------------------------
        .word   SIGN_nfa
; #
DIG:
        .word   DOCOL
        .word   BASE
        .word   AT
        .word   MSLMOD
        .word   ROT
        .word   LIT
        .word   $09
        .word   OVER
        .word   LESS
        .word   ZBRANCH
        .word   LCEB7
        .word   LIT
        .word   $07
        .word   PLUS
LCEB7:
        .word   LIT
        .word   $30
        .word   PLUS
        .word   HOLD
        .word   SEMIS
; ----------------------------------------------------------------------------
; #S_nfa
DIGS_nfa:
        .byte   $82
        .byte   "#"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   DIG_nfa
; #S
DIGS:
        .word   DOCOL
LCEC8:
        .word   DIG
        .word   TWODUP
        .word   OR
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LCEC8
        .word   SEMIS
; ----------------------------------------------------------------------------
; #>_nfa
EDIGS_nfa:
        .byte   $82
        .byte   "#"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   DIGS_nfa
; #>
EDIGS:
        .word   DOCOL
        .word   TWODROP
        .word   HLD
        .word   AT
        .word   PAD
        .word   OVER
        .word   SUB
        .word   SEMIS
; ----------------------------------------------------------------------------
; D.R_nfa
DDOTR_nfa:
        .byte   $83
        .byte   "D."
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   EDIGS_nfa
; D.R
DDOTR:
        .word   DOCOL
        .word   TOR
        .word   SWAP
        .word   OVER
        .word   DABS
        .word   BDIGS
        .word   DIGS
        .word   SIGN
        .word   EDIGS
        .word   RFROM
        .word   OVER
        .word   SUB
        .word   SPACES
        .word   TYPE
        .word   SEMIS
; ----------------------------------------------------------------------------
; D._nfa
DDOT_nfa:
        .byte   $82
        .byte   "D"
        .byte   $AE
; ----------------------------------------------------------------------------
        .word   DDOTR_nfa
; D.
DDOT:
        .word   DOCOL
        .word   ZERO
        .word   DDOTR
        .word   SPACE
        .word   SEMIS
; ----------------------------------------------------------------------------
; .R_nfa
DOTR_nfa:
        .byte   $82
        .byte   "."
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   DDOT_nfa
; .R
DOTR:
        .word   DOCOL
        .word   TOR
        .word   STOD
        .word   RFROM
        .word   DDOTR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ._nfa
DOT_nfa:
        .byte   $81,$AE
; ----------------------------------------------------------------------------
        .word   DOTR_nfa
; .
DOT:
        .word   DOCOL
        .word   STOD
        .word   DDOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?_nfa
QUESTION_nfa:
        .byte   $81,$BF
; ----------------------------------------------------------------------------
        .word   DOT_nfa
; ?
QUESTION:
        .word   DOCOL
        .word   AT
        .word   DOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; U._nfa
UDOT_nfa:
        .byte   $82
        .byte   "U"
        .byte   $AE
; ----------------------------------------------------------------------------
        .word   QUESTION_nfa
; U.
UDOT:
        .word   DOCOL
        .word   ZERO
        .word   DDOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; H._nfa
HDOT_nfa:
        .byte   $82
        .byte   "H"
        .byte   $AE
; ----------------------------------------------------------------------------
        .word   UDOT_nfa
        .word   DOCOL
        .word   BASE
        .word   AT
        .word   HEX
        .word   SWAP
        .word   UDOT
        .word   BASE
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?COMP_nfa
QCOMP_nfa:
        .byte   $85
        .byte   "?COM"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   HDOT_nfa
; ?COMP
QCOMP:
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   ZEQUAL
        .word   LIT
        .word   $11
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
COMPILE_nfa:
        .byte   $87
        .byte   "COMPIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   QCOMP_nfa
COMPILE:
        .word   DOCOL
        .word   QCOMP
        .word   RFROM
        .word   WCOUNT
        .word   COMMA
        .word   TOR
        .word   SEMIS
; ----------------------------------------------------------------------------
LITERAL_nfa:
        .byte   $C7
        .byte   "LITERA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   COMPILE_nfa
LITERAL:
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   ZBRANCH
        .word   LCFB5
        .word   COMPILE
        .word   LIT
        .word   COMMA
LCFB5:
        .word   SEMIS
; ----------------------------------------------------------------------------
DLITERAL_nfa:
        .byte   $C8
        .byte   "DLITERA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   LITERAL_nfa
DLITERAL:
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   ZBRANCH
        .word   LCFD2
        .word   SWAP
        .word   LITERAL
        .word   LITERAL
LCFD2:
        .word   SEMIS
; ----------------------------------------------------------------------------
backslash_C_nfa:
        .byte   $82
        .byte   "\"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   DLITERAL_nfa
        .word   DOCOL
        .word   DUP
        .word   UDOT
        .word   WCOUNT
        .word   TWOP
        .word   NFA
        .word   IDDOT
        .word   SEMIS
; ----------------------------------------------------------------------------
backslash_L_nfa:
        .byte   $82
        .byte   "\"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   backslash_C_nfa
        .word   DOCOL
        .word   DUP
        .word   UDOT
        .word   WCOUNT
        .word   DOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; backslash S<space>
backslash_S_nfa:
        .byte   $82
        .byte   "\S"
        .byte   $A0
; ----------------------------------------------------------------------------
        .word   backslash_L_nfa
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
backslash_J_nfa:
        .byte   $82
        .byte   "\"
        .byte   $CA
; ----------------------------------------------------------------------------
        .word   backslash_S_nfa
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
backslash_D_nfa:
        .byte   $82
        .byte   "\"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   backslash_J_nfa
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
; ----------------------------------------------------------------------------
WORD_nfa:
        .byte   $84
        .byte   "WOR"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   backslash_D_nfa
WORD:
        .word   DOCOL
        .word   BLK
        .word   AT
        .word   ZBRANCH
        .word   LD06F
        .word   BLK
        .word   AT
        .word   BLOCK
        .word   BRANCH
        .word   LD073
LD06F:
        .word   TIB
        .word   AT
LD073:
        .word   IN
        .word   AT
        .word   PLUS
        .word   SWAP
        .word   ENCLOSE
        .word   HERE
        .word   LIT
        .word   $22
        .word   BLANKS
        .word   IN
        .word   PSTORE
        .word   OVER
        .word   SUB
        .word   TOR
        .word   R
        .word   HERE
        .word   CSTORE
        .word   PLUS
        .word   HERE
        .word   ONEP
        .word   RFROM
        .word   CMOVE
        .word   SEMIS
; ----------------------------------------------------------------------------
ASCII_nfa:
        .byte   $C5
        .byte   "ASCI"
        .byte   $C9
; ----------------------------------------------------------------------------
        .word   WORD_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   ONEP
        .word   CAT
        .word   LITERAL
        .word   SEMIS
; ----------------------------------------------------------------------------
; (_nfa
LPAREN_nfa:
        .byte   $C1,$A8
; ----------------------------------------------------------------------------
        .word   ASCII_nfa
        .word   DOCOL
        .word   LIT
        .word   $29
        .word   WORD
        .word   SEMIS
; ----------------------------------------------------------------------------
; (.")_nfa
PDOTQ_nfa:
        .byte   $84
        .byte   "(."
        .byte   $22,$A9
; ----------------------------------------------------------------------------
        .word   LPAREN_nfa
; (.")
PDOTQ:
        .word   DOCOL
        .word   RFROM
        .word   COUNT
        .word   TWODUP
        .word   PLUS
        .word   TOR
        .word   TYPE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ."_nfa
DOTQ_nfa:
        .byte   $C2
        .byte   "."
        .byte   $A2
; ----------------------------------------------------------------------------
        .word   PDOTQ_nfa
        .word   DOCOL
        .word   LIT
        .word   $22
        .word   STATE
        .word   AT
        .word   ZBRANCH
        .word   LD103
        .word   COMPILE
        .word   PDOTQ
        .word   WORD
        .word   HERE
        .word   CAT
        .word   ONEP
        .word   ALLOT
        .word   BRANCH
        .word   LD10B
LD103:
        .word   WORD
        .word   HERE
        .word   COUNT
        .word   TYPE
LD10B:
        .word   SEMIS
; ----------------------------------------------------------------------------
; -FIND_nfa
DFIND_nfa:
        .byte   $85
        .byte   "-FIN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   DOTQ_nfa
; -FIND
DFIND:
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   CONTEXT
        .word   AT
        .word   AT
        .word   PFIND
        .word   DUP
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LD143
        .word   CONTEXT
        .word   AT
        .word   CURRENT
        .word   AT
        .word   SUB
        .word   ZBRANCH
        .word   LD143
        .word   DROP
        .word   HERE
        .word   LATEST
        .word   PFIND
LD143:
        .word   SEMIS
; ----------------------------------------------------------------------------
; '_nfa
TICK_nfa:
        .byte   $C1,$A7
; ----------------------------------------------------------------------------
        .word   DFIND_nfa
; '
TICK:
        .word   DOCOL
        .word   DFIND
        .word   ZEQUAL
        .word   LIT
        .word   $05
        .word   QERROR
        .word   DROP
        .word   LITERAL
        .word   SEMIS
; ----------------------------------------------------------------------------
; [COMPILE]_nfa
BCOMPILE_nfa:
        .byte   $C9
        .byte   "[COMPILE"
        .byte   $DD
; ----------------------------------------------------------------------------
        .word   TICK_nfa
        .word   DOCOL
        .word   DFIND
        .word   ZEQUAL
        .word   LIT
        .word   $05
        .word   QERROR
        .word   DROP
        .word   CFA
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
OFF_nfa:
        .byte   $83
        .byte   "OF"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   BCOMPILE_nfa
OFF:
        .word   DOCOL
        .word   ZERO
        .word   SWAP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
ON_nfa:
        .byte   $82
        .byte   "O"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   OFF_nfa
        .word   DOCOL
        .word   ONE
        .word   SWAP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; [_nfa
LBRACKET_nfa:
        .byte   $C1,$DB
; ----------------------------------------------------------------------------
        .word   ON_nfa
; [
LBRACKET:
        .word   DOCOL
        .word   STATE
        .word   OFF
        .word   SEMIS
; ----------------------------------------------------------------------------
; ]_nfa
RBRACKET_nfa:
        .byte   $81,$DD
; ----------------------------------------------------------------------------
        .word   LBRACKET_nfa
; ]
RBRACKET:
        .word   DOCOL
        .word   LIT
        .word   $C0
        .word   STATE
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; !CSP_nfa
STORECSP_nfa:
        .byte   $84
        .byte   "!CS"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   RBRACKET_nfa
; !CSP
STORECSP:
        .word   DOCOL
        .word   SPat
        .word   CSP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?CSP_nfa
QCSP_nfa:
        .byte   $84
        .byte   "?CS"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   STORECSP_nfa
; ?CSP
QCSP:
        .word   DOCOL
        .word   SPat
        .word   CSP
        .word   AT
        .word   SUB
        .word   LIT
        .word   $14
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ;_nfa
SEMI_nfa:
        .byte   $C1,$BB
; ----------------------------------------------------------------------------
        .word   QCSP_nfa
        .word   DOCOL
        .word   QCSP
        .word   COMPILE
        .word   SEMIS
        .word   SMUDGE
        .word   LBRACKET
        .word   SEMIS
; ----------------------------------------------------------------------------
; (LIT")_nfa
PLITQ_nfa:
        .byte   $86
        .byte   "(LIT"
        .byte   $22,$A9
; ----------------------------------------------------------------------------
        .word   SEMI_nfa
; (LIT")
PLITQ:
        .word   DOCOL
        .word   RFROM
        .word   DUP
        .word   COUNT
        .word   PLUS
        .word   TOR
        .word   SEMIS
; ----------------------------------------------------------------------------
; LIT"_nfa
LITQ_nfa:
        .byte   $C4
        .byte   "LIT"
        .byte   $A2
; ----------------------------------------------------------------------------
        .word   PLITQ_nfa
        .word   DOCOL
        .word   QCOMP
        .word   COMPILE
        .word   PLITQ
        .word   LIT
        .word   $22
        .word   WORD
        .word   HERE
        .word   CAT
        .word   ONEP
        .word   ALLOT
        .word   SEMIS
; ----------------------------------------------------------------------------
MSG:
        .byte   $00,$0A
        .byte   "pas trouve"

        .byte   $01,$09
        .byte   "pile vide"

        .byte   $02,$12
        .byte   "dictionnaire plein"


        .byte   $03,$1A
        .byte   "mode d'adressage incorrect"



        .byte   $04,$0A
        .byte   "(redefini)"

        .byte   $05,$1B
        .byte   "inconnu dans ce vocabulaire"



        .byte   $07,$0B
        .byte   "pile pleine"

        .byte   $0A,$1A
        .byte   "OVSAVE: compiler deux fois"



        .byte   $0B,$17
        .byte   "OVSAVE: utiliser OV6502"


        .byte   $0D,$1A
        .byte   "la base doit etre decimale"



        .byte   $0F,$20
        .byte   "TELE-FORTH V1.2 - Thierry "



        .byte   "BESTEL"
        .byte   $11,$17
        .byte   "en definition seulement"


        .byte   $12,$19
        .byte   "hors definition seulement"



        .byte   $13,$16
        .byte   "controles mal appaires"


        .byte   $14,$15
        .byte   "definition incomplete"


        .byte   $15,$14
        .byte   "dictionnaire protege"


        .byte   $16,$14
        .byte   "sur disque seulement"


        .byte   $17,$0D
        .byte   "lignes 0 a 15"

        .byte   $18,$17
        .byte   "declarer un vocabulaire"


        .byte   $1C,$11
        .byte   "valeur incorrecte"


        .byte   $81,$12
        .byte   "Fichier inexistant"


        .byte   $82,$0D
        .byte   "Erreur disque"

        .byte   $83,$10
        .byte   "Fichier existant"

        .byte   $84,$10
        .byte   "Disquette pleine"

        .byte   $85,$12
        .byte   "Disquette protegee"


        .byte   $86,$0E
        .byte   "Erreur de type"

        .byte   $87,$16
        .byte   "Disquette non STRATSED"


        .byte   $88,$0F
        .byte   "Pas de STRATSED"

        .byte   $89,$18
        .byte   "Nom de fichier incorrect"


        .byte   $8A,$0E
        .byte   "Lecteur absent"

        .byte   $FE
        .byte   "+TELE-FORTH V1.2"

        .byte   $0D,$0A
        .byte   "genere avec TELE-ASS V1.0a"



        .byte   $FF,$32
        .byte   "Base sur TELE-FORTH V1.1 "

        .byte   $0D,$0A
        .byte   "de Christophe LAVARENNE"

.dsb $D524-*,$00

MESSAGE_nfa:
        .byte   $87
        .byte   "MESSAG"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   LITQ_nfa
MESSAGE:
        .word   DOCOL
        .word   CR
        .word   LIT
        .word   $FF
        .word   ANDforth
        .word   TOR
        .word   LIT
        .word   MSG
LD53E:
        .word   COUNT
        .word   R
        .word   LESS
        .word   ZBRANCH
        .word   LD550
        .word   COUNT
        .word   PLUS
        .word   BRANCH
        .word   LD53E
LD550:
        .word   ONES
        .word   COUNT
        .word   R
        .word   EQUAL
        .word   WARNING
        .word   AT
        .word   ANDforth
        .word   ZBRANCH
        .word   LD56C
        .word   COUNT
        .word   TYPE
        .word   SPACE
        .word   BRANCH
        .word   LD579
LD56C:
        .word   DROP
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $04
        .byte   "Msg:"
; ----------------------------------------------------------------------------
        .word   R
        .word   DOT
LD579:
        .word   RFROMDROP
        .word   SEMIS
; ----------------------------------------------------------------------------
DEFER_nfa:
        .byte   $85
        .byte   "DEFE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   MESSAGE_nfa
        .word   DOCOL
        .word   CREATE
        .word   SMUDGE
        .word   HERE
        .word   TWO
        .word   ALLOT
        .word   HERE
        .word   TWO
        .word   ALLOT
        .word   LIT
        .word   NEXT
        .word   CFA
        .word   OVER
        .word   STORE
        .word   SWAP
        .word   STORE
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DODEFER:
        ldy     #$03
        lda     (W),y
        sta     N+1
        dey
        lda     (W),y
        sta     N
        dey
        lda     (N),y
        sta     W+1
        dey
        lda     (N),y
        sta     W
        jmp     W-1

; ----------------------------------------------------------------------------
; (IS)_nfa
PIS_nfa:
        .byte   $84
        .byte   "(IS"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   DEFER_nfa
; (IS)
PIS:
        .word   DOCOL
        .word   SWAP
        .word   CFA
        .word   SWAP
        .word   AT
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
IS_nfa:
        .byte   $C2
        .byte   "I"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   PIS_nfa
        .word   DOCOL
        .word   TICK
        .word   STATE
        .word   AT
        .word   ZBRANCH
        .word   LD5ED
        .word   COMPILE
        .word   PIS
        .word   BRANCH
        .word   LD5EF
LD5ED:
        .word   PIS
LD5EF:
        .word   SEMIS
; ----------------------------------------------------------------------------
; B/BUF_nfa
B_BUF_nfa:
        .byte   $85
        .byte   "B/BU"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   IS_nfa
; B/BUF
B_BUF:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0400
; ----------------------------------------------------------------------------
; B/SCR_nfa
B_SCR_nfa:
        .byte   $85
        .byte   "B/SC"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   B_BUF_nfa
; B/SCR
B_SCR:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0001
; ----------------------------------------------------------------------------
FIRST_nfa:
        .byte   $85
        .byte   "FIRS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   B_SCR_nfa
FIRST:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $1000
; ----------------------------------------------------------------------------
LIMIT_nfa:
        .byte   $85
        .byte   "LIMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   FIRST_nfa
LIMIT:
        .word   DOCON
        .word   RAM_START
; ----------------------------------------------------------------------------
; EMPTY-BUFFERS_nfa
EMPTYBUFFERS_nfa:
        .byte   $8D
        .byte   "EMPTY-BUFFER"

        .byte   $D3
; ----------------------------------------------------------------------------
        .word   LIMIT_nfa
; EMPTY-BUFFERS
EMPTYBUFFERS:
        .word   DOCOL
        .word   FIRST
        .word   LIMIT
        .word   OVER
        .word   SUB
        .word   ERASE
        .word   SEMIS
; ----------------------------------------------------------------------------
UPDATE_nfa:
        .byte   $86
        .byte   "UPDAT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   EMPTYBUFFERS_nfa
UPDATE:
        .word   DOCOL
        .word   FIRST
        .word   AT
        .word   LIT
        .word   $8000
        .word   OR
        .word   FIRST
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
FLUSH_nfa:
        .byte   $85
        .byte   "FLUS"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   UPDATE_nfa
FLUSH:
        .word   DOCOL
        .word   FIRST
        .word   AT
        .word   ZLESS
        .word   ZBRANCH
        .word   LD680
        .word   FIRST
        .word   DUP
        .word   ONEP
        .word   LIT
        .word   $80
        .word   CRST
        .word   WCOUNT
        .word   ZERO
        .word   RSLW
LD680:
        .word   SEMIS
; ----------------------------------------------------------------------------
BLOCK_nfa:
        .byte   $85
        .byte   "BLOC"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   FLUSH_nfa
BLOCK:
        .word   DOCOL
        .word   FIRST
        .word   AT
        .word   OVER
        .word   XOR
        .word   TWOSTAR
        .word   ZBRANCH
        .word   LD6AA
        .word   FLUSH
        .word   DUP
        .word   FIRST
        .word   STORE
        .word   FIRST
        .word   WCOUNT
        .word   ONE
        .word   RSLW
LD6AA:
        .word   DROP
        .word   FIRST
        .word   TWOP
        .word   SEMIS
; ----------------------------------------------------------------------------
ABORT_nfa:
        .byte   $85
        .byte   "ABOR"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   BLOCK_nfa
ABORT:
        .word   DODEFER
        .word   RAM_START
; ----------------------------------------------------------------------------
ERROR_nfa:
        .byte   $85
        .byte   "ERRO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   ABORT_nfa
ERROR:
        .word   DOCOL
        .word   WARNING
        .word   AT
        .word   ZLESS
        .word   ZBRANCH
        .word   LD6D4
        .word   ABORT
LD6D4:
        .word   HERE
        .word   COUNT
        .word   TYPE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $03
        .byte   " ? "
; ----------------------------------------------------------------------------
        .word   MESSAGE
        .word   SPstore
        .word   BLK
        .word   AT
        .word   DDUP
        .word   ZBRANCH
        .word   LD6F6
        .word   IN
        .word   AT
        .word   SWAP
        .word   WHERE
LD6F6:
        .word   QUIT
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?ERROR_nfa
QERROR_nfa:
        .byte   $86
        .byte   "?ERRO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   ERROR_nfa
; ?ERROR
QERROR:
        .word   DOCOL
        .word   SWAP
        .word   ZBRANCH
        .word   LD711
        .word   ERROR
        .word   BRANCH
        .word   LD713
LD711:
        .word   DROP
LD713:
        .word   SEMIS
; ----------------------------------------------------------------------------
; (NUMBER)_nfa
PNUMBER_nfa:
        .byte   $88
        .byte   "(NUMBER"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   QERROR_nfa
; (NUMBER)
PNUMBER:
        .word   DOCOL
LD722:
        .word   ONEP
        .word   DUPTOR
        .word   CAT
        .word   BASE
        .word   AT
        .word   DIGIT
        .word   ZBRANCH
        .word   LD75C
        .word   SWAP
        .word   BASE
        .word   AT
        .word   USTAR
        .word   DROP
        .word   ROT
        .word   BASE
        .word   AT
        .word   USTAR
        .word   DPLUS
        .word   DPL
        .word   AT
        .word   ONEP
        .word   ZBRANCH
        .word   LD756
        .word   ONE
        .word   DPL
        .word   PSTORE
LD756:
        .word   RFROM
        .word   BRANCH
        .word   LD722
LD75C:
        .word   RFROM
        .word   SEMIS
; ----------------------------------------------------------------------------
INUMBER_nfa:
        .byte   $87
        .byte   "INUMBE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   PNUMBER_nfa
INUMBER:
        .word   DOCOL
        .word   ZERO
        .word   ZERO
        .word   ROT
        .word   DUP
        .word   ONEP
        .word   CAT
        .word   LIT
        .word   $2D
        .word   EQUAL
        .word   DUPTOR
        .word   PLUS
        .word   LIT
        .word   $FFFF
LD786:
        .word   DPL
        .word   STORE
        .word   PNUMBER
        .word   DUP
        .word   CAT
        .word   BL
        .word   SUB
        .word   ZBRANCH
        .word   LD7AE
        .word   DUP
        .word   CAT
        .word   LIT
        .word   $2E
        .word   SUB
        .word   LIT
        .word   $05
        .word   QERROR
        .word   ZERO
        .word   BRANCH
        .word   LD786
LD7AE:
        .word   DROP
        .word   RFROM
        .word   ZBRANCH
        .word   LD7B8
        .word   DMINUS
LD7B8:
        .word   SEMIS
; ----------------------------------------------------------------------------
NUMBER_nfa:
        .byte   $86
        .byte   "NUMBE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   INUMBER_nfa
NUMBER:
        .word   DODEFER
        .word   NUMBER_defer
; ----------------------------------------------------------------------------
; .S_nfa
DOTS:
        .byte   $82
        .byte   "."
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   NUMBER_nfa
        .word   DOCOL
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $04
        .byte   "(-- "
; ----------------------------------------------------------------------------
        .word   DEPTH
        .word   ZGREAT
        .word   ZBRANCH
        .word   LD7F5
        .word   SPat
        .word   TWOS
        .word   S0
        .word   AT
        .word   TWOS
        .word   PDO
LD7E9:
        .word   I
        .word   QUESTION
        .word   LIT
        .word   $FFFE
        .word   PPLOOP
        .word   LD7E9
LD7F5:
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   ") "
; ----------------------------------------------------------------------------
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?EXEC_nfa
QEXEC_nfa:
        .byte   $85
        .byte   "?EXE"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   DOTS
; ?EXEC
QEXEC:
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   LIT
        .word   $12
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?STACK_nfa
QSTACK_nfa:
        .byte   $86
        .byte   "?STAC"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   QEXEC_nfa
; ?STACK
QSTACK:
        .word   DOCOL
        .word   SPat
        .word   S0
        .word   AT
        .word   SWAP
        .word   ULESS
        .word   ONE
        .word   QERROR
        .word   SPat
        .word   LIT
        .word   STACK
        .word   ULESS
        .word   LIT
        .word   $07
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?PAIRS_nfa
QPAIRS_nfa:
        .byte   $86
        .byte   "?PAIR"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   QSTACK_nfa
; ?PAIRS
QPAIRS:
        .word   DOCOL
        .word   SUB
        .word   LIT
        .word   $13
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?OK_nfa
QOK_nfa:
        .byte   $83
        .byte   "?O"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   QPAIRS_nfa
; ?OK
QOK:
        .word   DOCOL
LD858:
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   " OK? "
; ----------------------------------------------------------------------------
        .word   KEY
        .word   LIT
        .word   $0D
        .word   POF
        .word   LD872
        .word   ONE
        .word   SEMIS
        .word   BRANCH
        .word   LD8B6
LD872:
        .word   LIT
        .word   $1B
        .word   POF
        .word   LD882
        .word   ZERO
        .word   SEMIS
        .word   BRANCH
        .word   LD8B6
LD882:
        .word   LIT
        .word   $03
        .word   POF
        .word   LD890
        .word   QUIT
        .word   BRANCH
        .word   LD8B6
LD890:
        .word   CR
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $1F
        .byte   "RETURN=oui ESC=non CTRL+C=stop "; D895 52 45 54 55 52 4E 3D 6F



; ----------------------------------------------------------------------------
        .word   DROP
LD8B6:
        .word   BRANCH
        .word   LD858
        .word   SEMIS
; ----------------------------------------------------------------------------
OK_nfa:
        .byte   $82
        .byte   "O"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   QOK_nfa
OK:
        .word   DOCOL
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   "Ok"
; ----------------------------------------------------------------------------
        .word   BASE
        .word   AT
        .word   LIT
        .word   $0A
        .word   POF
        .word   LD8DC
        .word   LIT
        .word   $2E
        .word   BRANCH
        .word   LD902
LD8DC:
        .word   LIT
        .word   $10
        .word   POF
        .word   LD8EC
        .word   LIT
        .word   $23
        .word   BRANCH
        .word   LD902
LD8EC:
        .word   TWO
        .word   POF
        .word   LD8FA
        .word   LIT
        .word   $25
        .word   BRANCH
        .word   LD902
LD8FA:
        .word   LIT
        .word   $2A
        .word   SWAP
        .word   DROP
LD902:
        .word   EMIT
        .word   DEPTH
        .word   DOT
        .word   SEMIS
; ----------------------------------------------------------------------------
PROMPT_nfa:
        .byte   $86
        .byte   "PROMP"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   OK_nfa
PROMPT:
        .word   DODEFER
        .word   PROMPT_defer
; ----------------------------------------------------------------------------
EXPECT_nfa:
        .byte   $86
        .byte   "EXPEC"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   PROMPT_nfa
EXPECT:
        .word   DOCOL
        .word   OVER
        .word   PLUS
        .word   OVER
        .word   PDO
LD92A:
        .word   KEY
        .word   DUP
        .word   I
        .word   CSTORE
        .word   I
        .word   ONEP
        .word   OFF
        .word   BL
        .word   OVER
        .word   GREAT
        .word   OVER
        .word   LIT
        .word   $7E
        .word   GREAT
        .word   OR
        .word   ZBRANCH
        .word   LD9C6
        .word   LIT
        .word   $7F
        .word   POF
        .word   LD980
        .word   DUP
        .word   I
        .word   EQUAL
        .word   DUP
        .word   RFROM
        .word   TWOS
        .word   PLUS
        .word   TOR
        .word   ZBRANCH
        .word   LD970
        .word   LIT
        .word   $07
        .word   BRANCH
        .word   LD97C
LD970:
        .word   LIT
        .word   $08
        .word   DUP
        .word   EMIT
        .word   BL
        .word   EMIT
LD97C:
        .word   BRANCH
        .word   LD9C6
LD980:
        .word   LIT
        .word   $0D
        .word   POF
        .word   LD996
        .word   ZERO
        .word   I
        .word   CSTORE
        .word   LEAVE
        .word   BL
        .word   BRANCH
        .word   LD9C6
LD996:
        .word   ZERO
        .word   I
        .word   CSTORE
        .word   RFROM
        .word   ONES
        .word   TOR
        .word   LIT
        .word   $10
        .word   OVER
        .word   GREAT
        .word   OVER
        .word   LIT
        .word   $17
        .word   GREAT
        .word   OR
        .word   ZBRANCH
        .word   LD9C2
        .word   LIT
        .word   $07
        .word   SWAP
        .word   BRANCH
        .word   LD9C4
LD9C2:
        .word   DUP
LD9C4:
        .word   DROP
LD9C6:
        .word   EMIT
        .word   PLOOP
        .word   LD92A
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
QUERY_nfa:
        .byte   $85
        .byte   "QUER"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   EXPECT_nfa
QUERY:
        .word   DOCOL
        .word   TIB
        .word   AT
        .word   LIT
        .word   $50
        .word   EXPECT
        .word   ZERO
        .word   IN
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; <nul>_nfa
NUL_nfa:
        .byte   $C1,$80
; ----------------------------------------------------------------------------
        .word   QUERY_nfa
        .word   DOCOL
        .word   BLK
        .word   AT
        .word   ZBRANCH
        .word   LDA1E
        .word   ONE
        .word   BLK
        .word   PSTORE
        .word   ZERO
        .word   IN
        .word   STORE
        .word   BLK
        .word   AT
        .word   B_SCR
        .word   ONES
        .word   ANDforth
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LDA1A
        .word   QEXEC
        .word   RFROMDROP
LDA1A:
        .word   BRANCH
        .word   LDA20
LDA1E:
        .word   RFROMDROP
LDA20:
        .word   SEMIS
; ----------------------------------------------------------------------------
INTERPRET_nfa:
        .byte   $89
        .byte   "INTERPRE"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   NUL_nfa
INTERPRET:
        .word   DOCOL
LDA30:
        .word   DFIND
        .word   ZBRANCH
        .word   LDA50
        .word   STATE
        .word   AT
        .word   LESS
        .word   ZBRANCH
        .word   LDA48
        .word   CFA
        .word   COMMA
        .word   BRANCH
        .word   LDA4C
LDA48:
        .word   CFA
        .word   EXECUTE
LDA4C:
        .word   BRANCH
        .word   LDA68
LDA50:
        .word   HERE
        .word   NUMBER
        .word   DPL
        .word   AT
        .word   ONEP
        .word   ZBRANCH
        .word   LDA64
        .word   DLITERAL
        .word   BRANCH
        .word   LDA68
LDA64:
        .word   DROP
        .word   LITERAL
LDA68:
        .word   QSTACK
        .word   BRANCH
        .word   LDA30
        .word   SEMIS
; ----------------------------------------------------------------------------
QUIT_nfa:
        .byte   $84
        .byte   "QUI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   INTERPRET_nfa
QUIT:
        .word   DOCOL
        .word   ZERO
        .word   BLK
        .word   STORE
        .word   LBRACKET
LDA81:
        .word   CR
        .word   RPSTORE
        .word   QUERY
        .word   INTERPRET
        .word   STATE
        .word   AT
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LDA95
        .word   PROMPT
LDA95:
        .word   BRANCH
        .word   LDA81
        .word   SEMIS
; ----------------------------------------------------------------------------
CREATE_nfa:
        .byte   $86
        .byte   "CREAT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   QUIT_nfa
CREATE:
        .word   DOCOL
        .word   DFIND
        .word   ZBRANCH
        .word   LDABA
        .word   DROP
        .word   NFA
        .word   IDDOT
        .word   LIT
        .word   $04
        .word   MESSAGE
        .word   SPACE
LDABA:
        .word   HERE
        .word   DUP
        .word   CAT
        .word   WIDTH
        .word   AT
        .word   MIN
        .word   ONEP
        .word   ALLOT
        .word   DP
        .word   CAT
        .word   LIT
        .word   $FD
        .word   EQUAL
        .word   ALLOT
        .word   DUP
        .word   LIT
        .word   $A0
        .word   TOGGLE
        .word   HERE
        .word   ONES
        .word   LIT
        .word   $80
        .word   TOGGLE
        .word   LATEST
        .word   COMMA
        .word   CURRENT
        .word   AT
        .word   STORE
        .word   HERE
        .word   TWOP
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
VOCABULARY_nfa:
        .byte   $8A
        .byte   "VOCABULAR"

        .byte   $D9
; ----------------------------------------------------------------------------
        .word   CREATE_nfa
        .word   DOCOL
        .word   BUILDS
        .word   HERE
        .word   LIT
        .word   $04
        .word   PLUS
        .word   COMMA
        .word   HERE
        .word   VOCLINK
        .word   AT
        .word   COMMA
        .word   VOCLINK
        .word   STORE
        .word   LIT
        .word   $A081
        .word   COMMA
        .word   CURRENT
        .word   AT
        .word   CFA
        .word   COMMA
        .word   DOES
DOVOC:
        .word   AT
        .word   TWOP
        .word   CONTEXT
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
FORTH_nfa:
        .byte   $C5
        .byte   "FORT"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   VOCABULARY_nfa
FORTH:
        .word   DODOES
FORTH_pfa:
        .word   DOVOC
        .word   FORTH_voc
FORTH_LINK:
        .word   $00
; ----------------------------------------------------------------------------
; ?TERMINAL_nfa
QTERMINAL_nfa:
        .byte   $89
        .byte   "?TERMINA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   FORTH_nfa
; ?TERMINAL
QTERMINAL:
        .word   DODEFER
; ?TERMINAL_pfa, Vérifier si byte ou addr
QTERMINAL_pfa:
        .word   QTERMINAL_defer
; ----------------------------------------------------------------------------
KEY_nfa:
        .byte   $83
        .byte   "KE"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   QTERMINAL_nfa
KEY:
        .word   DODEFER
; Vérifier su byte ou addr
KEY_pfa:
        .word   KEY_defer
; ----------------------------------------------------------------------------
EMIT_nfa:
        .byte   $84
        .byte   "EMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   KEY_nfa
EMIT:
        .word   DODEFER
; Vérifier si byte ou addr
EMIT_pfa:
        .word   EMIT_defer
; ----------------------------------------------------------------------------
; (ABORT)_nfa
PABORT_nfa:
        .byte   $87
        .byte   "(ABORT"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   EMIT_nfa
; (ABORT)
PABORT:
        .word   DOCOL
        .word   SPstore
        .word   DECIMAL
        .word   LIT
        .word   $60
        .word   ZERO
        .word   LIT
        .word   CallTel
        .word   TWOSTORE
        .word   TERMINAL
        .word   CR
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $0C
        .byte   "TELE-FORTH V"

; ----------------------------------------------------------------------------
        .word   LIT
        .word   $01
        .word   LIT
        .word   $30
        .word   PLUS
        .word   EMIT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $01
        .byte   "."
; ----------------------------------------------------------------------------
        .word   LIT
        .word   $02
        .word   LIT
        .word   $30
        .word   PLUS
        .word   EMIT
        .word   SPACE
        .word   HIMEM
        .word   HERE
        .word   SUB
        .word   UDOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $0E
        .byte   "octets libres "

; ----------------------------------------------------------------------------
        .word   FORTH
        .word   DEFINITIONS
        .word   STARTUP
        .word   QUIT
        .word   SEMIS
; ----------------------------------------------------------------------------
COLD_nfa:
        .byte   $84
        .byte   "COL"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   PABORT_nfa
COLD:
        .word   DOCOL
        .word   ROMend
        .word   LIT
        .word   DictInitTable
        .word   DUPTOR
        .word   TWOP
        .word   LIT
        .word   RAM_START
        .word   RFROM
        .word   AT
        .word   CMOVE
        .word   EMPTYBUFFERS
        .word   LIT
        .word   $12
        .word   PORIGIN
        .word   LIT
        .word   UP
        .word   AT
        .word   LIT
        .word   $06
        .word   PLUS
        .word   LIT
        .word   $10
        .word   CMOVE
        .word   LIT
        .word   $0C
        .word   PORIGIN
        .word   AT
        .word   LIT
        .word   FORTH_pfa
        .word   TWOP
        .word   AT
        .word   TWOP
        .word   STORE
        .word   ABORT
        .word   SEMIS
; ----------------------------------------------------------------------------
WARM_nfa:
        .byte   $84
        .byte   "WAR"
        .byte   $CD
; ----------------------------------------------------------------------------
        .word   COLD_nfa
WARM:
        .word   DOCOL
        .word   EMPTYBUFFERS
        .word   ABORT
        .word   SEMIS
; ----------------------------------------------------------------------------
; MRK>_nfa
MRKFROM_nfa:
        .byte   $84
        .byte   "MRK"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   WARM_nfa
; MRK>
MRKFROM:
        .word   DOCOL
        .word   HERE
        .word   ZERO
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
; MRK<_nfa
MRKTO_nfa:
        .byte   $84
        .byte   "MRK"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   MRKFROM_nfa
; MRK<
MRKTO:
        .word   DOCOL
        .word   HERE
        .word   SEMIS
; ----------------------------------------------------------------------------
; RES>_nfa
RESFROM_nfa:
        .byte   $84
        .byte   "RES"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   MRKTO_nfa
; RES>
RESFROM:
        .word   DOCOL
        .word   HERE
        .word   SWAP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; RES<_nfa
RESTO_nfa:
        .byte   $84
        .byte   "RES"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   RESFROM_nfa
; RES<
RESTO:
        .word   DOCOL
        .word   COMMA
        .word   SEMIS
; ----------------------------------------------------------------------------
IF_nfa:
        .byte   $C2
        .byte   "I"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   RESTO_nfa
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
; ----------------------------------------------------------------------------
BEGIN_nfa:
        .byte   $C5
        .byte   "BEGI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   ENDIF_nfa
        .word   DOCOL
        .word   QCOMP
        .word   MRKTO
        .word   TWO
        .word   SEMIS
; ----------------------------------------------------------------------------
AGAIN_nfa:
        .byte   $C5
        .byte   "AGAI"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   BEGIN_nfa
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   BRANCH
        .word   RESTO
        .word   SEMIS
; ----------------------------------------------------------------------------
UNTIL_nfa:
        .byte   $C5
        .byte   "UNTI"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   AGAIN_nfa
UNTIL:
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   ZBRANCH
        .word   RESTO
        .word   SEMIS
; ----------------------------------------------------------------------------
WHILE_nfa:
        .byte   $C5
        .byte   "WHIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   UNTIL_nfa
        .word   DOCOL
        .word   TWO
        .word   QPAIRS
        .word   COMPILE
        .word   ZBRANCH
        .word   MRKFROM
        .word   LIT
        .word   $03
        .word   SEMIS
; ----------------------------------------------------------------------------
REPEAT_nfa:
        .byte   $C6
        .byte   "REPEA"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   WHILE_nfa
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
; ----------------------------------------------------------------------------
DO_nfa:
        .byte   $C2
        .byte   "D"
        .byte   $CF
; ----------------------------------------------------------------------------
        .word   REPEAT_nfa
        .word   DOCOL
        .word   QCOMP
        .word   COMPILE
        .word   PDO
        .word   MRKTO
        .word   LIT
        .word   $04
        .word   SEMIS
; ----------------------------------------------------------------------------
LOOP_nfa:
        .byte   $C4
        .byte   "LOO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   DO_nfa
        .word   DOCOL
        .word   LIT
        .word   $04
        .word   QPAIRS
        .word   COMPILE
        .word   PLOOP
        .word   RESTO
        .word   SEMIS
; ----------------------------------------------------------------------------
; +LOOP_nfa
PlusLOOP_nfa:
        .byte   $C5
        .byte   "+LOO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   LOOP_nfa
        .word   DOCOL
        .word   LIT
        .word   $04
        .word   QPAIRS
        .word   COMPILE
        .word   PPLOOP
        .word   RESTO
        .word   SEMIS
; ----------------------------------------------------------------------------
CASE_nfa:
        .byte   $C4
        .byte   "CAS"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   PlusLOOP_nfa
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
; ----------------------------------------------------------------------------
THEN_nfa:
        .byte   $C4
        .byte   "THE"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   ENDCASE_nfa
        .word   DOCOL
        .word   ENDIF
        .word   SEMIS
; ----------------------------------------------------------------------------
END_nfa:
        .byte   $C3
        .byte   "EN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   THEN_nfa
        .word   DOCOL
        .word   UNTIL
        .word   SEMIS
; ----------------------------------------------------------------------------
; IF(_nfa
IFP_nfa:
        .byte   $C3
        .byte   "IF"
        .byte   $A8
; ----------------------------------------------------------------------------
        .word   END_nfa
        .word   DOCOL
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LDE70
LDE40:
        .word   BL
        .word   WORD
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   ")ELSE("
; ----------------------------------------------------------------------------
        .word   HERE
        .word   DUP
        .word   CAT
        .word   ONEP
        .word   SEQUAL
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   ")ENDIF"
; ----------------------------------------------------------------------------
        .word   HERE
        .word   DUP
        .word   CAT
        .word   ONEP
        .word   SEQUAL
        .word   OR
        .word   ZBRANCH
        .word   LDE40
LDE70:
        .word   SEMIS
; ----------------------------------------------------------------------------
; )ELSE(_nfa
PELSEP_nfa:
        .byte   $C6
        .byte   ")ELSE"
        .byte   $A8
; ----------------------------------------------------------------------------
        .word   IFP_nfa
        .word   DOCOL
LDE7D:
        .word   BL
        .word   WORD
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   ")ENDIF"
; ----------------------------------------------------------------------------
        .word   HERE
        .word   DUP
        .word   CAT
        .word   ONEP
        .word   SEQUAL
        .word   ZBRANCH
        .word   LDE7D
        .word   SEMIS
; ----------------------------------------------------------------------------
; )ENDIF_nfa
PENDIF_nfa:
        .byte   $C6
        .byte   ")ENDI"
        .byte   $C6
; ----------------------------------------------------------------------------
        .word   PELSEP_nfa
        .word   DOCOL
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?LOADING_nfa
QLOADING_nfa:
        .byte   $88
        .byte   "?LOADIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   PENDIF_nfa
; ?LOADING
QLOADING:
        .word   DOCOL
        .word   BLK
        .word   AT
        .word   ZEQUAL
        .word   LIT
        .word   $16
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
backslash_nfa:
        .byte   $81,$DC
; ----------------------------------------------------------------------------
        .word   QLOADING_nfa
        .word   DOCOL
        .word   QLOADING
        .word   CSLL
        .word   IN
        .word   AT
        .word   OVER
        .word   MOD
        .word   SUB
        .word   IN
        .word   PSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; -->_nfa
FOLLOW_nfa:
        .byte   $C3
        .byte   "--"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   backslash_nfa
        .word   DOCOL
        .word   QLOADING
        .word   ZERO
        .word   IN
        .word   STORE
        .word   B_SCR
        .word   BLK
        .word   AT
        .word   OVER
        .word   MOD
        .word   SUB
        .word   BLK
        .word   PSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
LOAD_nfa:
        .byte   $84
        .byte   "LOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   FOLLOW_nfa
LOAD:
        .word   DOCOL
        .word   BLK
        .word   AT
        .word   TOR
        .word   IN
        .word   AT
        .word   TOR
        .word   ZERO
        .word   IN
        .word   STORE
        .word   B_SCR
        .word   STAR
        .word   BLK
        .word   STORE
        .word   INTERPRET
        .word   RFROM
        .word   IN
        .word   STORE
        .word   RFROM
        .word   BLK
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
THRU_nfa:
        .byte   $84
        .byte   "THR"
        .byte   $D5
; ----------------------------------------------------------------------------
        .word   LOAD_nfa
THRU:
        .word   DOCOL
        .word   ONEP
        .word   SWAP
        .word   PDO
LDF40:
        .word   I
        .word   LOAD
        .word   PLOOP
        .word   LDF40
        .word   SEMIS
; ----------------------------------------------------------------------------
; LOAD-USING_nfa
LOAD_USING_nfa:
        .byte   $8A
        .byte   "LOAD-USIN"

        .byte   $C7
; ----------------------------------------------------------------------------
        .word   THRU_nfa
        .word   DOCOL
        .word   XFILE
        .word   USING
        .word   LOAD
        .word   XFILE
        .word   DOTFILE
        .word   SEMIS
; ----------------------------------------------------------------------------
; THRU-USING_nfa
THRU_USING_nfa:
        .byte   $8A
        .byte   "THRU-USIN"

        .byte   $C7
; ----------------------------------------------------------------------------
        .word   LOAD_USING_nfa
        .word   DOCOL
        .word   XFILE
        .word   USING
        .word   THRU
        .word   XFILE
        .word   DOTFILE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?TERMSTOP_nfa
QTERMSTOP_nfa:
        .byte   $89
        .byte   "?TERMSTO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   THRU_USING_nfa
; ?TERMSTOP
QTERMSTOP:
        .word   DOCOL
        .word   QTERMINAL
        .word   DUP
        .word   ZBRANCH
        .word   LDFAE
        .word   KEY
        .word   TWODROP
        .word   KEY
        .word   DUP
        .word   LIT
        .word   $03
        .word   EQUAL
        .word   SWAP
        .word   LIT
        .word   $1B
        .word   EQUAL
        .word   OR
LDFAE:
        .word   SEMIS
; ----------------------------------------------------------------------------
; C/L_nfa
CSLL_nfa:
        .byte   $83
        .byte   "C/"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   QTERMSTOP_nfa
; C/L
CSLL:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0040
; ----------------------------------------------------------------------------
; (LINE)_nfa
PLINE_nfa:
        .byte   $86
        .byte   "(LINE"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   CSLL_nfa
; (LINE)
PLINE:
        .word   DOCOL
        .word   TOR
        .word   CSLL
        .word   B_BUF
        .word   STARSLMOD
        .word   RFROM
        .word   B_SCR
        .word   STAR
        .word   PLUS
        .word   BLOCK
        .word   PLUS
        .word   CSLL
        .word   SEMIS
; ----------------------------------------------------------------------------
DOTLINE_nfa:
        .byte   $85
        .byte   ".LIN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   PLINE_nfa
DOTLINE:
        .word   DOCOL
        .word   PLINE
        .word   DTRAILING
        .word   TYPE
        .word   SEMIS
; ----------------------------------------------------------------------------
LIST_nfa:
        .byte   $84
        .byte   "LIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   DOTLINE_nfa
LIST:
        .word   DOCOL
        .word   CR
        .word   DUP
        .word   SCR
        .word   STORE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   "SCR #"
; ----------------------------------------------------------------------------
        .word   DOT
        .word   LIT
        .word   $10
        .word   ZERO
        .word   PDO
LE012:
        .word   CR
        .word   I
        .word   TWO
        .word   DOTR
        .word   SPACE
        .word   I
        .word   SCR
        .word   AT
        .word   DOTLINE
        .word   QTERMSTOP
        .word   ZLEAVE
        .word   PLOOP
        .word   LE012
        .word   CR
        .word   SEMIS
; ----------------------------------------------------------------------------
TRIAD_nfa:
        .byte   $85
        .byte   "TRIA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   LIST_nfa
        .word   DOCOL
        .word   LIT
        .word   $0C
        .word   EMIT
        .word   LIT
        .word   $03
        .word   SLASH
        .word   LIT
        .word   $03
        .word   STAR
        .word   LIT
        .word   $03
        .word   OVER
        .word   PLUS
        .word   SWAP
        .word   PDO
LE058:
        .word   CR
        .word   I
        .word   LIST
        .word   QTERMSTOP
        .word   ZLEAVE
        .word   PLOOP
        .word   LE058
        .word   CR
        .word   LIT
        .word   $0F
        .word   MESSAGE
        .word   CR
        .word   SEMIS
; ----------------------------------------------------------------------------
INDEX_nfa:
        .byte   $85
        .byte   "INDE"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   TRIAD_nfa
        .word   DOCOL
        .word   LIT
        .word   $0C
        .word   EMIT
        .word   CR
        .word   ONEP
        .word   SWAP
        .word   PDO
LE08A:
        .word   CR
        .word   I
        .word   LIT
        .word   $03
        .word   DOTR
        .word   SPACE
        .word   ZERO
        .word   I
        .word   DOTLINE
        .word   QTERMSTOP
        .word   ZLEAVE
        .word   PLOOP
        .word   LE08A
        .word   SEMIS
; ----------------------------------------------------------------------------
; V<_nfa
VTO_nfa:
        .byte   $82
        .byte   "V"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   INDEX_nfa
; V<
VTO:
        .word   DOCOL
        .word   LIT
        .word   ORIGIN
        .word   SUB
        .word   SWAP
        .word   LIT
        .word   ORIGIN
        .word   SUB
        .word   SWAP
        .word   ULESS
        .word   SEMIS
; ----------------------------------------------------------------------------
FORGET_nfa:
        .byte   $86
        .byte   "FORGE"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   VTO_nfa
        .word   DOCOL
        .word   CURRENT
        .word   AT
        .word   CONTEXT
        .word   AT
        .word   SUB
        .word   LIT
        .word   $18
        .word   QERROR
        .word   TICK
        .word   DUP
        .word   FENCE
        .word   AT
        .word   VTO
        .word   LIT
        .word   $15
        .word   QERROR
        .word   NFA
        .word   TOR
        .word   VOCLINK
LE0F2:
        .word   AT
        .word   DUP
        .word   R
        .word   VTO
        .word   ZBRANCH
        .word   LE0F2
        .word   DUP
        .word   VOCLINK
        .word   STORE
LE104:
        .word   DUP
        .word   TWOS
        .word   AT
        .word   TWOP
        .word   DUP
LE10E:
        .word   AT
        .word   DUP
        .word   R
        .word   VTO
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LE124
        .word   PFA
        .word   LFA
        .word   BRANCH
        .word   LE10E
LE124:
        .word   SWAP
        .word   STORE
        .word   AT
        .word   DUP
        .word   ZEQUAL
        .word   ZBRANCH
        .word   LE104
        .word   DROP
        .word   RFROM
        .word   DP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ID._nfa
IDDOT_nfa:
        .byte   $83
        .byte   "ID"
        .byte   $AE
; ----------------------------------------------------------------------------
        .word   FORGET_nfa
; ID.
IDDOT:
        .word   DOCOL
        .word   COUNT
        .word   LIT
        .word   $1F
        .word   ANDforth
        .word   DUP
        .word   ZGREAT
        .word   ZBRANCH
        .word   LE16E
        .word   ZERO
        .word   PDO
LE158:
        .word   COUNT
        .word   LIT
        .word   $7F
        .word   ANDforth
        .word   EMIT
        .word   PLOOP
        .word   LE158
        .word   SPACE
        .word   DROP
        .word   BRANCH
        .word   LE170
LE16E:
        .word   TWODROP
LE170:
        .word   SEMIS
; ----------------------------------------------------------------------------
VLIST_nfa:
        .byte   $85
        .byte   "VLIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   IDDOT_nfa
        .word   DOCOL
        .word   ZERO
        .word   OUT
        .word   STORE
        .word   CR
        .word   CONTEXT
        .word   AT
        .word   AT
LE18A:
        .word   LIT
        .word   $28
        .word   OUT
        .word   AT
        .word   SUB
        .word   OVER
        .word   CAT
        .word   LIT
        .word   $1F
        .word   ANDforth
        .word   LESS
        .word   ZBRANCH
        .word   LE1A6
        .word   CR
LE1A6:
        .word   DUP
        .word   IDDOT
        .word   OUT
        .word   AT
        .word   MINUS
        .word   LIT
        .word   $07
        .word   ANDforth
        .word   SPACES
        .word   PFA
        .word   LFA
        .word   AT
        .word   DUP
        .word   ZEQUAL
        .word   QTERMSTOP
        .word   OR
        .word   ZBRANCH
        .word   LE18A
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
; VOC-LIST_nfa
VOC_LIST_nfa:
        .byte   $88
        .byte   "VOC-LIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   VLIST_nfa
        .word   DOCOL
        .word   VOCLINK
LE1DD:
        .word   AT
        .word   DDUP
        .word   ZBRANCH
        .word   LE1F5
        .word   DUP
        .word   LIT
        .word   $04
        .word   SUB
        .word   NFA
        .word   IDDOT
        .word   BRANCH
        .word   LE1DD
LE1F5:
        .word   SEMIS
; ----------------------------------------------------------------------------
; INIT-RAM: Copie $3c80 octets de $c37f vers $c380???
INIT_RAM:
        lda     #$3C
        sta     N+1
        lda     #$80
        sta     N
        lda     #$C3
        sta     N+3
        lda     #$80
        sta     N+2
        lda     #$C3
        sta     N+5
        lda     #$7F
        sta     N+4
        tya
        sta     (N+4),y
        jmp     LC35B

; ----------------------------------------------------------------------------
teleforth_signature:
        .byte   "TELE-FORTH V1.2"

        .byte   $0D,$0A
        .byte   "(c) 1989 Thierry BESTEL"


        .byte   $0D,$0A,$00
AYX_nfa:
        .byte   $83
        .byte   "AY"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   VOC_LIST_nfa
AYX:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0563
; ----------------------------------------------------------------------------
PIO_nfa:
        .byte   $83
        .byte   "PI"
        .byte   $CF
; ----------------------------------------------------------------------------
        .word   AYX_nfa
PIO:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0566
; ----------------------------------------------------------------------------
MON_nfa:
        .byte   $83
        .byte   "MO"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   PIO_nfa
MON:
        .word   MON_pfa
; ----------------------------------------------------------------------------
MON_pfa:
        lda     BOT,x
        inx
        inx
        sta     CallTel+1
        stx     _XSAVE
        lda     AYX_addr
        ldy     AYX_addr+1
        ldx     AYX_addr+2
        lsr     PIO_addr
        jsr     CallTel
        sta     AYX_addr
        sty     AYX_addr+1
        stx     AYX_addr+2
        php
        pla
        sta     PIO_addr
        ldx     _XSAVE
        jmp     NEXT

; ----------------------------------------------------------------------------
; MON:_nfa -> Compile un mot d'appel à une procédure Telemon
MONCOL_nfa:
        .byte   $84
        .byte   "MON"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   MON_nfa
        .word   DOCOL
        .word   CREATE
        .word   CCOMMA
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOMON:
        stx     _XSAVE
        ldy     #$02
        lda     (W),y
        sta     CallTel+1
        jsr     CallTel
        ldx     _XSAVE
        jmp     NEXT

; ----------------------------------------------------------------------------
; HRS:_nfa
HRSCOL_nfa:
        .byte   $84
        .byte   "HRS"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   MONCOL_nfa
        .word   DOCOL
        .word   CREATE
        .word   CCOMMA
        .word   CCOMMA
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOHRS:
        ldy     #$02
        lda     (W),y
        sta     CallTel+1
        iny
        lda     (W),y
        asl
        tay
LE2C4:
        lda     BOT,x
        sta     $4B,y
        inx
        lda     BOT,x
        sta     hrs1-1,y
        inx
        dey
        dey
        bne     LE2C4
        bcc     LE2DD
        bit     flgtel
        bpl     LE2E4
        bvs     LE2E4
LE2DD:
        stx     _XSAVE
        jsr     CallTel
        ldx     _XSAVE
LE2E4:
        jmp     NEXT

; ----------------------------------------------------------------------------
HIMEM_nfa:
        .byte   $85
        .byte   "HIME"
        .byte   $CD
; ----------------------------------------------------------------------------
        .word   HRSCOL_nfa
HIMEM:
        .word   DOCOL
        .word   QHIRES
        .word   ZBRANCH
        .word   LE2FF
        .word   LIT
        .word   $9800
        .word   BRANCH
        .word   LE303
LE2FF:
        .word   LIT
        .word   $B400
LE303:
        .word   SEMIS
; ----------------------------------------------------------------------------
SOUNDS_nfa:
        .byte   $C6
        .byte   "SOUND"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   HIMEM_nfa
        .word   DODOES
        .word   DOVOC
        .word   SOUNDS_voc
SOUNDS_LINK:
        .word   FORTH_LINK
; ----------------------------------------------------------------------------
; PSG:_nfa
PSGCOL_nfa:
        .byte   $84
        .byte   "PSG"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   FORTH_voc
        .word   DOCOL
        .word   CREATE
        .word   HERE
        .word   LIT
        .word   $0E
        .word   ALLOT
        .word   HERE
        .word   PDO
LE32D:
        .word   I
        .word   ONES
        .word   CSTORE
        .word   LIT
        .word   $FFFF
        .word   PPLOOP
        .word   LE32D
        .word   PSEMICODE
; ----------------------------------------------------------------------------
        stx     _XSAVE
        ldy     #$02
        lda     (W),y
        tax
        iny
        lda     (W),y
        tay
        brk  :  .byte XSONPS                    ; Telemon
        ldx     _XSAVE
        jmp     NEXT

; ----------------------------------------------------------------------------
; PSG!_nfa
PSGSTORE_nfa:
        .byte   $84
        .byte   "PSG"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   PSGCOL_nfa
        .word   DOCOL
        .word   AYX
        .word   TWOP
        .word   CSTORE
        .word   LIT
        .word   XEPSG
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
PLAY_nfa:
        .byte   $84
        .byte   "PLA"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   PSGSTORE_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $43,$04
; ----------------------------------------------------------------------------
SOUND_nfa:
        .byte   $85
        .byte   "SOUN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   PLAY_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $44,$03
; ----------------------------------------------------------------------------
MUSIC_nfa:
        .byte   $85
        .byte   "MUSI"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   SOUND_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $45,$04
; ----------------------------------------------------------------------------
; Appel Telemon XOUPS ($42)
OUPS_nfa:
        .byte   $84
        .byte   "OUP"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   MUSIC_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XOUPS
; ----------------------------------------------------------------------------
; Appel Telemon XZAP ($46)
ZAP_nfa:
        .byte   $83
        .byte   "ZA"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   OUPS_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XZAP
; ----------------------------------------------------------------------------
; Appel Telemon XSHOOT ($47)
SHOOT_nfa:
        .byte   $85
        .byte   "SHOO"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   ZAP_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XSHOOT
; ----------------------------------------------------------------------------
; Appel Telemon XEXPLO ($9C)
EXPLODE_nfa:
        .byte   $87
        .byte   "EXPLOD"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SHOOT_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XEXPLO
; ----------------------------------------------------------------------------
; Appel Telemon XPING ($9D)
PING_nfa:
        .byte   $84
        .byte   "PIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   EXPLODE_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XPING
; ----------------------------------------------------------------------------
GRAFX_nfa:
        .byte   $C5
        .byte   "GRAF"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   SOUNDS_nfa
        .word   DODOES
        .word   DOVOC
        .word   GRAFX_voc
GRAFX_LINK:
        .word   SOUNDS_LINK
; ----------------------------------------------------------------------------
; Vocabulaire GRAFX - Appel Telemon XTEXT ($19)
TEXTgrafx_nfa:
        .byte   $84
        .byte   "TEX"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   FORTH_voc
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XTEXT
; ----------------------------------------------------------------------------
; Appel Telemon XHIRES ($1A)
HIRES_nfa:
        .byte   $85
        .byte   "HIRE"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   TEXTgrafx_nfa
HIRES:
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XHIRES
; ----------------------------------------------------------------------------
ADRAW_nfa:
        .byte   $85
        .byte   "ADRA"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   HIRES_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $8D,$84
; ----------------------------------------------------------------------------
DRAW_nfa:
        .byte   $84
        .byte   "DRA"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   ADRAW_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $8E,$82
; ----------------------------------------------------------------------------
CIRCLE_nfa:
        .byte   $86
        .byte   "CIRCL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   DRAW_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $8F,$81
; ----------------------------------------------------------------------------
CURSET_nfa:
        .byte   $86
        .byte   "CURSE"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CIRCLE_nfa
CURSET:
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $90,$82
; ----------------------------------------------------------------------------
CURMOV_nfa:
        .byte   $86
        .byte   "CURMO"
        .byte   $D6
; ----------------------------------------------------------------------------
        .word   CURSET_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $91,$82
; ----------------------------------------------------------------------------
BOX_nfa:
        .byte   $83
        .byte   "BO"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   CURMOV_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $94,$82
; ----------------------------------------------------------------------------
ABOX_nfa:
        .byte   $84
        .byte   "ABO"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   BOX_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $95,$84
; ----------------------------------------------------------------------------
PAVE_nfa:
        .byte   $84
        .byte   "PAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   ABOX_nfa
        .word   DOHRS
; ----------------------------------------------------------------------------
        .byte   $96,$83
; ----------------------------------------------------------------------------
PAPER_nfa:
        .byte   $85
        .byte   "PAPE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   PAVE_nfa
        .word   DOCOL
        .word   SWAP
        .word   AYX
        .word   TWOSTORE
        .word   LIT
        .word   XPAPER
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
INK_nfa:
        .byte   $83
        .byte   "IN"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   PAPER_nfa
        .word   DOCOL
        .word   SWAP
        .word   AYX
        .word   TWOSTORE
        .word   LIT
        .word   XINK
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
FB_nfa:
        .byte   $82
        .byte   "F"
        .byte   $C2
; ----------------------------------------------------------------------------
        .word   INK_nfa
FB:
        .word   DOCOL
        .word   LIT
        .word   $40
        .word   USTAR
        .word   DROP
        .word   LIT
        .word   hrsfb
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
PATTERN_nfa:
        .byte   $87
        .byte   "PATTER"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   FB_nfa
        .word   DOCOL
        .word   LIT
        .word   hrspat
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
HEMIT_nfa:
        .byte   $85
        .byte   "HEMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   PATTERN_nfa
        .word   DOCOL
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   XCHAR
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
HTYPE_nfa:
        .byte   $85
        .byte   "HTYP"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   HEMIT_nfa
        .word   DOCOL
        .word   SWAP
        .word   AYX
        .word   TWOSTORE
        .word   LIT
        .word   XSCHAR
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
ADCHAR_nfa:
        .byte   $86
        .byte   "ADCHA"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   HTYPE_nfa
        .word   DOCOL
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   ZADCHA
        .word   MON
        .word   AYX
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
; CHAR:_nfa
CHARCOL_nfa:
        .byte   $85
        .byte   "CHAR"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   ADCHAR_nfa
        .word   DOCOL
        .word   BUILDS
        .word   HERE
        .word   LIT
        .word   $09
        .word   ALLOT
        .word   HERE
        .word   PDO
LE4FB:
        .word   I
        .word   ONES
        .word   CSTORE
        .word   LIT
        .word   $FFFF
        .word   PPLOOP
        .word   LE4FB
        .word   ZERO
        .word   CCOMMA
        .word   DOES
        .word   AYX
        .word   STORE
        .word   LIT
        .word   XSCRNE
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
WINDOWS_nfa:
        .byte   $C7
        .byte   "WINDOW"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   GRAFX_nfa
        .word   DODOES
        .word   DOVOC
        .word   WINDOWS_voc
WINDOWS_LINK:
        .word   GRAFX_LINK
; ----------------------------------------------------------------------------
; WINDOW:_nfa
WINDOWCOL_nfa:
        .byte   $87
        .byte   "WINDOW"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   FORTH_voc
        .word   DOCOL
        .word   BUILDS
        .word   ROT
        .word   TOR
        .word   ROT
        .word   CCOMMA
        .word   RFROM
        .word   CCOMMA
        .word   SWAP
        .word   CCOMMA
        .word   CCOMMA
        .word   LIT
        .word   SCRTXT
        .word   COMMA
        .word   DOES
DOWINDOW:
        .word   AYX
        .word   TWOSTORE
        .word   LIT
        .word   XSCRSE
        .word   MON
        .word   LIT
        .word   XCSSCR
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
MSGW_nfa:
        .byte   $84
        .byte   "MSG"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   WINDOWCOL_nfa
        .word   DODOES
        .word   DOWINDOW
; ----------------------------------------------------------------------------
        .byte   $00,$27,$00,$00,$80,$BB
; ----------------------------------------------------------------------------
SCRW_nfa:
        .byte   $84
        .byte   "SCR"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   MSGW_nfa
SCRW:
        .word   DODOES
        .word   DOWINDOW
; ----------------------------------------------------------------------------
        .byte   $00,$27,$01,$1B,$80,$BB
; ----------------------------------------------------------------------------
CURSOR_nfa:
        .byte   $86
        .byte   "CURSO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   SCRW_nfa
CURSOR:
        .word   LE594
; ----------------------------------------------------------------------------
LE594:
        stx     _XSAVE
        lsr     BOT,x
        lda     SECOND,x
        tax
        bcc     LE5A2
        brk  :  .byte XCSSCR                    ; Telemon
        jmp     LE5A4

; ----------------------------------------------------------------------------
LE5A2:
        brk  :  .byte XCOSCR                    ; Telemon
LE5A4:
        ldx     _XSAVE
        jmp     POPTWO

; ----------------------------------------------------------------------------
SCROLL_nfa:
        .byte   $86
        .byte   "SCROL"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   CURSOR_nfa
        .word   LE5B4
; ----------------------------------------------------------------------------
LE5B4:
        lda     #$04
        jsr     SETUP
        stx     _XSAVE
        lda     N+6
        sta     SCRNB
        ldx     N+4
        ldy     N+2
        lda     N
        bne     LE5CC
        brk  :  .byte XSCROB                    ; Telemon
        jmp     LE5CE

; ----------------------------------------------------------------------------
LE5CC:
        brk  :  .byte XSCROH                    ; Telemon
LE5CE:
        ldx     _XSAVE
        jmp     NEXT

; ----------------------------------------------------------------------------
CLOCK_nfa:
        .byte   $85
        .byte   "CLOC"
        .byte   $CB
; ----------------------------------------------------------------------------
        .word   WINDOWS_nfa
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
; ----------------------------------------------------------------------------
WAIT_nfa:
        .byte   $84
        .byte   "WAI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CLOCK_nfa
WAIT:
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
; ----------------------------------------------------------------------------
; (DOS)_nfa -> Appel de la procédure Stratsed $FFxx
PDOS_nfa:
        .byte   $85
        .byte   "(DOS"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   WAIT_nfa
; (DOS)
PDOS:
        .word   LE6AA
; ----------------------------------------------------------------------------
LE6AA:
        lda     flgtel
        lsr
        bcc     LE6B5
        lda     #$08
        jmp     LE6F2

; ----------------------------------------------------------------------------
LE6B5:
        sty     errnb
        sty     bnkcib
        lda     BOT,x
        sta     vexbnk+1
        dey
        sty     vexbnk+2
        stx     _XSAVE
        php
        tsx
        dex
        dex
        dex
        dex
        stx     saves
        lda     AYX_addr
        ldy     AYX_addr+1
        ldx     AYX_addr+2
        lsr     PIO_addr
        jsr     Exbnk
        sta     AYX_addr
        sty     AYX_addr+1
        stx     AYX_addr+2
        php
        pla
        sta     PIO_addr
        plp
        ldx     _XSAVE
        lda     errnb
LE6F2:
        sta     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; Appel de la procédure Stratsed $FFxx avec vérification du code d'erreur
DOS_nfa:
        .byte   $83
        .byte   "DO"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   PDOS_nfa
DOS:
        .word   DOCOL
        .word   PDOS
        .word   DUP
        .word   LIT
        .word   $80
        .word   OR
        .word   QERROR
        .word   SEMIS
; ----------------------------------------------------------------------------
FSTR:
        .byte   $82,$80
        .byte   "A$      "
        .byte   $82,$80
        .byte   "B$      "
        .byte   $82,$80
        .byte   "C$      "
        .byte   $82,$80
        .byte   "D$      "
        .byte   $FF
; ----------------------------------------------------------------------------
FRW:
        ldy     #$80
        lda     hrs3
        bpl     LE749
        lda     BUFP
        sta     $61
        lda     BUFP+1
        sta     $62
        sty     $60
        jmp     LE751

; ----------------------------------------------------------------------------
LE749:
        dey
LE74A:
        lda     ($61  ),y
        sta     (BUFP),y
        dey
        bpl     LE74A
LE751:
        clc
        lda     BUFP
        adc     #$80
        sta     BUFP
        bcc     LE75C
        inc     BUFP+1
LE75C:
        rts

; ----------------------------------------------------------------------------
di_nfa:
        .byte   $82
        .byte   "d"
        .byte   $E9
; ----------------------------------------------------------------------------
        .word   DOS_nfa
di:
        .word   LE764
; ----------------------------------------------------------------------------
LE764:
        sei
        jmp     NEXT

; ----------------------------------------------------------------------------
ei_nfa:
        .byte   $82
        .byte   "e"
        .byte   $E9
; ----------------------------------------------------------------------------
        .word   di_nfa
ei:
        .word   LE76F
; ----------------------------------------------------------------------------
LE76F:
        cli
        jmp     NEXT

; ----------------------------------------------------------------------------
; R/W_nfa
RSLW_nfa:
        .byte   $83
        .byte   "R/"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   ei_nfa
; R/W
RSLW:
        .word   DOCOL
        .word   ZBRANCH
        .word   LE787
        .word   LIT
        .word   $20
        .word   BRANCH
        .word   LE78B
LE787:
        .word   LIT
        .word   $23
LE78B:
        .word   TOR
        .word   OVER
        .word   LIT
        .word   BUFP
        .word   STORE
        .word   ONEP
        .word   TWOSTAR
        .word   ONEP
        .word   DUP
        .word   TWOS
        .word   di
        .word   PDO
LE7A3:
        .word   I
        .word   LIT
        .word   desalo
        .word   STORE
        .word   J
        .word   PDOS
        .word   LIT
        .word   $0F
        .word   EQUAL
        .word   ZBRANCH
        .word   LE7C1
        .word   DUP
        .word   B_BUF
        .word   BLANKS
        .word   LEAVE
LE7C1:
        .word   PLOOP
        .word   LE7A3
        .word   ei
        .word   RFROMDROP
        .word   DROP
        .word   SEMIS
; ----------------------------------------------------------------------------
DRIVE_nfa:
        .byte   $85
        .byte   "DRIV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   RSLW_nfa
        .word   DOCOL
        .word   DUP
        .word   ZLESS
        .word   OVER
        .word   LIT
        .word   $03
        .word   GREAT
        .word   OR
        .word   LIT
        .word   $1C
        .word   QERROR
        .word   LIT
        .word   tabdrv
        .word   OVER
        .word   PLUS
        .word   CAT
        .word   ZEQUAL
        .word   LIT
        .word   $8A
        .word   QERROR
        .word   LIT
        .word   drvdef
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ST-R/W_nfa
STRSLW_nfa:
        .byte   $86
        .byte   "ST-R/"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   DRIVE_nfa
        .word   DOCOL
        .word   TOR
        .word   LIT
        .word   piste
        .word   CSTORE
        .word   LIT
        .word   secteu
        .word   CSTORE
        .word   LIT
        .word   rwbuf
        .word   STORE
        .word   RFROM
        .word   ZBRANCH
        .word   LE832
        .word   LIT
        .word   $A1
        .word   BRANCH
        .word   LE836
LE832:
        .word   LIT
        .word   XSVSEC
LE836:
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
FILENAME_nfa:
        .byte   $88
        .byte   "FILENAM"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   STRSLW_nfa
FILENAME:
        .word   DOCOL
        .word   COUNT
        .word   SWAP
        .word   AYX
        .word   TWOSTORE
        .word   LIT
        .word   XNOMFI
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?FILE_nfa
QFILE_nfa:
        .byte   $85
        .byte   "?FIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   FILENAME_nfa
; ?FILE
QFILE:
        .word   DOCOL
        .word   FILENAME
        .word   AYX
        .word   TWOP
        .word   LIT
        .word   $82
        .word   CTST
        .word   LIT
        .word   $89
        .word   QERROR
        .word   LIT
        .word   XTRVNM
        .word   DOS
        .word   PIO
        .word   TWO
        .word   CTST
        .word   ZEQUAL
        .word   SEMIS
; ----------------------------------------------------------------------------
DOTFILE_nfa:
        .byte   $85
        .byte   ".FIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   QFILE_nfa
DOTFILE:
        .word   DOCOL
        .word   CR
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   "Using "
; ----------------------------------------------------------------------------
        .word   LIT
        .word   ficnum
        .word   CAT
        .word   ONES
        .word   LIT
        .word   $0260
        .word   STAR
        .word   LIT
        .word   DOSBUFFERS+768
        .word   PLUS
        .word   COUNT
        .word   LIT
        .word   $41
        .word   PLUS
        .word   EMIT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $01
        .byte   "-"
; ----------------------------------------------------------------------------
        .word   DUP
        .word   LIT
        .word   $09
        .word   DTRAILING
        .word   TYPE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $01
        .byte   "."
; ----------------------------------------------------------------------------
        .word   LIT
        .word   $09
        .word   PLUS
        .word   LIT
        .word   $03
        .word   DTRAILING
        .word   TYPE
        .word   SPACE
        .word   SEMIS
; ----------------------------------------------------------------------------
USING_nfa:
        .byte   $85
        .byte   "USIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   DOTFILE_nfa
USING:
        .word   DOCOL
        .word   FLUSH
        .word   LIT
        .word   $08
        .word   LIT
        .word   ftype
        .word   CSTORE
        .word   BL
        .word   WORD
        .word   HERE
        .word   QFILE
        .word   ZBRANCH
        .word   LE91A
        .word   LIT
        .word   XCLOSE
        .word   PDOS
        .word   DROP
        .word   LIT
        .word   drvdef
        .word   CAT
        .word   LIT
        .word   drive
        .word   CSTORE
        .word   LIT
        .word   XOPEN
        .word   DOS
        .word   BRANCH
        .word   LE991
LE91A:
        .word   LIT
        .word   $81
        .word   MESSAGE
        .word   CR
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   "Creer "
; ----------------------------------------------------------------------------
        .word   HERE
        .word   COUNT
        .word   TYPE
        .word   QOK
        .word   ZBRANCH
        .word   LE991
        .word   LIT
        .word   XCLOSE
        .word   PDOS
        .word   DROP
        .word   ZERO
        .word   LIT
        .word   desalo
        .word   STORE
        .word   B_BUF
        .word   LIT
        .word   fisalo
        .word   STORE
        .word   LIT
        .word   drvdef
        .word   CAT
        .word   LIT
        .word   drive
        .word   CSTORE
        .word   LIT
        .word   XOPEN
        .word   DOS
        .word   LIT
        .word   FSTR
        .word   LIT
        .word   $06
        .word   AT
        .word   DUP
        .word   LIT
        .word   rwbuf
        .word   STORE
        .word   LIT
        .word   $29
        .word   CMOVE
        .word   LIT
        .word   $08
        .word   AT
        .word   LIT
        .word   $0C
        .word   PLUS
        .word   AT
        .word   AYX
        .word   STORE
        .word   LIT
        .word   XSAY
        .word   DOS
LE991:
        .word   DOTFILE
        .word   SEMIS
; ----------------------------------------------------------------------------
XFILE_nfa:
        .byte   $85
        .byte   "XFIL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   USING_nfa
XFILE:
        .word   DOCOL
        .word   FLUSH
        .word   LIT
        .word   ficnum
        .word   LIT
        .word   $03
        .word   TOGGLE
        .word   SEMIS
; ----------------------------------------------------------------------------
INIT_nfa:
        .byte   $84
        .byte   "INI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   XFILE_nfa
        .word   DOCOL
        .word   LIT
        .word   XINITI
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
DIR_nfa:
        .byte   $83
        .byte   "DI"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   INIT_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   FILENAME
        .word   LIT
        .word   XDIRN
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
DEL_nfa:
        .byte   $83
        .byte   "DE"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   DIR_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   FILENAME
        .word   LIT
        .word   hrs1
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
COPY_nfa:
        .byte   $84
        .byte   "COP"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   DEL_nfa
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   FILENAME
        .word   LIT
        .word   bufnom
        .word   LIT
        .word   $0100
        .word   LIT
        .word   $0D
        .word   CMOVE
        .word   BL
        .word   WORD
        .word   HERE
        .word   FILENAME
        .word   LIT
        .word   bufnom
        .word   LIT
        .word   $010D
        .word   LIT
        .word   $0D
        .word   CMOVE
        .word   LIT
        .word   $80
        .word   LIT
        .word   vasalo0
        .word   STORE
        .word   LIT
        .word   XCOPY
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
STARTUP_nfa:
        .byte   $87
        .byte   "STARTU"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   COPY_nfa
STARTUP:
        .word   DOCOL
        .word   LIT
        .word   $60
        .word   ZERO
        .word   LIT
        .word   CallTel
        .word   TWOSTORE
        .word   LIT
        .word   v2dra
        .word   CAT
        .word   LIT
        .word   $07
        .word   ANDforth
        .word   LIT
        .word   vnmi
        .word   CSTORE
        .word   LIT
        .word   $04
        .word   PORIGIN
        .word   LIT
        .word   vnmi+1
        .word   STORE
        .word   LIT
        .word   flgtel
        .word   ONE
        .word   CTST
        .word   ZBRANCH
        .word   LEA81
        .word   LIT
        .word   $88
        .word   MESSAGE
        .word   BRANCH
        .word   LEAFF
LEA81:
        .word   LIT
        .word   DOSBUFFERS
        .word   LIT
        .word   $07C0
        .word   ERASE
        .word   LIT
        .word   $02
        .word   LIT
        .word   nbfic
        .word   CSTORE
        .word   LIT
        .word   DOSBUFFERS
        .word   LIT
        .word   tampfc
        .word   STORE
        .word   ONE
        .word   LIT
        .word   ficnum
        .word   CSTORE
        .word   LIT
        .word   v2dra
        .word   CAT
        .word   LIT
        .word   $07
        .word   ANDforth
        .word   LIT
        .word   xfield
        .word   CSTORE
        .word   LIT
        .word   FRW
        .word   LIT
        .word   xfield+1
        .word   STORE
        .word   LIT
        .word   $FFFF
        .word   LIT
        .word   bitmfc
        .word   STORE
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $09
        .byte   "FORTH.DAT"

; ----------------------------------------------------------------------------
        .word   QFILE
        .word   ZBRANCH
        .word   LEAFF
        .word   LIT
        .word   $08
        .word   LIT
        .word   ftype
        .word   CSTORE
        .word   LIT
        .word   XOPEN
        .word   DOS
        .word   ZERO
        .word   BLK
        .word   STORE
        .word   LBRACKET
        .word   RPSTORE
        .word   ONE
        .word   LOAD
        .word   QUIT
LEAFF:
        .word   SEMIS
; ----------------------------------------------------------------------------
; SALO!_nfa
SALOSTORE_nfa:
        .byte   $85
        .byte   "SALO"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   STARTUP_nfa
; SALO!
SALOSTORE:
        .word   DOCOL
        .word   LIT
        .word   vasalo0
        .word   STORE
        .word   LIT
        .word   fisalo
        .word   STORE
        .word   LIT
        .word   desalo
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; $SAVE_nfa
DOLSAVE_nfa:
        .byte   $85
        .byte   "$SAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SALOSTORE_nfa
; $SAVE
DOLSAVE:
        .word   DOCOL
        .word   ZERO
        .word   SALOSTORE
        .word   LIT
        .word   $40
        .word   LIT
        .word   ftype
        .word   CSTORE
        .word   LIT
        .word   XSAVE
        .word   DOS
        .word   SEMIS
; ----------------------------------------------------------------------------
; $LOAD_nfa
DOLLOAD_nfa:
        .byte   $85
        .byte   "$LOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   DOLSAVE_nfa
; $LOAD
DOLLOAD:
        .word   DOCOL
        .word   ZERO
        .word   LIT
        .word   RAM_START+27772
        .word   SALOSTORE
        .word   LIT
        .word   XLOAD
        .word   DOS
        .word   LIT
        .word   fisalo
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
OV6502_nfa:
        .byte   $86
        .byte   "OV650"
        .byte   $B2
; ----------------------------------------------------------------------------
        .word   DOLLOAD_nfa
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
; ----------------------------------------------------------------------------
EDIT_nfa:
        .byte   $84
        .byte   "EDI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   UNLINK_nfa
        .word   DOCOL
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $0C
        .byte   "A-EDITOR.COM"

; ----------------------------------------------------------------------------
        .word   PPOVLOAD
        .word   SEMIS
; ----------------------------------------------------------------------------
ASSEMBLER_nfa:
        .byte   $C9
        .byte   "ASSEMBLE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   EDIT_nfa
ASSEMBLER:
        .word   DOCOL
        .word   ZERO
        .word   PLITQ
; ----------------------------------------------------------------------------
        .byte   $0F
        .byte   "A-ASSEMBLER.COM"

; ----------------------------------------------------------------------------
        .word   PPOVLOAD
        .word   SEMIS
; ----------------------------------------------------------------------------
CODE_nfa:
        .byte   $84
        .byte   "COD"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   ASSEMBLER_nfa
        .word   DOCOL
        .word   ONE
        .word   ASSEMBLER
        .word   SEMIS
; ----------------------------------------------------------------------------
; ;CODE_nfa
SEMICODE_nfa:
        .byte   $85
        .byte   ";COD"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   CODE_nfa
        .word   DOCOL
        .word   TWO
        .word   ASSEMBLER
        .word   SEMIS
; ----------------------------------------------------------------------------
IOS_nfa:
        .byte   $C3
        .byte   "IO"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   SEMICODE_nfa
        .word   DODOES
        .word   DOVOC
        .word   IOS_voc
IOS_LINK:
        .word   WINDOWS_LINK
; ----------------------------------------------------------------------------
OPCH_nfa:
        .byte   $84
        .byte   "OPC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   FORTH_voc
OPCH:
        .word   DOCOL
        .word   LIT
        .word   $80
        .word   OR
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   $03
        .word   ANDforth
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
CLCH_nfa:
        .byte   $84
        .byte   "CLC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   OPCH_nfa
        .word   DOCOL
        .word   LIT
        .word   $80
        .word   OR
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   $03
        .word   ANDforth
        .word   LIT
        .word   $04
        .word   PLUS
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
; KBD:_nfa
KBDCOL_nfa:
        .byte   $84
        .byte   "KBD"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   CLCH_nfa
        .word   DOCOL
        .word   CREATE
        .word   CCOMMA
        .word   PSEMICODE
; ----------------------------------------------------------------------------
DOKBDCOL:
        stx     _XSAVE
        ldy     #$02
        lda     (W),y
        brk  :  .byte XGOKBD                    ; Telemon
        ldx     _XSAVE
        jmp     NEXT

; ----------------------------------------------------------------------------
QWERTY_nfa:
        .byte   $86
        .byte   "QWERT"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   KBDCOL_nfa
        .word   DOKBDCOL
; ----------------------------------------------------------------------------
        .byte   $00
; ----------------------------------------------------------------------------
AZERTY_nfa:
        .byte   $86
        .byte   "AZERT"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   QWERTY_nfa
        .word   DOKBDCOL
; ----------------------------------------------------------------------------
        .byte   $01
; ----------------------------------------------------------------------------
FRENCH_nfa:
        .byte   $86
        .byte   "FRENC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   AZERTY_nfa
        .word   DOKBDCOL
; ----------------------------------------------------------------------------
        .byte   $02
; ----------------------------------------------------------------------------
ACCENT_nfa:
        .byte   $86
        .byte   "ACCEN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   FRENCH_nfa
        .word   DOKBDCOL
; ----------------------------------------------------------------------------
        .byte   $04
; ----------------------------------------------------------------------------
; ?TERM_nfa
QTERM_nfa:
        .byte   $85
        .byte   "?TER"
        .byte   $CD
; ----------------------------------------------------------------------------
        .word   ACCENT_nfa
        .word   QTERM
; ----------------------------------------------------------------------------
; ?TERM_pfa
QTERM:
        stx     _XSAVE
        ldx     #$00
        brk  :  .byte XTSTBU                    ; Telemon
        bcs     LEF43
        iny
LEF43:
        tya
        ldx     _XSAVE
        jmp     PUSH0A

; ----------------------------------------------------------------------------
CKEY_nfa:
        .byte   $84
        .byte   "CKE"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   QTERM_nfa
        .word   CKEY_pfa
; ----------------------------------------------------------------------------
CKEY_pfa:
        lda     $0567
        ora     #$0C
        sta     CallTel+1
        jsr     CallTel
        jmp     PUSH0A

; ----------------------------------------------------------------------------
CEMIT_nfa:
        .byte   $85
        .byte   "CEMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   CKEY_nfa
        .word   CEMIT_pfa
; ----------------------------------------------------------------------------
CEMIT_pfa:
        lda     $0567
        tay
        ora     #$10
        sta     CallTel+1
        lda     BOT,x
        jsr     CallTel
        lda     scrX,y
        ldy     LCA07
        sta     (UP),y
        jmp     POP

; ----------------------------------------------------------------------------
INPUT_nfa:
        .byte   $85
        .byte   "INPU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   IOS_nfa
        .word   DOCOL
        .word   PIO
        .word   ONEP
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
OUTPUT_nfa:
        .byte   $86
        .byte   "OUTPU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   INPUT_nfa
        .word   DOCOL
        .word   PIO
        .word   TWOP
        .word   CSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
TERMINAL_nfa:
        .byte   $88
        .byte   "TERMINA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   OUTPUT_nfa
TERMINAL:
        .word   DOCOL
        .word   ZERO
        .word   PIO
        .word   ONEP
        .word   STORE
        .word   ZERO
        .word   SCRW
        .word   ZERO
        .word   ONE
        .word   CURSOR
        .word   ZERO
        .word   ZERO
        .word   OPCH
        .word   LIT
        .word   QTERM
        .word   LIT
        .word   QTERMINAL_pfa
        .word   PIS
        .word   LIT
        .word   CKEY_pfa
        .word   LIT
        .word   KEY_pfa
        .word   PIS
        .word   LIT
        .word   CEMIT_pfa
        .word   LIT
        .word   EMIT_pfa
        .word   PIS
        .word   SEMIS
; ----------------------------------------------------------------------------
CR_nfa:
        .byte   $82
        .byte   "C"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   TERMINAL_nfa
CR:
        .word   DOCOL
        .word   LIT
        .word   $0D
        .word   EMIT
        .word   LIT
        .word   $0A
        .word   EMIT
        .word   SEMIS
; ----------------------------------------------------------------------------
CLS_nfa:
        .byte   $83
        .byte   "CL"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   CR_nfa
CLS:
        .word   DOCOL
        .word   LIT
        .word   $0C
        .word   EMIT
        .word   SEMIS
; ----------------------------------------------------------------------------
GOTOXY_nfa:
        .byte   $86
        .byte   "GOTOX"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   CLS_nfa
GOTOXY:
        .word   DOCOL
        .word   LIT
        .word   $1F
        .word   EMIT
        .word   LIT
        .word   $40
        .word   OR
        .word   EMIT
        .word   LIT
        .word   $40
        .word   OR
        .word   EMIT
        .word   SEMIS
; ----------------------------------------------------------------------------
; ?HIRES_nfa
QHIRES_nfa:
        .byte   $86
        .byte   "?HIRE"
        .byte   $D3
; ----------------------------------------------------------------------------
        .word   GOTOXY_nfa
; ?HIRES
QHIRES:
        .word   DOCOL
        .word   LIT
        .word   flgtel
        .word   LIT
        .word   $80
        .word   CTST
        .word   SEMIS
; ----------------------------------------------------------------------------
; Appel Telemon XTSTLP ($1E)
TSTLP_nfa:
        .byte   $85
        .byte   "TSTL"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   CEMIT_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XTSTLP
; ----------------------------------------------------------------------------
; Appel Telemon XHCVDT ($4B)
VCOPY_nfa:
        .byte   $85
        .byte   "VCOP"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   TSTLP_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XHCVDT
; ----------------------------------------------------------------------------
; Appel Telemon XHCHRS ($4C)
HCOPY_nfa:
        .byte   $85
        .byte   "HCOP"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   VCOPY_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   $4C
; ----------------------------------------------------------------------------
; Appel Telemon XHCSCR ($4A)
WCOPY_nfa:
        .byte   $85
        .byte   "WCOP"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   HCOPY_nfa
        .word   DOCOL
        .word   LIT
        .word   SCRNB
        .word   CSTORE
        .word   LIT
        .word   XHCSCR
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
PEMIT_nfa:
        .byte   $85
        .byte   "PEMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   WCOPY_nfa
        .word   DOCOL
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   XLPRBI
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
; Appel Telemon XSDUMP ($5C)
SDUMP_nfa:
        .byte   $85
        .byte   "SDUM"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   PEMIT_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XSDUMP
; ----------------------------------------------------------------------------
; Appel Telemon XCONSO ($5D)
CONSOLE_nfa:
        .byte   $87
        .byte   "CONSOL"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SDUMP_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XCONSO
; ----------------------------------------------------------------------------
SLOAD_nfa:
        .byte   $85
        .byte   "SLOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   CONSOLE_nfa
        .word   DOCOL
        .word   PIO
        .word   ONE
        .word   CRST
        .word   LIT
        .word   XSLOAD
        .word   MON
        .word   LIT
        .word   desalo
        .word   AT
        .word   LIT
        .word   fisalo
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
SLOADA_nfa:
        .byte   $86
        .byte   "SLOAD"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   SLOAD_nfa
        .word   DOCOL
        .word   PIO
        .word   ONE
        .word   CSET
        .word   LIT
        .word   desalo
        .word   STORE
        .word   LIT
        .word   XSLOAD
        .word   MON
        .word   LIT
        .word   fisalo
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
SSAVE_nfa:
        .byte   $85
        .byte   "SSAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   SLOADA_nfa
        .word   DOCOL
        .word   ZERO
        .word   SALOSTORE
        .word   LIT
        .word   XSSAVE
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
SEMIT_nfa:
        .byte   $85
        .byte   "SEMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   SSAVE_nfa
        .word   DOCOL
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   XSOUT
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
; Appel Telemon XRING ($62)
RING_nfa:
        .byte   $84
        .byte   "RIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   SEMIT_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XRING
; ----------------------------------------------------------------------------
; Appel Telemon XWCXFI ($63)
WCXFI_nfa:
        .byte   $85
        .byte   "WCXF"
        .byte   $C9
; ----------------------------------------------------------------------------
        .word   RING_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XWCXFI
; ----------------------------------------------------------------------------
; Appel Telemon XLIGNE ($64)
LIGNE_nfa:
        .byte   $85
        .byte   "LIGN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   WCXFI_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XLIGNE
; ----------------------------------------------------------------------------
; Appel Telemon XDECON ($65)
DECON_nfa:
        .byte   $85
        .byte   "DECO"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   LIGNE_nfa
        .word   DOMON
; ----------------------------------------------------------------------------
        .byte   XDECON
; ----------------------------------------------------------------------------
MLOAD_nfa:
        .byte   $85
        .byte   "MLOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   DECON_nfa
        .word   DOCOL
        .word   PIO
        .word   ONE
        .word   CRST
        .word   LIT
        .word   XMLOAD
        .word   MON
        .word   LIT
        .word   desalo
        .word   AT
        .word   LIT
        .word   fisalo
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
MLOADA_nfa:
        .byte   $86
        .byte   "MLOAD"
        .byte   $C1
; ----------------------------------------------------------------------------
        .word   MLOAD_nfa
        .word   DOCOL
        .word   PIO
        .word   ONE
        .word   CSET
        .word   LIT
        .word   desalo
        .word   STORE
        .word   LIT
        .word   XMLOAD
        .word   MON
        .word   LIT
        .word   fisalo
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
MSAVE_nfa:
        .byte   $85
        .byte   "MSAV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   MLOADA_nfa
        .word   DOCOL
        .word   ZERO
        .word   SALOSTORE
        .word   LIT
        .word   XMSAVE
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
MEMIT_nfa:
        .byte   $85
        .byte   "MEMI"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   MSAVE_nfa
        .word   DOCOL
        .word   AYX
        .word   CSTORE
        .word   LIT
        .word   XMOUT
        .word   MON
        .word   SEMIS
; ----------------------------------------------------------------------------
MNTL_nfa:
        .byte   $84
        .byte   "MNT"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   MEMIT_nfa
MNTL:
        .word   LF1D1
; ----------------------------------------------------------------------------
LF1D1:
        lda     #$03
        sta     bnkcib
        lda     BOT,x
        sta     vexbnk+1
        dey
        sty     vexbnk+2
        stx     _XSAVE
        lda     AYX_addr
        ldy     AYX_addr+1
        ldx     AYX_addr+2
        lsr     PIO_addr
        jsr     Exbnk
        sta     AYX_addr
        sty     AYX_addr+1
        stx     AYX_addr+2
        php
        pla
        sta     PIO_addr
        ldx     _XSAVE
        jmp     POP

; ----------------------------------------------------------------------------
MINITEL_nfa:
        .byte   $87
        .byte   "MINITE"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   MNTL_nfa
MINITEL:
        .word   DODEFER
        .word   MINITEL_defer
MNTL0:
        .word   MINITEL
; ----------------------------------------------------------------------------
        .word   $F215,$F217
; ----------------------------------------------------------------------------
        rts

; ----------------------------------------------------------------------------
MNTL1:
        ldx     _XSAVE
        lda     #$F2
        sta     IP+1
        lda     #$11
        sta     IP
        jmp     NEXT

; ----------------------------------------------------------------------------
SERVEUR_nfa:
        .byte   $87
        .byte   "SERVEU"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   MINITEL_nfa
        .word   DOCOL
        .word   LIT
        .word   v2dra
        .word   CAT
        .word   LIT
        .word   $07
        .word   ANDforth
        .word   LIT
        .word   vaplic
        .word   CSTORE
        .word   LIT
        .word   MNTL1
        .word   LIT
        .word   vaplic+1
        .word   STORE
        .word   AYX
        .word   TWOP
        .word   CSTORE
        .word   LIT
        .word   $C5
        .word   MNTL
        .word   SEMIS
; ----------------------------------------------------------------------------
APLIC_nfa:
        .byte   $85
        .byte   "APLI"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   SERVEUR_nfa
        .word   DOCOL
        .word   LIT
        .word   hrs1
        .word   STORE
        .word   LIT
        .word   $BF
        .word   MNTL
        .word   SEMIS
; ----------------------------------------------------------------------------
TINPUT_nfa:
        .byte   $86
        .byte   "TINPU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   APLIC_nfa
        .word   DOCOL
        .word   LIT
        .word   $60
        .word   CSTORE
        .word   LIT
        .word   $BC
        .word   MNTL
        .word   LIT
        .word   $61
        .word   AT
        .word   LIT
        .word   $FF
        .word   CAT
        .word   SEMIS
; ----------------------------------------------------------------------------
PAGE_nfa:
        .byte   $84
        .byte   "PAG"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   TINPUT_nfa
        .word   DOCOL
        .word   LIT
        .word   RAM_START+35005
        .word   LIT
        .word   $07
        .word   DTRAILING
        .word   HERE
        .word   CSTORE
        .word   HERE
        .word   COUNT
        .word   CMOVE
        .word   HERE
        .word   SEMIS
; ----------------------------------------------------------------------------
; TEXT vocabulaire FORTH
TEXT_nfa:
        .byte   $84
        .byte   "TEX"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   QHIRES_nfa
; TEXT vocabulaire FORTH
TEXT:
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
; LINE vocabulaire FORTH
LINE_nfa:
        .byte   $84
        .byte   "LIN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   TEXT_nfa
; LINE vocabulaire FORTH
LINE:
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
; ----------------------------------------------------------------------------
EDITOR_nfa:
        .byte   $C6
        .byte   "EDITO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   LINE_nfa
EDITOR:
        .word   DODOES
        .word   DOVOC
        .word   EDITOR_voc
EDITOR_LINK:
        .word   IOS_LINK
; ----------------------------------------------------------------------------
WHERE_nfa:
        .byte   $85
        .byte   "WHER"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   EDITOR_nfa
WHERE:
        .word   DOCOL
        .word   DUP
        .word   B_SCR
        .word   SLASH
        .word   DUP
        .word   SCR
        .word   STORE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $08
        .byte   "Ecran # "
; ----------------------------------------------------------------------------
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
; #LOCATE_nfa
DIGLOCATE_nfa:
        .byte   $87
        .byte   "#LOCAT"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   FORTH_voc
; #LOCATE
DIGLOCATE:
        .word   DOCOL
        .word   RNUM
        .word   AT
        .word   CSLL
        .word   SLMOD
        .word   SEMIS
; ----------------------------------------------------------------------------
; #LEAD_nfa
DIGLEAD_nfa:
        .byte   $85
        .byte   "#LEA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   DIGLOCATE_nfa
; #LEAD
DIGLEAD:
        .word   DOCOL
        .word   DIGLOCATE
        .word   LINE
        .word   SWAP
        .word   SEMIS
; ----------------------------------------------------------------------------
; #LAG_nfa
DIGLAG_nfa:
        .byte   $84
        .byte   "#LA"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   DIGLEAD_nfa
; #LAG
DIGLAG:
        .word   DOCOL
        .word   DIGLEAD
        .word   DUPTOR
        .word   PLUS
        .word   CSLL
        .word   RFROM
        .word   SUB
        .word   SEMIS
; ----------------------------------------------------------------------------
; -MOVE_nfa
DMOVE_nfa:
        .byte   $85
        .byte   "-MOV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   DIGLAG_nfa
; -MOVE
DMOVE:
        .word   DOCOL
        .word   LINE
        .word   CSLL
        .word   CMOVE
        .word   UPDATE
        .word   SEMIS
; ----------------------------------------------------------------------------
H_nfa:
        .byte   $81,$C8
; ----------------------------------------------------------------------------
        .word   DMOVE_nfa
H:      .word   DOCOL
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
E_nfa:
        .byte   $81,$C5
; ----------------------------------------------------------------------------
        .word   H_nfa
E:      .word   DOCOL
        .word   LINE
        .word   CSLL
        .word   BLANKS
        .word   UPDATE
        .word   SEMIS
; ----------------------------------------------------------------------------
S_nfa:
        .byte   $81,$D3
; ----------------------------------------------------------------------------
        .word   E_nfa
S:      .word   DOCOL
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
D_nfa:
        .byte   $81,$C4
; ----------------------------------------------------------------------------
        .word   S_nfa
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
M_nfa:
        .byte   $81,$CD
; ----------------------------------------------------------------------------
        .word   D_nfa
M:      .word   DOCOL
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
T_nfa:
        .byte   $81,$D4
; ----------------------------------------------------------------------------
        .word   M_nfa
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
L_nfa:
        .byte   $81,$CC
; ----------------------------------------------------------------------------
        .word   T_nfa
        .word   DOCOL
        .word   SCR
        .word   AT
        .word   LIST
        .word   ZERO
        .word   M
        .word   SEMIS
; ----------------------------------------------------------------------------
; R vocabulaire EDITOR
Reditor_nfa:
        .byte   $81,$D2
; ----------------------------------------------------------------------------
        .word   L_nfa
; R vocabulaire EDITOR
Reditor:
        .word   DOCOL
        .word   PAD
        .word   ONEP
        .word   SWAP
        .word   DMOVE
        .word   SEMIS
; ----------------------------------------------------------------------------
P_nfa:
        .byte   $81,$D0
; ----------------------------------------------------------------------------
        .word   Reditor_nfa
        .word   DOCOL
        .word   ONE
        .word   TEXT
        .word   Reditor
        .word   SEMIS
; ----------------------------------------------------------------------------
; I vocabulaire EDITOR
Ieditor_nfa:
        .byte   $81,$C9
; ----------------------------------------------------------------------------
        .word   P_nfa
LF494:
        .word   DOCOL
        .word   DUP
        .word   S
        .word   Reditor
        .word   SEMIS
; ----------------------------------------------------------------------------
TOP_nfa:
        .byte   $83
        .byte   "TO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   Ieditor_nfa
TOP:
        .word   DOCOL
        .word   ZERO
        .word   RNUM
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
CLEAR_nfa:
        .byte   $85
        .byte   "CLEA"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   TOP_nfa
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
MATCH_nfa:
        .byte   $85
        .byte   "MATC"
        .byte   $C8
; ----------------------------------------------------------------------------
        .word   CLEAR_nfa
LF4D6:
        .word   DOCOL
        .word   TOR
        .word   TOR
        .word   TWODUP
        .word   RFROM
        .word   R
        .word   LC771
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
; 1LINE_nfa
ONELINE_nfa:
        .byte   $85
        .byte   "1LIN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   MATCH_nfa
ONELINE:
        .word   DOCOL
        .word   DIGLAG
        .word   PAD
        .word   COUNT
        .word   LF4D6
        .word   RNUM
        .word   PSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
FIND_nfa:
        .byte   $84
        .byte   "FIN"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   ONELINE_nfa
FIND:
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
DELETE_nfa:
        .byte   $86
        .byte   "DELET"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   FIND_nfa
DELETE:
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
; N vocaublaire EDITOR
Neditor_nfa:
        .byte   $81,$CE
; ----------------------------------------------------------------------------
        .word   DELETE_nfa
; N vocaublaire EDITOR
Neditor:
        .word   DOCOL
        .word   FIND
        .word   ZERO
        .word   M
        .word   SEMIS
; ----------------------------------------------------------------------------
F_nfa:
        .byte   $81,$C6
; ----------------------------------------------------------------------------
        .word   Neditor_nfa
        .word   DOCOL
        .word   ONE
        .word   TEXT
        .word   Neditor
        .word   SEMIS
; ----------------------------------------------------------------------------
B_nfa:
        .byte   $81,$C2
; ----------------------------------------------------------------------------
        .word   F_nfa
        .word   DOCOL
        .word   PAD
        .word   CAT
        .word   MINUS
        .word   M
        .word   SEMIS
; ----------------------------------------------------------------------------
X_nfa:
        .byte   $81,$D8
; ----------------------------------------------------------------------------
        .word   B_nfa
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
TILL_nfa:
        .byte   $84
        .byte   "TIL"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   X_nfa
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
C_nfa:
        .byte   $81,$C3
; ----------------------------------------------------------------------------
        .word   TILL_nfa
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
nu_nfa:
        .byte   $82
        .byte   "n"
        .byte   $F5
; ----------------------------------------------------------------------------
        .word   C_nfa
nu:
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
NEW_nfa:
        .byte   $83
        .byte   "NE"
        .byte   $D7
; ----------------------------------------------------------------------------
        .word   nu_nfa
        .word   DOCOL
        .word   LIT
        .word   Reditor
        .word   nu
        .word   SEMIS
; ----------------------------------------------------------------------------
UNDER_nfa:
        .byte   $85
        .byte   "UNDE"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   NEW_nfa
        .word   DOCOL
        .word   ONEP
        .word   LIT
        .word   LF494
        .word   nu
        .word   SEMIS
; ----------------------------------------------------------------------------
SCRMOVE_nfa:
        .byte   $87
        .byte   "SCRMOV"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   UNDER_nfa
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
SCRCOPY_nfa:
        .byte   $87
        .byte   "SCRCOP"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   SCRMOVE_nfa
        .word   DOCOL
        .word   USING
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $03
        .byte   "de "
; ----------------------------------------------------------------------------
        .word   LIT
        .word   $03
        .word   PICK
        .word   DUP
        .word   DOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   "a "
; ----------------------------------------------------------------------------
        .word   OVER
        .word   PLUS
        .word   DOT
        .word   XFILE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $04
        .byte   "vers"
; ----------------------------------------------------------------------------
        .word   USING
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $03
        .byte   "de "
; ----------------------------------------------------------------------------
        .word   OVER
        .word   DUP
        .word   DOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   "a "
; ----------------------------------------------------------------------------
        .word   OVER
        .word   PLUS
        .word   DOT
        .word   XFILE
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $06
        .byte   "Copier"
; ----------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------
LIFE_nfa:
        .byte   $C4
        .byte   "LIF"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   WHERE_nfa
        .word   DODOES
        .word   DOVOC
        .word   LIFE_voc
; VL0
LIFE_LINK:
        .word   EDITOR_LINK
; ----------------------------------------------------------------------------
DXY_nfa:
        .byte   $83
        .byte   "DX"
        .byte   $D9
; ----------------------------------------------------------------------------
        .word   FORTH_voc
DXY:
        .word   DOVAR
        .word   RAM_START+42
; ----------------------------------------------------------------------------
NEWm_nfa:
        .byte   $84
        .byte   "NEW"
        .byte   $ED
; ----------------------------------------------------------------------------
        .word   DXY_nfa
NEWm:
        .word   DOVAR
        .word   RAM_START+44
; ----------------------------------------------------------------------------
OLDm_nfa:
        .byte   $84
        .byte   "OLD"
        .byte   $ED
; ----------------------------------------------------------------------------
        .word   NEWm_nfa
OLDm:
        .word   DOVAR
        .word   RAM_START+46
; ----------------------------------------------------------------------------
WRKm_nfa:
        .byte   $84
        .byte   "WRK"
        .byte   $ED
; ----------------------------------------------------------------------------
        .word   OLDm_nfa
WRKm:
        .word   DOVAR
        .word   RAM_START+48
; ----------------------------------------------------------------------------
; org^_nfa
orgCARET_nfa:
        .byte   $84
        .byte   "org"
        .byte   $DE
; ----------------------------------------------------------------------------
        .word   WRKm_nfa
; org^
orgCARET:
        .word   DOVAR
        .word   RAM_START+50
; ----------------------------------------------------------------------------
; mid^_nfa
midCARET_nfa:
        .byte   $84
        .byte   "mid"
        .byte   $DE
; ----------------------------------------------------------------------------
        .word   orgCARET_nfa
; mid^
midCARET:
        .word   DOVAR
        .word   RAM_START+52
; ----------------------------------------------------------------------------
; end^_nfa
endCARET_nfa:
        .byte   $84
        .byte   "end"
        .byte   $DE
; ----------------------------------------------------------------------------
        .word   midCARET_nfa
; end^
endCARET:
        .word   DOVAR
        .word   RAM_START+54
; ----------------------------------------------------------------------------
; C:L_nfa
CCOLL_nfa:
        .byte   $83
        .byte   "C:"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   endCARET_nfa
; C:L
CCOLL:
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
; L:C_nfa
LCOLC_nfa:
        .byte   $83
        .byte   "L:"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   CCOLL_nfa
; L:C
LCOLC:
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
; C*L_nfa
CSTARL_nfa:
        .byte   $83
        .byte   "C*"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   LCOLC_nfa
; C*L
CSTARL:
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
; m#_nfa
mDIG_nfa:
        .byte   $82
        .byte   "m"
        .byte   $A3
; ----------------------------------------------------------------------------
        .word   CSTARL_nfa
; m#
mDIG:
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
TOKEN_nfa:
        .byte   $85
        .byte   "TOKE"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   mDIG_nfa
TOKEN:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $006F
; ----------------------------------------------------------------------------
TXTORG_nfa:
        .byte   $86
        .byte   "TXTOR"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   TOKEN_nfa
TXTORG:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $BBA8
; ----------------------------------------------------------------------------
PAINT_nfa:
        .byte   $85
        .byte   "PAIN"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   TXTORG_nfa
PAINT:
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
; .CURSOR_nfa
DOTCURSOR_nfa:
        .byte   $87
        .byte   ".CURSO"
        .byte   $D2
; ----------------------------------------------------------------------------
        .word   PAINT_nfa
; .CURSOR
DOTCURSOR:
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
; .GENE_nfa
DOTGENE_nfa:
        .byte   $85
        .byte   ".GEN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   DOTCURSOR_nfa
; .GENE
DOTGENE:
        .word   DOCOL
        .word   ZERO
        .word   ZERO
        .word   GOTOXY
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   "Gene "
; ----------------------------------------------------------------------------
        .word   DOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   ": "
; ----------------------------------------------------------------------------
        .word   midCARET
        .word   AT
        .word   orgCARET
        .word   AT
        .word   SUB
        .word   TWOSL
        .word   DOT
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $02
        .byte   "/ "
; ----------------------------------------------------------------------------
        .word   endCARET
        .word   AT
        .word   orgCARET
        .word   AT
        .word   SUB
        .word   TWOSL
        .word   DOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; .mLEN_nfa
DOTmLEN_nfa:
        .byte   $84
        .byte   "mLE"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   DOTGENE_nfa
; .mLEN
DOTmLET:
        .word   DOCOL
        .word   CCOLL
        .word   LCOLC
        .word   LIT
        .word   $08
        .word   STARSL
        .word   SEMIS
; ----------------------------------------------------------------------------
; m,_nfa
mCOMMA_nfa:
        .byte   $82
        .byte   "m"
        .byte   $AC
; ----------------------------------------------------------------------------
        .word   DOTmLEN_nfa
; m,
mCOMMA:
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
; m@_nfa
mAT_nfa:
        .byte   $82
        .byte   "m"
        .byte   $C0
; ----------------------------------------------------------------------------
        .word   mCOMMA_nfa
; m@
mAT:
        .word   DOCOL
        .word   AT
        .word   SWAP
        .word   BMAP
        .word   CTST
        .word   SEMIS
; ----------------------------------------------------------------------------
; m!_nfa
mSTORE_nfa:
        .byte   $82
        .byte   "m"
        .byte   $A1
; ----------------------------------------------------------------------------
        .word   mAT_nfa
; m!
mSTORE:
        .word   DOCOL
        .word   AT
        .word   SWAP
        .word   BMAP
        .word   TOGGLE
        .word   SEMIS
; ----------------------------------------------------------------------------
; ^,_nfa : !!! REMPLACER .byte ''^'' par .byte $5E sinon XA insère la chaine et tout ce qui qui la suit sans le ^
CARETCOMMA_nfa:
        .byte   $82
        .byte   $5E
        .byte   $AC
; ----------------------------------------------------------------------------
        .word   mSTORE_nfa
; ^,
CARETCOMMA:
        .word   DOCOL
        .word   DUPTOR
        .word   AT
        .word   STORE
        .word   TWO
        .word   RFROM
        .word   PSTORE
        .word   SEMIS
; ----------------------------------------------------------------------------
around_nfa:
        .byte   $86
        .byte   "aroun"
        .byte   $E4
; ----------------------------------------------------------------------------
        .word   CARETCOMMA_nfa
around:
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
INI_nfa:
        .byte   $83
        .byte   "IN"
        .byte   $C9
; ----------------------------------------------------------------------------
        .word   around_nfa
INI:
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
QFN_nfa:
        .byte   $83
        .byte   "QF"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   INI_nfa
QFN:
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
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   "Load:"
; ----------------------------------------------------------------------------
        .word   BRANCH
        .word   LFA9D
LFA95:
        .word   PDOTQ
; ----------------------------------------------------------------------------
        .byte   $05
        .byte   "Save:"
; ----------------------------------------------------------------------------
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
GENE_nfa:
        .byte   $84
        .byte   "GEN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   QFN_nfa
GENE:
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
; ----------------------------------------------------------------------------
DEMO_nfa:
        .byte   $84
        .byte   "DEM"
        .byte   $CF
; ----------------------------------------------------------------------------
        .word   LIFE_nfa
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
; ----------------------------------------------------------------------------
ROMend_nfa:
        .byte   $86
        .byte   "ROMen"
        .byte   $E4
; ----------------------------------------------------------------------------
        .word   DEMO_nfa
ROMend:
        .word   INIT_RAM
        .word   SEMIS

; ----------------------------------------------------------------------------
; Taille de la table d'init du dictionnaire en RAM (copiée en $1404 par COLD)
DictInitTable:
        .word   DictInitTableEnd-(*+2)

; ----------------------------------------------------------------------------
; +00 -> defer de ABORT
ABORT_defer:
        .word   PABORT

; ----------------------------------------------------------------------------
; +02 -> defer de NUMBER
NUMBER_defer = RAM_START-2+(*-DictInitTable)
        .word   INUMBER

; +04 -> defer de PROMPT
PROMPT_defer = RAM_START-2+(*-DictInitTable)
        .word   OK
; ----------------------------------------------------------------------------
; +06 -> Pour le vocabulaire FORTH
FORTH_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   ROMend_nfa

; ----------------------------------------------------------------------------
; +10 -> defer de QTERMINAL (initialisé à QTERM par TERMINAL)
QTERMINAL_defer = RAM_START-2+(*-DictInitTable)
        .word   LC05C

; ----------------------------------------------------------------------------
; +12 -> defer de KEY (initialisé à CKEY par TERMINAL)
KEY_defer = RAM_START-2+(*-DictInitTable)
        .word   LC05C

; ----------------------------------------------------------------------------
; +14 -> defer de EMIT (initialisé à CEMIT par TERMINAL)
EMIT_defer = RAM_START-2+(*-DictInitTable)
        .word   LC05C

; ----------------------------------------------------------------------------
; +16 -> Pour le vocabulaire SOUNDS
SOUNDS_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   PING_nfa

; ----------------------------------------------------------------------------
; +20 -> Pour le vocabulaire GRAFX
GRAFX_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   CHARCOL_nfa

; ----------------------------------------------------------------------------
; +24 -> Pour le vocabulaire WINDOWS
WINDOWS_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   SCROLL_nfa

; ----------------------------------------------------------------------------
; +28 -> Pour le vocabulaire IOS
IOS_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   PAGE_nfa

; ----------------------------------------------------------------------------
; +32 -> defer de MINITEL
MINITEL_defer = RAM_START-2+(*-DictInitTable)
        .word   LC05C

; ----------------------------------------------------------------------------
; +34 -> Pour le vocabulaire EDITOR
EDITOR_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   SCRCOPY_nfa

; ----------------------------------------------------------------------------
; +38 -> Pour le vocabulaire LIFE
LIFE_voc = RAM_START-2+(*-DictInitTable)
        .byte   $81,$A0
        .word   GENE_nfa

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00
DictInitTableEnd:

 .dsb $fff8-*,$00

; ----------------------------------------------------------------------------
        .word   teleforth_signature
; ----------------------------------------------------------------------------
        .byte   $12,$EF
; ----------------------------------------------------------------------------
        .word   ORIGIN
        .word   virq
