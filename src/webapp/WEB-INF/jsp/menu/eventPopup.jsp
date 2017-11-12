<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>공지사항 팝업</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<script>
   function notice_setCookie( name, value, expiredays ) { 
            var todayDate = new Date(); 
             todayDate.setDate( todayDate.getDate() + expiredays ); 
             document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
    } 
    function notice_closeWin() 
    {  
             if ( document.forms[0].Notice.checked )  
                     notice_setCookie( "Notice_${notice.seq}", "done" , 1); // 1일=하루동안 이 창을 열지 않음 
             self.close();  
    } 
    function na_call(str){  eval(str);} 
    
    function fileView(seq ) {
		var attURL = "noticeFileView.do?";
	    attURL += "p_seq="+seq;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    //window.showModalDialog(attURL,"",sProperties);
	    window.open(attURL,"",sProperties);
	    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");
	}
</script>
</head>
<body>
	<form name="form1">
		<div style="margin: 0px; paddin: 0px; border-top: 8px solid #515a80; border-bottom: 3px double #adb0bb; background: url(/images/main/info_bg.gif-) no-repeat right top;">
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
		<input name="Notice" onclick="notice_closeWin()" type="checkbox">하루동안 이 창을 열지 않음<input type="button" value="닫기" onclick="window.close()">
	</div>
	</form>
</body>
</html>
