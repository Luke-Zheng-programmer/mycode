ExitProcess proto
.data
mg0 byte "WSAStartup",0	;  0A6,88			   89,0A5h
mg1 byte "LoadLibraryExA",0 ;,88			   89,09Ch	6	   0AFh
mg2 byte "CreateProcessA",0   ;0CC,88		   89,0C7h	5
mg3 byte "ExitProcess",0	   ;29h,88		   89,27h	4		87h
mg4 byte "socket",0		  ;091h,88			   89,8Eh
mg5 byte "send",0		 ;32h,88			   89,33h
mg6 byte "listen",0		;87h ,88			   89,88h
mg7 byte "WSACleanup",0	  ;0DBh,88			   89,0D8h
mg8 byte "Sleep",0	  ;39h,88				   89,39h			 92h
mg9	byte "recv",0		;28h ,88			   89,29h
mg10 byte "htons",0		 ;4Ch ,88			   89,4Eh
mg11 byte "inet_addr",0	 ;0Ah ,88			   89,0Ch
mg12 byte "WSAGetLastError",0 ;89h,88		   89,87h	
mg13 byte "bind",0			;  35h,88		   89,38h
mg14 byte "accept",0	 ;98h,88			   89,97h
mg15 byte "closesocket",0	   ;9Fh,88		   89,99h	 1
mg16 byte "gethostname",0		;9Fh,88		   89,9Dh	 
mg17 byte "gethostbyname",0		;			   89,0F8h
mg18 byte "ReadConsoleA",0		;6Fh,88		   89,85h	 3
mg19 byte "GetStdHandle",0		;7Fh,88		   89,82h	 2
mg20 byte "WriteConsoleA",0		;			   89,9Bh	 1
.code
main proc
  mov dl,0
  mov rsi,offset mg0
L1:
  mov al,[rsi]
  xor al,89
  add dl,al
  inc rsi
  cmp al,89
  jne L1
  mov ecx,0
  call ExitProcess
main endp
end
  