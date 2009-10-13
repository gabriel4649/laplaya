checkBoundaries proc
  push ax; ax will be used as an index
  push cx
  mov ax,0
  mov cx,26; 26 es el ancho x de la pantalla
  checkUpperCorner:
    getCoordinates 0,ax
    cmp es:[bx],0; Check if it has video data
    jnz imageAtBorder
    inc ax
    loop checkUpperCorner
 
  mov ax,0
  mov cx,81; 81 es el largo y de la pantalla

  checkLeftCorner:
    getCoordinates ax,0
    cmp es:[bx],0; Check if it has video data
    jnz imageAtBorder
    inc ax
    loop checkLeftCorner
  
  mov ax,0
  mov cx,26

  checkLowerCorner:
    getCoordinates 81,ax
    cmp es:[bx],0; Check if it has video data
    jnz imageAtBorder
    inc ax
    loop checkLowerCorner

  mov ax,0
  mov cx,81; 

  checkRightCorner:
    getCoordinates ax,26
    cmp es:[bx],0; Check if it has video data
    jnz imageAtBorder
    inc ax
    loop checkRightCorner
  
  pop cx
  pop ax
  jmp boundaryChecked
  imageAtBorder: call changeDirection
  boundaryChecked: ret
checkBoundaries endp

  
