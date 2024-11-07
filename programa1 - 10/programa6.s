/* 
Autor: America Martinez Perez
Suma de los primeros N números naturales en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita al usuario un número N, calcula la suma de los primeros N números naturales y muestra el resultado.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce un número N para calcular la suma de los primeros N números naturales: ");
        long number = Convert.ToInt64(Console.ReadLine());
        
        // Calcular la suma de los primeros N números naturales
        long sum = 0;
        for (long i = 1; i <= number; i++)
        {
            sum += i;
        }
        
        Console.WriteLine("La suma de los primeros {0} números naturales es {1}.", number, sum);
    }
}
*/

.section .data
prompt: .asciz "Introduce un número N para calcular la suma de los primeros N números naturales: "
result_msg: .asciz "La suma de los primeros %ld números naturales es %ld.\n"
scanf_format: .asciz "%ld"

number: .quad 0
sum: .quad 0

.section .text
.global main

main:
    // Pedir al usuario un número
    ldr x0, =prompt
    bl printf

    // Leer el número
    ldr x0, =scanf_format
    ldr x1, =number
    bl scanf

    // Cargar el número en x1
    ldr x1, =number
    ldr x1, [x1]

    // Inicializar la suma en 0
    mov x2, #0

    // Calcular la suma de los primeros N números naturales
    mov x3, #1        // Inicializar contador en 1
sum_loop:
    cmp x3, x1        // Comparar contador con N
    bgt end_sum       // Si contador > N, salir del bucle

    add x2, x2, x3    // suma += contador
    add x3, x3, #1    // Incrementar contador
    b sum_loop        // Volver al inicio del bucle

end_sum:
    // Guardar el resultado de la suma
    ldr x4, =sum
    str x2, [x4]

    // Imprimir el resultado
    ldr x0, =result_msg
    mov x1, x1        // cargar N
    ldr x2, =sum
    ldr x2, [x2]      // cargar el resultado
    bl printf

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
