section .text
    global rmnthasm

    ; plan na program: stworzenie countera i sprawdzanie, czy counter = input int. Jeżeli tak, usuwamy znak na tym miejscu.

rmnthasm:
    push ebp
    mov ebp, esp

    push ebx
    push esi

    mov eax, [ebp + 8] ; str read pointer
    mov esi, [ebp + 8] ; str write pointer
    mov cl, [ebp + 12] ; int
    mov ch, 0 ;counter

start_loop:
    mov dl, [eax] ; wrzuć aktualny bajt do dl
    inc ch
    inc eax ; inkrementuj wskaźnik eax
    test dl, dl ; sprawdź, czy dl = 0.
    jz fin

    cmp ch, cl ; sprawdź, czy counter = int
    je delete_char ; jak tak, usuń znak

    mov bl, dl ; jak nie, przerzuć znak z dl do bl
    mov [esi], bl ; zapisz znak z bl na miejscu wskazanym przez esi
    inc esi ; inkrementuj wskaznik zapisujacy stringa
    jmp start_loop ; wroc do loopa

delete_char:
    mov ch, 0
    jmp start_loop

fin:
    dec eax
    mov bl, dl ; jak nie, przerzuć znak z dl do bl
    mov [esi], bl ; zapisz znak z bl na miejscu wskazanym przez esi
    mov eax, [ebp + 8]

    pop esi
    pop ebx

    pop ebp
    ret







