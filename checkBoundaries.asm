checkCoordinates macro x, y
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
  ;How direction will be changed
  ;x y | x -y
  ;x -y| -x -y;
  ;-x y| x y;
  ;-x-y| x -y;

  cmp deltax,0 
  jl caseB; if is negative
   
  cmp deltay,0
  jl caseB; if is negative
  
  jmp caseA

  caseA:
    neg deltay
    mov deltay,ax
    jmp changedDirection

  caseB:
    neg deltax
    mov deltax,ax
    jmp changedDirection

  changedDirection: ret
changeDirection endp

  