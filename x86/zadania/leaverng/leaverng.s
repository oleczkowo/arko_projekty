section .text
    global leaverng

leaverng:
    push ebp
    mov ebp, esp

    push ebx
    push esi

    mov eax, [ebp + 8] ; input str
    mov esi, [ebp + 8]
    mov cl, [ebp + 12] ; pierwszy znak
    mov ch, [ebp + 16] ; drugi znak

main_loop:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, cl
    jb not_in_range
    cmp bl, ch
    ja not_in_range
    mov [esi], bl
    inc esi
    jmp main_loop

not_in_range:
    jmp main_loop

fin:
    mov eax, [ebp + 8]
    mov [esi], bl

    pop esi
    pop ebx

    pop ebp
    ret