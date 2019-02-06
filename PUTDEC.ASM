;; PUTDEC.ASM -- a procedure PutDec which displays the contents of
;;   ax as a signed decimal number on the CRT.
;;
;;   call via:
;;	EXTRN	PutDec: NEAR
;;	mov	ax, theNumber
;;	call	PutDec
;;
;;  Program text from "Assembly Language for the IBM PC Family" by
;;   William B. Jones, (c) Copyright 1992, 1997 Scott/Jones Inc.
;;
	.MODEL	SMALL
INCLUDE PCMAC.INC
	.DATA
M32768	db	'-32768$'
	.CODE
	PUBLIC	PutDec
PutDec	PROC
	push	ax
	push	bx
	push	cx
	push	dx
	cmp	ax, -32768 ;	-32768 is a special case as there
	jne	TryNeg ;	  is no representation of +32768
	_PutStr M32768
	jmp	Done
TryNeg:
	cmp	ax, 0 ;		If number is negative ...
	jge	NotNeg
	mov	bx, ax ;	  save from it from _PutCh
	neg	bx ;		  make it positive and...
	_PutCh	'-' ;		  display a '-' character
	mov	ax, bx ;	To prepare for PushDigs
NotNeg:
	mov	cx, 0 ;		Initialize digit count
	mov	bx, 10 ;	Base of displayed number
PushDigs:
	sub	dx, dx ;	Convert ax to unsigned double-word
	div	bx
	add	dl, '0' ;	Compute the Ascii digit...
	push	dx ;		...push it (can push words only)...
	inc	cx ;		...and count it
	cmp	ax, 0 	;	Don't display leading zeroes
	jne	PushDigs
;
PopDigs:	;		Loop to display the digits
	pop	dx ;		  (in reverse of the order computed)
	_PutCh	dl
	loop	PopDigs
Done:
	pop	dx ;	Restore registers
	pop	cx
	pop	bx
	pop	ax
	ret
PutDec	ENDP
	END
