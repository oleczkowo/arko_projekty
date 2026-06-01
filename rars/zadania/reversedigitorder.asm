# Wpierw sprawdzê d³ugoœæ s³owa wejœciowego.
# Przy spotkaniu liczby z lewej zacznê sprawdzaæ od prawej, czy spotkam inn¹ liczbê.
# Bêde trzymaæ index ostatnio spotkanej liczby z lewej, oraz z prawej.
# Je¿eli index z lewej = index z prawej, nie zmieniaj.
# Je¿eli index z lewej > index z prawej, skoñcz program.


.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv SYS_EXIT0 10
.eqv BUFSIZE 80
.eqv LEFT_IDX t2
.eqv RIGHT_IDX t3

.data
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "
input: .space BUFSIZE

.text
main:
li a7, SYS_PRTSTR
li a1, BUFSIZE
la a0, prompt
ecall

la a0, msg
ecall

li a7, SYS_READSTR
la a0, input
ecall

li t0, '0'
li t1, '9'
li t4, 0

word_length:
lbu t6, (a0)
beqz t6, reset
addi t4, t4, 1
addi a0, a0, 1
j word_length

reset:
la a0, input
mv a3, t4
li t4, 0

analyse:
lbu t6, (a0)
beqz t6, fin
blt t6, t0, not_digit
bgt t6, t1, not_digit
mv LEFT_IDX, a0
j search_from_right

not_digit:
addi a0, a0, 1
j analyse

search_from_right:
lbu t5, (a3)
beq t5, a0, fin
blt t6, t0, not_digit_right
bgt t6, t1, not_digit_right
addi a3, a3, -1
mv t4, t5
mv t5, t6
mv t6, t4
li t4, 0
addi a0, a0, 1
j analyse

not_digit_right:
addi a3, a3, -1
j search_from_right

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall


