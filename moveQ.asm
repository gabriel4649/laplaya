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
        render db 4000 dup(0)
	red db 44h
	white db 0ffh
	memoria db 2

	
.code

;Esta subrutina dibuja el objeto que va a rebotar en la pantalla utilizando las variables xpos y ypos como referencia(Creado por Jaime el 15 de octubre de 2009)

mushroom macro location
	local supRed
        local infRed
        local whitePart

	push ax
	push bx
	push cx
	push dx
	
	mov bx, 0
	mov dh, ypos
	mov dl, xpos
	push dx
	add xpos, 1
	
	mov cx, 4
	supRed:
		colorpixel ypos, xpos, red, location
		add xpos, 1
	loop supRed
	add ypos, 1
	
	pop dx
	mov xpos, dl
	push dx
	mov cx, 6
	
	infRed:
		colorpixel ypos, xpos, red, location
		add xpos, 1
	loop infRed
	add ypos, 1
	
	pop dx
	mov xpos, dl
	push dx
	add xpos, 1
	mov cx, 4
	whitePart:
		colorpixel ypos, xpos, white, location
		add xpos, 1
	loop whitePart
	
	pop dx
	mov xpos, dl
	mov ypos, dh
	
	pop dx
	pop cx
	pop bx
	pop ax

endm
	
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

;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video
colorPixel macro fila, columna, color, memoria
	local escribirABorron
        local escribirARender
        local escribirAVideo
        local terminado

	push ax
	push bx
	push dx
	
	mov dx, memoria
	coordenadas fila, columna
	mov ah, color
	mov al, 0
        cmp dx, 1
        je escribirABorron
        cmp dx, 2
        je escribirARender
        cmp dx, 3
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
	pop dx
	pop bx
	pop ax
endm

checkCoordinatesnew macro xpos, ypos, widthh, height


;Check upper left corner
checkPixel xpos, ypos

;Check upper right corner
push ax; safeguard ax
push bx; safeguard bx
push dx; safeguard dx
push cx

mov ch, widthh
mov cl, height

mov dh, ypos; dh will store ypos
mov dl, xpos; dl will store xpos
push dx; safeguard the original xpos and ypos

mov dh, ypos
mov dl, xpos
push dx; safe for future use

mov bh, 0
mov bl, xpos
mov al, ch

add bl, al; add xpos and widthh
adc bh, 0
mov xpos, bl
checkPixel xpos, ypos

;Check lower right corner
mov bh, 0
mov bl, ypos
mov al, cl
;push ypos
add bl, al; add ypos and height
adc bh, 0
mov ypos, bl
checkPixel xpos, ypos

;Check lower left corner
pop dx; Get original xpos and ypos values
mov ypos, dh; restore ypos
mov xpos, dl; restore xpos

mov bh, 0
mov bl, ypos
mov al, cl
add bl, al; add ypos and height
adc bh, 0
mov ypos, bl
checkPixel xpos, ypos

;Restore values
pop dx
pop cx
pop dx
mov ypos, dh
mov xpos, dl
pop bx
pop ax

endm

checkPixel macro xpos, ypos

  local rgtLftBorder
  local infSupBorder
  local boundaryChecked
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
	
	mushroom 3
	call sleep
	
	loop jumpFarther
	jmp finishMain
	
	jumpfarther:
	jmp again
	
	finishMain:
	mov ax, 4c00h
	int 21h
main endp

;Esta subrutina mueve un pixel del objecto por una cantidad deltax y deltay
moveOb proc
	push ax
	push bx
	moveD deltay, ypos
	
	;Aqui se debe verificar si se salio de la parte inferior o superior de la pantalla
	checkCoordinatesnew xpos, ypos, 6, 3
	
	moveD deltax, xpos
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	;checkCoordinatesnew xpos, ypos, 6, 3
	pop bx
	pop ax
	ret
moveOb endp

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

;Especifica que pixeles de video se tienen que borrar. Lo hace guardando esta informacion en una variable tipo array (Creado por Jaime el 14 de octubre de 2009)
setErasePixels proc
	push ax
	push bx
        
        mov ah, white
        mov al, red

        mov bx, 1
     
	cmp borrar, 1
        jnz noSetPixel
        mov white, 1
        mov red, 1
     
	mushroom 1
        
	jmp finished
        	
	noSetPixel:
	mov white,0
        mov red, 0
	mushroom 1
        
        finished:
        mov white, ah
        mov red, al
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
		mov render[bx], al
		inc bx
		mov render[bx], ah
		dec bx
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
	