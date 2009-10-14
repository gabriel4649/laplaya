
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
  imageAtBorder: 
  call changeDirection
  boundaryChecked: 
endm


changeDirection proc
  push ax
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
    moveD deltay, ypos
    moveD deltay, ypos
    jmp changedDirection

  caseB:
    neg deltax
    moveD deltax, xpos
    moveD deltax, xpos
    jmp changedDirection

  changedDirection: 
  pop ax
  ret
changeDirection endp