	.file	"function.c"
	.intel_syntax noprefix
	.text
	.globl	f
	.type	f, @function
f:
	endbr64
	push	rbp
	mov	rbp, rsp

	# Структура стека
	# last_rbp
	# -8  - exp
	# -16 - term
	# -20 - iteration
	# -40 - x
	# -48 - eps

	movsd	QWORD PTR -40[rbp], xmm0 # x
	movsd	QWORD PTR -48[rbp], xmm1 # eps
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -8[rbp], xmm0 # exp
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	QWORD PTR -16[rbp], xmm0 # term = 1
	mov	DWORD PTR -20[rbp], 0 # iteration
.L5:
	movsd	xmm0, QWORD PTR -16[rbp] # term
	mulsd	xmm0, QWORD PTR -40[rbp] # x
	movsd	QWORD PTR -16[rbp], xmm0 # term
	add	DWORD PTR -20[rbp], 1 # iteration
	mov	eax, DWORD PTR -20[rbp] # iteration
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, eax
	movsd	xmm0, QWORD PTR -16[rbp] # term
	divsd	xmm0, xmm1
	movsd	QWORD PTR -16[rbp], xmm0 # term
	movsd	xmm0, QWORD PTR .LC0[rip]
	divsd	xmm0, QWORD PTR -8[rbp] # exp
	movsd	xmm1, QWORD PTR -8[rbp] # exp
	movapd	xmm2, xmm1
	addsd	xmm2, QWORD PTR -16[rbp] # term
	movsd	xmm1, QWORD PTR .LC0[rip]
	divsd	xmm1, xmm2
	subsd	xmm0, xmm1
	movq	xmm1, QWORD PTR .LC1[rip]
	andpd	xmm1, xmm0
	movsd	xmm0, QWORD PTR -48[rbp] # eps
	comisd	xmm0, xmm1
	jb	.L7
	movsd	xmm0, QWORD PTR -8[rbp] # exp
	movapd	xmm1, xmm0
	addsd	xmm1, QWORD PTR -16[rbp] # term
	movsd	xmm0, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm1
	jmp	.L8
.L7:
	movsd	xmm0, QWORD PTR -8[rbp] # exp
	addsd	xmm0, QWORD PTR -16[rbp] # term
	movsd	QWORD PTR -8[rbp], xmm0 # exp
	jmp	.L5
.L8:
	movq	rax, xmm0
	movq	xmm0, rax
	pop	rbp
	ret
	.size	f, .-f
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 16
.LC1:
	.long	-1
	.long	2147483647
	.long	0
	.long	0
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
