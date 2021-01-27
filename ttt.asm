[org 0x0100]
jmp start
;Data Labels
;--------------------------------------------------------------------------------
player1_win: db 'Player 1 Wins', 0
player2_win: db 'Player 2 Wins', 0
draw: db 'Draw', 0

player1_turn: db 'Player 1 Turn', 0
player2_turn: db 'Player 2 Turn', 0

win_check: dw 0
welcome: db 'Tic Tac Toe', 0
farewell: db 'Good Bye', 0

box_not_available: db 'This Box is Occupied', 0
array_index_out_of_bound: db 'Array Index is Out Of Bound', 0

reserved: dw 0, 0, 0, 0, 0, 0, 0, 0, 0
turn: dw 10 ; 10 stands for player 1 turn and 20 stands for player 2 turn
invalid_turn: dw 0 ; 0 stands for turn is valid and 1 for invalid

Play_Again: db 'Do You Want To Play Again (Y/N)', 0
;--------------------------------------------------------------------------------
clear_screen:
	push es
	push ax
	push cx
	push di
 
	mov ax, 0xb800
	mov es, ax
	xor di, di
	mov ah, 0x11
	mov cx, 2000
	
	cld
	rep stosw
 
	pop di
	pop cx
	pop ax
	pop es
	
	ret
;--------------------------------------------------------------------------------
printRectangle:
	push bp
	mov bp, sp
	
	push es
	push ax
	push cx
	push si
	push di

	mov ax, 0xb800
	mov es, ax

	mov al, 80
	mul byte [bp+12]
	add ax, [bp+10]

	shl ax, 1
	mov di, ax

	mov ah, [bp+4]
	mov cx, [bp+6]
	sub cx, [bp+10]
	
	mov al, 0
	
topLine:
	
	mov [es:di], ax
	add di, 2
	call sleep
	loop topLine
	
	mov [es:di], ax
	
	mov cx, [bp+8]
	sub cx, [bp+12]
	add di, 160

rightLine:
	
	mov [es:di], ax
	add di, 160
	call sleep
	loop rightLine
	
	mov [es:di], ax
	
	mov cx, [bp+6]
	sub cx, [bp+10]
	sub di, 2

bottomLine:
	
	mov [es:di], ax
	sub di, 2
	call sleep
	loop bottomLine

	mov [es:di], ax
	
	mov cx, [bp+8]
	sub cx, [bp+12]
	sub di, 160

leftLine:
	
	mov [es:di], ax
	sub di, 160
	call sleep
	loop leftLine
	
	mov [es:di], ax
	
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp

	ret 10
;--------------------------------------------------------------------------------
sleep:
	push cx
	mov cx, 0xFFFF
delay:
	loop delay
	pop cx

	ret
;--------------------------------------------------------------------------------
Fill_Box:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x020E
	add di, 160
	mov dx, 11
	
	mov ah, 0x33
	mov al, 0
	loop4:
		mov cx, 29
		loop5:
			mov [es:di], ax
			add di, 2
			call sleep
		loop loop5
		
		dec dx
		
		mov cx, 29
		
		cmp dx, 0
		je exit1
		
		add di, 160
		sub di, 2
		
		loop6:
			mov [es:di], ax
			sub di, 2
			call sleep
			loop loop6
		
		add di, 160
		add di, 2
		dec dx
	jmp loop4
	
	
	exit1:
	
	ret
;--------------------------------------------------------------------------------
Print_Straight_Line:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x0220
	add di, 160
	mov ah, 0xD5
	mov al, 0
	mov cx, 11
Straight_Line1:
	mov [es:di], ax
	add di, 160
	call sleep
	loop Straight_Line1
	
	mov di, 0x0234
	add di, 160
	mov cx, 11

Straight_Line2:
	mov [es:di], ax
	add di, 160
	call sleep
	loop Straight_Line2
	
	ret
;--------------------------------------------------------------------------------
Print_Horizontal_Line: ; 08EC
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x08EC
	mov cx, 3
	loop1:
		sub di, 160
		call sleep
		loop loop1
	
	add di, 2
	
	mov cx, 30
	mov ah, 0xD5
	mov al, 0 ;
Horizontal_Line1:
	mov [es:di], ax
	add di, 2
	call sleep
	loop Horizontal_Line1
	
	mov cx, 4
	loop2:
		sub di, 160
		loop loop2
	
	sub di, 2
	
	mov cx, 30

Horizontal_Line2:
	mov [es:di], ax
	sub di, 2
	call sleep
	loop Horizontal_Line2
	
	ret

;--------------------------------------------------------------------------------

message_box_colour: ; di = 0x0AF4
	
	mov di, 0x0AF4
	add di, 160
	mov cx, 38
	mov ax, 0xb800
	mov es, ax
	
	loop3:
		sub di, 2
		loop loop3
	
	mov ah, 0xF7
	mov al, 0x2D
	
	mov cx, 72
	
	fill1:
		mov [es:di], ax
		add di, 2
		call sleep
		loop fill1
	
	sub di, 2
	mov cx, 72
	add di, 160
	
	fill2:
		mov [es:di], ax
		sub di, 2
		dec cx
		call sleep
		jne fill2
		
	add di, 2
	mov cx, 72
	add di, 160
	
	fill3:
		mov [es:di], ax
		add di, 2
		call sleep
		loop fill3
	ret
	
;--------------------------------------------------------------------------------

message_print:
	push bp
	mov bp, sp

	push es
	push ax
	push cx
	push si
	push di
	push ds
 
	pop es

	mov di, [bp+4]

	mov cx, 0xffff
	
	xor al, al
	repne scasb

	mov ax, 0xffff
	sub ax, cx
	
	dec ax
	
	jz exit
	
	mov cx, ax

	mov ax, 0xb800
	mov es, ax

	mov al, 80
	mul byte [bp+8]
	add ax, [bp+10]
	shl ax, 1

	mov di,ax
	
	mov si, [bp+4]
	mov ah, [bp+6]
	
	cld

nextchar:
	lodsb
	stosw
	loop nextchar

exit:
	
	mov cx, 10
	
	loop93:
		call sleep
	loop loop93
	
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	
ret 8

;--------------------------------------------------------------------------------
player1_win_call:
	mov ax, 32
	push ax
	
	mov ax, 19
	push ax

	mov ax, 0xF6
	push ax
	
	mov ax, player1_win
	push ax
	
	call message_print
	call sleep
	
	ret
	
;--------------------------------------------------------------------------------
player2_win_call:
	mov ax, 32
	push ax
	
	mov ax, 19
	push ax

	mov ax, 0xF6
	push ax
	
	mov ax, player2_win
	push ax
	
	call message_print
	call sleep
	
	ret

;--------------------------------------------------------------------------------
player1_turn_call:
	mov ax, 32
	push ax
	
	mov ax, 19
	push ax

	mov ax, 0x76
	push ax
	
	mov ax, player1_turn
	push ax
	
	call message_print
	call sleep
	
	ret
	
;--------------------------------------------------------------------------------
player2_turn_call:
	mov ax, 32
	push ax
	
	mov ax, 19
	push ax

	mov ax, 0x76
	push ax
	
	mov ax, player2_turn
	push ax
	
	call message_print
	call sleep
	
	ret

;--------------------------------------------------------------------------------
Draw_call

	mov ax, 35
	push ax
	
	mov ax, 19
	push ax
	
	mov ax, 0x76
	push ax
	
	mov ax, draw
	push ax
	
	call message_print
	call sleep
	
	ret

;--------------------------------------------------------------------------------
ttt_print:
	mov ax, 32
	push ax
	
	mov ax, 0
	push ax
	
	mov ax, 0x1F
	push ax
	
	mov ax, welcome
	push ax
	
	call message_print
	
	ret
	
;----------------------------------------------------------------------------------------
LtoR_diagonal_line:
	mov ax, 0xb800
	mov es, ax
	mov di, 0x020C
	add di, 2
	add di, 160
	mov ah, 0x22
	mov al, 0
	
	mov cx, 3
	
	
	loop7:	
		mov [es:di], ax
		add di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 2
		mov [es:di], ax
		call sleep
		add di, 160
		add di, 2
		
	loop loop7
	
	mov [es:di], ax
	call sleep
	
	add di, 160
	
	add di, 2
	
	mov cx, 3
	
	loop8:
		mov [es:di], ax
		add di, 2
		call sleep
		mov [es:di], ax
		add di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 160
		add di, 2
	
	loop loop8

	
	mov [es:di], ax
	
	add di, 160
	
	add di, 2
	
	mov cx, 3
	
	loop9:
		mov [es:di], ax
		add di, 2
		call sleep
		mov [es:di], ax
		add di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 160
		add di, 2
		
	loop loop9
	
	ret

;----------------------------------------------------------------------------------------
RtoL_diagonal_line:
	mov ax, 0xb800
	mov es, ax
	mov di, 0x0248
	sub di, 2
	add di, 160
	mov ah, 0x22
	mov al, 0
	
	mov cx, 3
	
	loop10:
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 160
		sub di, 2
	
	loop loop10		

	mov [es:di], ax
	
	add di, 160
	sub di, 2
	
	mov cx, 3
	
	loop11:
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 160
		sub di, 2
	
	loop loop11
	
	mov [es:di], ax
	
	add di, 160
	sub di, 2
	
	mov cx, 3
	
	loop12:
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		sub di, 2
		call sleep
		mov [es:di], ax
		call sleep
		add di, 160
		sub di, 2
	
	loop loop12
	
	ret

;--------------------------------------------------------------------------------
win_horizontal_line1:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x034E
	
	mov cx, 29
	
	mov ax, 0x2200
	
	loop13:
		mov [es:di], ax
		add di, 2
		call sleep
	
	loop loop13
		
	ret

;---------------------------------------------------------------------------
win_horizontal_line2:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x05CE
	
	mov cx, 29
	
	mov ax, 0x2200
	
	loop14:
		mov [es:di], ax
		add di, 2
		call sleep
	
	loop loop14
		
	ret
	
;---------------------------------------------------------------------------
win_horizontal_line3:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x084E
	
	mov cx, 29
	
	mov ax, 0x2200
	
	loop15:
		mov [es:di], ax
		add di, 2
		call sleep
	
	loop loop15
		
	ret

;---------------------------------------------------------------------------
win_vertical_line1:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x02B6
	
	mov cx, 11
	
	mov ax, 0x2200
	loop16:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop16
	
	ret

;---------------------------------------------------------------------------
win_vertical_line2:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x02CA
	
	mov cx, 11
	
	mov ax, 0x2200
	loop17:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop17
	
	ret

;---------------------------------------------------------------------------
win_vertical_line3:
	mov ax, 0xb800
	mov es, ax
	
	mov di, 0x02DE
	
	mov cx, 11
	
	mov ax, 0x2200
	loop18:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop18
	
	ret

;---------------------------------------------------------------------------
mouse:
	mov ax, 1
	int 33h

	mov ax, 3 ; function to get mouse position and buttons
	int 33h
	
	cmp bx, 1
		jne mouse
	
	cmp cx, 185 ; left side of the box
		jl fail
	
	cmp dx, 116  ; bottom side of the box
		jg fail
	
	cmp dx, 30 ; top side of the box
		jle fail
	
	cmp cx, 420 ; right side of the box
		jge fail
	
	push cx
	
	mov cx, 62
	
	; For Box' Rows
	;First Row
	loop94:
		cmp dx, cx
			je fail_cx
		dec cx
		
		cmp cx, 55
			jnl loop94
	
	;Second Row
	mov cx, 95
	loop95:
		cmp dx, cx
			je fail_cx
		
		dec cx
		
		cmp cx, 88
			jne loop95
	
	pop cx
	
	push dx
	mov dx, 264
	
	; For Box' Columns
	loop96:
		cmp cx, dx
			je fail_dx
			
		dec dx
		
		cmp dx, 257
			jnl loop96

	mov dx, 344
	loop97:
		cmp cx, dx
			je fail_dx
			
		dec dx
		
		cmp dx, 337
			jnl loop97
	
	pop dx
	
	mov ax,dx ; Y coord to AX
	
	push dx
	
	mov dx, 320
	mul dx ; multiply AX by 320
	
	add ax, cx
	jmp not_fail
	
fail:
	call Not_Found
	jmp mouse
fail_cx:
	pop cx
	call Not_Found
	jmp mouse
fail_dx:
	pop dx
	call Not_Found
	jmp mouse
not_fail:
	push ax

; (Now cursor position is in AX, lets draw the pixel there)
	
	push cx
	mov di, ax
	mov cx, ax
	mov ax, 0xb800
	mov es, ax

	mov dl, 0x7F ; red color ;)
	mov [es:di], dl ; and we have the pixel drawn
	
	mov di, ax
	
	pop cx
	pop ax
	pop dx
	
	ret
;--------------------------------------------------------------------------------

check:

	mov ax, cx
	mov bx, dx
	check63:
		mov cx, 30
		loop98:
			cmp dx, cx
				je first_row

			inc cx
			cmp cx, 53
				jne loop98
	jmp check64
first_row:
		mov cx, ax
		mov dx, 185
		loop99:
			cmp cx, dx
				je first_box
			
			inc dx
			cmp dx, 250 
				jne loop99
		
		mov dx, 270
		loop100:
			cmp cx, dx
				je second_box
			inc dx
			cmp dx, 334
				jne loop100
		
		mov dx, 348
		loop101:
			cmp cx, dx
				je third_box
			inc dx
			cmp dx, 420
				jne loop101

first_box:
	mov dx, bx
	mov bx, 0
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call1

	call store
	mov dx, 1
	ret
second_box:
	mov dx, bx
	mov bx, 2
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call1
	call store
	mov dx, 2
	ret
third_box:
	mov dx, bx
	mov bx, 4
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call1
	call store
	mov dx, 3
	ret
error_call1:
	call error1
	ret

check64:
	mov cx, 62
	loop102:
		cmp dx, cx
			je second_row

		inc cx
		cmp cx, 88
			jne loop102
		jmp check65
second_row:
	mov cx, ax
	mov dx, 185
	loop103:
		cmp cx, dx
			je fourth_box

		inc dx
		cmp dx, 250 
			jne loop103

		mov dx, 270
		loop104:
			cmp cx, dx
				je fifth_box
			inc dx
			cmp dx, 334
				jne loop104

		mov dx, 348
		loop105:
			cmp cx, dx
				je sixth_box
			inc dx
			cmp dx, 420
				jne loop105
fourth_box:
	mov dx, bx
	mov bx, 6
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	
	call store
	mov dx, 4
	ret
fifth_box:
	mov dx, bx
	mov bx, 8
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	call store
	mov dx, 5
	ret
sixth_box:
	mov dx, bx
	mov bx, 10
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	call store
	mov dx, 6
	ret
error_call2:
	call error1
	ret

check65:
	mov cx, 95
	loop106:
		cmp dx, cx
			je third_row

		inc cx
		cmp cx, 116
			jne loop106
		call error_call3
		ret
third_row:
	mov cx, ax
	mov dx, 185
	loop107:
		cmp cx, dx
			je seventh_box

		inc dx
		cmp dx, 250 
			jne loop107

		mov dx, 270
		loop108:
			cmp cx, dx
				je eighth_box
			inc dx
			cmp dx, 334
				jne loop108

		mov dx, 338
		loop109:
			cmp cx, dx
				je ninth_box
			inc dx
			cmp dx, 420
				jne loop109
	jmp error_call3
seventh_box:
	mov dx, bx
	mov bx, 12
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	
	call store
	mov dx, 7
	ret
eighth_box:
	mov dx, bx
	mov bx, 14
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	call store
	mov dx, 8
	ret
ninth_box:
	mov dx, bx
	mov bx, 16
	mov dx, [reserved + bx]
	cmp dx, 0
		jne error_call2
	call store
	mov dx, 9
	ret
error_call3:
	mov dx, bx
	call error1
	ret

error1:
	mov ax, 28
	push ax
	
	mov ax, 19
	push ax
	
	mov ax, 0x76
	push ax
	
	mov ax, box_not_available
	push ax
	
	call message_print
	mov cx, 10
	loop27:
		call sleep
	loop loop27
	
	mov ax, 1
	mov [invalid_turn], ax
	
	call message_box_colour1
	ret
	
Not_Found:
	mov ax, 26
	push ax
	
	mov ax, 19
	push ax
	
	mov ax, 0x76
	push ax
	
	mov ax, array_index_out_of_bound
	push ax
	
	call message_print
	
	mov cx, 10
	loop110:
		call sleep
	loop loop110
	
	call message_box_colour1

	ret

;--------------------------------------------------------------------------------
check_box:
;--------------------------------------------------------------------------------
box1:
	cmp dx, 1
		je check_win1
		jmp box2

check_win1:
	check_turn1:
		mov ax, [turn]
		cmp ax, 20			; 10 Stands For 'O' Turn
			je player2_turn1
			jne player1_turn1
	
	player2_turn1:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 2]
			jne check30
		cmp bx, [reserved + 4]
			jne check30
			
			call win_horizontal_line1
			call player2_win_call
			mov [win_check], ax
			jmp endl1
			
		check30:
			cmp bx, [reserved + 6]
				jne check31
			cmp bx, [reserved + 12]
				jne check31
			
			call win_vertical_line1
			call player2_win_call
			mov [win_check], ax
			jmp endl1
		
		check31:
			cmp bx, [reserved + 8]
				jne endl1
			cmp bx, [reserved + 16]
				jne endl1
			
			call LtoR_diagonal_line
			call player2_win_call
			mov [win_check], ax
			jmp endl1
	
	player1_turn1:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 2]
			jne check32
		cmp bx, [reserved + 4]
			jne check32
			
			call win_horizontal_line1
			call player1_win_call
			mov [win_check], ax
			jmp endl1
			
		check32:
			cmp bx, [reserved + 6]
				jne check34
			cmp bx, [reserved + 12]
				jne check34
		
			call win_vertical_line1
			call player1_win_call
			mov [win_check], ax
			jmp endl1
		
		check34:
			cmp bx, [reserved + 8]
				jne endl1
			cmp bx, [reserved + 16]
				jne endl1
			
			call LtoR_diagonal_line
			call player1_win_call
			mov [win_check], ax
		
	endl1:
		ret

;--------------------------------------------------------------------------------	
box2:
	cmp dx, 2
		je check_win2
		jmp box3

check_win2:
	mov ax, [turn]
	cmp ax, 20			; 1 Stands For 'O' Turn
		je player2_turn2
		jne player1_turn2
	
	player2_turn2:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 0]
			jne check35
		cmp bx, [reserved + 4]
			jne check35
		
		call win_horizontal_line1
		call player2_win_call
		mov [win_check], ax
		jmp endl2
		
		check35:
			cmp bx, [reserved + 8]
				jne endl2
			cmp bx, [reserved + 14]
				jne endl2
		
		call win_vertical_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl2
		
	player1_turn2:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 0]
			jne check36
		cmp bx, [reserved + 4]
			jne check36
		
		call win_horizontal_line1
		call player1_win_call
		mov [win_check], ax
		jmp endl2
		
		check36:
			cmp bx, [reserved + 8]
				jne endl2
			cmp bx, [reserved + 14]
				jne endl2
		
		call win_vertical_line2
		call player1_win_call
		mov [win_check], ax
		
	endl2:
		ret

;--------------------------------------------------------------------------------
box3:	
	cmp dx, 3
		je check_win3
		jmp box4

check_win3:
	mov ax, [turn]
	cmp ax, 20			; 10 Stands For 'O' Turn
		je player2_turn3
		jne player1_turn3
	
	player2_turn3:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 2]
			jne check37
		cmp bx, [reserved + 0]
			jne check37
			
			call win_horizontal_line1
			call player2_win_call
			mov [win_check], ax
			jmp endl3
			
		check37:
			cmp bx, [reserved + 10]
				jne check38
			cmp bx, [reserved + 16]
				jne check38
			
			call win_vertical_line3
			call player2_win_call
			mov [win_check], ax
			jmp endl3
		
		check38:
			cmp bx, [reserved + 8]
				jne endl3
			cmp bx, [reserved + 12]
				jne endl3
			
			call RtoL_diagonal_line
			call player2_win_call
			mov [win_check], ax
			jmp endl3
	
	player1_turn3:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 2]
			jne check39
		cmp bx, [reserved + 0]
			jne check39
		
		call win_horizontal_line1
		call player1_win_call
		mov [win_check], ax
		jmp endl3
			
		check39:
			cmp bx, [reserved + 10]
				jne check40
			cmp bx, [reserved + 16]
				jne check40
			
			call win_vertical_line3
			call player1_win_call
			mov [win_check], ax
			jmp endl3
		
		check40:
			cmp bx, [reserved + 8]
				jne endl3
			cmp bx, [reserved + 12]
				jne endl3
			
			call RtoL_diagonal_line
			call player1_win_call
			mov [win_check], ax
		
	endl3:
		ret

;--------------------------------------------------------------------------------
box4:
	cmp dx, 4
		je check_win4
		jmp box5
		
check_win4:
	mov ax, [turn]
	cmp ax, 20			; 1 Stands For 'O' Turn
		je player2_turn4
		jne player1_turn4
	
	player2_turn4:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 0]
			jne check41
		cmp bx, [reserved + 12]
			jne check41
			
		call win_vertical_line1
		call player2_win_call
		mov [win_check], ax
		jmp endl4
		
		check41:
			cmp bx, [reserved + 8]
				jne endl4
			cmp bx, [reserved + 10]
				jne endl4
		
		call win_horizontal_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl4
	
	player1_turn4:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 0]
			jne check42
		cmp bx, [reserved + 12]
			jne check42
			
		call win_vertical_line1
		call player1_win_call
		mov [win_check], ax
		jmp endl4
		
		check42:
			cmp bx, [reserved + 8]
				jne endl4
			cmp bx, [reserved + 10]
				jne endl4
		
		call win_horizontal_line2
		call player1_win_call
		mov [win_check], ax
	
	endl4:
		ret

;--------------------------------------------------------------------------------		
box5:
	cmp dx, 5
		je check_win5
		jmp box6
check_win5:
	mov ax, [turn]
	cmp ax, 20			; 1 Stands For 'O' Turn
		je player2_turn5
		jne player1_turn5
	player2_turn5:
		mov bx, 20
		mov ax, 100
		cmp bx, [reserved + 6]
			jne check43
		cmp bx, [reserved + 10]
			jne check43
		call win_horizontal_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl5
		check43:
			cmp bx, [reserved + 2]
				jne check59
			cmp bx, [reserved + 14]
				jne check59
		call win_vertical_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl5
		check59:
			cmp bx, [reserved + 0]
				jne check60
			cmp bx, [reserved + 16]
				jne check60
			call LtoR_diagonal_line
			call player2_win_call
			mov [win_check], ax
			jmp endl5
		check60:
			cmp bx, [reserved + 4]
				jne endl5
			cmp bx, [reserved + 12]
				jne endl5
			call RtoL_diagonal_line
			call player2_win_call
			mov [win_check], ax
			jmp endl5
	player1_turn5:
		mov bx, 10
		mov ax, 100
		cmp bx, [reserved + 6]
			jne check45
		cmp bx, [reserved + 10]
			jne check45
		call win_horizontal_line2
		call player1_win_call
		mov [win_check], ax
		jmp endl5
		check45:
			cmp bx, [reserved + 2]
				jne check61
			cmp bx, [reserved + 14]
				jne check61
		call win_horizontal_line2
		call player1_win_call
		mov [win_check], ax
		check61:
			cmp bx, [reserved + 0]
				jne check62
			cmp bx, [reserved + 16]
				jne check62
			call LtoR_diagonal_line
			call player1_win_call
			mov [win_check], ax
			jmp endl5
		check62:
			cmp bx, [reserved + 4]
				jne endl5
			cmp bx, [reserved + 12]
				jne endl5
			call RtoL_diagonal_line
			call player1_win_call
			mov [win_check], ax

	endl5:
		ret

;--------------------------------------------------------------------------------
box6:
	cmp dx, 6
		je check_win6
		jmp box7

check_win6:
	mov ax, [turn]
	cmp ax, 20			; 1 Stands For 'O' Turn
		je player2_turn6
		jne player1_turn6
	
	player2_turn6:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 8]
			jne check46
		cmp bx, [reserved + 6]
			jne check46
			
		call win_horizontal_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl6
		
		check46:
			cmp bx, [reserved + 4]
				jne endl6
			cmp bx, [reserved + 16]
				jne endl6
		
		call win_vertical_line3
		call player2_win_call
		mov [win_check], ax
		jmp endl6
	
	player1_turn6:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 8]
			jne check47
		cmp bx, [reserved + 6]
			jne check47
			
		call win_horizontal_line2
		call player1_win_call
		mov [win_check], ax
		jmp endl6
		
		check47:
			cmp bx, [reserved + 4]
				jne endl6
			cmp bx, [reserved + 16]
				jne endl6
		
		call win_vertical_line3
		call player1_win_call
		mov [win_check], ax
	
	endl6:
		ret

box7:
	cmp dx, 7
		je check_win7
		jmp box8

check_win7
	mov ax, [turn]
	cmp ax, 20			; 10 Stands For 'O' Turn
		je player2_turn7
		jne player1_turn7
	
	player2_turn7:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 6]
			jne check48
		cmp bx, [reserved + 0]
			jne check48
			
		call win_vertical_line1
		call player2_win_call
		mov [win_check], ax
		jmp endl7
		
		check48:
			cmp bx, [reserved + 14]
				jne check49
			cmp bx, [reserved + 16]
				jne check49
		
		call win_horizontal_line3
		call player2_win_call
		mov [win_check], ax
		jmp endl7
		
		check49:
			cmp bx, [reserved + 8]
				jne endl7
			cmp bx, [reserved + 4]
				jne endl7
		
		call RtoL_diagonal_line
		call player2_win_call
		mov [win_check], ax
		jmp endl7
		
	player1_turn7:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 6]
			jne check50
		cmp bx, [reserved + 0]
			jne check50
			
		call win_vertical_line1
		call player1_win_call
		mov [win_check], ax
		jmp endl7
		
		check50:
			cmp bx, [reserved + 14]
				jne check51
			cmp bx, [reserved + 16]
				jne check51
		
		call win_horizontal_line3
		call player1_win_call
		mov [win_check], ax
		jmp endl7
		
		check51:
			cmp bx, [reserved + 8]
				jne endl7
			cmp bx, [reserved + 4]
				jne endl7
		
		call RtoL_diagonal_line
		call player1_win_call
		mov [win_check], ax
		
	endl7:
		ret
box8:
	cmp dx, 8
		je check_win8
		jmp box9
		
check_win8:
	mov ax, [turn]
	cmp ax, 20			; 20 Stands For 'X' Turn
		je player2_turn8
		jne player1_turn8
	
	player2_turn8:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 12]
			jne check52
		cmp bx, [reserved + 14]
			jne check52
		cmp bx, [reserved + 16]
			jne check52

		call win_horizontal_line3
		call player2_win_call
		mov [win_check], ax
		jmp endl8

		check52:
			cmp bx, [reserved + 14]
				jne endl8
			cmp bx, [reserved + 8]
				jne endl8
			cmp bx, [reserved + 2]
				jne endl8

		call win_vertical_line2
		call player2_win_call
		mov [win_check], ax
		jmp endl8
	
	player1_turn8:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 12]
			jne check53
		cmp bx, [reserved + 14]
			jne check53
		cmp bx, [reserved + 16]
			jne check53
			
		call win_horizontal_line3
		call player1_win_call
		mov [win_check], ax
		jmp endl8
		
		check53:
			cmp bx, [reserved + 14]
				jne endl8
			cmp bx, [reserved + 8]
				jne endl8
			cmp bx, [reserved + 2]
				jne endl8
		
		call win_vertical_line2
		call player1_win_call
		mov [win_check], ax
		
	endl8:
		ret
box9:
	cmp dx, 9
		je check_win9
		ret

check_win9:
	mov ax, [turn]
	cmp ax, 20			; 1 Stands For 'O' Turn
		je player2_turn9
		jne player1_turn9
	
	player2_turn9:
		mov bx, 20
		mov ax, 100
		
		cmp bx, [reserved + 14]
			jne check54
		cmp bx, [reserved + 12]
			jne check54
			
		call win_horizontal_line3
		call player2_win_call
		mov [win_check], ax
		jmp endl9
		
		check54:
			cmp bx, [reserved + 10]
				jne check56
			cmp bx, [reserved + 4]
				jne check56
		
		call win_vertical_line3
		call player2_win_call
		mov [win_check], ax
		jmp endl9
		
		check56:
			cmp bx, [reserved + 8]
				jne endl9
			cmp bx, [reserved + 0]
				jne endl9
		
		call LtoR_diagonal_line
		call player2_win_call
		mov [win_check], ax
		jmp endl9
		
	player1_turn9:
		mov bx, 10
		mov ax, 100
		
		cmp bx, [reserved + 14]
			jne check57
		cmp bx, [reserved + 12]
			jne check57
			
		call win_horizontal_line3
		call player1_win_call
		mov [win_check], ax
		jmp endl9
		
		check57:
			cmp bx, [reserved + 10]
				jne check58
			cmp bx, [reserved + 4]
				jne check58
		
		call win_vertical_line3
		call player1_win_call
		mov [win_check], ax
		jmp endl9
		
		check58:
			cmp bx, [reserved + 8]
				jne endl9
			cmp bx, [reserved + 0]
				jne endl9
		
		call LtoR_diagonal_line
		call player1_win_call
		mov [win_check], ax

	endl9:
		ret
;--------------------------------------------------------------------------------
player_turn:
	mov ax, [turn]
		cmp ax, 10
			je play1_call
			jne play2_call

play1_call:
	call player1_turn_call
	ret
play2_call:
	call player2_turn_call
	ret

;--------------------------------------------------------------------------------
play_turn:
	mov ax, [invalid_turn]
	cmp ax, 1
		jz no_turn
	
	
	mov ax, [turn]
		cmp ax, 10
			je turn_play2
		cmp ax, 20
			je turn_play1
		
		turn_play1:
			sub ax, 10
			mov word [turn], ax
			ret
		turn_play2:
			add ax, 10
			mov word [turn], ax
			ret
	no_turn:
		mov ax, 0
		mov [invalid_turn], ax
		ret
;--------------------------------------------------------------------------------
store:
	mov ax, [turn]
	mov word [reserved + bx], ax
	ret
;--------------------------------------------------------------------------------
message_box_colour1: ; di = 0x0AF4

	mov di, 0x0AF4
	add di, 160
	mov cx, 38
	mov ax, 0xb800
	mov es, ax

	loop29:
		sub di, 2
		loop loop29

	mov ah, 0xF7
	mov al, 0

	mov cx, 72

	fill4:
		mov [es:di], ax
		add di, 2
		loop fill4

	sub di, 2
	mov cx, 72
	add di, 160

	fill5:
		mov [es:di], ax
		sub di, 2
		dec cx
		jne fill5
		
	add di, 2
	mov cx, 72
	add di, 160
	
	fill6:
		mov [es:di], ax
		add di, 2
		loop fill6
	ret
;--------------------------------------------------------------------------------
print_X1:
	mov di, 0x02B8
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	
	loop30:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop30
	
	mov [es:di], ax
	
	mov cx, 2
	loop31:
		sub di, 160
	loop loop31
	
	mov cx, 2
	loop32:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop32
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X2:
	mov di, 0x02CC
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop33:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop33
	
	mov [es:di], ax
	
	mov cx, 2
	loop34:
		sub di, 160
	loop loop34
	
	mov cx, 2
	loop35:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop35
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X3:
	mov di, 0x02E0
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop36:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop36
	
	mov [es:di], ax
	
	mov cx, 2
	loop37:
		sub di, 160
	loop loop37
	
	mov cx, 2
	loop38:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop38
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X4:
	mov di, 0x0538
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	
	loop39:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop39
	
	mov [es:di], ax
	
	mov cx, 2
	loop40:
		sub di, 160
	loop loop40
	
	mov cx, 2
	loop41:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop41
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X5:
	mov di, 0x054C
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop42:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop42
	
	mov [es:di], ax
	
	mov cx, 2
	loop43:
		sub di, 160
	loop loop43
	
	mov cx, 2
	loop44:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop44
	
	mov [es:di], ax
	
	ret

;--------------------------------------------------------------------------------
print_X6:
	mov di, 0x0560
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop45:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop45
	
	mov [es:di], ax
	
	mov cx, 2
	loop46:
		sub di, 160
	loop loop46
	
	mov cx, 2
	loop47:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop47
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X7:
	mov di, 0x07B8
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	
	loop48:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop48
	
	mov [es:di], ax
	
	mov cx, 2
	loop49:
		sub di, 160
	loop loop49
	
	mov cx, 2
	loop50:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop50
	
	mov [es:di], ax
	
	ret
;--------------------------------------------------------------------------------
print_X8:
	mov di, 0x07CC
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop51:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop51
	
	mov [es:di], ax
	
	mov cx, 2
	loop52:
		sub di, 160
	loop loop52
	
	mov cx, 2
	loop53:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop53
	
	mov [es:di], ax
	
	ret

;--------------------------------------------------------------------------------
print_X9:
	mov di, 0x07E0
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0xEE00
	loop54:
		mov [es:di], ax
		add di, 160
		sub di, 2
		call sleep
	loop loop54
	
	mov [es:di], ax
	
	mov cx, 2
	loop55:
		sub di, 160
	loop loop55
	
	mov cx, 2
	loop56:
		mov [es:di], ax
		add di, 160
		add di, 2
		call sleep
	loop loop56
	
	mov [es:di], ax
	
	ret

;--------------------------------------------------------------------------------
print_O1:
	mov di, 0x02B8
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop57:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop57
	
	mov [es:di], ax
	
	mov cx, 2
	loop58:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop58
	
	mov [es:di], ax
	mov cx, 2
	loop59:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop59
	
	mov [es:di], ax
	mov cx, 2
	loop60:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop60
	ret
;--------------------------------------------------------------------------------
print_O2:
	mov di, 0x02CC
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop61:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop61
	
	mov [es:di], ax
	
	mov cx, 2
	loop62:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop62
	
	mov [es:di], ax
	mov cx, 2
	loop63:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop63
	
	mov [es:di], ax
	mov cx, 2
	loop64:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop64
	
	ret
;--------------------------------------------------------------------------------
print_O3:
	mov di, 0x02E0
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop65:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop65
	
	mov [es:di], ax
	
	mov cx, 2
	loop66:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop66
	
	mov [es:di], ax
	mov cx, 2
	loop67:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop67
	
	mov [es:di], ax
	mov cx, 2
	loop68:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop68
	
	ret
;--------------------------------------------------------------------------------
print_O4:
	mov di, 0x0538
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop69:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop69
	
	mov [es:di], ax
	
	mov cx, 2
	loop92:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop92
	
	mov [es:di], ax
	mov cx, 2
	loop70:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop70
	
	mov [es:di], ax
	mov cx, 2
	loop71:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop71
	
	ret
;--------------------------------------------------------------------------------
print_O5:
	mov di, 0x054C
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop72:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop72
	
	mov [es:di], ax
	
	mov cx, 2
	loop73:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop73
	
	mov [es:di], ax
	mov cx, 2
	loop74:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop74
	
	mov [es:di], ax
	mov cx, 2
	loop75:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop75
	
	ret

;--------------------------------------------------------------------------------
print_O6:
	mov di, 0x0560
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop76:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop76
	
	mov [es:di], ax
	
	mov cx, 2
	loop77:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop77
	
	mov [es:di], ax
	mov cx, 2
	loop78:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop78
	
	mov [es:di], ax
	mov cx, 2
	loop79:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop79
	
	ret
;--------------------------------------------------------------------------------
print_O7:
	mov di, 0x07B8
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop80:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop80
	
	mov [es:di], ax
	
	mov cx, 2
	loop81:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop81
	
	mov [es:di], ax
	mov cx, 2
	loop82:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop82
	
	mov [es:di], ax
	mov cx, 2
	loop83:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop83
	
	ret
;--------------------------------------------------------------------------------
print_O8:
	mov di, 0x07CC
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop84:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop84
	
	mov [es:di], ax
	
	mov cx, 2
	loop85:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop85
	
	mov [es:di], ax
	mov cx, 2
	loop86:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop86
	
	mov [es:di], ax
	mov cx, 2
	loop87:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop87
	
	ret

;--------------------------------------------------------------------------------
print_O9:
	mov di, 0x07E0
	mov cx, 2
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x4400
	
	loop88:
		mov [es:di], ax
		sub di, 2
		call sleep
	loop loop88
	
	mov [es:di], ax
	
	mov cx, 2
	loop89:
		mov [es:di], ax
		add di, 160
		call sleep
	loop loop89
	
	mov [es:di], ax
	mov cx, 2
	loop90:
		mov [es:di], ax
		add di, 2
		call sleep
	loop loop90
	
	mov [es:di], ax
	mov cx, 2
	loop91:
		mov [es:di], ax
		sub di, 160
		call sleep
	loop loop91	
	ret
;--------------------------------------------------------------------------------
print_pattern:
	mov ax, [turn]
		cmp ax, 10
			je print_O
		cmp ax, 20
			je print_X
			
print_O:
	cmp dx, 1
		je p01
	cmp dx, 2
		je p02
	cmp dx, 3
		je p03
	cmp dx, 4
		je p04
	cmp dx, 5
		je p05
	cmp dx, 6
		je p06
	cmp dx, 7
		je p07
	cmp dx, 8
		je p08
	cmp dx, 9
		je p09
	ret
p01:
	call print_O1
	ret
p02:
	call print_O2
	ret
p03:
	call print_O3
	ret
p04:
	call print_O4
	ret
p05:
	call print_O5
	ret
p06:
	call print_O6
	ret
p07:
	call print_O7
	ret
p08:
	call print_O8
	ret
p09:
	call print_O9
	ret
print_X:
	cmp dx, 1
		je pX1
	cmp dx, 2
		je pX2
	cmp dx, 3
		je pX3
	cmp dx, 4
		je pX4
	cmp dx, 5
		je pX5
	cmp dx, 6
		je pX6
	cmp dx, 7
		je pX7
	cmp dx, 8
		je pX8
	cmp dx, 9
		je pX9
	ret
pX1:
	call print_X1
	ret
pX2:
	call print_X2
	ret
pX3:
	call print_X3
	ret
pX4:
	call print_X4
	ret
pX5:
	call print_X5
	ret
pX6:
	call print_X6
	ret
pX7:
	call print_X7
	ret
pX8:
	call print_X8
	ret
pX9:
	call print_X9
	ret
;--------------------------------------------------------------------------------
game:
		call mouse
		call check   ;check move is valid or not
		
		cmp ax, 1
			je invalid_move

		mov ax, 2
		int 33h
		call message_box_colour1
		call print_pattern
		call check_box ;check if a player has won or not
		mov ax, 1
		int 33h
invalid_move:
	ret
;--------------------------------------------------------------------------------
Clear_Screen_After_Ending:
	mov di, 4000
	mov ax, 0xb800
	mov cx, 25
	mov ax, 0x0000
	loop114:
		cmp cx, 0
			je endl
		push cx
		mov cx, 80
		loop115:
			mov [es:di], ax
			sub di, 2
		loop loop115
		
		mov [es:di], ax
		
		call sleep
		call sleep
		
		sub di, 160
		
		pop cx
		dec cx
		
		cmp cx, 0
			je endl
		
		push cx
		mov cx, 80
		loop116:
			mov [es:di], ax
			add di, 2
		loop loop116
		sub di, 160
		pop cx
		call sleep
		call sleep
	loop loop114
	
	endl:
		ret
;--------------------------------------------------------------------------------
Again_Play:
	mov ax, 26
	push ax
	
	mov ax, 19
	push ax
	
	mov ax, 0x76
	push ax
	
	mov ax, Play_Again
	push ax
	
	call message_print
	
	mov ah, 0
	int 16h
	cmp al, 'y'
		je game_not_end
	cmp al, 'n'
		je true_game_end
		jmp Again_Play
	game_not_end:
	mov ax, 0
	
	mov cx, 9
	mov si, 0
	
	loop113:
		mov word [reserved + si], ax
		add si, 2
	loop loop113
	
	
	mov word [win_check], ax
	mov word [invalid_turn], ax
	
	mov ax, 10
	mov word [turn], ax
	
	mov ax, 1
	
	true_game_end:
	ret
;--------------------------------------------------------------------------------
start:
	call clear_screen
	
	mov ax, 1
	push ax ; push top
	
	mov ax, 2
	push ax ; push left
	
	mov ax, 22
	push ax ; push bottom
	
	mov ax, 78
	push ax ; push right
	
	mov ax, 0x44 ; Red FG
	push ax ; push attribute

	call printRectangle

	
	mov ax, 3
	push ax ; push top
	
	mov ax, 23
	push ax; push left
	
	mov ax, 14
	push ax; push bottom
	
	mov ax, 52
	push ax ; push right
	
	mov ax, 0xD5
	push ax
	
	call printRectangle
	
	call Fill_Box
	
	call Print_Straight_Line
	call Print_Horizontal_Line
	
	mov ax, 17
	push ax ; push top
	
	mov ax, 4
	push ax ; push left
	
	mov ax, 20
	push ax ; push bottom
	
	mov ax, 76
	push ax
	
	mov ax, 0x00
	push ax
	
	call printRectangle
	call message_box_colour
	call ttt_print
	
	play:
		call player_turn
		call game
		
		mov ax, 0
		cmp ax, [win_check + 0]
			jne game_end

		call play_turn ;Change Player Turn
		
		mov ax, 0
		mov [invalid_turn], ax

		mov cx, 9
		mov si, 0
		loop111:	;Checking if all the boxes are filled or not
			cmp ax, [reserved + si]
				je play
			add si, 2
		loop loop111
;--------------------------------------------------------------------------------
draw_end:
	call Draw_call
	mov cx, 10
	loop112:
		call sleep
	loop loop112
game_end:
	mov ax, 2
	int 33h
	mov cx, 80
	loop117:
		call sleep
	loop loop117
	call Again_Play
	cmp ax, 1
	jz start
	call Clear_Screen_After_Ending
	
	mov ax, 35
	push ax
	
	mov ax, 12
	push ax
	
	mov ax, 0x07
	push ax
	
	mov ax, farewell
	push ax
	
	call message_print
	
	mov ax, 0x4c00
	int 0x21