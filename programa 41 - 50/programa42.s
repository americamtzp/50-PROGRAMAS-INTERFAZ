/* 
Nombre: Conversión de carácter hexadecimal a decimal
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM convierte un carácter hexadecimal ('0'-'9', 'A'-'F', 'a'-'f') en su valor decimal correspondiente. 
Si el carácter no es válido, retorna -1.

Solución en C#:
#include <stdio.h>
#include <stdlib.h>

int main() {
    char hexNumber[100]; // Cadena para almacenar el número hexadecimal

    // Leer el número hexadecimal
    printf("Introduce un número hexadecimal: ");
    scanf("%s", hexNumber);

    // Convertir a decimal usando strtol, especificando base 16
    int decimalNumber = (int)strtol(hexNumber, NULL, 16);

    // Mostrar el resultado
    printf("El número decimal es: %d\n", decimalNumber);

    return 0;
}

*/

.global hex_char_to_dec

// Convierte un carácter hexadecimal a decimal
// Entrada: w0 (carácter hexadecimal, como 'A' o 'F')
// Salida: w0 (valor decimal)
hex_char_to_dec:
    cmp w0, '0'
    blt invalid_hex               // Si es menor que '0', no es hexadecimal
    cmp w0, '9'
    ble convert_digit             // Si está entre '0' y '9', es dígito decimal

    cmp w0, 'A'
    blt invalid_hex               // Si es menor que 'A', no es hexadecimal
    cmp w0, 'F'
    ble convert_upper_letter      // Si está entre 'A' y 'F', es letra mayúscula

    cmp w0, 'a'
    blt invalid_hex               // Si es menor que 'a', no es hexadecimal
    cmp w0, 'f'
    ble convert_lower_letter      // Si está entre 'a' y 'f', es letra minúscula

invalid_hex:
    mov w0, -1                    // Retornar -1 si no es válido
    ret

convert_digit:
    sub w0, w0, '0'               // Convertir '0'-'9' a 0-9
    ret

convert_upper_letter:
    sub w0, w0, 'A'               // Convertir 'A'-'F' a 10-15
    add w0, w0, 10
    ret

convert_lower_letter:
    sub w0, w0, 'a'               // Convertir 'a'-'f' a 10-15
    add w0, w0, 10
    ret
