STACK_BASE  equ 0x0100
FILE_BASE   equ 0x8000 ;; KERNEL_BASE
FILE_OFFSET equ 0x0000 ;; KERNEL_OFFSET

    org 0x0100
    jmp short LABEL_LSTART
    ;;nop
    %include "bpb.asm"

LABEL_LSTART:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, STACK_BASE

    call LABEL_SUPPORT  ;; Here means got loader and x64 support
    jnc .SUPPORT_LONG
.NOT_SUPPORT:
    mov si, MESSAGE_NOT_SUPPORT
    call LABEL_PRINT
    jmp HALT
.SUPPORT_LONG:
    ;; mov si, MESSAGE_FOUNDING
    ;; call LABEL_PRINT

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

    mov eax, [es:di+0x1c]
    mov dword [sz_kernel], eax ;; KERNEL文件大小
.LOAD_FILE:
    call LABEL_LOAD_FILE
.LOADED_FILE:
    mov si, MESSAGE_LOADED
    call LABEL_PRINT
.KILL_MOTOR
    call LABEL_KILL_MOTOR
    jmp HALT
;; Pause Just
;;    mov edi, FREE_SPACE
;;    jmp LABEL_SWITCH_LONG

sz_kernel dd 0

wSectorNo dd ROOT_SECNO
bodd      db 0

MESSAGE_FOUND:
    db "Loading", 0
MESSAGE_NO_FILE:
    db "No kernel.", 0x0a, 0x0d, 0
MESSAGE_LOADED:
    db "  [OK]", 0x0a, 0x0d, 0
MESSAGE_NOT_SUPPORT:
    db "CPU does not support long mode.", 0x0a, 0x0d, 0
FILE_NAME:
    db "KERNEL  BIN", 0

LABEL_SUPPORT:
    pushfd
    pop eax
    mov ecx, eax
    xor eax, 0x200000
    push eax
    popfd

    pushfd
    pop eax
    xor eax, ecx
    shr eax, 21
    and eax, 1
    push ecx
    popfd

    test eax, eax
    jz .NOT_SUPPORT

    mov eax, 0x80000000
    cpuid

    cmp eax, 0x80000001
    jb .NOT_SUPPORT

    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jnz .SUPPORT_LONG

.NOT_SUPPORT:
    stc
.SUPPORT_LONG
   ret

LABEL_KILL_MOTOR:
    push dx
    mov dx, 0x03f2
    mov al, 0
    out dx, al
    pop dx
    ret

%include "bootfunc.asm"

