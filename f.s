section .text

global f
f:

	push rbp
	mov  rbp, rsp

	;rdi	,rsi	,rdx	,rcx	,r8	,r9, [rbp + 16],[rbp + 24]
	;arr	,width	,height	,S	,A	,B	,C	,D

	sub rsp, 128

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
	;[rbp - 120]			:Xpixel previous 
	;[rbp - 128]			:Ypixel previous

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
	je set_colorOXY

	mov rdx, 0
	mov rax, [rbp - 16]
	mov rcx, 2
	div rcx

	cmp r10, rax
	je set_colorOXY

	mov r9b, 255
	jmp drawOXY
set_colorOXY:
	mov r9b, 0

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


	mov r8, [rbp - 16]
	mov [rbp - 120], r8

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

	ffree st0
	ffree st1

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


;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jle next

;	check if first	;

	mov r9, [rbp - 16]
	mov r8, [rbp - 120]
	cmp r9, r8
	je drawRed


;	check if red	;
checkS:

	ffree st0
	ffree st1

	mov [rbp - 88], r10
	fild QWORD [rbp - 88]
	fild QWORD [rbp - 120]
	fsub
	fld QWORD [rbp - 72]
	fmul

	fld st0
	fmul				;dx^2
	fstp QWORD [rbp - 112]


	mov [rbp - 88], r11
	fild QWORD [rbp - 88]
	fild QWORD [rbp - 128]
	fsub
	fld QWORD [rbp - 80]
	fmul

	fld st0
	fmul

	fld QWORD [rbp - 112]
	fadd

					;dy^2 + dx^2
	fsqrt


	fild QWORD [rbp - 32]
	fcomip st0, st1

	jb drawRed



;	draw		;

drawBlue:

	mov rax, r11
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
	jmp next

drawRed:

	mov [rbp - 120], r10
	mov [rbp - 128], r11

	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b

	add r10, 1

;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next1

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next1

;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 104]
	jg next1

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next1

	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b

next1:

	add r11, 1


;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next2

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next2



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next2

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next2


	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b

next2:

	sub r10, 1


;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next3

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next3



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next3

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next3


	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b
next3:

	sub r10, 1



;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next4

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next4



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next4

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next4


	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b
next4:

	sub r11, 1


;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next5

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next5



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next5

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next5



	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b
next5:

	sub r11, 1



;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next6

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next6



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next6

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next6



	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b
next6:
	add r10, 1



;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next7

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next7



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next7

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next7


	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b
next7:
	add r10, 1



;	check borders	;

	mov rax, r10

	cmp rax, [rbp - 104]
	jg next

	mov rcx,0
	sub rcx, [rbp - 104]

	cmp rax, rcx
	jl next



;	check borders	;

	mov rax, r11

	cmp rax, [rbp - 96]
	jg next

	mov rcx,0
	sub rcx, [rbp - 96]

	cmp rax, rcx
	jl next


	mov rax, r11
	add rax, [rbp - 96]
	mul QWORD [rbp - 16]
	add rax, r10
	add rax, [rbp - 104]
	mov r8, 3
	mul QWORD r8

	mov r9b, 255
	mov[rdi + rax], r9b
	mov r9b, 0
	mov [rdi + rax + 1], r9b
	mov r9b, 0
	mov [rdi + rax + 2], r9b

	sub r10, 1
	add r11, 1


next:
	add r10, 1
	cmp r10, [rbp - 104]
	jl loopDraw

end:
	mov rsp, rbp
	pop rbp
	ret
