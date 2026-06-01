	.eqv	PRTSTR, 4
	.eqv	GETSTR, 8
	.eqv	EXIT0, 10
	
	.data
buf:	.space	100

	.text
main:
	la 	a0, buf
	li 	a1, 100
	li 	a7, GETSTR
	ecall
	mv	t0, a0		#pointer to the start of the buffer	
	li	t2, '0'
	li	t3, '9'
	mv	t5, zero	#t5 - length of the longest sequence found so far
	
find_sequence:
	lbu 	t4, (a0)
	mv	t6, a0
	addi	a0, a0, 1
	beqz	t4, move_sequence
	bltu	t4, t2, find_sequence
	bgtu	t4, t3, find_sequence	
	li	t4, 1	#t4 - length of the current sequence
	
sequence_found:
	addi	a0, a0, 1
	addi	t4, t4, 1
	lbu	s0, (a0)
	bltu	s0, t2, sequence_finished
	bleu	s0, t3, sequence_found

sequence_finished:
	bleu	t4, t5, find_sequence
	mv	t5, t4
	mv	t1, t6		#pointer to the start of the currently found longest sequence
	j	find_sequence

move_sequence:
	lbu	t4, (t1)
	sb	t4, (t0)
	addi	t1, t1, 1
	addi	t0, t0, 1
	addi	t5, t5, -1
	bnez	t5, move_sequence

exit:
	sb	zero, (t0)
	la	a0, buf
	li	a7, PRTSTR
	ecall
	li	a7, EXIT0
	ecall