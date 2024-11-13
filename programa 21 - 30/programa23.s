/* 
Autor: America Martinez Perez
Fecha: 5 de noviembre de 2024
Descripción: Este programa en ensamblador ARM64 muestra un mensaje en pantalla seguido del valor ASCII del carácter 'A' utilizando llamadas al sistema en Linux.

.global _start

.section .data
msg:    .asciz "El valor ASCII es: "
char:   .byte 65               // El valor ASCII de 'A'

.section .text
_start:
    // Escribir el mensaje en stdout
    mov x0, #1                  // Número de archivo: 1 = stdout
    ldr x1, =msg                // Dirección del mensaje
    ldr x2, =19                 // Longitud del mensaje
    mov x8, #64                 // Número de syscall para 'write'
    svc #0                      // Hacer la llamada al sistema

    // Escribir el valor ASCII (carácter 'A') desde la sección de datos
    mov x0, #1                  // Número de archivo: 1 = stdout
    ldr x1, =char               // Dirección del valor ASCII (carácter 'A')
    mov x2, #1                  // Longitud (1 byte)
    mov x8, #64                 // Número de syscall para 'write'
    svc #0                      // Hacer la llamada al sistema

    // Finalizar el programa
    mov x0, #0                  // Código de salida
    mov x8, #93                 // Número de syscall para 'exit'
    svc #0                      // Hacer la llamada al sistema
