Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	deltax db 1
	deltay db 1
	xpos db 1
	ypos db 1
	delay dw 03ffh
	rebotes db 2
	dummy db ?
	borrar db 0
	erasePixel db 4000 dup(0)

	
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

moveD macro delta, pos
	push ax
	mov al, delta
	mov ah, 0
	mov bl, pos
	add bl, al
	mov pos, bl
	pop ax
endm


;Programa simple que simula el movimiento de un objeto en una pantalla de video, usa deltax y deltay para determinar cuanto se mueve el objeto
main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 250
	mov al, rebotes
	mov dummy, al
	
	again:
	call setErasePixels
	call moveOb ;Actualiza las variables posx y posy para que el objeto se dibuje en una parte diferente
	
	coordenadas ypos, xpos
	
	call clear
	call eraser
	
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
	moveD deltay, ypos
	
	;Aqui se debe verificar si se salio de la parte inferior o superior de la pantalla
	call checkCoordinates
	
	moveD deltax, xpos
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	call checkCoordinates
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
	cmp erasePixel[bx], 1
	jz noClear ;If el pixel no es cero, sal de la funcion
	mov ax, 0
	mov es:[bx], ax 
	noClear:
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

checkCoordinates proc

  cmp xpos,0
  jl rgtLftBorder ;if x is negative
  cmp xpos,79
  jg rgtLftBorder; if x is bigger 
  
  
  cmp ypos,0
  jl infSupBorder; if y is negative
  cmp ypos,24
  jg infSupBorder; if y is bigger than 25
  jmp boundaryChecked
  
  rgtLftBorder:
    neg deltax
    moveD deltax, xpos
    moveD deltax, xpos
    sub dummy, 1
    jz setErase
    jmp boundaryChecked

   infSupBorder:
    neg deltay
    moveD deltay, ypos
    moveD deltay, ypos   
    sub dummy, 1
    jz setErase
    jmp boundaryChecked
    
    setErase:
    xor borrar, 1
    jmp boundaryChecked

  boundaryChecked: 
  
  ret
checkCoordinates endp

setErasePixels proc
	push ax
	push bx
	cmp borrar, 1
	jnz noSetPixel
	coordenadas ypos, xpos
	mov erasePixel[bx], 1
	
	noSetPixel:
	pop bx
	pop ax
	ret
setErasePixels endp

;Estoy trabajando en esta parte
eraser proc
	push ax
	push cx
	push bx
	
	mov cx, 2000
	mov bx, 0
	checkErase:
		cmp erasePixel[bx], 1
		jnz doNothing ;If el pixel no es cero, sal de la funcion
		mov ax, 0ffffh
		mov es:[bx], ax 
		doNothing:
		inc bx
		inc bx
	loop checkErase
	
	pop bx
	pop cx
	pop ax
	ret
eraser endp

end main
	