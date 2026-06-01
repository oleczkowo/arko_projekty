.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv BUFSIZE 80
.eqv SYS_EXIT0 10

.data
input: .space BUFSIZE
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "

.text
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
li t1, 'A'
li t2, 'Z'
blt t0, t1, not_a_letter
bgt t0, t2, check_if_uppercase
sb t0, (a0)
addi a0, a0, 1
j loop

not_a_letter:
li t0, '*'
sb t0, (a0)
addi a0, a0, 1
j loop

check_if_uppercase:
li t3, 'a'
li t4, 'z'
blt t0, t3, not_a_letter
bgt t0, t4, not_a_letter
sb t0, (a0)
addi a0, a0, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall

