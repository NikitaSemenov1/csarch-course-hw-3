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
	# -16 - denom
	# -8  - num

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
	movsd	QWORD PTR -8[rbp], xmm0 # num <- xmm0
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
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, eax
	movsd	QWORD PTR -16[rbp], xmm0 # denom <- xmm0
	movsd	xmm0, QWORD PTR -8[rbp] # num
	divsd	xmm0, QWORD PTR -16[rbp] # xmm0 <- num / denom
	movq	rax, xmm0
	movq	xmm0, rax
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

	# структура стека
	# -96 - argv
	# -84 - argc
	# -72 - x
	# -64 - end
	# -56 - start
	# -44 - iterations
	# -40 - eps
	# -28 - i
	# -24 - res
	# -16 - fout
	# -8  - fin

	sub	rsp, 96
	mov	DWORD PTR -84[rbp], edi # argc
	mov	QWORD PTR -96[rbp], rsi # argv
	cmp	DWORD PTR -84[rbp], 2   # argc
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
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	esi, 0
	mov	rdi, rax
	call	strtod@PLT
	movq	rax, xmm0
	mov	QWORD PTR -40[rbp], rax # eps
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax
	call	atoi@PLT
	mov	DWORD PTR -44[rbp], eax # iterations
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC1[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L6
	mov	rax, QWORD PTR stdin[rip]
	mov	QWORD PTR -8[rbp], rax # fin
	mov	rax, QWORD PTR stdout[rip]
	mov	QWORD PTR -16[rbp], rax # fout
	jmp	.L7
.L6:
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC2[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L8
	cmp	DWORD PTR -84[rbp], 5 # argc
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
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC4[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC5[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -16[rbp], rax # fout
	jmp	.L7
.L8:
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC6[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp@PLT
	test	eax, eax
	jne	.L10
	cmp	DWORD PTR -84[rbp], 4 # argc
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
	mov	QWORD PTR -8[rbp], 0 # fin
	mov	rax, QWORD PTR -96[rbp] # argv
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, .LC5[rip]
	mov	rsi, rdx
	mov	rdi, rax
	call	fopen@PLT
	mov	QWORD PTR -16[rbp], rax # fout
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
	cmp	QWORD PTR -8[rbp], 0 # fin
	jne	.L12
	mov	eax, 0
	call	gen_double
	movq	rax, xmm0
	mov	QWORD PTR -72[rbp], rax # x
	mov	rax, QWORD PTR -72[rbp] # x
	movq	xmm0, rax
	lea	rax, .LC9[rip]
	mov	rdi, rax
	mov	eax, 1
	call	printf@PLT
	jmp	.L13
.L12:
	lea	rdx, -72[rbp] # x
	mov	rax, QWORD PTR -8[rbp] # fin
	lea	rcx, .LC10[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 0
	call	__isoc99_fscanf@PLT
.L13:
	movsd	xmm0, QWORD PTR .LC11[rip]
	movsd	QWORD PTR -24[rbp], xmm0 # res
	call	clock@PLT
	mov	QWORD PTR -56[rbp], rax # start
	mov	DWORD PTR -28[rbp], 0 # i = 0
	jmp	.L14
.L15:
	mov	rax, QWORD PTR -72[rbp] # x
	movsd	xmm0, QWORD PTR -40[rbp] # eps
	movapd	xmm1, xmm0
	movq	xmm0, rax
	call	f@PLT
	movq	rax, xmm0
	mov	QWORD PTR -24[rbp], rax # res
	add	DWORD PTR -28[rbp], 1 # i++
.L14:
	mov	eax, DWORD PTR -28[rbp]
	cmp	eax, DWORD PTR -44[rbp] # iterations
	jl	.L15
	call	clock@PLT
	mov	QWORD PTR -64[rbp], rax # end
	mov	rdx, QWORD PTR -24[rbp] # res
	mov	rax, QWORD PTR -16[rbp] # fout
	movq	xmm0, rdx
	lea	rdx, .LC9[rip]
	mov	rsi, rdx
	mov	rdi, rax
	mov	eax, 1
	call	fprintf@PLT
	mov	rax, QWORD PTR -64[rbp] # end
	sub	rax, QWORD PTR -56[rbp] # start
	pxor	xmm0, xmm0
	cvtsi2sd	xmm0, rax
	movsd	xmm1, QWORD PTR .LC12[rip]
	divsd	xmm0, xmm1
	mov	rax, QWORD PTR -64[rbp] # end
	sub	rax, QWORD PTR -56[rbp] # start
	pxor	xmm2, xmm2
	cvtsi2sd	xmm2, rax
	movq	rcx, xmm2
	mov	edx, DWORD PTR -44[rbp] # iterations
	mov	rax, QWORD PTR -16[rbp] # fout
	movapd	xmm1, xmm0
	movq	xmm0, rcx
	lea	rcx, .LC13[rip]
	mov	rsi, rcx
	mov	rdi, rax
	mov	eax, 2
	call	fprintf@PLT
	mov	rax, QWORD PTR stdin[rip]
	cmp	QWORD PTR -8[rbp], rax # fin
	je	.L16
	cmp	QWORD PTR -8[rbp], 0 # fin
	je	.L16
	mov	rax, QWORD PTR -8[rbp] # fin
	mov	rdi, rax
	call	fclose@PLT
.L16:
	mov	rax, QWORD PTR stdout[rip]
	cmp	QWORD PTR -16[rbp], rax # fout
	je	.L17
	mov	rax, QWORD PTR -16[rbp] # fout
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
