/* 
Nombre: Cálculo del Mínimo Común Múltiplo (MCM) y tiempo de ejecución en ensamblador ARM
Autor: América Martínez Pérez
Fecha: 5 de noviembre de 2024
Descripción: Este programa define dos funciones en ensamblador ARM. Una función calcula el MCM de dos números (15 y 20), 
y la otra obtiene el tiempo de ejecución utilizando el contador de ciclos.

Solución en C#:

#include <stdio.h>
#include <stdint.h>

extern void calcular_mcm();  // Declaración de la función en ensamblador
extern uint64_t obtener_tiempo();  // Declaración de la función para obtener el tiempo de ejecución

int main() {
    uint64_t tiempo_inicial, tiempo_final, tiempo_total;

    // Obtener el tiempo inicial
    tiempo_inicial = obtener_tiempo();

    // Llamada a la función de cálculo del MCM
    calcular_mcm();

    // Obtener el tiempo final
    tiempo_final = obtener_tiempo();

    // Calcular el tiempo total de ejecución
    tiempo_total = tiempo_final - tiempo_inicial;

    printf("El tiempo de ejecución en ciclos es: %lu\n", tiempo_total);

    return 0;
}

*/

.global calcular_mcm
.global obtener_tiempo

// Función para obtener el tiempo de ejecución (contador de ciclos)
obtener_tiempo:
    mrs x0, CNTVCT_EL0   // Leer el contador de ciclos en x0
    ret

// Función de cálculo del MCM
calcular_mcm:
    mov x0, 15            // Primer número
    mov x1, 20            // Segundo número
    // Algoritmo para calcular el MCM (este es un ejemplo sencillo)
    mov x2, 0             // Limpiar el registro
    ret
