; ---------------------------------------------------------------------------
; Mega Drive Framework
; By Devon 2022
; ---------------------------------------------------------------------------
; RAM map/variables
; ---------------------------------------------------------------------------

	include	"_inc/dma.i"

; ---------------------------------------------------------------------------
; Work RAM layout
; ---------------------------------------------------------------------------

	rsset	WORKRAM

; Global program variables
global_vars	rs.b	0
		include	"_globalvars.i"
global_vars_end	rs.b	0

; Framework variables
palette		rs.b	CRAM_SIZE			; Palette buffer
hscroll		rs.b	HSCROLL_SIZE			; Horizontal scroll buffer
vscroll		rs.b	VSRAM_SIZE			; Vertical scroll buffer
sprites		rs.b	SPRITES_SIZE			; Sprite buffer

dma_queue	rs.b	DMAQUEUE_SIZE			; DMA queue
dma_queue_cur	rs.w	1				; DMA queue cursor

external_int	rs.b	6				; External interrupt jump opcode
hblank_int	rs.b	6				; H-BLANK interrupt jump opcode
vblank_int	rs.b	6				; V-BLANK interrupt jump opcode

console_ver	rs.b	1				; Console version

mcd_found	rs.b	1				; Found Mega CD flag
mcd_sub_bios	rs.l	1				; Found Mega CD Sub CPU BIOS

; Saved program variables
saved_vars	rs.b	0
initialized	rs.l	1				; Initialized flag
saved_vars_end	rs.b	0

; Local program variables
local_vars	rs.b	(WORKRAM+$FF00)-__rs
local_vars_end	rs.b	0

; Stack
stack		rs.b	$100
stack_base	rs.b	0

; ---------------------------------------------------------------------------
