section .text

global f
f:

	push rbp
	mov  rbp, rsp

	;rdi	,rsi	,rdx	,rcx
	;arr	,width	,height	,wysokosc

	sub rsp, 32

	mov [rbp - 8], rdi	;arr
	mov [rbp - 16], rsi	;width
	mov [rbp - 24], rdx	;height
	mov [rbp - 32], rcx	;wysokosc

	mov r11, 0	;y iterator

loopY:
	mov r10, 0	;x iterator

	cmp r11, [rbp - 32]
	je set_white
	mov r9b, 150
	jmp set_white_exit
set_white:
	mov r9b, 255
set_white_exit:

loopX:
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

end:
	mov rsp, rbp
	pop rbp
	ret
