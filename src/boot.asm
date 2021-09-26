bits 16
[org 0x7c00]

global _main

;main function of bootloader
_main: 
  mov ah,0h
  mov al,0x03
  int 0x10
  call load_sector
  call detect_memory

;load kernel
load_sector:
mov ah,02h
mov al,1
mov ch,0
mov cl,1
mov dh,0
mov dl,80h
mov bh,0
mov es,0x7e00
int 13h
ret

detect_memory: ;should detect and save low and upper memory
clc
int 12h
mov dword [low_memory],ax
   

jmp $


low_memory dw 0 ;stores amount of low memory in KB
upper_memory dw 0

times 510-($-$$) db 0
dw 0xaa55