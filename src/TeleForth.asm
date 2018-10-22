; da65 V2.17 - Git 334e30c
; Created:    2018-06-14 23:41:53
; Input file: original/TeleForth.rom
; Page:       1


;        .setcpu "6502"

    * = $c000
#include "TeleForth.inc"
;#define TELEFORTH_20
#define TELEFORTH_12

; ----------------------------------------------------------------------------
; Version Teleforth 2.0
; ----------------------------------------------------------------------------
#ifdef TELEFORTH_20
; #echo "Compilation TeleForth v2.0 (ch376)"

#define VERSION_MAJ 2
#define VERSION_MIN 0
#echo "Compilation TeleForth VERSION_MAJ.VERSION_MIN (ch376)"

; Deplace les variables vasalo,... après PIO_addr pour éviter la collision avec
; Orix (pour pouvoir récupérer le PATH courant)
; A voir si ces variables sont nécessaires avec le ch376
#define Page05_Base ($0568-$28)

#define COMPACT
#define WITHOUT_FIGFORTH_BUG

; Décompilateur
;#define WITH_DECOMPILER

; Extensions sonores
#define WITH_SOUNDS_VOC

; Extensions graphiques
#define WITH_GRAFX_VOC

; SCRW et CURSOR nécessaires pour TERMINAL
#define WITH_WINDOWS_VOC

#define WITH_CLOCK
#define WITH_WAIT

; Support disque (Telestrat)
; R/W nécessaire pour FLUSH et BLOCK
;#define WITH_STRATSED_MINIMAL
; USING et XFILE nécessaires pour SCRMOVE et SCRCOPY
; DOLLOAD et DOLSAVE nécessaires pour OVERLAYS et EXTERNAL
; SALOSTORE nécessaire pour IOS_SERIAL et IOS_MINITEL
;#define WITH_STRATSED

; Support disque (CH376)
#define WITH_CH376
; Necessaire pour support AUTOSTART
;#define CH376_Extended

; Force les noms de fichiers en MAJUSCULES
#define WITH_UPERCASE_FILENAME
;#define WITH_UPPER

#define WITH_ARGV

; Support carte Twilight
#define WITH_TWILIGHTE

; Support EXIT (source dans Control.asm)
#define WITH_EXIT

; Support des structures de contrôle
#define WITH_ALL_TESTS
;#define WITH_IF_THEN_ELSE
;#define WITH_BEGIN_AGAIN
;#define WITH_BEGIN_UNTIL
;#define WITH_BEGIN_WHILE
;#define WITH_DO_LOOP
;#define WITH_DO_PLOOP
;#define WITH_CASE_OF_ENDCASE

#define WITH_PSEUDO_IF

#define WITH_AUTOSTART_SUPPORT
#define AUTOSTART_FILE "STARTUP.DAT"

; Gestion des écrans
#define WITH_QLOADING
#define WITH_FOLLOW
;#define WITH_BACKSLASH
#define WITH_BACKSLASH_IMMEDIATE
#define WITH_CSLL
#define WITH_PLINE
#define WITH_DOTLINE
#define WITH_INDEX
#define WITH_LIST
#define WITH_TRIAD
#define WITH_THRU
#define WITH_LOAD

#define WITH_OVERLAYS_SUPPORT
;#define WITH_EXTERNAL_HELPERS

; OPCH, QTERM, CKEY et CEMIT nécessaires pour TERMINAL
#define WITH_IOS_VOC
;#define WITH_IOS_PRINTER
;#define WITH_IOS_SERIAL
;#define WITH_IOS_MINITEL

;#define WITH_INPUT
;#define WITH_OUTPUT

; Support editeur standard
#define WITH_EDITOR_VOC
#define WITH_WHERE
#define WITH_EDITOR_TEXT_LINE
;#define WITH_EDITOR_SCRMOVE_SCRCOPY

; Jeu de la vie (démonstration)
;#define WITH_LIFE_VOC
;#define WITH_LIFE_DEMO

; Gestion du dictionnaire
#define WITH_FORGET
#define WITH_VLIST
#define WITH_VOC_LIST

;#define WITH_ROMend
#endif

; ----------------------------------------------------------------------------
; Version Teleforth 1.2
; ----------------------------------------------------------------------------
#ifdef TELEFORTH_12
;#echo "Compilation TeleForth v1.2 (TeleStrat)"

#define VERSION_MAJ 1
#define VERSION_MIN 2
#echo "Compilation TeleForth VERSION_MAJ.VERSION_MIN (TeleStrat)"

#define Page05_Base $0500

#undef COMPACT
#undef WITHOUT_FIGFORTH_BUG

; Décompilateur
#define WITH_DECOMPILER

; Extensions sonores
#define WITH_SOUNDS_VOC

; Extensions graphiques
#define WITH_GRAFX_VOC

; SCRW et CURSOR nécessaires pour TERMINAL
#define WITH_WINDOWS_VOC

#define WITH_CLOCK
#define WITH_WAIT

; Support disque (Telestrat)
; R/W nécessaire pour FLUSH et BLOCK
#define WITH_STRATSED_MINIMAL
; USING et XFILE nécessaires pour SCRMOVE et SCRCOPY
; DOLLOAD et DOLSAVE nécessaires pour OVERLAYS et EXTERNAL
; SALOSTORE nécessaire pour IOS_SERIAL et IOS_MINITEL
#define WITH_STRATSED

; Support disque (CH376)
#undef WITH_CH376
; Necessaire pour support AUTOSTART
#undef CH376_Extended

; Support des structures de contrôle
#define WITH_ALL_TESTS
;#define WITH_IF_THEN_ELSE
;#define WITH_BEGIN_AGAIN
;#define WITH_BEGIN_UNTIL
;#define WITH_BEGIN_WHILE
;#define WITH_DO_LOOP
;#define WITH_DO_PLOOP
;#define WITH_CASE_OF_ENDCASE

#define WITH_PSEUDO_IF

#define WITH_AUTOSTART_SUPPORT
#define AUTOSTART_FILE "FORTH.DAT"

; Gestion des écrans
#define WITH_QLOADING
#define WITH_FOLLOW
#define WITH_BACKSLASH
#define WITH_CSLL
#define WITH_PLINE
#define WITH_DOTLINE
#define WITH_INDEX
#define WITH_LIST
#define WITH_TRIAD
#define WITH_THRU
#define WITH_LOAD

#define WITH_OVERLAYS_SUPPORT
#define WITH_EXTERNAL_HELPERS

; OPCH, QTERM, CKEY et CEMIT nécessaires pour TERMINAL
#define WITH_IOS_VOC
#define WITH_IOS_PRINTER
#define WITH_IOS_SERIAL
#define WITH_IOS_MINITEL

#define WITH_INPUT
#define WITH_OUTPUT

; Support editeur standard
#define WITH_EDITOR_VOC
;#define WITH_WHERE
#define WITH_EDITOR_TEXT_LINE
#define WITH_EDITOR_SCRMOVE_SCRCOPY

; Jeu de la vie (démonstration)
#define WITH_LIFE_VOC
#define WITH_LIFE_DEMO

; Gestion du dictionnaire
#define WITH_FORGET
#define WITH_VLIST
#define WITH_VOC_LIST

#define WITH_ROMend

#endif

; ----------------------------------------------------------------------------

#ifdef WITH_STRATSED
#define WITH_STRATSED_MINIMAL
#endif

;#ifdef WITH_AUTOSTART_SUPPORT
; Need some OS support?
;#define WITH_STRATSED
;#endif

#ifdef WITH_AUTOSTART_SUPPORT
#ifndef AUTOSTART_FILE
#define AUTOSTART_FILE "FORTH.DAT"
#endif
#echo 'Fichier AUTOSTART par defaut: AUTOSTART_FILE'
#endif

#ifdef WITH_EXTERNAL_HELPERS
#define WITH_OVERLAYS_SUPPORT
#endif

#ifdef WITH_CLOCK
#define WITH_WINDOWS_VOC
#define NEED_MON
#endif

#ifdef WITH_IOS_PRINTER
#define WITH_IOSext_VOC
#endif

#ifdef WITH_IOS_SERIAL
#define WITH_IOSext_VOC
#endif

#ifdef WITH_IOS_MINITEL
#define WITH_IOSext_VOC
#endif

#ifdef WITH_IOSext_VOC
#define WITH_IOS_VOC
#endif

#ifdef WITH_EDITOR_SCRMOVE_SCRCOPY
#define WITH_EDITOR
#endif

#ifdef WITH_EDITOR_VOC
#define WITH_EDITOR_TEXT_LINE
#endif

#ifdef WITH_LIFE_DEMO
#define WITH_LIFE_VOC
#endif

#ifdef WITH_LIFE_VOC
#define WITH_GRAFX_VOC
#define WITH_WAIT
#define WITH_OVERLAYS_SUPPORT
#endif

; --------------------------

; Structures de contrôle

#ifdef WITH_ALL_TESTS
#define WITH_CONTROL_FLOW

#define WITH_IF_THEN_ELSE
#define WITH_BEGIN_AGAIN
#define WITH_BEGIN_UNTIL
#define WITH_BEGIN_WHILE
#define WITH_DO_LOOP
#define WITH_DO_PLOOP
#define WITH_CASE_OF_ENDCASE
#endif

#ifdef WITH_IF_THEN_ELSE
#define WITH_CONTROL_FLOW
#define NEED_MRKFROM
#endif

#ifdef WITH_BEGIN_AGAIN
#define WITH_CONTROL_FLOW
#define NEED_MRKTO
#define NEED_BEGIN
#define NEED_AGAIN
#endif

#ifdef WITH_BEGIN_UNTIL
#define WITH_CONTROL_FLOW
#define NEED_MRKTO
#define NEED_BEGIN
#define NEED_UNTIL
#endif

#ifdef WITH_BEGIN_WHILE
#define WITH_CONTROL_FLOW
#define NEED_MRKFROM
#define NEED_MRKTO
#define NEED_BEGIN
#define NEED_WHILE
#define NEED_REPEAT
#endif

#ifdef WITH_DO_LOOP
#define WITH_CONTROL_FLOW
#define NEED_MRKTO
#define NEED_DO
#define NEED_LOOP
#endif

#ifdef WITH_DO_PLOOP
#define WITH_CONTROL_FLOW
#define NEED_MRKTO
#define NEED_DO
#define NEED_PLOOP
#endif

#ifdef WITH_CASE_OF_ENDCASE
#define WITH_CONTROL_FLOW
#define NEED_MRKFROM
#endif


; --------------------------
#define NEED_ABORT


#ifdef NEED_ABORT
#define NEED_PABORT
#endif

#ifdef WITH_CH376
#define NEED_LOAD
#endif

#ifdef WITH_UPERCASE_FILENAME
#define NEED_UPPER
#endif

#ifdef WITH_UPPER
#define NEED_UPPER
#endif

#ifdef WITH_STRATSED
#define NEED_LOAD
#endif

#ifdef WITH_CSLL
#define NEED_CSLL
#endif

#ifdef WITH_QLOADING
#define NEED_QLOADING
#endif

#ifdef WITH_LOAD
#define NEED_LOAD
#endif


#ifndef WITH_EDITOR_VOC
;#undef WITH_INDEX
;#undef WITH_TRIAD
#undef WITH_EDITOR_SCRMOVE_SCRCOPY
#undef WITH_EDITOR_TEXT_LINE
#endif

#ifdef WITH_EDITOR_VOC
#define NEED_CSLL
#define WITH_PLINE
#define WITH_LIST
#define WITH_DOTLINE
#define WITH_WHERE
#endif

#ifdef WITH_FOLLOW
#define NEED_QLOADING
#endif

#ifdef WITH_BACKSLASH_IMMEDIATE
#define WITH_BACKSLASH
#endif

#ifdef WITH_BACKSLASH
#define NEED_QLOADING
#define NEED_CSLL
#endif

#ifdef WITH_INDEX
#define WITH_DOTLINE
#define NEED_QTERMSTOP
#endif

#ifdef WITH_TRIAD
#define WITH_LIST
#define NEED_QTERMSTOP
#endif

#ifdef WITH_LIST
#define WITH_DOTLINE
#define NEED_QTERMSTOP
#endif

#ifdef WITH_VLIST
#define NEED_QTERMSTOP
#endif

#ifdef WITH_DOTLINE
#define WITH_PLINE
#endif

#ifdef WITH_PLINE
#define NEED_CSLL
#endif

#ifdef WITH_CLOCK
#define NEED_AYX
#endif

#ifdef WITH_GRAFX_VOC
#define NEED_AYX
#endif

#ifdef WITH_IOS_VOC
#define NEED_AYX
#endif

#ifdef WITH_SOUNDS_VOC
#define NEED_AYX
#endif

#ifdef WITH_STRATSED
#define NEED_AYX
#endif

#ifdef WITH_WINDOWS_VOC
#define NEED_AYX
#endif


#ifdef WITH_INPUT
#define NEED_PIO
#endif

#ifdef WITH_OUTPUT
#define NEED_PIO
#endif

#ifdef NEED_PABORT
#define NEED_PIO
#endif

#ifdef NEED_QTERMSTOP
#define NEED_PIO
#endif


#ifdef WITH_GRAFX_VOC
#define NEED_MON
#endif

#ifdef WITH_IOS_VOC
#define NEED_MON
#endif

#ifdef WITH_SOUNDS_VOC
#define NEED_MON
#endif

#ifdef WITH_STRATSED
#define NEED_MON
#define NEED_PIO
#endif

#ifdef WITH_WINDOWS_VOC
#define NEED_MON
#endif


#ifdef WITH_IOSExt_VOC
#define NEED_MONCOL
#define NEED_PIO
#endif

#ifdef WITH_GRAFX_VOC
#define NEED_MONCOL
#endif

#ifdef WITH_SOUNDS_VOC
#define NEED_MONCOL
#endif


#ifdef WITH_GRAFX_VOC
#define NEED_HRSCOL
#endif

#ifdef WITH_SOUNDS_VOC
#define NEED_HRSCOL
#endif

#ifdef WITH_OVERLAYS_SUPPORT
#define NEED_HIMEM
#endif

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

tabdrv          = $0208                        ; Activation des lecteurs (0-> non c0nnecté, sinon nb pistes (b7=1-> double face))
drvdef          = $020C                        ; Numéro (0-3) du lecteur par défaut
flgtel          = $020D                        ; b7:1-> haute résolution, b6:1-> mode minitel, b5:1-> mode degrés (0->radian), b2:1->BONJOUR.COM existe, b1:1->imprimante CENTRONICS détectée, b0:1-> STRATSED absent
timeS           = $0211                        ; Horloge: secondes
timeM           = $0212                        ; Horloge: minutes
timeH           = $0213                        ; Horloge: heures
scrX            = $0220                        ; Coordonnée X
scrY            = $0224                        ; Coordonnée Y
hrspat          = $02AA                        ; Motif
vnmi            = $02F4                        ; Vecteur NMI (n° de banque, adresse)
virq            = $02FA                        ; Vecteur IRQ
vaplic          = $02FD                        ; N° banque, adresse TELEMATIC->LANGAGE

v2dra           = $0321

Exbnk           = $040C
vexbnk          = $0414
bnkcib          = $0417

drive           = $0500                        ; N° de drive (0-3)
piste           = $0501                        ; N° de piste (b7=1-> face B)
secteu          = $0502                        ; N° de secteur
rwbuf           = $0503                        ; Adresse tampon DOS pour lecture/écriture
errnb           = $0512                        ; Code erreur: 00->Ok, 01->Fichier inexistant, 02->I/O, 03->Fichier existant, 04->disque plein, 05->disquette protégée, 06->erreur de type de fichier, 07->Format inconnu, 11->Fichier déjà ouvert, 12->Fichier fermé, 13->Fin de fichier (séquentiel), 14->mauvais type d'expression, 15->mauvais n° de fiche
saves           = $0513
bufnom          = $0517                        ; N° de lecteur + nom du fichier sur 12 caractères ( ORIX: $0517-$0524)

                                               ; Orix: ORIX_PATH_CURRENT (ORIX_MAX_PATH_LENGTH:=MAX_LENGTH_OF_FILES*PATH_CURRENT_MAX_LEVEL+PATH_CURRENT_MAX_LEVEL)
                                               ; $0525-$0525+9*4+4 -> $0525-$054C
vasalo0         = Page05_Base +$28             ; Flag lecture/écriture
ftype           = Page05_Base +$2C             ; Type du fichier
desalo          = Page05_Base +$2D             ; Adresse de début du fichier à écrire
fisalo          = Page05_Base +$2F             ; Adresse de fin du fichier à écrire
tampfc          = Page05_Base +$42             ; Adresse de début des tampons fichier (initialisé à DOSBUFFERS par STARTUP)
bitmfc          = Page05_Base +$44             ; (word) BitMap des tampons logiques (même convention que la BitMap disquette, 0->occupé, 1->libre))
ficnum          = Page05_Base +$48             ; Numéro logique du fichier (1 ou 2)
nbfic           = Page05_Base +$49             ; Nombre de fichiers autorisés par FILE (2)
xfield          = Page05_Base +$4C             ; Pour fichier accès direct: xfield=n° de banque, xfield+1=adresse

CallTel         = $0560                        ; Routine d'appel d'une fonction Telemon. Initialisé à: 00 00 60 00 par (ABORT)
AYX_addr        = $0563                        ; Utilisé pour le passage des registres A,X,Y pour les appels MON
PIO_addr        = $0566                        ; Utilisé pour le passage du registre P pour les appels MON

_UAREA_         = $0800                        ; User Area (ex. CURRENT := $0822)
DOSBUFFERS      = $0840                        ; Tampons DOS pour 2 fichiers (taille: $0300+$0260*nbfic -> $07C0)
_FIRST          = $1000                        ; Tampon pour 1 écran (FIRST) de $0400 octets + octets de contrôles -- $1000 := DOSBUFFERS+$0300+$0260*2
RAM_START       = _FIRST+2+$0400+2             ; Zone pour le dictionnaire (LIMIT) - 1er mot utilisateur à partir de $143C := $1000+$0404 + $38 (longueur du dictionnaire en RAM)
SCRTXT          = $BB80                        ; Adresse de base de l'écran TEXT

;last_voc_link   = $0000
;PREV_VOC_LINK   = $0000

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
        .word   last_forth_word_nfa
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
        .word   last_voc_link
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
NOOP:
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
; Transfère ACC mots de la pile vers N
SETUP:
        asl
        sta     N-1
        sta     NEXT+1                         ; /?\ Bug, heureusement NEXT est en ROM!
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
; BUG: HEX 16A1 16A1 U* D. -> 01001141 au lieu de 02001141
; Correction du bug: http://forum.6502.org/viewtopic.php?f=9&t=689&start=30#p34890
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
#ifdef WITHOUT_FIGFORTH_BUG
        bne     LC3E1
        inc     BOT+1,x
#endif
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
; BUG: HEX 80000000. 8001 U/ U. U. -> 0 0 au lieu de FFFE 0002
; Correction du bug: http://6502org.wikidot.com/errata-software-figforth
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
        lda     $04  ,x
#ifdef WITHOUT_FIGFORTH_BUG
        bcs     L0446
#endif
        sec
        sbc     BOT,x
        tay
        lda     $05  ,x
        sbc     BOT+1,x
        bcc     LC418
        sty     $04  ,x
L0442:
        sta     $05  ,x
LC418:
        rol     SECOND,x
        rol     SECOND+1,x
        dec     N
        bne     LC404
        jmp     POP

#ifdef WITHOUT_FIGFORTH_BUG
L0446:
        sbc     BOT,x
        sta     $04  ,x
        lda     $05  ,x
        sbc     BOT+1,x
        sec
        bcs     L0442
#endif
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
        .word   SEMIS
; ----------------------------------------------------------------------------
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
TWOSWAP:
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
        sty     NEXT+2                         ; /?\ Bug, heureusement NEXT est en ROM!
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

-last_forth_word_nfa = DLITERAL_nfa

; ----------------------------------------------------------------------------
#ifdef WITH_DECOMPILER
#echo "Ajout du mini décompilateur"

backslash_C_nfa:
        .byte   $82
        .byte   "\"
        .byte   $C3
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = backslash_D_nfa
#endif

; ----------------------------------------------------------------------------
WORD_nfa:
        .byte   $84
        .byte   "WOR"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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



#ifndef WITH_CH376
        .byte   $0F,$20
        .byte   "TELE-FORTH V1.2 - Thierry BESTEL"
#else
.(
#define MSG015 "TELE-FORTH V",VERSION_MAJ+$30,".",VERSION_MIN+$30," - Christian Lardiere"
        .byte $0F
        .byte end-*-1
        .byte MSG015
        end=*
.)
#endif

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

#ifndef WITH_CH376
        .byte   $FE,$2B
        .byte   "TELE-FORTH V1.2",$0D,$0A,"genere avec TELE-ASS V1.0a"


        .byte   $FF,$32
        .byte   "Base sur TELE-FORTH V1.1 ",$0D,$0A,"de Christophe LAVARENNE"
#else
.(
#define MSG145 "Repertoire inexistant"
        .byte $91
        .byte end-*-1
        .byte MSG145
        end=*
.)
.(
#define MSG147 "Repertoire existant"
        .byte $93
        .byte end-*-1
        .byte MSG147
        end=*
.)

.(
#define MSG254 "TELE-FORTH V",VERSION_MAJ+$30,".",VERSION_MIN+$30,$0D,$0A,"genere avec xa v2.3.8"
        .byte $FE
        .byte end-*-1
        .byte MSG254
        end=*
.)
.(
#define MSG255 "Base sur TELE-FORTH V1.2",$0D,$0A,"de Thierry Bestel"
        .byte $FF
        .byte end-*-1
        .byte MSG255
        end=*

.)
#endif



#ifndef COMPACT
.dsb $D524-*,$00
#endif

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
; Nécessite le mot WHERE défini avec le vocabulaire EDITOR
; TODO: Vectoriser ERROR pour pouvoir avoir une version avec et sans WHERE
;       Ou vectoriser WHERE...
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
#ifdef WITH_WHERE
#echo "Ajout du support WHERE pour ERROR"
        .word   BLK
        .word   AT
        .word   DDUP
        .word   ZBRANCH
        .word   LD6F6
        .word   IN
        .word   AT
        .word   SWAP
        .word   WHERE
#endif
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
; Vocabulaire FORTH

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

last_voc_link = FORTH_LINK

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

-last_forth_word_nfa = EMIT_nfa

; ----------------------------------------------------------------------------
; (ABORT)_nfa
#ifdef NEED_PABORT
#echo "Ajout du mot (ABORT)"
PABORT_nfa:
        .byte   $87
        .byte   "(ABORT"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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
        .word   VERSION_MAJ
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
        .word   VERSION_MIN
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

-last_forth_word_nfa = PABORT_nfa
#endif

; ----------------------------------------------------------------------------
COLD_nfa:
        .byte   $84
        .byte   "COL"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
COLD:
        .word   DOCOL
#ifdef WITH_ROMend
        .word   ROMend
#endif
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

-last_forth_word_nfa = WARM_nfa

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
#include "Control.asm"
#endif

; ----------------------------------------------------------------------------
;           Instructions IF/THEN/ELSE utilisable en mode direct
; ----------------------------------------------------------------------------
#ifdef WITH_PSEUDO_IF
#echo "Ajout des mots IF(, )ELSE(, )ENDIF"
; ----------------------------------------------------------------------------
; IF(_nfa
IFP_nfa:
        .byte   $C3
        .byte   "IF"
        .byte   $A8
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = PENDIF_nfa
#endif

; ----------------------------------------------------------------------------
;                    Gestion chargement d'un écran
; ----------------------------------------------------------------------------
#ifdef NEED_QLOADING
#echo "Ajout du mot ?LOADING"
; ----------------------------------------------------------------------------
; ?LOADING_nfa
QLOADING_nfa:
        .byte   $88
        .byte   "?LOADIN"
        .byte   $C7
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = QLOADING_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_BACKSLASH
#ifndef WITH_BACKSLASH_IMMEDIATE
backslash_nfa:
#echo "Ajout du mot \\"
        .byte   $81,$DC
#else
backslash_nfa:
#echo "Ajout du mot \\ (IMMEDIATE)"
        .byte   $C1,$DC
#endif
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = backslash_nfa
#endif

#ifdef WITH_FOLLOW
#echo "Ajout du mot -->"
; ----------------------------------------------------------------------------
; -->_nfa
FOLLOW_nfa:
        .byte   $C3
        .byte   "--"
        .byte   $BE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = FOLLOW_nfa
#endif

#ifdef NEED_LOAD
#echo "Ajout du mot LOAD"
; ----------------------------------------------------------------------------
LOAD_nfa:
        .byte   $84
        .byte   "LOA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = LOAD_nfa
#endif

#ifdef WITH_THRU
#echo "Ajout du mot THRU"
; ----------------------------------------------------------------------------
THRU_nfa:
        .byte   $84
        .byte   "THR"
        .byte   $D5
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = THRU_nfa
#endif

; ----------------------------------------------------------------------------
; LOAD-USING_nfa
#ifdef WITH_STRATSED
LOAD_USING_nfa:
        .byte   $8A
        .byte   "LOAD-USIN"

        .byte   $C7
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = THRU_USING_nfa

#endif

; ----------------------------------------------------------------------------
; Utilisé par LIST, TRIAD, INDEX, VLIST
; ----------------------------------------------------------------------------
#ifdef NEED_QTERMSTOP
#echo "Ajout du mot ?TERMSTOP"
; ?TERMSTOP_nfa
QTERMSTOP_nfa:
        .byte   $89
        .byte   "?TERMSTO"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = QTERMSTOP_nfa
#endif

; ----------------------------------------------------------------------------
;                    Gestion affichage d'un écran
; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
#ifdef NEED_CSLL
#echo "Ajout du mot C/L"
; ----------------------------------------------------------------------------
; C/L_nfa
CSLL_nfa:
        .byte   $83
        .byte   "C/"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
; C/L
CSLL:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0040

-last_forth_word_nfa = CSLL_nfa
#endif


#ifdef WITH_PLINE
#echo "Ajout des mots (LINE)"
; ----------------------------------------------------------------------------
; (LINE)_nfa
PLINE_nfa:
        .byte   $86
        .byte   "(LINE"
        .byte   $A9
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = PLINE_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_DOTLINE
#echo "Ajout des mots .LINE"
DOTLINE_nfa:
        .byte   $85
        .byte   ".LIN"
        .byte   $C5
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
DOTLINE:
        .word   DOCOL
        .word   PLINE
        .word   DTRAILING
        .word   TYPE
        .word   SEMIS

-last_forth_word_nfa = DOTLINE_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_LIST
#echo "Ajout du mot LIST"
LIST_nfa:
        .byte   $84
        .byte   "LIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = LIST_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_TRIAD
#echo "Ajout du mot TRIAD"
TRIAD_nfa:
        .byte   $85
        .byte   "TRIA"
        .byte   $C4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = TRIAD_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_INDEX
#echo "Ajout du mot INDEX"
INDEX_nfa:
        .byte   $85
        .byte   "INDE"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = INDEX_nfa
#endif

; ----------------------------------------------------------------------------
;                         Gestion du dictionnaire
; ----------------------------------------------------------------------------
#ifdef WITH_FORGET
#echo "Ajout du mot V<"
; V<_nfa
VTO_nfa:
        .byte   $82
        .byte   "V"
        .byte   $BC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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
#echo "Ajout du mot FORGET"
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

-last_forth_word_nfa = FORGET_nfa
#endif

; ----------------------------------------------------------------------------
; ID._nfa
IDDOT_nfa:
        .byte   $83
        .byte   "ID"
        .byte   $AE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = IDDOT_nfa

; ----------------------------------------------------------------------------
#ifdef WITH_VLIST
#echo "Ajout du mot VLIST"
VLIST_nfa:
        .byte   $85
        .byte   "VLIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = VLIST_nfa
#endif

; ----------------------------------------------------------------------------
; VOC-LIST_nfa
#ifdef WITH_VOC_LIST
#echo "Ajout du mot VOC-LIST"
VOC_LIST_nfa:
        .byte   $88
        .byte   "VOC-LIS"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = VOC_LIST_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_ROMend
; INIT-RAM: Copie $3c80 octets de $c37f vers $c380???
; Utilisé uniquement par ROMend
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
#endif

; ----------------------------------------------------------------------------
teleforth_signature:
#ifdef TELEFORTH_V12
        .byte   "TELE-FORTH V1.2"

        .byte   $0D,$0A
        .byte   "(c) 1989 Thierry BESTEL"
        .byte   $0D,$0A,$00
#else
        .byte   "TELE-FORTH V","VERSION_MAJ.VERSION_MIN (ch376) - __DATE__"
        .byte $00
#endif

; ----------------------------------------------------------------------------
; Utilisé par CLOCK, GRAFX, IOS_xxx, SOUNDS, STRATSED_xxx, WINDOWS
#ifdef NEED_AYX
#echo "Ajout du mot AYX"
AYX_nfa:
        .byte   $83
        .byte   "AY"
        .byte   $D8
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
AYX:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0563

-last_forth_word_nfa = AYX_nfa
#endif


; ----------------------------------------------------------------------------
#ifdef NEED_PIO
#echo "Ajout du mot PIO"
; Utilisé par INPUT, OUTPUT, TERMINAL, ?TERMSTOP, IOS_extended, Stratsed_xxx
PIO_nfa:
        .byte   $83
        .byte   "PI"
        .byte   $CF
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
PIO:
        .word   DOCON
; ----------------------------------------------------------------------------
        .word   $0566

-last_forth_word_nfa = PIO_nfa
#endif


#ifdef NEED_MON
#echo "Ajout du mot MON"
; ----------------------------------------------------------------------------
; Utilisé par CLOCK, GRAFX, IOS_xxx, SOUNDS, Stratsed_extended (FILENAME), WINDOWS
MON_nfa:
        .byte   $83
        .byte   "MO"
        .byte   $CE
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = MON_nfa
#endif

#ifdef NEED_MONCOL
#echo "Ajout du mot MON:"
; ----------------------------------------------------------------------------
; MON:_nfa -> Compile un mot d'appel à une procédure Telemon
; Utilisé par les vocabulaires IOS_extended, GRAFX, SOUNDS
MONCOL_nfa:
        .byte   $84
        .byte   "MON"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = MONCOL_nfa
#endif

#ifdef NEED_HRSCOL
#echo "Ajout mot HRS:"
; ----------------------------------------------------------------------------
; HRS:_nfa
; Utilisé uniquement par les vocabulaires GRAFX et SOUNDS
HRSCOL_nfa:
        .byte   $84
        .byte   "HRS"
        .byte   $BA
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = HRSCOL_nfa
#endif

;#ifdef NEED_HIMEM
;#echo "Ajout mot HIMEM"
; ----------------------------------------------------------------------------
; Utilisé uniquement par (ABORT) et (+OVLOAD)
HIMEM_nfa:
        .byte   $85
        .byte   "HIME"
        .byte   $CD
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = HIMEM_nfa
;#endif

; ----------------------------------------------------------------------------
; Vocabulaire SOUNDS
#ifdef WITH_SOUNDS_VOC
#include "Sounds.voc"
#endif

; ----------------------------------------------------------------------------
; Vocabulaire GRAFX
#ifdef WITH_GRAFX_VOC
#include "Grafx.voc"
#endif

; ----------------------------------------------------------------------------
; Vocabulaire WINDOWS
#ifdef WITH_WINDOWS_VOC
#include "Windows.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_CLOCK
#include "Clock.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_WAIT
#include "Wait.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_STRATSED_MINIMAL
#include "Stratsed_minimal.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_STRATSED
#include "Stratsed_extended.voc"
#endif

; ----------------------------------------------------------------------------
; Vocabulaire CH376
; ----------------------------------------------------------------------------
#ifdef WITH_CH376
#include "CH376.voc"
#endif

; ----------------------------------------------------------------------------
#ifldef STARTUP
#else
#echo "Ajout du mot STARTUP de base"
;
; /?\ A transférer dans Stratsed_extended.voc et CH376.voc
; et mettre ici : STARTUP ;
; ou definir STARTUP comme DEFER STARTUP et deinir (STARTUP) dans
; Stratsed_extended.voc et CH376.voc et faire ' (STARTUP) IS STARTUP
;
; ----------------------------------------------------------------------------
STARTUP_nfa:
        .byte   $87
        .byte   "STARTU"
        .byte   $D0
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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
;
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
;
#ifdef WITH_AUTOSTART_SUPPORT
#echo "Pas de autostart 'FORTH.DAT' possible"
#endif

LEAFF:
        .word   SEMIS

-last_forth_word_nfa = STARTUP_nfa

#endif

; ----------------------------------------------------------------------------
#ifdef WITH_OVERLAYS_SUPPORT
#include "Overlays.fth"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_EXTERNAL_HELPERS
#include "Externals.voc"
#endif

; ----------------------------------------------------------------------------
; Vocabulaire IOS (minimal)
#ifdef WITH_IOS_VOC
#include "IOS_minimal.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_INPUT
#echo "Ajout mot INPUT"
INPUT_nfa:
        .byte   $85
        .byte   "INPU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   PIO
        .word   ONEP
        .word   CSTORE
        .word   SEMIS

-last_forth_word_nfa = INPUT_nfa
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_OUTPUT
#echo "Ajout mot OUTPUT"
OUTPUT_nfa:
        .byte   $86
        .byte   "OUTPU"
        .byte   $D4
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
        .word   DOCOL
        .word   PIO
        .word   TWOP
        .word   CSTORE
        .word   SEMIS

-last_forth_word_nfa = OUTPUT_nfa
#endif

; ----------------------------------------------------------------------------
; Necessite les mots SCRW et CURSOR du vocabulaire WINDOWS
; Necessite les mots OPCH, QTERM, CKEY et CEMIT du vocabulaire IOS minimal
TERMINAL_nfa:
        .byte   $88
        .byte   "TERMINA"
        .byte   $CC
; ----------------------------------------------------------------------------
        .word   last_forth_word_nfa
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

-last_forth_word_nfa = QHIRES_nfa

; ----------------------------------------------------------------------------
#ifdef WITH_IOSext_VOC
#include "IOS_extended.voc"
#endif

; ----------------------------------------------------------------------------
; Vocabulaire EDITOR
#ifdef WITH_EDITOR_VOC
#include "Editor.voc"
#else
#ifdef WITH_WHERE
#echo "Ajout mot WHERE vectorisé"
WHERE_nfa:
        .byte   $85
        .byte   "WHER","E"+$80
        .word   last_forth_word_nfa
WHERE:
        .word   DODEFER
        .word   WHERE_defer

PWHERE_nfa:
        .byte   $87
        .byte   "(WHERE",")"+$80
        .word   WHERE_nfa
PWHERE:
        .word   DOCOL
        .word   DROP
        .word   DROP
        .word   SEMIS

-last_forth_word_nfa = PWHERE_nfa
#endif
#endif

; ----------------------------------------------------------------------------
; Vocabulaire LIFE
#ifdef WITH_LIFE_VOC
#include "Life.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_ROMend
#echo "Ajout du mot ROMend"
ROMend_nfa:
        .byte   $86
        .byte   "ROMen"
        .byte   $E4
; ----------------------------------------------------------------------------
;        .word   DEMO_nfa
        .word last_forth_word_nfa
ROMend:
        .word   INIT_RAM
        .word   SEMIS

-last_forth_word_nfa = ROMend_nfa
#endif

; ----------------------------------------------------------------------------
; Vocabulaire pour la carte Twilight
#ifdef WITH_TWILIGHTE
#include "Twilighte.fth"
#endif

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
        .word   last_forth_word_nfa

; ----------------------------------------------------------------------------
; +10 -> defer de QTERMINAL (initialisé à QTERM par TERMINAL)
QTERMINAL_defer = RAM_START-2+(*-DictInitTable)
        .word   NOOP

; ----------------------------------------------------------------------------
; +12 -> defer de KEY (initialisé à CKEY par TERMINAL)
KEY_defer = RAM_START-2+(*-DictInitTable)
        .word   NOOP

; ----------------------------------------------------------------------------
; +14 -> defer de EMIT (initialisé à CEMIT par TERMINAL)
EMIT_defer = RAM_START-2+(*-DictInitTable)
        .word   NOOP

; ----------------------------------------------------------------------------
; +16 -> Pour le vocabulaire SOUNDS
#ifdef WITH_SOUNDS_VOC
#include "Sounds.voc"
#endif

; ----------------------------------------------------------------------------
; +20 -> Pour le vocabulaire GRAFX
#ifdef WITH_GRAFX_VOC
#include "Grafx.voc"
#endif

; ----------------------------------------------------------------------------
; +24 -> Pour le vocabulaire WINDOWS
#ifdef WITH_WINDOWS_VOC
#include "Windows.voc"
#endif

; ----------------------------------------------------------------------------
; +28 -> Pour le vocabulaire IOS
#ifdef WITH_IOS_VOC
#include "IOS_minimal.voc"
;
; ----------------------------------------------------------------------------
#ifdef WITH_IOSext_VOC
#include "IOS_extended.voc"
; +32 -> defer de MINITEL
#endif
#endif

; ----------------------------------------------------------------------------
; +34 -> Pour le vocabulaire EDITOR
#ifdef WITH_EDITOR_VOC
#include "Editor.voc"
#else
#ifdef WITH_WHERE
#echo "Ajout ' (WHERE) IS WHERE"
WHERE_defer = RAM_START-2+(*-DictInitTable)
        .word PWHERE
#endif
#endif

; ----------------------------------------------------------------------------
; +38 -> Pour le vocabulaire LIFE
#ifdef WITH_LIFE_VOC
#include "Life.voc"
#endif

; ----------------------------------------------------------------------------
#ifndef COMPACT
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_CH376
#include "CH376.voc"
#endif

; ----------------------------------------------------------------------------
#ifdef WITH_TWILIGHTE
#include "Twilighte.fth"
#endif

DictInitTableEnd:


; ----------------------------------------------------------------------------
#echo Fin:
#print *
#echo Utilise:
#print * - ORIGIN
#echo Octets libres:
#print $fff8-*

#if * > $fff8
#echo "Erreur fichier trop long"
#print _err_
#endif
 .dsb $fff8-*,$00

; ----------------------------------------------------------------------------
        .word   teleforth_signature
; ----------------------------------------------------------------------------
        .byte   $12,$EF
; ----------------------------------------------------------------------------
        .word   ORIGIN
        .word   virq
