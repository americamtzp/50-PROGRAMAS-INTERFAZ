/* 
Nombre: Conversión de Binario a Decimal en ensamblador ARM
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita un número en binario (máximo 64 bits), lo convierte a decimal y muestra el resultado en pantalla. Si la entrada es inválida, muestra un mensaje de error.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Ingrese número binario (max 64 bits): ");
        string input = Console.ReadLine();
        
        try
        {
            long result = Convert.ToInt64(input, 2);
            Console.WriteLine("Resultado decimal: " + result);
        }
        catch (FormatException)
        {
            Console.WriteLine("Error: Entrada inválida");
        }
    }
}
*/

.global _start
.align 4

.section .data
.align 4
msg1:       .string "Ingrese número binario (max 64 bits): "
msg2:       .string "\nResultado decimal: "
error_msg:  .string "Error: Entrada inválida\n"
newline:    .string "\n"

.section .bss
.align 4
buffer:     .skip 66     // Buffer para entrada
result:     .skip 21     // Buffer para resultado decimal

.section .text
.align 4
_start:
    // Imprimir mensaje de entrada
    mov     x0, #1           // stdout
    ldr     x1, =msg1        // Usar ldr en lugar de adr
    mov     x2, #35          // Longitud del mensaje
    mov     x8, #64          // write syscall
    svc     #0

    // Leer entrada
    mov     x0, #0           // stdin
    ldr     x1, =buffer      // Buffer para entrada
    mov     x2, #66          // Tamaño máximo
    mov     x8, #63          // read syscall
    svc     #0

    // Inicializar
    mov     x3, xzr          // Resultado = 0
    mov     x2, xzr          // Contador = 0
    ldr     x1, =buffer      // Puntero al buffer

convert_loop:
    ldrb    w4, [x1, x2]     // Cargar byte
    cmp     w4, #10          // Newline?
    beq     print_result
    cmp     w4, #0           // Null?
    beq     print_result
    
    // Validar dígito
    cmp     w4, #'0'
    blt     print_error
    cmp     w4, #'1'
    bgt     print_error
    
    // Convertir ASCII a binario
    sub     w4, w4, #'0'
    
    // Multiplicar por 2 y sumar
    lsl     x5, x3, #1       
    cmp     x5, x3           // Verificar overflow
    blo     print_error
    mov     x3, x5
    add     x3, x3, x4, uxtw
    
    add     x2, x2, #1
    cmp     x2, #64
    blt     convert_loop
    b       print_error

print_error:
    mov     x0, #1           // stdout
    ldr     x1, =error_msg   // Mensaje de error
    mov     x2, #22          // Longitud del mensaje
    mov     x8, #64          // write syscall
    svc     #0
    b       exit

print_result:
    // Mensaje de resultado
    mov     x0, #1
    ldr     x1, =msg2
    mov     x2, #19
    mov     x8, #64
    svc     #0

    // Convertir a ASCII
    ldr     x6, =result      
    add     x6, x6, #20      // Ir al final del buffer
    mov     x1, x3           // Número a convertir
    mov     x7, #10          // Divisor
    mov     x2, xzr          // Contador

convert_to_ascii:
    udiv    x4, x1, x7       // Dividir por 10
    msub    x5, x4, x7, x1   // Obtener remainder
    add     w5, w5, #'0'     // Convertir a ASCII
    strb    w5, [x6]         // Guardar dígito
    sub     x6, x6, #1       // Retroceder en buffer
    add     x2, x2, #1       // Incrementar contador
    mov     x1, x4           // Preparar siguiente división
    cbnz    x1, convert_to_ascii

    // Ajustar puntero
    add     x6, x6, #1
    
    // Imprimir resultado
    mov     x0, #1           // stdout
    mov     x1, x6           // Buffer del resultado
    mov     x8, #64          // write syscall
    svc     #0

    // Nueva línea
    mov     x0, #1
    ldr     x1, =newline
    mov     x2, #1
    mov     x8, #64
    svc     #0

exit:
    mov     x0, xzr          // Código de salida = 0
    mov     x8, #93          // exit syscall
    svc     #0
