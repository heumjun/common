<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Excel Import</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

<style>
	.popMainDiv {
		margin: 10px;
	}
	
	.popMainDiv .WarningArea {
		width: 490px;
		border: 1px solid #ccc;
		padding: 8px;
		margin-bottom: 0px;
	}
	
	.popMainDiv .WarningArea .tit {
		font-size: 12pt;
		margin-bottom: 6px;
		color: red;
		font-weight: bold;
	}
</style>
</head>
<body>
<form id="application_form" name="application_form" method="post">
<input type="hidden" id="row_selected" name="row_selected" value="${row_selected }"/>
	<div class = "topMain" style="margin-top: 0px;">
		<table class="searchArea2 conSearch">
			<col width="120"/>
			<col width="440"/>
				<tr>
					<td>
						<input type="file" name="fileName" id="fileExl" size="51" multiple />
					</td>
				</tr>
		</table>
		<br />
		<div class="button">
			<input type="button" value="확인" id="btnExlUp" class="btn_blue" />
			<input type="button" value="닫기" id="btnClose" class="btn_blue"/>
		</div>
	</div>

</form>
<script type="text/javascript" >
$(document).ready(function() {
	//Close 버튼 클릭.
	$("#btnClose").click(function(){
		self.close();
	});
	
	$("#btnExlUp").click(function() {
		var args = window.dialogArguments;
		$('#application_form').submit();
    });
	//File Implode Submit Form 셋팅.
	(function() {
		
		var jsonObj;
		
		var form = $('#application_form');
		var url = "commentReceiptAttachFileAction.do";

		//ajax 를 이용해  multipart/form 넘김....
		form.ajaxForm(
		{
			url:url,		
			data:jsonObj,
			dataType : 'json',
			success:function(jsonObj)
			{
				callback(jsonObj);
			},
			error:function(jxhr,textStatus)
			{ 
				//에러인경우 Json Text 를  Json Object 변경해 보낸다.
				if(textStatus=="parsererror") {
					callback(eval(jxhr.responseText));
					self.close();
				}
			}
		});
		
	})(); //function end
	
});	//ready function end

var callback = function(json) {
	var args = window.dialogArguments;
	args.$("#jqGridAddMainList").jqGrid('setCell', json.row_selected, 'document_name', json.document_name);
	args.$("#jqGridAddMainList").jqGrid('setCell', json.row_selected, 'dec_document_name', json.dec_document_name);
	self.close();
}
</script>
</body>
</html>