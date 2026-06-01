section .text
    global leavelongestnum

leavelongestnum:

    push ebp
    mov ebp, esp

    push esi
    push edi
    push ebx

    mov eax, [ebp + 8] ; wskaźnik na input str
    mov esi, [ebp + 8] ; wskaźnik na input str (zapisujący)

    mov ch, 0 ; counter sekwencji
    mov dl, 0 ; długość max sekwencji
    mov cl, 0 ; miejsce początku max sekwencji (aktualne miejsce minus counter)
    mov bh, 0 ; miejsce wskaźnika eax

start:
    mov bl, [eax] ; załaduj bajt do bl
    inc eax ; inkrementuj wskaźnik
    test bl, bl ; sprawdź czy nullptr
    jz fin_analyze
    cmp bl, '0' ; sprawdź czy cyfra
    jb not_digit
    cmp bl, '9'
    ja not_digit
    jmp sequence ; cyfra - rozpocznij sekwencję

not_digit:
    inc bh ; zinkrementuj miejsce wskaźnika
    jmp start

sequence:
    inc bh ; inkrementuj miejsce wskaźnika
    inc ch ; inkrementuj counter
    mov bl, [eax]
    inc eax
    test bl, bl
    jz end_seq ; przed tym była ostatnia cyfra w inpucie.
    cmp bl, '0' ; sprawdź czy cyfra
    jb end_seq
    cmp bl, '9'
    ja end_seq
    jmp sequence

end_seq:
    cmp ch, dl
    jbe no_max
    mov cl, bh
    sub cl, ch ; wyliczam miejsce maksymalnej sekwencji
    mov dl, ch ; ładuje nową długość maksymalnej sekwencji
    xor ch, ch ; zeruje counter sekwencji
    inc bh ; inkrementuje wskaźnik indeksu
    test bl, bl
    jz fin_analyze
    jmp start

fin_analyze:
    mov eax, [ebp + 8]
    movzx ecx, cl
    add eax, ecx

write_max_seq:
    dec dl
    mov bl, [eax]
    mov [esi], bl
    inc esi
    inc eax
    test dl, dl
    jz end_write
    jmp write_max_seq

end_write:
    mov bl, 0
    mov [esi], bl
    jmp fin


no_max:
    xor ch, ch ; ani nie wyliczam miejsca max seq, ani nie ładuje nowej długości.
    inc bh
    jmp start


fin:
    mov eax, [ebp + 8]

    pop ebx
    pop edi
    pop esi

    pop ebp
    ret