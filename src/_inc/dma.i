; ---------------------------------------------------------------------------
; Mega Drive Framework
; By Devon 2022
; ---------------------------------------------------------------------------
; DMA definitions
; ---------------------------------------------------------------------------
; Ultra DMA Queue by Flamewing
; https://github.com/flamewing/ultra-dma-queue
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Options
; ---------------------------------------------------------------------------
; This option makes the function work as a drop-in replacement of the original
; functions. If you modify all callers to supply a position in words instead of
; bytes (i.e., divide source address by 2) you can set this to 0 to gain 10(1/0)
DMA_SRC_BYTES		EQU	1

; This option (which is disabled by default) makes the DMA queue assume that the
; source address is given to the function in a way that makes them safe to use
; with RAM sources. You need to edit all callers to ensure this.
; Enabling this option turns off DMA_RAM_SAFE_USE, and saves 14(2/0).
DMA_RAM_SAFE		EQU	0

; This option (which is enabled by default) makes source addresses in RAM safe
; at the cost of 14(2/0). If you modify all callers so as to clear the top byte
; of source addresses (i.e., by ANDing them with $FFFFFF).
DMA_RAM_SAFE_USE	EQU	1&(DMA_RAM_SAFE=0)

; This option breaks DMA transfers that crosses a 128kB block into two. It is
; disabled by default because you can simply align the art in ROM and avoid the
; issue altogether. It is here so that you have a high-performance routine to do
; the job in situations where you can't align it in ROM.
DMA_128KB_SAFE		EQU	0

; Option to mask interrupts while updating the DMA queue. This fixes many race
; conditions in the DMA funcion, but it costs 46(6/1) cycles. The better way to
; handle these race conditions would be to make unsafe callers (such as S3&K's
; KosM decoder) prevent these by masking off interrupts before calling and then
; restore interrupts after.
DMA_VINT_SAFE		EQU	0

; ---------------------------------------------------------------------------
; DMA entry slot structure
; ---------------------------------------------------------------------------

	rsreset
dmaSlotReg94	rs.b	1				; Size (high) register ID
dmaSlotSize	rs.b	0				; Size register data start
dmaSlotSizeH	rs.b	1				; Size (high) register data
dmaSlotReg93	rs.b	1				; Size (low) register ID
dmaSlotSrc	rs.b	0				; Source register data start
dmaSlotSizeL	rs.b	1				; Size (low) register data

dmaSlotReg97	rs.b	1				; Source (high) register ID
dmaSlotSrcH	rs.b	1				; Source (high) register data
dmaSlotReg96	rs.b	1				; Source (middle) register ID
dmaSlotSrcM	rs.b	1				; Source (middle) register data
dmaSlotReg95	rs.b	1				; Source (low) register ID
dmaSlotSrcL	rs.b	1				; Source (low) register data

dmaSlotCmd	rs.l	1				; VDP command
dmaSlotLen	rs.b	0				; Size of structure

; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

DMASLOT_COUNT	EQU	$12				; Number of DMA entry slots
DMAQUEUE_SIZE	EQU	DMASLOT_COUNT*dmaSlotLen	; Size of DMA queue

; ---------------------------------------------------------------------------
; Convert VDP address in register to VDP command
; ---------------------------------------------------------------------------
; PARAMETERS:
;	reg   - Register containing source address in 68000 memory
;	type  - Type of VDP memory
;	rwd   - VDP command
;	clear - Mask out garbage bits
; ---------------------------------------------------------------------------

VDPCMDR macro reg, type, rwd, clear
	local	upperbits, lowerbits
	lsl.l	#2,\reg					; Move high bits into (word-swapped) position, accidentally moving everything else
	upperbits: EQU	(\type\_\rwd\)>>30
	if upperbits<>0
		addq.w	#upperbits,\reg			; Add upper access type bits
	endif
	
	ror.w	#2,\reg					; Put upper access type bits into place, also moving all other bits into their correct (word-swapped) places
	swap	\reg					; Put all bits in proper places
	if (\clear)<>0
		andi.w	#3,\reg				; Strip whatever junk was in upper word of reg
	endif

	lowerbits: EQU	(\type\_\rwd\)&$F0
	if lowerbits=$80
		tas.b	\reg				; Add in the DMA flag -- tas fails on memory, but works on registers
	elseif lowerbits<>0
		ori.w	#(lowerbits<<2),\reg		; Add in missing access type bits
	endif
	endm

; ---------------------------------------------------------------------------
; Clears the DMA queue, discarding all previously-queued DMAs.
; ---------------------------------------------------------------------------

RESETDMA macro
	move.w	#dma_queue,dma_queue_cur.w
	endm

; ---------------------------------------------------------------------------
; Directly queues a DMA on the spot. Requires all parameters to be known at
; assembly time; that is, no registers. Gives assembly errors when the DMA
; crosses a 128kB boundary, is at an odd ROM location, or is zero length.
; Expects source address and DMA length in bytes. Also, expects source, size,
; and dest to be known at assembly time. Gives errors if DMA starts at an
; odd address, transfers crosses a 128kB boundary, or has size 0.
;
; With the default settings, runs in:
; * 32(7/0) cycles if queue is full (DMA discarded)
; * 122(21/8) cycles otherwise (DMA queued)
; Passing a register as destination is faster by 8(2/0) when the DMA is queued,
; but requires initializing the register elsewhere, which is probably slower.
;
; Setting DMA_VINT_SAFE to 1 adds 46(6/1) cycles to both cases.
; ---------------------------------------------------------------------------
; The destination parameter can be either:
;	- A VRAM address literal
;	- A register initialized with `VDPCMD move.l,dest,VRAM,DMA`
;	- A register initialized with `vdpCommReg <reg>,VRAM,DMA`
; ---------------------------------------------------------------------------
; OPTIONS:
; 	DMA_VINT_SAFE (default 0)
; ---------------------------------------------------------------------------
; PARAMETERS:
; 	src    - Source address (in bytes)
;	length - transfer length (in bytes)
;	dest   - destination address
; ---------------------------------------------------------------------------

DMAIMM macro src, length, dest
	if ((\src)&1)<>0
		inform 3,"DMA queued from odd source $%h!", src
	endif
	if ((\length)&1)<>0
		inform 3,"DMA an odd number of bytes $%h!", length
	endif
	if (\length)=0
		inform 3,"DMA transferring 0 bytes (becomes a 128kB transfer). If you really mean it, pass 128kB instead."
	endif
	if (((\src)+(\length)-1)>>17)<>((\src)>>17)
		inform 3,"DMA crosses a 128kB boundary. You should either split the DMA manually or align the source adequately."
	endif

	if DMA_VINT_SAFE=1
		move.w	sr,-(sp)			; Save current interrupt mask
		move	#$2700,sr			; Mask off interrupts
	endif	; DMA_VINT_SAFE=1

	movea.w	dma_queue_cur.w,a1
	cmpa.w	#dma_queue_cur,a1
	beq.s	.done					; Return if there's no more room in the buffer
	move.b	#((\length)>>8)&$7F,dmaSlotSizeH(a1)	; Write top byte of size/2
							; Set d0 to bottom byte of size/2 and the low 3 bytes of source/2
	move.l	#(((\length)&$FF)<<24)|(((\src)>>1)&$7FFFFF),d0
	movep.l	d0,dmaSlotSizeL(a1)			; Write it all to the queue
	lea	dmaSlotCmd(a1),a1			; Seek to correct RAM address to store VDP DMA command

	ISDREG	\dest
	if is_reg
		move.l	\dest,(a1)+
	else
		VDPCMD	move.l,\dest,VRAM,DMA,(a1)+	; Write VDP DMA command for destination address
	endif

	move.w	a1,dma_queue_cur.w			; Write next queue slot
.done:
	if DMA_VINT_SAFE=1
		move.w	(sp)+,sr			; Restore interrupts to previous state
	endif	; DMA_VINT_SAFE=1
	endm

; ---------------------------------------------------------------------------
