; ----------------------------------------------------------------------------
; Configs.inc:
; ----------------------------------------------------------------------------
;				Configurations
; ----------------------------------------------------------------------------

; --------------------------------------------------------------
; Configuration pour TeleForth V2.0                      (Ch376)
; --------------------------------------------------------------
.scope TeleForth_V2

	VERSION_MAJ = 2
	VERSION_MIN = 0

	; Dictionnaire en minuscules
	; Pose un pb pour la conversion des nombres de base > 10
	; Ex. hex 1a -> 1a ? inconnu dans ce vocabulaire
	; DictCase .Set 1
	; CaseSensitive .set 0

	; Dictionnaire en MAJUSCULES
	DictCase .set 2
	CaseSensitive .set 0

	; Deplace les variables vasalo,... après PIO_addr pour éviter la collision avec
	; Orix (pour pouvoir récupérer le PATH courant)
	; A voir si ces variables sont nécessaires avec le ch376
	Page05_Base = ($0568-$28)
	;
	COMPACT .set 1
	WITHOUT_FIGFORTH_BUG .set 1
	;
	; Décompilateur
	;DECOMPILER .set 0
	;
	; Extensions sonores
	SOUNDS_VOC .set 1
	;
	; Extensions graphiques
	GRAFX_VOC .set 1
	;
	; SCRW et CURSOR nécessaires pour TERMINAL
	WINDOWS_VOC .set 1
	;
	CLOCK .set 1
	WAIT .set 1
	;
	; Support disque (Telestrat)
	; R/W nécessaire pour FLUSH et BLOCK
	;.define WITH_STRATSED_MINIMAL
	; USING et XFILE nécessaires pour SCRMOVE et SCRCOPY
	; DOLLOAD et DOLSAVE nécessaires pour OVERLAYS et EXTERNAL
	; SALOSTORE nécessaire pour IOS_SERIAL et IOS_MINITEL
	;.define WITH_STRATSED
	;
	; Support disque (CH376)
	CH376 .set 1
	; Necessaire pour support AUTOSTART
	;.define CH376_Extended
	;
	; Force les noms de fichiers en MAJUSCULES
	UPERCASE_FILENAME .set 1
	; UPPER .set 1
	; LOWER .set 1
	;
	ARGV .set 1
	;
	; Support carte Twilight
	TWILIGHTE .set 1
	;
	; Support EXIT (source dans Control.asm)
	EXIT .set 1
	;
	; Support des structures de contrôle
	ALL_TESTS .set 1
	;.define IF_THEN_ELSE
	;.define BEGIN_AGAIN
	;.define BEGIN_UNTIL
	;.define BEGIN_WHILE
	;.define DO_LOOP
	;.define DO_PLOOP
	;.define CASE_OF_ENDCASE
	;
	PSEUDO_IF .set 1
	;
	AUTOSTART_SUPPORT .set 1
	;	.define AUTOSTART_FILE "STARTUP.DAT"
	;
	; Gestion des écrans
	QLOADING .set 1
	FOLLOW .set 1
	;.define BACKSLASH
	BACKSLASH_IMMEDIATE .set 1
	CSLL .set 1
	PLINE .set 1
	DOTLINE .set 1
	INDEX .set 1
	LIST .set 1
	TRIAD .set 1
	THRU .set 1
	LOAD .set 1
	;
	OVERLAYS_SUPPORT .set 1
	;.define EXTERNAL_HELPERS
	;
	; OPCH, QTERM, CKEY et CEMIT nécessaires pour TERMINAL
	IOS_VOC .set 1
	;.define IOS_PRINTER
	;.define IOS_SERIAL
	;.define IOS_MINITEL
	;
	;.define INPUT
	;.define OUTPUT

	CLS .set 1
	GOTOXY .set 1

	;
	; Support editeur standard
	EDITOR_VOC .set 1
	WHERE .set 1
	EDITOR_TEXT_LINE .set 1
	;.define EDITOR_SCRMOVE_SCRCOPY
	;
	; Jeu de la vie (démonstration)
	;.define LIFE_VOC
	;.define LIFE_DEMO
	;
	; Gestion du dictionnaire
	FORGET .set 1
	VLIST .set 1
	VOC_LIST .set 1
	;
	;.define ROMend
	;

.endscope

; --------------------------------------------------------------
; Configuration pour TeleForth V2.0                    (Minimal)
; --------------------------------------------------------------
.scope TeleForth_V2_Minimal

	VERSION_MAJ = 2
	VERSION_MIN = 0

	; Dictionnaire en minuscules
	DictCase .Set 1
	CaseSensitive .set 0

	; Deplace les variables vasalo,... après PIO_addr pour éviter la collision avec
	; Orix (pour pouvoir récupérer le PATH courant)
	; A voir si ces variables sont nécessaires avec le ch376
	Page05_Base = ($0568-$28)
	;
	COMPACT .set 1
	WITHOUT_FIGFORTH_BUG .set 1
	;
	; Décompilateur
	;DECOMPILER .set 0
	;
	; Extensions sonores
	; SOUNDS_VOC .set 1
	;
	; Extensions graphiques
	; GRAFX_VOC .set 1
	;
	; SCRW et CURSOR nécessaires pour TERMINAL
	WINDOWS_VOC .set 1
	;
	; CLOCK .set 1
	; WAIT .set 1
	;
	; Support disque (Telestrat)
	; R/W nécessaire pour FLUSH et BLOCK
	;.define WITH_STRATSED_MINIMAL
	; USING et XFILE nécessaires pour SCRMOVE et SCRCOPY
	; DOLLOAD et DOLSAVE nécessaires pour OVERLAYS et EXTERNAL
	; SALOSTORE nécessaire pour IOS_SERIAL et IOS_MINITEL
	;.define WITH_STRATSED
	;
	; Support disque (CH376)
	CH376 .set 1
	; Necessaire pour support AUTOSTART
	;.define CH376_Extended
	;
	; Force les noms de fichiers en MAJUSCULES
	UPERCASE_FILENAME .set 1
	;.define UPPER
	;.define LOWER
	;
	ARGV .set 1
	;
	; Support carte Twilight
	TWILIGHTE .set 1
	;
	; Support EXIT (source dans Control.asm)
	;EXIT .set 1
	;
	; Support des structures de contrôle
	; ALL_TESTS .set 1
	;.define IF_THEN_ELSE
	;.define BEGIN_AGAIN
	;.define BEGIN_UNTIL
	;.define BEGIN_WHILE
	;.define DO_LOOP
	;.define DO_PLOOP
	;.define CASE_OF_ENDCASE
	;
	; PSEUDO_IF .set 1
	;
	AUTOSTART_SUPPORT .set 1
	;	.define AUTOSTART_FILE "STARTUP.DAT"
	;
	; Gestion des écrans
	QLOADING .set 1
	FOLLOW .set 1
	;.define BACKSLASH
	BACKSLASH_IMMEDIATE .set 1
	; CSLL .set 1
	; PLINE .set 1
	; DOTLINE .set 1
	; INDEX .set 1
	; LIST .set 1
	; TRIAD .set 1
	; THRU .set 1
	LOAD .set 1
	;
	OVERLAYS_SUPPORT .set 1
	;.define WITH_EXTERNAL_HELPERS
	;
	; OPCH, QTERM, CKEY et CEMIT nécessaires pour TERMINAL
	IOS_VOC .set 1
	;.define IOS_PRINTER
	;.define IOS_SERIAL
	;.define IOS_MINITEL
	;
	; INPUT .set 1
	; OUTPUT .set 1

	; CLS .set 1
	; GOTOXY .set 1

	;
	; Support editeur standard
	; EDITOR_VOC .set 1
	; WHERE .set 1
	; EDITOR_TEXT_LINE .set 1
	;.define EDITOR_SCRMOVE_SCRCOPY
	;
	; Jeu de la vie (démonstration)
	;.define LIFE_VOC
	;.define LIFE_DEMO
	;
	; Gestion du dictionnaire
	; FORGET .set 1
	; VLIST .set 1
	; VOC_LIST .set 1
	;
	;.define ROMend
	;

.endscope

; --------------------------------------------------------------
; Configuration pour TeleForth V1.2                   (Original)
; --------------------------------------------------------------
.scope TeleForth_V1
	VERSION_MAJ = 1
	VERSION_MIN = 2

	; Dictionnaire sans modification de casse
	DictCase .Set 0
	CaseSensitive .set 1

	Page05_Base = $0500

	;.undef COMPACT
	;.undef WITHOUT_FIGFORTH_BUG

	; Décompilateur
	DECOMPILER .set 1

	; Extensions sonores
	SOUNDS_VOC .set 1

	; Extensions graphiques
	GRAFX_VOC .set 1

	; SCRW et CURSOR nécessaires pour TERMINAL
	WINDOWS_VOC .set 1

	CLOCK .set 1
	WAIT .set 1

	; Support disque (Telestrat)
	; R/W nécessaire pour FLUSH et BLOCK
	STRATSED_MINIMAL .set 1
	; USING et XFILE nécessaires pour SCRMOVE et SCRCOPY
	; DOLLOAD et DOLSAVE nécessaires pour OVERLAYS et EXTERNAL
	; SALOSTORE nécessaire pour IOS_SERIAL et IOS_MINITEL
	STRATSED .set 1

	; Support disque (CH376)
	;.undef WITH_CH376
	; Necessaire pour support AUTOSTART
	;.undef CH376_Extended

	; Support des structures de contrôle
	ALL_TESTS .set 1
	;.define IF_THEN_ELSE
	;.define BEGIN_AGAIN
	;.define BEGIN_UNTIL
	;.define BEGIN_WHILE
	;.define DO_LOOP
	;.define DO_PLOOP
	;.define CASE_OF_ENDCASE

	PSEUDO_IF .set 1

	AUTOSTART_SUPPORT .set 1
;		.define AUTOSTART_FILE "FORTH.DAT"

	; Gestion des écrans
	QLOADING .set 1
	FOLLOW .set 1
	BACKSLASH .set 1
	CSLL .set 1
	PLINE .set 1
	DOTLINE .set 1
	INDEX .set 1
	LIST .set 1
	TRIAD .set 1
	THRU .set 1
	LOAD .set 1

	OVERLAYS_SUPPORT .set 1
	EXTERNAL_HELPERS .set 1

	; OPCH, QTERM, CKEY et CEMIT nécessaires pour TERMINAL
	IOS_VOC .set 1
	IOS_PRINTER .set 1
	IOS_SERIAL .set 1
	IOS_MINITEL .set 1

	INPUT .set 1
	OUTPUT .set 1

	; Support editeur standard
	EDITOR_VOC .set 1
	;.define WHERE
	EDITOR_TEXT_LINE .set 1
	EDITOR_SCRMOVE_SCRCOPY .set 1

	; Jeu de la vie (démonstration)
	LIFE_VOC .set 1
	LIFE_DEMO .set 1

	; Gestion du dictionnaire
	FORGET .set 1
	VLIST .set 1
	VOC_LIST .set 1

	ROMend .set 1

.endscope

; --------------------------------------------------------------

;.define With TeleForth_V1

; --------------------------------------------------------------

;.include .sprintf("%s.inc",.string(With))

;.if With::FORGET
;	.out .sprintf("Compilation TeleForth %d.%d",With::VERSION_MAJ, With::VERSION_MIN)
;.endif

.scope Included
	Config = 1
.endscope
