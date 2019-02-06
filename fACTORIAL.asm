Factorial Proc
        PUSH BP
        MOV BP,SP,
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


.model small
.stack 100h
.data 
m1 DB "Factorial of $"
M2 DB 'IS $'
i DW 3
    .code
main proc
    mov AX, @data
    mov ds, ax
    
    push i;
    call Factorial
    mov bx,ax
    _putstr m1
    mov ax,i
    call putdec
    _putch 'i','s',''
    _putstr m2
    mov ax,bx
    call putdec
    _putch 13,10
    _EXIT
MAIN ENDP
END MAIN