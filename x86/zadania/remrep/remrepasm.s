section .text
    global remrepasm

remrepasm:

    push ebp
    mov ebp, esp

    push ebx ; będę używać do przekazywania bajtów
    push esi ; będę używać jako pointer zapisujący
    push edi

    mov eax, [ebp + 8] ; pointer na stringa (odczytujący)
    mov esi, [ebp + 8] ; pointer na stringa (zapisujący)
    mov edi, 0 ; indeks potrzebny do trackowania ostatnio przyjętej pozycji dla nadpisania bh.
    mov bh, 0

first_letter:
    mov bl, [eax] ; załaduj bajt do bl
    inc eax ; inkrementuj wskaźnik
    test bl, bl ; sprawdź czy nullptr
    jz fin ; jak tak to skończ program
    inc edi ; inkrementuj pointer na znak (kolejny znak będzie na miejscu początek + 1)
    mov bh, bl ; kod dla pierwszej litery w podanym string
    mov [esi], bh ; zapisz pierwszą występującą nową literę
    inc esi ; inkrementuj wskaźnik zapisujący

letter_repetition:
    mov bl, [eax] ; nowy bajt do bl
    inc eax ; inkrementacja wskaźnika
    test bl, bl ; sprawdzenie czy nullptr
    jz try_new_letter ; jak tak, spróbuj wziąć nową literę / znak
    cmp bl, bh ; sprawdź, czy jest to znak analizowany
    jne save_letter ; jak nie to zachowaj ten znak
    jmp letter_repetition ; w innym przypadku pomiń ten znak (powtórzenie)

save_letter:
    mov [esi], bl ; zapisywanie znaku w miejscu wskazywanym przez esi
    inc esi
    jmp letter_repetition

try_new_letter:
    dec eax
    mov [esi], bl
    mov eax, [ebp + 8] ; powrót do początku
    mov esi, [ebp + 8] ; powrót do początku
    add esi, edi ; dodanie, aby wskazać na nowy znak
    add eax, edi ; to samo.
    mov bl, [eax] ; nowy bajt
    inc eax ; inkrementuj wskaźnik
    test bl, bl ; sprawdź, czy nullptr
    jz fin ; jak tak to zakończ
    mov bh, bl ; zmień znak w bh
    mov [esi], bh ; załaduj do aktualnego miejsca wskazanego przez esi bajt bh.
    inc esi ; inkrementuj esi
    inc edi ; inkrementuj edi
    jmp letter_repetition


fin:
    dec eax
    mov [esi], bl
    mov eax, [ebp + 8]

    pop edi
    pop esi
    pop ebx

    pop ebp
    ret