/* 
Autor: America Martinez Perez
Búsqueda Lineal en un Arreglo en Ensamblador ARM64
Fecha: 5 de noviembre de 2024
Descripción: Este programa busca un valor específico en un arreglo de enteros y retorna el índice de dicho valor. Si el valor no se encuentra, retorna -1.

Solución en C#:

using System;

class Program
{
    static void Main()
    {
        int[] array = { 12, 3, 5, 7, 1, 9, 2 };
        int target = 5;
        int index = -1;

        for (int i = 0; i < array.Length; i++)
        {
            if (array[i] == target)
            {
                index = i;
                break;
            }
        }

        Console.WriteLine(index != -1 ? $"Valor encontrado en el índice {index}" : "Valor no encontrado");
    }
}
*/

.section .data
array:      .word 12, 3, 5, 7, 1, 9, 2     // Arreglo de ejemplo
array_size: .word 7                        // Tamaño del arreglo (número de elementos)
target:     .word 5                        // Valor a buscar en el arreglo

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección del primer elemento
    adrp x1, array_size                   // Carga la página base de array_size en x1
    add x1, x1, :lo12:array_size          // Completa la dirección con el offset bajo de array_size
    ldr w2, [x1]                          // Carga el tamaño del arreglo en w2

    adrp x3, array                        // Carga la página base de array en x3
    add x3, x3, :lo12:array               // Completa la dirección con el offset bajo de array
    adrp x4, target                       // Carga la página base de target en x4
    add x4, x4, :lo12:target              // Completa la dirección con el offset bajo de target
    ldr w5, [x4]                          // Carga el valor a buscar en w5

    mov x6, #0                            // Inicializa el índice a 0 (64 bits ahora)

search_loop:
    cmp w6, w2                            // Verifica si el índice ha alcanzado el tamaño del arreglo
    beq not_found                         // Si hemos llegado al final, el valor no se encontró

    ldr w7, [x3, x6, lsl #2]              // Carga el elemento actual del arreglo en w7
    cmp w7, w5                            // Compara el elemento actual con el valor de búsqueda
    beq found                             // Si son iguales, salta a la etiqueta found

    add x6, x6, #1                        // Incrementa el índice
    b search_loop                         // Repite el bucle

not_found:
    mov w0, #-1                           // Si no se encuentra el valor, retorna -1
    mov x8, #93                           // Código de salida para ARM Linux
    svc #0                                // Llama al sistema para salir

found:
    mov w0, w6                            // Retorna el índice donde se encontró el valor
    mov x8, #93                           // Código de salida para ARM Linux
    svc #0                                // Llama al sistema para salir
