package syainInfo;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SyainInfoListDao {

	//接続に必要な変数を宣言
	private static  String sql = "SELECT * FROM syaininfo "
	+ "WHERE syain_name LIKE ? AND (age = ? OR ? = 0) AND (position = ? OR ? = '') AND (position = ? OR ? = '') "
	+ "AND (skill = ? OR ? = '') AND (hobby = ? OR ? = '')";
	private static final String url = "jdbc:mysql://localhost/Syain_Info_DB";
	private static final String user = "root";
	private static final String password = "";

	public static List<SyainInfoListForm> FindDB_dl(String syainName, int age, String position, String tel,
			String skill, String hobby) throws IOException {

		// 値を集めるリスト
		List<SyainInfoListForm> list = new ArrayList<>();

		try (
				Connection con = DriverManager.getConnection(url, user, password);
				PreparedStatement pstmt = con.prepareStatement(sql);
				) {
			if (age > 0) {
			} else {
				age = 0;
			}
			pstmt.setString(1, "%" + syainName + "%");
			pstmt.setInt(2, age);
			pstmt.setInt(3, age);
			pstmt.setString(4, position); // position = ?
			pstmt.setString(5, position); // OR ? = ''
			pstmt.setString(6, tel);
			pstmt.setString(7, tel);
			pstmt.setString(8, skill);
			pstmt.setString(9, skill);
			pstmt.setString(10, hobby);
			pstmt.setString(11, hobby);
			try (ResultSet rs = pstmt.executeQuery();) {
				while (rs.next()) {
					SyainInfoListForm kd = new SyainInfoListForm();

						kd.setId(rs.getInt("id"));
						kd.setSyainName(rs.getString("syain_name"));
						kd.setAge(rs.getInt("age"));
						kd.setPosition(rs.getString("position"));
						kd.setTel(rs.getString("tel"));
						kd.setSkill(rs.getString("skill"));
						kd.setHobby(rs.getString("hobby"));
						kd.setNotes(rs.getString("notes"));

					list.add(kd);
				}
			}

			// MySQLに値を渡せないとき、MySQLに接続できないとき
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}

		// Listを返す
		return list;
	}

	public static void DeleteSyainInfo(int id) throws IOException {

		try (
				Connection con = DriverManager.getConnection(url, user, password);
				PreparedStatement pstmt = con.prepareStatement("DELETE FROM syaininfo WHERE id = ?");
				) {
			pstmt.setInt(1, id);
			// 削除処理
			pstmt.executeUpdate();

			// MySQLに値を渡せないとき、MySQLに接続できないとき
		} catch (SQLException e) { 
			System.out.println("エラー：データベース接続に失敗しました。");
			System.out.println(e);
		}
	}

}
