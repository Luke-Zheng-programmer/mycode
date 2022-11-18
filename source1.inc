diaoyong:
    sub rsp,64d
    cmp [hh],0
    jne L1
    push r8
    push rax
    mov rcx,user32
    mov rdx,0
    mov r8,8
    call qword [r14]   ;LoadLibraryExA
    mov qword [pig+8d],rax
    mov rcx,d3d12
    mov rdx,0
    mov r8,8
    call qword [r14]
    mov qword [pig+16d],rax
    mov rcx,gdi32
    mov rdx,0
    mov r8,8
    call qword [r14]
    mov qword [pig+24d],rax
    mov rcx,ole32
    mov rdx,0
    mov r8,8
    call qword [r14]
    mov qword [pig+32d],rax
    mov rcx,dxgi
    mov rdx,0
    mov r8,8
    call qword [r14]
    mov qword [pig+40d],rax
    pop rax
    pop r8
    L1:
    inc [hh]
    cmp r15,'1'
    jne L2
    mov rdi,[pig]          ;kernel32
    L2:
    cmp r15,'2'
    jne L3
    mov rdi,[pig+8]        ;user32
    L3:
    cmp r15,'3'
    jne L4
    mov rdi,[pig+16d]      ;d3d12
    L4:
    cmp r15,'4'
    jne L5                 ;gdi32
    mov rdi,[pig+24d]
    L5:
    cmp r15,'5'
    jne L6
    mov rdi,[pig+32d]      ;ole32
    L6:
    cmp r15,'6'
    jne L7
    mov rdi,[pig+40d]      ;dxgi
    L7:
    mov ebx,dword [rdi+3Ch]
    mov esi,dword [rdi+rbx+88h]
    add rsi,rdi
    mov ecx,dword [rsi+20h]
    add rcx,rdi
    mov rdx,[stay]
    add rsp,64d
    ret