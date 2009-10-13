checkCoordinates macro x, y
  cmp x,0
  jns imageAtBorder
  cmp 80,x
  jns imageAtBorder
  
  cmp y,0
  jns imageAtBorder
  cmp 25,y
  jns imageAtBorder

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
  jns caseB
   
  cmp deltay,0
  jns caseB
  
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

  