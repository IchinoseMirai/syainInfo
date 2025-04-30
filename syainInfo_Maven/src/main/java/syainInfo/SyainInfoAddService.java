package syainInfo;


import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 
 * 
 */
@WebServlet("/SyainInfoAddService")
public class SyainInfoAddService extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 文字化け回避
		request.setCharacterEncoding("UTF-8");

		// ボタン押下情報取得
		String btnKind = request.getParameter("pressedBtn");

		if (btnKind.equals("add")) {
			// SyainInfoAdd.jspで入力した内容を受け取る
			String syainName = request.getParameter("inputName");
			int age = Integer.parseInt(request.getParameter("inputAge"));
			String position = request.getParameter("inputPosition");
			String tel = request.getParameter("inputTel");
			String skill = request.getParameter("inputSkill");
			String hobby = request.getParameter("inputHobby");
			String notes = request.getParameter("inputNotes");

			// 必須チェック
			if (syainName.isEmpty() || position.isEmpty()) {
				request.setAttribute("error", "必須項目が入力されていません。");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}
			// 年齢半角数字チェック
			if (!String.valueOf(age).matches("^[1-9][0-9]$")) {
				request.setAttribute("error", "年齢が不正です。");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}

			// 値を登録
			SyainInfoAddDao.AddInfo(syainName, age, position, tel, skill, hobby, notes);

		} else if (btnKind.equals("back")) {
			//処理なし
		}
		
		// 遷移先用意、一覧画面へ
		RequestDispatcher list = request.getRequestDispatcher("/SyainInfoList.jsp");
		list.forward(request, response);
	}
}