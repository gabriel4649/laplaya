
checkCoordinates macro x, y
  local imageAtBorder
  local boundaryChecked
  cmp x,0
  jl imageAtBorder; if x is negative
  cmp x,80
  jg imageAtBorder; if x is bigger 
  
  cmp y,0
  jl imageAtBorder; if y is negative
  cmp y,25
  jg imageAtBorder; if y is bigger than 25

  jmp boundaryChecked
  imageAtBorder: call changeDirection
  boundaryChecked: ret
endm

changeDirection proc
  push ax
  ;How direction will be changed
  ;incoming | outgoing
  ;x y | x -y
  ;x -y| -x -y;
  ;-x y| x y;
  ;-x-y| x -y;

  push ax  

  cmp deltax,0 
  jl caseB; if is negative
   
  cmp deltay,0
  jl caseB; if is negative
  
  jmp caseA

  caseA:
    neg deltay
    moveD deltay, ypos
    moveD deltay, ypos
    jmp changedDirection

  caseB:
    neg deltax
    moveD deltax, xpos
    moveD deltax, xpos
    jmp changedDirection

  changedDirection: pop ax 
                    ret
changeDirection endp

updateImage proc
 push dx; safeguard dx
 push cx; safeguard cx
 mov dh,0; dh will be used as the width index
 mov dl,0; dl will be used as the height index
 mov cx,80; 80 is the width of the screen
 outerLoop:
  push cx
  mov cx,25; 25 is the height of the screen
  innerLoop:
    inc dl
    coordenadas dl, dh
    cmp es:[bx],0; Verify if it contains a pixel
    jg updatePixel; If it contains a pixel update it
    jmp finished
    updatePixel: checkCoordinates dh, dl
                 sum dh,deltax
                 sum dl,deltay 
                 push ax; safeguard ax
                 mov bx,ax; save original coordinates               
                 coordenadas dl, dh; get new coordinates
                 mov es:[bx],es:[ax]; move pixel
                 mov es:[ax],0; delete old pixel
                 pop ax; restore ax		    
    finished: loop innerLoop
    pop cx
    inc dh
  loop outerLoop
 pop cx; restore cx
 pop dx; restore dx
 ret
updateImage endp

  