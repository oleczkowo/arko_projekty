section .text
    global reversepairs

reversepairs:
    push ebp
    mov ebp, esp

    push ebx

    mov eax, [ebp + 8] ; pointer na input

main_loop:
    mov bl, [eax]
    test bl, bl
    jz fin
    mov bh, [eax + 1]
    test bh, bh
    jz fin
    mov [eax], bh
    mov [eax + 1], bl
    add eax, 2
    jmp main_loop

fin:
    mov eax, [ebp + 8]

    pop ebx

    pop ebp
    ret