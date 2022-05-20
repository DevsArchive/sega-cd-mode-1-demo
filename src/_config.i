; ---------------------------------------------------------------------------
; Mode 1 Demo
; By Devon 2022
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Assembler options
; ---------------------------------------------------------------------------

	opt	ae-					; Disable automatic evens
	opt	m+					; Expand macros
	opt	l.					; Local label character
	opt	op+					; PC relative optimizations
	opt	os+					; Short branch optimizations
	opt	ow+					; Absolute word numessing optimizations
	opt	oz+					; Zero offset optimizations
	opt	oaq+					; ADDQ optimizations
	opt	osq+					; SUBQ optimizations
	opt	omq+					; MOVEQ optimizations

; ---------------------------------------------------------------------------
; Flags
; ---------------------------------------------------------------------------

; Debug flag
DEBUG		EQU	1

; ---------------------------------------------------------------------------
; ROM information
; ---------------------------------------------------------------------------

; Copyright
COPYRIGHT	EQUS	"DEVON"
; Game name
GAME_NAME	EQUS	"MEGA CD MODE 1 DEMO BY DEVON"
; I/O support
IO_SUPPORT	EQUS	"JC"
; Serial number
SERIAL		EQUS	"00000000"
; Revision
REVISION	EQU	0
; Save RAM size
SRAM_SIZE	EQU	0

; ---------------------------------------------------------------------------
