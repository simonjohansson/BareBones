all: 
	mkdir -p out
	docker run -v $(CURDIR):/build -i -t simonjohansson/osdev i686-elf-as boot.s -o out/boot.o
	docker run -v $(CURDIR):/build -i -t simonjohansson/osdev i686-elf-gcc -c kernel.c -o out/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	docker run -v $(CURDIR):/build -i -t simonjohansson/osdev i686-elf-gcc -T linker.ld -o out/myos.bin -ffreestanding -O2 -nostdlib out/boot.o out/kernel.o -lgcc
	mkdir -p out/isodir
	mkdir -p out/isodir/boot
	cp out/myos.bin out/isodir/boot/myos.bin
	mkdir -p out/isodir/boot/grub
	cp grub.cfg out/isodir/boot/grub/grub.cfg
	grub-mkrescue -d /usr/lib/grub/i386-pc/ -o out/myos.iso out/isodir/

clean:
	rm -rf out	

boot-iso:
	qemu-system-i386 -cdrom out/myos.iso

boot-kernel:
	qemu-system-i386 -kernel out/myos.bin
