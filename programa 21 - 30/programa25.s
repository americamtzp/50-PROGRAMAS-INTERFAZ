/*
Nombre: Contador de vocales y consonantes
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Programa en C que utiliza una función en ensamblador ARM para contar el número de vocales y consonantes en una cadena de caracteres.


#include <stdio.h>

// Declaración de la función ensambladora
extern void count_vowels_consonants(const char *str, int *vowels, int *consonants);

int main() {
    const char *text = "Hello, World!";
    int vowels = 0;
    int consonants = 0;

    // Llamar a la función ensambladora para contar vocales y consonantes
    count_vowels_consonants(text, &vowels, &consonants);

    // Imprimir los resultados
    printf("Vocales: %d\n", vowels);
    printf("Consonantes: %d\n", consonants);

    return 0;
}
*/

.global count_vowels_consonants  // Hacer la función accesible desde C

.text
count_vowels_consonants:
    mov x3, #0  // Inicializar contador de vocales en 0
    mov x4, #0  // Inicializar contador de consonantes en 0

loop:
    ldrb w5, [x0], #1  // Cargar un byte de la cadena (carácter)
    cbz w5, end_loop    // Si el carácter es null terminator (0), salir del bucle

    // Verificar si el carácter es una vocal (en minúscula o mayúscula)
    cmp w5, #'a'  // Comparar con 'a'
    beq count_vowel
    cmp w5, #'e'  // Comparar con 'e'
    beq count_vowel
    cmp w5, #'i'  // Comparar con 'i'
    beq count_vowel
    cmp w5, #'o'  // Comparar con 'o'
    beq count_vowel
    cmp w5, #'u'  // Comparar con 'u'
    beq count_vowel
    cmp w5, #'A'  // Comparar con 'A'
    beq count_vowel
    cmp w5, #'E'  // Comparar con 'E'
    beq count_vowel
    cmp w5, #'I'  // Comparar con 'I'
    beq count_vowel
    cmp w5, #'O'  // Comparar con 'O'
    beq count_vowel
    cmp w5, #'U'  // Comparar con 'U'
    beq count_vowel

    // Si no es vocal, verificar si es consonante (letras del alfabeto)
    cmp w5, #'a'  // Si es una letra minúscula
    blt skip_consonant
    cmp w5, #'z'
    bgt skip_consonant
    add x4, x4, #1  // Incrementar contador de consonantes
    b loop

count_vowel:
    add x3, x3, #1  // Incrementar contador de vocales
    b loop

skip_consonant:
    b loop

end_loop:
    // Guardar los resultados en las direcciones de memoria pasadas
    str w3, [x1]   // Guardar el número de vocales
    str w4, [x2]   // Guardar el número de consonantes
    ret
