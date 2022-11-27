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
	# exp -> xmm3
	# term -> xmm4
	# iteration -> ecx
	# x -> xmm5
	# eps -> xmm6

	movsd	xmm5, xmm0 # x
	movsd	xmm6, xmm1 # eps
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	xmm3, xmm0 # exp
	movsd	xmm0, QWORD PTR .LC0[rip]
	movsd	xmm4, xmm0 # term = 1
	mov	ecx, 0 # iteration
.L5:
	movsd	xmm0, xmm4 # term
	mulsd	xmm0, xmm5 # x
	movsd	xmm4, xmm0 # term
	add	ecx, 1 # iteration
	
	pxor	xmm1, xmm1
	cvtsi2sd	xmm1, ecx
	movsd	xmm0, xmm4 # term
	divsd	xmm0, xmm1
	movsd	xmm4, xmm0 # term
	movsd	xmm0, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm3 # exp
	movsd	xmm1, xmm3 # exp
	movapd	xmm2, xmm1
	addsd	xmm2, xmm4 # term
	movsd	xmm1, QWORD PTR .LC0[rip]
	divsd	xmm1, xmm2
	subsd	xmm0, xmm1
	movq	xmm1, QWORD PTR .LC1[rip]
	andpd	xmm1, xmm0
	movsd	xmm0, xmm6 # eps
	comisd	xmm0, xmm1
	jb	.L7
	movsd	xmm0, xmm3 # exp
	movapd	xmm1, xmm0
	addsd	xmm1, xmm4 # term
	movsd	xmm0, QWORD PTR .LC0[rip]
	divsd	xmm0, xmm1
	jmp	.L8
.L7:
	movsd	xmm0, xmm3 # exp
	addsd	xmm0, xmm4 # term
	movsd	xmm3, xmm0 # exp
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
