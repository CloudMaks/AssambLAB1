section .text
global _start

_start:

; Создаем файл
mov eax, 8
mov ebx, file_name
mov ecx, 0777 ; читать, писать и выполнять могут все
int 0x80 ; вызов ядра
mov [fd_out], eax

; Записываем данные в файл
mov edx,len ; кол-во байтов
mov ecx, msg ; сообщение для записи в файл
mov ebx, [fd_out] ; файловый дескриптор
mov eax,4 ; 4-(sys_write)системный вызов для записи
int 0x80

; Закрываем файл
mov eax, 6 ; 6 -( sys_close) системный вызов для закрытия
mov ebx, [fd_out]
int 0x80

; Выводим на экран сообщение
mov eax, 4 ;4- (sys_write) системный вызов ввода сообщения
mov ebx, 1
mov ecx, msg_done
mov edx, len_done
int 0x80

; Открываем файл для чтения
mov eax, 5 ;5- (sys_open) системный вызов открытия
mov ebx, file_name
mov ecx, 0 ; доступ "Только для чтения"
mov edx, 0777 ; читать, писать и выполнять могут все
int 0x80
mov [fd_in], eax

; Считываем данные из файла
mov eax, 3 ;3- (sys_read) системный вызов считывания данных
mov ebx, [fd_in]
mov ecx, info
mov edx, 26
int 0x80

; Закрываем файл
mov eax, 6 ;6- (sys_close) системный вызов закрытия файла
mov ebx, [fd_in]
int 0x80



; Выводим на экран данные из буфера info
mov eax, 4
mov ebx, 1
mov ecx, info
mov edx, 26
int 0x80

mov eax,1 ; 1 (sys_exit) системный вызов
int 0x80

section .data
file_name db 'nado.txt'
msg db "Hi, im Maks!"
len equ $-msg

msg_done db "Строка былла внесена в файл с названием nado.txt", 0xa
len_done equ $-msg_done

section .bss
fd_out resb 1
fd_in resb 1
info resb 26
