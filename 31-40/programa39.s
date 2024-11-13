/* 
Nombre: Conversión de número decimal a binario en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM toma un número decimal y lo convierte a binario, mostrando el resultado como una cadena de caracteres en la salida estándar.

Autor: America Martinez Perez

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        int num = 43; // Número decimal a convertir
        
        // Convertir a binario
        string binStr = Convert.ToString(num, 2); 
        
        Console.WriteLine("El número en binario es: " + binStr);
    }
}
*/

.global _start

.section .data
    num: .word 43        // Número decimal a convertir
    msg: .asciz "El número en binario es: "

.section .bss
    bin_str: .skip 32    // Reservamos 32 bytes para la cadena binaria

.section .text
_start:
    // Imprimir mensaje de inicio
    ldr x0, =msg         // Cargar la dirección del mensaje
    bl print_string

    // Cargar el número decimal a convertir
    ldr w1, =num         // Cargar el valor de 'num' en w1

    // Convertir a binario y almacenar el resultado en bin_str
    mov w2, #31          // Contador para el bit más significativo (comenzamos desde el bit 31)
    ldr x3, =bin_str     // Dirección de la cadena binaria

convert_loop:
    cmp w2, #0           // Si el contador es menor a 0, terminamos
    blt done

    // Obtener el bit en la posición w2
    lsr w4, w1, w2       // Desplazar el número hacia la derecha (w1)
    and w4, w4, #1       // Obtener el bit (0 o 1)

    // Convertir el bit a ASCII (0 o 1)
    add w4, w4, #48      // '0' tiene valor ASCII 48

    // Guardar el bit en la cadena binaria
    strb w4, [x3], #1    // Almacenar el byte y mover el puntero

    // Reducir el contador
    sub w2, w2, #1
    b convert_loop

done:
    // Imprimir la cadena binaria
    ldr x0, =bin_str     // Cargar la dirección de la cadena binaria
    bl print_string

    // Salir del programa
    mov x8, #93          // syscall number for exit
    mov x0, #0           // status 0
    svc #0

// Función para imprimir una cadena de caracteres
print_string:
    mov x2, x1           // Longitud de la cadena (en bytes)
    mov x8, #64          // syscall number for write
    mov x1, x0           // Dirección de la cadena
    mov x0, #1           // File descriptor (1 = stdout)
    svc #0
    ret
