# �ޥ������
AS = nasm -fbin

# ����, ��ư
bochs: vram
	~y-takata/bochs

vram: vram.s
	$(AS) $<
