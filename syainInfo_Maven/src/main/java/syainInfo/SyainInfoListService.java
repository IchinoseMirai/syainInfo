package syainInfo;


import java.io.IOException;
import java.util.stream.Stream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 
 * 
 */
@WebServlet("/SyainInfoListService")
public class SyainInfoListService extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 文字化け回避
		request.setCharacterEncoding("UTF-8");
		// ボタン押下情報取得
		String btnKind = request.getParameter("pressedBtn");

		if (btnKind.equals("add")) {
			// 登録ボタン押下時処理

			// 登録画面へ遷移
			RequestDispatcher list = request.getRequestDispatcher("/SyainInfoAdd.jsp");
			list.forward(request, response);

		} else if (btnKind.equals("update")) {
			// 修正ボタン押下時処理
			// jspから送られてきたidから社員情報を再取得
			int id = Integer.parseInt(request.getParameter("id"));

			SyainInfoSearchDao SyainInfoSearchDao = new SyainInfoSearchDao();
			String syainName = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getSyainName();
			int age = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getAge();
			String position = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getPosition();
			String tel = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getTel();
			String skill = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getSkill();
			String hobby = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getHobby();
			String notes = SyainInfoSearchDao.SearchDB_fromId(id).get(0).getNotes();
			
			// セッションに保存
			HttpSession session = request.getSession();
			session.setAttribute("id", id);
			request.setAttribute("syainName", syainName);
			request.setAttribute("age", age);
			request.setAttribute("position", position);
			request.setAttribute("tel", tel);
			request.setAttribute("skill", skill);
			request.setAttribute("hobby", hobby);
			request.setAttribute("notes", notes);
			
			// 修正画面へ遷移
			RequestDispatcher list = request.getRequestDispatcher("/SyainInfoUpdate.jsp");
			list.forward(request, response);

		} else if (btnKind.equals("delete")) {
			// 削除ボタン押下時処理
			// チェックボックスが選択されたデータのidを取得
			String[] checkbox = request.getParameterValues("choice");
			// String配列をint配列に変換
			int[] idArray = Stream.of(checkbox).mapToInt(Integer::parseInt).toArray();

			for (int i=0; i<checkbox.length; i++) {
				// SyainInfoList.jspで選択した社員の社員名を受け取る
				int id = idArray[i];
				// 値を削除
				SyainInfoListDao.DeleteSyainInfo(id);
			}
			// 一覧画面へ遷移（画面の更新）
			RequestDispatcher list = request.getRequestDispatcher("/SyainInfoList.jsp");
			list.forward(request, response);

		} else if (btnKind.equals("upload")) {
			// アップロードボタン押下時処理

			// 修正画面へ遷移
			RequestDispatcher list = request.getRequestDispatcher("/SyainInfoUpload.jsp");
			list.forward(request, response);

		}

	}
}