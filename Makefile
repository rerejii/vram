# マクロ定義
AS = nasm -fbin

# 生成, 起動
bochs: vram
	~y-takata/bochs

vram: vram.s
	$(AS) $<
