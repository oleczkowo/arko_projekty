# za³o¿enia do zadania / notatki do obmyœlenia programu
# 1. je¿eli bespoœrednio po napotkaniu numeru napotkamy spacjê, a nastêpnie kolejny numer, program wyrzuci b³¹d.
# 2. rozumiej¹c zapis naturalny zak³adam, ¿e napotkanie czegokolwiek oprócz spacji/numeru na pierwszym znaku oznacza nieprawid³owy zapis / wyst¹pienie b³êdu w programie.
# 3. podobnie jak w punkcie pierwszym, napotkanie na pary operatorów równie¿ skutkuje b³êdem (nie uwzglêdniam dodawania ujemnych liczb)
# 4a. znak = mo¿e wyst¹piæ niezale¿nie od tego, kiedy i gdzie siê znajduje. Mo¿liwe bêdzie wiêc napotkanie kilku takich znaków z rzêdu, znaku = bezpoœrednio po operatorze lub po liczbie.
# 4b. b³êdne zapisy znaku = to w takim wypadku <operator> = <operator>, <liczba> = <liczba>

.eqv 	SYS_PRTINT 1
.eqv 	SYS_PRTSTR 4
.eqv 	SYS_READSTR 8
.eqv 	BUFSIZE 256
.eqv 	SYS_EXIT0 10
.eqv 	SYS_EXIT2 93

.data
input: .space BUFSIZE
opfirsterr: .asciz "Equation started incorrectly. Equation has to start with a number."
fnumerr: .asciz "Equation is incorrect. First number error."
numerrone: .asciz "Syntax error. Note: equation can only contain characters 0-9, and operators -+*/="
operatorerr: .asciz "Syntax error."
zerodiverr: .asciz "Error. Division by zero attempted."
prompt: .asciz "Enter an equation (usable operators are +, -, *, /, =). Operators have equal priorites:\n"
msg: .asciz "Your equation: "
space: .asciz " "

.text
main:
	li	a7, SYS_PRTSTR
	la	a0, prompt
	li	a1, BUFSIZE
	ecall

	la	a0, msg
	ecall

	li	a7, SYS_READSTR
	la 	a0, input
	ecall

	li 	t1, '0' # this will be used for comparisons and for ASCII to digit value offset.
	li 	t2, '9'
	li 	t3, ' '
	li 	s0, '+'
	li 	s1, '-'
	li 	s2, '*'
	li 	s3, '/'
	li 	s5, '\n'
	li 	s6, '='
		
	li 	t4, 0 # encountered operator
	li 	t5, 10 # base
	li 	t6, 0 # result
	
	li 	s4, 0 # current number
	li 	s7, 0 # tracker of index (needed for equality operator implementation)

program_start:
	lbu 	t0, (a0)
	beq 	t0, s5, ending
	addi	a0, a0, 1
	addi 	s7, s7, 1
	beq 	t0, t3, program_start
	blt 	t0, t1, opferr
	bgt 	t0, t2, opferr

first_number: # this function defines program's behavior when encountering the first number.
	sub 	t0, t0, t1
	mul 	s4, s4, t5
	add 	s4, s4, t0
	lbu 	t0, (a0)
	beq 	t0, s5, first_number_end
	addi 	a0, a0, 1
	addi 	s7, s7, 1
	beq 	t0, t3, add_number # if there is a whitespace, the number was already found, so we search for an operator to appear.
	beq 	t0, s0, first_operator
	beq 	t0, s1, first_operator
	beq 	t0, s2, first_operator
	beq 	t0, s3, first_operator
	beq 	t0, s6, first_equal_sign # equal sign immediately after the first number, which means that we will have to search for an operator next
	bgeu 	t0, t1, first_check
	
fnerr:
	la 	a0, fnumerr
	j 	err
	
first_check:
	bgtu	t0, t2, fnerr
	j first_number

first_operator:
	add 	t6, t6, s4
	li 	s4, 0
	mv 	t4, t0
	j 	nbr_search

first_equal_sign:
	add 	t6, t6, s4
	li 	s4, 0
	li 	a7, SYS_PRTINT
	mv 	a0, t6
	ecall
	li 	a7, SYS_PRTSTR
	la 	a0, space
	ecall
	la 	a0, input
	add 	a0, a0, s7
	j 	search_for_operator

add_number: 
	add 	t6, t6, s4
	li 	s4, 0

search_for_operator:
	beqz 	t0, ending
	lbu 	t0, (a0)
	beq 	t0, s5, ending
	addi 	a0, a0, 1
	addi 	s7, s7, 1
	beq 	t0, s6, operator_equal_sign # we encounter an = sign after finding a number
	beq 	t0, t3, search_for_operator
	beq 	t0, s0, operator
	beq 	t0, s1, operator
	beq 	t0, s2, operator
	beq 	t0, s3, operator

operator_error:
	la 	a0, operatorerr
	j 	err

operator_equal_sign:
	li 	a7, SYS_PRTINT
	mv 	a0, t6
	ecall
	li 	a7, SYS_PRTSTR
	la 	a0, space
	ecall
	la 	a0, input
	add 	a0, a0, s7
	j 	search_for_operator

operator:
	mv 	t4, t0
	j 	nbr_search
	
nbr_equal: # this allows to write = sign after an operator, so we can come back to searching for a number after encountering an = sign.
	li 	a7, SYS_PRTINT
	mv 	a0, t6
	ecall
	li 	a7, SYS_PRTSTR
	la 	a0, space
	ecall
	la 	a0, input
	add 	a0, a0, s7

nbr_search:
	beqz 	t0, ending
	lbu 	t0, (a0)
	beq 	t0, s5, ending
	addi	a0, a0, 1
	addi 	s7, s7, 1
	beq 	t0, s6, nbr_equal # we encounter an = sign after finding an operator
	beq 	t0, t3, nbr_search # while we search for a number, we go through every whitespace that appears
	bltu 	t0, t1, number_error
	bgtu 	t0, t2, number_error

number:
	sub 	t0, t0, t1
	mul 	s4, s4, t5
	add 	s4, s4, t0
	lbu 	t0, (a0)
	beq 	t0, s5, operation
	addi	a0, a0, 1
	addi	s7, s7, 1
	beq	t0, t3, operation # if there is a whitespace, the number was already found, so we search for an operator to appear.
	beq 	t0, s0, operation_new_operator
	beq 	t0, s1, operation_new_operator
	beq 	t0, s2, operation_new_operator
	beq 	t0, s3, operation_new_operator
	beq 	t0, s6, operation # the number ends immediately after = is encountered, so we will search for an operator next. First, we have to make an operation
	bgeu	t0, t1, check_if_nbr # this includes 0 and higher ascii value characters

number_error:
	la 	a0, numerrone
	j 	err
	
check_if_nbr:
	bgtu	t0, t2, number_error
	j number

operation_new_operator:
	bne 	t4, s0, sub_number_no
	add 	t6, t6, s4
	j 	end_op_no

sub_number_no:
	bne	t4, s1, mul_number_no
	sub	t6, t6, s4
	j 	end_op_no
	
mul_number_no:
	bne 	t4, s2, divi_number_no
	mul 	t6, t6, s4
	j 	end_op_no

divi_number_no:
	beqz 	s4, zdiverr
	div 	t6, t6, s4
	
end_op_no:
	li 	s4, 0
	mv 	t4, t0
	j 	nbr_search


operation:
	bne 	t4, s0, sub_new_number
	add 	t6, t6, s4
	beq 	t0, s5, end_op_ls
	j 	end_op_nn

sub_new_number:
	bne 	t4, s1, mul_new_number
	sub 	t6, t6, s4
	beq 	t0, s5, end_op_ls
	j 	end_op_nn
	
mul_new_number:
	bne 	t4, s2, divi_new_number
	mul 	t6, t6, s4
	beq 	t0, s5, end_op_ls
	j 	end_op_nn

divi_new_number:
	beqz 	s4, zdiverr
	div 	t6, t6, s4
	beq 	t0, s5, end_op_ls

end_op_nn:
	li 	s4, 0
	beq 	t0, s6, operator_equal_sign
	j 	search_for_operator
	
end_op_ls: # this occurs when equation ends with a number
	li 	s4, 0
	j 	ending

opferr:
	la 	a0, opfirsterr
	j 	err

zdiverr:
	la 	a0, zerodiverr

err:
	li 	a7, SYS_PRTSTR
	ecall
	li 	a0, 1
	li 	a7, SYS_EXIT2
	ecall
	
first_number_end:
	add 	t6, t6, s4

ending:
	li 	a7, SYS_PRTINT
	mv 	a0, t6
	ecall
	
fin:
	li 	a7, SYS_EXIT0
	ecall
