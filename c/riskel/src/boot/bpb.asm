BS_OEMName     db 'RiskOS  '    ; (8 Bytes) OEM String
BPB_BytePerSec dw 512           ; 每扇区字节数
BPB_SecPerClus db 1             ; 每簇多少扇区
BPB_RsvdSecCnt dw 1             ; Boot 记录占用多少扇区
BPB_NumFATs    db 2             ; 共有多少 FAT 表
BPB_RootEntCnt dw 224           ; 根目录文件数最大值
BPB_TotSec16   dw 2880          ; 逻辑扇区总数
BPB_Media      db 0xf0          ; 媒体描述符
BPB_FATSz16    dw 9             ; 每FAT扇区数
BPB_SecPerTrk  dw 18            ; 每磁道扇区数
BPB_NumHeads   dw 2             ; 磁头数(面数)
BPB_HiddSec    dd 0             ; 隐藏扇区数
BPB_TotSec32   dd 0             ; wTotalSectorCount为0时这个值记录扇区数
BS_DrvNum      db 0             ; 中断 13 的驱动器号
BS_Reserved1   db 0             ; 未使用
BS_BootSig     db 0x29          ; 扩展引导标记 (29h)
BS_VolID       dd 0             ; 卷序列号
BS_VolLab      db 'Boot       ' ; (11 Bytes) 卷标
BS_FileSysType db 'FAT12   '    ; (8 Bytes) 文件系统类型


ROOT_SECTOR   equ 14            ; (BPB_RootEntCnt*32)+(BPB_BytePerSec-1)/BPB_BytePerSec
ROOT_SECNO    equ 19            ; BPB_RsvdSecCnt+(BPB_NumFATs*BPB_FATSz16)
FAT1_SECNO    equ 1             ; FAT1的第一个扇区号, BPB_RsvdSecCnt
DELTA_SECNO   equ 17            ; BPB_RsvcSecCnt+(BPB_NumFATs*BPB_FATSz16)-2
                                ; 文件开始Sector号 = DirEntry中的开始Sector号+Root占用的Sector

