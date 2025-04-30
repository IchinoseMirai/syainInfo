package syainInfo;


import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

interface ConversionType { //インタフェース
	int toIntFromString(String str);
}

/**
 * 社員情報一覧にて社員情報を何件目から何件目まで表示しているかを記録する
 * 
 */
@WebServlet("/SyainInfoListPage")
public class SyainInfoListPage extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 文字化け回避
		request.setCharacterEncoding("UTF-8");

		// リクエストスコープへ登録する値
		int infoNumberStart = 0;
		int infoNumberEnd = 0;

		// データ表示箇所変更値
		int infoNumber = 10;

		// ラムダ式
		// Interface.java
		ConversionType conversionType = str -> Integer.parseInt(request.getParameter(str));

		// 現在の社員情報表示状態を取得
		int infoNumberStartInit = conversionType.toIntFromString("startNumber");
		int infoNumberEndInit = conversionType.toIntFromString("edNumber"); //endNumberだとエラーになる

		// 押下したボタンによって処理を変更
		if (conversionType.toIntFromString("pressedBtn") == 0) {
			// 前ボタン押下時
			infoNumberStart = infoNumberStartInit - infoNumber;
			infoNumberEnd = infoNumberEndInit - infoNumber;
		} else if (conversionType.toIntFromString("pressedBtn") == 1) {
			// 次ボタン押下時
			infoNumberStart = infoNumberStartInit + infoNumber;
			infoNumberEnd = infoNumberEndInit + infoNumber;
		}

		// リクエストスコープへの登録
		request.setAttribute("infoNumberStart", String.valueOf(infoNumberStart));
		request.setAttribute("infoNumberEnd",  String.valueOf(infoNumberEnd));

		// 一覧画面へ遷移（画面の更新）
		RequestDispatcher list = request.getRequestDispatcher("/SyainInfoList.jsp");
		list.forward(request, response);
	}
}