; Fichier (appels StratSed sauf XNOMFI: appe Telemon)
XOPEN  = $1A                                   ; Ouvre un fichier, nom dans BUFNOM ($0517-$0522), numéro logique dans FICNUM ($0548)
XCLOSE = $1D                                   ; Ferme le fichier FICNUM
XNOMFI = $24                                   ; (AY), longueur dans X --> BUFNOM (tient compte de l'extension par défaut). Retour X:0->longueur nulle, X:1->RAS (C:1->Jokers), X:2->modification du lecteur par défaut, X:>127->nom incorrect
XCOPY  = $38                                   ; Copie de fichiers, source dans BUFTRV ($0100-), cible dans BUFNOM, VSALO0: b7=O,b6=M, VSALO1: b7=N,b6=C
XDELN  = $4D                                   ; DEL
XDIRN  = $56                                   ; Catalogue, nom -> BUFNOM
XINITI = $5C                                   ; Initialiser, DRIVE: lecteur
XLOAD  = $62                                   ; Charger fichier BUFNOM, VSALO0: 00->rien de spécial, 40->afficher status, 80->forcer pas d'exécution, VSALO1: 00-> rien de spécial, 80->charger à l'adresse DESALO
XSAVE  = $6B                                   ; Sauver fichier BUFNOM, DESALO,FISALO,FTYPE, VSALO0: 00->SAVEO, 40->SAVEM, 80->SAVE, C0->SAVEU
XTRVNM = $7D                                   ; Chercher fichier BUFNOM, retour avec Z=1 si trouvé
XSVSEC = $8C                                   ; Ecrit un secteur DRIVE, PISTE, SECTEU, RWBUF
XSAY   = $8F                                   ; Ecrit secteur Y, piste A, DRIVE, RWBUF
XPRSEC = $A1                                   ; Lit secteur DRIVE, PISTE, SECTEU, RWBUF

; Buffer
XTSTBU = $56

; Clavier
XGOKBD = $52

; Sons
XSONPS = $40
XEPSG  = $41
XOUPS  = $42
XZAP   = $46
XSHOOT = $47
XEXPLO = $9C
XPING  = $9D

; Video
XTEXT  = $19
XHIRES = $1A
ZADCHA = $1D
XCOSCR = $34
XCSSCR = $35
XSCRSE = $36
XSCROH = $37
XSCROB = $38
XSCRNE = $39
XPAPER = $92
XINK   = $93
XCHAR  = $97
XSCHAR = $98

; Horloge
XCLCL  = $3D
XWRCLK = $3E

; Imprimante
XTSTLP = $1E
XLPRBI = $48
XHCSCR = $4A

; RS-232
XSDUMP = $5C
XSLOAD = $5E
XSSAVE = $5F
XSOUT  = $67

; Minitel
XHCVDT = $4B
XCONSO = $5D
XMLOAD = $60
XMSAVE = $61
XRING  = $62
XWCXFI = $63
XLIGNE = $64
XDECON = $65
XMOUT  = $66

