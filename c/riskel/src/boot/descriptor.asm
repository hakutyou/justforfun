;; Descriptor Table
DA_SYS_TYPE_LDT      equ 0x0002
DA_SYS_TYPE_TSS_free equ 0x0009
DA_SYS_TYPE_TSS_busy equ 0x000b
DA_SYS_DPL1          equ 0000000000100000b
DA_SYS_DPL2          equ 0000000001000000b
DA_SYS_P             equ 0000000010000000b
DA_SYS_AVL           equ 0001000000000000b
DA_SYS_G             equ 1000000000000000b

;; Descriptor Base(64 bit), Limit(20 bit), Attr(16-4 bit)
%macro Descriptor 3
    dw %2 & 0xffff	    ;; limit
    dw %1 & 0xffff	    ;; base
    db (%1 >> 16) & 0xff    ;; base
    dw ((%2 >> 8) & 0x0f00)|(%3 & 0xf0ff)
    db (%1 >> 24) & 0xff    ;; base
    dd (%1 >> 32)           ;; base
    dd 0
%endmacro

DA_USER_WRITE     equ 0000000000000010b ;; 不知道什么用
DA_USER_CODE      equ 0000000000011000b ;; 加载CS寄存器 (否则会产生#GP异常)
DA_USER_DATA      equ 0000000000010000b ;; 加载其他寄存器 (否则会产生#GP异常)
DA_USER_CODE_C    equ 0000000000000100b ;; conforming/non-conforming (控制权限)
DA_USER_CODE_DPL1 equ 0000000000100000b ;; 访问code segment (需要的权限)
DA_USER_CODE_DPL2 equ 0000000001000000b
DA_USER_P         equ 0000000010000000b ;; present (是否加载到内存)
DA_USER_CODE_L    equ 0010000000000000b ;; long (64-bit mode 还是 compatibility mode)
DA_USER_CODE_DB   equ 0100000000000000b ;; 指示 code segment 的default operand size
;; DS/ES/SS 的 data segment descriptor 只有DA_USER_P 有效
;; FS/GS 的 Base 有效
;; Code segment descriptor 强制 Reabable
;; Data segment descriptor 强制 Expand-Up, Writable

;; UserDescriptor Base(32bit), Attr(16-4 bit)
%macro UserDescriptor 2
    dw 0                    ;; limit
    dw %1 & 0xffff          ;; base
    db (%1 >> 16) & 0xff    ;; base
    dw %2 & 0xf0ff          ;; attr
    db (%1 >> 24) & 0xff    ;; base
%endmacro

;; Gate Descriptor
DA_LDT      EQU 0x82  ; 局部描述符表段类型值
DA_386TSS   EQU 0x89  ; 可用 386 任务状态段类型值

SA_RPL0 EQU 0
SA_RPL1 EQU 1
SA_RPL2 EQU 2
SA_RPL3 EQU 3

SA_TIG  EQU 0
SA_TIL  EQU 4
DA_386CGate EQU 0x8c  ; 386 调用门类型值
DA_386IGate EQU 0x8e  ; 386 中断门类型值
DA_386TGate EQU 0x8f  ; 386 陷阱门类型值

DA_GATE_IST1 equ 1
DA_GATE_IST2 equ 2
DA_GATE_IST3 equ 3
DA_GATE_IST4 equ 4
DA_GATE_IST5 equ 5
DA_GATE_IST6 equ 6
DA_GATE_IST7 equ 7

DA_GATE_S    equ 00010000b
DA_GATE_DPL0 equ 00000000b
DA_GATE_DPL1 equ 00100000b
DA_GATE_DPL2 equ 01000000b
DA_GATE_DPL3 equ 01100000b
DA_GATE_P    equ 10000000b
;; Gate selector(16 bit), offset(64 bit), IST(3 bit), attr(16 bit)
%macro Gate 4
    dw %2 && 0xffff
    dw %1
    dw (%3 & 0x07) | ((%4 << 8) & 0xff00)
    dw ((%2 >> 16) & 0xffff
    dd ((%2 >> 32) & 0xffffffff)
    dd 0
%endmacro
