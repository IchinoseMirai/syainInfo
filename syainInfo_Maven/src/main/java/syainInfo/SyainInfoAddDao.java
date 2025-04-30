package syainInfo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class SyainInfoAddDao {

	//接続に必要な変数を宣言
	private static final String sql = "INSERT INTO syaininfo VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	private static final String url = "jdbc:mysql://localhost/Syain_Info_DB";
	private static final String user = "root";
	private static final String password = "";


	public static void AddInfo(String syainName, int age, String position, String tel,
			String skill, String hobby, String notes) throws IOException {
		SyainInfoAddForm formId = new SyainInfoAddForm();
		int id = 999990;
		// 最も大きいidを取得
		try (
				Connection conId = DriverManager.getConnection(url, user, password);
				PreparedStatement pstmtId = conId.prepareStatement("SELECT MAX(id) FROM syaininfo");
				) {
			try (ResultSet rs = pstmtId.executeQuery();) {
				while (rs.next()) {
					// idカラムの中で最も大きい数字を取得し、1を足したidで登録
					formId.setId(rs.getInt("MAX(id)"));
					id = formId.getId() + 1;
				}
			}
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}

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

			pstmt.setInt(1, id);
			pstmt.setString(2, syainName);
			pstmt.setInt(3, age);
			pstmt.setString(4, position);
			pstmt.setString(5, tel);
			pstmt.setString(6, skill);
			pstmt.setString(7, hobby);
			pstmt.setString(8, notes);
			pstmt.setString(9, formatNowDate);
			pstmt.executeUpdate();

			// MySQLに値を渡せないとき、MySQLに接続できないとき
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}
	}

	public static  List<SyainInfoAddForm> selectSyainName() throws IOException {
		// 社員名を集める
		List<SyainInfoAddForm> syainNameList = new ArrayList<>();
		try (
				Connection con = DriverManager.getConnection(url, user, password);
				PreparedStatement pstmt = con.prepareStatement("SELECT * FROM syaininfo");
				) {
			try (ResultSet rs = pstmt.executeQuery();) {
				while (rs.next()) {
					SyainInfoAddForm kd1 = new SyainInfoAddForm();
					kd1.setSyainName(rs.getString("syain_name"));
					syainNameList.add(kd1);
				}
			}
			// MySQLに値を渡せないとき、MySQLに接続できないとき
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}
		// 社員名を集めたリストを返す
		return syainNameList;
	}

}
