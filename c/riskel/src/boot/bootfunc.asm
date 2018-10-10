LABEL_PRINT:
    pushad
.LOOP:
    lodsb        ;; [es:si] -> al
    test al, al
    je .FINISH
    mov ah, 0x0e
    int 0x10
    jmp .LOOP
.FINISH:
    popad
    ret

LABEL_SEARCH_FILE:
;; flushFloppy
    xor ah, ah
    xor dl, dl
    int 0x13

;; Search FILE
    mov ax, FILE_BASE
    mov es, ax

    mov cx, ROOT_SECTOR

.LOOP_SECTOR:
    push cx

    mov bx, FILE_OFFSET
    mov ax, [wSectorNo]
    mov cl, 1
    call LABEL_LOAD

    mov si, FILE_NAME
    mov di, FILE_OFFSET
    cld

    mov cx, 0x10
.SEARCH_FILE_LOOP:
    push cx
    mov cx, 11
.CMP_FILENAME:
    lodsb
    cmp al, byte [es:di]
    jne .NOT_FILENAME

    inc di
    loop .CMP_FILENAME
    jmp .FILE_FOUND
.NOT_FILENAME:
    and di, 0xffe0
    add di, 0x20
    mov si, FILE_NAME
    pop cx
    loop .SEARCH_FILE_LOOP

.NEXT_SECTOR:
    inc word [wSectorNo]

    pop cx
    loop .LOOP_SECTOR

.NO_FILE:
    stc
    ret
.FILE_FOUND:
    pop cx
    pop cx
    clc
    ret

LABEL_READSECTOR:
    push bp
    mov bp, sp
    sub esp, 2
    mov byte [bp-2], cl
    push bx
    mov bl, [BPB_SecPerTrk]
    div bl
    inc ah
    mov cl, ah
    mov dh, al
    shr al, 1
    mov ch, al
    and dh, 1
    pop bx
    mov dl, [BS_DrvNum]
.READ_LOOP:
    mov ah, 2
    mov al, byte [bp-2]
    int 0x13
    jc .READ_LOOP

    add esp, 2
    pop bp
    ret

LABEL_LOAD:
    push bp
    mov bp, sp
    sub esp, 2
    mov byte [bp-2], cl
    push bx
    mov bl, [BPB_SecPerTrk]
    div bl
    inc ah
    mov cl, ah
    mov dh, al
    shr al, 1
    mov ch, al
    and dh, 1
    pop bx
    mov dl, [BS_DrvNum]
.READ:
    mov ah, 2
    mov al, byte [bp-2]
    int 13h
    jc .READ
    add esp, 2
    pop bp
    ret

LABEL_LOAD_FILE:
    mov ax, ROOT_SECTOR
    and di, 0xffe0
    add di, 0x001a

    mov cx, word [es:di]
    push cx
    add cx, ax
    add cx, DELTA_SECNO
    mov ax, FILE_BASE
    mov es, ax
    mov bx, FILE_OFFSET   ;; es:bx = FILE_BASE:FILE_OFFSET
    mov ax, cx
.LOADING_FILE:
    push ax
    push bx
    mov ah, 0x0e
    mov al, '.'
    mov bl, 0x0f
    int 0x10
    pop bx
    pop ax

    mov cl, 1
    call LABEL_READSECTOR
    pop ax
    call LABEL_GETFATENTRY
    cmp ax, 0x0fff
    jz .LOADED_FILE
    push ax
    mov dx, ROOT_SECTOR
    add ax, dx
    add ax, DELTA_SECNO
    add bx, [BPB_BytePerSec]
    jmp .LOADING_FILE
.LOADED_FILE:
    ret


LABEL_GETFATENTRY:
    push es
    push bx
    push ax
    mov ax, FILE_BASE
    sub ax, 0x0100
    mov es, ax          ;; LOADER_BASE 留出 4K 存放 FAT
    pop ax
    mov byte [bodd], 0
    mov bx, 3
    mul bx
    mov bx, 2
    div bx
    cmp dx, 0
    jz .EVEN
    mov byte [bodd], 1
.EVEN:
    xor dx, dx
    mov bx, [BPB_BytePerSec]
    div bx
    push dx
    mov bx, 0
    add ax, FAT1_SECNO
    mov cl, 2
    call LABEL_READSECTOR
    pop dx
    add bx, dx
    mov ax, [es:bx]
    cmp byte [bodd], 1
    jnz .EVER_EVEN
    shr ax, 4
.EVER_EVEN:
    and ax, 0x0fff
.GETED_ENTRY:
    pop bx
    pop es
    ret


HALT:
    hlt
    jmp HALT

