Title Programa que tiene una subrutina que dibuja el background del proyecto de micro
.model small 
.stack 100h
.data
	marca db '>>>>'
	white db 077h
	blue db 11h
	green db 22h
	brown db 66h
	render db 4000 dup(0)
	memoria db 2
	erasePixel db 4000 dup(0)

.code

coordenadas macro fila, columna
	push ax
	mov al, fila
	mov ah, 0
	mov bl, 160
	mul bl
	
	mov bx, ax
	add bl, columna
	adc bh, 0
	add bl, columna
	adc bh, 0
	pop ax
endm

;Necesita las coordenadas en dx, dh es la fila y dl es la columna(creado por Jaime 15 de octubre de 2009)
cloud macro
	local paintingMidCloud
	local paintingMid
	local paintingSupCloud
	local paintingInfCloud
	
	push ax
	push cx
	push dx
	mov cx, 6
	paintingSupCloud:
		colorPixel dh, dl, white, memoria
		inc dl
	loop paintingSupCloud
	
	pop dx
	sub dl, 2
	add dh, 1
	push dx
	mov cx, 2
	
	paintingMidCloud:
		push cx
		mov cx, 10
		paintingMid:
			colorPixel dh, dl, white, memoria
			inc dl
		loop paintingMid
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al	
	loop paintingMidCloud
	
	pop dx
	add dl, 2
	add dh, 2
	push dx
	mov cx, 6
	paintingInfCloud:
		colorPixel dh, dl, white, memoria
		inc dl
	loop paintingInfCloud
	pop dx
	pop cx
	pop ax
endm

;Dibuja un bloque marron (Creado por Jaime 16 de octubre de 2009)
block macro
local paintingBlock
local painting

push ax
push cx
push dx

mov cx, 2
paintingBlock:
	push cx
	mov cx, 4
	painting:
		colorPixel dh, dl, brown, memoria
		inc dl
	loop painting
	mov al, dh
	pop cx
	pop dx
	push dx
	inc al
	mov dh, al	
loop paintingBlock

pop dx
pop cx
pop ax
endm


bush macro
local paintingBushInf
local paintingBushMid
local paintingBushSup
push ax
push cx
push dx

mov cx, 7
paintingBushInf:
	colorPixel dh, dl, green, memoria
	inc dl
loop paintingBushInf

pop dx
push dx

sub dh, 1
add dl, 1
mov cx, 5

paintingBushMid:
	colorPixel dh, dl, green, memoria
	inc dl
loop paintingBushMid

pop dx
push dx

sub dh, 2
add dl, 2
mov cx, 3
paintingBushSup:
	colorPixel dh, dl, green, memoria
	inc dl
loop paintingBushSup

pop dx
pop cx
pop ax
endm


;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video(creado por Jaime 15 de octubre de 2009)
;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video
colorPixel macro fila, columna, color, memoria
	local escribirABorron
        local escribirARender
        local escribirAVideo
        local terminado

	push ax
	push bx
	coordenadas fila, columna
	mov ah, color
	mov al, 0
        cmp memoria, 1
        je escribirABorron
        cmp memoria, 2
        je escribirARender
        cmp memoria, 3
        je escribirAVideo

        escribirABorron: 
	mov erasePixel[bx], al
	inc bx
	mov erasePixel[bx], ah
        jmp terminado 

        escribirARender:
	mov render[bx], al
	inc bx
	mov render[bx], ah
	jmp terminado

	escribirAVideo: mov es:[bx], ax	
        jmp terminado
	

        terminado:
	pop bx
	pop ax
endm

main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	call background
	call doRender
	
	mov ax, 4c00h
	int 21h
main endp

background proc
	push ax
	push bx
	push cx
	push dx
	
	mov bx, 0
	mov cx, 1600
	paintingSky:
		mov ah, blue
		mov al, 0
		mov render[bx], al
		inc bx
		mov render[bx], ah
		inc bx
	loop paintingSky
	
	mov cx, 400
	paintingGround:
		mov ah, brown
		mov al, 0
		mov render[bx], al
		inc bx
		mov render[bx], ah
		inc bx
	loop paintingGround
	
	mov dl, 71
	mov dh, 14
	push dx
	mov cx, 3
	paintingSupPipe:
		push cx
		mov cx, 9
		paintingSup:
			colorPixel dh, dl, green, memoria
			inc dl
		loop paintingSup
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al
	loop paintingSupPipe
	
	pop dx
	mov dl, 73
	mov dh, 17
	push dx
	mov cx, 3

	paintingInfPipe:
		push cx
		mov cx, 7
		paintingInf:
			colorPixel dh, dl, green, memoria
			inc dl
		loop paintingInf
		mov al, dh
		pop cx
		pop dx
		push dx
		inc al
		mov dh, al
	loop paintingInfPipe
	
	mov dh, 0
	mov dl, 7
	cloud
		
	mov dh, 0
	mov dl, 65
	cloud

	mov dh, 12
	mov dl, 12
	block
		
	mov cx, 3
	mov dh, 12
	mov dl, 30
	paintingBlocks:
		block
		add dl, 6
	loop paintingBlocks
	
	mov dh, 6
	mov dl, 36
	block
	
	
	mov dh, 19
	mov dl, 5
	bush
	
	mov dh, 19
	mov dl, 60
	bush
		
	
	pop dx
	pop dx
	pop cx
	pop bx
	pop ax
	ret
background endp


doRender proc
         push ax
         push bx
         push cx

         mov bx,0
         mov cx, 2000

         renderLoop:    
	 mov al, render[bx]
	 inc bx
	 mov ah, render[bx]
	 dec bx
         mov es:[bx], ax
         inc bx
         inc bx
         loop renderLoop
         
	 pop cx
         pop bx
         pop ax
	 ret
doRender endp

end main

