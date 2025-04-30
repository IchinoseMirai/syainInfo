package syainInfo;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 * 
 * 
 */
@WebServlet("/SyainInfoListUpload")
@MultipartConfig
public class SyainInfoListUpload extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 文字化け回避
		request.setCharacterEncoding("UTF-8");

		// ボタン押下情報取得
		String btnKind = request.getParameter("pressedBtn");

		if (btnKind.equals("upload")) {
			// ファイル内容を受け取る
			String syainName = request.getParameter("manufact0");
			int age = Integer.parseInt(request.getParameter("manufact1"));
			String position = request.getParameter("manufact2");
			String tel = request.getParameter("manufact3");
			String skill = request.getParameter("manufact4");
			String hobby = request.getParameter("manufact5");
			String notes = request.getParameter("manufact6");

			// ファイルチェック
			Part filePart = request.getPart("uploadFile");
			if (filePart == null || filePart.getSize() == 0) {
				request.setAttribute("error", "ファイルが選択されていません。");
				request.getRequestDispatcher("/error.jsp").forward(request, response);
				return;
			}

			try (BufferedReader reader = new BufferedReader(new InputStreamReader(filePart.getInputStream(), StandardCharsets.UTF_8))) {
				String line;
				while ((line = reader.readLine()) != null) {
					// 項目ごとに分ける
					String[] columns = line.split(",");
					// 項目数チェック
					if (columns.length != 7) {
						request.setAttribute("error", "CSVの形式が正しくありません。");
						request.getRequestDispatcher("/error.jsp").forward(request, response);
						return;
					}
					// 必須チェック
					if (syainName.isEmpty() || position.isEmpty() || columns[0].isEmpty() || columns[2].isEmpty()) {
						request.setAttribute("error", "必須項目が入力されていません。");
						request.getRequestDispatcher("/error.jsp").forward(request, response);
						return;
					}
					// 年齢半角数字チェック
					if (!String.valueOf(age).matches("^[1-9][0-9]$") || !columns[1].matches("^[1-9][0-9]$")) {
						request.setAttribute("error", "年齢が不正です。");
						request.getRequestDispatcher("/error.jsp").forward(request, response);
						return;
					}

				}
			}

			// 値を登録
		    // columnsを入れると社員名に謎の空白が入ってしまうため
			SyainInfoAddDao.AddInfo(syainName, age, position, tel, skill, hobby, notes);

		} else if (btnKind.equals("back")) {
			//処理なし
		}

		// 一覧画面へ遷移
		RequestDispatcher list = request.getRequestDispatcher("/SyainInfoList.jsp");
		list.forward(request, response);
	}
}