
format PE64 console

entry start

section '.text' code readable executable

 start:
    sub rsp,64
    mov r14,position
    mov rsi,[gs:60h]
    mov rsi,[rsi+18h]
    mov rsi,[rsi+30h]
    mov rsi,[rsi]
    mov rdi,[rsi+98h]
    mov r8,procname
    mov [pig],rdi

    pe:
    mov ebx,dword [rdi+3Ch]
    mov esi,dword [rdi+rbx+88h]
    add rsi,rdi
    mov ecx,dword [rsi+20h]
    add rcx,rdi
    mov rdx,[stay]


    name:
    inc rdx
    mov ebp,dword [rcx+rdx*4]
    add rbp,rdi
    mov r9,0
    mov r12,0


    name_loop:
    mov al,byte [r8+r9]
    mov bl,byte [rbp+r12]
    cmp al,"."
    je re
    inc r9
    jmp re2
    re:
    cmp byte [r8+r9+1],0
    jne out2
    mov r15,0
    jmp out1
    out2:
    mov r15,'1'
    pigs:
    cmp r15b,byte [r8+r9+1]
    je out1
    inc r15
    jmp pigs
    re2:
    inc r12
    cmp al,bl
    je name_loop
    jmp name
    out1:
    add r9,2
    add r8,r9
    mov eax,dword [rsi + 24h]
    add rax,rdi
    mov dx,word [rax+2*rdx]
    mov eax,dword [rsi+1Ch]
    add rax,rdi
    mov eax,dword [rax+4*rdx]
    add rdi,rax
    mov rax,[no]
    mov [r14+rax],rdi
    add [no],8
    cmp r15,0
    je outside
    call diaoyong
    jmp name
    outside:
    add rsp,8
    mov ecx,0
    call qword [r14+8]   ;ExitProcess

    include 'source1.inc'
section '.data' readable writeable
  position dq 50h dup (0)
  pig dq 40 dup (0)
  user32 db "User32.dll",0                ;2
  d3d12 db "D3D12.dll",0                  ;3
  gdi32 db "gdi32.dll",0                  ;4
  ole32 db "ole32.dll",0                  ;5
  dxgi  db "dxgi.dll",0                   ;6
  procname db "LoadLibraryExA.1ExitProcess.1QueryPerformanceFrequency.2LoadIconW.2LoadCursorW."
           db "4GetStockObject.2RegisterClassW.2AdjustWindowRect.2CreateWindowExW.2ShowWindow."
           db "2UpdateWindow.5CoCreateGuid.3D3D12GetDebugInterface.6CreateDXGIFactory1.3D3D12CreateDevice."
           db "1OutputDebugStringW.",0
  stay dq -1
  no dq 0
  hh dq 0