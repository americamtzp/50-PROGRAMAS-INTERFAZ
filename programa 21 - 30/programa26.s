/* 
Nombre: Operaciones Bitwise (AND, OR, XOR) en ensamblador ARM
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM realiza operaciones bitwise (AND, OR, XOR) entre dos valores hexadecimales y muestra los resultados.
Formato de salida: Imprime los resultados en formato hexadecimal de 64 bits.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        ulong value1 = 0x1234567812345678;
        ulong value2 = 0x8765432187654321;

        // Operaciones bitwise
        ulong andResult = value1 & value2;
        ulong orResult = value1 | value2;
        ulong xorResult = value1 ^ value2;

        Console.WriteLine("AND: {0:X16}", andResult);
        Console.WriteLine("OR:  {0:X16}", orResult);
        Console.WriteLine("XOR: {0:X16}", xorResult);
    }
}
*/

.data
    // Valores de entrada
    value1:      .quad   0x1234567812345678
    value2:      .quad   0x8765432187654321

    // Mensajes de salida
    msgAnd:      .string "AND: %016lX\n"
    msgOr:       .string "OR:  %016lX\n"
    msgXor:      .string "XOR: %016lX\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Realizar operaciones bitwise
    ldr     x2, =value1
    ldr     x3, =value2
    ldr     x2, [x2]
    ldr     x3, [x3]

    and     x4, x2, x3
    orr     x5, x2, x3
    eor     x6, x2, x3

    // Imprimir resultados
    adrp    x0, msgAnd
    add     x0, x0, :lo12:msgAnd
    mov     x1, x4
    bl      printf

    adrp    x0, msgOr
    add     x0, x0, :lo12:msgOr
    mov     x1, x5
    bl      printf

    adrp    x0, msgXor
    add     x0, x0, :lo12:msgXor
    mov     x1, x6
    bl      printf

    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret
