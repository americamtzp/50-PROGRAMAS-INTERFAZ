/* 
Autor: America Martinez Perez
Verificación de Palíndromo en ensamblador ARM
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM solicita una palabra, verifica si es un palíndromo y muestra el resultado en pantalla.
Formato: Compara la palabra ingresada carácter por carácter desde el inicio y el final hacia el centro para determinar si es un palíndromo.

Solución en C#:
using System;

class Program
{
    static void Main()
    {
        Console.Write("Introduce una palabra: ");
        string input = Console.ReadLine()?.Trim();

        bool isPalindrome = true;
        for (int i = 0, j = input.Length - 1; i < j; i++, j--)
        {
            if (input[i] != input[j])
            {
                isPalindrome = false;
                break;
            }
        }

        Console.WriteLine(isPalindrome ? "Es palindromo" : "No es palindromo");
    }
}
*/

.global _start

.section .data
prompt: .asciz "Introduce una palabra: "
msg_palindrome: .asciz "Es palindromo\n"
msg_not_palindrome: .asciz "No es palindromo\n"

.section .bss
input_buffer: .skip 100  // Reservamos espacio para la entrada

.section .text
_start:
    // Imprimir el mensaje de solicitud
    mov x0, 1              // Descriptor de archivo para stdout
    ldr x1, =prompt         // Dirección del mensaje
    mov x2, 23              // Longitud del mensaje
    mov x8, 64              // syscall para escribir
    svc 0                   // Llamada al sistema

    // Leer la entrada del usuario
    mov x0, 0              // Descriptor de archivo para stdin
    ldr x1, =input_buffer   // Dirección del buffer de entrada
    mov x2, 100            // Número máximo de caracteres
    mov x8, 63             // syscall para leer
    svc 0                  // Llamada al sistema

    // Eliminar el salto de línea (\n) si lo hay
    ldr x3, =input_buffer   // Dirección del buffer
remove_newline:
    ldrb w4, [x3]          // Cargar un byte
    cmp w4, 10             // Comparar con '\n' (código 10)
    beq end_remove_newline // Si es salto de línea, terminar
    add x3, x3, 1          // Mover al siguiente byte
    b remove_newline
end_remove_newline:

    // Calcular la longitud de la cadena ingresada (sin el salto de línea)
    ldr x1, =input_buffer   // Dirección del buffer
    mov x2, 0              // Contador de longitud
find_length:
    ldrb w3, [x1, x2]      // Cargar un byte de la cadena
    cbz w3, done_length    // Si es el final de la cadena (null byte), salir
    add x2, x2, 1          // Incrementar el contador de longitud
    b find_length
done_length:

    // Verificar si la cadena es un palíndromo
    mov x3, x2              // Copiar longitud a x3
    sub x3, x3, 1           // x3 = longitud - 1 (índice final)
    mov x4, 0               // x4 = índice inicial (0)

check_palindrome:
    ldrb w5, [x1, x4]       // Cargar el carácter desde el inicio
    ldrb w6, [x1, x3]       // Cargar el carácter desde el final
    cmp w5, w6              // Comparar los dos caracteres
    bne not_palindrome      // Si no son iguales, no es palíndromo

    // Mover los índices hacia el centro
    add x4, x4, 1           // Incrementar el índice inicial
    sub x3, x3, 1           // Decrementar el índice final
    cmp x4, x3              // Comparar los índices
    ble check_palindrome    // Si el índice inicial es menor o igual al final, continuar

    // Si todo es correcto, es un palíndromo
    mov x0, 1               // Descriptor de archivo para stdout
    ldr x1, =msg_palindrome // Dirección del mensaje "Es palíndromo"
    mov x2, 15              // Longitud del mensaje
    mov x8, 64              // syscall para escribir
    svc 0                   // Llamada al sistema
    b end_program           // Salto al final del programa

not_palindrome:
    mov x0, 1               // Descriptor de archivo para stdout
    ldr x1, =msg_not_palindrome // Dirección del mensaje "No es palíndromo"
    mov x2, 18              // Longitud del mensaje
    mov x8, 64              // syscall para escribir
    svc 0                   // Llamada al sistema

end_program:
    mov x8, 93              // syscall para salir
    mov x0, 0               // Código de salida
    svc 0                   // Llamada al sistema
