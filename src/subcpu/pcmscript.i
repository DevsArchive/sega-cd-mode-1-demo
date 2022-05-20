; ---------------------------------------------------------------------------
; Mode 1 Demo
; By Devon 2022
; ---------------------------------------------------------------------------
; PCM driver script definitions
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Notes
; ---------------------------------------------------------------------------

	rsset	$40
PCMNSTART	rs.b	0				; Start of notes

NREST		rs.b	1				; Rest note
NCUT		rs.b	1				; Cut note

NA0		rs.b	1				; Octave 0
NAS0		rs.b	0
NBB0		rs.b	1
NB0		rs.b	1

NC1		rs.b	1				; Octave 1
NCS1		rs.b	0
NDB1		rs.b	1
ND1		rs.b	1
NDS1		rs.b	0
NEB1		rs.b	1
NE1		rs.b	1
NF1		rs.b	1
NFS1		rs.b	0
NGB1		rs.b	1
NG1		rs.b	1
NGS1		rs.b	0
NAB1		rs.b	1
NA1		rs.b	1
NAS1		rs.b	0
NBB1		rs.b	1
NB1		rs.b	1

NC2		rs.b	1				; Octave 2
NCS2		rs.b	0
NDB2		rs.b	1
ND2		rs.b	1
NDS2		rs.b	0
NEB2		rs.b	1
NE2		rs.b	1
NF2		rs.b	1
NFS2		rs.b	0
NGB2		rs.b	1
NG2		rs.b	1
NGS2		rs.b	0
NAB2		rs.b	1
NA2		rs.b	1
NAS2		rs.b	0
NBB2		rs.b	1
NB2		rs.b	1

NC3		rs.b	1				; Octave 3
NCS3		rs.b	0
NDB3		rs.b	1
ND3		rs.b	1
NDS3		rs.b	0
NEB3		rs.b	1
NE3		rs.b	1
NF3		rs.b	1
NFS3		rs.b	0
NGB3		rs.b	1
NG3		rs.b	1
NGS3		rs.b	0
NAB3		rs.b	1
NA3		rs.b	1
NAS3		rs.b	0
NBB3		rs.b	1
NB3		rs.b	1

NC4		rs.b	1				; Octave 4
NCS4		rs.b	0
NDB4		rs.b	1
ND4		rs.b	1
NDS4		rs.b	0
NEB4		rs.b	1
NE4		rs.b	1
NF4		rs.b	1
NFS4		rs.b	0
NGB4		rs.b	1
NG4		rs.b	1
NGS4		rs.b	0
NAB4		rs.b	1
NA4		rs.b	1
NAS4		rs.b	0
NBB4		rs.b	1
NB4		rs.b	1

NC5		rs.b	1				; Octave 5
NCS5		rs.b	0
NDB5		rs.b	1
ND5		rs.b	1
NDS5		rs.b	0
NEB5		rs.b	1
NE5		rs.b	1
NF5		rs.b	1
NFS5		rs.b	0
NGB5		rs.b	1
NG5		rs.b	1
NGS5		rs.b	0
NAB5		rs.b	1
NA5		rs.b	1
NAS5		rs.b	0
NBB5		rs.b	1
NB5		rs.b	1

NC6		rs.b	1				; Octave 6
NCS6		rs.b	0
NDB6		rs.b	1
ND6		rs.b	1
NDS6		rs.b	0
NEB6		rs.b	1
NE6		rs.b	1
NF6		rs.b	1
NFS6		rs.b	0
NGB6		rs.b	1
NG6		rs.b	1
NGS6		rs.b	0
NAB6		rs.b	1
NA6		rs.b	1
NAS6		rs.b	0
NBB6		rs.b	1
NB6		rs.b	1

NC7		rs.b	1				; Octave 7
NCS7		rs.b	0
NDB7		rs.b	1
ND7		rs.b	1
NDS7		rs.b	0
NEB7		rs.b	1
NE7		rs.b	1
NF7		rs.b	1
NFS7		rs.b	0
NGB7		rs.b	1
NG7		rs.b	1
NGS7		rs.b	0
NAB7		rs.b	1
NA7		rs.b	1
NAS7		rs.b	0
NBB7		rs.b	1
NB7		rs.b	1

NC8		rs.b	1				; Octave 8
NCS8		rs.b	0
NDB8		rs.b	1
ND8		rs.b	1
NDS8		rs.b	0
NEB8		rs.b	1
NE8		rs.b	1
NF8		rs.b	1
NFS8		rs.b	0
NGB8		rs.b	1
NG8		rs.b	1
NGS8		rs.b	0
NAB8		rs.b	1

PCMNEND		EQU	__rs-1				; End of notes

; ---------------------------------------------------------------------------
; Command IDs
; ---------------------------------------------------------------------------

PCMCSTART	rs.b	0				; Start of commands

PCMCIDJUMP	rs.b	1				; Jump
PCMCIDLEGATO	rs.b	1				; Legato
PCMCIDINS	rs.b	1				; Instrument

PCMCEND		EQU	__rs-1				; End of commands

; ---------------------------------------------------------------------------
; Start track
; ---------------------------------------------------------------------------

__pcm_track_id = -1
PCMTRKSTART macro
	__pcm_track_id: = __pcm_track_id+1
	__pcm_origin_\#__pcm_track_id\: EQU *
	endm

; ---------------------------------------------------------------------------
; Define instrument table
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr - Pointer to instrument table
; ---------------------------------------------------------------------------

PCMINSTBL macro addr
	dc.w	(\addr)-(__pcm_origin_\#__pcm_track_id\)
	endm

; ---------------------------------------------------------------------------
; Start channel table
; ---------------------------------------------------------------------------

PCMCHNSTART macro
	__pcm_chn_cnt: = -1
	dc.w	__pcm_chn_cnt_\#__pcm_track_id
	endm

; ---------------------------------------------------------------------------
; Define channel
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr - Pointer to track data
;	id   - Channel ID
;	vol  - Volume
;	pan  - Panning
; ---------------------------------------------------------------------------

PCMCHNPTR macro addr, id, vol, pan
	if ((\id)<0)|((\id)>7)
		inform 2,"Invalid PCM channel ID %d", \id
		mexit
	endif

	__pcm_chn_cnt: = __pcm_chn_cnt+1
	dc.w	(\addr)-(__pcm_origin_\#__pcm_track_id\)
	dc.b	\id
	dc.b	\vol, \pan, 0
	endm

; ---------------------------------------------------------------------------
; End channel table
; ---------------------------------------------------------------------------

PCMCHNEND macro
	__pcm_chn_cnt_\#__pcm_track_id: EQU __pcm_chn_cnt
	endm

; ---------------------------------------------------------------------------
; Start instrument table
; ---------------------------------------------------------------------------

PCMINSSTART macro
	__pcm_instbl_\#__pcm_track_id\: EQU *
	endm

; ---------------------------------------------------------------------------
; Define instrument pointer
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr - Pointer to instrument data
; ---------------------------------------------------------------------------

PCMINSPTR macro addr
	dc.w	(\addr)-(__pcm_instbl_\#__pcm_track_id\)
	endm

; ---------------------------------------------------------------------------
; Define instrument data
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr   - Pointer to sample data
;	len    - Length of sample data
;	loop   - Loop point
;	nstart - Note range start
;	nend   - Note range end
;	trns   - Transposition
;	atk    - Attack rate
;	dec    - Decay rate
;	slv    - Sustain level
;	sus    - Sustain rate
;	rel    - Release rate
; ---------------------------------------------------------------------------

PCMINSDAT macro addr, len, loop, nstart, nend, trns, atk, dec, slv, sus, rel
	if ((\nstart)<PCMNSTART)|((\nstart)>PCMNEND)
		inform 2,"Invalid note range start"
		mexit
	elseif ((\nend)<PCMNSTART)|((\nend)>PCMNEND)
		inform 2,"Invalid note range end"
		mexit
	elseif (\nend)<(\nstart)
		inform 2,"Note range end is less than start"
		mexit
	endif
	
	dc.l	\addr
	dc.l	\len
	dc.l	\loop
	dc.b	\trns
	dc.b	\atk, \dec, \slv, \sus, \rel
	dc.b	(\nstart)-PCMNSTART, (\nend)-PCMNSTART
	endm

; ---------------------------------------------------------------------------
; End of instrument data
; ---------------------------------------------------------------------------

PCMINSEND macro
	dc.w	-1
	endm

; ---------------------------------------------------------------------------
; Jump command
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address to jump to
; ---------------------------------------------------------------------------

PCMCJUMP macro addr
	dc.b	PCMCIDJUMP
	dc.w	(\addr)-(*+2)
	endm

; ---------------------------------------------------------------------------
; Legato command
; ---------------------------------------------------------------------------

PCMCLEGATO	EQU	PCMCIDLEGATO

; ---------------------------------------------------------------------------
; Set instrument command
; ---------------------------------------------------------------------------
; PARAMETERS:
;	ins - Instrument ID
; ---------------------------------------------------------------------------

PCMCINS macro ins
	dc.b	PCMCIDINS, \ins
	endm

; ---------------------------------------------------------------------------
