default rel

section .text
    global wu_line

wu_line:
    push    ebp
    mov     ebp, esp
    sub     esp, 8 ; two local variables : gradient, and a flag

    push    ebx
    push    edi
    push    esi

wu_start:
    mov     eax, [ebp + 20] ; all arguments are passed as integers
    mov     ecx, [ebp + 12]
    mov     DWORD [ebp-8], 0
    cmp     ecx, eax ; compare xe to xs
    jne     wu_select_direction

    mov     eax, [ebp + 24]
    mov     ecx, [ebp + 16]
    cmp     eax, ecx ; compare ye to ys
    jne     wu_select_direction
    ; single point provided by four arguments, so draw a pixel
    push    DWORD [ebp + 28]
    push    DWORD [ebp + 16]
    push    DWORD [ebp + 12]
    push    DWORD [ebp + 8]
    call    set_pixel
    add     esp, 16

    jmp     end

wu_select_direction:
    mov     eax, [ebp + 20] ; load xe
    mov     ecx, [ebp + 24] ; load ye
    sub     eax, [ebp + 12] ; xe - xs
    sub     ecx, [ebp + 16] ; ye - ys

    ; here to get absolute of (xe - xs) we have to do
    ; ((xe - xs XOR (xe - xs)>>31)) - (xe - xs>>31)

    mov     esi, eax ; store xe - xs in esi
    mov     edi, ecx ; store ye - ys in edi

    sar     esi, 0x1F ; shift (xe - xs) right by 31 (0x1F)
    xor     eax, esi ; (xe - xs) XOR (xe-xs)>>31
    sub     eax, esi ; abs(xe - xs)

    sar     edi, 0x1F ; shift (ye - ys) right by 31
    xor     ecx, edi ; (ye - ys) XOR (ye-ys)>>31
    sub     ecx, edi ; abs(ye - ys)

    cmp     eax, ecx ; comparison of these two absolute values
    jb      vertical ; if abs(dx) < abs(dy), use vertical function
    xor     ecx, ecx

swap_check_start_end:
    mov     eax, [ebp + 12] ; load starting point x or y
    cmp     eax, [ebp + 20] ; load ending point x or y
    jb      is_positive_dx ; if xs/ys < xe/ye, don't swap start point with end point

    ; else, swap starting point with ending point

    mov     eax, [ebp + 12]
    mov     ebx, [ebp + 20]
    mov     [ebp + 20], eax
    mov     [ebp + 12], ebx

    mov     eax, [ebp + 16]
    mov     ebx, [ebp + 24]
    mov     [ebp + 24], eax
    mov     [ebp + 16], ebx

; I have to take into account, that xs might still be bigger than xe, even after swapping for fe. vertical ye < ys.
; This would mean, that the gradient would be negative, which is bad considering I'm working on unsigned integers.

is_positive_dx:
    mov     eax, [ebp + 12]
    mov     ebx, [ebp + 20]
    cmp     eax, ebx ; if xs > xe, dx has to be xs-xe instead of xe-xs.
    jb     calculate_dx
    sub     eax, ebx ; xs - xe
    mov     esi, eax
    mov     eax, [ebp - 8]
    inc     eax
    mov     [ebp - 8], eax
    jmp     is_positive_dy

; note: it is impossible to have both dx and dy negative, since there is a
; check function that might swap starting point with endpoint before that.

calculate_dx:
    mov     eax, [ebp + 20] ; load xe
    sub     eax, [ebp + 12] ; xe - xs
    mov     esi, eax ; store dx (xe-xs) in esi

is_positive_dy:
    mov     eax, [ebp + 16]
    mov     ebx, [ebp + 24]
    cmp     eax, ebx
    jb     calculate_dy
    sub     eax, ebx
    mov     edi, eax
    mov     eax, [ebp - 8]
    inc     eax
    mov     [ebp - 8], eax
    jmp     calculate_gradient

calculate_dy:
    mov     eax, [ebp + 24] ; load ye
    sub     eax, [ebp + 16] ; ye - ys
    mov     edi, eax ; store dy (ye-ys) in edi

calculate_gradient:
    cmp     esi, 0 ; if dx is 0
    je      gradient1 ; make gradient equal to 1
    mov     eax, edi ; load dy from edi to eax
    sal     eax, 0x10 ; convert dy to 16.16
    mov     ebx, esi ; load dx to ebx
    sal     ebx, 0x10 ; convert dx to 16.16
    shld    edx, eax, 0x10 ; prepare for division
    idiv    DWORD ebx ; divide
    mov     [ebp - 4], eax ; store gradient = dy/dx in [ebp-4]

compute_slope:
    mov     eax, [ebp + 28] ; int of color (fe. 0x000000FF)
    sal     eax, 0x10 ; now it will be fe. 0x00FF0000
    mov     [ebp + 28], eax ; store it back to color [ebp+28]

    mov     eax, [ebp + 12] ; load xs/ys to eax

    mov     ebx, [ebp + 16] ; load y0 (yf = y0)
    sal     ebx, 0x10 ; turn yf to a 16.16 fixed point number

    test    cl, cl
    jnz     vertical_loop

horizontal_loop:
    ; eax - xs integer value
    ; ebx - yf formatted to 16.16
    ; ecx - (int)yf (truncated)
    ; edx - fract_part(yf)
    ; edi - 1 - fract_part(yf)
    ; esi - color calculations (color1 and color2)
    ; [ebp - 4] - gradient formatted to 16.16
    ; [ebp + 28] - color in 16.16 format

    cmp     eax, [ebp + 20] ; compare xs to xe
    ja      end ; if above, end program

    mov     ecx, ebx ; load 16.16 yf to ecx
    sar     ecx, 0x10 ; truncate to (int)yf

    mov     edx, ebx ; load 16.16 yf to edx
    and     edx, 0x0000FFFF

    mov     edi, 0x00010000 ; load 16.16 1 representation into edi
    sub     edi, edx ; 1 - fract_part(yf) = rfract_part(yf)

    mov     esi, [ebp + 28] ; load 16.16 color into esi
    sar     esi, 16
    imul    esi, edi ; multiply color * rfract_part(yf)
    sar     esi, 16
    and     esi, 0x000000FF

    push    esi ; color argument
    push    ecx ; yf
    push    eax ; xs
    push    DWORD [ebp+8] ; push the pointer to bitmap
    call    set_pixel
    add     esp, 16

    inc     ecx

    mov     esi, [ebp + 28] ; load 16.16 color into esi
    sar     esi, 16
    imul    esi, edx ; multiply color * fract_part(yf)
    sar     esi, 16
    and     esi, 0xFF

    push    esi ; color argument
    push    ecx ; yf
    push    eax ; xs
    push    DWORD [ebp+8] ; push the pointer to bitmap
    call    set_pixel
    add     esp, 16

    dec     ecx
    inc     eax

    mov     esi, [ebp-8]
    test    esi, esi
    jnz     hor_negative_gradient

    add     ebx, [ebp - 4]

    jmp     horizontal_loop

vertical_loop:
    cmp     eax, [ebp + 20] ; compare xs to xe
    ja      end ; if above, end program

    mov     ecx, ebx ; load 16.16 yf to ecx
    sar     ecx, 0x10 ; truncate to (int)yf

    mov     edx, ebx ; load 16.16 yf to edx
    and     edx, 0x0000FFFF

    mov     edi, 0x00010000 ; load 16.16 1 representation into edi
    sub     edi, edx ; 1 - fract_part(yf) = rfract_part(yf)

    mov     esi, [ebp + 28] ; load 16.16 color into esi
    sar     esi, 16
    imul    esi, edi ; multiply color * rfract_part(yf)
    sar     esi, 16
    and     esi, 0x000000FF

    push    esi ; color argument
    push    eax ; inverted arguments
    push    ecx
    push    DWORD [ebp+8] ; push the pointer to bitmap
    call    set_pixel
    add     esp, 16

    inc     ecx

    mov     esi, [ebp + 28] ; load 16.16 color into esi
    sar     esi, 16
    imul    esi, edx ; multiply color * fract_part(yf)
    sar     esi, 16
    and     esi, 0xFF

    push    esi ; color argument
    push    eax
    push    ecx
    push    DWORD [ebp+8] ; push the pointer to bitmap
    call    set_pixel
    add     esp, 16

    dec     ecx
    inc     eax

    mov     esi, [ebp-8]
    test    esi, esi
    jnz     ver_negative_gradient

    add     ebx, [ebp - 4]

    jmp     vertical_loop

hor_negative_gradient:
    sub     ebx, [ebp-4]
    jmp     horizontal_loop

ver_negative_gradient:
    sub     ebx, [ebp-4]
    jmp     vertical_loop


vertical:
    ; swap xs with ys
    mov     eax, [ebp + 12] ; load xs into eax
    mov     ecx, [ebp + 16] ; load ys into ecx
    mov     [ebp + 16], eax ; load xs from eax into ys
    mov     [ebp + 12], ecx ; load ys from ecx into xs
    ; swap xe with ye
    mov     eax, [ebp + 20] ; load xe into eax
    mov     ecx, [ebp + 24] ; load ye into ecx
    mov     [ebp + 24], eax ; load xe from eax into ye
    mov     [ebp + 20], ecx ; load ye from ecx into ys
    ; zero ecx to use as a flag
    xor     ecx, ecx
    inc     cl
    jmp     swap_check_start_end

end:
    pop    esi
    pop    edi
    pop    ebx

    add    esp, 8
    pop    ebp
    ret

gradient1:
    mov     DWORD [ebp - 4], 0x00010000
    jmp     compute_slope

set_pixel: ; C declaration: set_pixel(unsigned char* bmp, uint32_t x, uint32_t y, uint32_t color)
    push    ebp
    mov     ebp, esp

    push    ecx
    push    ebx
    push    edx
    push    eax

    mov     eax, [ebp+8] ; pointer at the bmp header
    mov     ebx, [eax+18] ; width of the image is stored at this offset in the bmp header
    mov     ecx, [ebp+16] ; provided y value

    add     ebx, 3 ; add 3 to width
    and     ebx, 0xFFFFFFFC ; mask with ~3
    imul    ebx, ecx ; width * y

    mov     edx, [ebp+12] ; x value
    add     ebx, edx ; add x value to ebx
    add     ebx, eax ; add ebx value to pointer to bitmap
    add     ebx, 54 + 1024 ; offset for 8bpp files

    mov     edx, [ebp+20] ; color value
    mov     [ebx], dx ; write this color to pixel stored in ebx

    pop     eax
    pop     edx
    pop     ebx
    pop     ecx

    leave
    ret