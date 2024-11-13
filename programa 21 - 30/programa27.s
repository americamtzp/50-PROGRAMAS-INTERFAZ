/* 
Nombre: Operaciones de desplazamiento de bits en ensamblador ARM
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM realiza desplazamientos de bits a la izquierda y a la derecha sobre un número de 64 bits y muestra los resultados.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        ulong x = 0x1234567812345678;   // Número de 64 bits
        ulong y = 5;                    // Número de bits para desplazar

        Console.WriteLine("Valor de x: {0:X16}", x);
        Console.WriteLine("Valor de y: {0:X16}", y);

        ulong leftShiftResult = x << (int)y;
        Console.WriteLine("Desplazamiento a la izquierda: {0:X16}", leftShiftResult);

        ulong rightShiftResult = x >> (int)y;
        Console.WriteLine("Desplazamiento a la derecha: {0:X16}", rightShiftResult);
    }
}
*/

.data
    x:      .quad   0x1234567812345678    // Número de 64 bits
    y:      .quad   0x0000000000000005    // Número de 64 bits
    
    msgX:    .string "Valor de x: %016lX\n"
    msgY:    .string "Valor de y: %016lX\n"
    msgLeft: .string "Desplazamiento a la izquierda: %016lX\n"
    msgRight:.string "Desplazamiento a la derecha: %016lX\n"
    newline: .string "\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Imprimir valor de x
    adrp    x0, msgX
    add     x0, x0, :lo12:msgX
    mov     x1, x
    bl      printf
    
    // Imprimir valor de y
    adrp    x0, msgY
    add     x0, x0, :lo12:msgY
    mov     x1, y
    bl      printf
    
    // Desplazamiento a la izquierda
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_left
    
    // Desplazamiento a la derecha
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_right
    
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para desplazamiento a la izquierda
shift_left:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsl     x0, x0, x1                 // Desplazar x a la izquierda por y bits
    
    // Imprimir resultado
    adrp    x0, msgLeft
    add     x0, x0, :lo12:msgLeft
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret

// Función para desplazamiento a la derecha
shift_right:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsr     x0, x0, x1                 // Desplazar x a la derecha por y bits
    
    // Imprimir resultado
    adrp    x0, msgRight
    add     x0, x0, :lo12:msgRight
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret
