section .text
    global lvlstnasm

lvlstnasm:
    push ebp ; odtwórz ebp
    mov ebp, esp ; rusz esp do ebp

    push ebx
    push esi

    mov eax, [ebp + 8] ; wskaźnik na string wejściowy
    mov esi, [ebp + 8] ; wskaźnik na string wejściowy (zapisujący)
    mov cl, [ebp + 12] ; wskaźnik na int wejściowy
    mov ch, 0 ; counter ilości cyfr

count_word_digit:
    mov bl, [eax] ; załaduj bajt stringa
    inc eax ; zinkrementuj eax
    test bl, bl ; sprawdź, czy bajt jest nullptr
    jz fin_count_digit ; jak tak, zakończ liczenie ilości liczb
    cmp bl, '0' ; sprawdzam, czy cyfra
    jb not_digit
    cmp bl, '9'
    jg not_digit
    inc ch ; jeżeli nie wykonaliśmy skoku, jest to cyfra, więc zinkrementuj counter
    jmp count_word_digit ; wróć do pętli

not_digit:
    jmp count_word_digit

fin_count_digit:
    dec eax
    mov eax, [ebp + 8] ; wróć do argumentu wejściowego
    cmp cl, ch
    jge print_all_digits
    sub ch, cl ; odejmij counter ilości cyfr od podanej ilości zachowanych cyfr

main_loop:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz finish
    cmp bl, '0'
    jb delete
    cmp bl, '9'
    jg delete
    cmp ch, 0
    jbe save_digit
    dec ch
    jmp main_loop

delete:
    jmp main_loop

save_digit:
    mov dl, bl
    mov [esi], dl
    inc esi
    jmp main_loop

print_all_digits:
    mov bl, [eax]
    inc eax
    test bl, bl
    jz finish
    cmp bl, '0'
    jb avoid
    cmp bl, '9'
    jg avoid

    jmp save

avoid:
    jmp print_all_digits

save:
    mov dl, bl
    mov [esi], dl
    inc esi
    jmp print_all_digits

finish:
    dec eax
    mov dl, bl
    mov [esi], dl
    mov eax, [ebp + 8]

    pop esi
    pop ebx

    pop ebp
    ret




