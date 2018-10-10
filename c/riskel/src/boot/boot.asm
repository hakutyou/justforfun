STACK_BASE  equ 0x7c00
FILE_BASE   equ 0x9000 ;; LOADER_BASE
FILE_OFFSET equ 0x0100 ;; LOADER_OFFSET

    org 0x7c00
    [bits 16]
    jmp short LABEL_START
    nop

%include "bpb.asm"

LABEL_START:
    jmp 0:.flushCS
.flushCS:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, STACK_BASE
    cld
.SEARCH_FILE:
    call LABEL_SEARCH_FILE
    jnc .FILE_FOUND
.NO_FILE:
    mov si, MESSAGE_NO_FILE
    call LABEL_PRINT
    jmp HALT
.FILE_FOUND:
    mov si, MESSAGE_FOUND
    call LABEL_PRINT

    ;;mov eax, [es:di+0x1c]
    ;;mov dword [sz_file], eax ;; LOADER文件大小
.LOAD_FILE:
    call LABEL_LOAD_FILE

.LOADED_FILE:
    mov si, MESSAGE_LOADED
    call LABEL_PRINT
    jmp FILE_BASE:FILE_OFFSET ;; LOADER_BASE:LOADER_BASE

wSectorNo dw ROOT_SECNO
bodd      db 0

MESSAGE_FOUND:
    db "Booting", 0
MESSAGE_NO_FILE:
    db "No loader.", 0x0a, 0x0d, 0
MESSAGE_LOADED:
    db "  [OK]", 0x0a, 0x0d, 0
FILE_NAME:
    db "LOADER  BIN", 0

%include "bootfunc.asm"

; Pad out file.
    times 510 - ($-$$) db 0
    dw 0xaa55
