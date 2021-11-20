main proto
ExitProcess proto
.data
big byte 43h,3Ah,5Ch,57h,69h,6Eh,64h,6Fh,77h,73h,5Ch,53h,79h,73h,57h,4Fh,57h,36h,34h,5Ch,77h,73h,32h,5Fh,33h,32h,2Eh,64h,6Ch,6Ch       ; W64\ws2_32.dll
.code
main proc
  sub rsp,32
  mov rdx,offset big
  mov rdi,rdx
  mov rcx,lengthof big - 1
L2:
  push rcx
L1:
  mov al,byte ptr [rdx]
  xchg al,[rdx + 1]
  mov [rdx],al
  add rdx,1
  loop L1
  pop rcx
  mov rdx,rdi
  loop L2
  mov ecx,0
  call ExitProcess
main endp
end	