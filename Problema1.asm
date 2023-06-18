; Codigo hecho por:
; Reyes Andrade Emiliano Alejandro
; Ortiz Gonzalez Rodrigo
; Lopez Piza Javier

section .data
    numbers1 db 1, 2, 3,  ; Los primeros 100 números de la primera matriz
    numbers2 db 101, 102, 103,  ; Los primeros 100 números de la segunda matriz
    scalar db 0 ; Variable para almacenar el escalar ingresado por el usuario

section .text
    global _start

_start:
    ; Mostrar el menú
    mov rax, 1
    mov rdi, 1
    mov rsi, menu
    mov rdx, menu_len
    syscall

    ; Leer la opción ingresada por el usuario
    mov rax, 0
    mov rdi, 0
    mov rsi, option
    mov rdx, 2
    syscall

    ; Comparar la opción ingresada
    cmp byte [option], '1' ; Suma
    je suma
    cmp byte [option], '2' ; Resta
    je resta
    cmp byte [option], '3' ; Multiplicación
    je multiplicacion
    cmp byte [option], '4' ; Multiplicación Escalar
    je multiplicacion_escalar
    jmp exit

suma:
    ; Sumar los elementos de las matrices
    mov ecx, 100 ; Iterar 100 veces (cantidad de elementos en la matriz)
    mov rsi, numbers1 ; Puntero a la primera matriz
    mov rdi, numbers2 ; Puntero a la segunda matriz

    ; Sumar los elementos y almacenar el resultado en numbers1
    loop_suma:
        movsd xmm0, qword [rsi] ; Cargar un elemento de numbers1 en xmm0
        addsd xmm0, qword [rdi] ; Sumar un elemento de numbers2 a xmm0
        movsd qword [rsi], xmm0 ; Almacenar el resultado en numbers1
        add rsi, 8 ; Avanzar al siguiente elemento
        add rdi, 8 ; Avanzar al siguiente elemento
        loop loop_suma

    jmp print_result

resta:
    ; Restar los elementos de las matrices
    mov ecx, 100 ; Iterar 100 veces (cantidad de elementos en la matriz)
    mov rsi, numbers1 ; Puntero a la primera matriz
    mov rdi, numbers2 ; Puntero a la segunda matriz

    ; Restar los elementos y almacenar el resultado en numbers1
    loop_resta:
        movsd xmm0, qword [rsi] ; Cargar un elemento de numbers1 en xmm0
        movsd xmm1, qword [rdi] ; Cargar un elemento de numbers2 en xmm1
        subsd xmm0, xmm1 ; Restar los elementos
        movsd qword [rsi], xmm0 ; Almacenar el resultado en numbers1
        add rsi, 8 ; Avanzar al siguiente elemento
        add rdi, 8 ; Avanzar al siguiente elemento
        loop loop_resta

    jmp print_result

multiplicacion:
    ; Multiplicar los elementos de las matrices
    mov ecx, 100 ; Iterar 100 veces (cantidad de elementos en la matriz)
    mov rsi, numbers1 ; Puntero a la primera matriz
    mov rdi, numbers2 ; Puntero a la segunda matriz

    ; Multiplicar los elementos y almacenar el resultado en numbers1
    loop_multiplicacion:
        movsd xmm0, qword [rsi] ; Cargar un elemento de numbers1 en xmm0
        movsd xmm1, qword [rdi] ; Cargar un elemento de numbers2 en xmm1
        mulsd xmm0, xmm1 ; Multiplicar los elementos
        movsd qword [rsi], xmm0 ; Almacenar el resultado en numbers1
        add rsi, 8 ; Avanzar al siguiente elemento
        add rdi, 8 ; Avanzar al siguiente elemento
        loop loop_multiplicacion

    jmp print_result

multiplicacion_escalar:
    ; Leer el escalar ingresado por el usuario
    mov rax, 0
    mov rdi, 0
    mov rsi, scalar_input
    mov rdx, 2
    syscall

    ; Convertir el número ingresado a un valor numérico
    movzx eax, byte [scalar_input]
    sub eax, '0'
    mov byte [scalar], al

    ; Multiplicar la primera fila por el escalar
    mov ecx, 100 ; Iterar 100 veces (cantidad de elementos en la fila)
    mov rsi, numbers1 ; Puntero a la primera matriz

    ; Multiplicar los elementos por el escalar
    loop_multiplicacion_escalar:
        movzx eax, byte [scalar] ; Cargar el escalar en eax y realizar una ampliación de cero
        movd xmm1, eax ; Mover el valor ampliado a xmm1
        shufpd xmm1, xmm1, 0 ; Replicar el escalar en xmm1

        movsd xmm0, qword [rsi] ; Cargar un elemento de numbers1 en xmm0
        mulsd xmm0, xmm1 ; Multiplicar el elemento por el escalar

        movsd qword [rsi], xmm0 ; Almacenar el resultado en numbers1
        add rsi, 8 ; Avanzar al siguiente elemento
        loop loop_multiplicacion_escalar

    jmp print_result

print_result:
    ; Imprimir el resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, result_len
    syscall

    ; Imprimir los elementos de numbers1
    mov ecx, 100 ; Iterar 100 veces (cantidad de elementos en la matriz)
    mov rsi, numbers1 ; Puntero a la matriz

    loop_print:
        movsd xmm0, qword [rsi] ; Cargar un elemento de numbers1 en xmm0    ;Segmentation Fault
        cvttsd2si eax, xmm0 ; Convertir el elemento a entero
        mov rdi, rsi_num ; Puntero a la cadena de números
        mov rdx, 4 ; Longitud de un número en la cadena
        call print_number ; Llamar a la función para imprimir un número
        add rsi, 8 ; Avanzar al siguiente elemento
        loop loop_print

    jmp exit

exit:
    ; Salir del programa
    mov eax, 60
    xor edi, edi
    syscall

; Función para imprimir un número
print_number:
    ; rdi: Puntero a la cadena de números
    ; rdx: Longitud de un número en la cadena
    push rax
    push rdi
    push rdx

    mov rax, 1 ; syscall para imprimir
    mov rdi, 1 ; fd = stdout
    mov rsi, rdi ; puntero a la cadena
    mov rdx, rdx ; longitud de la cadena
    syscall

    pop rdx
    pop rdi
    pop rax
    ret

section .data
    menu db "Menu:", 10
         db "1. Suma", 10
         db "2. Resta", 10
         db "3. Multiplicacion", 10
         db "4. Multiplicacion Escalar", 10
         db "Ingrese una opcion: ", 0
    menu_len equ $ - menu

    option db '0', 0
    scalar_input db '0', 0

    result db "Resultado:", 10
    result_len equ $ - result

    rsi_num db '0000', 0 ; Buffer para convertir un número entero a cadena
