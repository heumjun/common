<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
	<div
		style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
		<img src="/images/main/tit_notice.gif" style="padding-top: 10px; padding-bottom: 6px; padding-left: 10px;" />
	</div>
	<table class="table_st01">
		<col width="85px">
		<col width="240px">
		<col width="85px">
		<col width="240px">
		<thead>
			<tr>
				<th><strong>등록자</strong></th>
				<td>${notice.create_by_name}</td>
				<th><strong>등록일자</strong></th>
				<td class="end" style="border-right: none;">${notice.create_date}</td>
			</tr>
			<tr>
				<th><strong>제목</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3">${notice.subject}</td>
			</tr>
			<tr>
				<th><strong>내용</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3"><textarea cols="100" rows="20"
						readonly="readonly" style="border: 0px;">${notice.contents}</textarea></td>
			</tr>
			<tr>
				<th><strong>파일</strong></th>
				<td class="end" style="border-right: none; text-align: left;" colspan="3"><a href="#none" style="cursor:pointer;vertical-align:middle;" onclick="javascript:fileView('${notice.seq}')">${notice.filename}</a></td>
			</tr>
		</thead>
	</table>
	<div style="float: right; padding: 5px 5px;">
		<input type="button" class="btnAct btn_blue" id="btnList" name="btnList" value="목록" />
	</div>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#btnList").click(function() {
				document.location.href = "popUpNoticeList.do";
			});
		});
		
		function fileView(seq ) {
			var attURL = "noticeFileView.do?";
		    attURL += "p_seq="+seq;
		
		    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
		
		    //window.showModalDialog(attURL,"",sProperties);
		    window.open(attURL,"",sProperties);
		    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
		}
	</script>
</body>
</html>
