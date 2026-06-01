section .text
    global reversedig

reversedig:
    push ebp
    mov ebp, esp

    push ebx
    push esi

    mov eax, [ebp + 8]

    xor cl, cl ; counter długości input - 1 (przyda się, by przeskoczyć jednym pointerem do końca string.)
    xor ch, ch; counter ilości cyfr

count_len_dig:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin_analyse
    cmp bl, '0'
    jb not_digit
    cmp bl, '9'
    ja not_digit
    inc cl
    inc ch
    jmp count_len_dig

not_digit:
    inc cl
    jmp count_len_dig

fin_analyse:
    mov eax, [ebp + 8] ; ustaw wskaźnik z powrotem na input
    mov esi, [ebp + 8]
    dec cl
    movzx edx, cl
    add esi, edx; ustaw wskaźnik na koniec inputa

main_loop:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp ch, 1 ; to sprawdzenie pozwala na wskazanie programowi, czy coś jeszcze pozostało do zamiany, czy nie.
    jbe fin ; jak tak to skończ program
    cmp bl, '0' ; sprawdź czy cyfra
    jb main_loop ; jak nie to szukaj dalej
    cmp bl, '9'
    ja main_loop
    jmp digit_search

digit_search:
    mov bh, [esi]
    dec esi
    test bh, bh
    jz fin
    cmp bh, '0'
    jb digit_search
    cmp bh, '9'
    ja digit_search
    mov [esi + 1], bl
    mov [eax - 1], bh
    sub ch, 2
    jmp main_loop


fin:
    mov eax, [ebp + 8]

    pop esi
    pop ebx

    pop ebp
    ret