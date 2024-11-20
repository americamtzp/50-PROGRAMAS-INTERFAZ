/* 
Nombre: Detección de desbordamiento en suma de números enteros
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM realiza la suma de dos números enteros grandes, detecta si ocurre un desbordamiento y muestra el resultado o un mensaje de error.

Solución en C#:
#include <stdio.h>
#include <limits.h>  // Para obtener los valores máximos y mínimos de los tipos

// Función para detectar el desbordamiento en la suma
int detectarDesbordamiento(int a, int b) {
    // Comprobamos si la suma produce un desbordamiento
    if ((b > 0 && a > INT_MAX - b) || (b < 0 && a < INT_MIN - b)) {
        return 1; // Desbordamiento detectado
    }
    return 0; // No hay desbordamiento
}

int main() {
    int a, b;

    // Solicitar al usuario los dos números a sumar
    printf("Ingresa el primer número: ");
    scanf("%d", &a);
    printf("Ingresa el segundo número: ");
    scanf("%d", &b);

    // Verificar si hay desbordamiento
    if (detectarDesbordamiento(a, b)) {
        printf("¡Desbordamiento detectado!\n");
    } else {
        int suma = a + b;
        printf("La suma es: %d\n", suma);
    }

    return 0;
}

*/

.section .data
mensaje_no_overflow: .ascii "No hubo desbordamiento.\n"
mensaje_overflow:    .ascii "Desbordamiento detectado!\n"
mensaje_resultado:   .ascii "Resultado: %ld\n"
buffer:              .space 64

.section .text
.global _start

_start:
    // Números de entrada
    mov     x0, 9223372036854775800  // Número 1 (ejemplo)
    mov     x1, 100                 // Número 2 (ejemplo)

    // Realizar la suma con detección de desbordamiento
    adds    x2, x0, x1              // x2 = x0 + x1, actualiza flags
    bvs     desbordamiento          // Si el flag V está activo, ir a desbordamiento

    // No hubo desbordamiento
no_desbordamiento:
    // Imprimir mensaje de "No hubo desbordamiento"
    mov     x0, 1                   // FD para stdout
    ldr     x1, =mensaje_no_overflow
    mov     x2, 23                  // Longitud del mensaje
    mov     x8, 64                  // syscall write
    svc     0

    // Imprimir el resultado de la suma
    mov     x0, 1                   // FD para stdout
    ldr     x1, =buffer             // Buffer para formatear salida
    mov     x2, 64                  // Tamaño del buffer
    mov     x8, 64                  // syscall write
    svc     0
    b       fin                     // Terminar ejecución

desbordamiento:
    // Imprimir mensaje de "Desbordamiento detectado!"
    mov     x0, 1                   // FD para stdout
    ldr     x1, =mensaje_overflow
    mov     x2, 25                  // Longitud del mensaje
    mov     x8, 64                  // syscall write
    svc     0

fin:
    // Salir del programa
    mov     x8, 93                  // syscall exit
    mov     x0, 0                   // Código de salida
    svc     0
