<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" href="/css/common.css" type="text/css" />
<link rel="stylesheet" href="/css/common_table.css" type="text/css" />
<link rel="stylesheet" href="/css/ui.jqgrid.css" type="text/css" />
<link rel="stylesheet" href="/css/redmond/jquery-ui-1.10.4.custom.css" type="text/css" />
<link rel="stylesheet" href="/css/jquery.treeview.css" />
<link rel="stylesheet" href="/css/dis_style.css" />
<link rel="stylesheet" href="/css/easyui.css" />
<script type="text/javascript" src="/js/jquery-2.1.4.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery.easyui.min.js" charset='utf-8'></script>
<script type="text/javascript" src="/js/jquery.cycle.all.js" charset='utf-8'></script>
<script>
	/* $(document).ready(function() {
		$('#logo').cycle({
			fx: 'wipe', speed:  1700, timeout: -1000, delay:  -4000
		});
	}); */
</script>
<style type="text/css">
* {
	margin: 0px;
	padding: 0px;
}

#dis_header {
	position: relative;
	width: 100%;
	top: 0px;
	height: 98px;
	left: 0px;
	margin: 0px;
	padding: 0px;
	background: url(./images/main/header_bg.jpg) repeat-x right 92px /*#f5f5f5;*/ #fff
}

#logo {
	position: relative;
	top: 12px;
	left: 21px;
}

.img_bg {
	position: absolute;
	top: 0px;
	right: 0px;
	float: right;
	width: 1160px;
	height: 92px;
	background: url(./images/main/bg_repeat.jpg-) repeat-x right top;
	z-index: 99; /*background-size:cover;*/
}

.userinfo {
	position: absolute;
	top: 53px;
	right: 15px;
	width: 600px;
	height: 90px;
	text-align: right;
	z-index: 9999999 !important
}

a:hover {
	text-decoration: none;
}
</style>

<div id="dis_header">
	<div id="logo">
		<a href="layoutMainContents.do" target="main"><img src="./images/main/logo.png" alt="DIS설계정보시스템" /></a>
		<!-- <a href="layoutMainContents.do" target="main"><img src="./images/main/logo5.png" alt="DIS설계정보시스템" /></a>
		<a href="layoutMainContents.do" target="main"><img src="./images/main/logo1.png" alt="DIS설계정보시스템" /></a>
		<a href="layoutMainContents.do" target="main"><img src="./images/main/logo2.png" alt="DIS설계정보시스템" /></a>
		<a href="layoutMainContents.do" target="main"><img src="./images/main/logo3.png" alt="DIS설계정보시스템" /></a>
		<a href="layoutMainContents.do" target="main"><img src="./images/main/logo4.png" alt="DIS설계정보시스템" /></a> -->

	</div>
	<div id="headImg"
		style="position: absolute; float: right; top: -1px; left: 280px; text-align: left; width: 100%; height: 93px; background: url(./images/main/bg_repeat.jpg) repeat left top; z-index: 55">
		<img src="./images/main/img_bg4.jpg" />
	</div>

	<div class="userinfo">
		<select style="height: 28px; margin-top: -3px; color: #4a4848; font-size: 11px; font-weight: bold;" id="p_role_code"
			name="p_role_code" onchange="roleChage();">
		</select>
		<div
			style="display: inline; height: 12px; color: #4a4848; padding: 6px 11px 6px 11px; font-size: 11px; font-weight: bold; background: #fff; letter-spacing: -0.02em; border: 1pxsolid #3a437e; margin-top: 3px;">
			${loginUser.user_id} ${loginUser.user_name} (${loginUser.insa_dept_name})</div>
		<a href="#"
			onclick="window.open('popUpUserInfoUpdate.do','사용자정보','resizable=no, width=400, height=200, scrollbars=yes');return false">
			<span id="userInfoUpdate"
			style="position: relative; top: -1px; display: inline; text-align: center; background: #3a437e; color: #f3f4f5; font-weight: bold; font-size: 11px; padding: 5px 8px; vertical-aiign: middle;">정보변경</span>
		</a>
		
<!-- 		<a href="#" -->
<!-- 			onclick="window.open('popUpBookmarkUpdate.do','사용자정보','resizable=no, width=600, height=650, scrollbars=yes');return false"> -->
<!-- 			<span id="bookmarkUpdate" -->
<!-- 			style="position: relative; top: -1px; display: inline; text-align: center; background: #3a437e; color: #f3f4f5; font-weight: bold; font-size: 11px; padding: 5px 8px; vertical-aiign: middle;">Bookmark 편집</span> -->
<!-- 		</a> -->
		
		<input type="button" value="BOOKMARK" id="bookmarkUpdate" style="position: relative; top: -2px; display: inline; text-align: center; background: #3a437e; color: #f3f4f5; font-weight: bold; font-size: 11px; padding: 6px 8px; vertical-aiign: middle; border:0px"/>
		
		<a href="javascript:logout();"><span
			style="position: relative; top: -1px; display: inline; text-align: center; background: #3a437e; color: #f3f4f5; font-weight: bold; font-size: 11px; padding: 5px 8px; vertical-aiign: middle;">Logout</span></a>
	</div>
</div>
<script>
	if ('${loginUser.user_id}' == '${loginID}') {
		$("#userInfoUpdate").hide();
	}
	function logout() {
		if ('${loginUser.user_id}' == '${loginID}') {
			parent.close();
		} else {
			parent.location.href = "disLogout.do";
		}
	}
	function roleChage() {
		parent.roleChage($("#p_role_code").val());
	}
	// 권한 정보를 코드마스터에서 가져온다.
	$.post("infoComboCodeMaster.do?sd_type=DIS_ROLE_GROUP", "", function(data) {
		// 로그인된 유저의 권한 정보리스트를 취득한다.
		var authorList = "${loginUser.author_code}".split("|");
		for (var i = 0; i < data.length; i++) {
			// 로그인된 유저의 권한정보만 보여준다.
			for (var k = 0; k < authorList.length; k++) {
				if (data[i].value == authorList[k]) {
					$("#p_role_code").append("<option value='"+data[i].value+"'>" + data[i].text + "</option>");
				}
			}
		}
	}, "json");
	
	$("#bookmarkUpdate").click(function(){
		var sURL = "popUpBookmarkUpdate.do?roleCode="+$("#p_role_code option:selected").val();
		var popOptions = "dialogWidth: 600px; dialogHeight: 650px; center: yes; resizable: yes; status: no; scroll: yes;"; 
		window.showModalDialog(sURL, window, popOptions);
	});
	
	function refresh() {
		$("#menu",parent.document).get(0).contentDocument.location.reload();
	}
</script>