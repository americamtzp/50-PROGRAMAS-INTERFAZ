/*
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM64 encuentra el segundo valor más grande en un arreglo de enteros. 
            La función `find_second_largest` toma como entrada un puntero al arreglo y el tamaño del arreglo, 
            y devuelve el segundo elemento más grande encontrado en el mismo.

#include <stdio.h>

// Declaraciones externas para las funciones en ensamblador
extern void init_pila();
extern long push(long value);
extern long pop();
extern int is_empty();

int main() {
    int option;
    long value, result;

    // Inicializar la pila
    init_pila();

    do {
        printf("\nMenu:\n");
        printf("1. Apilar\n");
        printf("2. Desapilar\n");
        printf("3. Verificar si la pila está vacía\n");
        printf("0. Salir\n");
        printf("Seleccione una opción: ");
        scanf("%d", &option);

        switch (option) {
            case 1:
                printf("Ingrese un valor a apilar: ");
                scanf("%ld", &value);
                result = push(value);
                if (result == -1) {
                    printf("Error: Desbordamiento de pila.\n");
                } else {
                    printf("%ld apilado.\n", value);
                }
                break;

            case 2:
                result = pop();
                if (result == -1) {
                    printf("Error: Pila vacía.\n");
                } else {
                    printf("Desapilado: %ld\n", result);
                }
                break;

            case 3:
                if (is_empty()) {
                    printf("La pila está vacía.\n");
                } else {
                    printf("La pila no está vacía.\n");
                }
                break;

            case 0:
                printf("Saliendo...\n");
                break;

            default:
                printf("Opción no válida.\n");
                break;
        }
    } while (option != 0);

    return 0;
}


*/

.global find_second_largest
find_second_largest:
    // Entradas: 
    // x0 = puntero al arreglo
    // x1 = tamaño del arreglo

    cmp x1, #2                // Si el tamaño es menor que 2, no hay segundo más grande
    blt end                   // Salir si el tamaño es menor que 2

    ldr w2, [x0]              // Primer elemento (maximo)
    ldr w3, [x0, #4]          // Segundo elemento (segundo máximo)
    cmp w2, w3                // Verificar si el primer elemento es mayor que el segundo
    bge init_max_second       // Si el primer elemento es mayor o igual, inicializar segundo máximo
    mov w2, w3                // Si no, el segundo máximo es el primero
    mov w3, w2                // Segundo máximo es el primero ahora

init_max_second:
    // Recorre el arreglo
    mov x4, #2                // Índice a partir de 2 (ya tenemos los dos primeros elementos)
loop:
    cmp x4, x1                // Verificar si hemos recorrido todo el arreglo
    bge end                   // Salir si hemos llegado al final

    ldr w5, [x0, x4, lsl #2]  // Cargar el siguiente elemento en el arreglo
    cmp w5, w2                // Comparar con el máximo
    bgt update_max            // Si el elemento es mayor que el máximo, actualizar el máximo

    cmp w5, w3                // Comparar con el segundo máximo
    bgt update_second         // Si es mayor que el segundo máximo, actualizar el segundo máximo
    b loop

update_max:
    mov w3, w2                // El segundo máximo ahora es el máximo actual
    mov w2, w5                // Actualizar el máximo con el nuevo valor
    b loop

update_second:
    mov w3, w5                // Actualizar el segundo máximo
    b loop

end:
    mov x0, w3                // El segundo máximo es el resultado
    ret
