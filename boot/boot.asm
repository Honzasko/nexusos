bits 16
[org 0x7c00]

global _main


_main:
  mov ah,0h
  mov al,0x03
  int 0x10
  mov si,msg
  mov cx,len
  call print_string


print_string:
 mov ah,0x0e
 mov di,0
 jmp .loop
 .loop:
  lodsb
  int 10h
  cmp cx,di
  je .end
  inc di
  jmp .loop
 .end:
  ret
   



msg db "Hello,World!",0
len equ $ - msg

jmp $
times 510-($-$$) db 0
dw 0xaa55
