<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="syainInfo.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報登録</title>
</head>
<body>

<%
// Daoのインスタンス作成
SyainInfoAddDao SyainInfoAddDao = new SyainInfoAddDao();

// カラムの値を格納するリスト作成
List<SyainInfoAddForm> DuplicateSyainName = new ArrayList<>();

// 社員名重複チェックにて使用
DuplicateSyainName = SyainInfoAddDao.selectSyainName();

//検索条件を格納
String SearchName = (String)request.getParameter("searchName");
int SearchAge = Integer.parseInt(request.getParameter("searchAge"));
String SearchPosition = (String)request.getParameter("searchPosition");
String SearchTel = (String)request.getParameter("searchTel");
String SearchSkill = (String)request.getParameter("searchSkill");
String SearchHobby = (String)request.getParameter("searchHobby");
%>

<script type="text/javascript">
// 入力値
var inputName;
var inputAge;
var inputPosition;

// 登録ボタン押下時
function addBtn(){

	// 入力値を取得
	inputName = document.getElementById("inputName").value;
	inputAge = document.getElementById("inputAge").value;
	inputPosition = document.getElementById("inputPosition").value;
	
	// 社員名入力チェック
	if (!syainNameCheck()) {
		alert("社員名を入力してください。");
		return false;
	}
	// 年齢入力チェック
	if (!inputAgeCheck()) {
		alert("年齢を入力してください。");
		return false;
	}
	// 年齢文字数チェック
	if (!inputAgeMojisuCheck()) {
		alert("年齢を2文字で入力してください。");
		return false;
	}
	// 年齢半角数字チェック
	if (!inputAgeNumberCheck()) {
		alert("年齢を半角数字で入力してください。");
		return false;
	}
	// 役職入力チェック
	if (!inputPositionCheck()) {
		alert("役職を入力してください。");
		return false;
	}

	var result = confirm("入力した情報を登録します。よろしいですか？");
	if (result) {
		// 処理続行（submitの処理を行う）
		// 入力された値をSyainInfoAddService.javaへ渡す

		// 検索条件保持
		saveSearchData("add");
	} else {
		return false;
	}

}

//戻るボタン押下時
function backBtn(){

	// 検索条件保持
	saveSearchData("back");

	// 一覧画面へ
}

// 検索条件保持関数
function saveSearchData(btnKind) {
	// 検索条件を保持
	let form;
	if (btnKind == "add") {
    	form = document.getElementById("addForm");
	} else if (btnKind == "back") {
	    form = document.createElement("form");
	    form.method = "POST";
	    form.action = "SyainInfoAddService";
	}

    const input1 = document.createElement("input");
    input1.type = "hidden";
    input1.name = "searchName";
    input1.value = "<%=SearchName%>";

    const input2 = document.createElement("input");
    input2.type = "hidden";
    input2.name = "searchAge";
    input2.value = "<%=SearchAge%>";

    const input3 = document.createElement("input");
    input3.type = "hidden";
    input3.name = "searchPosition";
    input3.value = "<%=SearchPosition%>";

    const input4 = document.createElement("input");
    input4.type = "hidden";
    input4.name = "searchTel";
    input4.value = "<%=SearchTel%>";

    const input5 = document.createElement("input");
    input5.type = "hidden";
    input5.name = "searchSkill";
    input5.value = "<%=SearchSkill%>";

    const input6 = document.createElement("input");
    input6.type = "hidden";
    input6.name = "searchHobby";
    input6.value = "<%=SearchHobby%>";

    const pressedBtn = document.createElement("input");
    pressedBtn.type = "hidden";
    pressedBtn.name = "pressedBtn";
    if (btnKind == "add") {
    	pressedBtn.value = "add";
    } else if (btnKind == "back") {
    	pressedBtn.value = "back";
    }

    form.appendChild(input1);
    form.appendChild(input2);
    form.appendChild(input3);
    form.appendChild(input4);
    form.appendChild(input5);
    form.appendChild(input6);
    form.appendChild(pressedBtn);
    
    document.body.appendChild(form);
    form.submit();
}

// 社員名入力チェック
function syainNameCheck() {
	// 社員名が入力されているか
	if (inputName == "") {
		return false;
	}
	return true;
}

//年齢入力チェック
function inputAgeCheck() {
	// 年齢が入力されているか
	if (inputAge == "") {
		return false;
	}
	return true
}

//年齢文字数チェック
function inputAgeMojisuCheck() {
	// 2文字か
	if (inputAge.length != "2") {
		return false;
	}
	return true;
}

//年齢半角数字チェック
function inputAgeNumberCheck() {
	// 半角数字のみか
	var pattern = /^[1-9][0-9]$/;
	var result = inputAge.match(pattern);
	// matchメソッドで一致しなければnullが返る
	if (result == null) {
		return false;
	}
	return true;
}

//役職入力チェック
function inputPositionCheck() {
	// 役職が入力されているか
	if (inputPosition == "") {
		return false;
	}
	return true;
}

</script>
<h2>社員を登録します</h2>

<!-- onsubmitがfalseの場合、submitの処理を無効にする -->
<form method="POST" action="SyainInfoAddService" id="addForm" name="addForm" onsubmit="return addBtn()">
<table border="1">
	<tr>
		<th>社員名</th>
		<th>年齢</th>
		<th>役職</th>
		<th>電話番号</th>
		<th>スキル</th>
		<th>趣味</th>
		<th>備考</th>
	</tr>
	<tr>
		<td><input type="text" id="inputName" name="inputName" size="20" /></td>
		<td><input type="text" id="inputAge" name="inputAge" maxlength="2" size="10" /></td>
		<td><input type="text" id="inputPosition" name="inputPosition" size="10" /></td>
		<td><input type="text" id="inputTel" name="inputTel" size="10" /></td>
		<td><input type="text" id="inputSkill" name="inputSkill" size="10" /></td>
		<td><input type="text" id="inputHobby" name="inputHobby" size="10" /></td>
		<td><input type="text" id="inputNotes" name="inputNotes" size="10" /></td>
	</tr>
</table>

<BR>
<input type="submit" value="登録" />
<input type="button" value="戻る" onclick="backBtn()" />

</form>
</body>
</html>