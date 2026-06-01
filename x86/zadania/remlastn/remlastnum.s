section .text
    global remlastnum

remlastnum:
    push ebp
    mov ebp, esp

    push esi
    push ebx

    mov eax, [ebp + 8] ; pointer na string (czytający)
    mov esi, [ebp + 8] ; pointer na string (zapisujący)
    mov ecx, 0 ; counter ilości sekwencji

start:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin_analyse
    cmp bl, '0'
    jb start
    cmp bl, '9'
    ja start
    jmp start_sequence

start_sequence:
    inc ecx

sequence:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin_analyse
    cmp bl, '0'
    jb start
    cmp bl, '9'
    ja start
    jmp sequence

fin_analyse:
    mov eax, [ebp + 8]

write:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, '0'
    jb save
    cmp bl, '9'
    ja save
    jmp digit

save:
    mov [esi], bl
    inc esi
    jmp write

digit:
    dec ecx

dig_sequence:
    test ecx, ecx
    jz last_sequence
    mov [esi], bl
    inc esi
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, '0'
    jb save
    cmp bl, '9'
    ja save
    jmp dig_sequence

last_sequence:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, '0'
    jb save
    cmp bl, '9'
    ja save
    jmp last_sequence


fin:
    mov eax, [ebp + 8]
    mov [esi], bl

    pop ebx
    pop esi

    pop ebp
    ret