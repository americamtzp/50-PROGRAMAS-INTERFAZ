/* 
Autor: America Martinez Perez
División de dos números en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita al usuario dos números, realiza la división del primero entre el segundo, y muestra el resultado. Incluye una verificación para evitar la división por cero.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce el primer número: ");
        long num1 = Convert.ToInt64(Console.ReadLine());

        Console.Write("Introduce el segundo número: ");
        long num2 = Convert.ToInt64(Console.ReadLine());

        if (num2 == 0)
        {
            Console.WriteLine("Error: División por cero no permitida.");
        }
        else
        {
            long result = num1 / num2;
            Console.WriteLine("La división es: {0}", result);
        }
    }
}
*/

.section .data
prompt1: .asciz "Introduce el primer número: "
prompt2: .asciz "Introduce el segundo número: "
result_msg: .asciz "La división es: %ld\n"
error_msg: .asciz "Error: División por cero no permitida.\n"
scanf_format: .asciz "%ld"  // Formato para leer long int

num1: .quad 0
num2: .quad 0
result: .quad 0

.section .text
.global main

main:
    // Pedir el primer número
    ldr x0, =prompt1
    bl printf

    // Leer el primer número
    ldr x0, =scanf_format // Cargar formato de scanf
    ldr x1, =num1        // Cargar dirección de num1
    bl scanf

    // Pedir el segundo número
    ldr x0, =prompt2
    bl printf

    // Leer el segundo número
    ldr x0, =scanf_format // Cargar formato de scanf
    ldr x1, =num2        // Cargar dirección de num2
    bl scanf

    // Dividir los números
    ldr x1, =num1
    ldr x1, [x1]         // Cargar el primer número
    ldr x2, =num2
    ldr x2, [x2]         // Cargar el segundo número

    // Comprobar si el segundo número es cero
    cmp x2, #0
    beq division_por_cero // Saltar si el segundo número es cero

    sdiv x3, x1, x2       // Dividir los números
    ldr x0, =result
    str x3, [x0]         // Almacenar el resultado

    // Mostrar el resultado
    ldr x0, =result_msg
    ldr x1, =result
    ldr x1, [x1]         // Cargar el resultado
    bl printf

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0

division_por_cero:
    // Mostrar un mensaje de error si se intenta dividir por cero
    ldr x0, =error_msg
    bl printf

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
