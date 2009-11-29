Title Prueba de sonido
.model small
.stack 100h
.data
marca db '>>>>'
delay dw 0ffh

;Notes
noteC db 65
noteCsharp db 69
noteD db 73
noteDsharp db 78
noteE db 82
noteF db 87
noteFsharp db 92
noteG db 98
noteGsharp db 104
noteA db 110
noteAsharp db 116
noteB  db 123

;variable para guardar una nota
note db ?

;captured character
character db ?

.code

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

keyboardToNote macro charAscii, note
local caseQ, caseW, caseE, caseR, exit
push bx

cmp charAscii, 'q'
je caseQ

cmp charAscii, 'w'
je caseW

cmp charAscii, 'e'
je caseE

cmp charAscii, 'r'
je caseR

caseQ:
mov bl, noteC
mov note, bl
jmp exit

caseW:
mov bl, noteD
mov note, bl
jmp exit

caseE:
mov bl, noteE
mov note, bl
jmp exit

caseR:
mov bl, noteF
mov note, bl
jmp exit

exit:
pop bx

endm

setNote macro note
  push ax

  ;tell timer 2 that we want to modify the count down  
  ;send value 0B6h to port 43h
  mov al, 0B6h
  out 43h, al

  ;send the value of the new count down low byte first high byte last
  ;important that this is done as quickly as possible

  mov al, note
  ;send low byte to port 42h
  out 42h, al
  ;send high byte to port 42h
  mov al, 0
  out 42h, al

  pop ax
endm

main proc 

  mov ax, @data
  mov ds, ax

  mov cx, 1000


  mainLoop:

  ;leer del teclado
  mov ah, 8
  mov dl, 0ffh
  jz readChar
  
  ;no char in buffer, set to inaudible frequency
  mov al, 0
  jmp inaudible

  readChar:
  mov character, al
  keyboardToNote character, note

  inaudible:
  setNote note

  call startSpeaker
  call sleep
  call stopSpeaker
  call clearBuffer

  loop mainLoop

 
  ;stop program
  mov ax, 4c00h
  int 21h

main endp


end main
