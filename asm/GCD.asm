include pcmac.inc

.model small
.stack 160h

.data 
firstno db "Enter the first number 'M' $"
secondno db "Enter the second number 'N' $"
errormsg db "Division by zero attempted"
m1 db "gcd called $"
m2 db "no error $"

Sign    DB  ?
M32768  db  '-32768$'

.code
main proc
MOV AX,@DATA   ;Load the Data to AX.
MOV DS,AX     ;Move the Data AX to DS
call getdata
_putch 13,10
_exit 0

call putdec
pop bp
ret 4
main endp


error proc
_putstr errormsg
ret
error endp

getdata proc
_putstr firstno
call GETDEC
push ax
_putstr secondno
call GETDEC
push ax
call GCD
;_putstr m1
ret

getdata endp

GCD proc

push bp
mov bp,sp
mov ax,word ptr[bp+6]
mov bx,word ptr[bp+4]

cmp bx,0
je er
_putstr m2
jmp a
er:call error
a:

call putdec 
div bx
cmp ah,0
je true
jmp b
true: mov ax,bx
b:
call putdec 
ret
GCD endp


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
