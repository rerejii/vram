import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.awt.Color;
import java.io.File;

class dot{
  /* 色の値の取得準備 */
	static ImageUtility iu = new ImageUtility();
	static int brack = iu.rgb(0,0,0);
	static int whilt = iu.rgb(255,255,255);

  public static void main(String args[]){
    try{
      /* 入力画像の読み込み */
			BufferedImage readImage = ImageIO.read(new File(args[0])); //第一引数をファイル名とする
			int w = readImage.getWidth(); //横幅
			int h = readImage.getHeight(); //縦幅
      File file = new File("out.txt");
      FileWriter filewriter = new FileWriter(file);
      /* 出力画像の準備 */
			BufferedImage writeImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
      pic_16(readImage, writeImage, w,h);
      /* output.pngへの書き込み */
      ImageIO.write(writeImage, "png", new File("output.png"));
      txt_16(writeImage, file, filewriter, w, h);
    }catch (IOException e){
			/* 例外処理 */
			throw new RuntimeException(e.toString());
		}
		System.out.println("画像処理が完了しました");
  }

  public static void pic_16(BufferedImage readImage, BufferedImage writeImage, int w, int h){
		// 1ピクセルづつ処理を行う
    // 0:B,1:g,2:r,3:a
		for (int y = 0; y < h; y++) {
		  for (int x = 0; x < w; x++) {
				int color = readImage.getRGB(x, y); // 入力画像の画素値を取得
				//int c = (iu.r(color) + iu.g(color) + iu.b(color)) / 3;
        int a = iu.a(color);
        int r = iu.r(color);
        int g = iu.g(color);
        int b = iu.b(color);
        int s = 122;
        //--------------------
        if(a > s){
          a = 255;
        }else{
          a = 0;
        }
        if(r > s){
          r = 255;
        }else{
          r = 0;
        }
        if(g > s){
          g = 255;
        }else{
          g = 0;
        }
        if(b > s){
          b = 255;
        }else{
          b = 0;
        }
        //---------------------
        color = iu.argb(a,r,g,b);
        writeImage.setRGB(x, y, color); //出力画像に画素値をセット
	    }
		}
	}

  public static void txt_16(BufferedImage readImage, File file, FileWriter filewriter, int w, int h){
		// 1ピクセルづつ処理を行う
    // 0:B,1:g,2:r,3:a
    try{
  		for (int y = 0; y < h; y++) {
  		  for (int x = 0; x < w; x++) {
  				int color = readImage.getRGB(x, y); // 入力画像の画素値を取得
  				//int c = (iu.r(color) + iu.g(color) + iu.b(color)) / 3;
          int a = iu.a(color);
          int r = iu.r(color);
          int g = iu.g(color);
          int b = iu.b(color);
          int s = 122;
          int count = 0;
          //--------------------
          if(a > s){
            count += 8;
          }
          if(r > s){
            count += 4;
          }
          if(g > s){
            count += 2;
          }
          if(b > s){
            count += 1;
          }
          //filewriter.write("1");
          if(count == 15){
            filewriter.write('?');
          }else if(count == 14){
            filewriter.write('>');
          }else if(count == 13){
            filewriter.write('=');
          }else if(count == 12){
            filewriter.write('<');
          }else if(count == 11){
            filewriter.write('B');
          }else if(count == 10){
            filewriter.write(':');
          }else{
            filewriter.write(String.valueOf(count));
          }
          //---------------------
  	    }
        filewriter.write("\n");
  		}
      filewriter.close();
    }catch(IOException e){
      System.out.println(e);
	  }
  }


}
