package syainInfo;

import java.util.ResourceBundle;

interface Hoge { //インタフェース
	  int doSomething(String str);
	  static int aiueo() {
		  return 1;
	  }
	}

interface Hoge2 { //インタフェース
	  int doSomething2(String str);
	}

public class ramuda {
	 public static void main(String[] args) {


		Hoge2 hoge2 = str -> str.length(); //抽象クラスのみの場合の実装クラス
		Hoge hoge = (str) -> { //他に具象クラスが存在する場合の実装クラス（static）
			  return str.length();
			};
		int length = hoge.doSomething("あいうえお"); //メソッド使用
		int length2 = hoge2.doSomething2("あいうえおかきく"); //メソッド使用
		System.out.println(length);  // "5"と出力される
		System.out.println(length2);  // "8"と出力される

		ResourceBundle rb = ResourceBundle.getBundle("config");
		System.out.println(rb.getString("url"));
		System.out.println(rb.getString("password"));
		System.out.println(rb.getString("user"));
		
	}
}