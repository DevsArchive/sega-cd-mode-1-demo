; ---------------------------------------------------------------------------
; Mega Drive Framework
; By Devon 2022
; ---------------------------------------------------------------------------
; Mega CD definitions
; ---------------------------------------------------------------------------

	include	"_config.i"
	include	"macros.i"
	include	"axm68k.i"

; ---------------------------------------------------------------------------
; Memory map
; ---------------------------------------------------------------------------

; Program RAM
PRGRAM		EQU	$000000				; Program RAM
PRGRAM_END	EQU	$07FFFF				; End of Program RAM
PRGRAM_SIZE	EQU	(PRGRAM_END+1)-PRGRAM		; Size of Program RAM
SPSTART		EQU	PRGRAM+$6000			; System program start

; Word RAM
WORDRAM2M	EQU	$080000				; Word RAM (2M)
WORDRAM2M_END	EQU	$0BFFFF				; End of Word RAM (2M)
WORDRAM2M_SIZE	EQU	(WORDRAM2M_END+1)-WORDRAM2M	; Size of Word RAM (2M)
WORDRAM1M	EQU	$0C0000				; Word RAM (2M)
WORDRAM1M_END	EQU	$0DFFFF				; End of Word RAM (2M)
WORDRAM1M_SIZE	EQU	(WORDRAM1M_END+1)-WORDRAM1M	; Size of Word RAM (2M)

; PCM
PCMREGS		EQU	$FF0001				; PCM registers base
PCMENV		EQU	PCMREGS+($0000*2)		; PCM volume
PCMPAN		EQU	PCMREGS+($0001*2)		; PCM panning
PCMFDL		EQU	PCMREGS+($0002*2)		; PCM frequency low
PCMFDH		EQU	PCMREGS+($0003*2)		; PCM frequency high
PCMLSL		EQU	PCMREGS+($0004*2)		; PCM loop address low
PCMLSH		EQU	PCMREGS+($0005*2)		; PCM loop address high
PCMST		EQU	PCMREGS+($0006*2)		; PCM start address high
PCMCTRL		EQU	PCMREGS+($0007*2)		; PCM control
PCMONOFF	EQU	PCMREGS+($0008*2)		; PCM on/off control
PCMADDR		EQU	PCMREGS+($0010*2)		; PCM sample address
PCMDATA		EQU	PCMREGS+($1000*2)		; PCM sample data

; Registers
MCDREGS		EQU	$FFFF8000			; Registers base

; Initialization
LEDSTATUS	EQU	MCDREGS+0			; LED status
CPURESET	EQU	MCDREGS+1			; Reset flag
VERSION		EQU	MCDREGS+1			; Version
PROTECT		EQU	MCDREGS+2			; Program RAM write protect
MEMMODE		EQU	MCDREGS+3			; Memory mode

; CDC
CDCMODE		EQU	MCDREGS+4			; CDC mode
CDCREGADDR	EQU	MCDREGS+5			; CDC register address
CDCREGDATA	EQU	MCDREGS+6			; CDC register data
CDCDATA		EQU	MCDREGS+8			; CDC read data
CDCDMA		EQU	MCDREGS+$A			; CDC DMA address
STOPWATCH	EQU	MCDREGS+$C			; Stop watch

; Communication (Main CPU)
MAINFLAG	EQU	MCDREGS+$E			; Main CPU flag
MAINCOM0	EQU	MCDREGS+$10			; Communication command 0
MAINCOM0H	EQU	MAINCOM0
MAINCOM0L	EQU	MAINCOM0+1
MAINCOM1	EQU	MCDREGS+$12			; Communication command 1
MAINCOM1H	EQU	MAINCOM1
MAINCOM1L	EQU	MAINCOM1+1
MAINCOM2	EQU	MCDREGS+$14			; Communication command 2
MAINCOM2H	EQU	MAINCOM2
MAINCOM2L	EQU	MAINCOM2+1
MAINCOM3	EQU	MCDREGS+$16			; Communication command 3
MAINCOM3H	EQU	MAINCOM3
MAINCOM3L	EQU	MAINCOM3+1
MAINCOM4	EQU	MCDREGS+$18			; Communication command 4
MAINCOM4H	EQU	MAINCOM4
MAINCOM4L	EQU	MAINCOM4+1
MAINCOM5	EQU	MCDREGS+$1A			; Communication command 5
MAINCOM5H	EQU	MAINCOM5
MAINCOM5L	EQU	MAINCOM5+1
MAINCOM6	EQU	MCDREGS+$1C			; Communication command 6
MAINCOM6H	EQU	MAINCOM6
MAINCOM6L	EQU	MAINCOM6+1
MAINCOM7	EQU	MCDREGS+$1E			; Communication command 7
MAINCOM7H	EQU	MAINCOM7
MAINCOM7L	EQU	MAINCOM7+1

; Communication (Sub CPU)
SUBFLAG		EQU	MCDREGS+$F			; Sub CPU flag
SUBCOM0		EQU	MCDREGS+$20			; Communication status 0
SUBCOM0H	EQU	SUBCOM0
SUBCOM0L	EQU	SUBCOM0+1
SUBCOM1		EQU	MCDREGS+$22			; Communication status 1
SUBCOM1H	EQU	SUBCOM1
SUBCOM1L	EQU	SUBCOM1+1
SUBCOM2		EQU	MCDREGS+$24			; Communication status 2
SUBCOM2H	EQU	SUBCOM2
SUBCOM2L	EQU	SUBCOM2+1
SUBCOM3		EQU	MCDREGS+$26			; Communication status 3
SUBCOM3H	EQU	SUBCOM3
SUBCOM3L	EQU	SUBCOM3+1
SUBCOM4		EQU	MCDREGS+$28			; Communication status 4
SUBCOM4H	EQU	SUBCOM4
SUBCOM4L	EQU	SUBCOM4+1
SUBCOM5		EQU	MCDREGS+$2A			; Communication status 5
SUBCOM5H	EQU	SUBCOM5
SUBCOM5L	EQU	SUBCOM5+1
SUBCOM6		EQU	MCDREGS+$2C			; Communication status 6
SUBCOM6H	EQU	SUBCOM6
SUBCOM6L	EQU	SUBCOM6+1
SUBCOM7		EQU	MCDREGS+$2E			; Communication status 7
SUBCOM7H	EQU	SUBCOM7
SUBCOM7L	EQU	SUBCOM7+1

; Interrupt
INT3TIME	EQU	MCDREGS+$30			; Timer interrupt time
INTMASK		EQU	MCDREGS+$32			; Interrupt mask

; CDD
CDFADER		EQU	MCDREGS+$34			; CD fader
CDDTYPE		EQU	MCDREGS+$36			; CDD data type
CDDCTRL		EQU	MCDREGS+$37			; CDD control
CDDSTAT0	EQU	MCDREGS+$38			; CDD receive status 0
CDDSTAT1	EQU	MCDREGS+$39			; CDD receive status 1
CDDSTAT2	EQU	MCDREGS+$3A			; CDD receive status 2
CDDSTAT3	EQU	MCDREGS+$3B			; CDD receive status 3
CDDSTAT4	EQU	MCDREGS+$3C			; CDD receive status 4
CDDSTAT5	EQU	MCDREGS+$3D			; CDD receive status 5
CDDSTAT6	EQU	MCDREGS+$3E			; CDD receive status 6
CDDSTAT7	EQU	MCDREGS+$3F			; CDD receive status 7
CDDSTAT8	EQU	MCDREGS+$40			; CDD receive status 8
CDDSTAT9	EQU	MCDREGS+$41			; CDD receive status 9
CDDCMD0		EQU	MCDREGS+$42			; CDD transfer command 0
CDDCMD1		EQU	MCDREGS+$43			; CDD transfer command 1
CDDCMD2		EQU	MCDREGS+$44			; CDD transfer command 2
CDDCMD3		EQU	MCDREGS+$45			; CDD transfer command 3
CDDCMD4		EQU	MCDREGS+$46			; CDD transfer command 4
CDDCMD5		EQU	MCDREGS+$47			; CDD transfer command 5
CDDCMD6		EQU	MCDREGS+$48			; CDD transfer command 6
CDDCMD7		EQU	MCDREGS+$49			; CDD transfer command 7
CDDCMD8		EQU	MCDREGS+$4A			; CDD transfer command 8
CDDCMD9		EQU	MCDREGS+$4B			; CDD transfer command 9

; Font
FONTCOLOR	EQU	MCDREGS+$4C			; Font color
FONT1BPP	EQU	MCDREGS+$4E			; Input 1BPP font data
FONT4BPP0	EQU	MCDREGS+$50			; Output 4BPP font data (0)
FONT4BPP1	EQU	MCDREGS+$52			; Output 4BPP font data (1)
FONT4BPP2	EQU	MCDREGS+$54			; Output 4BPP font data (2)
FONT4BPP3	EQU	MCDREGS+$56			; Output 4BPP font data (3)

; Graphics
GFXON		EQU	MCDREGS+$58			; Graphics operation process flag
GFXSIZE		EQU	MCDREGS+$59			; Graphics data size
STAMPMAP	EQU	MCDREGS+$5A			; Stamp map address
IMGVSZTILE	EQU	MCDREGS+$5C			; Image buffer vertical tile size
IMGBUFFER	EQU	MCDREGS+$5E			; Image buffer address
IMGOFFSET	EQU	MCDREGS+$60			; Image buffer offset
IMGHSIZE	EQU	MCDREGS+$62			; Image buffer horizontal pixel size
IMGVSIZE	EQU	MCDREGS+$64			; Image buffer vertical pixel size
TRACETBL	EQU	MCDREGS+$66			; Trace table address

; Subcode
SUBADDR		EQU	MCDREGS+$68			; Subcode address
SUBDATA		EQU	MCDREGS+$100			; Subcode buffer area
SUBDATA_END	EQU	MCDREGS+$17F			; End of subcode buffer area
SUBDATA_SIZE	EQU	(SUBDATA_END+1)-SUBDATA		; Size of subcoe buffer area

; ---------------------------------------------------------------------------
; BIOS function code
; ---------------------------------------------------------------------------

; Music
MSCSTOP		EQU	$02				; Stop music
MSCPAUSEON	EQU	$03				; Pause music
MSCPAUSEOFF	EQU	$04				; Unpause music
MSCSCANFF	EQU	$05				; Fast forward music
MSCSCANFR	EQU	$06				; Fast reverse music
MSCSCANOFF	EQU	$07				; Restore music playback speed
MSCPLAY		EQU	$11				; Play music and subsequent tracks
MSCPLAY1	EQU	$12				; Play music track
MSCPLAYR	EQU	$13				; Loop music track
MSCPLAYT	EQU	$14				; Play music at time
MSCSEEK		EQU	$15				; Seek to music track
MSCSEEK1	EQU	$19				; Seek to music track and play
MSCSEEKT	EQU	$16				; Seek to music at time

; Drive
DRVOPEN		EQU	$0A				; Open CD drive
DRVINIT		EQU	$10				; Close CD drive and read TOC

; CD-ROM
ROMPAUSEON	EQU	$08				; Stop reading into CDC
ROMPAUSEOFF	EQU	$09				; Resume reading into CDC
ROMREAD		EQU	$17				; Begin reading sectors
ROMSEEK		EQU	$18				; Seek to sector
ROMREADN	EQU	$20				; Read number of sectors
ROMREADE	EQU	$21				; Read up to sector

; BIOS
CDBCHK		EQU	$80				; Get status of last command
CDBSTAT		EQU	$81				; Get BIOS status
CDBTOCWRITE	EQU	$82				; Write TOC
CDBTOCREAD	EQU	$83				; Read TOC
CDBPAUSE	EQU	$84				; Set pause to standby delay time

; Fader
FDRSET		EQU	$85				; Set music volume
FDRCHG		EQU	$86				; Ramp to music volume at rate

; CDC
CDCSTART	EQU	$87				; Start reading at sector into CDC
CDCSTOP		EQU	$89				; Stop reading into CDC
CDCSTAT		EQU	$8A				; Check if sector data is prepared
CDCREAD		EQU	$8B				; Prepare to send sector data to destination
CDCTRN		EQU	$8C				; Use Sub CPU to read sector data into RAM
CDCACK		EQU	$8D				; Inform CDC sector is fully read
CDCSETMODE	EQU	$96				; Set CD read mode

; Subcode
SCDINIT		EQU	$8E				; Initialize BIOS for subcode reading
SCDSTART	EQU	$8F				; Enable reading of subcode data by the CDC
SCDSTOP		EQU	$90				; Disable reading of subcode data by the CDC
SCDSTAT		EQU	$91				; Get subcode error status
SCDREAD		EQU	$92				; Read R through W subcode channels
SCDPQ		EQU	$93				; Read P and Q codes
SCDPQL		EQU	$94				; Read last P and Q codes

; LED
LEDSET		EQU	$95				; Set LED mode

; Backup RAM
BRMINIT		EQU	$00				; Prepare writing to or reading fromBackup RAM
BRMSTAT		EQU	$01				; Get how much Backup RAM has been used
BRMSERCH	EQU	$02				; Search for the desired file in Backup RAM
BRMREAD		EQU	$03				; Read data from Backup RAM
BRMWRITE	EQU	$04				; Write data to Backup RAM
BRMDEL		EQU	$05				; Delete data from Backup RAM
BRMFORMAT	EQU	$06				; Format Backup RAM
BRMDIR		EQU	$07				; Read directory from Backup RAM
BRMVERIFY	EQU	$08				; Check data written to Backup RAM

; ---------------------------------------------------------------------------
; BIOS entry points
; ---------------------------------------------------------------------------

_ADRERR		EQU	$5F40					; Address error
_BOOTSTAT	EQU	$5EA0					; Boot status
_BURAM		EQU	$5F16					; Backup RAM function entry
_CDBIOS		EQU	$5F22					; BIOS function entry
_CDBOOT		EQU	$5F1C					; Boot function entry
_CDSTAT		EQU	$5E80					; CD status
_CHKERR		EQU	$5F52					; CHK exception
_CODERR		EQU	$5F46					; Illegal instruction
_DEVERR		EQU	$5F4C					; Division by zero
_LEVEL1		EQU	$5F76					; Graphics interrupt
_LEVEL2		EQU	$5F7C					; Mega Drive interrupt
_LEVEL3		EQU	$5F82					; Timer interrupt
_LEVEL4		EQU	$5F88					; CDD interrupt
_LEVEL5		EQU	$5F8E					; CDC interrupt
_LEVEL6		EQU	$5F94					; Subcode interrupt
_LEVEL7		EQU	$5F9A					; Unused
_NOCOD0		EQU	$5F6A					; Line A emulator
_NOCOD1		EQU	$5F70					; Line F emulator
_SETJMPTBL	EQU	$5F0A					; Set up module
_SPVERR		EQU	$5F5E					; Privilege violation
_TRACE		EQU	$5F64					; TRACE exception
_TRAP00		EQU	$5FA0					; TRAP 00 exception
_TRAP01		EQU	$5FA6					; TRAP 01 exception
_TRAP02		EQU	$5FAC					; TRAP 02 exception
_TRAP03		EQU	$5FB2					; TRAP 03 exception
_TRAP04		EQU	$5FB8					; TRAP 04 exception
_TRAP05		EQU	$5FBE					; TRAP 05 exception
_TRAP06		EQU	$5FC4					; TRAP 06 exception
_TRAP07		EQU	$5FCA					; TRAP 07 exception
_TRAP08		EQU	$5FD0					; TRAP 08 exception
_TRAP09		EQU	$5FD6					; TRAP 09 exception
_TRAP10		EQU	$5FDC					; TRAP 10 exception
_TRAP11		EQU	$5FE2					; TRAP 11 exception
_TRAP12		EQU	$5FE8					; TRAP 12 exception
_TRAP13		EQU	$5FEE					; TRAP 13 exception
_TRAP14		EQU	$5FF4					; TRAP 14 exception
_TRAP15		EQU	$5FFA					; TRAP 15 exception
_TRPERR		EQU	$5F58					; TRAPV exception
_USERCALL0	EQU	$5F28					; System program initialization
_USERCALL1	EQU	$5F2E					; System program main
_USERCALL2	EQU	$5F34					; System program Mega Drive interrupt
_USERCALL3	EQU	$5F3A					; System program user routine
_USERMODE	EQU	$5EA6					; System program return code
_WAITVSYNC	EQU	$5F10					; VSync

; ---------------------------------------------------------------------------
; Calls BIOS function
; ---------------------------------------------------------------------------
; Assumes that all preparatory and cleanup work is done externally
; ---------------------------------------------------------------------------
; PARAMETERS:
;	fcode - BIOS function code
; ---------------------------------------------------------------------------

CDBIOS macro fcode
	moveq	#0,d0
	move.w	\fcode,d0
	jsr	_CDBIOS	
	endm

; ---------------------------------------------------------------------------
; Call Backup RAM function
; ---------------------------------------------------------------------------
; Assumes that all preparatory and cleanup work is done externally.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	fcode - Backup RAM function code
; ---------------------------------------------------------------------------

BURAM macro fcode
	move.w	\fcode,d0
	jsr	_BURAM
	endm

; ---------------------------------------------------------------------------
; Close the CD tray and read the TOC from the CD
; ---------------------------------------------------------------------------
; Pauses for 2 seconds after reading the TOC. If bit 7 of the TOC track
; is set, the BIOS starts playing the first track automatically. Waits
; for a DRVOPEN request if there is no disc in the drive.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Address of initialization parameters:
;	       dc.b    $XX              ; Track ID to read TOC from
;                                       ; (Normally $01)
;	       dc.b    $XX              ; Last track ID
;                                       ; ($FF = Read all tracks)
; ---------------------------------------------------------------------------

BIOS_DRVINIT macro
	CDBIOS	#DRVINIT
	endm

; ---------------------------------------------------------------------------
; Open the CD drive
; ---------------------------------------------------------------------------

BIOS_DRVOPEN macro
	CDBIOS	#DRVOPEN
	endm

; ---------------------------------------------------------------------------
; Stop the current music track
; ---------------------------------------------------------------------------

BIOS_MSCSTOP macro
	CDBIOS	#MSCSTOP
	endm

; ---------------------------------------------------------------------------
; Play a music track and subsequent tracks after
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to music track ID
;	       dc.w    $XXXX            ; First music track to play
; ---------------------------------------------------------------------------

BIOS_MSCPLAY macro
	CDBIOS	#MSCPLAY
	endm

; ---------------------------------------------------------------------------
; Play a music track
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to music track ID
;	       dc.w    $XXXX            ; Music track to play
; ---------------------------------------------------------------------------

BIOS_MSCPLAY1 macro
	CDBIOS	#MSCPLAY1
	endm

; ---------------------------------------------------------------------------
; Loop a music track
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to music track ID
;	       dc.w    $XXXX            ; Music track to loop
; ---------------------------------------------------------------------------

BIOS_MSCPLAYR macro
	CDBIOS	#MSCPLAYR
	endm

; ---------------------------------------------------------------------------
; Play music from a specific time
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to BCD time code in the format MM:SS:FF:00
;	       dc.l    $XXXXXXXX        ; Seek time
; ---------------------------------------------------------------------------

BIOS_MSCPLAYT macro
	CDBIOS	#MSCPLAYT
	endm

; ---------------------------------------------------------------------------
; Seek to beginning of music track and pause
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to music track ID
;	       dc.w    $XXXX            ; Music track to seek to
; ---------------------------------------------------------------------------

BIOS_MSCSEEK macro
	CDBIOS	#MSCSEEK
	endm

; ---------------------------------------------------------------------------
; Seek to beginning of music track and play it
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to music track ID
;	       dc.w    $XXXX            ; Music track to play
; ---------------------------------------------------------------------------

BIOS_MSCSEEK1 macro
	CDBIOS	#MSCSEEK1
	endm

; ---------------------------------------------------------------------------
; Seek to a specific time
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to BCD time code in the format MM:SS:FF:00
;	       dc.l    $XXXXXXXX       ; Seek time
; ---------------------------------------------------------------------------

BIOS_MSCSEEKT macro
	CDBIOS	#MSCSEEKT
	endm

; ---------------------------------------------------------------------------
; Pause the current music track
; ---------------------------------------------------------------------------
; If the drive is left paused it will stop after a programmable delay
; (See CDBPAUSE).
; ---------------------------------------------------------------------------

BIOS_MSCPAUSEON macro
	CDBIOS	#MSCPAUSEON
	endm

; ---------------------------------------------------------------------------
; Resume the current paused music track
; ---------------------------------------------------------------------------
; If the drive has timed out and stopped, the BIOS will seek to the pause
; time (with the attendant delay) and resume playing.
; ---------------------------------------------------------------------------

BIOS_MSCPAUSEOFF macro
	CDBIOS	#MSCPAUSEOFF
	endm

; ---------------------------------------------------------------------------
; Play music from current position in fast forward speed
; ---------------------------------------------------------------------------

BIOS_MSCSCANFF macro
	CDBIOS	#MSCSCANFF
	endm

; ---------------------------------------------------------------------------
; Play music from current position in fast reverse speed
; ---------------------------------------------------------------------------

BIOS_MSCSCANFR macro
	CDBIOS	#MSCSCANFR
	endm

; ---------------------------------------------------------------------------
; Return to normal playback speed
; ---------------------------------------------------------------------------
; If the drive was paused before the scan was initiated, it will be
; returned to pause.
; ---------------------------------------------------------------------------

BIOS_MSCSCANOFF macro
	CDBIOS	#MSCSCANOFF
	endm

; ---------------------------------------------------------------------------
; Begin reading data from the CD at the designated logical sector
; ---------------------------------------------------------------------------
; Executes a CDCSTART to begin the read, but doesn't stop automatically.
; ROMREAD actually pre-seeks by 2 sectors, but doesn't start passing data
; to the CDC until the desired sector is reached.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to logical sector ID
;	       dc.l    $XXXXXXXX       ; First sector to read
; ---------------------------------------------------------------------------

BIOS_ROMREAD macro
	CDBIOS	#ROMREAD
	endm

; ---------------------------------------------------------------------------
; Begin reading data from the CD at the designated logical sector for
; a set number of sectors
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to logical sector ID and count
;	       dc.l    $XXXXXXXX       ; First sector to read
;	       dc.l    $XXXXXXXX       ; Number of sectors to read
; ---------------------------------------------------------------------------

BIOS_ROMREADN macro
	CDBIOS	#ROMREADN
	endm

; ---------------------------------------------------------------------------
; Begin reading data from the CD at the designated logical sector up to
; another designated logical sector
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to first and last logical sector IDs
;	       dc.l    $XXXXXXXX       ; First sector to read
;	       dc.l    $XXXXXXXX       ; Last sector to read
; ---------------------------------------------------------------------------

BIOS_ROMREADE macro
	CDBIOS	#ROMREADE
	endm

; ---------------------------------------------------------------------------
; Seek to the designated logical sector and pause
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to logical sector ID
;	       dc.l    $XXXXXXXX       ; Sector to seek to
; ---------------------------------------------------------------------------

BIOS_ROMSEEK macro
	CDBIOS	#ROMSEEK
	endm

; ---------------------------------------------------------------------------
; Stop reading data into the CDC and pause
; ---------------------------------------------------------------------------

BIOS_ROMPAUSEON macro
	CDBIOS	#ROMPAUSEON
	endm

; ---------------------------------------------------------------------------
; Resume reading data into the CDC from the current logical sector
; ---------------------------------------------------------------------------

BIOS_ROMPAUSEOFF macro
	CDBIOS	#ROMPAUSEOFF
	endm

; ---------------------------------------------------------------------------
; Check the status of the last command
; ---------------------------------------------------------------------------
; Returns success if the command has been executed, not if it's complete.
; This means that CDBCHK will return success on a seek command once the
; seek has started, NOT when the seek is actually finished.
; ---------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Command has been executed/BIOS is busy
; ---------------------------------------------------------------------------

BIOS_CDBCHK macro
	CDBIOS	#CDBCHK
	endm

; ---------------------------------------------------------------------------
; Get the BIOS status
; ---------------------------------------------------------------------------
; RETURNS:
;	a0.l - Pointer to BIOS status table
;	       dc.w    $XXXX            ; BIOS status
;	       dc.w    $XXXX            ; LED status
;	       dc.b    $XX              ; CDD status code
;	       dc.b    $XX              ; CDD report code
;	       dc.b    $XX              ; Disc control code
;	       dc.b    $XX              ; Track ID
;	       dc.l    $XXXXXXXX        ; Absolute BCD timecode
;	       dc.l    $XXXXXXXX        ; Relative BCD timecode
;	       dc.b    $XX              ; First track ID
;	       dc.b    $XX              ; Last track ID
;	       dc.b    $XX              ; Drive version
;	       dc.b    $XX              ; Track flag
;	       dc.l    $XXXXXXXX        ; Start time of read out area
;	       dc.w    $XXXX            ; Master volume
;	       dc.w    $XXXX            ; Volume
;	       dc.l    $XXXXXXXX        ; Data read header
; ---------------------------------------------------------------------------

BIOS_CDBSTAT macro
	CDBIOS	#CDBSTAT
	endm

; ---------------------------------------------------------------------------
; Get the timecode and type of a specific track from the TOC
; ---------------------------------------------------------------------------
; If the track isn't in the TOC, the BIOS will either return the time of
; the last track read or the beginning of the disc. Don't call this
; function while the BIOS is loading the TOC (see DRVINIT).
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Track ID
; RETURNS:
;	d0.l - BCD timecode of requested track in MM:SS:FF:## format
;	       ## is the requested track number, 00 if there was an error
;	d1.b - Track type:
;	       $00 = CD-DA track
;	       $FF = CD-ROM track
; ---------------------------------------------------------------------------

BIOS_CDBTOCREAD macro
	CDBIOS	#CDBTOCREAD
	endm

; ---------------------------------------------------------------------------
; Write data to the TOC
; ---------------------------------------------------------------------------
; Don't write to the TOC while the BIOS is performing a DRVINIT.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to table of TOC entries to write
;	       Entry format is MM:SS:FF:HH where ## is the track number
; ---------------------------------------------------------------------------

BIOS_CDBTOCWRITE macro
	CDBIOS	#CDBTOCWRITE
	endm

; ---------------------------------------------------------------------------
; Set delay time for when the BIOS switches from pause to standby
; ---------------------------------------------------------------------------
; Normal ranges for this delay time are $1194 - $FFFE.
; A delay of $FFFF prevents the drive from stopping, but can damage the
; drive if used improperly.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Delay time
; ---------------------------------------------------------------------------

BIOS_CDBPAUSE macro
	CDBIOS	#CDBPAUSE
	endm

; ---------------------------------------------------------------------------
; Set the audio volume
; ---------------------------------------------------------------------------
; If bit 15 of the volume parameter is 1, sets the master volume level.
; There's a delay of up to 13ms before the volume begins to change and
; another 23ms for the new volume level to take effect. The master volume
; sets a maximum level which the volume level can't exceed.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - 16 bit volume        ($0000 = Min, $0400 = Max)
;	       16 bit master volume ($8000 = Min, $8400 = Max)
; ---------------------------------------------------------------------------

BIOS_FDRSET macro
	CDBIOS	#FDRSET
	endm

; ---------------------------------------------------------------------------
; Ramp the audio volume to a new level at the requested rate
; ---------------------------------------------------------------------------
; As in FDRSET, there's a delay of up to 13ms before the change starts.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.l - Volume change
;	       H: New volume ($0000 = Min, $0400 = Max)
;	       L: Rate in steps/vblank
;	          $0001 = Slow
;	          $0200 = Fast
;	          $0400 = Set immediately
; ---------------------------------------------------------------------------

BIOS_FDRCHG macro
	CDBIOS	#FDRCHG
	endm

; ---------------------------------------------------------------------------
; Start reading data from the current logical sector into the CDC
; ---------------------------------------------------------------------------
; The BIOS pre-seeks by 2 to 4 sectors and data read actually begins before
; the requested sector. It's up to the caller to identify the correct
; starting sector (usually by checking the time codes in the headers as
; they're read from the CDC buffer).
; ---------------------------------------------------------------------------

BIOS_CDCSTART macro
	CDBIOS	#CDCSTART
	endm

; ---------------------------------------------------------------------------
; Stop reading data into the CDC
; ---------------------------------------------------------------------------
; If a sector is being read when CDCSTOP is called, it's lost.
; ---------------------------------------------------------------------------

BIOS_CDCSTOP macro
	CDBIOS	#CDCSTOP
	endm

; ---------------------------------------------------------------------------
; Check if sector data has been prepared
; ---------------------------------------------------------------------------
; If no sector is ready for read, the carry bit will be set. Up to 5 sectors
; can be buffered in the CDC buffer.
; ---------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Sector available for read/No sectors available
; ---------------------------------------------------------------------------

BIOS_CDCSTAT macro
	CDBIOS	#CDCSTAT
	endm

; ---------------------------------------------------------------------------
; Prepare to send sector to the current device destination
; ---------------------------------------------------------------------------
; Make sure to set the device destination BEFORE calling CDCREAD. If a sector
; is ready, the carry bit will be cleared on return and it's necessary to
; respond with a call to CDCACK.
; ---------------------------------------------------------------------------
; RETURNS:
;	d0.l  - Sector header in BCD MM:SS:FF:MD format, MD is sector mode
;	        $00 = CD-DA
;	        $01 = CD-ROM mode 1
;	        $02 = CD-ROM mode 2
;	cc/cs - Sector ready for transfer/Sector not ready
; ---------------------------------------------------------------------------

BIOS_CDCREAD macro
	CDBIOS	#CDCREAD
	endm

; ---------------------------------------------------------------------------
; Use the Sub-CPU to read one sector into RAM
; ---------------------------------------------------------------------------
; The device destination must be set to SUB-CPU read before calling CDCTRN.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to sector destination buffer (At least $920 bytes)
;	a1.l  - Pointer to header destination buffer (At least 4 bytes)
; RETURNS:
;	a0.l  - Next sector destination address (a0 + $920)
;	a1.l  - Next header destination address (a1 + 4)
;	cc/cs - Sector successfully transferred/Transfer failed
; ---------------------------------------------------------------------------

BIOS_CDCTRN macro
	CDBIOS	#CDCTRN
	endm

; ---------------------------------------------------------------------------
; Inform the CDC that the current sector has been read and we're ready
; for the next sector
; ---------------------------------------------------------------------------

BIOS_CDCACK macro
	CDBIOS	#CDCACK
	endm

; ---------------------------------------------------------------------------
; Tell the BIOS which mode to read the CD in
; ---------------------------------------------------------------------------
; Mode 0 (CD-DA)                              %10
; Mode 1 (CD-ROM with full error correction)  %00
; Mode 2 (CD-ROM with CRC only)               %01
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - xxxxxxxxxxxx3210
;	                   ||||
;	                   |||+--> CD Mode 2
;	                   ||+---> CD-DA mode
;	                   |+----> Transfer error block with data
;	                   +-----> Re-read last data
; ---------------------------------------------------------------------------

BIOS_CDCSETMODE macro
	CDBIOS	#CDCSETMODE
	endm

; ---------------------------------------------------------------------------
; Initialize the BIOS for subcode reading
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Pointer to scratch buffer (At least $750 bytes)
; ---------------------------------------------------------------------------

BIOS_SCDINIT macro
	CDBIOS	#SCDINIT
	endm

; ---------------------------------------------------------------------------
; Enable reading of subcode data by the CDC
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w - Subcode processing mode
;	       0 = --------
;	       1 = --RSTUVW
;	       2 = PQ------
;	       3 = PQRSTUVW
; ---------------------------------------------------------------------------

BIOS_SCDSTART macro
	CDBIOS	#SCDSTART
	endm

; ---------------------------------------------------------------------------
; Disable reading of subcode data by the CDC
; ---------------------------------------------------------------------------

BIOS_SCDSTOP macro
	CDBIOS	#SCDSTOP
	endm

; ---------------------------------------------------------------------------
; Get subcode error status
; ---------------------------------------------------------------------------
; RETURNS:
;	d0.l - errqcodecrc/errpackcirc/scdflag/restrcnt
;	d1.l - erroverrun/errpacketbufful/errqcodefufful/errpackfufful
; ---------------------------------------------------------------------------

BIOS_SCDSTAT macro
	CDBIOS	#SCDSTAT
	endm

; ---------------------------------------------------------------------------
; Reads R through W subcode channels
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to subcode buffer (At least $18 bytes)
; RETURNS:
;	a0.l  - Address of next subcode buffer (a0.l + $18)
;	cc/cs - Read successful/Read failed
; ---------------------------------------------------------------------------

BIOS_SCDREAD macro
	CDBIOS	#SCDREAD
	endm

; ---------------------------------------------------------------------------
; Get P and Q codes from subcode
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to Q code buffer (At least $C bytes)
; RETURNS:
;	a0.l  - Address of next Q code buffer (a0.l + $C)
;	cc/cs - Read successful/Read failed
; ---------------------------------------------------------------------------

BIOS_SCDPQ macro
	CDBIOS	#SCDPQ
	endm

; ---------------------------------------------------------------------------
; Get the last P and Q codes
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to Q code buffer (At least $C bytes)
; RETURNS:
;	a0.l  - Address of next Q code buffer (a0.l + $C)
;	cc/cs - Read successful/Read failed
; ---------------------------------------------------------------------------

BIOS_SCDPQL macro
	CDBIOS	#SCDPQL
	endm

; ---------------------------------------------------------------------------
; Control the "Ready" and "Access" LEDs
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.w
;	Mode            Ready (Green)  Access (Red)  System Indication
;	---------------------------------------------------------------
;	                Off            Off           Only at reset
;	0 - LEDREADY    On             Blink         CD ready/No disc
;	1 - LEDDISCIN   On             Off           CD ready/Disc ok
;	2 - LEDACCESS   On             On            CD accessing
;	3 - LEDSTANDBY  Blink          Off           Standby mode
;	4 - LEDERROR    Blink          Blink         Reserved
;	5 - LEDMODE5    Blink          On            Reserved
;	6 - LEDMODE6    Off            Blink         Reserved
;	7 - LEDMODE7    Off            On            Reserved
;	? - LEDSYSTEM                                Return to BIOS
; ---------------------------------------------------------------------------

BIOS_LEDSET macro
	CDBIOS	#LEDSET
	endm

; ---------------------------------------------------------------------------
; Prepare to write into or read from Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to scratch RAM ($640 bytes)
;	a1.l  - Pointer to display strings buffer (12 bytes)
; RETURNS:
;	cc/cs - SEGA formatted RAM is present/Not formatted or no RAM
;	d0.w  - Size of Backup RAM ($2[000] - $100[000] bytes)
;	d1.w  - 0 = No RAM
;	        1 = Not formatted
;	        2 = Other format
;	a1.l  - Pointer to display strings
; ---------------------------------------------------------------------------

BIOS_BRMINIT macro
	BURAM	#BRMINIT
	endm

; ---------------------------------------------------------------------------
; Get how much Backup RAM has been used
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a1.l - Pointer to display strings buffer (12 bytes)
; RETURNS:
;	d0.w - Number of blocks of free area
;	d1.w - Number of files in directory
; ---------------------------------------------------------------------------

BIOS_BRMSTAT macro
	BURAM	#BRMSTAT
	endm

; ---------------------------------------------------------------------------
; Search for the desired file in Backup RAM
; ---------------------------------------------------------------------------
; The file names are 11 ASCII characters terminated with a 0.
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to file name
; RETURNS:
;	cc/cs - File found/File not found
;	d0.w  - Number of blocks
;	d1.b  - Mode
;		 0 = normal
;		-1 = data protected (with protect function)
;	a0.l  - Backup RAM start address for search
; ---------------------------------------------------------------------------

BIOS_BRMSERCH macro
	BURAM	#BRMSERCH
	endm

; ---------------------------------------------------------------------------
; Read data from Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to file name
;	a1.l  - Pointer to write buffer
; RETURNS:
;	cc/cs - Success/Error
;	d0.w  - Number of blocks
;	d1.b  - Mode
;	         0 = Normal
;	        -1 = Data protected
; ---------------------------------------------------------------------------

BIOS_BRMREAD macro
	BURAM	#BRMREAD
	endm

; ---------------------------------------------------------------------------
; Write data to Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to parameters
;	        dc.b    "XXXXXXXXXXX", 0 ; File name
;	        dc.b    $XX		 ; Flag
;		                         ; $00 = Normal
;		                         ; $FF = Encoded
;	        dc.w    $XXXX            ; Block size
;	                                 ; $00 = $40 bytes
;	                                 ; $FF = $20 bytes
;	a1.l  - Pointer to save data
; RETURNS:
;	cc/cs - Success/Error
; ---------------------------------------------------------------------------

BIOS_BRMWRITE macro
	BURAM	#BRMWRITE
	endm

; ---------------------------------------------------------------------------
; Delete data from Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to file name
; RETURNS:
;	cc/cs - Deleted/Not found
; ---------------------------------------------------------------------------

BIOS_BRMDEL macro
	BURAM	#BRMDEL
	endm

; ---------------------------------------------------------------------------
; Format Backup RAM
; ---------------------------------------------------------------------------
; Call BIOS_BRMINIT before calling this.
; ---------------------------------------------------------------------------
; RETURNS:
;	cc/cs - Success/Error
; ---------------------------------------------------------------------------

BIOS_BRMFORMAT macro
	BURAM	#BRMFORMAT
	endm

; ---------------------------------------------------------------------------
; Read directory from Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	d1.l  - H: Number of files to skip when all files cannot be read in
;	           one try
;	        L: Size of directory buffer (numer of files that can be read
;	           in the directory buffer)
;	a0.l  - Pointer to parameter (file name) table
;	a1.l  - Pointer to directory buffer
; RETURNS:
;	cc/cs - Success/Too much to read
; ---------------------------------------------------------------------------

BIOS_BRMDIR macro
	BURAM	#BRMDIR
	endm

; ---------------------------------------------------------------------------
; Check data written to Backup RAM
; ---------------------------------------------------------------------------
; PARAMETERS:
;	a0.l  - Pointer to parameters
;	        dc.b    "XXXXXXXXXXX", 0 ; File name
;	        dc.b    $XX		 ; Flag
;		                         ; $00 = Normal
;		                         ; $FF = Encoded
;	        dc.w    $XXXX            ; Block size
;	                                 ; $00 = $40 bytes
;	                                 ; $FF = $20 bytes
;	a1.l  - Pointer to save data
; RETURNS:
;	cc/cs - Success/Error
;	d0.w  - Error number
;	        -1 = Data does not match
;	         0 = File Not found
; ---------------------------------------------------------------------------

BIOS_BRMVERIFY macro
	BURAM	#BRMVERIFY
	endm

; ---------------------------------------------------------------------------
