/* 
Nombre: Encontrar el mínimo en un arreglo en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM recorre un arreglo de enteros para encontrar el valor mínimo y lo utiliza como código de salida del sistema.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        int[] array = { 12, 3, 5, 7, 1, 9, 2 };
        int min = array[0];
        
        foreach (int num in array)
        {
            if (num < min)
                min = num;
        }
        
        Console.WriteLine("El valor mínimo del arreglo es: " + min);
    }
}
*/

.section .data
array:      .word 12, 3, 5, 7, 1, 9, 2    // Arreglo de ejemplo
array_size: .word 7                       // Tamaño del arreglo (número de elementos)

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección del primer elemento
    adrp x1, array_size      
