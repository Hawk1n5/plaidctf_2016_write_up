0x0 Intorduction
================

`butterfly: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=daad8fa88bfeef757675864191b0b162f8977515, not stripped`

This file is a 64-bit elf,and check some protector.

`
CANARY    : ENABLED

FORTIFY   : disabled

NX        : ENABLED

PIE       : disabled

RELRO     : disabled

`

Canary and NX is able,and server have ASLR.

0x1 Vulnerability
=================

In this elf,main function is small,It just do something like:

`
	read(buf);
	page = buf & 0xfffffffff000
	mprotect(page, 4096, 7);
	buf = "value";
	mprotect(page, 4096, 5);
`

I'm not found this value where can controller.But it's OK.In the main function:

`
	400860:	48 83 c4 48          	add    $0x48,%rsp
	
	400864:	5b                   	pop    %rbx
	
	400865:	41 5e                	pop    %r14
	
	400867:	41 5f                	pop    %r15
	
	400869:	5d                   	pop    %rbp
	
	40086a:	c3                   	retq  
`

Before exit main function.It will executable this code.

And we can user input address to modif 0x400860.so if we exit main function.

rsp will dont add 0x48,so we can controller rsp,But It just 16 bytes,because I cant controller value,

If controller value,and modif 0x400860 let rsp have more.

So when I input data,and return to main,that I can input again,

After many times,If rsp have enough gadget,We can ret to it and exec which I want.

btw.It didnt give me libc.so first time,need leak two libc addres and user libcdb to find libc verson.

