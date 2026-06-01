.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv SYS_EXIT0 10
.eqv BUFSIZE 80
.eqv SEQ_FLAG t4

.data
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "
input: .space BUFSIZE
new: .space BUFSIZE

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
la a2, new
ecall

li t5, 'A'
li t6, 'Z'
li SEQ_FLAG, 0
li t3, 1

loop:
lbu  t0, (a0)
beqz t0, fin
blt t0, t5, not_upper
bgt t0, t6, not_upper
beq SEQ_FLAG, t3, sequence 
sb t0, (a2)
addi a0, a0, 1
addi a2, a2, 1
li SEQ_FLAG, 1
j loop

not_upper:
sb t0, (a2)
addi a0, a0, 1
addi a2, a2, 1
li SEQ_FLAG, 0
j loop

sequence:
addi a0, a0, 1
j loop

fin:
li a7, SYS_PRTSTR
la a0, new
ecall

li a7, SYS_EXIT0
ecall
