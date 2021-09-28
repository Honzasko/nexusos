bits 16
[org 0x7c00]

global _main

;main function of bootloader
_main: 
  mov ah,0h
  mov al,0x03
  int 0x10
  call load_sector ;call function named load_sector
  call enable_a20
  call detect_memory


jmp $ ;make infinity loop for main function 

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

;check if a20 is supported,if yes turned it on 
enable_a20:
mov ax,2403h
int 15h
cmp ah,0
jz .is_supported
ret
.is_supported:
mov ax,2401h
int 15h
ret


detect_memory: ;should detect and save low and upper memory
clc
int 12h
mov word [low_memory],ax
mov ax,E801h
int 15h
mov word [upper_memory],ax
mov word [upper_memory_high],bx
ret   


low_memory dw 0 ;stores amount of low memory in KiB
upper_memory dw 0 ;store amount of upper memory in KiB before 16.MiB   
upper_memory_high dw 0 ;store size of memory after 16.MiB in 64KiB blocks

times 510-($-$$) db 0
dw 0xaa55
