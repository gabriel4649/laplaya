Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	deltax db 1
	deltay db 1
	xpos db 1
	ypos db 1
	delay dw 01ffh
	rebotes db 2 
	dummy db ? ; Se utiliza esta variable para no modificar el numero de rebotes (se necesita saber el numero de rebotes para cuando el programa deje de borrar)
	borrar db 0
	erasePixel db 4000 dup(0)

	
.code
	
;Macro que determina la localizacion de un desplazamiento utilizando las filas y columnas y devolviendo el valor en el registro bx(Creado por Jaime el 13 de octubre de 2009)
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

;Macro que actualiza la posicion del objeto utilizando como parametros el cambio en direccion y la posicion actual(Creado por Jaime el 13 de octubre de 2009)
moveD macro delta, pos
	push ax
	mov al, delta
	mov ah, 0
	mov bl, pos
	add bl, al
	mov pos, bl
	pop ax
endm

;Macro que verifica si el objeto debe comenzar a borrar la imagen(Creado por Jaime el 14 de octubre de 2009)
setErase macro 
	local noSetErase
        local erasing
        local invertirBorrar      

        push ax

        cmp borrar, 1
        je erasing
	sub dummy, 1
	jnz noSetErase
	jmp invertirBorrar
	
	erasing: 
        add dummy, 1
        mov al,rebotes
        cmp dummy,al
        jnz noSetErase

        invertirBorrar: 
        xor borrar, 1
        
	noSetErase:
        pop ax
endm


;Programa simple que simula el movimiento de un objeto en una pantalla de video, usa deltax y deltay para determinar cuanto se mueve el objeto(Creado por Jaime el 13 de octubre de 2009)
main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 1000
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

;Esta subrutina borra cualquier cosa que se encuentre en la pantalla de DOS(Creado por Jaime el 13 de octubre de 2009)
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

;Esta subrutina manipula la velocidad a la que va a correr el programa utilizando la variable delay(Creado por Jaime el 13 de octubre de 2009)
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

;Verifica si el objeto se salio de la pantalla y si esto ocurre, cambia la direccion a la que se va a mover
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
    call changeDx
    jmp boundaryChecked

   infSupBorder:
    call changeDy
    jmp boundaryChecked
    

  boundaryChecked: 
  
  ret
checkCoordinates endp

;Especifica que pixeles de video se tienen que borrar. Lo hace guardando esta informacion en una variable tipo array (Creado por Jaime el 14 de octubre de 2009)
setErasePixels proc
	push ax
	push bx
	cmp borrar, 1
        jnz noSetPixel
	coordenadas ypos, xpos
	mov erasePixel[bx], 1
	jmp finished
        
        
	
	noSetPixel:
        coordenadas ypos, xpos
	mov erasePixel[bx], 0
        
        finished:
	pop bx
	pop ax
	ret
setErasePixels endp

;Borra la parte de la pantalla que se debe borrar luego de que el objeto rebota varias veces en la pantalla (Creado por Jaime el 14 de octubre de 2009)
eraser proc
	push ax
	push cx
	push bx
	
	mov cx, 2000
	mov bx, 0
	checkErase:
		cmp erasePixel[bx], 1 ; Verifica si se debe borrar el pixel apuntado por bx
		jnz doNothing ;If el pixel no es cero, vuelve a iterar
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

changeDx proc
	neg deltax
	moveD deltax, xpos
	setErase
	ret
changeDx endp

changeDy proc
	neg deltay
	moveD deltay, ypos
	setErase
	ret
changeDy endp

end main
	