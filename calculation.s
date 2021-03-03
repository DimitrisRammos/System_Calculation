######################################################################
#																	 #
#		   Calculation of b-system in conversion to decimal		 	 #
#																	 #
######################################################################

.text
	.globl __start	
														#start the program
__start:
					li $s1, 1
					li $s2, 10
loop:				
					li $v0, 4
					la $a0, give_number					#print message
					syscall


give_again:

#i read as string and i convert in int

read_int:			li $v0, 8							#code to read a string
					la $a0, base			
					li $a1, 21							#have size 21
					syscall

					la $t9, base
					li $s4, 0
					li $s0, 0
					li $t2, 9
					li $t8, -38

Loop:				lb $t1, 0($t9)						#i read this as string
					beq $t1, $zero, out
					addi $t1, $t1, -48
					beq $t1, $t8, out

					blt $t1, $zero, print_str 			#if isn't number, that is wrong
					bgt $t1, $t2, print_str

					addi $t9, $t9, 1
					addi $s4, $s4, 1					#i have on counter as if it is from up 2 digital, the input to be consider wrong
					j Loop

print_str:			li $v0, 4 							#i print the string and after that is wrong
					la $a0, base
					syscall

					li $v0, 4
					la $a0, endl
					syscall

					j wrong_number 						#is wrong 

out:				beq $s4, $zero, print_str 			#hasn't given nothing, so wrong
					li $t2, 2				  
					bgt $s4, $t2, print_str   			#the digital is 2 more
					beq $t2, $s4, LOOP_1

					#an exei ena psifio
					la $t9, base
					lb $t1, 0($t9)
					addi $t1, $t1, -48
					add $s0, $s0, $t1
					j print_number_1

					la $t9, base
					li $s4, 0

LOOP_1:				lb $t1, 0($t9)						#i read as string
					beq $t1, $zero, print_number_1
					addi $t1, $t1, -48
					beq $t1, $t8, print_number_1		#i create
					
					addi $s4, $s4, 1

					bne $s4, $t2, nexT
					mult $s1, $t1
					mflo $t3
					add $s0, $s0, $t3

					addi $t9, $t9, 1
					j LOOP_1

nexT:				mult $s2, $t1
					mflo $t3
					add $s0, $s0, $t3

					addi $t9, $t9, 1
					j LOOP_1

print_number_1:		li $v0, 1
					move $a0, $s0						#i print the number i read
					syscall

					la	$a0,endl 						# system call to print
					li	$v0, 4 							# out a newline
					syscall


					beq $s0, $zero, Exit				#if give me zero(0), i stop the program
					slti $t0, $s0, 2					#i do the necessary control, for number he gives me, so that  >=2 and <=10
					beq $t0, $s1, wrong_number

					slt $t0, $s2, $s0
					beq $t0, $s1, wrong_number


					li $v0, 4
					la $a0, number
					syscall								#print message

					li $v0, 1
					move $a0, $s0						#print the number
					syscall

					li $v0, 4
					la $a0, label_1						#i print
					syscall


read_string:		li $v0, 8						# code to read a string
					la $a0, digit_5				
					li $a1, 6						# have size 5
					syscall

print_string_1:		li $v0, 4
					la $a0, digit_5
					syscall

					li	$v0, 4 						# out a newline
					la	$a0,endl 					# system call to print
					syscall


					la $s3, digit_5
					li $s4, 0
					li $t8, -38
loop_1:				lb $t1, 0($s3)
					beq $t1, $zero, print_number
					addi $t1, $t1, -48
					beq $t1, $t8, print_number
					bge $t1, $s0, wrong_digit_5 				# if it not belong in numbering system or it isn't number
					blt $t1, $zero,	wrong_digit_5 				# if it isn't number
					addi $s4, $s4, 1

					addi $s3, $s3, 1							#addi

					j loop_1

print_number:		li $v0, 4
					la $a0, number_demical						#i print a message, who is a number he gives me in decimal system
					syscall

					#
					move $s5, $s0
					li $s6, 1

					beq $s4, $zero, give_string

					addi $s4, $s4, -1

loop_2:				beq $s4, $zero, print_1  					#i do mutiplication for to finf the power for each condition
					
					mult $s6, $s5
					mflo $s6

					addi $s4, $s4, -1
					j loop_2


print_1:			la $s3, digit_5
					li $s7, 0

loop_3:				lb $t1, 0($s3)							#With the base every power, for each condition, i finfe the number is demical system
					beq $t1, $zero, print_dem
					addi $t1, $t1, -48
					beq $t1, $t8, print_dem
					mult $s6, $t1
					mflo $t1

					add $s7, $s7, $t1

					div $s6, $s0							#i do division to take the next condition
					mflo $s6

					addi $s3, $s3, 1
					j loop_3


print_dem:			li $v0, 1
					move $a0, $s7							#print the demical number, that i creat before
					syscall

					la	$a0,endl 							# system call to print
					li	$v0, 4 								# out a newline
					syscall

					j loop




give_string:		li $v0, 4
					la $a0, please_give_string			#if string is free, than i request again the string
					syscall

					j read_string


wrong_digit_5:		li $v0, 4
					la $a0, wrong_number_digit_5		#i print wrong message, why the number from string isn't in the numbering system,
					syscall								# of the number given from the start

					j read_string


wrong_number:		li $v0, 4
					la $a0, wrong_1					#i print wrong message, because the number is different from the limit
					syscall


					j give_again

Exit:				li 		$v0, 10
					syscall							#END

#################################################
#			 									#
#     	 	    data segment					#
#												#
#################################################

	.data
endl: 					.asciiz 	"\n"
give_number:			.asciiz		"Give base: \n"
wrong_1:				.asciiz		"Wrong base; give again: \n"
number:					.asciiz		"Give 5-digit number in base "
wrong_number_digit_5:	.asciiz		"Wrong number; give again \n"
please_give_string:		.asciiz		"Wrong, Please give 5-digit number in base \n"
number_demical:			.asciiz		"Number in decimal is: \n"
label_1:				.asciiz		": \n"
digit_5:				.asciiz		"------"
base:					.asciiz		"--------------------"



##########################################################
#														 #
#		   				 END	 	 				 	 #
#														 #
##########################################################
