package syainInfo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class SyainInfoUpdateDao {

	//接続に必要な変数を宣言
	private static final String sql = "UPDATE syaininfo "
			+ "SET syain_name = ?, age = ?, position = ?, tel = ?, skill = ?, hobby = ?, notes = ?, update_date = ? WHERE id = ?";
	private static final String url = "jdbc:mysql://localhost/Syain_Info_DB";
	private static final String user = "root";
	private static final String password = "";

	public static void UpdateInfo(int id, String syainName, int age, String position, String tel,
			String skill, String hobby, String notes) throws IOException {
		// データベースに登録
		try (
				Connection con = DriverManager.getConnection(url, user, password);
				PreparedStatement pstmt = con.prepareStatement(sql);
				) {
	        // 現在日時を取得
			LocalDateTime nowDate = LocalDateTime.now();

	        // 表示形式を指定
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss.SSS"); // 表示形式を指定
			String formatNowDate = dtf.format(nowDate); // 指定した表示形式を設定

			pstmt.setString(1, syainName);
			pstmt.setInt(2, age);
			pstmt.setString(3, position);
			pstmt.setString(4, tel);
			pstmt.setString(5, skill);
			pstmt.setString(6, hobby);
			pstmt.setString(7, notes);
			pstmt.setString(8, formatNowDate);
			pstmt.setInt(9, id);
			pstmt.executeUpdate();

			// MySQLに値を渡せないとき、MySQLに接続できないとき
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}
	}

}