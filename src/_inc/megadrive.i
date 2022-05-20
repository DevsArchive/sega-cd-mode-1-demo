; ---------------------------------------------------------------------------
; Mega Drive Framework
; By Devon 2022
; ---------------------------------------------------------------------------
; Mega Drive definitions
; ---------------------------------------------------------------------------

	include	"_config.i"
	include	"macros.i"
	include	"axm68k.i"

; ---------------------------------------------------------------------------
; Memory map (68000)
; ---------------------------------------------------------------------------

; ROM
CARTROM		EQU	$000000				; Cartridge ROM start
CARTROM_END	EQU	$3FFFFF				; Cartridge ROM end
CARTROM_SIZE	EQU	(CARTROM_END+1)-CARTROM	; Cartridge ROM size

; Expansion
EXPANSION	EQU	$400000				; Expansion memory start
EXPANSION_END	EQU	$7FFFFF				; Expansion memory end
EXPANSION_SIZE	EQU	(EXPANSION_END+1)-EXPANSION	; Expansion memory size

; Z80
Z80RAM		EQU	$A00000				; Z80 RAM start
Z80RAM_END	EQU	$A01FFF				; Z80 RAM end
Z80RAM_SIZE	EQU	(Z80RAM_END+1)-Z80RAM		; Z80 RAM size
Z80BUS		EQU	$A11100				; Z80 bus request
Z80RESET	EQU	$A11200				; Z80 reset

; Work RAM
WORKRAM		EQU	$FFFF0000			; Work RAM start
WORKRAM_END	EQU	$FFFFFFFF			; Work RAM end
WORKRAM_SIZE	EQU	(MD_RAM_END+1)-MD_RAM		; Work RAM size

; Save RAM
SRAMPAD_SIZE: =	0
	if (SRAM_SIZE<>0)
		SRAMPAD_SIZE: =	$2000
		while (SRAMPAD_SIZE<SRAM_SIZE)
			SRAMPAD_SIZE: = SRAMPAD_SIZE*2
		endw
		if (SRAMPAD_SIZE>$8000)
			inform 3,"Save RAM size is too large. Maximum save RAM size is 32 KiB."
		endif
	endif
SRAM		EQU	$200001				; Save RAM start
SRAM_END	EQU	SRAM+((SRAMPAD_SIZE-1)*2)	; Save RAM end
SRAM_ON		EQU	$A130F1				; Save RAM enable port

; Sound
YMADDR0		EQU	$A04000				; YM2612 address port 0
YMDATA0		EQU	$A04001				; YM2612 data port 0
YMADDR1		EQU	$A04002				; YM2612 address port 1
YMDATA1		EQU	$A04003				; YM2612 data port 1
PSGCTRL		EQU	$C00011				; PSG control port

; VDP
VDPDATA		EQU	$C00000				; VDP data port
VDPCTRL		EQU	$C00004				; VDP control port
VDPHV		EQU	$C00008				; VDP H/V counter
VDPDEBUG	EQU	$C0001C				; VDP debug register

; I/O
VERSION		EQU	$A10001				; Hardware version
IODATA1		EQU	$A10003				; I/O port 1 data port
IODATA2		EQU	$A10005				; I/O port 2 data port
IODATA3		EQU	$A10007				; I/O port 3 data port
IOCTRL1		EQU	$A10009				; I/O port 1 control port
IOCTRL2		EQU	$A1000B				; I/O port 2 control port
IOCTRL3		EQU	$A1000D				; I/O port 3 control port

; TMSS
TMSSSEGA	EQU	$A14000				; TMSS "SEGA" register
TMSSMODE	EQU	$A14100				; TMSS bus mode

; Mega CD memory
MCDBIOS		EQU	EXPANSION			; BIOS
PRGRAM		EQU	EXPANSION+$20000		; Sub CPU Program RAM bank
PRGRAM_END	EQU	EXPANSION+$3FFFF		; End of Sub CPU Program RAM bank
PRGRAM_SIZE	EQU	(PRGRAM_END+1)-PRGRAM		; Size of Sub CPU Program RAM bank
WORDRAM		EQU	EXPANSION+$200000		; Word RAM
WORDRAM2M_END	EQU	EXPANSION+$23FFFF		; End of Word RAM (2M)
WORDRAM1M_END	EQU	EXPANSION+$21FFFF		; End of Word RAM (1M/1M)
WORDRAM2M_SIZE	EQU	(WORDRAM2M_END+1)-WORDRAM	; Size of Word RAM (2M)
WORDRAM1M_SIZE	EQU	(WORDRAM1M_END+1)-WORDRAM	; Size of Word RAM (1M/1M)

; Mega CD registers
MCDREGS		EQU	$A12000				; Registers base
MCDINT2		EQU	MCDREGS+0			; Sub CPU level 2 interrupt flags
MCDBUSREQ	EQU	MCDREGS+1			; Sub CPU bus request
MCDPROTECT	EQU	MCDREGS+2			; Sub CPU Program RAM write protect
MCDMEMMODE	EQU	MCDREGS+3			; Memory mode
MCDCDCMODE	EQU	MCDREGS+4			; CDC mode
MCDHINT		EQU	MCDREGS+6			; H-BLANK interrupt vector
MCDCDCREAD	EQU	MCDREGS+8			; CDC host data
MCDSTOPWATCH	EQU	MCDREGS+$C			; Stop watch

; Mega CD communication (Main CPU)
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

; Mega CD communication (Sub CPU)
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

; ---------------------------------------------------------------------------
; Memory map (Z80)
; ---------------------------------------------------------------------------

; Sound
ZYMADDR0	EQU	$4000				; YM2612 address port 0
ZYMDATA0	EQU	$4001				; YM2612 data port 0
ZYMADDR1	EQU	$4002				; YM2612 address port 1
ZYMDATA1	EQU	$4003				; YM2612 data port 1
ZPSGCTRL	EQU	$7F11				; PSG control port

; Bank
ZBANKREG	EQU	$6000				; 68000 bank register
ZBANK		EQU	$8000				; 68000 bank
ZBANKSIZE	EQU	$8000				; Size of 68000 bank

; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

CRAM_SIZE	EQU	16*4*2				; Size of color RAM
HSCROLL_SIZE	EQU	224*4				; Size of horizontal scroll data
VSRAM_SIZE	EQU	(320/16)*4			; Size of vertical scroll RAM
SPRITES_SIZE	EQU	80*8				; Size of sprite data

; ---------------------------------------------------------------------------
; Request Z80 bus access
; ---------------------------------------------------------------------------

Z80REQ macro
	move.w	#$100,Z80BUS				; Request Z80 bus access
	endm

; ---------------------------------------------------------------------------
; Wait for Z80 bus request acknowledgement
; ---------------------------------------------------------------------------

Z80WAIT macro
.Wait\@:
	btst	#0,Z80BUS				; Was the request acknowledged?
	bne.s	.Wait\@					; If not, wait
	endm

; ---------------------------------------------------------------------------
; Request Z80 bus access
; ---------------------------------------------------------------------------

Z80STOP macro
	Z80REQ						; Request Z80 bus access
	Z80WAIT						; Wait for acknowledgement
	endm

; ---------------------------------------------------------------------------
; Release the Z80 bus
; ---------------------------------------------------------------------------

Z80START macro
	move.w	#0,Z80BUS				; Release the bus
	endm

; ---------------------------------------------------------------------------
; Request Z80 reset
; ---------------------------------------------------------------------------

Z80RESON macro
	move.w	#0,Z80RESET				; Request Z80 reset
	endm

; ---------------------------------------------------------------------------
; Cancel Z80 reset
; ---------------------------------------------------------------------------

Z80RESOFF macro
	move.w	#$100,Z80RESET				; Cancel Z80 reset
	endm

; ---------------------------------------------------------------------------
; Wait for DMA to finish
; ---------------------------------------------------------------------------
; PARAMETERS:
;	ctrl - (OPTIONAL) VDP control port address register
; ---------------------------------------------------------------------------

DMAWAIT macro ctrl
.Wait\@:
	if narg>0					; Is DMA active?
		move.w	(\ctrl),ccr
	else
		move.w	VDPCTRL,ccr
	endif
	bvs.s	.Wait\@					; If so, wait
	endm

; ---------------------------------------------------------------------------
; VDP command instruction
; ---------------------------------------------------------------------------
; PARAMETERS:
;	addr - Address in VDP memory
;	type - Type of VDP memory
;	rwd  - VDP command
;	end  - Destination, or modifier if end2 is defined
;	end2 - Destination if defined
; ---------------------------------------------------------------------------

VRAM_WRITE	EQU	$40000000			; VRAM write
CRAM_WRITE	EQU	$C0000000			; CRAM write
VSRAM_WRITE	EQU	$40000010			; VSRAM write
VRAM_READ	EQU	$00000000			; VRAM read
CRAM_READ	EQU	$00000020			; CRAM read
VSRAM_READ	EQU	$00000010			; VSRAM read
VRAM_DMA	EQU	VRAM_WRITE|$80			; VRAM DMA
CRAM_DMA	EQU	CRAM_WRITE|$80			; CRAM DMA
VSRAM_DMA	EQU	VSRAM_WRITE|$80			; VSRAM DMA

; ---------------------------------------------------------------------------

VDPCMD macro ins, addr, type, rwd, end, end2
	local	cmd
	cmd: =	(\type\_\rwd\)|(((\addr)&$3FFF)<<16)|((\addr)/$4000)
	if narg=5
		\ins	#$\$cmd,\end
	elseif narg>=6
		\ins	#$\$cmd\\end,\end2
	else
		\ins	$\$cmd
	endif
	endm

; ---------------------------------------------------------------------------
; VDP DMA from 68000 memory to VDP memory
; ---------------------------------------------------------------------------
; PARAMETERS:
;	src  - Source address in 68000 memory
;	dest - Destination address in VDP memory
;	len  - Length of data in bytes
;	type - Type of VDP memory
;	ctrl - (OPTIONAL) VDP control port address register
; ---------------------------------------------------------------------------

DMA68K macro src, dest, len, type, ctrl
	if narg>4
		move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),(\ctrl)
		move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),(\ctrl)
		move.w	#$9700|(((\src)>>17)&$7F),(\ctrl)
		VDPCMD	move.w,\dest,\type,DMA,>>16,(\ctrl)
		VDPCMD	move.w,\dest,\type,DMA,&$FFFF,-(sp)
		move.w	(sp)+,(\ctrl)
	else
		move.l	#$94009300|((((\len)/2)&$FF00)<<8)|(((\len)/2)&$FF),VDPCTRL
		move.l	#$96009500|((((\src)/2)&$FF00)<<8)|(((\src)/2)&$FF),VDPCTRL
		move.w	#$9700|(((\src)>>17)&$7F),VDPCTRL
		VDPCMD	move.w,\dest,\type,DMA,>>16,VDPCTRL
		VDPCMD	move.w,\dest,\type,DMA,&$FFFF,-(sp)
		move.w	(sp)+,VDPCTRL
	endif
	endm

; ---------------------------------------------------------------------------
; VDP DMA fill VRAM with byte
; Auto-increment should be set to 1 beforehand
; ---------------------------------------------------------------------------
; PARAMETERS:
;	byte - Byte to fill VRAM with
;	addr - Address in VRAM
;	len  - Length of fill in bytes
;	ctrl - (OPTIONAL) VDP control port address register
; ---------------------------------------------------------------------------

DMAFILL macro byte, addr, len, ctrl
	if narg>3
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),(\ctrl)
		move.w	#$9780,(\ctrl)
		move.l	#$40000080|(((\addr)&$3FFF)<<16)|(((\addr)&$C000)>>14),(\ctrl)
		move.w	#(\byte)<<8,-4(\ctrl)
		DMAWAIT	\ctrl
	else
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),VDPCTRL
		move.w	#$9780,VDPCTRL
		move.l	#$40000080|(((\addr)&$3FFF)<<16)|(((\addr)&$C000)>>14),VDPCTRL
		move.w	#(\byte)<<8,VDPDATA
		DMAWAIT
	endif
	endm

; ---------------------------------------------------------------------------
; VDP DMA copy region of VRAM to another location in VRAM
; Auto-increment should be set to 1 beforehand
; ---------------------------------------------------------------------------
; PARAMETERS:
;	src  - Source address in VRAM
;	dest - Destination address in VRAM
;	len  - Length of copy in bytes
;	ctrl - (OPTIONAL) VDP control port address register
; ---------------------------------------------------------------------------

DMACOPY macro src, dest, len, ctrl
	if narg>3
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),(\ctrl)
		move.l	#$96009500|(((\src)&$FF00)<<8)|((\src)&$FF),(\ctrl)
		move.w	#$97C0,(\ctrl)
		move.l	#$0000C0|(((\dest)&$3FFF)<<16)|(((\dest)&$C000)>>14),(\ctrl)
		DMAWAIT	\ctrl
	else
		move.l	#$94009300|((((\len)-1)&$FF00)<<8)|(((\len)-1)&$FF),VDPCTRL
		move.l	#$96009500|(((\src)&$FF00)<<8)|((\src)&$FF),VDPCTRL
		move.w	#$97C0,VDPCTRL
		move.l	#$0000C0|(((\dest)&$3FFF)<<16)|(((\dest)&$C000)>>14),VDPCTRL
		DMAWAIT
	endif
	endm

; ---------------------------------------------------------------------------
