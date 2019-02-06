.model small
.stack 100h

.data 
m1 DB "Factorial of $", 0
m2 DB 'IS $', 0
i DW 3

.code
INCLUDE GETDEC.ASM
INCLUDE PUTDEC.ASM
INCLUDE PCMAC.INC

start:
    mov AX, @data
    mov ds, ax
    
    push i;
    call Factorial;
    mov bx,ax
    _putstr m1
    mov ax,i
    call PutDec
    _putch 'i','s',''
    _putstr m2
    mov ax,bx
    call PutDec
    _putch 13,10
    _EXIT
    
Factorial proc
        PUSH BP;
        MOV BP,SP;
        MOV AX,word get, [BP+4]
        Cmp AX,1
        JLE Done
        SUB ax,1 ; Dec AX
        PUSH AX
        Call Factorial; d
Done:   imul word ptr[BP+4]
        POP BP
        RET Z; AX has the factorial
Factorial ENDP

mov ah,4ch
int 21h

end start
end