include pcmac.inc
INCLUDE GETDEC.ASM
INCLUDE PUTDEC.ASM

.model small
.stack 160h

.data 
message1 db "Factorial of $",0
message2 db 'IS $',0
i DW 3

.code

start:mov AX, @data
    mov ds, ax
    
    push i;
    call factorial;
    mov bx,ax
    _putstr message1
    mov ax,i
    call PutDec
    _putch 'i','s',''
    _putstr message2
    mov ax,bx
    call PutDec
    _putch 13,10
    _EXIT
    int 21h
    
factorial proc NEAR
        PUSH BP;
        MOV BP,SP;
        MOV AX,word ptr[BP+4]
        Cmp AX,1
        JLE Done
        SUB ax,1 ; Dec AX
        PUSH AX
        Call Factorial; d
Done:   imul word ptr[BP+4]
        POP BP
        RET 2; AX has the factorial
factorial EndP

End start