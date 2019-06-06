; 下記に掲載のプログラムを基に作成した:
; http://d.hatena.ne.jp/rudeboyjet/20080108/p1
; テキストVRAMの使い方は下記を参照:
; https://en.wikipedia.org/wiki/VGA-compatible_text_mode
	; 一行80
	; ブートストラップコードは Real-address mode で実行されるので,
	; 32ビットの番地を指定しても下位16ビットのみ使用される.
	; AX, CX, DXは番地の指定に使えない (EAX, ECX, EDXは使える).

	org	0x7c00		; 開始番地
	mov	ax, 0xB800
	mov	ds, ax		; セグメントレジスタにVRAMの番地を代入
	mov	bx, 0		; VRAM上の番地
str:
	mov	cx, 80 * 25	; 画面全体を対象のカウント
	mov	al, 0		; 空白文字
	mov	ah, 31		; 背景青
	mov	dl, 0		; カウントに使う
white:
	cmp	dl, 5		; カウント5なら
	je	nami		; 波の発生
	inc	dl		; カウント増加
	mov	[bx], ax	; 文字と属性をVRAMに書き込む(海)
white2:			; データ量削減のための共通部分
	add	bx, 2 		; 移動
	dec	cx		; 残り回数を減らす
	cmp	cx, 0		; 残り回数確認
	jne	white		; 0でなければループ
	jmp	second		; 終われば次に進む
nami:
	mov	dl, 0		; カウントリセット
	mov	al,0x5e	; 波の表現用文字
	mov	[bx], ax	; 文字と属性をVRAMに書き込む
	mov	al, 0		; 空白文字にリセット
	jmp	white2		; 共通部文に飛ぶ
;---------------------------------------------------- 
second:			; 本体
	mov	bx, 42		; VRAM上の番地
	mov	si, data	; dataの番地を取り出す
	mov	cx, 18		; ループ回数
	mov	al, 219	; 字の調整
c_change:			; カラーを変えるメソッド
	mov	ah, [cs:si]	; カラーを取り出す 
	inc	si		; 読み込むdata番地を進める
	cmp	ah, '@'	; @は終了
	je	stop		; 一時停止用メソッドに飛ぶ
	sub	ah, '0'	; 文字データを数値データに置き換える
	mov	dl, [cs:si]	; 同じカラーがいくつ続くかのデータ取得
	sub	dl, '0'	; 文字データを数値データに置き換える
	inc	si		; 読み込むdata番地を進める
loop0:				; キャラクターを書き込むループ
	mov	[bx], ax	; 文字と属性をVRAMに書き込む
	add	bx, 2 		; 番地を進める
	mov	[bx], ax	; 文字と属性をVRAMに書き込む
	add	bx, 2 		; 番地を進める
	dec	dl		; 色変えるまでのカウント減少
	dec	cx		; 改行残り回数を減らす
	cmp	cx, 0		; 改行残り回数0なら
	je	next		; 改行用メソッドを起動
	cmp	dl, 0		; カラーカウントが0なら
	je	c_change	; カラーを変えるメソッド起動
	jmp	loop0		; すべて0でなければループ
next:				; 改行用メソッド
	mov	cx, 18		; 改行カウントのリセット
	add	bx, 2 * 44	; 改行
	cmp	dl, 0		; カラーカウントが0なら
	je	c_change	; カラーを変えるメソッド起動
	jmp	loop0		; loopに戻れ
stop:				; 停止用メソッド
	mov	ah, 00H	; タイマーBIOS呼び出しコマンド格納
	int	1AH		; タイマーBIOS
	mov	[cs:time1], dx; 現在の時刻格納
	add	dword[cs:time1], 182; 起動時刻の設定
stoploop:			; 起動までの停止ループ
	mov	ah, 00H	; タイマーBIOS呼び出しコマンド格納
	int	1AH		; タイマーBIOS
	mov	bx, [cs:time1]; 起動時刻の格納	
	cmp	bx,dx		; 起動時刻かの判定
	jge	stoploop	; 起動時刻でないならloop
	jmp	end		; 起動時刻なら次のメソッドへ
end:				; 次の描写用のデータの設定用メソッド
	add	dword[cs:count],4;波の場所用のカウントを増やす
	mov	ax, [cs:count]; 割り算用にデータを格納
	mov	dx, 0		; 割り算前の準備	
	mov	bx, 12		; 12で割る
	div	bx		; 割り算
	mov	bx, dx		; 余りを、次の波の開始位置に格納
	jmp	str		; スタートに飛べ

	data:	db	'95829?8192819?869:899882>5849782>181>286968<94>18;>1829483?188>2?19383?184?1869386?181?1879284?383?1859283?481?181?1849382<1?6849682<1?4<2839683<58594819182?58593819281?3<1?181?1859481?1<1>1<1?1>181?2829581<1?2=1>2?3<1839481?4>1?3<1?2829481<1?3>1?281?38493?383?181<2?28394?283?5<1?38192?384?281?2<183@',
	time1: dw 0
	count:  db 	0
	times   510-($-$$) db 0 ; セクタ末尾まで0で埋める ($$は開始番地)
        db      0x55, 0xaa      ; Boot Signature
