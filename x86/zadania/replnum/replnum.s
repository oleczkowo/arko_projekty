section .text
    global replnum

replnum:
    push ebp
    mov ebp, esp

    push esi
    push ebx

    mov eax, [ebp + 8] ; ptr na inputstr
    mov esi, [ebp + 8] ; ptr na inputstr (zapisujący)
    mov cl, [ebp + 12] ; char z zadania

start:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, '0'
    jb not_digit
    cmp bl, '9'
    ja not_digit
    mov [esi], cl
    inc esi
    jmp digit_seq

digit_seq:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp bl, '0'
    jb not_digit
    cmp bl, '9'
    ja not_digit
    jmp digit_seq

not_digit:
    mov [esi], bl
    inc esi
    jmp start


fin:
    mov [esi], bl
    mov eax, [ebp + 8]
    pop ebx
    pop esi

    pop ebp
    ret