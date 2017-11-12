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
	.popMainDiv{margin:10px; }
	.popMainDiv .WarningArea{width:404px;  border:1px solid #ccc; padding:8px; margin-bottom:20px; }
	.popMainDiv .WarningArea .tit{font-size:12pt; margin-bottom:6px; color:red; font-weight:bold;}	
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
	<div class="popMainDiv">
		<div class="WarningArea">
			<div class="tit" >※ Warning</div>
			- 업로드 가능한 파일의 확장자는 <b><u>.xls</u></b>입니다.<br />
			<!-- - 업로드 파일의 <b><u>DRM을 꼭 해제한 후</u></b> 업로드 바랍니다.<br /> -->
			- 다운받은 파일의 양식을  <b><u>변경할 경우 오류가 발생</u></b> 합니다.<br />
		</div>
		<div class="buttonArea">
			<input type="file" value="Import" name="fileName" id="fileExl" size="27"/>
			<input type="button" value="Upload" id="btnExlUp" class="btn_blue" />
			<input type="button" value="Close" id="btnClose" class="btn_blue"/>
		</div>
	</div>
</form>	

<script type="text/javascript" >
	$(document).ready(function(){
		//Close 버튼 클릭.
		$("#btnClose").click(function(){
			self.close();
		});
		//엑셀 업로드 클릭
		$("#btnExlUp").click(function(){
			var file = $("#fileExl").val().toLowerCase();
			if(!isExcelFile(file)){
				return false;	
			}
			
			$('#application_form').submit();
		});
		
		//File Implode Submit Form 셋팅.
		(function() {
			
			var form = $('#application_form');
			var url = "emsPartListImportAction.do";
			
			getAjaxJsonFormAsyncForTarget(url,form,callback);
			
		})();
		
	});
	
	//엑셀 파일 체크
	var isExcelFile = function(file){
		if(file == "" || file.indexOf(".xls") < 0 || file.indexOf(".xlsx") > 0){
			alert("Enter a file or Check the file format");
			return false;
		}else{
			return true;
		}
	}
	
	var callback = function(data){
		alert(data.resultMsg);
		self.close();
	}
    
</script>
</body>

</html>