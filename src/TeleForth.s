; ----------------------------------------------------------------------------
; TeleForth.s:
; ----------------------------------------------------------------------------
;				TeleForth
; ----------------------------------------------------------------------------


.include "TeleForth.mac"

.include "TeleForth.inc"

.include "Configs.inc"

.include "build.inc"

; .define With TeleForth_V2

; ----------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------

verbose 2, .sprintf("Compilation TeleForth %d.%d",With::VERSION_MAJ, With::VERSION_MIN)

; ----------------------------------------------------------------------------
;
; ----------------------------------------------------------------------------

.ifdef With::STRATSED
	With::STRATSED_MINIMAL .set 1
.endif

;.ifdef With::AUTOSTART_SUPPORT
; Need some OS support?
;.define With::STRATSED
;.endif

.ifdef With::AUTOSTART_SUPPORT
	.if .not .strlen(AUTOSTART_FILE)
		.undef AUTOSTART_FILE
		.define AUTOSTART_FILE "FORTH.DAT"
	.endif
	verbose 2, .sprintf("Fichier AUTOSTART: %s", AUTOSTART_FILE)
.endif

.ifdef With::EXTERNAL_HELPERS
	With::OVERLAYS_SUPPORT .set 1
.endif

.ifdef With::CLOCK
	With::WINDOWS_VOC .set 1
	NEED_MON .set 1
.endif

.ifdef With::IOS_PRINTER
	With::IOSext_VOC .set 1
.endif

.ifdef With::IOS_SERIAL
	With::IOSext_VOC .set 1
.endif

.ifdef With::IOS_MINITEL
	With::IOSext_VOC .set 1
.endif

.ifdef With::IOSext_VOC
	With::IOS_VOC .set 1
.endif

.ifdef With::EDITOR_SCRMOVE_SCRCOPY
	With::EDITOR .set 1
.endif

.ifdef With::EDITOR_VOC
	With::EDITOR_TEXT_LINE .set 1
.endif

.ifdef With::LIFE_DEMO
	With::LIFE_VOC .set 1
.endif

.ifdef With::LIFE_VOC
	With::GRAFX_VOC .set 1
	With::WAIT .set 1
	With::OVERLAYS_SUPPORT .set 1
.endif

; ----------------------------------------------------------------------------
; Structures de contrôle
; ----------------------------------------------------------------------------

.ifdef With::ALL_TESTS
	With::CONTROL_FLOW .set 1

	With::IF_THEN_ELSE .set 1
	With::BEGIN_AGAIN .set 1
	With::BEGIN_UNTIL .set 1
	With::BEGIN_WHILE .set 1
	With::DO_LOOP .set 1
	With::DO_PLOOP .set 1
	With::CASE_OF_ENDCASE .set 1
.endif

.ifdef With::IF_THEN_ELSE
	With::CONTROL_FLOW .set 1
	NEED_MRKFROM .set 1
.endif

.ifdef With::BEGIN_AGAIN
	With::CONTROL_FLOW .set 1
	NEED_MRKTO .set 1
	NEED_BEGIN .set 1
	NEED_AGAIN .set 1
.endif

.ifdef With::BEGIN_UNTIL
	With::CONTROL_FLOW .set 1
	NEED_MRKTO .set 1
	NEED_BEGIN .set 1
	NEED_UNTIL .set 1
.endif

.ifdef With::BEGIN_WHILE
	With::CONTROL_FLOW .set 1
	NEED_MRKFROM .set 1
	NEED_MRKTO .set 1
	NEED_BEGIN .set 1
	NEED_WHILE .set 1
	NEED_REPEAT .set 1
.endif

.ifdef With::DO_LOOP
	With::CONTROL_FLOW .set 1
	NEED_MRKTO .set 1
	NEED_DO .set 1
	NEED_LOOP .set 1
.endif

.ifdef With::DO_PLOOP
	With::CONTROL_FLOW .set 1
	NEED_MRKTO .set 1
	NEED_DO .set 1
	NEED_PLOOP .set 1
.endif

.ifdef With::CASE_OF_ENDCASE
	With::CONTROL_FLOW .set 1
	NEED_MRKFROM .set 1
.endif


; ----------------------------------------------------------------------------
; Ajout des dépendances
; ----------------------------------------------------------------------------

NEED_ABORT .set 1


.ifdef NEED_ABORT
	NEED_PABORT .set 1
.endif

.ifdef With::CH376
	NEED_LOAD .set 1
.endif

.ifdef With::UPERCASE_FILENAME
	NEED_UPPER .set 1
.endif

.ifdef With::UPPER
	NEED_UPPER .set 1
.endif

.ifdef With::LOWER
	NEED_LOWER .set 1
.endif

.ifndef With::DictCase
	.warning "DictCase non spécifié, valeur par defaut: 0"
	With::DictCase .set 0
.endif

.if With::CaseSensitive = 0
	.if With::DictCase = 0
		.warning "CaseSentive = 0 && DictCase = 0"

	.elseif With::DictCase =1
		NEED_LOWER .set 1

	.elseif With::DictCase =2
		NEED_UPPER .set 1

	.else
		.error .sprintf("Valeur incorrecte pour DictCase: %d", With::DictCase)
	.endif
.endif

.ifdef With::STRATSED
	NEED_LOAD .set 1
.endif

.ifdef With::CSLL
	NEED_CSLL .set 1
.endif

.ifdef With::QLOADING
	NEED_QLOADING .set 1
.endif

.ifdef With::LOAD
	NEED_LOAD .set 1
.endif


.ifndef With::EDITOR_VOC
	;.undef With::INDEX
	;.undef With::TRIAD
	.ifdef With::EDITOR_SCRMOVE_SCRCOPY
		.undef With::EDITOR_SCRMOVE_SCRCOPY
	.endif
	.ifdef With::EDITOR_TEXT_LINE
		.undef With::EDITOR_TEXT_LINE
	.endif
.endif

.ifdef With::EDITOR_VOC
	NEED_CSLL .set 1
	With::PLINE .set 1
	With::LIST .set 1
	With::DOTLINE .set 1
	With::WHERE .set 1
.endif

.ifdef With::FOLLOW
	NEED_QLOADING .set 1
.endif

.ifdef With::BACKSLASH_IMMEDIATE
	With::BACKSLASH .set 1
.endif

.ifdef With::BACKSLASH
	NEED_QLOADING .set 1
	NEED_CSLL .set 1
.endif

.ifdef With::INDEX
	With::DOTLINE .set 1
	NEED_QTERMSTOP .set 1
.endif

.ifdef With::TRIAD
	With::LIST .set 1
	NEED_QTERMSTOP .set 1
.endif

.ifdef With::LIST
	With::DOTLINE .set 1
	NEED_QTERMSTOP .set 1
.endif

.ifdef With::VLIST
	NEED_QTERMSTOP .set 1
.endif

.ifdef With::DOTLINE
	With::PLINE .set 1
.endif

.ifdef With::PLINE
	NEED_CSLL .set 1
.endif

.ifdef With::CLOCK
	NEED_AYX .set 1
.endif

.ifdef With::GRAFX_VOC
	NEED_AYX .set 1
.endif

.ifdef With::IOS_VOC
	NEED_AYX .set 1
.endif

.ifdef With::SOUNDS_VOC
	NEED_AYX .set 1
.endif

.ifdef With::STRATSED
	NEED_AYX .set 1
.endif

.ifdef With::WINDOWS_VOC
	NEED_AYX .set 1
.endif


.ifdef With::INPUT
	NEED_PIO .set 1
.endif

.ifdef With::OUTPUT
	NEED_PIO .set 1
.endif

.ifdef NEED_PABORT
	NEED_PIO .set 1
.endif

.ifdef NEED_QTERMSTOP
	NEED_PIO .set 1
.endif


.ifdef With::GRAFX_VOC
	NEED_MON .set 1
.endif

.ifdef With::IOS_VOC
	NEED_MON .set 1
.endif

.ifdef With::SOUNDS_VOC
	NEED_MON .set 1
.endif

.ifdef With::STRATSED
	NEED_MON .set 1
	NEED_PIO .set 1
.endif

.ifdef With::WINDOWS_VOC
	NEED_MON .set 1
.endif


.ifdef With::IOSExt_VOC
	NEED_MONCOL .set 1
	NEED_PIO .set 1
.endif

.ifdef With::GRAFX_VOC
	NEED_MONCOL .set 1
.endif

.ifdef With::SOUNDS_VOC
	NEED_MONCOL .set 1
.endif


.ifdef With::GRAFX_VOC
	NEED_HRSCOL .set 1
.endif

.ifdef With::SOUNDS_VOC
	NEED_HRSCOL .set 1
.endif

.ifdef With::OVERLAYS_SUPPORT
	NEED_HIMEM .set 1
.endif


; ----------------------------------------------------------------------------
; Adresses RAM
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
vasalo0         = With::Page05_Base +$28       ; Flag lecture/écriture
ftype           = With::Page05_Base +$2C       ; Type du fichier
desalo          = With::Page05_Base +$2D       ; Adresse de début du fichier à écrire
fisalo          = With::Page05_Base +$2F       ; Adresse de fin du fichier à écrire
tampfc          = With::Page05_Base +$42       ; Adresse de début des tampons fichier (initialisé à DOSBUFFERS par STARTUP)
bitmfc          = With::Page05_Base +$44       ; (word) BitMap des tampons logiques (même convention que la BitMap disquette, 0->occupé, 1->libre))
ficnum          = With::Page05_Base +$48       ; Numéro logique du fichier (1 ou 2)
nbfic           = With::Page05_Base +$49       ; Nombre de fichiers autorisés par FILE (2)
xfield          = With::Page05_Base +$4C       ; Pour fichier accès direct: xfield=n° de banque, xfield+1=adresse

CallTel         = $0560                        ; Routine d'appel d'une fonction Telemon. Initialisé à: 00 00 60 00 par (ABORT)
AYX_addr        = $0563                        ; Utilisé pour le passage des registres A,X,Y pour les appels MON
PIO_addr        = $0566                        ; Utilisé pour le passage du registre P pour les appels MON

_UAREA_         = $0800                        ; User Area (ex. CURRENT := $0822)
DOSBUFFERS      = $0840                        ; Tampons DOS pour 2 fichiers (taille: $0300+$0260*nbfic -> $07C0)
_FIRST          = $1000                        ; Tampon pour 1 écran (FIRST) de $0400 octets + octets de contrôles -- $1000 := DOSBUFFERS+$0300+$0260*2
RAM_START       = _FIRST+2+$0400+2             ; Zone pour le dictionnaire (LIMIT) - 1er mot utilisateur à partir de $143C := $1000+$0404 + $38 (longueur du dictionnaire en RAM)
SCRTXT          = $BB80                        ; Adresse de base de l'écran TEXT



; ----------------------------------------------------------------------------
; TeleForth
; ----------------------------------------------------------------------------
	.setcpu "6502"
	.org $c000

; ----------------------------------------------------------------------------
; ORIGIN
; Cold start
; ----------------------------------------------------------------------------
ORIGIN:
        nop
        jmp     PCOLD1

; ----------------------------------------------------------------------------
; Warm start
; ----------------------------------------------------------------------------
        nop
        jmp     WARM1

        .word   $0201,$0E01

; ----------------------------------------------------------------------------
; NTOP
; adresse mot le plus récent: ROMend_nfa
; ----------------------------------------------------------------------------
NTOP:
        .word   last_forth_word_nfa

; ----------------------------------------------------------------------------
; BSCH
; ----------------------------------------------------------------------------
BSCH:
        .word   $007F

; ----------------------------------------------------------------------------
; UAREA
; ----------------------------------------------------------------------------
UAREA:
        .word   $0800
; ----------------------------------------------------------------------------
; (S0)
; ----------------------------------------------------------------------------
PS0:
        .word   $00BE
; ----------------------------------------------------------------------------
; (R0)
; ----------------------------------------------------------------------------
PR0:
        .word   $01FF

; ----------------------------------------------------------------------------
; (TIB)
; ----------------------------------------------------------------------------
PTIB:
        .word   $0100

; ----------------------------------------------------------------------------
; (WIDTH)
; ----------------------------------------------------------------------------
PWIDTH:
        .word   $001F

; ----------------------------------------------------------------------------
; (WARNING)
; ----------------------------------------------------------------------------
PWARNING:
        .word   $0001

; ----------------------------------------------------------------------------
; (FENCE)
; ----------------------------------------------------------------------------
PFENCE:
        .word   RAM_START-2+(DictInitTableEnd-DictInitTable); C01C 3C 14

; ----------------------------------------------------------------------------
; (DP)
; ----------------------------------------------------------------------------
PDP:
        .word   RAM_START-2+(DictInitTableEnd-DictInitTable); C01E 3C 14

; ----------------------------------------------------------------------------
; (VOC-LINK)
; adresse VOC-LINK du vocabulaire le plus récent: LIFE-LINK
; ----------------------------------------------------------------------------
PVOCLINK:
        .word   last_voc_link2

; ----------------------------------------------------------------------------
; SYSTEM
; ----------------------------------------------------------------------------
SYSTEM:
        .word   $0004,$5ED2

; ----------------------------------------------------------------------------
; (COLD)
; ----------------------------------------------------------------------------
PCOLD:
        .word   COLD

PCOLD1:
        lda     #$6C
        sta     W-1
        lda     UAREA
        sta     UP
        lda     UAREA+1
        sta     UP+1
        ldx     PR0
        txs
        ldx     PS0
        lda     #>PCOLD
        sta     IP+1
        lda     #<PCOLD
        sta     IP
        jmp     NEXT

; ----------------------------------------------------------------------------
; (WARM)
; ----------------------------------------------------------------------------
PWARM:
        .word   WARM

WARM1:
        lda     #>PWARM
        sta     IP+1
        lda     #<PWARM
        sta     IP
        jmp     RPSTORE_pfa

; ----------------------------------------------------------------------------
; NOOP
; ----------------------------------------------------------------------------
code "NOOP"
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
; EXECUTE
; ----------------------------------------------------------------------------
code "EXECUTE"
LC083:
        lda     BOT,x
        sta     W
        lda     BOT+1,x
        sta     W+1
        inx
        inx
        jmp     W-1

; ----------------------------------------------------------------------------
; LIT
; ----------------------------------------------------------------------------
code "LIT"
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
; SETUP
; Transfère ACC mots de la pile vers N
; ----------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------
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
; ----------------------------------------------------------------------------
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
; BRANCH
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
; (+LOOP)
; ----------------------------------------------------------------------------
declare "(+LOOP)","PPLOOP"
        .word   PPLOOP_pfa

; ----------------------------------------------------------------------------
; (LOOP)
; ----------------------------------------------------------------------------
declare "(LOOP)","PLOOP"
        .word   PLOOP_pfa

; ----------------------------------------------------------------------------
; 0BRANCH
; ----------------------------------------------------------------------------
declare "0BRANCH","ZBRANCH"
        .word   ZBRANCH_pfa

; ----------------------------------------------------------------------------
; BRANCH
; ----------------------------------------------------------------------------
declare "BRANCH"
        .word   BRANCH_pfa

; ----------------------------------------------------------------------------
; (OF)
; ----------------------------------------------------------------------------
declare "(OF)","POF"
        .word   POF_pfa

; ----------------------------------------------------------------------------
; (OF")
; ----------------------------------------------------------------------------
declare '(OF")',"POFQUOT"
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
; ?LEAVE
; ----------------------------------------------------------------------------
code "?LEAVE","ZLEAVE"
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
; LEAVE
; ----------------------------------------------------------------------------
declare "LEAVE"
        .word   LEAVE_pfa

; ----------------------------------------------------------------------------
; (DO)
; ----------------------------------------------------------------------------
code "(DO)","PDO"
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
; I
; ----------------------------------------------------------------------------
code "I"
LC20F:
        stx     _XSAVE
        tsx
        lda     _TIB_+1,x
        pha
        lda     _TIB_+2,x
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
; R
; ----------------------------------------------------------------------------
declare "R"
      .word   LC20F

; ----------------------------------------------------------------------------
; J
; ----------------------------------------------------------------------------
code "J"
LC22A:
        stx     _XSAVE
        tsx
        lda     _TIB_+5,x
        pha
        lda     _TIB_+6,x
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
; DIGIT
; ----------------------------------------------------------------------------
code "DIGIT"
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

LC262:
        tya
        pha
        inx
        inx
        jmp     PUT

; ----------------------------------------------------------------------------
; (FIND)
; ----------------------------------------------------------------------------
code "(FIND)","PFIND"
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
; S=
; ----------------------------------------------------------------------------
code "S=","SEQUAL"
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

LC2EE:
        lda     #$00
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
; ENCLOSE
; ----------------------------------------------------------------------------
code "ENCLOSE"
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
; CMOVE
; ----------------------------------------------------------------------------
code "CMOVE"
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

LC368:
        sta     (N+2),y
        iny
        bne     LC35B
        inc     N+5
        inc     N+3
        jmp     LC35B

; ----------------------------------------------------------------------------
; CMOVE>
; ----------------------------------------------------------------------------
code "CMOVE>","CMOVEFROM"
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
; U*
; ----------------------------------------------------------------------------
; BUG: HEX 16A1 16A1 U* D. -> 01001141 au lieu de 02001141
; Correction du bug: http://forum.6502.org/viewtopic.php?f=9&t=689&start=30#p34890
; ----------------------------------------------------------------------------
code "U*","USTAR"
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
.ifdef With::WITHOUT_FIGFORTH_BUG
        bne     LC3E1
        inc     BOT+1,x
.endif
LC3E1:
        dey
        bne     LC3C6
        jmp     NEXT

; ----------------------------------------------------------------------------
; U/
; ----------------------------------------------------------------------------
; BUG: HEX 80000000. 8001 U/ U. U. -> 0 0 au lieu de FFFE 0002
; Correction du bug: http://6502org.wikidot.com/errata-software-figforth
; ----------------------------------------------------------------------------
code "U/","USL"
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
.ifdef With::WITHOUT_FIGFORTH_BUG
        bcs     L0446
.endif
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

.ifdef With::WITHOUT_FIGFORTH_BUG
L0446:
        sbc     BOT,x
        sta     $04  ,x
        lda     $05  ,x
        sbc     BOT+1,x
        sec
        bcs     L0442
.endif

; ----------------------------------------------------------------------------
; AND
; ----------------------------------------------------------------------------
code "AND","ANDforth"
LC42B:
        lda     BOT,x
        and     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        and     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; OR
; ----------------------------------------------------------------------------
code "OR"
LC441:
        lda     BOT,x
        ora     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        ora     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; XOR
; ----------------------------------------------------------------------------
code "XOR"
LC458:
        lda     BOT,x
        eor     SECOND,x
        sta     SECOND,x
        lda     BOT+1,x
        eor     SECOND+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
;NOT:
; ----------------------------------------------------------------------------
code "NOT"
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
; ;S
; ----------------------------------------------------------------------------
code ";S","SEMIS"
LC484:
        pla
        sta     IP
        pla
        sta     IP+1
        jmp     NEXT

; ----------------------------------------------------------------------------
; SP@
; ----------------------------------------------------------------------------
code "SP@","SPat"
LC495:
        txa
PUSH0A:
        pha
        lda     #$00
        jmp     PUSH

; ----------------------------------------------------------------------------
; SP!
; ----------------------------------------------------------------------------
code "SP!","SPstore"
LC4A4:
        ldy     #$06
        lda     (UP),y
        tax
        jmp     NEXT

; ----------------------------------------------------------------------------
; RP!
; ----------------------------------------------------------------------------
code "RP!","RPSTORE"
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
; RP@
; ----------------------------------------------------------------------------
code "RP@","RPAT"
LC4CC:
        stx     _XSAVE
        tsx
        txa
        pha
        lda     #$01
        ldx     _XSAVE
        jmp     PUSH

; ----------------------------------------------------------------------------
; 2*
; ----------------------------------------------------------------------------
code "2*","TWOSTAR"
; ----------------------------------------------------------------------------
LC4DF:
        asl     BOT,x
        rol     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2/
; ----------------------------------------------------------------------------
code "2/","TWOSL"
LC4ED:
        lda     BOT+1,x
        asl
        ror     BOT+1,x
        ror     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2**
; ----------------------------------------------------------------------------
code "2**","TWOPOWER"
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
; 1+
; ----------------------------------------------------------------------------
code "1+","ONEP"
LC52B:
        inc     BOT,x
        bne     LC531
        inc     BOT+1,x
LC531:
        jmp     NEXT

; ----------------------------------------------------------------------------
; 1-
; ----------------------------------------------------------------------------
code "1-","ONES"
LC53B:
        lda     BOT,x
        bne     LC541
        dec     BOT+1,x
LC541:
        dec     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 2+
; ----------------------------------------------------------------------------
declare "2+","TWOP"
        .word   DOCOL
        .word   ONEP
        .word   ONEP
        .word   SEMIS

; ----------------------------------------------------------------------------
; 2-
; ----------------------------------------------------------------------------
declare "2-","TWOS"
        .word   DOCOL
        .word   ONES
        .word   ONES
        .word   SEMIS

; ----------------------------------------------------------------------------
; >R
; ----------------------------------------------------------------------------
code ">R","TOR"
LC567:
        lda     BOT+1,x
        pha
        lda     BOT,x
        pha
        inx
        inx
        jmp     NEXT

; ----------------------------------------------------------------------------
; R>
; ----------------------------------------------------------------------------
code "R>","RFROM"
LC579:
        dex
        dex
        pla
        sta     BOT,x
        pla
        sta     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; DUP>R
; ----------------------------------------------------------------------------
code "DUP>R","DUPTOR"
LC58E:
        lda     BOT+1,x
        pha
        lda     BOT,x
        pha
        jmp     NEXT

; ----------------------------------------------------------------------------
; R>DROP
; ----------------------------------------------------------------------------
code "R>DROP","RFROMDROP"
LC5A2:
        pla
        pla
        jmp     NEXT

; ----------------------------------------------------------------------------
; 0=
; ----------------------------------------------------------------------------
code "0=","ZEQUAL"
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
; 0<
; ----------------------------------------------------------------------------
code "0<","ZLESS"
LC5C3:
        asl     BOT+1,x
        sty     BOT+1,x
        tya
        rol
        sta     BOT,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; 0>
; ----------------------------------------------------------------------------
code "0>","ZGREAT"
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
; =
; ----------------------------------------------------------------------------
declare "=","EQUAL"
        .word   DOCOL
        .word   SUB
        .word   ZEQUAL
        .word   SEMIS

; ----------------------------------------------------------------------------
; <
; ----------------------------------------------------------------------------
declare "<","LESS"
        .word   DOCOL
        .word   SUB
        .word   ZLESS
        .word   SEMIS

; ----------------------------------------------------------------------------
; >
; ----------------------------------------------------------------------------
declare ">","GREAT"
        .word   DOCOL
        .word   SUB
        .word   ZGREAT
        .word   SEMIS

; ----------------------------------------------------------------------------
; -
; ----------------------------------------------------------------------------
code "-","SUB"
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
; +
; ----------------------------------------------------------------------------
code "+","PLUS"
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
; D+
; ----------------------------------------------------------------------------
code "D+","DPLUS"
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
; MINUS
; ----------------------------------------------------------------------------
code "MINUS"
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
; DMINUS
; ----------------------------------------------------------------------------
code "DMINUS"
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
; DROP
; ----------------------------------------------------------------------------
declare "DROP"
        .word   POP

; ----------------------------------------------------------------------------
; NIP
; ----------------------------------------------------------------------------
code "NIP"
LC69D:
        lda     BOT,x
        sta     SECOND,x
        lda     BOT+1,x
        sta     SECOND+1,x
        jmp     POP

; ----------------------------------------------------------------------------
; 2DROP
; ----------------------------------------------------------------------------
declare "2DROP","TWODROP"
        .word   POPTWO

; ----------------------------------------------------------------------------
; S->D
; ----------------------------------------------------------------------------
code "S->D","STOD"
LC6BB:
        lda     BOT+1,x
        bpl     LC6C0
        dey
LC6C0:
        tya
        pha
        jmp     PUSH

; ----------------------------------------------------------------------------
; -DUP
; ----------------------------------------------------------------------------
code "-DUP","DDUP"
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
; DUP
; ----------------------------------------------------------------------------
declare "DUP"
        .word   LC6D4

; ----------------------------------------------------------------------------
; OVER
; ----------------------------------------------------------------------------
code "OVER"
LC6F2:
        lda     SECOND,x
        pha
        lda     SECOND+1,x
        jmp     PUSH

; ----------------------------------------------------------------------------
; 2DUP
; ----------------------------------------------------------------------------
code "2DUP","TWODUP"
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
; PICK
; ----------------------------------------------------------------------------
code "PICK"
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
; SWAP
; ----------------------------------------------------------------------------
code "SWAP"
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
; ROT
; ----------------------------------------------------------------------------
code "ROT"
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
; 2SWAP
; ----------------------------------------------------------------------------
declare "2SWAP","TWOSWAP"
        .word   DOCOL
        .word   ROT
        .word   TOR
        .word   ROT
        .word   RFROM
        .word   SEMIS
; ----------------------------------------------------------------------------
; ROLL
; ----------------------------------------------------------------------------
declare "ROLL"
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
; +!
; ----------------------------------------------------------------------------
code "+!","PSTORE"
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
; TOGGLE
; ----------------------------------------------------------------------------
code "TOGGLE"
LC7C2:
        lda     BOT,x
        eor     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; CSET
; ----------------------------------------------------------------------------
code "CSET"
LC7D4:
        lda     BOT,x
        ora     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; CRST
; ----------------------------------------------------------------------------
code "CRST"
LC7E6:
        lda     BOT,x
        eor     #$FF
        and     (SECOND,x)
        sta     (SECOND,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; CTST
; ----------------------------------------------------------------------------
code "CTST"
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
; C!
; ----------------------------------------------------------------------------
code "C!","CSTORE"
LC80F:
        lda     SECOND,x
        sta     (BOT,x)
        jmp     POPTWO

; ----------------------------------------------------------------------------
; C@
; ----------------------------------------------------------------------------
code "C@","CAT"
LC81D:
        lda     (BOT,x)
        sta     BOT,x
        sty     BOT+1,x
        jmp     NEXT

; ----------------------------------------------------------------------------
; COUNT
; ----------------------------------------------------------------------------
code "COUNT"
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
; !
; ----------------------------------------------------------------------------
code "!","STORE"
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
; @
; ----------------------------------------------------------------------------
code "@","AT"
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
; WCOUNT
; ----------------------------------------------------------------------------
code "WCOUNT"
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
; 2@
; ----------------------------------------------------------------------------
declare "2@","TWOAT"
        .word   DOCOL
        .word   DUPTOR
        .word   TWOP
        .word   AT
        .word   RFROM
        .word   AT
        .word   SEMIS

; ----------------------------------------------------------------------------
; 2!
; ----------------------------------------------------------------------------
declare "2!","TWOSTORE"
        .word   DOCOL
        .word   DUPTOR
        .word   STORE
        .word   RFROM
        .word   TWOP
        .word   STORE
        .word   SEMIS
; ----------------------------------------------------------------------------
; :
; ----------------------------------------------------------------------------
declare ":","COLON", immediate
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
; CONSTANT
; ----------------------------------------------------------------------------
declare "CONSTANT"
        .word   DOCOL
        .word   CREATE
        .word   SMUDGE
        .word   COMMA
        .word   PSEMICODE

DOCON:
        ldy     #$02
        lda     (W),y
        pha
        iny
        lda     (W),y
        jmp     PUSH

; ----------------------------------------------------------------------------
; 0
; ----------------------------------------------------------------------------
constant "0","ZERO", 0

; ----------------------------------------------------------------------------
; 1
; ----------------------------------------------------------------------------
constant "1","ONE", 1

; ----------------------------------------------------------------------------
; 2
; ----------------------------------------------------------------------------
constant "2","TWO", 2

; ----------------------------------------------------------------------------
; BL
; ----------------------------------------------------------------------------
constant "BL",, ' '

; ----------------------------------------------------------------------------
; VARIABLE
; ----------------------------------------------------------------------------
declare "VARIABLE"
        .word   DOCOL
        .word   CREATE
        .word   SMUDGE
        .word   HERE
        .word   TWOP
        .word   COMMA
        .word   COMMA
        .word   PSEMICODE

DOVAR:
        ldy     #$02
        lda     (W),y
        pha
        iny
        lda     (W),y
        jmp     PUSH

; ----------------------------------------------------------------------------
; USER
; ----------------------------------------------------------------------------
declare "USER"
        .word   DOCOL
        .word   CONSTANT
        .word   PSEMICODE

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
; DOES>
; ----------------------------------------------------------------------------
declare "DOES>","DOES"
        .word   DOCOL
        .word   RFROM
        .word   LATEST
        .word   PFA
        .word   STORE
        .word   PSEMICODE

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
; S0
; ----------------------------------------------------------------------------
user "S0",, $0006

; ----------------------------------------------------------------------------
; R0
; ----------------------------------------------------------------------------
user "R0",, $0008

; ----------------------------------------------------------------------------
; TIB
; ----------------------------------------------------------------------------
user "TIB",, $000A

; ----------------------------------------------------------------------------
; WIDTH
; ----------------------------------------------------------------------------
user "WIDTH",, $000C

; ----------------------------------------------------------------------------
; WARNING
; ----------------------------------------------------------------------------
user "WARNING",, $000E

; ----------------------------------------------------------------------------
; FENCE
; ----------------------------------------------------------------------------
user "FENCE",, $0010

; ----------------------------------------------------------------------------
; DP
; ----------------------------------------------------------------------------
user "DP",, $0012

; ----------------------------------------------------------------------------
; VOC-LINK
; ----------------------------------------------------------------------------
user "VOC-LINK","VOCLINK", $0014

; ----------------------------------------------------------------------------
; BLK
; ----------------------------------------------------------------------------
user "BLK",, $0016

; ----------------------------------------------------------------------------
; IN
; ----------------------------------------------------------------------------
user "IN",, $0018

; ----------------------------------------------------------------------------
; OUT
; /!\ LCA07 est utilisé par CEMIT de IOS_minimal
; TODO: Modifier CEMIT
; ----------------------------------------------------------------------------
user "OUT",, $001A
LCA07 := *-2

; ----------------------------------------------------------------------------
; SCR
; ----------------------------------------------------------------------------
user "SCR",, $001C

; ----------------------------------------------------------------------------
; CONTEXT
; ----------------------------------------------------------------------------
user "CONTEXT",, $0020

; ----------------------------------------------------------------------------
; CURRENT
; ----------------------------------------------------------------------------
user "CURRENT",, $0022

; ----------------------------------------------------------------------------
; STATE
; ----------------------------------------------------------------------------
user "STATE",, $0024

; ----------------------------------------------------------------------------
; BASE
; ----------------------------------------------------------------------------
user "BASE",, $0026

; ----------------------------------------------------------------------------
; DPL
; ----------------------------------------------------------------------------
user "DPL",, $0028

; ----------------------------------------------------------------------------
; CSP
; ----------------------------------------------------------------------------
user "CSP",, $002C

; ----------------------------------------------------------------------------
; R#
; ----------------------------------------------------------------------------
user "R#","RNUM", $002E

; ----------------------------------------------------------------------------
; HLD
; ----------------------------------------------------------------------------
user "HLD",, $0030

; ----------------------------------------------------------------------------
; +ORIGIN
; ----------------------------------------------------------------------------
declare "+ORIGIN","PORIGIN"
        .word   DOCOL
        .word   LIT
        .word   ORIGIN
        .word   PLUS
        .word   SEMIS

; ----------------------------------------------------------------------------
; HERE
; ----------------------------------------------------------------------------
declare "HERE"
        .word   DOCOL
        .word   DP
        .word   AT
        .word   SEMIS
; ----------------------------------------------------------------------------
; ALLOT
; ----------------------------------------------------------------------------
declare "ALLOT"
        .word   DOCOL
        .word   DP
        .word   PSTORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; C,
; ----------------------------------------------------------------------------
declare "C,","CCOMMA"
        .word   DOCOL
        .word   HERE
        .word   CSTORE
        .word   ONE
        .word   ALLOT
        .word   SEMIS

; ----------------------------------------------------------------------------
; ,
; ----------------------------------------------------------------------------
declare ",","COMMA"
        .word   DOCOL
        .word   HERE
        .word   STORE
        .word   TWO
        .word   ALLOT
        .word   SEMIS

; ----------------------------------------------------------------------------
; LATEST
; ----------------------------------------------------------------------------
declare "LATEST"
        .word   DOCOL
        .word   CURRENT
        .word   AT
        .word   AT
        .word   SEMIS

; ----------------------------------------------------------------------------
; DEFINITIONS
; ----------------------------------------------------------------------------
declare "DEFINITIONS"
        .word   DOCOL
        .word   CONTEXT
        .word   AT
        .word   CURRENT
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; IMMEDIATE
; ----------------------------------------------------------------------------
declare "IMMEDIATE"
        .word   DOCOL
        .word   LATEST
        .word   LIT
        .word   $40
        .word   TOGGLE
        .word   SEMIS

; ----------------------------------------------------------------------------
; SMUDGE
; ----------------------------------------------------------------------------
declare "SMUDGE"
        .word   DOCOL
        .word   LATEST
        .word   LIT
        .word   $20
        .word   TOGGLE
        .word   SEMIS

; ----------------------------------------------------------------------------
; TRAVERSE
; ----------------------------------------------------------------------------
declare "TRAVERSE"
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
; PFA
; ----------------------------------------------------------------------------
declare "PFA"
        .word   DOCOL
        .word   ONE
        .word   TRAVERSE
        .word   LIT
        .word   $05
        .word   PLUS
        .word   SEMIS

; ----------------------------------------------------------------------------
; NFA
; ----------------------------------------------------------------------------
declare "NFA"
        .word   DOCOL
        .word   LIT
        .word   $05
        .word   SUB
        .word   LIT
        .word   $FFFF
        .word   TRAVERSE
        .word   SEMIS

; ----------------------------------------------------------------------------
; CFA
; ----------------------------------------------------------------------------
declare "CFA"
        .word   DOCOL
        .word   TWOS
        .word   SEMIS

; ----------------------------------------------------------------------------
; LFA
; ----------------------------------------------------------------------------
declare "LFA"
        .word   DOCOL
        .word   TWOS
        .word   TWOS
        .word   SEMIS

; ----------------------------------------------------------------------------
; <BUILDS
; ----------------------------------------------------------------------------
declare "<BUILDS","BUILDS"
        .word   DOCOL
        .word   ZERO
        .word   CONSTANT
        .word   SEMIS

; ----------------------------------------------------------------------------
; (;CODE)
; ----------------------------------------------------------------------------
declare "(;CODE)", "PSEMICODE"
        .word   DOCOL
        .word   RFROM
        .word   LATEST
        .word   PFA
        .word   CFA
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; RECURSE
; ----------------------------------------------------------------------------
declare "RECURSE",, immediate
        .word   DOCOL
        .word   QCOMP
        .word   LATEST
        .word   PFA
        .word   CFA
        .word   COMMA
        .word   SEMIS

; ----------------------------------------------------------------------------
; SPACE
; ----------------------------------------------------------------------------
declare "SPACE"
        .word   DOCOL
        .word   BL
        .word   EMIT
        .word   SEMIS

; ----------------------------------------------------------------------------
; SPACES
; ----------------------------------------------------------------------------
declare "SPACES"
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
; TYPE
; ----------------------------------------------------------------------------
declare "TYPE"
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
; MOVE
; ----------------------------------------------------------------------------
declare "MOVE"
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
; FILL
; ----------------------------------------------------------------------------
declare "FILL"
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
; ERASE
; ----------------------------------------------------------------------------
declare "ERASE"
        .word   DOCOL
        .word   ZERO
        .word   FILL
        .word   SEMIS

; ----------------------------------------------------------------------------
; BLANKS
; ----------------------------------------------------------------------------
declare "BLANKS"
        .word   DOCOL
        .word   BL
        .word   FILL
        .word   SEMIS

; ----------------------------------------------------------------------------
; -TRALING
; ----------------------------------------------------------------------------
declare "-TRAILING", "DTRAILING"
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
; DEPTH
; ----------------------------------------------------------------------------
declare "DEPTH"
        .word   DOCOL
        .word   SPat
        .word   S0
        .word   AT
        .word   SWAP
        .word   SUB
        .word   TWOSL
        .word   SEMIS

; ----------------------------------------------------------------------------
; D+-
; ----------------------------------------------------------------------------
declare "D+-", "DPM"
        .word   DOCOL
        .word   ZLESS
        .word   ZBRANCH
        .word   LCCDF
        .word   DMINUS
LCCDF:
        .word   SEMIS

; ----------------------------------------------------------------------------
; DABS
; ----------------------------------------------------------------------------
declare "DABS"
        .word   DOCOL
        .word   DUP
        .word   DPM
        .word   SEMIS

; ----------------------------------------------------------------------------
; +-
; ----------------------------------------------------------------------------
declare "+-", "PM"
        .word   DOCOL
        .word   ZLESS
        .word   ZBRANCH
        .word   LCCFF
        .word   MINUS
LCCFF:
        .word   SEMIS

; ----------------------------------------------------------------------------
; ABS
; ----------------------------------------------------------------------------
declare "ABS"
        .word   DOCOL
        .word   DUP
        .word   PM
        .word   SEMIS

; ----------------------------------------------------------------------------
; MAX
; ----------------------------------------------------------------------------
declare "MAX"
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
; MIN
; ----------------------------------------------------------------------------
declare "MIN"
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
; U<
; ----------------------------------------------------------------------------
declare "U<", "ULESS"
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
; M/MOD
; ----------------------------------------------------------------------------
declare "M/MOD", "MSLMOD"
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
; M/
; ----------------------------------------------------------------------------
declare "M/", "MSL"
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
; /MOD
; ----------------------------------------------------------------------------
declare "/MOD", "SLMOD"
        .word   DOCOL
        .word   TOR
        .word   STOD
        .word   RFROM
        .word   MSL
        .word   SEMIS

; ----------------------------------------------------------------------------
; /
; ----------------------------------------------------------------------------
declare "/", "SLASH"
        .word   DOCOL
        .word   SLMOD
        .word   NIP
        .word   SEMIS

; ----------------------------------------------------------------------------
; MOD
; ----------------------------------------------------------------------------
declare "MOD"
        .word   DOCOL
        .word   SLMOD
        .word   DROP
        .word   SEMIS

; ----------------------------------------------------------------------------
; M*
; ----------------------------------------------------------------------------
declare "M*", "MSTAR"
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
; *
; ----------------------------------------------------------------------------
declare "*", "STAR"
        .word   DOCOL
        .word   MSTAR
        .word   DROP
        .word   SEMIS

; ----------------------------------------------------------------------------
; */MOD
; ----------------------------------------------------------------------------
declare "*/MOD", "STARSLMOD"
        .word   DOCOL
        .word   TOR
        .word   MSTAR
        .word   RFROM
        .word   MSL
        .word   SEMIS

; ----------------------------------------------------------------------------
; */
; ----------------------------------------------------------------------------
declare "*/", "STARSL"
        .word   DOCOL
        .word   STARSLMOD
        .word   NIP
        .word   SEMIS

; ----------------------------------------------------------------------------
; DECIMAL
; ----------------------------------------------------------------------------
declare "DECIMAL"
        .word   DOCOL
        .word   LIT
        .word   $0A
        .word   BASE
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; HEX
; ----------------------------------------------------------------------------
declare "HEX"
        .word   DOCOL
        .word   LIT
        .word   $10
        .word   BASE
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; BIN
; ----------------------------------------------------------------------------
declare "BIN"
        .word   DOCOL
        .word   TWO
        .word   BASE
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; PAD
; ----------------------------------------------------------------------------
declare "PAD"
        .word   DOCOL
        .word   HERE
        .word   LIT
        .word   $44
        .word   PLUS
        .word   SEMIS

; ----------------------------------------------------------------------------
; <#
; ----------------------------------------------------------------------------
declare "<#", "BDIGS"
        .word   DOCOL
        .word   PAD
        .word   HLD
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; HOLD
; ----------------------------------------------------------------------------
declare "HOLD"
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
; SIGN
; ----------------------------------------------------------------------------
declare "SIGN"
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
; #
; ----------------------------------------------------------------------------
declare "#", "DIG"
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
; #S
; ----------------------------------------------------------------------------
declare "#S", "DIGS"
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
; #>
; ----------------------------------------------------------------------------
declare "#>", "EDIGS"
        .word   DOCOL
        .word   TWODROP
        .word   HLD
        .word   AT
        .word   PAD
        .word   OVER
        .word   SUB
        .word   SEMIS

; ----------------------------------------------------------------------------
; D.R
; ----------------------------------------------------------------------------
declare "D.R", "DDOTR"
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
; D.
; ----------------------------------------------------------------------------
declare "D.", "DDOT"
        .word   DOCOL
        .word   ZERO
        .word   DDOTR
        .word   SPACE
        .word   SEMIS

; ----------------------------------------------------------------------------
; .R
; ----------------------------------------------------------------------------
declare ".R", "DOTR"
        .word   DOCOL
        .word   TOR
        .word   STOD
        .word   RFROM
        .word   DDOTR
        .word   SEMIS

; ----------------------------------------------------------------------------
; .
; ----------------------------------------------------------------------------
declare ".", "DOT"
        .word   DOCOL
        .word   STOD
        .word   DDOT
        .word   SEMIS

; ----------------------------------------------------------------------------
; ?
; ----------------------------------------------------------------------------
declare "?", "QUESTION"
        .word   DOCOL
        .word   AT
        .word   DOT
        .word   SEMIS

; ----------------------------------------------------------------------------
; U.
; ----------------------------------------------------------------------------
declare "U.", "UDOT"
        .word   DOCOL
        .word   ZERO
        .word   DDOT
        .word   SEMIS
; ----------------------------------------------------------------------------
; H.
; ----------------------------------------------------------------------------
declare "H.", "HDOT"
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
; ?COMP
; ----------------------------------------------------------------------------
declare "?COMP", "QCOMP"
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   ZEQUAL
        .word   LIT
        .word   $11
        .word   QERROR
        .word   SEMIS

; ----------------------------------------------------------------------------
; COMPILE
; ----------------------------------------------------------------------------
declare "COMPILE"
        .word   DOCOL
        .word   QCOMP
        .word   RFROM
        .word   WCOUNT
        .word   COMMA
        .word   TOR
        .word   SEMIS

; ----------------------------------------------------------------------------
; LITERAL
; ----------------------------------------------------------------------------
declare "LITERAL",, immediate
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
; DLITERAL
; ----------------------------------------------------------------------------
declare "DLITERAL",, immediate
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


.ifdef With::DECOMPILER
	.include "Decomplier.s"
.endif

; ----------------------------------------------------------------------------
; WORD
; ----------------------------------------------------------------------------
declare "WORD"
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
; ASCII
; ----------------------------------------------------------------------------
declare "ASCII",, immediate
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE
        .word   ONEP
        .word   CAT
        .word   LITERAL
        .word   SEMIS

; ----------------------------------------------------------------------------
; (
; ----------------------------------------------------------------------------
declare "(", "LPAREN", immediate
        .word   DOCOL
        .word   LIT
        .word   $29
        .word   WORD
        .word   SEMIS

; ----------------------------------------------------------------------------
; (.")
; ----------------------------------------------------------------------------
declare '(.")', "PDOTQ"
        .word   DOCOL
        .word   RFROM
        .word   COUNT
        .word   TWODUP
        .word   PLUS
        .word   TOR
        .word   TYPE
        .word   SEMIS

; ----------------------------------------------------------------------------
; ."
; ----------------------------------------------------------------------------
declare '."', "DOTQ", immediate
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
; -FIND
; ----------------------------------------------------------------------------
declare "-FIND","DFIND"
        .word   DOCOL
        .word   BL
        .word   WORD
        .word   HERE

	;
	; Conversion MAJUSCULES/minuscules
	; pour la recherche dans le dictionnaire
	;
	.if With::CaseSensitive = 0
		;.word   CAPS
		;.word   AT
		;.word   ZBRANCH
		;.word   LDFIND_SUITE
	        .word   DUP
		.word   COUNT
		.if With::DictCase = 1
			.word   LOWER
	        .else
			.word UPPER
	        .endif
	        ;LDFIND_SUITE:
	.endif

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
; '
; ----------------------------------------------------------------------------
declare "'","TICK", immediate
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
; [COMPILE]
; ----------------------------------------------------------------------------
declare "[COMPILE]", "BCOMPILE", immediate
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
; OFF
; ----------------------------------------------------------------------------
declare "OFF"
        .word   DOCOL
        .word   ZERO
        .word   SWAP
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; ON
; ----------------------------------------------------------------------------
declare "ON"
        .word   DOCOL
        .word   ONE
        .word   SWAP
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; [
; ----------------------------------------------------------------------------
declare "[", "LBRACKET", immediate
        .word   DOCOL
        .word   STATE
        .word   OFF
        .word   SEMIS

; ----------------------------------------------------------------------------
; ]
; ----------------------------------------------------------------------------
declare "]", "RBRACKET"
        .word   DOCOL
        .word   LIT
        .word   $C0
        .word   STATE
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; !CSP
; ----------------------------------------------------------------------------
declare "!CSP", "STORECSP"
        .word   DOCOL
        .word   SPat
        .word   CSP
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; ?CSP
; ----------------------------------------------------------------------------
declare "?CSP", "QCSP"
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
; ;
; ----------------------------------------------------------------------------
declare ";", "SEMI", immediate
        .word   DOCOL
        .word   QCSP
        .word   COMPILE
        .word   SEMIS
        .word   SMUDGE
        .word   LBRACKET
        .word   SEMIS

; ----------------------------------------------------------------------------
; (LIT")
; ----------------------------------------------------------------------------
declare '(LIT")', "PLITQ"
        .word   DOCOL
        .word   RFROM
        .word   DUP
        .word   COUNT
        .word   PLUS
        .word   TOR
        .word   SEMIS

; ----------------------------------------------------------------------------
; LIT"
; ----------------------------------------------------------------------------
declare 'LIT"', "LITQ", immediate
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
; Message d'erreur
; ----------------------------------------------------------------------------
MSG:
        .byte   $00
        pstring   "pas trouve"

        .byte   $01
        pstring "pile vide"

        .byte   $02
        pstring "dictionnaire plein"

        .byte   $03
        pstring "mode d'adressage incorrect"

        .byte   $04
        pstring "(redefini)"

        .byte   $05
        pstring "inconnu dans ce vocabulaire"

        .byte   $07
        pstring "pile pleine"

        .byte   $0A
        pstring "OVSAVE: compiler deux fois"

        .byte   $0B
        pstring "OVSAVE: utiliser OV6502"

        .byte   $0D
        pstring "la base doit etre decimale"


	.ifndef With::CH376
	        .byte   $0F
	        pstring "TELE-FORTH V1.2 - Thierry BESTEL"
	.else
	        .byte $0F
	        pstring .sprintf("TELE-FORTH V%d.%d - Christian Lardiere",With::VERSION_MAJ, With::VERSION_MIN)
	.endif


        .byte   $11
        pstring "en definition seulement"

        .byte   $12
        pstring "hors definition seulement"

        .byte   $13
        pstring "controles mal appaires"

        .byte   $14
        pstring "definition incomplete"

        .byte   $15
        pstring "dictionnaire protege"

        .byte   $16
        pstring "sur disque seulement"

        .byte   $17
        pstring "lignes 0 a 15"

        .byte   $18
        pstring "declarer un vocabulaire"

        .byte   $1C
        pstring "valeur incorrecte"

        .byte   $81
        pstring "Fichier inexistant"

        .byte   $82
        pstring "Erreur disque"

        .byte   $83
        pstring "Fichier existant"

        .byte   $84
        pstring "Disquette pleine"

        .byte   $85
        pstring "Disquette protegee"

        .byte   $86
        pstring "Erreur de type"

        .byte   $87
        pstring "Disquette non STRATSED"

        .byte   $88
        pstring "Pas de STRATSED"

        .byte   $89
        pstring "Nom de fichier incorrect"

        .byte   $8A
        pstring "Lecteur absent"


	.ifndef With::CH376
	        .byte   $FE
	        pstring .sprintf("TELE-FORTH V1.2%c%cgenere avec TELE-ASS V1.0a",$0D,$0A)

	        .byte   $FF
	        pstring .sprintf("Base sur TELE-FORTH V1.1 %c%cde Christophe LAVARENNE",$0D,$0A)
	.else
	        .byte $91
		pstring "Repertoire inexistant"

	        .byte $93
		pstring "Repertoire existant"

	        .byte $FE
		pstring .sprintf("TELE-FORTH V%d.%d%c%cgenere avec xa v2.3.8", With::VERSION_MAJ, With::VERSION_MIN,$0D,$0A)

	        .byte $FF
		pstring .sprintf("Base sur TELE-FORTH V1.2%c%cde Thierry Bestel",$0D,$0A)
	.endif


.ifndef With::COMPACT
	.res $D524-*,$00
.endif

; ----------------------------------------------------------------------------
; MESSAGE
; ----------------------------------------------------------------------------
declare "MESSAGE"
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

        .byte   $04
        .byte   "Msg:"

        .word   R
        .word   DOT
LD579:
        .word   RFROMDROP
        .word   SEMIS

; ----------------------------------------------------------------------------
; DEFER
; ----------------------------------------------------------------------------
declare "DEFER"
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
; (IS)
; ----------------------------------------------------------------------------
declare "(IS)", "PIS"
        .word   DOCOL
        .word   SWAP
        .word   CFA
        .word   SWAP
        .word   AT
        .word   STORE
        .word   SEMIS

; ----------------------------------------------------------------------------
; IS
; ----------------------------------------------------------------------------
declare "IS",, immediate
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
; B/BUF
; ----------------------------------------------------------------------------
constant "B/BUF", "B_BUF", $0400

; ----------------------------------------------------------------------------
; B/SCR
; ----------------------------------------------------------------------------
constant "B/SCR", "B_SCR", $0001

; ----------------------------------------------------------------------------
; FIRST
; ----------------------------------------------------------------------------
constant "FIRST",, $1000

; ----------------------------------------------------------------------------
; LIMIT
; ----------------------------------------------------------------------------
constant "LIMIT",, RAM_START

; ----------------------------------------------------------------------------
; EMPTY-BUFFERS
; ----------------------------------------------------------------------------
declare "EMPTY-BUFFERS", "EMPTYBUFFERS"
        .word   DOCOL
        .word   FIRST
        .word   LIMIT
        .word   OVER
        .word   SUB
        .word   ERASE
        .word   SEMIS

; ----------------------------------------------------------------------------
; UPDATE
; ----------------------------------------------------------------------------
declare "UPDATE"
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
; FLUSH
; ----------------------------------------------------------------------------
declare "FLUSH"
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
; BLOCK
; ----------------------------------------------------------------------------
declare "BLOCK"
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
; ABORT
; ----------------------------------------------------------------------------
declare "ABORT"
        .word   DODEFER
	.word ABORT_defer

; ----------------------------------------------------------------------------
; ERROR
; ----------------------------------------------------------------------------
; Nécessite le mot WHERE défini avec le vocabulaire EDITOR
; TODO: Vectoriser ERROR pour pouvoir avoir une version avec et sans WHERE
;       Ou vectoriser WHERE...
; ----------------------------------------------------------------------------
declare "ERROR"
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

        .byte   $03
        .byte   " ? "

        .word   MESSAGE
        .word   SPstore
.ifdef With::WHERE
		verbose 2, "Ajout du support WHERE pour ERROR"
	        .word   BLK
	        .word   AT
	        .word   DDUP
	        .word   ZBRANCH
	        .word   LD6F6
	        .word   IN
	        .word   AT
	        .word   SWAP
	        .word   WHERE
.endif
LD6F6:
        .word   QUIT
        .word   SEMIS

; ----------------------------------------------------------------------------
; ?ERROR
; ----------------------------------------------------------------------------
declare "?ERROR", "QERROR"
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
; (NUMBER)
; ----------------------------------------------------------------------------
declare "(NUMBER)", "PNUMBER"
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
; INUMBER
; ----------------------------------------------------------------------------
declare "INUMBER"
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
; NUMBER
; ----------------------------------------------------------------------------
declare "NUMBER"
        .word   DODEFER
        .word   NUMBER_defer

; ----------------------------------------------------------------------------
; .S
; ----------------------------------------------------------------------------
declare ".S", "DOTS"
        .word   DOCOL
        .word   PDOTQ

        .byte   $04
        .byte   "(-- "

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

        .byte   $02
        .byte   ") "

        .word   SEMIS

; ----------------------------------------------------------------------------
; ?EXEC
; ----------------------------------------------------------------------------
declare "?EXEC", "QEXEC"
        .word   DOCOL
        .word   STATE
        .word   AT
        .word   LIT
        .word   $12
        .word   QERROR
        .word   SEMIS

; ----------------------------------------------------------------------------
; ?STACK
; ----------------------------------------------------------------------------
declare "?STACK", "QSTACK"
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
; ?PAIRS
; ----------------------------------------------------------------------------
declare "?PAIRS", "QPAIRS"
        .word   DOCOL
        .word   SUB
        .word   LIT
        .word   $13
        .word   QERROR
        .word   SEMIS

; ----------------------------------------------------------------------------
; ?OK
; ----------------------------------------------------------------------------
declare "?OK", "QOK"
        .word   DOCOL
LD858:
        .word   PDOTQ

        .byte   $05
        .byte   " OK? "

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

        .byte   $1F
        .byte   "RETURN=oui ESC=non CTRL+C=stop "

        .word   DROP
LD8B6:
        .word   BRANCH
        .word   LD858
        .word   SEMIS

; ----------------------------------------------------------------------------
; OK
; ----------------------------------------------------------------------------
declare "OK"
        .word   DOCOL
        .word   PDOTQ

        .byte   $02
        .byte   "Ok"

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
; PROMPT
; ----------------------------------------------------------------------------
declare "PROMPT"
        .word   DODEFER
        .word   PROMPT_defer

; ----------------------------------------------------------------------------
; EXPECT
; ----------------------------------------------------------------------------
declare "EXPECT"
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
; QUERY
; ----------------------------------------------------------------------------
declare "QUERY"
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
; <nul>
; ----------------------------------------------------------------------------
declare "", "NUL", immediate
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
; INTERPRET
; ----------------------------------------------------------------------------
declare "INTERPRET"
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
; QUIT
; ----------------------------------------------------------------------------
declare "QUIT"
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
; CREATE
; ----------------------------------------------------------------------------
declare "CREATE"
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
; VOCABULARY
; ----------------------------------------------------------------------------
declare "VOCABULARY"
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
; FORTH (*)
; ----------------------------------------------------------------------------
vocabulary "FORTH",, immediate

; ----------------------------------------------------------------------------
; ?TERMINAL
; ----------------------------------------------------------------------------
declare "?TERMINAL", "QTERMINAL"
        .word   DODEFER

QTERMINAL_pfa:
        .word   QTERMINAL_defer

; ----------------------------------------------------------------------------
; KEY
; ----------------------------------------------------------------------------
declare "KEY"
        .word   DODEFER

KEY_pfa:
        .word   KEY_defer

; ----------------------------------------------------------------------------
; EMIT
; ----------------------------------------------------------------------------
declare "EMIT"
        .word   DODEFER
EMIT_pfa:
        .word   EMIT_defer

.ifdef NEED_PABORT
	; ----------------------------------------------------------------------------
	; (ABORT)
	; ----------------------------------------------------------------------------
	declare "(ABORT)", "PABORT"
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

	        .byte   $0C
	        .byte   "TELE-FORTH V"

	        .word   LIT
	        .word   With::VERSION_MAJ
	        .word   LIT
	        .word   $30
	        .word   PLUS
	        .word   EMIT
	        .word   PDOTQ

	        .byte   $01
	        .byte   "."

	        .word   LIT
	        .word   With::VERSION_MIN
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

	        .byte   $0E
	        .byte   "octets libres "

	        .word   FORTH
	        .word   DEFINITIONS
	        .word   STARTUP
	        .word   QUIT
	        .word   SEMIS
.endif

; ----------------------------------------------------------------------------
; COLD
; ----------------------------------------------------------------------------
declare "COLD"
        .word   DOCOL

	.ifdef With::ROMend
	        .word   ROMend
	.endif

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
; WARM
; ----------------------------------------------------------------------------
declare "WARM"
        .word   DOCOL
        .word   EMPTYBUFFERS
        .word   ABORT
        .word   SEMIS

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
	.include "Control.s"
.endif

; ----------------------------------------------------------------------------
;           Instructions IF/THEN/ELSE utilisable en mode direct
; ----------------------------------------------------------------------------
.ifdef With::PSEUDO_IF
	verbose 2, "Ajout des mots IF(, )ELSE(, )ENDIF"
	; ----------------------------------------------------------------------------
	; IF(
	; ----------------------------------------------------------------------------
	declare "IF(", "IFP", immediate
	        .word   DOCOL
	        .word   ZEQUAL
	        .word   ZBRANCH
	        .word   LDE70
	LDE40:
	        .word   BL
	        .word   WORD
	        .word   PLITQ

	        .byte   $06
	        .byte   ")ELSE("

	        .word   HERE
	        .word   DUP
	        .word   CAT
	        .word   ONEP
	        .word   SEQUAL
	        .word   PLITQ

	        .byte   $06
	        .byte   ")ENDIF"

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
	; )ELSE(
	; ----------------------------------------------------------------------------
	declare ")ELSE(", "PELSEP", immediate
	        .word   DOCOL
	LDE7D:
	        .word   BL
	        .word   WORD
	        .word   PLITQ

	        .byte   $06
	        .byte   ")ENDIF"

	        .word   HERE
	        .word   DUP
	        .word   CAT
	        .word   ONEP
	        .word   SEQUAL
	        .word   ZBRANCH
	        .word   LDE7D
	        .word   SEMIS

	; ----------------------------------------------------------------------------
	; )ENDIF
	; ----------------------------------------------------------------------------
	declare ")ENDIF", "PENDIF", immediate
	        .word   DOCOL
	        .word   SEMIS

.endif

; ----------------------------------------------------------------------------
;                    Gestion chargement d'un écran
; ----------------------------------------------------------------------------
	.ifdef NEED_QLOADING

		; ----------------------------------------------------------------------------
		; ?LOADING
		; ----------------------------------------------------------------------------
			declare "?LOADING","QLOADING"
		        .word   DOCOL
		        .word   BLK
		        .word   AT
		        .word   ZEQUAL
		        .word   LIT
		        .word   $16
		        .word   QERROR
		        .word   SEMIS

	.endif

	.ifdef With::BACKSLASH
		; ----------------------------------------------------------------------------
		; \
		; ----------------------------------------------------------------------------
		.ifndef With::BACKSLASH_IMMEDIATE
			verbose 2, "Ajout du mot \\"
			declare "\", "backslash"
		.else
			verbose 2, "Ajout du mot \\ (IMMEDIATE)"
			declare "\", "backslash", immediate
		.endif
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
	.endif

	.ifdef With::FOLLOW
		; ----------------------------------------------------------------------------
		; -->
		; ----------------------------------------------------------------------------
		declare "-->", "FOLLOW", immediate
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

	.endif

	.ifdef NEED_LOAD
		; ----------------------------------------------------------------------------
		; LOAD
		; ----------------------------------------------------------------------------
		declare "LOAD"
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

	.endif

	.ifdef With::THRU
		; ----------------------------------------------------------------------------
		; THRU
		; ----------------------------------------------------------------------------
		declare "THRU"
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

	.endif

	.ifdef With::STRATSED
		; ----------------------------------------------------------------------------
		; LOAD-USING
		; ----------------------------------------------------------------------------
		declare "LOAD-USING", "LOAD_USING"
		        .word   DOCOL
		        .word   XFILE
		        .word   USING
		        .word   LOAD
		        .word   XFILE
		        .word   DOTFILE
		        .word   SEMIS

		; ----------------------------------------------------------------------------
		; THRU-USING
		; ----------------------------------------------------------------------------
		declare "THRU-USING", "THRU_USING"
		        .word   DOCOL
		        .word   XFILE
		        .word   USING
		        .word   THRU
		        .word   XFILE
		        .word   DOTFILE
		        .word   SEMIS

	.endif

	; ----------------------------------------------------------------------------
	; Utilisé par LIST, TRIAD, INDEX, VLIST
	; ----------------------------------------------------------------------------
	.ifdef NEED_QTERMSTOP
		; ----------------------------------------------------------------------------
		; ?TERMSTOP
		; ----------------------------------------------------------------------------
		declare "?TERMSTOP", "QTERMSTOP"
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

	.endif

; ----------------------------------------------------------------------------
;                    Gestion affichage d'un écran
; ----------------------------------------------------------------------------
.ifdef NEED_CSLL
	; ----------------------------------------------------------------------------
	; C/L
	; ----------------------------------------------------------------------------
	constant "C/L","CSLL", $0040

.endif


.ifdef With::PLINE
	; ----------------------------------------------------------------------------
	; (LINE)
	; ----------------------------------------------------------------------------
	declare "(LINE)", "PLINE"
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

.endif

.ifdef With::DOTLINE
	; ----------------------------------------------------------------------------
	; .LINE
	; ----------------------------------------------------------------------------
	declare ".LINE", "DOTLINE"
	        .word   DOCOL
	        .word   PLINE
	        .word   DTRAILING
	        .word   TYPE
	        .word   SEMIS

.endif

.ifdef With::LIST
	; ----------------------------------------------------------------------------
	; LIST
	; ----------------------------------------------------------------------------
	declare "LIST"
	        .word   DOCOL
	        .word   CR
	        .word   DUP
	        .word   SCR
	        .word   STORE
	        .word   PDOTQ

	        .byte   $05
	        .byte   "SCR #"

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
.endif

.ifdef With::TRIAD
	; ----------------------------------------------------------------------------
	; TRIAD_nfa
	; ----------------------------------------------------------------------------
	declare "TRIAD"
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
.endif

.ifdef With::INDEX
	; ----------------------------------------------------------------------------
	; INDEX
	; ----------------------------------------------------------------------------
	declare "INDEX"
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
	.endif

; ----------------------------------------------------------------------------
;                         Gestion du dictionnaire
; ----------------------------------------------------------------------------
.ifdef With::FORGET
	; ----------------------------------------------------------------------------
	; V<
	; ----------------------------------------------------------------------------
	declare "V<", "VTO"
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
	; FORGET
	; ----------------------------------------------------------------------------
	declare "FORGET"
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
.endif

	; ----------------------------------------------------------------------------
	; ID.
	; ----------------------------------------------------------------------------
	declare "ID.", "IDDOT"
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

.ifdef With::VLIST
	; ----------------------------------------------------------------------------
	; VLIST
	; ----------------------------------------------------------------------------
	declare "VLIST"
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
.endif

.ifdef With::VOC_LIST
	; ----------------------------------------------------------------------------
	; VOC-LIST
	; ----------------------------------------------------------------------------
	declare "VOC-LIST", "VOC_LIST"
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
.endif

.ifdef With::ROMend
	; ----------------------------------------------------------------------------
	; INIT-RAM
	; Copie $3c80 octets de $c37f vers $c380???
	; Utilisé uniquement par ROMend
	; ----------------------------------------------------------------------------
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
.endif

; ----------------------------------------------------------------------------
; TeleForth signature
; ----------------------------------------------------------------------------
teleforth_signature:
.ifdef TELEFORTH_V12
        .byte   "TELE-FORTH V1.2"

        .byte   $0D,$0A
        .byte   "(c) 1989 Thierry BESTEL"
        .byte   $0D,$0A,$00
.else
        .byte   .sprintf("TELE-FORTH V%d.%d (ch376) - %s", With::VERSION_MAJ, With::VERSION_MIN, __DATE__)
;        .byte   .sprintf("TELE-FORTH V%d.%d (ch376) - %s",VERSION_MAJ,VERSION_MIN, __DATE__)
        .byte $00
.endif

.ifdef NEED_AYX
	; ----------------------------------------------------------------------------
	; AYX
	; ----------------------------------------------------------------------------
	; Utilisé par CLOCK, GRAFX, IOS_xxx, SOUNDS, STRATSED_xxx, WINDOWS
	; ----------------------------------------------------------------------------
	constant "AYX",, $0563
.endif


.ifdef NEED_PIO
	; ----------------------------------------------------------------------------
	; PIO
	; ----------------------------------------------------------------------------
	constant "PIO",, $0566
.endif


.ifdef NEED_MON
	; ----------------------------------------------------------------------------
	; MON
	; ----------------------------------------------------------------------------
	; Utilisé par CLOCK, GRAFX, IOS_xxx, SOUNDS, Stratsed_extended (FILENAME), WINDOWS
	; ----------------------------------------------------------------------------
	code "MON"
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
.endif

.ifdef NEED_MONCOL
	; ----------------------------------------------------------------------------
	; MON:
	; Compile un mot d'appel à une procédure Telemon
	; Utilisé par les vocabulaires IOS_extended, GRAFX, SOUNDS
	; ----------------------------------------------------------------------------
	declare "MON:", "MONCOL"
	        .word   DOCOL
	        .word   CREATE
	        .word   CCOMMA
	        .word   PSEMICODE

	DOMON:
	        stx     _XSAVE
	        ldy     #$02
	        lda     (W),y
	        sta     CallTel+1
	        jsr     CallTel
	        ldx     _XSAVE
	        jmp     NEXT
.endif

.ifdef NEED_HRSCOL
	; ----------------------------------------------------------------------------
	; HRS:
	; Utilisé uniquement par les vocabulaires GRAFX et SOUNDS
	; ----------------------------------------------------------------------------
	declare "HRS:", "HRSCOL"
	        .word   DOCOL
	        .word   CREATE
	        .word   CCOMMA
	        .word   CCOMMA
	        .word   PSEMICODE

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
.endif

; ----------------------------------------------------------------------------
; HIMEM
; Utilisé uniquement par (ABORT) et (+OVLOAD)
; ----------------------------------------------------------------------------
declare "HIMEM"
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
; Ajout des autres fichiers source
; ----------------------------------------------------------------------------
.ifdef With::SOUNDS_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire SOUNDS
	; ----------------------------------------------------------------------------
	.include "Sounds.s"
.endif
add_to_voc "FORTH"

.ifdef With::GRAFX_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire GRAFX
	; ----------------------------------------------------------------------------
	.include "Grafx.s"
	.endif
add_to_voc "FORTH"

.ifdef With::WINDOWS_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire WINDOWS
	; ----------------------------------------------------------------------------
	.include "Windows.s"
	.endif
add_to_voc "FORTH"

.ifdef With::CLOCK
	; ----------------------------------------------------------------------------
	; CLOCK
	; ----------------------------------------------------------------------------
	.include "Clock.s"
.endif
add_to_voc "FORTH"

.ifdef With::WAIT
	; ----------------------------------------------------------------------------
	; WAIT
	; ----------------------------------------------------------------------------
	.include "Wait.s"
.endif
add_to_voc "FORTH"

.ifdef With::STRATSED_MINIMAL
	; ----------------------------------------------------------------------------
	; Stratsed minimal
	; ----------------------------------------------------------------------------
	.include "Stratsed_minimal.s"
.endif
add_to_voc "FORTH"

.ifdef With::STRATSED
	; ----------------------------------------------------------------------------
	; Stratsed
	; ----------------------------------------------------------------------------
	.include "Stratsed_extended.s"
.endif
add_to_voc "FORTH"

.ifdef With::CH376
	; ----------------------------------------------------------------------------
	; Vocabulaire CH376
	; ----------------------------------------------------------------------------
	.include "CH376.s"
.endif
add_to_voc "FORTH"

.ifdef STARTUP
.else
	verbose 2, "Ajout du mot STARTUP de base"
	; ----------------------------------------------------------------------------
	; STARTUP
	; ----------------------------------------------------------------------------
	; /?\ A transférer dans Stratsed_extended.s et CH376.s
	; et mettre ici : STARTUP ;
	; ou definir STARTUP comme DEFER STARTUP et deinir (STARTUP) dans
	; Stratsed_extended.s et CH376.s et faire ' (STARTUP) IS STARTUP
	; ----------------------------------------------------------------------------
	declare "STARTUP"
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

	.ifdef With::AUTOSTART_SUPPORT
		verbose 2, "Pas de autostart 'FORTH.DAT' possible"
	.endif

	LEAFF:
	        .word   SEMIS
.endif

.ifdef With::OVERLAYS_SUPPORT
	; ----------------------------------------------------------------------------
	; Overlays support
	; ----------------------------------------------------------------------------
	.include "Overlays.s"
.endif
add_to_voc "FORTH"

.ifdef With::EXTERNAL_HELPERS
	; ----------------------------------------------------------------------------
	; Externals helpers
	; ----------------------------------------------------------------------------
	.include "Externals.s"
.endif
add_to_voc "FORTH"

.ifdef With::IOS_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire IOS (minimal)
	; ----------------------------------------------------------------------------
	.include "IOS_minimal.s"
.endif
add_to_voc "FORTH"

.ifdef With::INPUT
	; ----------------------------------------------------------------------------
	; INPUT
	; ----------------------------------------------------------------------------
	declare "INPUT"
	        .word   DOCOL
	        .word   PIO
	        .word   ONEP
	        .word   CSTORE
	        .word   SEMIS
.endif

.ifdef With::OUTPUT
	; ----------------------------------------------------------------------------
	; OUTPUT
	; ----------------------------------------------------------------------------
	declare "OUTPUT"
	        .word   DOCOL
	        .word   PIO
	        .word   TWOP
	        .word   CSTORE
	        .word   SEMIS
.endif

; ----------------------------------------------------------------------------
; TERMINAL
; ----------------------------------------------------------------------------
; Necessite les mots SCRW et CURSOR du vocabulaire WINDOWS
; Necessite les mots OPCH, QTERM, CKEY et CEMIT du vocabulaire IOS minimal
; ----------------------------------------------------------------------------
declare "TERMINAL"
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
        .word   QTERM_pfa
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
; CR
; ----------------------------------------------------------------------------
declare "CR"
        .word   DOCOL
        .word   LIT
        .word   $0D
        .word   EMIT
        .word   LIT
        .word   $0A
        .word   EMIT
        .word   SEMIS

; ----------------------------------------------------------------------------
; CLS
; ----------------------------------------------------------------------------
declare "CLS"
        .word   DOCOL
        .word   LIT
        .word   $0C
        .word   EMIT
        .word   SEMIS

; ----------------------------------------------------------------------------
; GOTOXY
; ----------------------------------------------------------------------------
declare "GOTOXY"
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
; ?HIRES
; ----------------------------------------------------------------------------
declare "?HIRES", "QHIRES"
        .word   DOCOL
        .word   LIT
        .word   flgtel
        .word   LIT
        .word   $80
        .word   CTST
        .word   SEMIS


.ifdef With::IOSext_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire IOS
	; ----------------------------------------------------------------------------
	.include "IOS_extended.s"
.endif
add_to_voc "FORTH"

.ifdef With::EDITOR_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire EDITOR
	; ----------------------------------------------------------------------------
	.include "Editor.s"
.else
	.ifdef With::WHERE
		verbose 2, "Ajout mot WHERE vectorisé"

		add_to_voc "FORTH"

		; ----------------------------------------------------------------------------
		; WHERE
		; ----------------------------------------------------------------------------
		declare "WHERE"
		        .word   DODEFER
		        .word   WHERE_defer

		; ----------------------------------------------------------------------------
		; (WHERE)
		; ----------------------------------------------------------------------------
		declare "(WHERE)", "PWHERE"
		        .word   DOCOL
		        .word   DROP
		        .word   DROP
		        .word   SEMIS
	.endif
.endif

add_to_voc "FORTH"


.ifdef With::LIFE_VOC
	; ----------------------------------------------------------------------------
	; Vocabulaire LIFE
	; ----------------------------------------------------------------------------
	.include "Life.s"
.endif
add_to_voc "FORTH"


.ifdef With::ROMend
	verbose 2, "Ajout du mot ROMend"
	; ----------------------------------------------------------------------------
	; ROMend
	; ----------------------------------------------------------------------------
	declare "ROMend"
	        .word   INIT_RAM
	        .word   SEMIS
.endif

.ifdef With::TWILIGHTE
	; ----------------------------------------------------------------------------
	; Vocabulaire pour la carte Twilight
	; ----------------------------------------------------------------------------
	.include "Twilighte.s"
.endif
add_to_voc "FORTH"


; ----------------------------------------------------------------------------
; Partie en RAM
; ----------------------------------------------------------------------------

verbose 2, ""

	; ----------------------------------------------------------------------------
	; Taille de la table d'init du dictionnaire en RAM (copiée en $1404 par COLD)
	; ----------------------------------------------------------------------------
	DictInitTable:
	        .word   DictInitTableEnd-(*+2)

		.org RAM_START

	; ----------------------------------------------------------------------------
	; +00 -> defer de ABORT
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer ABORT -> $%04x", *)
	ABORT_defer:
	        .word   PABORT

	; ----------------------------------------------------------------------------
	; +02 -> defer de NUMBER
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer NUMBER -> $%04x", *)
	NUMBER_defer:
	        .word   INUMBER

	; ----------------------------------------------------------------------------
	; +04 -> defer de PROMPT
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer PROMPT -> $%04x", *)
	PROMPT_defer:
	        .word   OK

	; ----------------------------------------------------------------------------
	; +06 -> Pour le vocabulaire FORTH
	; ----------------------------------------------------------------------------
	verbose 2, "Ajout entête du vocabulaire FORTH"
	vocabulary_pfa "FORTH"

	; ----------------------------------------------------------------------------
	; +10 -> defer de QTERMINAL (initialisé à QTERM par TERMINAL)
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer ?TERMINAL -> $%04x", *)
	QTERMINAL_defer:
	        .word   NOOP

	; ----------------------------------------------------------------------------
	; +12 -> defer de KEY (initialisé à CKEY par TERMINAL)
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer KEY -> $%04x", *)
	KEY_defer:
	        .word   NOOP

	; ----------------------------------------------------------------------------
	; +14 -> defer de EMIT (initialisé à CEMIT par TERMINAL)
	; ----------------------------------------------------------------------------
	verbose 2, .sprintf("Ajout defer EMIT -> $%04x", *)
	EMIT_defer:
	        .word   NOOP

	; ----------------------------------------------------------------------------
	; +16 -> Pour le vocabulaire SOUNDS
	; ----------------------------------------------------------------------------
	.ifdef With::SOUNDS_VOC
		.include "Sounds.s"
	.endif

	; ----------------------------------------------------------------------------
	; +20 -> Pour le vocabulaire GRAFX
	; ----------------------------------------------------------------------------
	.ifdef With::GRAFX_VOC
		.include "Grafx.s"
	.endif

	; ----------------------------------------------------------------------------
	; +24 -> Pour le vocabulaire WINDOWS
	; ----------------------------------------------------------------------------
	.ifdef With::WINDOWS_VOC
		.include "Windows.s"
	.endif

	; ----------------------------------------------------------------------------
	; +28 -> Pour le vocabulaire IOS
	; ----------------------------------------------------------------------------
	.ifdef With::IOS_VOC
		.include "IOS_minimal.s"

		.ifdef With::IOSext_VOC
			; ----------------------------------------------------------------------------
			; +32 -> defer de MINITEL
			; ----------------------------------------------------------------------------
			.include "IOS_extended.s"
		.endif
	.endif

	; ----------------------------------------------------------------------------
	; +34 -> Pour le vocabulaire EDITOR
	; ----------------------------------------------------------------------------
	.ifdef With::EDITOR_VOC
		.include "Editor.s"
	.else
		.ifdef With::WHERE
			verbose 2, "Ajout ' (WHERE) IS WHERE"
			; WHERE_defer = RAM_START-2+(*-DictInitTable)
			WHERE_defer:
			        .word PWHERE
		.endif
	.endif

	; ----------------------------------------------------------------------------
	; +38 -> Pour le vocabulaire LIFE
	; ----------------------------------------------------------------------------
	.ifdef With::LIFE_VOC
		.include "Life.s"
	.endif

	; ----------------------------------------------------------------------------
	; Remplissage
	; ----------------------------------------------------------------------------
	.ifndef With::COMPACT
	        .byte   $00,$00,$00,$00,$00,$00,$00,$00
	        .byte   $00,$00,$00,$00,$00,$00
	.endif

	; ----------------------------------------------------------------------------
	; Pour le vocabulaire CH376
	; ----------------------------------------------------------------------------
	.ifdef With::CH376
		.include "CH376.s"
	.endif

	; ----------------------------------------------------------------------------
	; Pour le vocabulaire Twilighte
	; ----------------------------------------------------------------------------
	add_to_voc "FORTH"
	.ifdef With::TWILIGHTE
		.include "Twilighte.s"
	.endif

RAM_END:

	.org DictInitTable +2 + (RAM_END-RAM_START)
DictInitTableEnd:


; ----------------------------------------------------------------------------
;				END
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
last_forth_word_nfa .set FORTH_last_word_nfa
last_voc_link2 .set last_voc_link
; ----------------------------------------------------------------------------

verbose 1, ""
verbose 1, ""
verbose 1, .sprintf("TeleForth %d.%d - %s",With::VERSION_MAJ,With::VERSION_MIN, __DATE__)
verbose 1,          "----------------------------"
verbose 1, .sprintf("ROM          : $%04x - $%04x", $C000, *)
verbose 1, .sprintf("Used         : $%04x", * - ORIGIN)
verbose 1, .sprintf("Free         : $%04x", $fff8-*)
verbose 1,          "          --- ---"
verbose 1, .sprintf("UAREA        : $%04x", _UAREA_)
verbose 1, .sprintf("DOSBUFFERS   : $%04x", DOSBUFFERS)
verbose 1, .sprintf("FIRST        : $%04x", _FIRST)
verbose 1, .sprintf("LIMIT        : $%04x", RAM_START)

verbose 1, .sprintf("Dictionary   : $%04x - $%04x", RAM_START, RAM_END)

verbose 1,          "----------------------------"
verbose 1, ""
verbose 1, ""

; ----------------------------------------------------------------------------
.if * > $fff8
	.error .sprintf("Erreur fichier trop long %d", _err_)
.endif
 .res $fff8-*, $00

; ----------------------------------------------------------------------------
; Vecteurs 6502 & Telemon
; ----------------------------------------------------------------------------
        .word   teleforth_signature
; ----------------------------------------------------------------------------
        .byte   $12,$EF
; ----------------------------------------------------------------------------
        .word   ORIGIN
        .word   virq
