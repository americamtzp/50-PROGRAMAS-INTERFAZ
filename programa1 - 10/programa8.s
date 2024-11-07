/* 
Autor: America Martinez Perez
Generador de la serie de Fibonacci en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita al usuario un número de términos y calcula la serie de Fibonacci hasta ese número, mostrando los resultados.
El primer término es 0 y el segundo término es 1. Los siguientes términos se generan sumando los dos términos anteriores.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce el número de términos de la serie de Fibonacci: ");
        int nTerms = Convert.ToInt32(Console.ReadLine());

        // Verificar si el número de términos es mayor que 0
        if (nTerms <= 0)
        {
            return; // Salir si n <= 0
        }

        long fib1 = 0, fib2 = 1;

        // Imprimir el primer término
        Console.WriteLine($"Fibonacci[0] = {fib1}");

        // Si solo se quiere imprimir el primer término
        if (nTerms == 1)
        {
            return;
        }

        // Imprimir el segundo término
        Console.WriteLine($"Fibonacci[1] = {fib2}");

        // Calcular y mostrar el resto de los términos
        for (int i = 2; i < nTerms; i++)
        {
            long fibNext = fib1 + fib2;
            Console.WriteLine($"Fibonacci[{i}] = {fibNext}");

            // Actualizar los términos
            fib1 = fib2;
            fib2 = fibNext;
        }
    }
}
*/

.section .data
prompt: .asciz "Introduce el número de términos de la serie de Fibonacci: "
result_msg: .asciz "Fibonacci[%ld] = %ld\n"
scanf_format: .asciz "%ld"

n_terms: .quad 0
fib1: .quad 0
fib2: .quad 1

.section .text
.global main

main:
    // Pedir el número de términos
    ldr x0, =prompt
    bl printf

    // Leer el número de términos
    ldr x0, =scanf_format
    ldr x1, =n_terms
    bl scanf

    // Cargar el número de términos en x1
    ldr x1, =n_terms
    ldr x1, [x1]

    // Verificar si n es menor o igual a 0
    cmp x1, #0
    ble end_program      // Si n <= 0, salir

    // Inicializar los primeros dos términos de Fibonacci
    ldr x4, =fib1
    ldr x5, =fib2
    mov x0, #0           // Primer término (0)
    str x0, [x4]         // fib1 = 0

    mov x0, #1           // Segundo término (1)
    str x0, [x5]         // fib2 = 1

    // Imprimir el primer término
    ldr x0, =result_msg
    mov x1, #0           // Índice 0
    ldr x2, [x4]         // Cargar fib1 (0)
    bl printf

    // Si solo se quiere imprimir el primer término, salir
    cmp x1, #1
    beq end_program

    // Imprimir el segundo término
    mov x1, #1           // Índice 1
    ldr x0, =result_msg
    ldr x2, [x5]         // Cargar fib2 (1)
    bl printf

    // Calcular y mostrar el resto de los términos
    mov x7, #2           // Contador de términos ya impresos

fibonacci_loop:
    // Cargar los dos últimos términos
    ldr x10, [x4]        // fib1
    ldr x11, [x5]        // fib2
    add x12, x10, x11    // x12 = fib1 + fib2

    // Imprimir el término actual
    ldr x0, =result_msg
    mov x1, x7           // Índice actual
    mov x2, x12          // Valor a imprimir
    bl printf

    // Actualizar los términos
    str x11, [x4]        // fib1 = fib2
    str x12, [x5]        // fib2 = nuevo término (x12)

    // Incrementar el contador
    add x7, x7, #1
    cmp x7, x1
    blt fibonacci_loop

end_program:
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
