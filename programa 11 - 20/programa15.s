/* 
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM realiza una búsqueda binaria en un arreglo de enteros ordenado.
El programa busca un valor específico en el arreglo y devuelve su índice si se encuentra, o -1 si no está.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        int[] array = { 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 };
        int target = 7;
        
        int low = 0;
        int high = array.Length - 1;
        int index = -1;

        while (low <= high)
        {
            int mid = (low + high) / 2;
            if (array[mid] == target)
            {
                index = mid;
                break;
            }
            else if (array[mid] < target)
            {
                low = mid + 1;
            }
            else
            {
                high = mid - 1;
            }
        }

        Console.WriteLine("Índice encontrado: " + index);
    }
}
*/

.section .data
array:      .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19  // Arreglo ordenado
array_size: .word 10                                // Tamaño del arreglo
target:     .word 7                                 // Valor a buscar

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

    mov w6, #0                            // Inicializa el índice de inicio (low)
    mov w7, w2                            // Inicializa el índice final (high) al tamaño del arreglo

binary_search_loop:
    cmp w6, w7                            // Verifica si low <= high
    bgt not_found                         // Si no, el valor no se encuentra

    add w8, w6, w7                        // w8 = low + high
    lsr w8, w8, #1                        // w8 = (low + high) / 2 (dividir entre 2)

    ldr w9, [x3, x8, lsl #2]              // Cargar el elemento en la mitad del arreglo (array[mid])
    cmp w9, w5                            // Compara el valor encontrado con el valor objetivo
    beq found                             // Si son iguales, hemos encontrado el valor

    blt search_right                      // Si el valor es menor que el objetivo, buscar en la mitad derecha
    b search_left                         // Si el valor es mayor, buscar en la mitad izquierda

search_left:
    sub w7, w8, #1                        // high = mid - 1
    b binary_search_loop                  // Repetir la búsqueda

search_right:
    add w6, w8, #1                        // low = mid + 1
    b binary_search_loop                  // Repetir la búsqueda

not_found:
    mov w0, #-1                           // Si no se encuentra el valor, retorna -1
    mov x8, #93                           // Código de salida para ARM Linux
    svc #0                                // Llama al sistema para salir

found:
    mov w0, w8                            // Retorna el índice donde se encontró el valor
    mov x8, #93                           // Código de salida para ARM Linux
    svc #0                                // Llama al sistema para salir
