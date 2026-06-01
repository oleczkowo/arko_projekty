section .text
    global getdec

getdec:
    push ebp
    mov ebp, esp
    mov ecx, [ebp + 8]
    xor edx, edx

findnum:
    mov dl, [ecx]
    inc ecx
    test dl, dl
    jz fin
    cmp dl, '0'
    jb findnum
    cmp dl, '9'
    ja findnum
    xor eax, eax

num_seq:
    lea eax, [eax + eax*4]
    lea eax, [eax*2 + edx - '0']
    mov dl, [ecx]
    inc ecx
    test dl, dl
    jz fin
    cmp dl, '0'
    jb fin
    cmp dl, '9'
    ja fin
    jmp num_seq


fin:
    pop ebp
    ret