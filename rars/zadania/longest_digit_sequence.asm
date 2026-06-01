# chce zrobiæ to zadanie na jednym buforze.

.eqv SYS_PRTSTR 4
.eqv SYS_READSTR 8
.eqv SYS_EXIT0 10
.eqv BUFSIZE 80
.eqv SEQ_COUNTER t0
.eqv MAX_SEQ_INDEX t1
.eqv MAX_SEQ_LENGTH t2
.eqv CURRENT_SEQ_INDEX t3

.data
prompt: .asciz "Enter a string\n"
msg: .asciz "Your string: "
input: .space BUFSIZE
found_seq: .space BUFSIZE

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

li SEQ_COUNTER, 0
li MAX_SEQ_INDEX, 0
li MAX_SEQ_LENGTH, 0
li CURRENT_SEQ_INDEX, 0
li t4, '0'
li t5, '9'

loop:
lbu t6, (a0)
beqz t6, analyse_fin
blt t6, t4, not_digit
bgt t6, t5, not_digit
j sequence_start

sequence_start:
li SEQ_COUNTER, 0
mv CURRENT_SEQ_INDEX, a0
addi SEQ_COUNTER, SEQ_COUNTER, 1
addi a0, a0, 1
lbu t6, (a0)
beqz t6, sequence_at_fin
blt t6, t4, end_sequence
bgt t6, t5, end_sequence
j sequence_middle

not_digit:
addi a0, a0, 1 # not a digit, out of sequence
j loop

sequence_middle:
addi SEQ_COUNTER, SEQ_COUNTER, 1
addi a0, a0, 1
lbu t6, (a0)
beqz t6, sequence_at_fin
blt t6, t4, end_sequence         
bgt t6, t5, end_sequence
j sequence_middle

end_sequence:
bgt SEQ_COUNTER, MAX_SEQ_LENGTH, new_max_found
j loop

new_max_found:
mv MAX_SEQ_INDEX, CURRENT_SEQ_INDEX
mv MAX_SEQ_LENGTH, SEQ_COUNTER
j loop

sequence_at_fin:
bgt SEQ_COUNTER, MAX_SEQ_LENGTH, new_max_found
j analyse_fin

analyse_fin:
la a2, found_seq
la a0, input
bnez MAX_SEQ_LENGTH, print_sequence
la a0, found_seq
li a7, SYS_PRTSTR
ecall

li a7, SYS_EXIT0
ecall

print_sequence:
la a0, input
lbu t0, (MAX_SEQ_INDEX)
sb t0, (a2)
addi MAX_SEQ_LENGTH, MAX_SEQ_LENGTH, -1
addi MAX_SEQ_INDEX, MAX_SEQ_INDEX, 1
addi a0, a0, 1
addi a2, a2, 1
beqz MAX_SEQ_LENGTH, analyse_fin
j print_sequence





