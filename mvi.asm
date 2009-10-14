Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	deltax db 5
	deltay db 1
	xpos db 1
	ypos db 1
	delay dw 05ffh
	
.code
;Macro que determina la localizacion de un desplazamiento utilizando las filas y columnas y devolviendo el valor en el registro bx
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

;Programa simple que simula el movimiento de un objeto en una pantalla de video, usa deltax y deltay para determinar cuanto se mueve el objeto
main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 10
	
	again:
	call moveOb
	
	coordenadas ypos, xpos
	
	call clear
	mov al, 'Q'
	mov ah, 0fh
	mov es:[bx], ax
	call sleep
	
	loop again
	
	mov ax, 4c00h
	int 21h
main endp

;Esta subrutina mueve un pixel del objecto por una cantidad deltax y deltay
moveOb proc
	push ax
	push bx
	mov al, deltay
	mov ah, 0
	mov bl, ypos
	add bl, al
	;Aqui se debe verificar si se salio de la parte inferior o superior de la pantalla
	mov ypos, bl
	
	mov al, deltax
	mov ah, 0
	mov bl, xpos
	add bl, al
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	mov xpos, bl
	pop bx
	pop ax
	ret
moveOb endp

;Esta subrutina borra cualquier cosa que se encuentre en la pantalla de DOS
clear proc
	push cx
	push bx
	mov bx, 0
	mov cx, 2000
	
	clearall:
	mov es:[bx], 0
	inc bx
	inc bx
	loop clearall
	
	pop bx
	pop cx
	ret
clear endp

;Esta subrutina manipula la velocidad a la que va a correr el programa utilizando la variable delay
sleep proc
	push cx
	
	mov cx, delay
	sleepingag:
		push cx
		mov cx, 00ffh
		sleeping:
		loop sleeping
		pop cx
	loop sleepingag
	
	pop cx
	ret
sleep endp

end main
	