.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv SYS_EXIT0 10
.eqv BUFSIZE 80

.data
input: .space BUFSIZE
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "

.text
main:
li a7, SYS_PRTSTR
la a0, prompt
li a1, BUFSIZE
ecall

la a0, msg
ecall

li a7, SYS_READSTR
la a0, input
ecall

loop:
lbu t0, (a0)
beqz t0, fin

li t1, '0'
li t2, '9'
bltu t0, t1, not_digit
bgtu t0, t2, not_digit
li t0, '*'
sb t0, (a0)
addi a0, a0, 1
addi a1, a1, 1
j loop

not_digit:
sb t0, (a0)
addi a0, a0, 1
addi a1, a1, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall