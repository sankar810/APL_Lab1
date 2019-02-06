include pcmac.inc
.model small
.stack 100h

.data

Input1 DB 'Enter first number : $'
Input2 DB 'Enter second number : $'
Message DB 'Success : $'

Sign    DB  ?
M32768  db  '-32768$'

.code

main proc

      mov ax, @data
      mov ds, ax
     _Putstr Input1
     call GetDec ; number in AX after
     PUSH AX ; Input1 is pushed on stack
     _PutStr Input2
     call Getdec ; still AX
     PUSH AX ; Input2 is pushed on stack
     call GCD
     call PutDec
       
     
     
_PUTCH 13, 10
_exit 0 ; finished/return to dos
     
main ENDP    


GCD PROC
     
     PUSH BP
     MOV BP,SP
     
     MOV AX, word ptr[BP+6]
     MOV BX, word ptr[BP+4]
     CWD
     DIV BX
    
     CMP DX, 0
     JE DONE   ;Both numbers are equal
     MOV AX, DX ; Try to push DX directly
     PUSH BX
     PUSH AX
     call GCD
DONE : MOV AX, BX
       POP BP
       RET 4

GCD ENDP











;=================================PutDec===============================================
PutDec  PROC
    push    ax
    push    bx
    push    cx
    push    dx
    cmp ax, -32768 ;    -32768 is a special case as there
    jne TryNeg ;      is no representation of +32768
    _PutStr M32768
    jmp DonePutDec
TryNeg:
    cmp ax, 0 ;     If number is negative ...
    jge NotNeg
    mov bx, ax ;      save from it from _PutCh
    neg bx ;          make it positive and...
    _PutCh  '-' ;         display a '-' character
    mov ax, bx ;    To prepare for PushDigs
NotNeg:
    mov cx, 0 ;     Initialize digit count
    mov bx, 10 ;    Base of displayed number
PushDigs:
    sub dx, dx ;    Convert ax to unsigned double-word
    div bx
    add dl, '0' ;   Compute the Ascii digit...
    push    dx ;        ...push it (can push words only)...
    inc cx ;        ...and count it
    cmp ax, 0   ;   Don't display leading zeroes
    jne PushDigs
;
PopDigs:    ;       Loop to display the digits
    pop dx ;          (in reverse of the order computed)
    _PutCh  dl
    loop    PopDigs
DonePutDec:
    pop dx ;    Restore registers
    pop cx
    pop bx
    pop ax
    ret
PutDec  ENDP

GetDec  PROC
    push    bx ;        Don't need to save ax, but bx, cx, ...
    push    cx ;        ...dx must be saved and restored
    push    dx
    mov bx, 0 ;     accumulated NumberValue in bx := 0
    mov cx, 10
    mov Sign, '+' ; Guess that sign will be '+'
    _GetCh  ;       Read character ==> al
    cmp al, '-' ;   Is first character a minus sign?
    jne AfterRead
    mov Sign, '-' ;   yes
ReadLoop:
    _GetCh
AfterRead:
    cmp al, '0' ;   Is character a digit?
    jl  DoneGetDec ;        No
    cmp al, '9'
    jg  DoneGetDec ;        No
    sub al, '0' ;     Yes, cvt to DigitValue and extend to a
    mov ah, 0 ;        word (so we can add it to NumberValue)
    xchg    ax, bx ;    Save DigitValue
        ;          and set up NumberValue for mul
    mul cx ;        NumberValue * 10 ...
    add ax, bx ;      + DigitValue ...
    mov bx, ax ;      ==> NumberValue
    jmp ReadLoop
DoneGetDec:
    cmp al, 13 ;    If last character read was a RETURN...
    jne NoLF
    _PutCh 10 ;     ...echo a matching line feed
NoLF:
    cmp Sign, '-'
    jne Positive
    neg bx ;        Final result is in bx
Positive:
    mov ax, bx ;    Returned value --> ax
    pop dx ;        restore registers
    pop cx
    pop bx
    ret
GetDec  ENDP


end main