<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DOCUMENT</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
ul.pop_addfile {width:100%;}
ul.pop_addfile li {float:left; width:100%; border-bottom:1px solid #c7c7c7; padding:10px 10px 10px 20px; margin-bottom:10px;}
.li_box {float:left; margin-right:20px;}
</style>
</head>
<body>
<form id="upload" action="saveDoc.do" method="POST" enctype="multipart/form-data">
	
			<div id="wrap">
				<div class="ex_upload">File & Commentes</div>
				<div style="margin-top:15px; margin-right:10px; float:right;">
					<% String main_code = request.getParameter("maincode") == null ? "" : request.getParameter("maincode").toString(); %>
			 		<input type="hidden" name="main_code" value="<%=main_code%>"/>
			 		<input type="hidden" id="createdby" name="createdby" value="${loginUser.user_id}" />
			 		<input type="hidden" id="data" name="data"/>
					<input type="submit" value="저장" class="btn_blue">
					<input type="button" id="btncancle" value="취소" class="btn_blue"/>
				</div>
				<ul class="pop_addfile mgt10">
				<li>
				<div class="li_box"><input type="file" name="file1" size="30" value="" /></div><div><textarea rows="3" name="commentes1" cols="40" wrap></textarea></div></li>
				<li>
				<div class="li_box"><input type=file name="file2" size="30" value="" /></div><div><textarea rows="3" name="commentes2" cols="40" wrap></textarea></div></li>
				<li>
				<div class="li_box"><input type=file name="file3" size="30" value="" /></div><div><textarea rows="3" name="commentes3" cols="40" wrap></textarea></div></li>
				<li>
				<div class="li_box"><input type=file name="file4" size="30" value="" /></div><div><textarea rows="3" name="commentes4" cols="40" wrap></textarea></div></li>
				<li>
				<div class="li_box"><input type=file name="file5" size="30" value="" /></div><div><textarea rows="3" name="commentes5" cols="40" wrap></textarea></div></li>
				</ul>
			</div>
</form>

<script type="text/javascript">
$(document).ready(function(){

	$('#upload').ajaxForm({
        // 반환할 데이터의 타입. 'json'으로 하면 IE 에서만 제대로 동작하고 크롬, FF에서는 응답을 수신하지
        // 못하는 문제점을 발견하였다. dataType을 정의하지 않을 경우 기본 값은 null 이다.
		dataType : 'text', 
		beforeSerialize: function() {
			// form을 직렬화하기전 엘레먼트의 속성을 수정할 수도 있다.
		},
		beforeSubmit : function() {
			$('#result').html('uploading...');
		},
		success : function(data) {
			
			//$('#result').html('Success - ' + jData.result);
			if ( data == 'success' ) {
				alert("처리가 완료 되었습니다.")
				var returnValue = 'ok';
				window.returnValue = returnValue;
				self.close();
			}
			// 크롬, FF에서 반환되는 데이터(String)에는 pre 태그가 쌓여있으므로
			// 정규식으로 태그 제거. IE의 경우 정상적으로 값이 반환된다.
			//data = data.replace(/[<][^>]*[>]/gi, '');
			
			// JSON 객체로 변환
			//var jData = JSON.parse(data);
			
			//window.returnValue = "success"
			//self.close();
			
			//$('#result').html('Success - ' + jData.result);
		},
		error: function() {
			alert("처리 실패.");
		}
	});

	
	$("#btncancle").click(function(){
		self.close();	
	});	

});

//######## 메시지 Call ########//
var afterDBTran = function(json){

 	var msg = "";
	var result = "";
	for(var keys in json)
	{
		for(var key in json[keys])
		{
			if(key=='Result_Msg')
			{
				msg=json[keys][key];
			}
			
			if(key=='result')
			{
				result=json[keys][key];
			}
		}
	}
	
	if (result == "duplication" || result == "fail") alert(msg);

	return result;
};

/*
function fn_upLoadFile()
	{
		var sUrl = "saveDoc.do.do";
		var f = document.application_form;
				
		f.action = sUrl;
		f.method="post";
		f.enctype="multipart/form-data";
		f.submit();
	
	}
*/

</script>
</body>
</html>