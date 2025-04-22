.386
.model flat, stdcall
option casemap :none

include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
    input1      db 16 dup(0)
    input2      db 16 dup(0)
    input3      db 16 dup(0)
    resultStr   db 16 dup(0)
    response    db 4 dup(0)
    prompt1     db "Enter first number: ", 0
    prompt2     db "Enter second number: ", 0
    prompt3     db "Enter third number: ", 0
    resultMsg   db "The average is: ", 0
    askAgain    db "Do you want to enter another set? (y/n): ", 0
    newline     db 13, 10, 0
    exitMsg     db 13,10,"Thank you for coming!",13,10,0



.code
main:
startLoop:
    ; Prompt and input first number
    invoke StdOut, addr prompt1
    invoke StdIn, addr input1, 16
    invoke atodw, addr input1
    mov eax, eax
    mov ebx, eax        ; total = first input

    ; Prompt and input second number
    invoke StdOut, addr prompt2
    invoke StdIn, addr input2, 16
    invoke atodw, addr input2
    mov eax, eax
    add ebx, eax        ; total += second input

    ; Prompt and input third number
    invoke StdOut, addr prompt3
    invoke StdIn, addr input3, 16
    invoke atodw, addr input3
    mov eax, eax
    add ebx, eax        ; total += third input

    ; Compute average
    mov eax, ebx
    xor edx, edx
    mov ecx, 3
    div ecx             ; eax = average

    ; Convert and print average
    invoke dwtoa, eax, addr resultStr
    invoke StdOut, addr resultMsg
    invoke StdOut, addr resultStr
    invoke StdOut, addr newline

    ; Ask user if they want to repeat
    invoke StdOut, addr askAgain
    invoke StdIn, addr response, 4

    ; Check user's response
    mov al, byte ptr [response]
    cmp al, 'y'
    je startLoop
    cmp al, 'Y'
    je startLoop

    invoke StdOut, addr exitMsg

    ; Exit program
    invoke ExitProcess, 0
end main
