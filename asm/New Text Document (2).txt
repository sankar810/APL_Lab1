include pcmac.inc

.model small
.stack 100h

.data

message db,13,10, "PROGRAM FOR GCD OF TWO NUMBERS $"
firstno db,13,10, "Enter the first number 'M': $"
secondno db,13,10, "Enter the second number 'N': $"
errormsg db,13,10, "Division by zero attempted! $"
continuemsg db,13,10, "Do you want to continue(Y/N) $"

Sign    db  ?
M32768  db  '-32768$'

.code
main proc
        
        mov ax, @data
        mov ds, ax
        call getdata            ; call getdata procedure
        call PutDec   
        _PUTCH 13, 10
        _exit 0 
     
main endp   

getdata proc
        _putstr message
flag:
        _putstr firstno         ;get first value m
        call getdec     
        push ax                 ;push it into stack
        _putstr secondno        ;get second value n
        call getdec             
        push ax                 ;push it into stack
        call GCD                ;call gcd procedure
        call putdec
        _putstr continuemsg
        _getch
        cmp al,'Y'        
        je flag
        cmp al,'y'
        je flag 
        ret         
        
getdata endp

error proc  
        _putstr errormsg        ;error message
        _exit 0
error endp

GCD proc 

        push bp
        mov bp,sp    
        mov ax, word ptr[bp+6] ; get value of m from stack
        mov bx, word ptr[bp+4] ; get value of n from stack
        cmp bx,0
        je er
        jmp label1
  er:call error                ; call error procedure
  
  label1:
        cwd
        div bx                 ;divide for modulo value
        cmp dx, 0              ;compare remainder with 0
        je true                ;Both numbers are equal
        push bx                ;push quotient i.e next m
        push dx                ;push remainder i.e next n
        call GCD               ;recursive call
  true: mov ax, bx
        pop bp                 ;clear stack
        ret 4
GCD ENDP






; putdec file

PutDec  PROC
    push    ax
    push    bx
    push    cx
    push    dx
    cmp ax, -32768              ;-32768 is a special case as there
    jne TryNeg                  ;is no representation of +32768
    _PutStr M32768
    jmp DonePutDec
TryNeg:
    cmp ax, 0                   ;If number is negative ...
    jge NotNeg
    mov bx, ax                  ;save from it from _PutCh
    neg bx                      ;make it positive and...
    _PutCh  '-'                 ;display a '-' character
    mov ax, bx                  ;To prepare for PushDigs
NotNeg:
    mov cx, 0                   ;Initialize digit count
    mov bx, 10                  ;Base of displayed number
PushDigs:
    sub dx, dx                  ;Convert ax to unsigned double-word
    div bx
    add dl, '0'                 ;Compute the Ascii digit...
    push    dx                  ;...push it (can push words only)...
    inc cx                      ;...and count it
    cmp ax, 0                   ;Don't display leading zeroes
    jne PushDigs

PopDigs:                        ;Loop to display the digits
    pop dx                      ;(in reverse of the order computed)
    _PutCh  dl
    loop    PopDigs
DonePutDec:
    pop dx                      ;Restore registers
    pop cx
    pop bx
    pop ax
    ret
PutDec  ENDP

;getdec file

GetDec  PROC
    push    bx                  ;Don't need to save ax, but bx, cx, ...
    push    cx                  ;...dx must be saved and restored
    push    dx
    mov bx, 0                   ;accumulated NumberValue in bx := 0
    mov cx, 10
    mov Sign, '+'               ;Guess that sign will be '+'
    _GetCh                      ;Read character ==> al
    cmp al, '-'                 ;Is first character a minus sign?
    jne AfterRead
    mov Sign, '-'               ;yes
ReadLoop:
    _GetCh
AfterRead:
    cmp al, '0'                 ;Is character a digit?
    jl  DoneGetDec              ;No
    cmp al, '9'
    jg  DoneGetDec              ;No
    sub al, '0'                 ;Yes, cvt to DigitValue and extend to a
    mov ah, 0                   ;word (so we can add it to NumberValue)
    xchg    ax, bx              ;Save DigitValue
                                ;and set up NumberValue for mul
    mul cx                      ;NumberValue * 10 ...
    add ax, bx                  ;+ DigitValue ...
    mov bx, ax                  ;==> NumberValue
    jmp ReadLoop
DoneGetDec:
    cmp al, 13                  ;If last character read was a RETURN...
    jne NoLF
    _PutCh 10                   ;....echo a matching line feed
NoLF:
    cmp Sign, '-'
    jne Positive
    neg bx                      ;Final result is in bx
Positive:
    mov ax, bx                  ;Returned value --> ax
    pop dx                      ;restore registers
    pop cx
    pop bx
    ret
GetDec  ENDP


end main