;Este Programa dibuja un piano

title MicroPiano
.Model Small
.stack 100h
.data
	color db 0
	blanco db 15
	negro db 0
	crema db 6
	amarillo db 14
	azul db 1

        filehandle dw 0
        bytesread dw 0
        filename db "prueba.bmp0"
        buffer db 3200 dup (0)
        imagex dw 0
        imagey dw 0
        

	
	ycoord dw 10
	xcoord dw 35
	
	anchoBlanca dw 15
	;LargoBlanca = 3*anchoBlanca
	largoBlanca dw 48
	
	anchoNegra dw ?
	largoNegra dw ?
	xpiano dw 20
	ypiano dw 30

	largoIl dw ?
	yIl dw ?
	ilumWhite db 17 dup(0)
	ilumBlack db 12 dup(0)
	
	delay dw 03ffh

;       Octave 0    1    2    3    4    5    6    7
; 	Note
; 	 C     16   33   65  131  262  523 1046 2093
; 	 C#    17   35   69  139  277  554 1109 2217
; 	 D     18   37   73  147  294  587 1175 2349
; 	 D#    19   39   78  155  311  622 1244 2489
; 	 E     21   41   82  165  330  659 1328 2637
; 	 F     22   44   87  175  349  698 1397 2794
; 	 F#    23   46   92  185  370  740 1480 2960
; 	 G     24   49   98  196  392  784 1568 3136
; 	 G#    26   52  104  208  415  831 1661 3322
; 	 A     27   55  110  220  440  880 1760 3520
; 	 A#    29   58  116  233  466  932 1865 3729
; 	 B     31   62  123  245  494  988 1975 3951


	;Notes
	hNoteC dw 659
	hNoteCSharp dw 622
	hNoteD dw 587 
	hNoteDSharp dw 554
	hNoteE dw 523

	noteC dw 1975
	noteCsharp dw 1865
	noteD dw 1760
	noteDsharp dw 1661
	noteE dw 1568
	noteF dw 1480
	noteFsharp dw 1397
	noteG dw 1328
	noteGsharp dw 1244
	noteA dw 1175
	noteAsharp dw 1109
	noteB  dw 1046

	lNoteC dw 3951
	lNoteCSharp dw 3729
	lNoteD dw 3520
	lNoteDSharp dw 3322
	lNoteE dw 3136
	lNoteF dw 2960
	lNoteFSharp dw 2794
	lNoteG dw 2637
	lNoteGSharp dw 2489
	lNoteA dw 2349
	lNoteASharp dw 2217
	lNoteB dw 2093

	silence dw 1

	;variable para guardar una nota
	note dw 1

	;captured character
	character db ?
.code

drawKey macro x:Req, y:Req, color:Req, ancho:Req, largo:Req
local drawingKey
push di
push cx
push bx

mov di, ancho
add di, x
mov cx, largo
mov bx, y

drawingKey:
	mDrawHorizontalLine x, di, y, color
	inc y
loop drawingKey

mov y, bx
pop bx
pop cx
pop di	
endm

loopX macro labell:Req

	local away
	local finish
	loop away
	jmp finish
	away:
	jmp labell
	finish:

endm

mSetVideoMode Macro mode:Req, dispPage:Req
;Establece el modo gr?fico deseado indicando qu?
;p?gina se utilizar?.
        push ax
        mov ah,0
        mov al,mode
        int 10h
        mov ah,5
        mov al,dispPage
        int 10h
        pop ax
        endm
        
mGoToTextMode Macro
;Regresa el video a su modo 3 que corresponde a
;modo de texto 80 x 25 x 256
        push ax
        mov ah,0
        mov al,3
        int 10h
        pop ax
        endm


mPutPixel Macro color:Req, vidPage:Req, x:Req, y:Req
;Despliega un pixel en la pantalla en las coordenadas
;(x,y) con el color indicado en la p?gina indicada
        push ax
        push bx
        push cx
        push dx
        
        mov ah,0ch
        mov al,color
        mov bh,vidPage
        mov cx,x
        mov dx,y
        int 10h
        
        pop  dx
        pop  cx
        pop  bx
        pop  ax
        endm

mClearScreen Macro
;Borra el contenido de la pantalla en modo gr?fico
        push ax
        mov ah,06H
        mov al,0
        int 10h
        pop  ax
        endm

mWait   Macro factor:Req
;Para implementar retrasos en el programa
;El valor en factor causa que el retraso sea mayor o menor.
;Mientras mayor sea el valor mayor es el retraso.  Una excepci?n
;es el uso del 0.  ?ste valor causa el m?ximo retraso.
local inner
local outter
local middle
        push cx
        
        mov cx,factor
outter:
            push cx 
            mov cx, 2000
middle:
                push cx
                mov cx,2000
inner:
                loop inner
                pop cx
            loop middle
            pop cx
        loop outter
        
        pop  cx
        endm

mPutPixelMode13H Macro color:Req, x:Req, y:Req
;Despliega un pixel en la pantalla asumiendo que se est?
;en el modo gr?fico 13H y escribiendo directamente a la
;memoria de video
        push ax
        push bx
        push si
        push es
	push dx
        
        mov ax,0A000H
        mov es,ax
        mov ax,y
        mov bx,320
        mul bx
        add ax,x
        mov si,ax
	mov dl, color
        mov es:[si],dl

	pop dx
        pop es
        pop si
        pop  bx
        pop  ax
endm



mDrawHorizontalLine Macro x0:Req, x1:Req, y:Req, color:Req
;Dibuja una linea horizontal entre las coordenadas (x0,y) y (x1,y)
;Hace uso del macro mPutPixelMode13H
        local inOrder, nextPixel
        push ax
        push cx
        push si
        mov si,x0
        mov ax,x1
        cmp si,ax
        jle inOrder
        xchg ax,si
inOrder:
        mov cx,ax
        sub cx,si
nextPixel:        
            mPutPixelMode13H color,si,y
            inc si
        loop nextPixel
        pop si
        pop cx
        pop ax
        endm
mDispChar macro char:Req, pageNum:Req, attributes:Req, repetitions:Req
        push ax
        push bx
        push cx

        mov ah,09H
        mov al,char
        mov bh,pageNum
        mov bl,attributes
        mov cx,repetitions
        int 10h

        pop cx
        pop bx
        pop ax
        endm

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

testMacro macro

	push dx
	push bx
	push ax

        mov     al, 0b6h                ; set 8253 command register
        out     43h, al                 ; for channel 2, mode 3

        mov     ax, 34dch               ; low part of clock freq.
        mov     dx, 12h                 ; hight part of clock freq.
        div     note      ; get note from data segment
        out     42h, al                 ; 8253 command register (low byte)
        mov     al, ah
        out     42h, al                 ; 8253 command regsieter (high byte)

        ; turn on low bits in 8255 output port

        in      al, 61h                 ; read current value of 8255 port
        or      al, 3                   ; clear low bits
        out     61h, al                 ; send new value to port
   

        call sleep

        ; turn off speaker, check note count, set up next note

        xor     al, 3                  
        ;out     61h, al                 ; turn off speaker
        mov     cx, 0af0h
    
	pop ax
	pop bx
	pop dx
endm

clearBuffer proc
  push ax
  push dx

next:
  mov ah,6
  mov dl,0ffh
  int 21h
  jnz next
  pop dx
  pop ax
  ret
clearBuffer endp

stopSpeaker proc
  push ax
  ;stop the speaker by disconnecting it from timer 2 (clear bits 0&1)
  in al,061h
  and al,0FCh ;clear bits 0&1
  out 061h, al
  pop ax
  ret
stopSpeaker endp

startSpeaker proc
  push ax
 
  ;connect speaker to timer 2 by setting bits 0&1
  in al,061h
  or al,3 ; set bits 0&1 to connect to timer 2
  ;send value to port 61h
  out 061h, al
  pop ax
  ret
startSpeaker endp

turnOnIlum macro ilum:Req, displacement:req
	push bx

	mov bx, 0
	mov bx, displacement
	mov ilum[bx], 1

	pop bx
endm

macro charAscii, note
	local caseZ
	local caseS
	local caseX
	local caseD
	local caseC
	local caseV
	local caseG
	local caseB
	local caseH
	local caseN
	local caseJ
	local caseM
	local caseQ
	local case2
	local caseW
	local caseE
	local caseR
	local case5
	local caseT
	local case6
	local caseY
	local case7
	local caseU
	local caseI
	local case9
	local caseO
	local case0
	local caseP
	local exit
	push bx
	push si

	cmp charAscii, 'z'
	je caseZ

	cmp charAscii, 's'
	je caseS

	cmp charAscii, 'x'
	je caseX

	cmp charAscii, 'd'
	je caseD

	cmp charAscii, 'c'
	je caseC

	cmp charAscii, 'v'
	je caseV

	cmp charAscii, 'g'
	je caseG

	cmp charAscii, 'b'
	je caseB

	cmp charAscii, 'h'
	je caseH

	cmp charAscii, 'n'
	je caseN

	cmp charAscii, 'j'
	je caseJ

	cmp charAscii, 'm'
	je caseM

	cmp charAscii, 'q'
	je caseQ
	cmp charAscii, ','
	je caseQ

	cmp charAscii, '2'
	je case2
	cmp charAscii, 'l'
	je case2

	cmp charAscii, 'w'
	je caseW
	cmp charAscii, '.'
	je caseW

	cmp charAscii, '3'
	je case3
	cmp charAscii, ':'

	cmp charAscii, 'e'
	je caseE
	cmp charAscii, '/'
	je caseE

	cmp charAscii, 'r'
	je caseR

	cmp charAscii, '5'
	je case5

	cmp charAscii, 't'
	je caseT

	cmp charAscii, '6'
	je case6

	cmp charAscii, 'y'
	je caseY

	cmp charAscii, '7'
	je case7

	cmp charAscii, 'u'
	je caseU

	cmp charAscii, 'i'
	je caseI

	cmp charAscii, '9'
	je case9

	cmp charAscii, 'o'
	je caseO

	cmp charAscii, '0'
	je case0

	cmp charAscii, 'p'
	je caseP

	mov bx, silence
	mov note, bx
	jmp exit

	caseZ:
	mov bx, lNoteC
	mov note, bx
	turnOnIlum ilumWhite, 0
	jmp exit

	caseS:
	mov bx, lNoteCSharp
	mov note, bx
	turnOnIlum ilumBlack, 0
	jmp exit

	caseX:
	mov bx, lNoteD
	mov note, bx
	turnOnIlum ilumWhite, 1
	jmp exit

	caseD:
	mov bx, lNoteDSharp
	mov note, bx
	turnOnIlum ilumBlack, 1
	jmp exit

	caseC:
	mov bx, lNoteE
	mov note, bx
	turnOnIlum ilumWhite, 2
	jmp exit

	caseV:
	mov bx, lNoteF
	mov note, bx
	turnOnIlum ilumWhite, 3
	jmp exit

	caseG:
	mov bx, lNoteFSharp
	mov note, bx
	turnOnIlum ilumBlack, 2
	jmp exit

	caseB:
	mov bx, lNoteG
	mov note, bx
	turnOnIlum ilumWhite, 4
	jmp exit

	caseH:
	mov bx, lNoteGSharp
	mov note, bx
	turnOnIlum ilumBlack, 3
	jmp exit

	caseN:
	mov bx, lNoteA
	mov note, bx
	turnOnIlum ilumWhite, 5
	jmp exit

	caseJ:
	mov bx, lNoteASharp
	mov note, bx
	turnOnIlum ilumBlack, 4
	jmp exit

	caseM:
	mov bx, lNoteB
	mov note, bx
	turnOnIlum ilumWhite, 6
	jmp exit

	caseQ:
	mov bx, noteC
	mov note, bx
	turnOnIlum ilumWhite, 7
	jmp exit

	case2:
	mov bx, noteCsharp
	mov note, bx
	turnOnIlum ilumBlack, 5
	jmp exit

	caseW:
	mov bx, noteD
	mov note, bx
	turnOnIlum ilumWhite, 8
	jmp exit

	case3:
	mov bx, noteDsharp
	mov note, bx
	turnOnIlum ilumBlack, 6
	jmp exit

	caseE:
	mov bx, noteE
	mov note, bx
	turnOnIlum ilumWhite, 9
	jmp exit

	caseR:
	mov bx, noteF
	mov note, bx
	turnOnIlum ilumWhite, 10
	jmp exit

	case5:
	mov bx, noteFsharp
	mov note, bx
	turnOnIlum ilumBlack, 7
	jmp exit

	caseT:
	mov bx, noteG
	mov note, bx
	turnOnIlum ilumWhite, 11
	jmp exit

	case6:
	mov bx, noteGsharp
	mov note, bx
	turnOnIlum ilumBlack, 8
	jmp exit

	caseY:
	mov bx, noteA
	mov note, bx
	turnOnIlum ilumWhite, 12
	jmp exit

	case7:
	mov bx, noteAsharp
	mov note, bx
	turnOnIlum ilumBlack, 9
	jmp exit

	caseU:
	mov bx, noteB
	mov note, bx
	turnOnIlum ilumWhite, 13
	jmp exit

	caseI:
	mov bx, hNoteC
	mov note, bx
	turnOnIlum ilumWhite, 14
	jmp exit

	case9:
	mov bx, hNoteCSharp
	mov note, bx
	turnOnIlum ilumBlack, 10
	jmp exit

	caseO:
	mov bx, hNoteD
	mov note,bx
	turnOnIlum ilumWhite, 15
	jmp exit

	case0:
	mov bx, hNoteDSharp
	mov note, bx
	turnOnIlum ilumBlack, 11
	jmp exit

	caseP:
	mov bx, hNoteE
	mov note, bx
	turnOnIlum ilumWhite, 16
	jmp exit


	exit:
	pop si
	pop bx

endm


setNote macro note
	push ax
	push bx

	;tell timer 2 that we want to modify the count down  
	;send value 0B6h to port 43h
	mov al, 0B6h
	out 43h, al

	;send the value of the new count down low byte first high byte last
	;important that this is done as quickly as possible

	mov ax, note
	;send low byte to port 42h
	out 42h, al
	;send high byte to port 42h
	mov al, ah
	out 42h, al

	pop bx
	pop ax
endm


main proc
;muestra ejemplos de las llamadas a los macros
        mov ax,@data
        mov ds,ax

        mSetVideoMode 13H,00D
        mClearScreen
	call drawPiano

        ; open file
        lea dx, filename
        mov ah, 3Dh
        mov al, 0
        int 21h
        mov filehandle, ax

        ; read file
	mov ah, 3fh
        mov bx, filehandle
        lea dx, buffer
        ;number of bytes
        mov cx, 3200
        int 21h

        ;write image
        mov bx, 0
        mov cx, 320
        write:
         push cx
         mov cx, 100
         innerLoop:
          mPutPixelMode13H buffer[bx], imagex, imagey
          inc imagex
          loop innerLoop
         inc imagey
         pop cx
         loop write
         
        
        

	mainLoop:
	mov ah, 3fh

	mov ah, 6
	mov dl, 0FFh
	int 21h
	jz noInput

	continue:
	call clearBuffer
	mov character, al
	keyboardToNote character, note

	setNote note
	call startSpeaker
	noInput:
	call iluminateWhitePiano
	call sleep
	
	call clearIlum
	call stopSpeaker
	
	jmp mainLoop

        
        ;mWait 5
        mGoToTextMode        

        mov ah,4ch
        int 21h
main    endp


;Esta subrutina dibuja un piano.
drawPiano proc
	push ax
	push bx
	push cx
	push dx
	
	mov dx, 0
	mov ax, xpiano
	mov cx, 17

	drawingWhitePianoKeys:
		drawKey xpiano, ypiano, blanco, anchoBlanca, largoBlanca
		;xpiano += anchoBlanca
		mov bx, anchoBlanca
		add xpiano, bx
		inc xpiano
	loop drawingWhitePianoKeys

	mov xpiano, ax
	push ax

	;Esta parte del codigo se lleva a cabo para calcular la posicion en la que se va a empezar a dibujar las teclas negras.
	;Estas van a ser dibujadas a un desplazamiento de la posicion inicial de 3/4 partes el ancho de la tecla blanca 
	mov ax, anchoBlanca
	inc ax
	mov anchoNegra, 3
	mov dx, 0
	mul anchoNegra
	mov dx, 0
	mov anchoNegra, 4
	div anchoNegra
	add xpiano, ax

	mov ax, anchoBlanca
	inc ax
	shr ax, 1
	mov anchoNegra, ax

	mov ax, largoBlanca
	shr ax, 1
	mov LargoNegra, ax
	
	mov cx, 2
	drawingAllBlackPianoKeys:
		push cx
		
		mov cx, 2
		drawingBlackPianoKeys1:
			drawKey xpiano, ypiano, crema, anchoNegra, largoNegra
			;xpiano += anchoBlanca
			mov bx, anchoNegra
			add xpiano, bx
			add xpiano, bx
			;inc xpiano
		loopX drawingBlackPianoKeys1
		
		;Estas lineas dejan un espacio de una tecla blanca.
		mov cx, 2
		addingMultiple:
		mov bx, anchoNegra
		add xpiano, bx
		loop addingMultiple
		
		mov cx, 3
		drawingBlackPianoKeys2:
			drawKey xpiano, ypiano, crema, anchoNegra, largoNegra
			;xpiano += anchoBlanca
			mov bx, anchoNegra
			add xpiano, bx
			add xpiano, bx
			;inc xpiano
		loopX drawingBlackPianoKeys2
		
		mov cx, 2
		addingMultiple2:
		mov bx, anchoNegra
		add xpiano, bx
		loop addingMultiple2
	
		pop cx
	loopX drawingAllBlackPianoKeys
	
	
	mov cx, 2
	drawingBlackPianoKeys3:
		drawKey xpiano, ypiano, crema, anchoNegra, largoNegra
		;xpiano += anchoBlanca
		mov bx, anchoNegra
		add xpiano, bx
		add xpiano, bx
	loopX drawingBlackPianoKeys3	

	
	
	pop ax
	mov xpiano, ax

	pop dx
	pop cx
	pop bx
	pop ax
	ret							
drawPiano endp

iluminateWhitePiano proc
	push ax	
	push bx
	push cx
	push dx
	
	mov ax, xpiano
	push ax
	
	mov ax, largoBlanca
	shr ax, 1
	mov largoIl, ax
	mov ax, ypiano
	mov yIl, ax
	mov ax, largoIl
	add yIl, ax	

	mov bx, 0

	mov cx, 17

	IlumWhitePianoKeys:
		cmp ilumWhite[bx], 1
		jne noIlum
		drawkey xpiano, yIl, amarillo, anchoBlanca, LargoIl
		jmp anotherOne
		
		noIlum:
		drawKey xpiano, yIl, blanco, anchoBlanca, LargoIl
		anotherOne:
		;xpiano += anchoBlanca
		mov dx, anchoBlanca
		add xpiano, dx
		inc xpiano
		inc bx
	loopX IlumWhitePianoKeys

	pop ax
	mov xpiano, ax
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
iluminateWhitePiano endp

clearIlum proc
	push cx
	push bx

	mov bx, 0
	
	mov cx, 17
	clearing:
	mov ilumWhite[bx], 0
	inc bx
	loop clearing	
	
	pop bx
	pop cx
	ret
clearIlum endp

end main

