.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv BUFSIZE 80
.eqv SYS_EXIT0 10

.data
input: .space BUFSIZE
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "
merged: .space BUFSIZE
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
la a2, merged
ecall

loop:
lbu t0, (a0)
beqz t0, fin
li t1, '0'
li t2, '9'
blt t0, t1, not_digit
bgt t0, t2, not_digit
addi a0, a0, 1
j loop

not_digit:
sb t0, (a2)
addi a0, a0, 1
addi a2, a2, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, merged
ecall

li a7, SYS_EXIT0
ecall
