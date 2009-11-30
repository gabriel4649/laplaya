Title Prueba de sonido
.model small
.stack 100h
.data
marca db '>>>>'
delay dw 00ffh

;Notes
noteC dw 262
noteCsharp dw 277
noteD dw 294
noteDsharp dw 311
noteE dw 330
noteF dw 349
noteFsharp dw 370
noteG dw 392
noteGsharp dw 415
noteA dw 440
noteAsharp dw 466
noteB  dw 494
silence dw 2

;variable para guardar una nota
note dw 1

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

        ;xor     al, 3                  
       ; out     61h, al                 ; turn off speaker
       ; mov     cx, 0af0h
    
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

keyboardToNote macro charAscii, note
local caseQ, caseW, caseE, caseR, exit
push bx

cmp charAscii, 'q'
je caseQ

cmp charAscii, '2'
je case2

cmp charAscii, 'w'
je caseW

cmp charAscii, '3'
je case3

cmp charAscii, 'e'
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

;mov bx, silence
;mov note, bx
;jmp exit

caseQ:
mov bx, noteC
mov note, bx
jmp exit

case2:
mov bx, noteCsharp
mov note, bx
jmp exit

caseW:
mov bx, noteD
mov note, bx
jmp exit

case3:
mov bx, noteDsharp
mov note, bx
jmp exit

caseE:
mov bx, noteE
mov note, bx
jmp exit

caseR:
mov bx, noteF
mov note, bx
jmp exit

case5:
mov bx, noteFsharp
mov note, bx
jmp exit

caseT:
mov bx, noteG
mov note, bx
jmp exit

case6:
mov bx, noteGsharp
mov note, bx
jmp exit

caseY:
mov bx, noteA
mov note, bx
jmp exit

case7:
mov bx, noteAsharp
mov note, bx
jmp exit

caseU:
mov bx, noteB
mov note, bx
jmp exit

exit:
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
  mov bx, ax
  mov al, bh
  out 42h, al

  pop bx
  pop ax
endm

main proc 

  mov ax, @data
  mov ds, ax

  mainLoop:

  tryAgain:  
      mov ah, 6
      mov dl, 0FFh
      int 21h
      jz tryAgain

  mov character, al
  keyboardToNote character, note

  ;print char
  mov ah, 02h
  mov dl, al
  int 21h

 
  ;setNote note
  testMacro
  ;call startSpeaker
  ;call sleep
  ;call stopSpeaker
  
  ;inaudible:
  ;call clearBuffer
  jmp mainLoop

 
  ;stop program
  mov ax, 4c00h
  int 21h

main endp


end main
