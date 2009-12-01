Title Prueba de sonido
.model small
.stack 100h
.data
marca db '>>>>'
delay dw 00ffh

;Notes

hNoteC dw 523
hNoteCSharp dw 554
hNoteD dw 587
hNoteDSharp dw 622
hNoteE dw 659

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

lNoteC dw 131  
lNoteCSharp dw 139
lNoteD dw 147 
lNoteDSharp dw 155  
lNoteE dw 165  
lNoteF dw 175  
lNoteFSharp dw 185 
lNoteG dw 196  
lNoteGSharp dw 208  
lNoteA dw 220  
lNoteASharp dw 233  
lNoteB dw 245  

silence dw 1

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
jmp exit

caseS:
mov bx, lNoteCSharp
mov note, bx
jmp exit

caseX:
mov bx, lNoteD
mov note, bx
jmp exit

caseD:
mov bx, lNoteDSharp
mov note, bx
jmp exit

caseC:
mov bx, lNoteE
mov note, bx
jmp exit

caseV:
mov bx, lNoteF
mov note, bx
jmp exit

caseG:
mov bx, lNoteFSharp
mov note, bx
jmp exit

caseB:
mov bx, lNoteG
mov note, bx
jmp exit

caseH:
mov bx, lNoteGSharp
mov note, bx
jmp exit

caseN:
mov bx, lNoteA
mov note, bx
jmp exit

caseJ:
mov bx, lNoteASharp
mov note, bx
jmp exit

caseM:
mov bx, lNoteB
mov note, bx
jmp exit

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

caseI:
mov bx, hNoteC
mov note, bx
jmp exit

case9:
mov bx, hNoteCSharp
mov note, bx
jmp exit

caseO:
mov bx, hNoteD
mov note,bx
jmp exit

case0:
mov bx, hNoteDSharp
mov note, bx
jmp exit

caseP:
mov bx, hNoteE
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

  ;tryAgain:  
      mov ah, 6
      mov dl, 0FFh
      int 21h
      
  jnz continue

  call stopSpeaker 
  continue:

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
