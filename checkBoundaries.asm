;Check if the coordinates are withing the screen boundaries
checkCoordinates macro x, y
  ;   __4__
  ;  |     |
  ;1 |_____| 3
  ;     2
  local imageAtBorder
  local boundaryChecked

  border; variable
  
  cmp x,0
  mov border,1
  jl imageAtBorder; if x is negative


  cmp x,80
  mov border,3
  jg imageAtBorder; if x is bigger 
  
  cmp y,0
  mov border,4
  jl imageAtBorder; if y is negative

  cmp y,25
  mov border,2
  jg imageAtBorder; if y is bigger than 25

  jmp boundaryChecked
  imageAtBorder: call changeDirection border
  boundaryChecked: ret
endm

;Changes a moving object's direction
changeDirection macro case
  ;How direction will be changed
  ;incoming | outgoing
  ;          case
  ;        2      3
  ;x y | x -y o -x y
  ;        3      4
  ;x -y| -x -y o x y
  ;        1      2 
  ;-x y| x y o -x -y
  ;        1      4 
  ;-x-y| x -y o -x y

  push ax  

  cmp deltax,0 
  jl deltaXNegative; if is negative
   
  cmp deltay,0
  jl deltaYNegative; if is negative

  jmp bothPositive
  
  deltaYNegative: ; x -y
    cmp case,3
    je caseA; case 3
    jmp caseB; case 4

  deltaXNegative:
    cmp deltay,0
    jl bothNegative; if is negative
    cmp case,1; -x y
    je caseA; case 1
    jmp caseB; case 2

   bothNegative: ; -x -y
    cmp case,1
    je caseA; case 1
    jmp caseB; case 4

   bothPositive: ; x y
    cmp case,2
    je caseB; case 2
    jmp caseA; case 3

   
  caseA: neg deltax
         jmp changedDirection
  caseB: neg deltay 
         jmp changedDirection


  changedDirection: pop ax 
                    ret
changeDirection endp

;Updates the moving object location
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
    inc dl; increment y coordinate
    coordenadas dl, dh
    cmp es:[bx],0; Verify if it contains a pixel
    jg updatePixel; If it contains a pixel update it
    jmp finished
    updatePixel: checkCoordinates dh, dl
                 sum dh,deltax
                 sum dl,deltay 
                 push ax; safeguard ax
                 mov ax,bx; save original coordinates               
                 coordenadas dl, dh; get new coordinates
                 mov es:[bx],es:[ax]; move pixel
                 mov es:[ax],0; delete old pixel
                 pop ax; restore ax		    
    finished: loop innerLoop
    pop cx
    inc dh; increment x coordinate
  loop outerLoop
 pop cx; restore cx
 pop dx; restore dx
 ret
updateImage endp

  