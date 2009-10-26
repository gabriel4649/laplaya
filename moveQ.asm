Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	deltax db 1
	deltay db 1
	xpos db 1
	ypos db 1
	delay dw 05ffh
	rebotes db 10
	dummy db ? ; Se utiliza esta variable para no modificar el numero de rebotes (se necesita saber el numero de rebotes para cuando el programa deje de borrar)
	borrar db 3
	erasePixel db 4000 dup(0)
        render db 4000 dup(0)
	red db 44h
	white db 0ffh
	blue db 11h
	green db 22h
	brown db 66h
        flag db 0
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
		colorPixel dh, dl, white, 2
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
			colorPixel dh, dl, white, 2
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
		colorPixel dh, dl, white, 2
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
		colorPixel dh, dl, brown, 2
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
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushInf

pop dx
push dx

sub dh, 1
add dl, 1
mov cx, 5

paintingBushMid:
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushMid

pop dx
push dx

sub dh, 2
add dl, 2
mov cx, 3
paintingBushSup:
	colorPixel dh, dl, green, 2
	inc dl
loop paintingBushSup

pop dx
pop cx
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
        ; Borrar
        ; Estado 3 = No hacer nada, flotar
        ; Estado 1 = Escribir el background
        ; Estado 0 = Borrar el background
	local noSetErase
        local writing
        local normal     

        push ax; Guardar a ax

        cmp borrar, 3; En el estado 3 no hacer nada
        jnz normal; Verificar si borrar esta en el estado 0 o 1
        sub dummy,1; Disminuir dummy
        jnz noSetErase; Si no es cero salir del macro
        mov al, rebotes; Si se llega a cero pasar rebotes a al para restaurar dummy
        mov dummy, al; Restaurar dummy al numero de rebotes
        add dummy, 1; Añadirle 1 a dummy porque se le va a restar uno ahora aunque no halla chocado
        mov borrar, 0; Setear borrar al estado 0, el de borrar. 

        normal:

        cmp borrar, 1; Verificar si esta en el estado 1
        je writing; Escribir el background
	sub dummy, 1; Disminuir dummy
	jnz noSetErase; Si no es cero salir del macro
        mov al, rebotes; Si es cero restuarar dummy y setear borrar al estado 1
        mov dummy, al
	mov borrar,1
        
        jmp noSetErase; Salir del macro
	
	writing: 
        sub dummy, 1; Disminuir dummy
        jnz noSetErase; Salir del macro si no es cero
        mov al, rebotes; ; Si es cero restaurar dummy y pasar al estado 3
        mov dummy, al
        mov borrar, 3     
        
	noSetErase:
        pop ax
endm
cmp dummy,al
;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video
colorPixel macro fila, columna, color, memoria
        ;Memoria 1 = Mapa de donde se va a borrar
        ;Memoria 2 = Memoria render, la memoria intermedia que despues se copia a la memoria de video
        ;Memoria 3 = Memoria de video

	local escribirABorron
        local escribirARender
        local escribirAVideo
        local terminado

	push ax
	push bx
	push cx
	
	mov cx, memoria; Guardar a cx el numero de memoria a donde se va a escribir
	coordenadas fila, columna; Buscar las coordenadas
	mov ah, color; Guardar el color que se va a escribir
	mov al, 0
        cmp cx, 1
        je escribirABorron
        cmp cx, 2
        je escribirARender
        cmp cx, 3
        je escribirAVideo

        escribirABorron: 
	mov erasePixel[bx], ah; Escribir en la coordenada bx el color ah en la mapa de borron
	inc bx
	mov erasePixel[bx], ah; Repetir para el proximo byte
        jmp terminado 

        escribirARender:
	mov render[bx], al; Escribir en la coordenada bx 0
	inc bx
	mov render[bx], ah; Escribir en el proximo byte el color ah
	jmp terminado

	escribirAVideo: mov es:[bx], ax; Pasar el byte entero a la memoria de video
        jmp terminado
	

        terminado:
	pop cx
	pop bx
	pop ax
endm


;Macro que determina si el objeto se salio de la pantalla y le cambia la direccion para arreglarlo. (Creado por Jaime 24 de octubre de 2009)
checkPixel macro delta, pos, border, lengthh

  local outBorder
  local boundaryChecked
  
  push ax
  mov al, border
  mov ah, lengthh
  
  sub al, ah ;Esta resta se hace con el proposito de verificar hasta que punto relativo puede moverse el objeto
  
  cmp pos, 0
  jl outBorder;if pos is negative
  cmp pos, al
  jg outBorder; if pos is bigger 
  jmp boundaryChecked
  
  
  outBorder:
    changeDelta delta, pos
    mov flag, 1
    
  boundaryChecked:
  pop ax

endm

;Macro que cambia direccion a la que se mueve el objeto. (Creado por Jaime 24 de octubre de 2009)
changeDelta macro delta, pos
	neg delta
	moveD delta, pos
	setErase
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
        
        call background; Dibjar background en "render"
        call eraser; borrar lo que alla que borrar
        mushroom 2; escribir hongo en "render"
               
        call doRender; copiar render a memoria de video
	
	
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
	;checkCoordinatesnew xpos, ypos, 6, 4; 6 y 3 son el ancho y el largo de la imagen
	checkPixel deltay, ypos, 25, 3
	
	moveD deltax, xpos
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	checkPixel deltax, xpos, 79, 5
	pop bx
	pop ax
	ret
moveOb endp

doRender proc
         push ax; Guardar los registros
         push bx
         push cx

         mov cx, 2000; Repeat for all of video memeroy
         
         ; Move data from render to video memory
         renderLoop:    
	 mov al, render[bx]; move data from bx to ax
	 inc bx
	 mov ah, render[bx]
	 dec bx
         mov es:[bx], ax; write to video memory
         inc bx; increment memory index
         inc bx
         loop renderLoop
         
	 pop cx
         pop bx
         pop ax
	 ret
doRender endp

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
        cmp borrar, 3; Si esta en el estado 3, el estado de flotar, simplemente sal de la subrutina. 
	je dontDoAnything

	push ax; Guardar a ax
	    
        mov ah, white; Guardar valores originales de white y red 
        mov al, red
     
	cmp borrar, 1
        jnz noSetPixel
        mov white, 0; Poner 0 el red y white para cuando se escriba el hongo en el mapa de borrar lo que alla es un hongo compuesto de 0s. 
        mov red, 0
     
	mushroom 1; Escribir el hongo que consiste de 0s al mapa de borrar. 
        
	jmp finished
        	
	noSetPixel:
	mov white,1; Poner 1 el red y white para cuando se escriba el hongo en el mapa de borrar lo que alla es un hongo compuesto de 1s. 
        mov red, 1
	mushroom 1; Escribir el hongo que consiste de 1s al mapa de borrar. 
        
        finished:
        mov white, ah; Restaurar white y red
        mov red, al

	pop ax
        dontDoAnything:
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
		mov ax, 0h
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
			colorPixel dh, dl, green, 2
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
			colorPixel dh, dl, green, 2
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

end main
	