section .text
    global reverselet

reverselet:
    push ebp
    mov ebp, esp

    push ebx
    push esi

    mov eax, [ebp + 8] ; wskaźnik na input
    mov cl, 0 ; counter długości input
    mov ch, 0 ; counter liter

count_len_dig:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin_analyse
    cmp bl, 'A'
    jb not_letter
    cmp bl, 'Z'
    ja second_check
    inc cl
    inc ch
    jmp count_len_dig

not_letter:
    inc cl
    jmp count_len_dig

second_check:
    cmp bl, 'a'
    jb not_letter
    cmp bl, 'z'
    ja not_letter
    inc cl
    inc ch
    jmp count_len_dig

fin_analyse:
    mov eax, [ebp + 8] ; pointer od lewej
    dec cl
    movzx edx, cl
    mov esi, [ebp + 8]
    add esi, edx ; pointer po prawej

main_loop:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz fin
    cmp ch, 1 ; to sprawdzenie pozwala na wskazanie programowi, czy coś jeszcze pozostało do zamiany, czy nie.
    jbe fin ; jak tak to skończ program
    cmp bl, 'A'
    jb main_loop ; przechodzimy dalej, nie modyfikuje nic.
    cmp bl, 'Z'
    ja lower_check
    jmp letter_search

lower_check:
    cmp bl, 'a'
    jb main_loop
    cmp bl, 'z'
    ja main_loop

letter_search:
    mov bh, [esi]
    dec esi
    cmp bh, 'A'
    jb letter_search
    cmp bh, 'Z'
    ja backwards_lower_check
    jmp switch

backwards_lower_check:
    cmp bh, 'a'
    jb letter_search
    cmp bh, 'z'
    ja letter_search

switch:
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
