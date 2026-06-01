.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8

.data
input: .space 80
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "

.text

main:
li a7, SYS_PRTSTR
la a0, prompt
ecall

la a0, msg
ecall

li a7, SYS_READSTR
li a1, 80
la a0, input
ecall

loop:

lbu t3, 0(a0)
beqz t3, fin
li t1, 'A'
li t2, 'Z'
blt t3, t1, not_uppercase
bgt t3, t2, not_uppercase
li t3, '*'
sb t3, 0(a0)
j loop

not_uppercase:
sb t3, 0(a0)
addi a0, a0, 1
addi a1, a1, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, 10
ecall

