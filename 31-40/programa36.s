// nano 36.c
/*
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Programa en C que calcula el segundo número máximo de una lista de enteros almacenada en ensamblador ARM64.

Solución en C:
#include <stdio.h>

// Declaración de la función ensambladora
extern void find_second_max();

// Declaración de la variable second_max que se encuentra en el ensamblador
extern int second_max;

int main() {
    // Llamar a la función en ensamblador que calcula el segundo máximo
    find_second_max();

    // Leer el segundo máximo desde la memoria y mostrarlo
    printf("El segundo máximo es: %d\n", second_max);

    return 0;
}
*/

// nano 36.s
.global find_second_max
.global second_max

.section .data
nums: 
    .word 4, 9, 2, 7, 5, 10, 3  // Lista de números
nums_len: 
    .word 7  // Longitud de la lista
second_max: 
    .word 0  // Inicializamos second_max a 0

.section .text
find_second_max:
    ldr x0, =nums       // Cargar la dirección de la lista de números
    ldr x1, =nums_len   // Cargar la dirección de la longitud de la lista
    ldr w1, [x1]        // Obtener la longitud de la lista (número de elementos)
    
    // Inicializamos los valores del máximo y segundo máximo
    mov x2, #0          // max = 0
    mov x3, #0          // second_max = 0
    
loop:
    cmp w1, #0
    beq end_loop

    ldr w4, [x0], #4    // Cargar el siguiente número en w4 y mover x0 al siguiente número

    cmp w4, w2
    ble not_new_max     // Si w4 no es mayor que el máximo, saltar

    mov x3, x2          // El segundo máximo es el antiguo máximo
    mov x2, x4          // El nuevo máximo es el número actual
    b continue_loop

not_new_max:
    cmp w4, w3
    ble continue_loop   // Si w4 no es mayor que el segundo máximo, continuar

    mov x3, x4          // Actualizar segundo máximo

continue_loop:
    sub w1, w1, #1      // Decrementar la longitud restante
    b loop              // Repetir el bucle

end_loop:
    // Guardar el segundo máximo en la memoria
    ldr x0, =second_max // Cargar la dirección de second_max
    str w3, [x0]        // Guardamos el segundo máximo en la dirección de second_max
    
    ret
