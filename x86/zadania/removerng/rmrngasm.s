section .text
global rmrngasm

rmrngasm:
    ; standardowy epilog procedury x86
    push ebp
    mov ebp, esp
    push esi
    push ebx
    push edi

    mov eax, [ebp + 8] ; read pointer
    mov esi, [ebp + 8] ; write pointer
    mov cl, [ebp + 12] ; 1 znak
    mov ch, [ebp + 16] ; 2 znak
    mov bl, [ebp + 20] ; znak analizowany

main_loop:
    mov bl, byte [eax] ; wstaw do bl znak analizowany
    inc eax
    cmp bl, 0 ; sprawdź, czy nullptr
    je fin ; jak tak, przejdź do fin

    cmp bl, cl ; porównaj z podanym znakiem
    jbe not_delete ; jeżeli mniejsze/równe, nie usuwaj

    cmp bl, ch ; porównaj z drugim znakiem
    jge not_delete ; jeżeli większe/równe, nie usuwaj

    ; mov byte [eax], 32, poprzednia wersja
    jmp main_loop ; nie zapisuj, leć dalej.

not_delete:
    mov dl, bl
    mov [esi], dl ; zapisz tam, gdzie wskazuje pointer
    inc esi ; inkrementuj wskazik
    jmp main_loop ; wroc do loopa

fin:
    dec eax
    mov dl, bl
    mov [esi], dl
    mov eax, [ebp + 8]

    pop edi
    pop ebx
    pop esi
    pop ebp
    ret