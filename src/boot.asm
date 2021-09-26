;
; Fixed boot.asm for NASM
;
; Date: 26-09-2021
;

bits 16
org 0x7c00

main:
cli
xor ax, ax ; mov ax, cs
mov es, ax
mov ds, ax
mov ss, ax
mov sp, ax ; 32 KiB (0x08000 - 0x0fffe)
cld ; clear the direction flag
;mov byte [drive_number], dl ; store drive number
sti

;mov ax, 0x0003
;int 0x10 ; BIOS - Set video mode 0x03

mov si, ls2_msg
call print_string

mov ax, 0x0201
mov cx, 0x0002
xor dh, dh
;mov dl, byte [drive_number]
mov bx, 0x7e00
;stc
int 13h ; BIOS - Read the second sector from the boot media (buffer address: 0x0000:0x7e00)
jc .error
jmp 0x7e00

.error:
mov si, error_msg
call print_string
jmp $

;drive_number db 0x00
ls2_msg db "Loading stage 2... ", 0x00
error_msg db "Error", 0x00

print_string:
;push ax
;push bx
;push si

mov ah, 0x0e
xor bh, bh

.print_char:
lodsb
or al, al
jz .return
int 0x10
jmp .print_char

.return:
;pop si
;pop bx
;pop ax
ret

times 0x01fe-($-$$) db 0x00
dw 0xaa55
