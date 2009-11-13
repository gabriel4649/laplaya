Title subrutina que mueve un caracter en la pantalla por un delta X y delta Y
.model small
.stack 100h
.data
	marca db '>>>>'
	
        ;Variables del hongo
        deltax db -4
	deltay db 1
	xpos db 40
	ypos db 2
        rebotes db 30
	;Variables del hongo fin 
	
	 ; Se utiliza esta variable para no modificar el numero de rebotes (se necesita saber el numero de rebotes para cuando el programa deje de borrar)
	dummy db ?
	
	; Determina el estado de la imagen, o sea si va a flotar, borrar o pintar de nuevo el background.
	; (0) Pinta
	; (1) Borra
	; (3) Flota
	borrar db 3  
	
        ;Selecciona cual background es el que se va a dibujar el hongo
	;En 0 dibuja el background original y en 1 dibuja el segundo background
	backgroundSelect1 db 0
	
 
        ;Variables de la flor
        deltax2 db 4
        deltay2 db 1
        xpos2 db 15
        ypos2 db 10
        rebotes2 db 30
        dummy2 db ?
        borrar2 db 3
	;Variables de la flor fin
	
	;Selecciona cual background es el que se va a dibujar la flor
	;En 0 dibuja el background original y en 1 dibuja el segundo background
	backgroundSelect2 db 0
        
        ;Determina cuan rapido se va a mover la imagen, o sea cuan rapido va a correr el programa
        delay dw 0001h
        
        ;Variable que determina que pixel se va a dibujar en la pantalla.
	;(0) Se dibuja pixel del primer background
	;(1) Se dibuja un pixel negro
	;(2) Se dibuja pixel del segundo background
	erasePixel db 4000 dup(0)
	
	
        ;La imagen que se va a dibujar en pantalla primero se dibuja en esta variable.
	;Esto se hace para que no se vea el proceso de borrar y de dibujar la imagen.
	;De esta manera cuando se dibuja a pantalla se ve mas bonito
        render db 4000 dup(0)
	
	
	;Esta variable contiene el segundo background
	bowserCastle db 4000 dup(0)
	

        ;colores
	red db 44h
	white db 0ffh
	blue db 11h
	green db 22h
	brown db 66h
	yellow db 0eeh
        black db 00h
        gray db 088h
	purple db 55h
	detailBrown db 60h

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de un goomba a la variable render,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx En este registro se guardan las coordenadas en donde se va a guardar la imagen. En dh se guarda la fila y en dl la columna

;Creado por Jaime 11 de noviembre de 2009

goomba macro

	push ax
	push cx
	push dx

	mov cx, 5

	paintingRow1:
		colorPixel dh, dl, brown, 2
		inc dl
	loop paintingRow1

	pop dx
	dec dl
	inc dh
	push dx

	mov cx, 7
	paintingRow2:
		colorPixel dh, dl, brown, 2
		inc dl
	loop paintingRow2

	pop dx
	dec dl
	inc dh
	push dx

		;Painting third row

	colorPixel dh, dl, brown, 2
	inc dl
	colorPixel dh, dl, brown, 2
	inc dl

	mov cx, 5
	paintingRow3:
		colorPixel dh, dl, white, 2
		inc dl
	loop paintingRow3

	colorPixel dh, dl, brown, 2
	inc dl
	colorPixel dh, dl, brown, 2
		;End painting third row

	pop dx
	dec dl
	inc dh
	push dx

		;Painting fourth row

	mov cx, 11
	paintingRow4First:
		colorPixel dh, dl, brown, 2
		inc dl 
	loop paintingRow4First

	pop dx
	push dx
	add dl, 2

	mov cx, 7
	paintingRow4Second:
		colorPixel dh, dl, white, 2
		inc dl
	loop paintingRow4Second

	pop dx
	push dx
	add dl, 4
	colorPixel dh, dl, black, 2
	add dl, 2
	colorPixel dh, dl, black, 2
	
		;End painting fourth row
	pop dx
	dec dl
	inc dh
	push dx
		;Painting fifth row

	mov cx, 13
	paintingRow5:
		colorPixel dh, dl, brown, 2
		inc dl
	loop paintingRow5

		;End painting fifth row

	pop dx
	inc dh
	push dx
		;Painting sixth row
	mov cx, 13
	paintingRow5First:
		colorPixel dh, dl, brown, 2
		inc dl
	loop paintingRow5First
	
	pop dx
	push dx
	add dl, 4

	mov cx, 5
	paintingRow5Second:
		colorPixel dh, dl, white, 2
		inc dl
	loop paintingRow5Second
		;End painting sixth row	

	pop dx
	inc dl
	inc dh
	push dx
	
		;Painting seventh row

	mov cx, 11
	paintingRow6First:
	
		colorPixel dh, dl, black, 2
		inc dl
		
	loop paintingRow6First

	pop dx
	push dx
	add dl, 4

	mov cx, 3
	paintingRow6Second:
	
		colorPixel dh, dl, brown, 2
		inc dl
	loop paintingRow6Second
		;End painting seventh
	pop dx
	inc dh
	push dx

		;Painting Eighth Row

	mov cx, 4
	paintingRow7First:
	
		colorPixel dh, dl, black, 2
		inc dl
		
	loop paintingRow7First

	add dl, 3

	mov cx, 4
	paintingRow7Second:
	
		colorPixel dh, dl, black, 2
		inc dl
		
	loop paintingRow7Second

	
		;End painting Eighth
	pop dx
	pop cx
	pop ax

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de una moneda a la variable render,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx En este registro se guardan las coordenadas en donde se va a guardar la imagen. En dh se guarda la fila y en dl la columna

;Creado por Jaime 11 de noviembre de 2009
coin macro

	local paintingSecond
	local paintingThird

	push ax
	push cx
	push dx
	
	colorPixel dh, dl, purple, 2
	
	pop dx
	inc dh
	dec dl
	push dx	
	
	;Painting second row

	mov cx, 3
	
	paintingSecond:
	
		colorPixel dh, dl, purple, 2
		inc dl

	loop paintingSecond
	
	;End second

	pop dx
	inc dh
	push dx

	;Painting third row	
	
	mov cx, 3

	paintingThird:
		colorPixel dh, dl, purple, 2
		inc dl
	loop paintingThird

	
	;End third

	pop dx
	inc dh
	inc dl
	push dx

	colorPixel dh, dl, purple, 2

	pop dx
	pop cx
	pop ax
	

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;____________((((((((KOOPA)))))))))))))___________________________________
;(((((((((Dibuja a koopa (editado por Daphne 23 de Octubre de 2009))))))))

koopa macro
local paintingKoopa
local paintingK

push ax
push cx
push dx

mov cx, 1
paintingKoopa:
push cx
mov cx, 1
paintingK:
colorPixel dh, dl, green, 4
inc dl
loop paintingK
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintingKoopa

pop dx
pop cx
pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;_______(((((((((((((((((((Blanco)))))))))))))))_______________________________
blanco macro
local paintBlanco
local paintB

push ax
push cx
push dx

mov cx, 1
paintBlanco:
push cx
mov cx, 1
paintB:
colorPixel dh, dl, white, 4
inc dl
loop paintB
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintBlanco

pop dx
pop cx
pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;________________((((((((((((crema)))))))))))))))))))_____________
crema macro
local paintCrema
local paintC

push ax
push cx
push dx

mov cx, 1;((((((((((((((Cambie el 2))))))))))))))))
paintCrema:
push cx
mov cx, 1;(((((((((((((Cambie el 4))))))))))))))))
paintC:
colorPixel dh, dl, yellow, 4
inc dl
loop paintC
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintCrema

pop dx
pop cx
pop ax
endm

;______________red_______-
rojo macro
local paintRed
local paintR

push ax
push cx
push dx

mov cx, 1;
paintRed:
push cx
mov cx, 1;
paintR:
colorPixel dh, dl, red, 4
inc dl
loop paintR
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintRed

pop dx
pop cx
pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;_______Macro Peach_____
peach macro
local paintPeach
local paintP

push ax
push cx
push dx

mov cx, 1
paintPeach:
push cx
mov cx, 1
paintP:
colorPixel dh, dl, brown, 4
inc dl
loop paintP
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintPeach

pop dx
pop cx
pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;_________Dibuja el bloque________
bloque macro
local paintBloq
local paintB

push ax
push cx
push dx

mov cx, 3
paintBloq:
push cx
mov cx, 5
paintB:
colorPixel dh, dl, brown, 4
inc dl
loop paintB
mov al, dh
pop cx
pop dx
push dx
inc al
mov dh, al
loop paintBloq

pop dx
pop cx
pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Este macro mueve la posicion actual de una imagen,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: Se escriben las coordenadas donde se va a dibujar en dx, dh es la fila y dl es la columna.

;Creado por Jaime 11 de noviembre de 2009

moveOb macro deltax, deltay, xpos, ypos, borrar, dummy, rebotes, height, widthh, bgType
	push ax
	push bx
	push cx
	
	mov cl, height
	mov ch, widthh
	moveD deltay, ypos
	
	;Aqui se debe verificar si se salio de la parte inferior o superior de la pantalla
	;checkCoordinatesnew xpos, ypos, 6, 4; 6 y 3 son el ancho y el largo de la imagen
	checkPixel deltay, ypos, 25, height, borrar, dummy, rebotes, bgType
	
	moveD deltax, xpos
	;Aqui se deber verificar si se salio de la parte derecha o izquierda de la pantalla
	checkPixel deltax, xpos, 79, widthh, borrar, dummy, rebotes, bgType
	pop cx
	pop bx
	pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

										
;Especifica que pixeles de video se tienen que borrar. Lo hace guardando esta informacion en una variable tipo array

;Precondiciones: N/A
;PostCondiciones: A erasePixel se le añaden las variables que representan las partes borradas y los backgrounds

;Parametros/Registros: borrar que es la variable que contiene el estado de borrar, meneco que contiene la imagen que se va a usar y bgType que contiene
;el tipo de variable de background que se va a escribir al mapa de borron. 

;Creado por Gabriel el 14 de octubre de 2009
 
setErasePixels macro borrar, muneco, bgType
        local dontDoAnything, noSetPixel, finished, writeBack2
        cmp borrar, 3; Si esta en el estado 3, el estado de flotar, simplemente sal del macro. 
	je dontDoAnything

	push ax; Guardar registros
	push cx
	    
        mov ah, white; Guardar valores originales de white y red 
        mov al, red
	mov ch, green
	
     
	cmp borrar, 1; Verificar si se encuentra en el estado 1, el estado de escribir backgrounds
        jnz noSetPixel
       
        cmp bgType, 1; Verificar el estado de bgType, si esta en 1 se escribe el segundo background
	je writeBack2    
        mov white, 0; Poner 0 el red y white para cuando se escriba el muneco en el mapa de borrar lo que alla es un hongo compuesto de 0s. 
        mov red, 0
	mov green, 0
	muneco 1; Escribir el hongo que consiste de 0s al mapa de borrar. 
        
	jmp finished

        writeBack2:; Escribir 2 al mapa de borrar en forma del muneco
	mov white, 2
	mov red, 2
	mov green, 2
	muneco 1

        jmp finished
        	
	noSetPixel:	
	mov white,1; Poner 1 el red y white para cuando se escriba el hongo en el mapa de borrar lo que alla es un muneco compuesto de 1s. 
        mov red, 1
	mov green, 1
	muneco 1; Escribir el muneco que consiste de 1s al mapa de borrar. 
        
        finished:
        mov white, ah; Restaurar white, red y green
        mov red, al
	mov green, ch

	pop cx; Restaurar registros
	pop ax

        dontDoAnything:

endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de un hongo a la variable render,

;Precondiciones: Utiliza las variables xpos y ypos para determinar con respecto a que localizacion va a crear la imagen.
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx guarda localmente las variables xpos y ypos para no alterar sus valores cuando se termine de ejecutar el macro.

;Creado por Jaime 11 de noviembre de 2009

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                                             
;Este macro dibuja una flor
flower macro location
local fwhite
local swhite
local twhite
local yello
local hoja
local verde

push ax
push bx
push cx
push dx

mov bx, 0
mov dh, ypos2
mov dl, xpos2
push dx
add xpos2, 1

mov cx, 3
fwhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop fwhite
add ypos2, 1

pop dx
mov xpos2, dl
push dx
mov cx, 5

swhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop swhite

;---yello---
pop dx
mov xpos2, dl
add xpos2, 1
push dx
mov cx, 3
yello:
colorpixel ypos2, xpos2, red, location
add xpos2, 1
loop yello


add ypos2,1

pop dx

mov xpos2, dl
push dx
add xpos2, 1
mov cx, 3

twhite:
colorpixel ypos2, xpos2, white, location
add xpos2, 1
loop twhite

pop dx





add ypos2, 1
mov xpos2, dl
;add xpos2,1
push dx
mov cx, 3

hoja:
colorpixel ypos2, xpos2, green, location
add xpos2, 2;
loop hoja
pop dx

add ypos2, 1
mov xpos2, dl
add xpos2,1
push dx
mov cx, 3

verde:
colorpixel ypos2, xpos2, green, location
add xpos2, 1
loop verde
pop dx


mov xpos2, dl
mov ypos2, dh

pop dx
pop cx
pop bx
pop ax

endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de una nube a la variable render,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx En este registro se guardan las coordenadas en donde se va a guardar la imagen. En dh se guarda la fila y en dl la columna

;Creado por Jaime 15 de octubre de 2009

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de una nube a la variable render,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx En este registro se guardan las coordenadas en donde se va a guardar la imagen. En dh se guarda la fila y en dl la columna

;Creado por Jaime 16 de octubre de 2009

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
		colorPixel dh, dl, Brown, 2
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Dibuja la imagen de un arbusto a la variable render,

;Precondiciones: N/A
;PostCondiciones N/A

;Parametros/Registros: 
;1-Dx En este registro se guardan las coordenadas en donde se va a guardar la imagen. En dh se guarda la fila y en dl la columna

;Creado por Jaime 16 de octubre de 2009

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Macro que verifica si el objeto debe comenzar a borrar la imagen o si debe escribir uno de los backgrounds

;Precondiciones: N/A
;PostCondiciones: Puede que se modifique el estado de borrar si es que hay un cambio de estado y dummy siempre va a cambiar. 
;Tambien se podria invertir el valorbgType si hay un cambio al estado 1.

;Parametros/Registros: borrar que es la variable que contiene el estado de borrar, dummy que es una variable temporera utilizada para 
;mantener cuenta de los estados, rebotes que es el numero de rebotes que debe hacer el objeto antes de cambiar de estado
;y bgType que contiene que contiene el tipo de background que se va a escribir al mapa de borron. 

;Creado por Gabriel el 14 de octubre de 2009

setErase macro borrar, dummy, rebotes, bgType
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
        jnz noSetErase; Si dummy no es cero salir del macro
		
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
        xor bgType,01h; Alternar bakgroundSelect
        
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Macro que utiliza como parametros la fila, columna y el color en el que se va a dibujar un pixel en video
colorPixel macro fila, columna, color, memoria
        ;Memoria 1 = Mapa de donde se va a borrar
        ;Memoria 2 = Memoria render, la memoria intermedia que despues se copia a la memoria de video
        ;Memoria 3 = Memoria de video
		;Memoria 4 = Memoria del segundo background

	local escribirABorron
        local escribirARender
        local escribirAVideo
        local terminado
		local escribirABackground2
		local erasePix
		
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
	cmp cx, 4
	je escribirABackground2
		

        escribirABorron: 
		call writeToBorron
        jmp terminado 

        escribirARender:
		call writeToRender
		jmp terminado

	escribirAVideo: 
		call writeToVideo
        jmp terminado
		
		escribirABackground2:
		call writeToBack2
		jmp terminado
	

        terminado:
	pop cx
	pop bx
	pop ax
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Cuando la imagen se sale de la pantalla, este macro la dibuja en el borde por donde se sali�.

;Precondiciones:
;Postcondiciones:

;Parametros:
;1-Delta: Se utiliza este parametro para verificar por donde se sali� la imagen y para mover esta otra vez a la pantalla.
;2-Pos: Este parametro indica la posicion actual de la imagen. Se utiliza para verificar si la imagen ya se encuentra dentro de la pantalla.
;3-Lengthh: Este parametro es el largo o ancho de la imagen. Se utiliza para verificar si la imagen ya se encuentra dentro de la pantalla luego de que se sale por la parte derecha o inferior de la pantalla.
;4-Border: Este parametro es el largo o ancho de la pantalla. Se utiliza para verificar si la imagen ya se encuentra dentro de la pantalla luego de que se sale por la parte derecha o inferior de la pantalla.
;5-Ax: Este registro guarda temporeramente el valor de delta.

;Creado por Jaime A. Torres el 12 de noviembre de 2009
goToEdge macro delta, pos, lengthh, border

	local loop1
	local rightOrBelow
	local loop2
	local exit
	push ax

	mov al, delta
	cmp delta, 0
	jg rightOrBelow
	
	mov delta, 1
	loop1:
		moveD delta, pos
		cmp pos, 0
		je exit
	jmp loop1
	
	rightOrBelow:
	mov delta, -1
	loop2:
		moveD delta, pos
		mov ah, pos
		add ah, lengthh
		cmp ah, border
		je exit
	jmp loop2
	
	exit:
	mov delta, al
	
	pop ax

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Macro que determina si el objeto se salio de la pantalla y le cambia la direccion para arreglarlo. (Creado por Jaime 24 de octubre de 2009)
checkPixel macro delta, pos, border, lengthh, borrar, dummy, rebotes, bgType

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
	
	goToedge delta, pos, lengthh, border
	changeDelta delta, pos, borrar, dummy, rebotes, bgType
	    
	  boundaryChecked:
	  pop ax

endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Macro que cambia direccion a la que se mueve el objeto. (Creado por Jaime 24 de octubre de 2009)
changeDelta macro delta, pos, borrar, dummy, rebotes, bgType
	neg delta
	setErase borrar, dummy, rebotes, bgType
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Programa simple que simula el movimiento de un objeto en una pantalla de video, usa deltax y deltay para determinar cuanto se mueve el objeto(Creado por Jaime el 13 de octubre de 2009)
main proc
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
	
	mov cx, 5000

	mov al, rebotes
	mov dummy, al

        mov al, rebotes2
        mov dummy2, al
      
        call background2
	
	again:
	setErasePixels borrar, mushroom, backgroundSelect1
        setErasePixels borrar2, flower, backgroundSelect2
	
	moveOb deltax, deltay, xpos, ypos, borrar, dummy, rebotes, 3, 5, backgroundSelect1 ;Actualiza las variables posx y posy para que el objeto se dibuje en una parte diferente
        moveOb deltax2, deltay2, xpos2, ypos2, borrar2, dummy2, rebotes2, 5, 4, backgroundSelect2
        
        call background; Dibjar background en "render"
        call eraser; borrar lo que alla que borrar
        mushroom 2; escribir hongo en "render"
        flower 2; escribir flower en "render"
               
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Subrutina que pasa la variable render a la memoria de video. 

;Precondiciones: N/A
;PostCondiciones: Modifica el contenido de la memoria de video. 

;Parametros/Registros: render, la variable que contiene lo que se va a copiar a la memoria de video. 

;Creado por Gabriel el 15 de octubre de 2009

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
         
	 pop cx; Restaurar los registros
         pop bx
         pop ax
	 ret
doRender endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Esta subrutina manipula la velocidad a la que va a correr el programa utilizando la variable delay(Creado por Jaime el 13 de octubre de 2009)
sleep proc
	push cx
	
	mov cx, delay
	sleepingag:
		push cx
		mov cx, 0afffh
		sleeping:
		loop sleeping
		pop cx
	loop sleepingag
	
	pop cx
	ret
sleep endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Verifica si el objeto se salio de la pantalla y si esto ocurre, cambia la direccion a la que se va a mover

;Borra la parte de la pantalla que se debe borrar luego de que el objeto rebota varias veces en la pantalla (Creado por Jaime el 14 de octubre de 2009)
eraser proc
	push ax
	push cx
	push bx
	
	mov cx, 2000
	mov bx, 0
	checkErase:
		cmp erasePixel[bx], 1 ; Verifica si se debe borrar el pixel apuntado por bx
		jnz CheckifDrawBack2 ;If el pixel no es cero, vuelve a iterar
		mov ax, 0h
		mov render[bx], al
		inc bx
		mov render[bx], ah
		dec bx
		jmp doNothing
		
		CheckifDrawBack2:
		cmp erasePixel[bx], 2
		jnz doNothing
		mov al, bowserCastle[bx]
		mov render[bx], al
		inc bx
		mov al, bowserCastle[bx]
		mov render[bx], al
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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
		mov ah, detailBrown
		mov al, 0b0h
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

	mov dh, 7
	mov dl, 14
	coin

	mov dh, 7
	mov dl, 13
	coin
		
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

	mov dh, 1
	mov dl, 37
	coin
	
	mov dh, 1
	mov dl, 38
	coin
	
	
	mov dh, 19
	mov dl, 5
	bush
	
	mov dh, 19
	mov dl, 60
	bush
		;Anadi goomba
	mov dh, 12
	mov dl, 51
	goomba
		;Se acabo
	
	pop dx
	pop dx
	pop cx
	pop bx
	pop ax
	ret
background endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

writeToBorron proc

	cmp ah, 1 ;Si es uno se borra, por lo tanto se debe cambiar el pixel independientemente del background que se utilice
	je erasePix		
		
	cmp erasePixel[bx], 1 ;Si el pixel en el que se va a escribir es uno, es que este espacio ya se borro y se le puede escribir encima con cualquiera de los dos backgrounds
	je erasePix
	jmp endWriteBorr
		
	erasePix:
	mov erasePixel[bx], ah; Escribir en la coordenada bx el color ah en la mapa de borron
	inc bx
	mov erasePixel[bx], ah; Repetir para el proximo byte
    endWriteBorr:
ret
writeToBorron endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


writeToRender proc

	mov render[bx], al; Escribir en la coordenada bx 0
	inc bx
	mov render[bx], ah; Escribir en el proximo byte el color ah

ret
writeToRender endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


writeToVideo proc
	escribirAVideo: mov es:[bx], ax; Pasar el byte entero a la memoria de video
ret
writeToVideo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

writeToBack2 proc
	mov bowserCastle[bx], al
        inc bx
	mov bowserCastle[bx], ah
	ret
writeToBack2 endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

background2 proc
push ax
push bx
push cx
push dx

	;Se agrego esta parte a la subrutina para que el la parte de atras del background no sea enteramente negra

	;Se termino modificacion

mov bx, 0
mov cx, 160
paintingGris:
mov ah, white
mov al, 0
inc bx
mov bowserCastle[bx], ah
inc bx
loop paintingGris

mov cx, 1280
paintingNegro:
mov ah, 04h
mov al, 0b0h
mov bowserCastle[bx], al
inc bx
mov bowserCastle[bx], ah
inc bx
loop paintingNegro

mov cx, 560
paintingLava:
mov ah, red
mov al, 0
inc bx
mov bowserCastle[bx], ah
inc bx
loop paintingLava




;___________(((((Bloques Gris))))))))_____________
mov dh, 0 ;fila
mov dl, 0 ;columna
block

mov dh, 16 ;fila
mov dl, 0 ; column
block

mov dh, 0 ;fila
mov dl, 76 ; columna ((en 80 no me la dibuja pq el bloque es de 4))))
block

mov dh, 16 ;fila
mov dl, 76 ; columna
block

;____________(((((((((koopa)))))))))_______________

mov dh, 6 
mov dl, 53 
Koopa
mov dh, 6 
mov dl, 54 
Koopa
mov dh, 7 
mov dl, 52 
Koopa
mov dh, 7 
mov dl, 53
Koopa
mov dh, 7 
mov dl, 55 
Koopa
mov dh, 7
mov dl, 56
Koopa
mov dh, 7
mov dl, 57
Koopa
mov dh, 8 
mov dl, 52
Koopa
mov dh, 8 
mov dl, 53
Koopa
mov dh, 8
mov dl, 54
Koopa
mov dh, 8
mov dl, 55
Koopa
mov dh, 8
mov dl, 56
Koopa
mov dh, 8 
mov dl, 57 
Koopa
mov dh, 9 
mov dl, 52 
Koopa
mov dh, 9 
mov dl, 53 
Koopa
mov dh, 9 
mov dl, 54 
Koopa
mov dh, 9 
mov dl, 55 
Koopa
mov dh, 9 
mov dl, 56 
koopa
mov dh, 10 
mov dl, 52 
koopa
mov dh, 10 
mov dl, 53 
koopa
mov dh, 11 
mov dl, 50 
koopa
mov dh, 11 
mov dl, 51 
koopa
mov dh, 11 ;fila
mov dl, 53 ; columna
koopa
mov dh, 12 ;fila
mov dl, 49 ; columna
koopa
mov dh, 12 ;fila
mov dl, 50 ; columna
koopa
mov dh, 12 ;fila
mov dl, 51 ; columna
koopa
mov dh, 12 ;fila
mov dl, 53 ; columna
koopa
mov dh, 13 ;fila
mov dl, 48 ; columna
koopa
mov dh, 13 ;fila
mov dl, 49 ; columna
koopa
mov dh, 13 ;fila
mov dl, 50 ; columna
koopa
mov dh, 14 ;fila
mov dl, 47 ; columna
koopa
mov dh, 14 ;fila
mov dl, 48 ; columna
koopa
mov dh, 14 ;fila
mov dl, 49 ; columna
koopa
mov dh, 14 ;fila
mov dl, 51 ; columna
koopa
mov dh, 14 ;fila
mov dl, 52 ; columna
koopa
mov dh, 15 ;fila
mov dl, 48 ; columna
koopa
mov dh, 15 ;fila
mov dl, 50 ; columna
koopa
mov dh, 15 ;fila
mov dl, 51 ; columna
koopa
mov dh, 15 ;fila
mov dl, 52 ; columna
koopa
mov dh, 16 ;fila
mov dl, 51 ; columna
koopa


;_______((((((((((puntitos blancos)))))))))))_________
mov dh, 6 
mov dl, 52 
blanco
mov dh, 7
mov dl, 54 
blanco
mov dh, 10 
mov dl, 51
blanco
mov dh, 11  
mov dl, 52
blanco
mov dh, 12 
mov dl, 52
blanco
mov dh, 13 
mov dl, 51 
blanco
mov dh, 14  
mov dl, 50 
blanco
mov dh, 15  
mov dl, 49 
blanco

;____________(((((((((((((puntitos crema))))))))))))))____________

mov dh, 10  
mov dl, 54
crema
mov dh, 10
mov dl, 55
crema
mov dh, 13 
mov dl, 52
crema
mov dh, 13 
mov dl, 53
crema
mov dh, 13  
mov dl, 54
crema
mov dh, 14  
mov dl, 53
crema
mov dh, 14   
mov dl, 54
crema
mov dh, 16  
mov dl, 49
crema
mov dh, 16  
mov dl, 50
crema
mov dh, 16 
mov dl, 52
crema
mov dh, 16 
mov dl, 53
crema
mov dh, 16 
mov dl, 54
crema
mov dh, 17 
mov dl, 48
crema
mov dh, 17 
mov dl, 49
crema
mov dh, 17  
mov dl, 50
crema
mov dh, 17  
mov dl, 51
crema



;___MARIO____(parece un lego)
mov dh,5  
mov dl,15 
blanco
mov dh,5  
mov dl,16 
blanco
mov dh,5  
mov dl,17 
blanco
mov dh,5  
mov dl,18
blanco
mov dh,5  
mov dl,19 
blanco
mov dh,6 
mov dl,14 
blanco
mov dh,6 
mov dl,15 
blanco
mov dh,6 
mov dl,16 
blanco
mov dh,6 
mov dl,17 
blanco
mov dh,6 
mov dl,18 
blanco
mov dh,6 
mov dl,19 
blanco
mov dh,6 
mov dl,20
blanco
mov dh, 10
mov dl, 15
blanco
mov dh, 10
mov dl, 16
blanco
mov dh, 10
mov dl, 18
blanco
mov dh, 10
mov dl, 19
blanco
mov dh, 11
mov dl, 15
blanco
mov dh, 11
mov dl, 16
blanco
mov dh, 11
mov dl, 17
blanco
mov dh, 11
mov dl, 18
blanco
mov dh, 11
mov dl, 19
blanco
mov dh, 12
mov dl, 15
blanco
mov dh, 12
mov dl, 16
blanco
mov dh, 12
mov dl, 17
blanco
mov dh, 12
mov dl, 18
blanco
mov dh, 12
mov dl, 19
blanco
mov dh, 13
mov dl, 15
blanco
mov dh, 13
mov dl, 16
blanco
mov dh, 13
mov dl, 17
blanco
mov dh, 13
mov dl, 18
blanco
mov dh, 13
mov dl, 19
blanco
mov dh, 14
mov dl, 15
blanco
mov dh, 14
mov dl, 16
blanco
mov dh, 14
mov dl, 18
blanco
mov dh, 14
mov dl, 19
blanco


mov dh, 6
mov dl, 17
rojo
mov dh, 10
mov dl, 14
rojo
mov dh, 10
mov dl, 17
rojo
mov dh, 10
mov dl, 20
rojo
mov dh, 11
mov dl, 14
rojo
mov dh, 11
mov dl, 20
rojo
mov dh, 15
mov dl, 15
rojo
mov dh, 15
mov dl, 16
rojo
mov dh, 15
mov dl, 18
rojo
mov dh, 15
mov dl, 19
rojo

mov dh, 7
mov dl, 15
peach
mov dh, 7
mov dl, 17
peach
mov dh, 7
mov dl, 19
peach
mov dh, 8
mov dl, 15
peach
mov dh, 8
mov dl, 16
peach
mov dh, 8
mov dl, 17
peach
mov dh, 8
mov dl, 18
peach
mov dh, 8
mov dl, 19
peach
mov dh, 9
mov dl, 17
peach
mov dh, 12
mov dl, 14
peach
mov dh, 12
mov dl, 20
peach
mov dh, 16
mov dl, 4
peach
mov dh, 16
mov dl, 5
peach
mov dh, 16
mov dl, 6
peach
mov dh, 16
mov dl, 7
peach
mov dh, 16
mov dl, 8
peach
mov dh, 16
mov dl, 9
peach
mov dh, 16
mov dl, 10
peach
mov dh, 16
mov dl, 11
peach
mov dh, 16
mov dl, 12
peach
mov dh, 16
mov dl, 13
peach
mov dh, 16
mov dl, 14
peach
mov dh, 16
mov dl, 15
peach
mov dh, 16
mov dl, 16
peach
mov dh, 16
mov dl, 17
peach
mov dh, 16
mov dl, 18
peach
mov dh, 16
mov dl, 19
peach
mov dh, 16
mov dl, 20
peach
mov dh, 16
mov dl, 21
peach
mov dh, 16
mov dl, 22
peach
mov dh, 16
mov dl, 23
peach
mov dh, 16
mov dl, 24
peach
mov dh, 16
mov dl, 25
peach



;flor
mov dh, 5
mov dl, 33
blanco
mov dh, 5  
mov dl, 34
blanco
mov dh, 5  
mov dl, 35
blanco 
mov dh, 6  
mov dl, 32
blanco
mov dh, 6  
mov dl, 36
blanco
mov dh, 7  
mov dl, 33
blanco
mov dh, 7
mov dl, 34
blanco
mov dh, 7
mov dl, 35
blanco
mov dh, 6  
mov dl, 33
crema
mov dh, 6
mov dl, 34
crema
mov dh, 6
mov dl, 35
crema
mov dh, 8
mov dl, 32
koopa
mov dh, 8
mov dl, 34
koopa
mov dh, 8
mov dl, 36
koopa
mov dh, 9
mov dl, 33
koopa
mov dh, 9
mov dl, 34
koopa
mov dh, 9
mov dl, 35
koopa

mov dh, 10
mov dl, 32
bloque

pop dx
pop cx
pop bx
pop ax
ret
background2 endp		

end main
	
