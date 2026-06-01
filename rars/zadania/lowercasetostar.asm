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
ecall

la a0, msg
ecall

li a7, SYS_READSTR
li a1, BUFSIZE
la a0, input
ecall

loop:
lbu t0, (a0)
beqz t0, fin

li t1, 'a'
li t2, 'z'
blt t0, t1, not_lowercase
bgt t0, t2, not_lowercase
li t0, '*'
sb t0, (a0)
addi a0, a0, 1
addi a1, a1, 1
j loop

not_lowercase:
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