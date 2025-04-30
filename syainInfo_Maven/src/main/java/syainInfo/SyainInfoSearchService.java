package syainInfo;


import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 一覧画面遷移Service
 * フォームに入力された検索条件データを一覧画面に送る
 */
@WebServlet("/SyainInfoSearchService")
public class SyainInfoSearchService extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 文字化け回避
		request.setCharacterEncoding("UTF-8");

		// 一覧画面へ遷移
		RequestDispatcher list = request.getRequestDispatcher("/SyainInfoList.jsp");
		list.forward(request, response);
	}
}