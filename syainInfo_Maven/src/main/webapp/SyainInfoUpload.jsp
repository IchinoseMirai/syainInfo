<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="syainInfo.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報アップロード</title>
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

<h2>社員をアップロードします</h2>
<!-- onsubmitがfalseの場合、submitの処理を無効にする -->
<form method="POST" action="SyainInfoListUpload" id="uploadForm" name="uploadForm" enctype="multipart/form-data" onsubmit="return UploadBtn()">
	<input type="file" id="uploadFile" name="uploadFile" href="#" value="" accept=".csv"/>
	<input type="submit" id="upload" href="#" value="アップロード"/>
</form>
<BR>

<script type="text/javascript">
// アップロードファイルの値を格納する変数
var uploadName;
var uploadAge;
var uploadPosition;
var uploadTel;
var uploadSkill;
var uploadHobby;
var uploadNotes;

// hiddenオブジェクト作成フラグ
var hiddenFlg = false;

//Form要素を取得する
var form = document.forms.uploadForm;
var hairetu;
var result;

//ファイルが読み込まれた時の処理
form.uploadFile.addEventListener('change', function(e) {

	//読み込んだファイル情報を取得
	result = e.target.files[0];
	//FileReaderのインスタンスを作成する
	var reader = new FileReader();
	//読み込んだファイルの中身を取得する
	if (typeof result != "undefined") {
		reader.readAsText(result);
	} else if (typeof result == "undefined") {
		// hairetuを未定義にする（未定義の変数を代入）
		hairetu = undefined;
	}
    //ファイルの中身を取得後に処理を行う
    reader.addEventListener( 'load', function() {
		//CSVの各データ毎に読み込む
		hairetu = reader.result.split(',');
    })

})


// 登録ボタン押下時
function UploadBtn(){

	// ファイル存在チェック
	// ファイルが選択されていなければエラー
	if (!fileExistingCheck()) {
		alert("アップロードファイルが存在しません。");
		return false;
	}
	// ファイル拡張子チェック
	// csvで無ければエラー
	if (!csvCheck()) {
		alert("アップロードファイルの拡張子は.csvとしてください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
	// カラム数チェック
	// hairetuの要素数が7ではない場合エラー
	if (!sizeCheck()) {
		alert("アップロードファイルの形式が異なります。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
<%
	for (int n = 0; n < 7; n++) {
%>
		// valueに設定する変数を宣言
		var data<%=n%> = hairetu[<%=n%>];
		// hiddenオブジェクトを動的に作成
		if (!hiddenFlg) {
			var manufact<%=n%> = document.createElement("input");
			manufact<%=n%>.setAttribute("type", "hidden");
			manufact<%=n%>.setAttribute("id", "manufact<%=n%>");
			manufact<%=n%>.value = data<%=n%>;
			manufact<%=n%>.name = "manufact<%=n%>";
			var form2 = document.getElementById("uploadForm");
			// form内にオブジェクト追加（これでjavaに読み込んだデータを送る）
			form2.appendChild(manufact<%=n%>);
		} else {
			// valueのみ変更
			document.getElementById("manufact<%=n%>").value = data<%=n%>;
		}

<%
	}
%>
	// hiddenオブジェクト作成フラグを作成不可に
	hiddenFlg = true;

	//値
	uploadName = data0;
	uploadAge = data1;
	uploadPosition = data2;
	uploadTel = data3;
	uploadSkill = data4;
	uploadHobby = data5;
	uploadNotes = data6;


	// 社員名入力チェック
	if (!syainNameCheck()) {
		alert("社員名を入力してください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
	// 年齢入力チェック
	if (!inputAgeCheck()) {
		alert("年齢を入力してください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
	// 年齢文字数チェック
	if (!ageMojisuCheck()) {
		alert("年齢を2文字で入力してください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
	// 年齢半角数字チェック
	if (!ageNumberCheck()) {
		alert("年齢を半角数字で入力してください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}
	// 役職入力チェック
	if (!inputPositionCheck()) {
		alert("役職を入力してください。");
		document.getElementById("uploadFile").value = "";
		return false;
	}

	var result = confirm("選択されたファイルをアップロードします。よろしいですか？");
	if (result) {
		// 処理続行（submitの処理を行う）
		// 検索条件保持
		saveSearchData("upload");
	} else {
		document.getElementById("uploadFile").value = "";
		return false;
	}

}

//戻るボタン押下時
function backBtn(){
	// 検索条件保持
	saveSearchData("back");
	// 一覧画面へ
}

//検索条件保持関数
function saveSearchData(btnKind) {
	// 検索条件を保持
	let form;
	if (btnKind == "upload") {
    	form = document.getElementById("uploadForm");
	} else if (btnKind == "back") {
	    form = document.createElement("form");
	    form.method = "POST";
	    form.action = "SyainInfoListUpload";
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
    if (btnKind == "upload") {
    	pressedBtn.value = "upload";
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

//ファイル存在チェック
function fileExistingCheck() {
	// ファイルが未選択か
	if (document.getElementById("uploadFile").value == "") {
		return false;
	}
	return true;
}

// ファイル拡張子チェック
function csvCheck() {
	var pattern = /^.*\.csv$/;
	var matchResult = result.name.match(pattern);
	// matchメソッドで一致しなければnullが返る
	// 拡張子がcsvか
	if (matchResult == null) {
		return false;
	}
	return true;
}

// カラム数チェック
function sizeCheck() {
	// 要素数が7か
	if (hairetu.length != 7) {
		return false;
	}
	return true;
}

// 社員名入力チェック
function syainNameCheck() {
	// 社員名が入力されているか
	if (uploadName == "") {
		return false;
	}
	return true;
}

//年齢入力チェック
function inputAgeCheck() {
	// 年齢が入力されているか
	if (uploadAge == "") {
		return false;
	}
	return true;
}

//年齢文字数チェック
function ageMojisuCheck() {
	// 2文字か
	if (uploadAge.length != "2") {
		return false;
	}
	return true;
}

//年齢半角数字チェック
function ageNumberCheck() {
	// 半角数字のみか
	var pattern = /^[1-9][0-9]$/;
	var result = uploadAge.match(pattern);
	// matchメソッドで一致しなければnullが返る
	if (result == null) {
		return false;
	}
	return true;
}

//役職入力チェック
function inputPositionCheck() {
	// 役職が入力されているか
	if (uploadPosition == "") {
		return false;
	}
	return true;
}

</script>


<input type="button" value="戻る" onclick="backBtn()" />
</body>
</html>