; ----------------------------------------------------------------------------
; Needs.inc
; ----------------------------------------------------------------------------
;				Ajout des dépendances
; ----------------------------------------------------------------------------


.scope Need
.endscope

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
	Need::MON .set 1
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
	With::CLS .set 1
	With::GOTOXY .set 1
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
	Need::MRKFROM .set 1
.endif

.ifdef With::BEGIN_AGAIN
	With::CONTROL_FLOW .set 1
	Need::MRKTO .set 1
	Need::BEGIN .set 1
	Need::AGAIN .set 1
.endif

.ifdef With::BEGIN_UNTIL
	With::CONTROL_FLOW .set 1
	Need::MRKTO .set 1
	Need::BEGIN .set 1
	Need::UNTIL .set 1
.endif

.ifdef With::BEGIN_WHILE
	With::CONTROL_FLOW .set 1
	Need::MRKFROM .set 1
	Need::MRKTO .set 1
	Need::BEGIN .set 1
	Need::WHILE .set 1
	Need::REPEAT .set 1
.endif

.ifdef With::DO_LOOP
	With::CONTROL_FLOW .set 1
	Need::MRKTO .set 1
	Need::DO .set 1
	Need::LOOP .set 1
.endif

.ifdef With::DO_PLOOP
	With::CONTROL_FLOW .set 1
	Need::MRKTO .set 1
	Need::DO .set 1
	Need::PLOOP .set 1
.endif

.ifdef With::CASE_OF_ENDCASE
	With::CONTROL_FLOW .set 1
	Need::MRKFROM .set 1
.endif


; ----------------------------------------------------------------------------
; Ajout des dépendances
; ----------------------------------------------------------------------------

Need::ABORT .set 1


.ifdef Need::ABORT
	Need::PABORT .set 1
.endif

.ifdef With::CH376
	Need::LOAD .set 1
.endif

.ifdef With::UPERCASE_FILENAME
	Need::UPPER .set 1
.endif

.ifdef With::UPPER
	Need::UPPER .set 1
.endif

.ifdef With::LOWER
	Need::LOWER .set 1
.endif

.ifndef With::DictCase
	.warning "DictCase non spécifié, valeur par defaut: 0"
	With::DictCase .set 0
.endif

.if With::CaseSensitive = 0
	.if With::DictCase = 0
		.warning "CaseSentive = 0 && DictCase = 0"

	.elseif With::DictCase =1
		Need::LOWER .set 1

	.elseif With::DictCase =2
		Need::UPPER .set 1

	.else
		.error .sprintf("Valeur incorrecte pour DictCase: %d", With::DictCase)
	.endif
.endif

.ifdef With::STRATSED
	Need::LOAD .set 1
.endif

.ifdef With::CSLL
	Need::CSLL .set 1
.endif

.ifdef With::QLOADING
	Need::QLOADING .set 1
.endif

.ifdef With::LOAD
	Need::LOAD .set 1
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
	Need::CSLL .set 1
	With::PLINE .set 1
	With::LIST .set 1
	With::DOTLINE .set 1
	With::WHERE .set 1
.endif

.ifdef With::FOLLOW
	Need::QLOADING .set 1
.endif

.ifdef With::BACKSLASH_IMMEDIATE
	With::BACKSLASH .set 1
.endif

.ifdef With::BACKSLASH
	Need::QLOADING .set 1
	Need::CSLL .set 1
.endif

.ifdef With::INDEX
	With::DOTLINE .set 1
	Need::QTERMSTOP .set 1
.endif

.ifdef With::TRIAD
	With::LIST .set 1
	Need::QTERMSTOP .set 1
.endif

.ifdef With::LIST
	With::DOTLINE .set 1
	Need::QTERMSTOP .set 1
.endif

.ifdef With::VLIST
	Need::QTERMSTOP .set 1
.endif

.ifdef With::DOTLINE
	With::PLINE .set 1
.endif

.ifdef With::PLINE
	Need::CSLL .set 1
.endif

.ifdef With::CLOCK
	Need::AYX .set 1
.endif

.ifdef With::GRAFX_VOC
	Need::AYX .set 1
.endif

.ifdef With::IOS_VOC
	Need::AYX .set 1
.endif

.ifdef With::SOUNDS_VOC
	Need::AYX .set 1
.endif

.ifdef With::STRATSED
	Need::AYX .set 1
.endif

.ifdef With::WINDOWS_VOC
	Need::AYX .set 1
.endif


.ifdef With::INPUT
	Need::PIO .set 1
.endif

.ifdef With::CLS
	Need::CLS .set 1
.endif

.ifdef With::GOTOXY
	Need::GOTOXY .set 1
.endif

.ifdef With::OUTPUT
	Need::PIO .set 1
.endif

.ifdef Need::PABORT
	Need::PIO .set 1
.endif

.ifdef Need::QTERMSTOP
	Need::PIO .set 1
.endif


.ifdef With::GRAFX_VOC
	Need::MON .set 1
.endif

.ifdef With::IOS_VOC
	Need::MON .set 1
.endif

.ifdef With::SOUNDS_VOC
	Need::MON .set 1
.endif

.ifdef With::STRATSED
	Need::MON .set 1
	Need::PIO .set 1
.endif

.ifdef With::WINDOWS_VOC
	Need::MON .set 1
.endif


.ifdef With::IOSExt_VOC
	Need::MONCOL .set 1
	Need::PIO .set 1
.endif

.ifdef With::GRAFX_VOC
	Need::MONCOL .set 1
.endif

.ifdef With::SOUNDS_VOC
	Need::MONCOL .set 1
.endif


.ifdef With::GRAFX_VOC
	Need::HRSCOL .set 1
.endif

.ifdef With::SOUNDS_VOC
	Need::HRSCOL .set 1
.endif

.ifdef With::OVERLAYS_SUPPORT
	Need::HIMEM .set 1
.endif


