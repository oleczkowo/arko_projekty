.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv BUFSIZE 80
.eqv SYS_EXIT0 10
.eqv counter t6

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

li counter, 0
li t1, 'a'
li t2, 'z'
li t3, 3

loop:
lbu t0, (a0)
beqz t0, fin
blt t0, t1, not_lowercase
bgt t0, t2, not_lowercase
addi counter, counter, 1
beq counter, t3, switch
addi a0, a0, 1
j loop

not_lowercase:
addi a0, a0, 1
j loop

switch:
li counter, 0
addi t0, t0, -32
sb t0, (a0)
addi a0, a0, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall
