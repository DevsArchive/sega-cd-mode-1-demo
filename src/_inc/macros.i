; ---------------------------------------------------------------------------
; Mega Drive Framework
; By Devon 2022
; ---------------------------------------------------------------------------
; General macros
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
; Align to size boundary
; ---------------------------------------------------------------------------
; PARAMETERS:
;	bound - Size boundary
;	value - (OPTIONAL) Value to pad with
; ---------------------------------------------------------------------------

ALIGN macro bound, value
	local	pad
	pad: = ((\bound)-((*)%(\bound)))%(\bound)
	if narg>1
		dcb.b	pad, \value
	else
		dcb.b	pad, 0
	endif
	endm

; ---------------------------------------------------------------------------
; Align RS offset to be even
; ---------------------------------------------------------------------------

RSEVEN macro
	rs.b	__rs&1
	endm

; ---------------------------------------------------------------------------
; Align RS offset to boundary
; ---------------------------------------------------------------------------

RSALIGN macro bound
	rs.b	((\bound)-((__rs)%(\bound)))%(\bound)
	endm

; ---------------------------------------------------------------------------
; Generate repeated RS structure entries
; ---------------------------------------------------------------------------
; PARAMETERS:
;	name  - Entry name base
;	count - Number of entries
;	size  - Size of entry
; ---------------------------------------------------------------------------

RSRPT macro name, count, size
	local	cnt
	cnt: = 0
	rept	\count
		\name\\$Cnt:	rs.\0	\size
		cnt: = cnt+1
	endr
	endm

; ---------------------------------------------------------------------------
; Push RS value
; ---------------------------------------------------------------------------

rsStack: = 0
RSPUSH macro
	rsStackVal\#rsStack\: =	__rs
	rsStack: = rsStack+1
	endm

; ---------------------------------------------------------------------------
; Pop RS value
; ---------------------------------------------------------------------------

RSPOP macro
	rsStack: = rsStack-1
	rsset	rsStackVal\#rsStack
	endm

; ---------------------------------------------------------------------------
; Store string with fixed size
; ---------------------------------------------------------------------------
; PARAMETERS:
;	len - Length of string
;	str - String to store
; ---------------------------------------------------------------------------

STRSZ macro len, str
	local	len2, str2
	if strlen(\str)>(\len)
		len2: =	\len
		str2: SUBSTR 1,\len,\str
	else
		len2: =	strlen(\str)
		str2: EQUS \str
	endif
	dc.b	"\str2"
	dcb.b	(\len)-len2, " "
	endm

; ---------------------------------------------------------------------------
; Store number with fixed number of digits
; ---------------------------------------------------------------------------
; PARAMETERS:
;	digits - Number of digits
;	num    - Number to store
; ---------------------------------------------------------------------------

NUMSTR macro digits, num
	local	num2, dig2, mask
	num2: = \num
	dig2: = 1
	mask: = 10
	while	(num2<>0)&(dig2<(\digits))
		num2: = num2/10
		mask: = mask*10
		dig2: = dig2+1
	endw
		num2: = (\num)%mask
	dcb.b	(\digits)-strlen("\#num2"), "0"
	dc.b	"\#num2"
	endm

; ---------------------------------------------------------------------------
; Store month string
; ---------------------------------------------------------------------------
; PARAMETERS:
;	month - Month ID
; ---------------------------------------------------------------------------

MTHSTR macro month
	local	mth
	mth: SUBSTR 1+(((\month)-1)*3), 3+(((\month)-1)*3), &
		"JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
	dc.b	"\mth"
	endm

; ---------------------------------------------------------------------------
; Store build date
; ---------------------------------------------------------------------------

BUILDDATE macro
	NUMSTR	4, _year+1900
	dc.b	"/"
	NUMSTR	2, _month
	dc.b	"/"
	NUMSTR	2, _day
	dc.b	" "
	NUMSTR	2, _hours
	dc.b	":"
	NUMSTR	2, _minutes
	endm

; ---------------------------------------------------------------------------
; Check if a parameter is a data register
; ---------------------------------------------------------------------------
; PARAMETERS:
;	param  - Parameter to check
; RETURNS:
;	is_reg - 0 = Not data register
;	         1 = Data register
; ---------------------------------------------------------------------------

ISDREG macro param
	local	num_str, num
	is_reg: = 0
	if strlen("\param")=2
		if instr("\param","d")=1
			num_str: SUBSTR 2,2,"\param"
			num: EQU \num_str
			if (num>=0)&(num<=7)
				is_reg: = 1
			endif
		endif
	endif
	endm

; ---------------------------------------------------------------------------
; Check if a parameter is an address register
; ---------------------------------------------------------------------------
; PARAMETERS:
;	param  - Parameter to check
; RETURNS:
;	is_reg - 0 = Not address register
;	         1 = Address register
; ---------------------------------------------------------------------------

ISAREG macro param
	local	numStr, num
	is_reg: = 0
	if strlen("\param")=2
		if instr("\param","a")=1
			numStr: SUBSTR 2,2,"\param"
			num: EQU \numStr
			if (num>=0)&(num<=7)
				is_reg: = 1
			endif
		endif
	endif
	endm

; ---------------------------------------------------------------------------
