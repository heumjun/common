<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>정보변경</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<form id="application_form" name="application_form" method="post" action="savePopUpUserInfo.do">
		<div
			style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
			<!-- 			<img src="/images/main/info_tit.gif" /> -->
			<img src="/images/main/tit_userinfo.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
		</div>
		<table class="table_st01">
			<col width="140px">
			<col width="260px">
			<thead>
				<tr>
					<th align="right"><strong>기존 비밀번호<span style="color: red;">*</span></strong>&nbsp;</th>
					<td style="text-align: left;">&nbsp;<input type="password" class="required w250h20" id="old_pw" name="old_pw" /></td>
				</tr>
				<tr>
					<th align="right"><strong>신규 비밀번호<span style="color: red;">*</span></strong>&nbsp;</th>
					<td style="text-align: left;">&nbsp;<input type="password" class="required w250h20" id="new_pw" name="new_pw" /></td>
				</tr>
				<tr>
					<th align="right"><strong>신규 비밀번호 확인<span style="color: red;">*</span></strong>&nbsp;</th>
					<td style="text-align: left;">&nbsp;<input type="password" class="required w250h20" id="new_pw_con"
						name="new_pw_con" /></td>
				</tr>
			</thead>
		</table>
	</form>
	<div style="float: right; padding: 5px 5px;">
		<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
	</div>
	<script type="text/javascript">
		$(document).ready(function() {
			var message = "${message}";
			var result = "${result}";

			if (result == "S") {
				if (message != null && message != "") {
					alert(message);
				}
				opener.document.location.href = "disLogout.do";
				self.close();
			} else {
				if (message != null && message != "") {
					alert(message);
					return;
				}
			}

			$("#btnSave").click(function() {
				if ($("#old_pw").val() == "") {
					alert("기존 비밀번호를 입력해 주세요.");
					$("#old_pw").focus();
					return;
				} else if ($("#new_pw").val() == "") {
					alert("신규 비밀번호를 입력해 주세요.");
					$("#new_pw").focus();
					return;
				} else if ($("#new_pw_con").val() == "") {
					alert("신규 비밀번호 확인을 입력해 주세요.");
					$("#new_pw_con").focus();
					return;
				} else if ($("#new_pw").val() != $("#new_pw_con").val()) {
					alert("입력된 신규 비밀번호가 틀립니다.\n다시 확인해 주세요.");
					$("#new_pw_con").focus();
					return;
				}

				$("#application_form").submit();
			});
		});
	</script>
</body>
</html>
