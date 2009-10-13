checkBoundaries proc
  push bx; bx will be used as an index
  push cx
  mov bx,0
  mov cx,100; 100 es el ancho x de la pantalla
  checkUpperCorner:
    getCoordinates bx,0
    cmp es:[coordinate],0; Check if it has video data
    jnz imageAtBorder
    inc bx
    loop checkUpperCorner
 
  mov bx,0
  mov cx,150; 150 es el largo y de la pantalla

  checkLeftCorner:
    getCoordinates 0,bx
    cmp es:[coordinate],0; Check if it has video data
    jnz imageAtBorder
    inc bx
    loop checkLeftCorner
  
  mov bx,0
  mov cx,100

  checkLowerCorner:
    getCoordinates bx,150
    cmp es:[coordinate],0; Check if it has video data
    jnz imageAtBorder
    inc bx
    loop checkLowerCorner

  mov bx,0
  mov cx,150; 

  checkRightCorner:
    getCoordinates 100,bx
    cmp es:[coordinate],0; Check if it has video data
    jnz imageAtBorder
    inc bx
    loop checkRightCorner
  
  pop cx
  pop bx
  jmp boundaryChecked
  imageAtBorder: call changeDirection
  boundaryChecked: ret
checkBoundaries endp

  