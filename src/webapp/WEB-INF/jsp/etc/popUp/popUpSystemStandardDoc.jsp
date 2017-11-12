<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DOCUMENT</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>

<form id="application_form" name="application_form" method="post" enctype="multipart/form-data" action="systemStandardFileUpload.do">
<input type="hidden" id="user_id" name="user_id" value="<c:out value="${loginUser.user_id}" />" />
<div id = "wrap">
	<div style="float:right;margin:10px 10px 10px 0;">
		<input type="submit" class="btn_blue" id="btnUpload"  value="저장">
		<input type="button" class="btn_blue" id="btnClose" value="취소"/>
	</div>
	<table style="margin-left:10px">
		<tr>
			<td><input type=file id="p_file1" name="uploadfile1" size="30" value="" /></td>
		</tr>
		<tr>
			<td><input type=file id="p_file2" name="uploadfile2" size="30" value="" /></td>
		</tr>
		<tr>
			<td><input type=file id="p_file3" name="uploadfile3" size="30" value="" /></td>
		</tr>
		<tr>
			<td><input type=file id="p_file4" name="uploadfile4" size="30" value="" /></td>
		</tr>
  	</table>
</div>

	
</form>

<script type="text/javascript">	
	$(document).ready(function(){
		//Close 버튼 클릭.
		$("#btncancle").click(function(){
			self.close();	
		});	
	});
</script>
</body>
</html>