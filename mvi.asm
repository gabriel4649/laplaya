Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	deltax db 1
	deltay db 1
	xpos db 1
	ypos db 1
	
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
	
	mov cx, 30
	
	again:
	
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
	
	coordenadas ypos, xpos
	
	mov al, 'Q'
	mov ah, 0fh
	mov es:[bx], ax
	
	loop again
	
	mov ax, 4c00h
	int 21h
main endp



end main
	