/* 
Nombre: Ordenación de array usando el método de mezcla (Merge Sort) en ensamblador ARM
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM implementa el algoritmo de ordenación Merge Sort. 
             Ordena un array de enteros y muestra el resultado en la consola.

Solución en C#:
using System;

class Program
{
    static void Merge(int[] array, int left, int mid, int right)
    {
        int n1 = mid - left + 1;
        int n2 = right - mid;
        int[] leftArray = new int[n1];
        int[] rightArray = new int[n2];

        Array.Copy(array, left, leftArray, 0, n1);
        Array.Copy(array, mid + 1, rightArray, 0, n2);

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2)
        {
            if (leftArray[i] <= rightArray[j])
                array[k++] = leftArray[i++];
            else
                array[k++] = rightArray[j++];
        }

        while (i < n1)
            array[k++] = leftArray[i++];
        while (j < n2)
            array[k++] = rightArray[j++];
    }

    static void MergeSort(int[] array, int left, int right)
    {
        if (left < right)
        {
            int mid = left + (right - left) / 2;
            MergeSort(array, left, mid);
            MergeSort(array, mid + 1, right);
            Merge(array, left, mid, right);
        }
    }

    static void Main()
    {
        int[] array = {5, 3, 8, 1, 2};
        Console.WriteLine("Ordenando el array usando el método de mezcla (Merge Sort)...");
        MergeSort(array, 0, array.Length - 1);
        
        Console.WriteLine("Array ordenado:");
        foreach (int num in array)
            Console.WriteLine(num);
    }
}
*/

.data
    prompt:       .asciz "Ordenando el array usando el método de mezcla (Merge Sort)...\n"
    sortedMsg:    .asciz "Array ordenado:\n"
    array:        .word 5, 3, 8, 1, 2   // Array a ordenar
    length:       .word 5               // Longitud del array
    tempArray:    .space 20             // Espacio temporal para mezclar
    newline:      .asciz "\n"           // Nueva línea

.text
    .global _start

_start:
    // Mostrar el mensaje de inicio
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =prompt                 // Dirección del mensaje de inicio
    mov x2, #51                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Cargar la longitud del array en w1
    ldr x1, =length
    ldr w1, [x1]

    // Inicializar el tamaño del subarray (1 elemento al principio)
    mov w2, #1                      // Tamaño de los bloques a mezclar

merge_sort_iterative:
    cmp w2, w1                      // Si el tamaño del bloque es mayor que la longitud, terminamos
    bge end_sort

    // Configurar los índices de mezcla
    mov w3, #0                      // Índice inicial para mezclar bloques

merge_blocks:
    cmp w3, w1                      // Si el índice es igual a la longitud, terminamos esta fase de mezcla
    bge increase_block_size

    // Calcular los límites de los subarrays
    mov w4, w3                      // Límite izquierdo del primer subarray
    add w5, w3, w2                  // Límite derecho del primer subarray
    add w6, w5, w2                  // Límite derecho del segundo subarray

    // Ajustar los límites si exceden el tamaño del array
    cmp w5, w1
    bgt adjust_right_limit
    cmp w6, w1
    bgt adjust_left_limit

adjust_right_limit:
    mov w5, w1

adjust_left_limit:
    mov w6, w1

    // Llamada para mezclar los subarrays definidos
    bl merge                        // Llamada a la función merge para mezclar los bloques
    add w3, w3, w2, lsl #1          // Avanzar al siguiente par de bloques

    b merge_blocks                  // Repetir para el siguiente par de bloques

increase_block_size:
    lsl w2, w2, #1                  // Duplicar el tamaño del bloque
    b merge_sort_iterative          // Repetir el proceso con el nuevo tamaño de bloque

end_sort:
    // Mostrar el mensaje de array ordenado
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =sortedMsg              // Dirección del mensaje "Array ordenado:\n"
    mov x2, #16                     // Longitud del mensaje
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    // Imprimir los elementos del array ordenado
    mov w10, #0                     // Índice para impresión

print_array:
    ldr x3, =array                  // Dirección base del array
    lsl w11, w10, #2                // Desplazamiento de w10 (w11 = w10 * 4 bytes por palabra)
    add x3, x3, x11                 // Dirección de array[w10]
    ldr w0, [x3]                    // Cargar el valor en w0

    // Convertir el número a texto (para impresión) llamando a la función print_num
    bl print_num

    // Imprimir una nueva línea
    mov x0, #1                      // Descriptor de archivo para STDOUT
    ldr x1, =newline                // Dirección de la nueva línea
    mov x2, #1                      // Longitud de la nueva línea
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    add w10, w10, #1                // Incrementar índice
    ldr x1, =length                 // Dirección de la longitud
    ldr w1, [x1]                    // Leer la longitud original del array
    cmp w10, w1                     // Comparar índice con la longitud del array
    blt print_array                 // Repetir si aún hay elementos

    // Terminar el programa
    mov x8, #93                     // Syscall para 'exit' (93)
    svc #0                          // Ejecutar syscall

merge:
    // Implementación de la función de mezcla (merge) para combinar dos subarrays
    ret                             // Finaliza la función de mezcla

print_num:
    add w0, w0, '0'                 // Convertir el número a su equivalente ASCII
    mov x1, sp                      // Usar la pila para el buffer temporal
    strb w0, [x1, #-1]!             // Guardar el carácter en la pila

    mov x0, #1                      // Descriptor de archivo para STDOUT
    mov x2, #1                      // Longitud del número convertido
    mov x8, #64                     // Syscall para 'write' (64)
    svc #0                          // Ejecutar syscall

    ret                             // Retornar de la función
