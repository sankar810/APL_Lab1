.Model Small
.Stack 160h

.Data
infor db "Hello world",10,12+1
inforlen Equ 13

.Code
start: MOV AX,@data
MOV DS,AX
MOV CX,inforleN
MOV SI,0
again: MOV AL,infor[SI]
CALL printch
INC SI
LOOP again
MOV AX,4c00h
INT 21h

printch Proc Near
MOV BX,0
MOV AH,0Eh
INT 10h
RET
printch EndP

End start