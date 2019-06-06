import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.IOException;

class number{
  public static void main(String args[]){
    try{
      FileReader inFile = new FileReader("~/in.txt");
      File outFile = new File("out.txt");
      BufferedReader br = new BufferedReader(inFile);
      FileWriter filewriter = new FileWriter(outFile);
      String line;
      int x = 256;
      while((line = br.readLine()) != null){
        int inNum = Integer.parseInt(line);
        while(true){
          if(x != inNum){
            filewriter.write(String.valueOf(x));
            x++;
          }else{
            x++;
            break;
          }
        }
      }
    }catch (IOException e){
      /* 例外処理 */
  			throw new RuntimeException(e.toString());
    }
    System.out.println("出力完了");
  }
}
