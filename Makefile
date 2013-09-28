hdd.img: boot/grub/grub.cfg boot/iron
	@echo "[IMG] hdd.img"
	@cp hdd.template.img hdd.img
	@sudo rm -rf hdd
	@sudo mkdir hdd
	@sudo mount -o loop,offset=1048576 hdd.img hdd
	@sudo rm -f hdd/boot/grub.cfg
	@sudo rm -rf hdd/boot/iron
	@sudo cp -rf boot/* hdd/boot/
	@sudo umount hdd
	@sudo rm -rf hdd
