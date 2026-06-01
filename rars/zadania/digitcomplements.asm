.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv BUFSIZE 80
.eqv SYS_EXIT0 10

.data
prompt: .asciz "Enter a string.\n"
msg: .asciz "Your string: "
input: .space BUFSIZE

.text
main:
li a7, SYS_PRTSTR
la a0, prompt
ecall

la a0, msg
ecall

li a7, SYS_READSTR
li a1, BUFSIZE
la a0, input
ecall

loop:
li t4, 9
li t5, '0'
li t6, '9'
lbu t0, (a0)
beqz t0, fin
bgt t0, t6, not_digit
blt t0, t5, not_digit
sub t0, t6, t0
addi t0, t0, 48
sb t0, (a0)
addi a0, a0, 1
j loop

not_digit:
sb t0, (a0)
addi a0, a0, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall
