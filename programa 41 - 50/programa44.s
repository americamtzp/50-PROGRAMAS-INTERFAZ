/* 
Nombre: Generador de números pseudoaleatorios en ensamblador ARM
Autor: América Martínez Pérez
Fecha: 5 de noviembre de 2024
Descripción: Este programa implementa un generador de números pseudoaleatorios basado en la fórmula lineal congruencial:
             semilla = (semilla * 1103515245 + 12345) & 0x7FFFFFFF
             El resultado es un número en el rango [0, 2^31-1].

Solución en C#:
#include <stdio.h>

// Declaración de la función en ensamblador
extern int GenerarAleatorio(int semilla);

int main() {
    int semilla, cantidad;

    // Solicitar al usuario la semilla
    printf("Introduce una semilla: ");
    scanf("%d", &semilla);

    // Solicitar al usuario cuántos números aleatorios generar
    printf("¿Cuántos números aleatorios deseas generar? ");
    scanf("%d", &cantidad);

    // Generar y mostrar los números aleatorios
    printf("Números aleatorios generados:\n");
    for (int i = 0; i < cantidad; i++) {
        semilla = GenerarAleatorio(semilla);  // Actualiza la semilla para el siguiente número
        printf("%d\n", semilla);
    }

    return 0;
}

*/

.global GenerarAleatorio

GenerarAleatorio:
    // w0 contiene la semilla de entrada

    // Cargar el valor 1103515245 en w1 usando instrucciones separadas
    movz w1, 0x49E3        // Parte inferior del número (16 bits)
    movk w1, 0x4E35, lsl #16  // Parte superior del número (añadir a los bits altos)

    mov w2, 12345          // Incremento

    // Realizar el cálculo: semilla = (semilla * 1103515245 + 12345) & 0x7FFFFFFF
    mul w0, w0, w1         // Multiplica semilla por 1103515245
    add w0, w0, w2         // Suma 12345
    and w0, w0, 0x7FFFFFFF // Asegurarse de que esté en el rango de 0 a 2^31-1
    ret
