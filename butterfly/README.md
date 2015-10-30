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

In
