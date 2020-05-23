section .text

global f
f:

	push rbp
	mov  rbp, rsp

	;rdi	,rsi	,rdx	,rcx	,r8	,r9, [rbp + 16],[rbp + 24]
	;arr	,width	,height	,S	,A	,B	,C	,D

	sub rsp, 112

	mov [rbp - 8], rdi		;arr
	mov [rbp - 16], rsi		;width
	mov [rbp - 24], rdx		;height
	mov [rbp - 32], rcx		;S
	mov [rbp - 40], r8		;A
	mov [rbp - 48], r9		;B
	mov QWORD [rbp - 56], 20	;max Y
	mov QWORD [rbp - 64], 5	;max X
	;[rbp - 72]			:scaleX
	;[rbp - 80]			:scaleY
	;[rbp - 88]			:buffor1
	;[rbp - 96]			:half height
	;[rbp - 104]			:half width
	;[rbp - 112]			:result buffor

;	OXY drawing	;


	mov r11, 0	;y iterator
loopY:
	mov r10, 0	;x iterator
loopX:

	mov rdx, 0
	mov rax, [rbp - 24]
	mov rcx, 2
	div rcx

	cmp r11, rax
	je set_white

	mov rdx, 0
	mov rax, [rbp - 16]
	mov rcx, 2
	div rcx

	cmp r10, rax
	je set_white

	mov r9b, 150
	jmp drawOXY
set_white:
	mov r9b, 255

drawOXY:
	mov  rax, r11
	mul QWORD [rbp - 16]
	add rax, r10
	mov r8, 3
	mul QWORD r8

	mov [rdi + rax], r9b
	mov [rdi + rax + 1], r9b
	mov [rdi + rax + 2], r9b

	add r10, 1
	cmp r10, [rbp - 16]
	jl loopX

	add r11, 1
	cmp r11, [rbp - 24]
	jl loopY


;	Prepare scales and halfes		;

	fild QWORD [rbp - 64]
	fild QWORD [rbp - 16]
	fdiv
	fstp QWORD [rbp - 72]
	fild QWORD [rbp - 56]
	fild QWORD [rbp - 24]
	fdiv
	fstp QWORD [rbp - 80]

	mov rdx, 0
	mov rax, [rbp - 24]
	mov rcx, 2
	div rcx
	mov [rbp - 96], rax

	mov rdx, 0
	mov rax, [rbp - 16]
	mov rcx, 2
	div rcx
	mov [rbp - 104], rax

;	Prapare X	;

	mov rax, [rbp - 16]
	mov rdx, 0
	mov rcx, 2
	div rcx
	mov QWORD [rbp - 88], 0
	fild QWORD [rbp - 88]
	mov [rbp - 88], rax
	fild QWORD [rbp - 88]
	fsub
	fistp QWORD [rbp - 88]
	mov r10, [rbp - 88]	;r10 = -width/2

loopDraw:

	mov [rbp - 88], r10	;calc x
	fild QWORD [rbp - 88]
	fld QWORD [rbp - 72]
	fmul
	fstp QWORD [rbp - 88]		;x

;	function calc	;

	fld QWORD [rbp - 88]	;Ax^3
	fld QWORD [rbp - 88]
	fmul
	fld QWORD [rbp - 88]
	fmul
	fild QWORD [rbp - 40]
	fmul
	fstp QWORD [rbp - 112]

	fld QWORD [rbp - 88]	;Bx^2
	fld QWORD [rbp - 88]
	fmul
	fild QWORD [rbp - 48]
	fmul
	fld QWORD [rbp - 112]
	fadd
	fstp QWORD [rbp - 112]

	fld QWORD [rbp - 88]	;Cx
	fild QWORD [rbp + 16]
	fmul
	fld QWORD [rbp - 112]
	fadd

	fild QWORD [rbp + 24]	;D
	fadd

;	calc pixY	;

	fld QWORD [rbp - 80]
	fdiv
	fistp QWORD [rbp - 88]
	mov r11, [rbp - 88]


;	draw	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next

	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 0
	mov[rdi + rax], r9b
	mov r9b, 0
	mov[rdi + rax + 1], r9b
	mov r9b, 255
	mov[rdi + rax + 2], r9b


next:
	add r10, 1
	cmp r10, [rbp - 104]
	jl loopDraw

end:
	mov rsp, rbp
	pop rbp
	ret
