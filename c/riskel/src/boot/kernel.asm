    org 0x0100

%define PAGE_PRESENT (1 << 0)
%define PAGE_WRITE (1 << 1)

%include "descriptor.asm"

[SECTION .gdt]
GDT:
.NULL:  equ $-GDT
        UserDescriptor       0, 0
.CODE:  equ $-GDT
        UserDescriptor       0, DA_USER_CODE | DA_USER_P | DA_USER_CODE_L
.DATA:  equ $-GDT
        UserDescriptor       0, DA_USER_DATA | DA_USER_P | DA_USER_WRITE
.VIDEO: equ $-GDT
        UserDescriptor 0xb8000, DA_USER_DATA | DA_USER_P | DA_USER_WRITE
.CODEA: equ $-GDT
        UserDescriptor LABEL_CODEA, DA_USER_CODE | DA_USER_P | DA_USER_CODE_L
;.CODEA: equ $-GDT
;        Descriptor LABEL_CODEA, 0xffff, DA_USER_CODE | DA_SYS_TYPE_LDT | DA_SYS_P
;;.LDT:   Descriptor           0, 0, DA_SYS_TYPE_LDT

;align 4
;    dw 0
.Pointer:
    dw $-GDT ;; gdt_limit
    dd GDT     ;; gdt_base

;; [SECTION .gdt] end


;[SECTION .ldt]
;LDT:
;.CODEA: equ $-GDT
;	UserDescriptor 0,0
;        ;;UserDescriptor LABEL_CODEA, DA_USER_CODE | DA_USER_P | DA_USER_CODE_L

;;.Pointer:
;;    dw $-LDT ;; ldt_limit
;;    dd LDT     ;; ldt_base

;; [SECTION .ldt] end


[SECTION .code]
ALIGN 4
IDT:
    .LENGTH dw 0
    .BASE dd 0

LABEL_SWITCH_LONG:
    push di
    mov ecx, 0x1000
    xor eax, eax
    cld
    rep stosd
    pop di

    ;; es:di -> Page Map Level 4 Table
    lea eax, [es:di+0x1000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di], eax

    ;; Build Page Directory Point Table
    lea eax, [es:di+0x2000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di+0x1000], eax

    ;; Build the Page Directory
    lea eax, [es:di+0x3000]
    or eax, PAGE_PRESENT | PAGE_WRITE
    mov [es:di+0x2000], eax

    push di
    lea di, [di+0x3000]
    mov eax, PAGE_PRESENT | PAGE_WRITE

    ;; Build the Page Table
.LOOP_PAGE_TABLE:
    mov [es:di], eax
    add eax, 0x1000
    add di, 8
    cmp eax, 0x200000
    jb .LOOP_PAGE_TABLE

    pop di
    ;; Disable IRQs
    mov al, 0xff
    out 0xa1, al
    out 0x21, al

    nop
    nop

    lidt [IDT]

    ;; ENTER LONG MODE
    mov eax, 10100000b
    mov cr4, eax

    mov edx, edi
    mov cr3, edx

    mov ecx, 0xc0000080
    rdmsr

    or eax, 0x00000100
    wrmsr

    mov ebx, cr0
    or ebx, 0x80000001
    mov cr0, ebx

    lgdt [GDT.Pointer]

    jmp GDT.CODE:LABEL_LONG_MODE

[BITS 64]

LABEL_LONG_MODE:
    mov ax, GDT.DATA
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov ss, ax

    ;;lldt [LDT.Pointer]

    ;;mov rax, ss
    ;;push rax              ;; ss
    ;;push rsp              ;; rsp
    ;;pushfq                ;; rflags

    ;push GDT.CODEA
    push 8
    push LABEL_CODEA
    retfq

;;    mov ax, GDT.VIDEO
;;    mov gs, ax
;;    xor edi, edi
;;
;;    mov rax, 0x0f6C0f6C0f650f48
;;    mov [gs:edi],rax
;;
;;    mov rax, 0x0f6F0f570f200f6F
;;    mov [gs:edi + 8], rax
;;
;;    mov rax, 0x0f210f640f6C0f72
;;    mov [gs:edi + 16], rax
;;
;;.FINISH:
;;    hlt
;;    jmp .FINISH

;;    ;call SelectorLDTCodeA:0
;;
;;    ; Blank out the screen to a blue color.
;;    ; mov edi, 0xb8000
;;    ; mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
;;    ; mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
;;    ; rep stosq                         ; Clear the entire screen. 
;;
;;    ; Display "Hello World!"
;;    xor edi, edi
;;
;;    mov rax, 0x0f6C0f6C0f650f48
;;    mov [gs:edi],rax
;;
;;    mov rax, 0x0f6F0f570f200f6F
;;    mov [gs:edi + 8], rax
;;
;;    mov rax, 0x0f210f640f6C0f72
;;    mov [gs:edi + 16], rax
;;
;;.FINISH:
;;    hlt
;;    jmp .FINISH
SegCodeLen equ $ - LABEL_LONG_MODE
;; [SECTION .code] end


;;[SECTION .ldt]
;;LDT:
;;.DESC_CODEA: UserDescriptor       0, DA_USER_DATA | DA_USER_P | DA_USER_WRITE
;;
;;align 4
;;    dw 0
;;.Pointer:
;;    dw $-LDT-1 ;; ldt_limit
;;    dd LDT     ;; ldt_base
;;
;;SelectorLDTCodeA equ .DESC_CODEA - LDT + SA_TIL
;;;;;; [SECTION .ldt] end


[SECTION .la]
[BITS 64]
LABEL_CODEA:
    mov ax, GDT.VIDEO
    mov gs, ax

    ; Blank out the screen to a blue color.
    ; mov edi, 0xb8000
    ; mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
    ; mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
    ; rep stosq                         ; Clear the entire screen. 

    ; Display "Hello World!"
    xor edi, edi

    mov rax, 0x0f6C0f6C0f650f48
    mov [gs:edi],rax

    mov rax, 0x0f6F0f570f200f6F
    mov [gs:edi + 8], rax

    mov rax, 0x0f210f640f6C0f72
    mov [gs:edi + 16], rax

.FINISH:
    hlt
    jmp .FINISH

CodeALen equ $-LABEL_CODEA
;;[SECTION .la] end

;; ;;[SECTION .stack]
;; ;;[BITS 64]
;; LABEL_STACK:
;;     times 64 db 0
;; ;;;    times 256 db 0
;; ;;stacktop equ $-LABEL_STACK-1
;; 
;; ;; [SECTION .stack] end
