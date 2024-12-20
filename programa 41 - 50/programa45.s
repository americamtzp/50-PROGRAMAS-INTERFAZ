/*
Nombre: Verificación de Números de Armstrong en Ensamblador ARM
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa solicita un número al usuario, verifica si es un número de Armstrong y muestra el resultado.
Un número de Armstrong es un número que es igual a la suma de sus dígitos elevados a la potencia del número de dígitos.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce un número: ");
        string input = Console.ReadLine();

        if (!int.TryParse(input, out int number))
        {
            Console.WriteLine("Error: Entrada inválida. Solo se permiten números.");
            return;
        }

        int sum = 0, original = number;
        while (number > 0)
        {
            int digit = number % 10;
            sum += digit * digit * digit;
            number /= 10;
        }

        if (sum == original)
            Console.WriteLine("Es un número de Armstrong");
        else
            Console.WriteLine("No es un número de Armstrong");
    }
}
*/

.section .data
prompt_msg: .asciz "Introduce un número:\n"          // Mensaje para solicitar número
error_msg: .asciz "Error: Entrada inválida. Solo se permiten números.\n"
msg_armstrong: .asciz "Es un número de Armstrong\n"  // Mensaje si es Armstrong
msg_not_armstrong: .asciz "No es un número de Armstrong\n" // Mensaje si no es Armstrong
buffer: .space 10                                    // Buffer para almacenar la entrada del usuario

.section .text
.global _start

_start:
    // Solicitar número al usuario
    mov x0, 1
    ldr x1, =prompt_msg
    mov x2, 21                        // Tamaño del mensaje
    mov x8, 64                        // Syscall write (64 para ARM64)
    svc 0

    // Leer entrada del usuario
    mov x0, 0
    ldr x1, =buffer
    mov x2, 10                        // Tamaño máximo a leer
    mov x8, 63                        // Syscall read (63 para ARM64)
    svc 0

    // Convertir cadena a número (atoi simple con validación)
    ldr x1, =buffer
    mov w0, 0                         // Inicializamos el número (num = 0)
    mov w4, 10                        // Constante 10 para multiplicar en `atoi_loop`

atoi_loop:
    ldrb w2, [x1], #1                 // Leer siguiente carácter
    cmp w2, 10                        // Comparar con '\n' (fin de entrada)
    beq end_atoi                      // Si es '\n', terminar conversión
    cmp w2, '0'                       // Verificar si es menor que '0'
    blt error                         // Si es menor, error
    cmp w2, '9'                       // Verificar si es mayor que '9'
    bgt error                         // Si es mayor, error
    sub w2, w2, '0'                   // Convertir a número
    mul w0, w0, w4                    // Multiplicar acumulador por 10
    add w0, w0, w2                    // Agregar dígito
    b atoi_loop                       // Repetir para el siguiente carácter

end_atoi:
    // Verificación del número de Armstrong
    mov w1, w0                        // Guardamos el número original
    mov w2, 0                         // Inicializamos sum a 0

check_armstrong:
    mov w3, w1
    mov w4, 10
    udiv w5, w3, w4
    msub w6, w5, w4, w3               // Obtener dígito
    mul w7, w6, w6
    mul w7, w7, w6
    add w2, w2, w7
    mov w1, w5
    cmp w1, 0
    bne check_armstrong

    // Comparar la suma calculada
    cmp w2, w0
    bne not_armstrong

    // Es un número de Armstrong
    ldr x0, =msg_armstrong
    mov x2, 27                        // Tamaño del mensaje de Armstrong con \n
    b print_message                   // Saltar a imprimir mensaje y terminar

not_armstrong:
    ldr x0, =msg_not_armstrong        // No es un número de Armstrong
    mov x2, 31                        // Tamaño del mensaje de No Armstrong con \n

print_message:
    mov x1, x0
    mov x0, 1                         // File descriptor (stdout)
    mov x8, 64                        // Syscall write
    svc 0
    b end                             // Finalizar el programa

error:
    // Imprimir mensaje de error
    ldr x0, =error_msg
    mov x1, x0
    mov x2, 44                        // Tamaño del mensaje de error
    mov x8, 64                        // Syscall write
    svc 0

end:
    mov x8, 93                        // Syscall exit
    mov x0, 0                         // Código de salida 0
    svc 0
