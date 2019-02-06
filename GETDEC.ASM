;; GETDEC.ASM -- a function to read a decimal number (with optional
;;   minus sign) from the keyboard and return the binary value in ax
;;   There is no error checking
;;
;;	calling sequence:
;;	EXTRN	GetDec: NEAR
;;	call	GetDec ;	On return, number read is in ax
;;
;;  Program text from "Assembly Language for the IBM PC Family" by
;;   William B. Jones, (c) Copyright 1992, 1997 Scott/Jones Inc.
;;
	.MODEL	SMALL
INCLUDE	PCMAC.INC
	.DATA
Sign	DB	?
	.CODE
	PUBLIC	GetDec
GetDec	PROC
	push	bx ;		Don't need to save ax, but bx, cx, ...
	push	cx ;		...dx must be saved and restored
	push	dx
	mov	bx, 0 ;		accumulated NumberValue in bx := 0
	mov	cx, 10
	mov	Sign, '+' ;	Guess that sign will be '+'
	_GetCh	;		Read character ==> al
	cmp	al, '-' ;	Is first character a minus sign?
	jne	AfterRead
	mov	Sign, '-' ;	  yes
ReadLoop:
	_GetCh
AfterRead:
	cmp	al, '0' ;	Is character a digit?
	jl	Done ;		  No
	cmp	al, '9'
	jg	Done ;		  No
	sub	al, '0' ;	  Yes, cvt to DigitValue and extend to a
	mov	ah, 0 ;		   word (so we can add it to NumberValue)
	xchg	ax, bx ;	Save DigitValue
		;		   and set up NumberValue for mul
	mul	cx ;		NumberValue * 10 ...
	add	ax, bx ;	  + DigitValue ...
	mov	bx, ax ;	  ==> NumberValue
	jmp	ReadLoop
Done:
	cmp	al, 13 ;	If last character read was a RETURN...
	jne	NoLF
	_PutCh 10 ;		...echo a matching line feed
NoLF:
	cmp	Sign, '-'
	jne	Positive
	neg	bx ;		Final result is in bx
Positive:
	mov	ax, bx ;	Returned value --> ax
	pop	dx ;		restore registers
	pop	cx
	pop	bx
	ret
GetDec	ENDP
	END
