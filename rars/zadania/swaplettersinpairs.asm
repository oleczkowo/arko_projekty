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
lbu t0, 0(a0)
beqz t0, fin
lbu t1, 1(a0)
beqz t1, odd_fin
mv t2, t1
mv t1, t0
mv t0, t2
sb t0, 0(a0)
sb t1, 1(a0)
addi a0, a0, 2
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

# w programie jest b³¹d, który przy nieparzystej liczbie znaków wypisuje ostatni¹ w nowej linii zamiast razem.