<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="syainInfo.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報検索条件設定</title>
</head>
<body>

<script>

var InputAge;

// 検索ボタン押下時
function searchBtn() {
	// 入力値を格納
	if (document.getElementById("searchAge").value != null) {
		InputAge = document.getElementById("searchAge").value;
	}

	if (InputAge != null && InputAge != "") {
		// 年齢文字数チェック
		if (!inputAgeMojisuCheck()) {
			alert("年齢を半角2文字で入力してください。");
			return false;
		}		
		// 半角数字チェック
		if (!inputAgeNumberCheck()) {
			alert("年齢を半角数字で入力してください。");
			return false;
		}
	} else {
		document.getElementById("searchAge").value = "0";
		InputAge = 0;
	}


}

//年齢文字数チェック
function inputAgeMojisuCheck() {
	// 2文字か
	if (InputAge.length != "2") {
		return false;
	}
	return true;
}

//年齢半角数字チェック
function inputAgeNumberCheck() {
	// 半角数字のみか
	var pattern = /^[1-9][0-9]$/;
	var result = InputAge.match(pattern);
	// matchメソッドで一致しなければnullが返る
	if (result == null) {
		return false;
	}
	return true;
}

</script>

<h1>社員情報検索条件設定</h1>
<h3 style="margin-bottom: 1px; margin-top: 1px">検索条件</h3>
<form method="POST" action="SyainInfoSearchService" onsubmit="return searchBtn()" >
	社員名　：<input type="text" id="searchName" name="searchName" size="20" /><BR>
	年齢　　：<input type="text" id="searchAge" name="searchAge" maxlength="2" size="20" /><BR>
	役職　　：<input type="text" id="searchPosition" name="searchPosition" size="20" /><BR>
	電話番号：<input type="text" id="searchTel" name="searchTel" size="20" /><BR>
	スキル　：<input type="text" id="searchSkill" name="searchSkill" size="20" /><BR>
	趣味　　：<input type="text" id="searchHobby" name="searchHobby" size="20" /><BR>
	<input type="submit" value="検索" />
</form>

</body>
</html>