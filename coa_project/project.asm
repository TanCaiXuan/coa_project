.386
.387
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\msvcrt.lib 

extrn printf:proc  ; Use MASM32's printf

.data
    input1      db 16 dup(0)
    input2      db 16 dup(0)
    input3      db 16 dup(0)
    response    db 4 dup(0)
    prompt1     db "Enter first number: ", 0
    prompt2     db "Enter second number: ", 0
    prompt3     db "Enter third number: ", 0
    askAgain    db "Do you want to enter another set? (y/n): ", 0
    exitMsg     db 13, 10, "Thank you for coming!", 13, 10, 0
    floatFormat db "The average is: %.2f", 13, 10, 0
    three       dd 3

.data?
    resultFloat REAL8 ?

.code
main:
startLoop:
    ; Prompt and read first number
    invoke StdOut, addr prompt1
    invoke StdIn, addr input1, 16
    invoke atodw, addr input1
    push eax

    ; Prompt and read second number
    invoke StdOut, addr prompt2
    invoke StdIn, addr input2, 16
    invoke atodw, addr input2
    push eax

    ; Prompt and read third number
    invoke StdOut, addr prompt3
    invoke StdIn, addr input3, 16
    invoke atodw, addr input3
    push eax

    ; Floating point calculation
    fild dword ptr [esp]       ; third
    fild dword ptr [esp+4]     ; second
    faddp st(1), st(0)
    fild dword ptr [esp+8]     ; first
    faddp st(1), st(0)
    fild dword ptr [three]
    fdivp st(1), st(0)
    fstp resultFloat

    add esp, 12                ; clean up stack

    ; Print float 
    push dword ptr resultFloat+4    ; High part
    push dword ptr resultFloat      ; Low part
    push offset floatFormat
    call printf
    add esp, 12

    ; Ask to repeat
    invoke StdOut, addr askAgain
    invoke StdIn, addr response, 4
    mov al, byte ptr [response]
    cmp al, 'y'
    je startLoop
    cmp al, 'Y'
    je startLoop

    ; Exit
    invoke StdOut, addr exitMsg
    invoke ExitProcess, 0

end main
