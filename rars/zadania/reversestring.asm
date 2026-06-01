.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv BUFSIZE 80
.eqv SYS_EXIT0 10

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

li t6, 0 # a counter for length of string
li t5, '2'

get_length:
lbu t0, (a0)
beqz t0, odd_fin
addi t6, t6, 1 # increment counter if character is not a null terminator
addi a0, a0, 1
j get_length

start_loop:
sub a0, a0, t6
div t4, t6, t5
j loop

loop:
li t1, '0'
lbu t0, (a0)
add t1, a0, t6
lbu t2, (t1)
mv t3, t0
mv t0, t2
mv t2, t3
addi a0, a0, 1
addi t1, t1, -1
beq a0, t2, fin
sb t0, (t1)
sb t2, (a0)
bgt a0, t2, odd_fin
j loop

fin:
li a7, SYS_PRTSTR
la a0, input
ecall

li a7, SYS_EXIT0
ecall

odd_fin:
sb t0, (a0)
j fin

# kod jeszcze nie dzia³a poprawnie, do zrobienia

