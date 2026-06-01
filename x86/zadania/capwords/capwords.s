section .text
    global capwords

capwords:
    push ebp
    mov ebp, esp

    push ebx ; można używać edx / ecx i nie ładować ebx, ale no cóż. Tak robię w większości zadań, więc tu robię podobnie.

    mov eax, [ebp + 8] ; pointer czytający input / zapisujący input
    mov cl, 1 ; flaga (sprawdza, czy napotkano literę po spacji / w pierwszym słowie pliku). Capitalize zmienia cl na 0.

main_loop:
    mov bl, [eax] ; ładuj bajt do bl
    inc eax ; inkrementuj eax
    test bl, bl ; sprawdź czy nullptr
    jz fin ; skończ program jak nullptr.
    test cl, cl ; sprawdź czy cl 0
    jnz first_letter ; jak tak to sprawdź czy spotkasz pierwszą literę.
    cmp bl, ' ' ; sprawdź czy spacja
    je new_word ; jak tak, będziemy szukać nowego słowa
    jmp main_loop ; skocz do pętli z powrotem

first_letter:
    cmp bl, 'A' ; porównaj z A
    jb not_a_letter ; jak mniejszy od A to nie jest litera
    cmp bl, 'Z' ; porównaj z Z
    ja lower_check ; jeżeli większy od Z, sprawdź czy to nie jest mniejsza litera
    xor cl, cl ; w innym wypadku mamy do czynienia z pierwszą literą w słowie, która od razu jest wielka.
    jmp main_loop

lower_check:
    cmp bl, 'a' ; jak znak większy od Z i mniejszy od a, nie jest literą
    jb not_a_letter
    cmp bl, 'z' ; jak znak większy od z, nie jest literą
    ja not_a_letter
    xor cl, cl
    sub bl, 32
    mov [eax - 1], bl
    jmp main_loop

not_a_letter:
    jmp main_loop

new_word:
    mov cl, 1
    jmp main_loop

fin:
    mov eax, [ebp + 8]
    pop ebx

    pop ebp
    ret