<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<title>DIS Login</title>
<script type="text/javascript">
	function fsubmit(frm) {
		if (frm.adminid.value == "") {
			alert("아이디를 입력하세요.");
			frm.adminid.focus();
			return false;
		}
		if (frm.adminpw.value == "") {
			alert("비밀번호를 입력하세요.");
			frm.adminpw.focus();
			return false;
		}
		return true;
	}

	function fn_init() {
		var errMsg = "${errMessage}";
		if (errMsg != null && errMsg != "") {
			alert(errMsg);
			document.login_form.adminid.focus();
			return;
		}
	}
</script>
</head>
<body class="body_bg" onload="fn_init();">
	<div class="allArea">
		<div id="divMain" class="loginbox">
			<form name="login_form" method=post action="loginCheck.do" onsubmit="return fsubmit(this);" autocomplete=off>
				<div class="login">
					<h1 class="login_tit">
						<img src="./images/login/login_tit.png" alt="dis설계정보시스템" />
					</h1>
					<div class="inputArea">
						<div class="ip_style">
							<input type="text" name="adminid" id="adminid" class="ip_box" value="" style="text-transform: uppercase;" />
						</div>
						<div class="ip_style mgt7">
							<input type="password" name="adminpw" id="adminpw" maxlength="15" class="ip_box" value=""/>
						</div>
						<a href="#"><input type="image" src="./images/login/btn_login.png" title="로그인" class="btn_login mgt20" /></a>
						<div class="bt_txt">
							<img src="./images/login/bottom_txt.png" />
						</div>
					</div>
				</div>
			</form>
			<!-- test 입니다. -->
			<script type="text/javascript">
			
				$(window).load(function() {
					// 	fn_all_text_upper();

					if (parent.frames[0]) {
						// 상위 frame이 존재할 때 상위에서 로그인 화면으로 이동시킴
						parent.location.href = "disLogin.do";
					}

					var popup_opener = opener;
					if (!popup_opener) {
						popup_opener = window.dialogArguments;
						if (popup_opener) {
							//현재창이 팝업
							popup_opener.parent.location.href = "disLogin.do";
							self.close();
						}
					} else {
						// 팝업인 경우
						self.close();
					}

					
				});

				$(document).ready(function() {
					// 	$( "#adminid" ).val( "211055" );
					// 	$( "#adminpw" ).val( "1" );

					$("#adminid").focus();

					$("#adminid").change(function() {
						$(this).val($(this).val().toUpperCase());
					});
					
					//key evant 
					$("#adminpw").keypress(function(event) {
					  if (event.which == 13) {
						  if(fsubmit(login_form)) login_form.submit();
					    }
					});

				});
			</script>
		</div>
	</div>
</body>
</html>