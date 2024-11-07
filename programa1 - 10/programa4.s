/* 
Autor: America Martinez Perez
Multiplicación de dos números en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita al usuario dos números enteros, los multiplica y muestra el resultado en la pantalla.

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
        
        // Multiplicación
        long result = num1 * num2;
        
        Console.WriteLine("La multiplicación es: {0}", result);
    }
}
*/

.section .data
prompt1: .asciz "Introduce el primer número: "
prompt2: .asciz "Introduce el segundo número: "
result_msg: .asciz "La multiplicación es: %ld\n"
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

    // Multiplicar los números
    ldr x1, =num1
    ldr x1, [x1]         // Cargar el primer número
    ldr x2, =num2
    ldr x2, [x2]         // Cargar el segundo número
    mul x3, x1, x2       // Multiplicar los números
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
