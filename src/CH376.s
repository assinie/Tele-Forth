; ----------------------------------------------------------------------------
; Extensions pour le CH376

.ifdef With::CH376

	.ifndef Included::CH376_INC
		Included::CH376_INC = 1
		.out "Ajout du vocabulaire CH376"


		;---------------------------------------------------------------------------
		; Adresse de l'interface CH376
		;---------------------------------------------------------------------------
		ch376_command = $341
		ch376_data    = $340

		; ----------------------------------------------------------------------------
		; CH376
		; ----------------------------------------------------------------------------

		vocabulary "CH376",, immediate

		; ----------------------------------------------------------------------------
		; (read)
		; ----------------------------------------------------------------------------
		code "(read)", "Pread"
		.proc Pread_local
			lda #$01
			jsr SETUP	; Récupère l'adresse
			stx _XSAVE	; Sauvegarde car détruit par WaitResponse
		begin:
			lda #$27	; ReadUSB
			sta ch376_command
			lda ch376_data
			sta N+2	; Nombre de caractères à lire
			beq fin
		        ldy #$00	; Initialise Y (remarque: inutile la première fois)
		loop:
			lda ch376_data
			sta (N),y
			iny
			dec N+2
			bne loop

			clc		; Calcule l'adresse du caractère suivant pour la prochaine boucle
			tya
			adc N
			sta N
			bcc suite
			inc N+1
		suite:
			lda #$3b
			sta ch376_command
			lda #$22
			sta ch376_command
		;	lda ch376_data
			jsr _WaitResponse
			cmp #$1d
			beq begin
		fin:
			ldx _XSAVE	; Restaure X
			jmp NEXT
		.endproc

		; ----------------------------------------------------------------------------
		; (write)
		; ----------------------------------------------------------------------------
		code "(write)", "Pwrite"
		.proc Pwrite_local
			lda #$01
			jsr SETUP	; Récupère l'adresse
			stx _XSAVE	; Sauvegarde car détruit par WaitResponse
		begin:
			lda #$2d	; WriteRqData
			sta ch376_command
			lda ch376_data
			sta N+2	; Nombre de caractères à écrire
			beq fin
		        ldy #$00	; Initialise Y (remarque: inutile la première fois)
		loop:
			lda (N),y
			sta ch376_data
			iny
			dec N+2
			bne loop

			clc		; Calcule l'adresse du caractère suivant pour la prochaine boucle
			tya
			adc N
			sta N
			bcc suite
			inc N+1
		suite:
			lda #$3d	; ByteWrGo
			sta ch376_command
			lda #$22
			sta ch376_command
		;	lda ch376_data
			jsr _WaitResponse
			cmp #$1e
			beq begin
		fin:
			ldx _XSAVE	; Restaure X
			jmp NEXT
		.endproc

		;---------------------------------------------------------------------------
		; WaitResponse:
		; A voir si il faut preserver X et Y
		;
		; Entree:
		;
		; Sortie:
		; Z: 0 -> ACC: Status du CH376
		; Z: 1 -> Timeout
		; X,Y: Modifies
		;---------------------------------------------------------------------------
		.proc _WaitResponse
				LDY #$FF
			ZZZ009:
				LDX #$FF
			ZZZ010:
				LDA ch376_command
				BMI ZZZ011
				LDA #$22
				STA ch376_command
				LDA ch376_data
				RTS
			ZZZ011:
				DEX
				BNE ZZZ010
				DEY
				BNE ZZZ009
				RTS
		.endproc

		; ----------------------------------------------------------------------------
		; : ch376:<BUILDS C, DOES> C@ 0341 C! 0340 C@ ;
		; ----------------------------------------------------------------------------
		declare "ch376:", "ch376col"
		        .word DOCOL
		        .word BUILDS
		        .word CCOMMA
		        .word DOES
		DOch376col:
		        .word CAT
		        .word LIT
		        .word ch376_command
		        .word CSTORE
		        .word LIT
		        .word ch376_data
		        .word CAT
		        .word SEMIS

		; ----------------------------------------------------------------------------
		; : CH376chk: <BUILDS SWAP C, C, DOES> DUP C@ 341 C!
		; ----------------------------------------------------------------------------
		.if 0
			declare "ch376chk:", "ch376chkcol"
			        .word DOCOL
			        .word BUILDS
			        .word SWAP
			        .word CCOMMA
			        .word CCOMMA
			        .word DOES
			DOch376chkcol:
			        .word DUP
			        .word CAT
			        .word LIT
			        .word ch376_command
			        .word CSTORE
			.ifdef GetStatus
			        .word GetStatus
			.else
			        .word LIT
			        .word $22
			        .word LIT
			        .word $341
			        .word CSTORE
			        .word LIT
			        .word ch376_data
			        .word CAT
			.endif
			        .word SWAP
			        .word ONEP
			        .word CAT
			        .word EQUAL
			        .word SEMIS
		.endif

		; ----------------------------------------------------------------------------
		; : Exists 55 0341 C! 0340 C@ AA = ;
		; ( -- b )
		; ----------------------------------------------------------------------------
		code "Exists"
		.proc Exists_local
		        lda #$06
		        sta ch376_command
		        lda #$00
		        sta ch376_data
		        ldy ch376_data
		        cpy #$FF
		        bne fin
		        lda #$01
		fin:
		        jmp PUSH0A
		.endproc

		; ----------------------------------------------------------------------------
		; : SetUSB 15 0341 C! 6 0340 C! 0340 C@ ;
		; ( -- )
		; ----------------------------------------------------------------------------
		.ifdef CH376_FORTH
			declare "SetUSB"
			        .word DOCOL
			        .word LIT
			        .word $15
			        .word LIT
			        .word ch376_command
			        .word CSTORE
			        .word LIT
			        .word 6
			        .word LIT
			        .word ch376_data
			        .word CSTORE
			        .word LIT
			        .word ch376_data
			        .word CAT
			        .word SEMIS
		.else

			code "SetUSB"

				lda #$15
				sta ch376_command
				lda #$06
				sta ch376_data
			;	lda ch376_data
			;	jmp PUSH0A
			        jmp NEXT
		.endif

		; ----------------------------------------------------------------------------
		; OLD:
		; : SetFilename 2F 0341 C!   BL WORD HERE COUNT   0 DO DUP C@ 0340 C! 1+ LOOP DROP 0 0340 C! ;
		;
		; Utilisation: SetFilename FICHIER.FTH
		;
		; NEW:
		; : SetFilename 2F 0341 C!   0518 0C -TRAILING    0 DO DUP C@ 0340 C! 1+ LOOP DROP 0 0340 C! ;
		;
		; Utilisation LIT" FORTH.DAT" SetFilename
		;
		; ----------------------------------------------------------------------------
		declare "SetFilename"
		.proc SetFilename_local
		        .word DOCOL
		        .word LIT
		        .word $2F
		        .word LIT
		        .word ch376_command
		        .word CSTORE

			.ifdef CH376_OLD
			        .word BL
			        .word WORD
			        .word HERE
			        .word COUNT
			.else
				.word LIT
				.word bufnom+1
				.word LIT
				.word $0C
				.word DTRAILING
			.endif

		        .word LIT
		        .word $00
		        .word PDO
		ZZloop:
		        .word DUP
		        .word CAT
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word ONEP
		        .word PLOOP
			        .word ZZloop
		        .word DROP
		        .word LIT
		        .word $00
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word SEMIS
		.endproc

		; ----------------------------------------------------------------------------
		; 22 ch376: GetStatus
		; ----------------------------------------------------------------------------
		declare "GetStatus"
		        .word DODOES
		        .word DOch376col
		        .byte $22

		; ----------------------------------------------------------------------------
		; 31 ch376: Mount
		; ----------------------------------------------------------------------------
		declare "Mount"
		        .word DODOES
		        .word DOch376col
		        .byte $31

		; ----------------------------------------------------------------------------
		; : SetByteRdWr 0341 C! 0100 /MOD SWAP 0340 C! 0340 C! GetStatus ;
		; ----------------------------------------------------------------------------
		declare "SetByteRdWr"
		        .word DOCOL
		;        .word LIT
		;        .word $3A
		        .word LIT
		        .word ch376_command
		        .word CSTORE
		        .word LIT
		        .word $0100
		        .word SLMOD
		        .word SWAP
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word GetStatus
		        .word SEMIS

		; ----------------------------------------------------------------------------
		; : SetByteLocate 39 0341 C! 0100 /MOD SWAP 0340 C! 0340 C! 0 0340 OVER OVER C! C! GetStatus ;
		; ----------------------------------------------------------------------------
		declare "SetByteLocate"
		        .word DOCOL
		        .word LIT
		        .word $39
		        .word LIT
		        .word ch376_command
		        .word CSTORE
		        .word LIT
		        .word $0100
		        .word SLMOD
		        .word SWAP
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word LIT
		        .word $00
		        .word LIT
		        .word ch376_data
		        .word OVER
		        .word OVER
		        .word CSTORE
		        .word CSTORE
		        .word GetStatus
		        .word SEMIS

		; ----------------------------------------------------------------------------
		; : FileOpen 32 0341 C! GetStatus ;
		; ----------------------------------------------------------------------------
		declare "FileOpen"
		        .word DOCOL
		        .word LIT
		        .word $32
		        .word LIT
		        .word ch376_command
		        .word CSTORE
		        .word GetStatus

			.ifndef CH376_OLD
			;	0517 0548 C@ 1- 1 AND 0260 * 0B40 + 0D CMOVE ;
			        .word LIT
			        .word bufnom
				.word LIT
				.word ficnum
				.word CAT
				.word ONES
				.word ONE
				.word ANDforth
				.word LIT
				.word $0260
				.word STAR
				.word LIT
				.word $0B40
				.word PLUS
				.word LIT
				.word $0D
				.word CMOVE
			.endif
		        .word SEMIS



		; ----------------------------------------------------------------------------
		; FileCreate
		; ----------------------------------------------------------------------------
		declare "FileCreate"
		        .word DOCOL
		        .word LIT
		        .word $34
		        .word LIT
		        .word ch376_command
		        .word STORE
		        .word GetStatus
		        .word SEMIS

		; ----------------------------------------------------------------------------
		; : FileClose 36 0341 C! 0340 C! GetStatus ;
		; ----------------------------------------------------------------------------
		declare "FileClose"
		        .word DOCOL
		        .word LIT
		        .word $36
		        .word LIT
		        .word ch376_command
		        .word CSTORE
		        .word LIT
		        .word ch376_data
		        .word CSTORE
		        .word GetStatus
		        .word SEMIS

		; ----------------------------------------------------------------------------
		; ( ad bloc -- 1 | ad 0 )
		; : read B/BUF * SetByteLocate 14 = IF B/BUF 3A SetByteRdWr 1D = IF (read) 1 ELSE 0 THEN THEN ;
		; ----------------------------------------------------------------------------
		declare "read"
		.proc read_local
		        .word DOCOL
		        .word B_BUF
		        .word STAR
		        .word SetByteLocate
		        .word LIT
		        .word $14
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZend
		        .word B_BUF
		        .word LIT
		        .word $3A
		        .word SetByteRdWr
		        .word LIT
		        .word $1D
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZelse
		        .word Pread
		        .word ONE
		        .word BRANCH
		        .word ZZend
		ZZelse:
		        .word ZERO
		ZZend:
		        .word SEMIS
		.endproc

		.if 0
			; ----------------------------------------------------------------------------
			; : SetByteWrite 3C 0341 C! 0100 /MOD SWAP 0340 C! 0340 C! GetStatus ;
			; ----------------------------------------------------------------------------
			declare "SetByteWrite"
			        .word DOCOL
			        .word LIT
			        .word $3C
			        .word LIT
			        .word ch376_command
			        .word CSTORE
			        .word LIT
			        .word $0100
			        .word SLMOD
			        .word SWAP
			        .word LIT
			        .word ch376_data
			        .word CSTORE
			        .word LIT
			        .word ch376_data
			        .word CSTORE
			        .word GetStatus
			        .word SEMIS

		.endif

		; ----------------------------------------------------------------------------
		; ( ad bloc -- 1 | ad 0 )
		; : write B/BUF * SetByteLocate 14 = IF B/BUF 3C SetByteRdWr 14 = IF (write) 1 ELSE 0 THEN THEN ;
		; ----------------------------------------------------------------------------
		declare "write"
		.proc write_local
		        .word DOCOL
		        .word B_BUF
		        .word STAR
		        .word SetByteLocate
		        .word LIT
		        .word $14
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZend
		        .word B_BUF
		        .word LIT
		        .word $3C
		        .word SetByteRdWr
		        .word LIT
		        .word $14
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZelse
		        .word Pwrite
		        .word ONE
		        .word BRANCH
		        .word ZZend
		ZZelse:
		        .word ZERO
		ZZend:
		        .word SEMIS
		.endproc


		.ifdef CH376_Extended
			.out "Ajout des mots GetVersion, ByteRdGo, ReadUSB [CH376]"
			; ----------------------------------------------------------------------------
			; 1 ch376: GetVersion
			; ----------------------------------------------------------------------------
			declare "GetVersion"
			        .word DODOES
			        .word DOch376col
			        .byte $01

			; ----------------------------------------------------------------------------
			; : ByteRdGoB 0341 C! GetStatus ;
			; ----------------------------------------------------------------------------
			declare "ByteRdGo"
			        .word DOCOL
			        .word LIT
			        .word $3B
			        .word LIT
			        .word ch376_command
			        .word CSTORE
			        .word GetStatus
			        .word SEMIS

			; ----------------------------------------------------------------------------
			; 27 ch376: ReadUSB
			; ----------------------------------------------------------------------------
			declare "ReadUSB"
			        .word DODOES
			        .word DOch376col
			        .byte $27

		.endif

		; ----------------------------------------------------------------------------
		; Code récupéré de la version Forth-83
		; ( addr n -- )
		; ----------------------------------------------------------------------------
		.ifdef NEED_UPPER
			add_to_voc "FORTH"

			; ----------------------------------------------------------------------------
			; UPPER
			; ----------------------------------------------------------------------------
			code "UPPER"
			.proc UPPER_local
			        lda     #$02
			        jsr     SETUP
			        ldy     N
			L1459:
			        cpy     #$00
			        beq     L1468
			        dey
			        lda     (N+2),y
			        jsr     L146B
			        sta     (N+2),y
			        clv
			        bvc     L1459
			L1468:
			        jmp     NEXT

			L146B:
			        cmp     #$61
			        bcc     L1476
			        cmp     #$7B
			        bcs     L1476
			        sec
			        sbc     #$20
			L1476:
			        rts

			.endproc
		.endif

		.ifdef NEED_LOWER
			add_to_voc "FORTH"

			; ----------------------------------------------------------------------------
			; lower
			; ----------------------------------------------------------------------------
			code "lower", "LOWER"
			.proc lower_local
			        lda     #$02
			        jsr     SETUP
			        ldy     N
			L1459:
			        cpy     #$00
			        beq     L1468
			        dey
			        lda     (N+2),y
			        jsr     L146B
			        sta     (N+2),y
			        clv
			        bvc     L1459
			L1468:
			        jmp     NEXT

			L146B:
			        cmp     #$41
			        bcc     L1476
			        cmp     #$7B
			        bcs     L1476
			        clc
			        adc     #$20
			L1476:
			        rts
			.endproc

		.endif

		; ----------------------------------------------------------------------------
		; : FILENAME COUNT DUP 0C > 89 ?ERROR 0518 SWAP OVER 0D BLANKS CMOVE ;
		; ----------------------------------------------------------------------------
		declare "FILENAME"
		.proc FILENAME_local
		        .word DOCOL
		        .word COUNT

		; Conversion min/MAJ
		; Si on le fait ici, on modifie la source
		;        .word TWODUP
		;        .word UPPER

		        .word DUP
		        .word LIT
		        .word $0C
		        .word GREAT
		        .word LIT
		        .word $89
		        .word QERROR
		        .word LIT
		        .word bufnom+1
		        .word SWAP
		        .word OVER
		        .word LIT
		        .word $0D
		        .word BLANKS

			.ifdef With::UPERCASE_FILENAME
				.out "Force les noms fichiers en MAJUSCULE"
			        ; Pour conversion min/MAJ
			        .word TWODUP
			        .word TOR
			        .word TOR

			        .word CMOVE

			        ; Conversion min/MAJ
			        .word RFROM
			        .word RFROM
			        .word UPPER
			.else
			        .word CMOVE
			.endif

		        .word SEMIS
		.endproc

		; ----------------------------------------------------------------------------
		; : ?FILE FILENAME CH376 SetFilename2 FileOpen 14 = IF 0 FileClose
		;  DROP 1 ELSE 0 THEN ;
		; ----------------------------------------------------------------------------
		declare "?FILE", "QFILE"
		.proc QFILE_local
			.word DOCOL
		        .word FILENAME
		        .word SetFilename
		        .word FileOpen
		        .word LIT
		        .word $14
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZelse
		        .word ZERO
		        .word FileClose
		        .word DROP
		        .word ONE
		        .word BRANCH
		        .word ZZend
		ZZelse:
		        .word ZERO
		ZZend:
		        .word SEMIS
		.endproc

		.ifdef With::ARGV
			; ----------------------------------------------------------------------------
			;( argc -- adr len )
			;( argc -- adr 0 ) si argc > nombre d'arguments
			;
			;/!\ Pas de vérification de la validité de argc (doit être >=0)
			;: argv
			;	1+ >R (Sauvegarde argc )
			;
			;	58F ( 590 1 - ) 0 0 1
			;	R> 0
			;	DO
			;		DUP 0= IF ( Sortie prématurée, plus de paramètres )
			;				LEAVE ( -- 59A 0 1 0 )
			;			ELSE
			;				SWAP DROP + + BL ENCLOSE
			;			THEN
			;	LOOP
			;	IF >R + R> ELSE ( -- 59A 0 1 ) DROP  THEN ;
			; ----------------------------------------------------------------------------
			declare "ARGV"
			.proc ARGV_local
			        .word DOCOL
			        .word ONEP
			        .word TOR
			        .word LIT
			        .word $058F
			        .word ZERO
			        .word ZERO
			        .word ONE
			        .word RFROM
			        .word ZERO
			        .word PDO
			L16A6:
			        .word DUP
			        .word ZEQUAL
			        .word ZBRANCH
			        .word L16B4
			        .word LEAVE
			        .word BRANCH
			        .word L16C0
			L16B4:
			        .word SWAP
			        .word DROP
			        .word PLUS
			        .word PLUS
			        .word BL
			        .word ENCLOSE
			L16C0:
			        .word PLOOP
			        .word L16A6
			        .word ZBRANCH
			        .word L16D2
			        .word TOR
			        .word PLUS
			        .word RFROM
			        .word BRANCH
			        .word L16D4
			L16D2:
			        .word DROP
			L16D4:
			        .word SEMIS
			.endproc

		.endif

		; ----------------------------------------------------------------------------
		; STARTUP
		; ----------------------------------------------------------------------------
		.out "Ajout du mot STARTUP avec suppport CH376";
		declare "STARTUP"
		.proc STARTUP_local
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

		        .word   Exists
		        .word   ZEQUAL

		        .word   ZBRANCH
		        .word   LEA81
		        .word   LIT
		        .word   $88                                                             ; /?\ "Pas de STRATSED" à remplacer par: 8A->"Pas de lecteur"
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
				.out .sprintf("Ajout du support autostart (fichier: %s)", AUTOSTART_FILE)

				; L'existence du CH376 a déjà été vérifiée,

				; On vérifie que la clé est montée, dnas le cas contraire, on la monte
				; GetStaus 14 = DUP 0= IF DROP SetUSB Mount DROP GetStatus 14 = THEN IF 2 ARGV ...
				; [--
			        .word GetStatus
			        .word LIT
			        .word $0014
			        .word EQUAL
			        .word DUP
			        .word ZEQUAL
			        .word ZBRANCH
			        .word CleOK
			        .word DROP
				; --]

				; - TEST -
				; Si on suppose que la cle n'a pas été montée
				; Après Mount, le répertoire courant est "/"
				.word SetUSB
				.word Mount
				.word DROP								; Modifier 'Mount' pour qu'il ne fasse pas le 340 C@ mais GetStatus
				.word GetStatus
				.word LIT
				.word $14
				.word EQUAL
			CleOK:
				.word ZBRANCH
				.word LEAFF

				; Si on ne fait pas le Mount:
				;        Si on n'a pas exécuter au préalable au moins une commande Orix qui utilise la clé (ls par exemple)
				;          alors la clé n'est pas montée, il faudra donc faire un Mount pour que les accès disque fonctionne
				;        Sinon, si on démarre le Forth par une commande 'bank n', le répertoire du CH376 courant est correct (ie celui de Orix)
				;          si on démarre le Forth par un commande dans /BIN alors le répertoire courant du CH376 est /BIN et non celui de Orix

				; Si le Mount n'a pas été fait, GetStatus renvoie $5F (ABORT)

				.ifdef With::ARGV
					;        2 argv DUP IF DUP HERE C! HERE 1+ SWAP CMOVE HERE ELSE 2DROP LIT" STARTUP.DAT" THEN ;

					; - TEST -
				        ; 2 si on lance le Forth par: bank 3 <nom_fichier>
				        ; 0 (ou1?) si on le lance par: <nom_fichier>
				        ; Si 0 (ou 1?) et qu'on lance le Forth par la commande 'bank 3', on essaye de charger le fichier 'bank' depuis le répertoire courant de Orix
					;        .word TWO
				        .word ZERO

				        .word ARGV
				        .word DUP
				        .word ZBRANCH
				        .word Largv_else
				        .word DUP
				        .word HERE
				        .word CSTORE
				        .word HERE
				        .word ONEP
				        .word SWAP
				        .word CMOVE
				        .word HERE
				        .word BRANCH
				        .word Largv_endif

				Largv_else:
				        .word TWODROP
				.endif

			        .word   PLITQ

			        .byte   .strlen(AUTOSTART_FILE)
			        .byte   AUTOSTART_FILE

			Largv_endif:
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
			.endif
			LEAFF:
			;        .word   LIT
			;        .word   $8A
			;        .word   MESSAGE
			        .word   SEMIS
		.endproc

		;.ifdef CH376_Extended
		.ifdef With::AUTOSTART_SUPPORT
			.out "Ajout des mots (DOS), DOS [CH376]"
			add_to_voc "CH376"
			; ----------------------------------------------------------------------------
			; : (DOS) DUP XOPEN = IF DROP SetFilename FileOpen 14 = 0= 81
			;       ELSE DUP XSAVE = IF DROP SetFilename FileCreate DROP (XSAVE) 82
			;            ELSE DUP XLOAD = IF DROP SetFilename FileOpen DROP (XLOAD) 82
			;                 ELSE DROP 1 1C
			;                 THEN
			;            THEN
			;       THEN ;
			;
			; Si on veut une compatibilité avec (DOS) du Stratsed:
			; : (DOS) DUP XOPEN IF DROP FileOpen 14 = 1 *
			;       ELSE DROP 8 ;
			;
			; /?\ A définir comme DEFER (DOS)
			; ----------------------------------------------------------------------------
			declare "(DOS)", "PDOS"
			.proc PDOS_local
			        .word DOCOL
			        .word DUP
			        .word LIT
			        .word XOPEN
			        .word EQUAL
			        .word ZBRANCH
			        .word ZZsave
			        .word DROP
			        .word SetFilename
			        .word FileOpen
			        .word LIT
			        .word $14
			        .word EQUAL
			        .word ZEQUAL
			        .word LIT
			        .word $81
			        .word BRANCH
			        .word ZZend

			ZZsave:
			        .word DUP
			        .word LIT
			        .word XSAVE
		        .word EQUAL
			        .word ZBRANCH
			        .word ZZload
			        .word DROP
			        .word SetFilename

			        ; /!\ Attention pas de vérification de l'existence du fichier
			        ; le fichier sera écrasé si il existe déjà
			        .word FileCreate
			        ; /!\ Pas de vérification du code de retoure
			        .word DROP

			        .word PXSAVE
			        .word LIT
			        .word $82
			        .word BRANCH
			        .word ZZend

			ZZload:
			        .word DUP
			        .word LIT
			        .word XLOAD
			        .word EQUAL
			        .word ZBRANCH
			        .word ZZelse
			        .word DROP
			        .word SetFilename
			        .word FileOpen
			        .word DROP
			        .word PXLOAD
			        .word LIT
			        .word $82
			        .word BRANCH
			        .word ZZend

			ZZelse:
			        .word DROP
			        .word ONE
			        .word LIT
			        .word $1c
			ZZend:
			        .word SEMIS
			.endproc

			; ----------------------------------------------------------------------------
			; DOS
			; ----------------------------------------------------------------------------
			add_to_voc "FORTH"
			declare "DOS"
			        .word DOCOL
			        .word PDOS
			        .word QERROR
			        .word SEMIS

		.endif

		; ----------------------------------------------------------------------------
		; ( bufad bloc r/w -- )
		; Avec bloc >= 1 (/!\ Pas de vérification)
		; : R/W IF 1- read 0= IF B/BUF BLANKS THEN ELSE 1- write . THEN ;
		; ----------------------------------------------------------------------------
		declare "R/W", "RSLW"
		.proc RSLW_local
		        .word DOCOL
		        .word ZBRANCH
		        .word ZZelse
		; - TEST -
		; Pour le calcul de l'offset dans le fichier
		; on soustrait 1 au n° de bloc pour commencer à 0
		;        .word ONES

		        .word read
		        .word ZEQUAL
		        .word ZBRANCH
		        .word ZZthen
		        .word B_BUF
		        .word BLANKS
		ZZthen:
		        .word BRANCH
		        .word ZZend
		ZZelse:
		; - TEST -
		; Pour le calcul de l'offset dans le fichier
		; on soustrait 1 au n° de bloc pour commencer à 0
		;        .word ONES

		        .word write
		        .word DOT
		ZZend:
		        .word SEMIS
		.endproc


		;---------------------------------------------------------------------------
		;
		; Codes d'erreur du CH376
		;
		;---------------------------------------------------------------------------
		.define SUCCESS $12
		.define INT_SUCCESS $14
		.define INT_DISK_READ $1D
		.define INT_DISK_WRITE $1E
		.define ABORT $5F

		add_to_voc "CH376"

		;---------------------------------------------------------------------------
		; (XLOAD)
		;---------------------------------------------------------------------------
		code "(XLOAD)", "PXLOAD"
		.proc PXLOAD_local
		; Entrée: desalo contient l'adresse de chargement
		; Sortie: 0 -> Ok, 2-> Erreur ($80+2-> Erreur Disque)
		;         fisalo pointe sur l'octet suivant le dernier octet lu
		;
		; Faire 'FILENAME SetFilename FileOpen' avant l'appel à XLOAD
		;
		; : test BL WORD HERE FILENAME CH376 SetFilename FileOpen 014 = IF XLOAD ;
		; ou
		; : test BL WORD HERE ?FILE IF CH376 FileOpen DROP XLOAD ;
		;
		;  HEX 2000 052D ! test OVERLAY.SRC XLOAD
		;
		;
		;    jsr _SetFilename
		;    jsr _FileOpen
		;    cmp #$14
		;    bne Error
		    lda #$ff
		    tay
		    jsr SetByteRead
		    bne Error

		    lda desalo
		    sta $d0                                                                    ; /!\ Vérifier que $D0-D1 n'est pas utilisé
		    lda desalo+1
		    sta $d0+1

		ZZ0002:
		    jsr ReadUSBData2
		;    bcc ReadNextChunk
		; Si on arrive ici, RdUSBData0 à indiqué qu'il n'y avait plus rien à lire
		; Il faudrait peut-être lire le statut pour voir si il y a eu une erreur
		; et sortir de toute façon
		ReadNextChunk:
		    jsr ByteRdGo
		    beq ZZ0002
		    ; Sauvegarde du code de fin
		    pha
		    ; Fermeture du fichier sans modification
		    lda #$00
		    jsr _FileClose
		    ; Vérifier le code de retour pour la fermeture? ($14 -> Z=1 -> Ok)

		    lda $d0
		    sta fisalo
		    lda $d0+1
		    sta fisalo+1

		    pla
		    cmp #INT_SUCCESS
		    beq PXLOAD_Fin
		    lda #$02
		    .byte $2c

		PXLOAD_Fin:
		    lda #$00
		    jmp PUSH0A

		ReadUSBData2:
		    stx _XSAVE
		    sec
		    ; RdUSBData0
		    lda #$27
		    sta ch376_command
		    ldx ch376_data
		    beq ZZZ002
		    ldy #$00
		ZZZ003:
		    lda ch376_data
		    sta ($d0),y
		    iny
		    dex
		    bne ZZZ003
		    ; Ajuste le pointeur $D0-$D1
		    clc
		    tya
		    adc $d0
		    sta $d0
		    bcc *+4
		    inc $d1
		    clc
		ZZZ002:
		    ldx _XSAVE
		    rts

		Error:
		    lda #$02
		    jmp PUSH0A
		.endproc

		; ------------------------------------------------------------------------------
		; (XSAVE)
		; ------------------------------------------------------------------------------
		code "(XSAVE)", "PXSAVE"
		.proc PXSAVE_local
		; Faire FILENAME SetFilename FileCreate avant l'appel
		; et mettre à jour desalo et fisalo
		    stx     AYX_addr+2                                                         ; Sauvegarde X ici parce que SetByteWrite utilise _XSAVE
		    lda desalo
		    sta $d0
		    lda desalo+1
		    sta $d1

		    ; Calcul de la taille de la zone
		    sec
		    lda fisalo
		    sbc desalo
		;    tax
		    pha
		    lda fisalo+1
		    sbc desalo+1
		    tay
		    pla
		    jsr SetByteWrite
		    ; bne erreur
		    jsr WriteRqData
		    tax

		    ldy #$00
		loop:
		    lda ($d0),y
		    sta ch376_data
		    iny
		    dex
		    bne loop

		;    Verifier GetStatus == $51?, Non-> erreur

		    ; Ajuste le pointeur $D0-$D1
		    clc
		    tya
		    adc $d0
		    sta $d0
		    bcc *+4
		    inc $d1

		    jsr ByteWrGo
		    bcs erreur2
		;    jsr WriteRqData
		    tax
		    beq PXSAVE_Fin
		    bne loop-2
		    ; Si on arrive ici
		    ; $d0 est revenu à 0!!!
		erreur1:
		    ldx #$01
		    .byte $2c

		erreur2:
		    cmp #INT_SUCCESS
		    beq PXSAVE_Fin
		    tax
		    .byte $2c

		PXSAVE_Fin:
		    ldx #$00

		    lda #$01
		    jsr _FileClose
		    ; Vérifier le code de retour de FileClose?

		    txa
		    ldx     AYX_addr+2
		    jmp PUSH0A
		;    rts


		ByteWrGo:
		    ; ByteWrGo renvoie:
		    ;    - INT_DISK_WRITE si il faut encore écrire
		    ;    - INT_SUCCESS si on a atteint la valeur indiquée par le SetByteWrite
		    lda #$3d
		    sta ch376_command
		    jsr _WaitResponse
		    cmp #INT_DISK_WRITE
		    beq WriteRqData
		    sec
		    rts

		WriteRqData:
		    lda #$2d
		    sta ch376_command
		    lda ch376_data
		    clc
		    rts

		.endproc


		; ==============================================================================

		;---------------------------------------------------------------------------
		; 28 Octets
		;---------------------------------------------------------------------------
		_SetFilename:
				; Copie la longueur de la chaine dans X
		        stx _XSAVE
			tax

			lda #$2f
			sta ch376_command
	;		sta ch376_data		; Pour ouverture de '/'
			ldy #$ff
		ZZZ004:
			iny
	;		lda (bufnom+1),y
			lda bufnom+1,y
			sta ch376_data
	;		dex
			bne ZZZ004

			; Ajoute le '\0' final
			lda #$00
			sta ch376_data
		        ldx _XSAVE
			rts

		;---------------------------------------------------------------------------
		; 32 Octets
		;---------------------------------------------------------------------------
		_Mount:
			LDA #$31
			.byte $2c

		_FileOpen:
			LDA #$32
			.byte $2c

		_FileCreate:
			LDA #$34

		CH376_Cmd:
			STA ch376_command

		CH376_CmdWait:
		        stx _XSAVE
			JSR _WaitResponse
			ldx _XSAVE
			CMP #INT_SUCCESS
			RTS

		;---------------------------------------------------------------------------
		; ACC: Flag mise à jour (0: Non, 1: Oui)
		_FileClose:
			LDY #$36
			STY ch376_command
			STA ch376_data

			CLC									; Saut inconditionel
			BCC CH376_CmdWait


		;---------------------------------------------------------------------------
		; 28 Octets
		;---------------------------------------------------------------------------
		SetByteRead:
			PHA
			LDA #$3A
		;	.byte $2c
			bne CH376_Cmd2

		SetByteWrite:
			pha
			lda #$3C

		CH376_Cmd2:
			STA ch376_command
			PLA
			STA ch376_data
			STY ch376_data

		CH376_CmdWait2:
		        stx _XSAVE
			JSR _WaitResponse
			ldx _XSAVE
			CMP #INT_DISK_READ
			RTS

		;---------------------------------------------------------------------------
		ByteRdGo:
			LDA #$3B
			STA ch376_command
			BNE CH376_CmdWait2


		;---------------------------------------------------------------------------
		; SALO!
		;---------------------------------------------------------------------------
		add_to_voc "FORTH"
		declare "SALO!", "SALOSTORE"
		        .word DOCOL
		        .word LIT
		        .word vasalo0
		        .word STORE
		        .word LIT
		        .word fisalo
		        .word STORE
		        .word LIT
		        .word desalo
		        .word STORE
		        .word SEMIS

		;---------------------------------------------------------------------------
		; $SAVE
		;---------------------------------------------------------------------------
		declare "$SAVE", "DOLSAVE"
		        .word DOCOL
		        .word ZERO
		        .word SALOSTORE
		        .word LIT
		        .word $40
		        .word LIT
		        .word ftype
		        .word CSTORE

		        ; On ouvre le fichier
		        ; /!\ Il faut au moins avoir fait un FILENAME avant
		        ; pour mettre le bom du fichier en $517...
		;        .word SetFilename
		;        .word FileOpen
		;        .word DROP
		;
		;        .word PXSAVE
		        .word LIT
		        .word XSAVE
		        .word DOS
		        .word SEMIS

		;---------------------------------------------------------------------------
		; $LOAD
		;---------------------------------------------------------------------------
		declare "$LOAD", "DOLLOAD"
		        .word DOCOL
		        .word ZERO
		        .word LIT
		        .word $8080
		        .word SALOSTORE

		        ; On ouvre le fichier
		        ; /!\ Il faut au moins avoir fait un FILENAME avant
		        ; pour mettre le bom du fichier en $517...
		;        .word SetFilename
		;        .word FileOpen
		;        .word DROP
		;
		;        .word PXLOAD
		        .word LIT
		        .word XLOAD
		        .word DOS
		        .word LIT
		        .word fisalo
		        .word AT
		        .word SEMIS

		;---------------------------------------------------------------------------
		; : ?DIR FILENAME CH376 SetFilename FileOpen ( DUP 14 = IF FileClose THEN 41 = ) 41 = 0 FileClose DROP ;
		; ( adr -- b )
		; b:1 -> ok
		; b:0 -> erreur
		;---------------------------------------------------------------------------
		declare "?DIR", "QDIR"
		.proc QDIR_local
		        .word DOCOL
		        .word FILENAME
		        .word SetFilename
		        .word FileOpen
		        .word LIT
		        .word $41
		        .word EQUAL
		        ; [-- A voir si le FileClose est nécessaire
		        ; .word FileClose
		        ; .word DROP
		        ; --]
		        .word SEMIS
		.endproc

		;---------------------------------------------------------------------------
		; cd <path>
		; : cd TIB @ IN @ + C@ ASCII / = IF LIT" /" ?DIR 0= 82 ?ERROR THEN BEGIN ASCII / WORD HERE 1+ C@ WHILE HERE ?DIR 0= 91 ?ERROR REPEAT CR ;
		;---------------------------------------------------------------------------
		declare "CD"
		.proc CD_local
		        .word DOCOL
		        .word TIB
		        .word AT
		        .word IN
		        .word AT
		        .word PLUS
		        .word CAT
		        .word LIT
		        .word '/'
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZ_Then
		        .word PLITQ
		        .byte $01
		        .byte '/'
		        .word QDIR
		        .word ZEQUAL
		        .word LIT
		        .word $82
		        .word QERROR
		ZZ_Then:
		ZZ_Begin:
		        .word LIT
		        .word '/'
		        .word WORD
		        .word HERE
		        .word ONEP
		        .word CAT
		        .word ZBRANCH
		        .word ZZ_Repeat
		; WHILE
		        .word HERE
		        .word QDIR
		        .word ZEQUAL
		        .word LIT
		        .word $91
		        .word QERROR
		        .word BRANCH
		        .word ZZ_Begin
		ZZ_Repeat:
		        .word CR
		        .word SEMIS
		.endproc

		;---------------------------------------------------------------------------
		; (CD)
		;
		; addr : Adresse d'une chaine terminée par un \0
		;
		; addr cd
		;
		; DUP C@ ASCII / = IF
		;	LIT" /" ?DIR 0= 82 ?ERROR
		; THEN
		; BEGIN
		;	ASCII / ENCLOSE DUP
		; WHILE
		;	( adresse_buffer offset_debut longueur offset_suivant )
		;	>R
		;	OVER - HERE C!
		;	OVER + HERE 1+ HERE C@  ( 2DUP 1+ ERASE ) CMOVE
		;	R> +
		;	HERE ?DIR 0= 91 ?ERROR
		; REPEAT
		; 2DROP 2DROP
		;---------------------------------------------------------------------------
		declare "(CD)", "PCD"
		.proc PCD_local
		        .word DOCOL
		        .word DUP
		        .word CAT
		        .word LIT
		        .word '/'
		        .word EQUAL
		        .word ZBRANCH
		        .word ZZ_Then
		        .word PLITQ
		        .byte $01
		        .byte "/"
		        .word QDIR
		        .word ZEQUAL
		        .word LIT
		        .word $82
		        .word QERROR
		ZZ_Then:
		ZZ_Begin:
		        .word LIT
		        .word '/'
		        .word ENCLOSE
		        .word DUP
		        .word ZBRANCH
		        .word ZZ_Repeat
		; WHILE
		;	>R
		;	OVER - HERE C!
		;	OVER + HERE 1+ HERE C@  ( 2DUP 1+ ERASE ) CMOVE
		;	R> +
		;	HERE ?DIR 0= 91 ?ERROR

		        .word TOR
		        .word OVER
		        .word SUB
		        .word HERE
		        .word CSTORE
		        .word OVER
		        .word PLUS
		        .word HERE
		        .word ONEP
		        .word HERE
		        .word CAT

		        .word TWODUP
		        .word ONEP
		        .word ERASE

		        .word CMOVE
		        .word RFROM
		        .word PLUS
		        .word HERE
		        .word QDIR
		        .word ZEQUAL
		        .word LIT
		        .word $91
		        .word QERROR
		        .word BRANCH
		        .word ZZ_Begin
		ZZ_Repeat:
			.word TWODROP
			.word TWODROP
			.word SEMIS

		.endproc

	.else
		.out "Ajout entête du vocabulaire CH376"

		; ----------------------------------------------------------------------------
		; CH376
		; ----------------------------------------------------------------------------
		vocabulary_pfa "CH376"

	.endif

.endif
