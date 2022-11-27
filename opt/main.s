	.file	"main.c"
	.intel_syntax noprefix
	.text
	.globl	gen_double
	.type	gen_double, @function
gen_double:
	endbr64
	push	rbp
	mov	rbp, rsp

	# Структура стека
	# rbp_last
	# denom -> xmm1
	# num -> xmm0

	sub	rsp, 16
	mov	edi, 0
	call	time@PLT
	mov	edi, eax
	call	srand@PLT
	call	rand@PLT
	movsx	rdx, eax

	# остаток от деления на 2000
	imul	rdx, rdx, 274877907
	shr	rdx, 32
	sar	edx, 7
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 2000

	sub	eax, ecx
	mov	edx, eax
	lea	eax, -1000[rdx]
	pxor	xmm0, xmm0 
	cvtsi2sd	xmm0, eax
	call	rand@PLT
	movsx	rdx, eax
	
	# остаток от деления на 1000
	imul	rdx, rdx, 274877907
	shr	rdx, 32
	sar	edx, 6
	mov	ecx, eax
	sar	ecx, 31
	sub	edx, ecx
	imul	ecx, edx, 1000

	sub	eax, ecx
	mov	edx, eax
	lea	eax, 1[rdx]
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, eax
	
	divsd	xmm0, xmm1 # xmm0 <- num / denom
	leave
	ret
	.size	gen_double, .-gen_double
	.section	.rodata
	.align 8
.LC0:
	.string	"At least 3 parameters must be provided\n"
.LC1:
	.string	"-i"
.LC2:
	.string	"-f"
	.align 8
.LC3:
	.string	"Input/output files are not provided\n"
.LC4:
	.string	"r"
.LC5:
	.string	"w"
.LC6:
	.string	"-g"
.LC7:
	.string	"Output file is not provided\n"
.LC8:
	.string	"Invalid parameter\n"
.LC9:
	.string	"%f\n"
.LC10:
	.string	"%lf"
	.align 8
.LC13:
	.string	"The time of the calculating of %d iterations: %f clocks or %f seconds\n"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp

	# argv -> r12
	# argc -> r13
	# -8 - x -> xmm7
	# end -> r13
	# start -> r12
	# -12 - iterations
	# eps -> xmm9
	# i -> is not used
	# res -> xmm10
	# fout - r14
	# fin - r15

	sub	rsp, 16
	mov	r13d, edi # argc
	mov	r12, rsi # argv
	cmp	r13d, 2   # argc
	jg	.L4
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 39
	mov	esi, 1
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	eax, 1
	jmp	.L18
.L4:
	mov	rax, r12 # argv
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	esi, 0
	mov	rdi, rax
	call	strtod@PLT
	movq	xmm9, xmm0 # eps
	mov	rax, r12 # argv
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -12[rbp], eax # iterations
	mov	rax, r12 # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC1[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L6
	mov	rax, QWORD PTR stdin[rip]
	mov	r15, rax # fin
	mov	rax, QWORD PTR stdout[rip]
	mov	r14, rax # fout
	jmp	.L7
.L6:
	mov	rax, r12 # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC2[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L8
	cmp	r13d, 5 # argc
	jg	.L9
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 36
	mov	esi, 1
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	eax, 1
	jmp	.L18
.L9:
	mov	rax, r12 # argv
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC4[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	r15, rax
	mov	rax, r12 # argv
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC5[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	r14, rax # fout
	jmp	.L7
.L8:
	mov	rax, r12 # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC6[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L10
	cmp	r13d, 4 # argc
	# r13 is free now
	jg	.L11
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 28
	mov	esi, 1
	lea	rax, .LC7[rip]
	mov	rdi, rax
	call	fwrite@PLT
	mov	eax, 1
	jmp	.L18
.L11:
	mov	r15, 0 # fin
	mov	rax, r12 # argv
	# r12 is free now
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC5[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	r14, rax # fout
	jmp	.L7
.L10:
	mov	rax, QWORD PTR stderr[rip]
	mov	rcx, rax
	mov	edx, 18
	mov	esi, 1
	lea	rax, .LC8[rip]
	mov	rdi, rax
	call	fwrite@PLT
.L7:
	cmp	r15, 0 # fin
	jne	.L12
	mov	eax, 0
	call	gen_double
	movq	rax, xmm0
	mov	QWORD PTR -8[rbp], rax # x
	movq	xmm0, rax
	lea	rax, .LC9[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	jmp	.L13
.L12:
	lea	rdx, -8[rbp] # x
	mov	rax, r15 # fin
	lea	rcx, .LC10[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_fscanf@PLT
	movsd xmm7, QWORD PTR -8[rbp]
.L13:
	movsd	xmm10, QWORD PTR .LC11[rip] # res
	
	call	clock@PLT
	mov	r12, rax # start
	mov	ebx, DWORD PTR -12[rbp] # i = iterations
	jmp	.L14
.L15:
	movq	xmm1, xmm9 # eps
	movq	xmm0, xmm7
	call	f@PLT
	movq	xmm10, xmm0 # res
	sub ebx, 1 # i--
.L14:
	
	cmp	ebx, 0 # iterations != 0
	jnz	.L15

	call	clock@PLT
	mov	r13, rax # end
	
	mov	rax, r14 # fout
	movq	xmm0, xmm10 # res
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	mov	rax, r13 # end
	sub	rax, r12 # start
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, rax
	movsd	xmm1, QWORD PTR .LC12[rip]
	divsd	xmm0, xmm1
	mov	rax, r13 # end
	sub	rax, r12 # start
	pxor	xmm2, xmm2
	cvtsi2sd	xmm2, rax
	movq	rcx, xmm2
	mov	edx, DWORD PTR -12[rbp] # iterations
	mov	rax, r14 # fout
	movapd	xmm1, xmm0
	movq	xmm0, rcx
	lea	rcx, .LC13[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 2
	call	fprintf@PLT
	mov	rax, QWORD PTR stdin[rip]
	cmp	r15, rax # fin
	je	.L16
	cmp	r15, 0 # fin
	je	.L16
	mov	rax, r15 # fin
	mov	rdi, rax
	call	fclose@PLT
.L16:
	mov	rax, QWORD PTR stdout[rip]
	cmp	r14, rax # fout
	je	.L17
	mov	rax, r14 # fout
	mov	rdi, rax
	call	fclose@PLT
.L17:
	mov	eax, 0
.L18:
	leave
	ret
	.size	main, .-main
	.section	.rodata
	.align 8
.LC11:
	.long	0
	.long	-1074790400
	.align 8
.LC12:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
