<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="syainInfo.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>社員情報一覧</title>

</head>
<body>

<%
// Daoのインスタンス作成
SyainInfoListDao SyainInfoListDao = new SyainInfoListDao();
SyainInfoSearchDao SyainInfoSearchDao = new SyainInfoSearchDao();

// 各カラムの値を格納するリスト作成
List<SyainInfoListForm> syainInfo = new ArrayList<>();
List<SyainInfoListForm> syainInfoDownload = new ArrayList<>();

// データ表示箇所
int infoNumberStart = 0;
int infoNumberEnd = 10;

//「前の10件」「次の10件」ボタンを押下して更新した場合
String infoNumberStartString = (String)request.getAttribute("infoNumberStart");
String infoNumberEndString = (String)request.getAttribute("infoNumberEnd");
if (infoNumberStartString != null && infoNumberEndString != null) {
	infoNumberStart = Integer.parseInt(infoNumberStartString);
	infoNumberEnd = Integer.parseInt(infoNumberEndString);
}

// 検索条件を格納
String SearchName = (String)request.getParameter("searchName");
int SearchAge = Integer.parseInt(request.getParameter("searchAge"));
String SearchPosition = (String)request.getParameter("searchPosition");
String SearchTel = (String)request.getParameter("searchTel");
String SearchSkill = (String)request.getParameter("searchSkill");
String SearchHobby = (String)request.getParameter("searchHobby");

//各カラムの値を格納（画面表示用）
syainInfo = SyainInfoSearchDao.SearchDB(SearchName, SearchAge, SearchPosition, SearchTel, SearchSkill, SearchHobby, infoNumberStart);

//各カラムの値を格納（ダウンロード用）
syainInfoDownload = SyainInfoListDao.FindDB_dl(SearchName, SearchAge, SearchPosition, SearchTel, SearchSkill, SearchHobby);

// 繰り返し用変数
int syainNumber = 0;
int ageNumber = 0;
int positionNumber = 0;
int telNumber = 0;
int skillNumber = 0;
int hobbyNumber = 0;
int notesNumber = 0;

%>

<script type="text/javascript">
// CRUD機能を実装する（一覧表示・登録・修正・削除）

// チェックボックス選択数
var checkboxCount = 0;

// 選択したチェックボックスの情報
var checkbox;

// 選択した社員の情報
var id;
var sn;
var ag;
var ps;
var te;
var sk;
var hb;
var nt;


// 登録画面に遷移
function addBtn(){

	//検索条件の保持
	saveSearchData("add");

	// 登録画面へ

}

// 修正画面に遷移
function updateBtn(){

	// 選択したデータ取得
	getSyainInfo();

	// 選択チェック
	if (!selectCheck()) {
		alert("社員を選択してください。");
		return;
	}

	// 複数選択チェック
	if (!multipleSelectCheck()) {
		alert("社員を1つのみ選択してください。");
		checkboxCount = 0;
		return;
	}

	// データの保存
	sessionStorage.setItem('id', id);
	sessionStorage.setItem('syainName', sn);
	sessionStorage.setItem('age', ag);
	sessionStorage.setItem('position', ps);
	sessionStorage.setItem('tel', te);
	sessionStorage.setItem('skill', sk);
	sessionStorage.setItem('hobby', hb);
	sessionStorage.setItem('notes', nt);

	//検索条件の保持
	saveSearchData("update");

	// 修正画面へ

}

// 社員情報の削除
function deleteBtn(){

	// チェックボックス選択数を取得
	getCheckboxCount();

	// 選択チェック
	if (!selectCheck()) {
		alert("社員を選択してください。");
		return false;
	}

	// カウントリセット
	checkboxCount = 0;

	var result = confirm("選択した社員を削除します。よろしいですか？");
	if (result) {
		// 処理続行
		setCheckboxValue();
		document.getElementById("DeleteBtn").value = "delete";

		//検索条件の保持
		saveSearchData("delete");
	} else {
		return false;
	}

}

// ダウンロード処理
function downloadBtn() {
	// 文字コード
	var bom = new Uint8Array([0xEF, 0xBB, 0xBF]);
	// 書き込み内容
	var content = "";
<%
	for (int n = 0; n < syainInfoDownload.size(); n++) {
%>
		content = content + "<%=syainInfoDownload.get(n).getSyainName() %>" + "," + "<%=syainInfoDownload.get(n).getAge() %>" + 
		"," + "<%=syainInfoDownload.get(n).getPosition() %>" + "," + "<%=syainInfoDownload.get(n).getTel() %>" + "," + 
		"<%=syainInfoDownload.get(n).getSkill() %>" + "," + "<%=syainInfoDownload.get(n).getHobby() %>" + "," + 
		"<%=syainInfoDownload.get(n).getNotes() %>";

		if (<%=n%> < <%=syainInfoDownload.size()%>-1) {
			content = content + "\r\n";
		}
<%
	}
%>
	var blob = new Blob([ bom, content ], { "type" : "text/csv" });
	var a = document.createElement('a');
	a.download = "test.csv";
	a.target   = '_blank';

	// for IE
	if (window.navigator.msSaveBlob) { 
		window.navigator.msSaveBlob(blob, "test.csv"); 
		// msSaveOrOpenBlobの場合はファイルを保存せずに開ける
		window.navigator.msSaveOrOpenBlob(blob, "test.csv"); 
	// for Chrome
	} else if (window.webkitURL && window.webkitURL.createObjectURL) {
		a.href = window.webkitURL.createObjectURL(blob);
		a.click();
	} else {
		document.getElementById("download").href = window.URL.createObjectURL(blob);
	}
}

// アップロード画面へ遷移
function uploadBtn() {

	//検索条件の保持
	saveSearchData("upload");
	// アップロード画面へ

}

// 前の10件を表示
function previousBtn() {
	// 前にデータが存在しない場合
	if (<%=infoNumberStart%> == 0) {
		alert("最初の社員が表示されています。");
		return false;
	}
	// "0"は「前の10件」ボタン
	document.getElementById("PreviousBtn").value = "0";
	document.getElementById("StartNumber0").value = "<%=infoNumberStart%>";
	document.getElementById("EndNumber0").value = "<%=infoNumberEnd%>";

	//検索条件の保持
	saveSearchData("previous");
}


// 次の10件を表示
function nextBtn() {
	// 次にデータが存在しない場合
	if (<%=infoNumberEnd%> >= <%=syainInfoDownload.size()%>) {
		alert("最後の社員が表示されています。");
		return false;
	}
	// "1"は「次の10件」ボタン
	document.getElementById("NextBtn").value = "1";
	document.getElementById("StartNumber1").value = "<%=infoNumberStart%>";
	document.getElementById("EndNumber1").value = "<%=infoNumberEnd%>";

	//検索条件の保持
	saveSearchData("next");
}

//戻るボタン押下時
function backBtn(){

	// 検索画面へ
	 window.location.href = './SyainInfoSearch.jsp'
}


function saveSearchData(btnKind) {
	// 検索条件を保持
	let form;
	if (btnKind == "add" || btnKind == "update" || btnKind == "upload") {
		form = document.createElement("form");
	    form.method = "POST";
	    form.action = "SyainInfoListService";
	} else if (btnKind == "delete") {
		form = document.getElementById("deleteForm");
	} else if (btnKind == "previous") {
		form = document.getElementById("form-previous");
	} else if (btnKind == "next") {
		form = document.getElementById("form-next");
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
    } else if (btnKind == "update") {
    	pressedBtn.value = "update";
    } else if (btnKind == "delete") {
    	pressedBtn.value = "delete";
    } else if (btnKind == "upload") {
    	pressedBtn.value = "upload";
    } else if (btnKind == "previous") {
    	pressedBtn.value = "previous";
    } else if (btnKind == "next") {
    	pressedBtn.value = "next";
    }

    form.appendChild(input1);
    form.appendChild(input2);
    form.appendChild(input3);
    form.appendChild(input4);
    form.appendChild(input5);
    form.appendChild(input6);
    form.appendChild(pressedBtn);
    
    document.body.appendChild(form);

	if (btnKind == "update") {
		// idカラム用のhiddenオブジェクトを動的に作成
		var manufact = document.createElement("input");
		manufact.setAttribute("type", "hidden");
		manufact.setAttribute("id", "id");
		manufact.value = id;
		manufact.name = "id";
		// form内にオブジェクト追加
		form.appendChild(manufact);
	}

	form.submit();

	}

	// チェックボックス選択数カウント
	function getCheckboxCount() {
<%
	for (int i=0; i < syainInfo.size(); i++) {
%>
		checkbox = document.getElementById("choice<%=i%>");
		if (checkbox.checked) {
			checkboxCount++;
		}
<%	
	}
%>
}

// 選択したデータの値を取得
function getSyainInfo() {
<%
	for (int i=0; i < syainInfo.size(); i++) {
%>
		checkbox = document.getElementById("choice<%=i%>");
		if (checkbox.checked) {
			checkboxCount++;
			id  = "<%=syainInfo.get(i).getId()%>";
			sn  = "<%=syainInfo.get(i).getSyainName()%>";
			ag  = "<%=syainInfo.get(i).getAge()%>";
			ps  = "<%=syainInfo.get(i).getPosition()%>";
			te  = "<%=syainInfo.get(i).getTel()%>";
			sk  = "<%=syainInfo.get(i).getSkill()%>";
			hb  = "<%=syainInfo.get(i).getHobby()%>";
			nt  = "<%=syainInfo.get(i).getNotes()%>";
		}
<%	
	}
%>
}

// チェックボックスのvalueにidを設定
// javaでチェックしないとアウト
function setCheckboxValue() {
<%
	for (int i=0; i < syainInfo.size(); i++) {
%>
		checkbox = document.getElementById("choice<%=i%>");
		if (checkbox.checked) {
			document.getElementById("choice<%=i%>").value = "<%=syainInfo.get(i).getId()%>";
		}
<%	
	}
%>
}

//選択チェック
function selectCheck(){
	// チェックボックスが選択されているか
	if (checkboxCount == 0) {
		return false;
	}
	return true;
}

// 複数選択チェック
function multipleSelectCheck(){
	// チェックボックスが選択されているか
	if (checkboxCount >= 2) {
		return false;
	}
	return true;
}


</script>
<h1>社員情報一覧</h1>
<BR>

<!-- 登録完了しました　修正完了しました　削除完了しました　を出力させたい -->

<p>修正・削除を行う場合は、下の表より社員を選択してから、ボタンを押下してください。</p>
<!-- onsubmitがfalseの場合、submitの処理を無効にする -->
<form method="POST" action="SyainInfoListService" id="deleteForm" name="deleteForm" onsubmit="return deleteBtn()" >
	<input type="hidden" id="DeleteBtn" name="pressedBtn" value="" />
	<input type="button" value="登録" onclick="addBtn()" />
	<input type="button" value="修正" onclick="updateBtn()" />
	<input type="submit" value="削除" />
	<BR><BR>
	<input type="submit" value="前の10件" form="form-previous" />
	<input type="submit" value="次の10件" form="form-next" />

	<table border="1">
		<tr>
			<th>選択</th>
			<th>社員名</th>
			<th>年齢</th>
			<th>役職</th>
			<th>電話番号</th>
			<th>スキル</th>
			<th>趣味</th>
			<th>備考</th>
		</tr>
		<!-- 一覧に社員を表示 -->
		<tr>
			<td>
<%
				for(int sentaku = 0; sentaku < syainInfo.size(); sentaku++ ) {
%>
					<input type="checkbox" name="choice" id="choice<%=sentaku%>" value="" />
					<br>
<%
				}
%>			
			</td>
			<td>
<%
				for(SyainInfoListForm title1 : syainInfo) {
%>
					<a id="syainName<%=syainNumber%>"><%=title1.getSyainName() %></a>
					<br>
<%
					syainNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title2 : syainInfo) {
%>
					<a id="age<%=ageNumber%>"><%=title2.getAge() %></a>
					<br>
<%
					ageNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title3 : syainInfo) {
%>
					<a id="position<%=positionNumber%>"><%=title3.getPosition() %></a>
					<br>
<%
					positionNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title4 : syainInfo) {
%>
					<a id="tel<%=telNumber%>"><%=title4.getTel() %></a>
					<br>
<%
					telNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title5 : syainInfo) {
%>
					<a id="skill<%=skillNumber%>"><%=title5.getSkill() %></a>
					<br>
<%
					skillNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title6 : syainInfo) {
%>
					<a id="hobby<%=hobbyNumber%>"><%=title6.getHobby() %></a>
					<br>
<%
					hobbyNumber++;
				}
%>	
			</td>
			<td>
<%
				for(SyainInfoListForm title7 : syainInfo) {
%>
					<a id="notes<%=notesNumber%>"><%=title7.getNotes() %></a>
					<br>
<%
					notesNumber++;
				}
%>	
			</td>
		</tr>
	</table>
</form>
<input type="button" id="download" href="#" download="test.csv" value="ダウンロード(JavaScript)"  onclick="downloadBtn()"/>
<input type="button" value="アップロード" onclick="uploadBtn()"/><BR>
<input type="button" value="戻る" onclick="backBtn()"/>
<form id="form-previous" method="POST" action="SyainInfoListPage" name="form-previous" onsubmit="return previousBtn()">
	<input type="hidden" id="PreviousBtn" name="pressedBtn" value="0" /> <!-- インターフェースを試したかったため数値で判定 -->
	<input type="hidden" id="StartNumber0" name="startNumber" value="0" />
	<input type="hidden" id="EndNumber0" name="edNumber" value="0" />
</form>
<form id="form-next" method="POST" action="SyainInfoListPage" name="form-next" onsubmit="return nextBtn()">
	<input type="hidden" id="NextBtn" name="pressedBtn" value="1" /> <!-- インターフェースを試したかったため数値で判定 -->
	<input type="hidden" id="StartNumber1" name="startNumber" value="0" />
	<input type="hidden" id="EndNumber1" name="edNumber" value="0" />
</form>
</body>
</html>