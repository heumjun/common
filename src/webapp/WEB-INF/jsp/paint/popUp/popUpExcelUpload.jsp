<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	 uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>Paint Excel Upload</title>
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<h1 class="ex_upload">Paint Excel Upload</h1><br />
		<form id="application_form" name="application_form" enctype="multipart/form-data" action="${gbn}" method="post">
			<input type="hidden" id="txtProjectNo"  name="project_no" 	value="${project_no}" />
			<input type="hidden" id="txtRevision"  	name="revision" 	value="${revision}" />
			<input type="hidden" id="p_project_no"  name="p_project_no" value="${p_project_no}" />
			<div>
				<div class="txt_box">
					<div  class="red_txt">※ Warning</div>
					- 업로드 가능한 파일의 확장자는 <b><u>.xls .xlsx</u></b>입니다.<br />
					<!-- - 업로드 파일의 <b><u>DRM을 꼭 해제한 후</u></b> 업로드 바랍니다.<br /> -->
					- 다운받은 파일의 양식을  <b><u>변경할 경우 오류가 발생</u></b> 합니다.<br />
				</div>
				<div class="ex_btn">
					<input type="file"   value="Import" name="file" id="fileExl" size="60"/>
					<input type="button" value="Upload" id="btnExlUp" class="btn_blue"/>
					<input type="button" value="Close"  id="btnClose" class="btn_blue"/>
				</div>
			</div>
			
		</form>	
	
		<script type="text/javascript" >
			var lodingBox;
				
			$(document).ready(function(){
				//Close 버튼 클릭.
				$("#btnClose").click(function(){
					self.close();
				});
				//엑셀 업로드 클릭
				$("#btnExlUp").click(function(){
											
					
					var file = $("#fileExl").val().toLowerCase();
					
					if(isExcelFile(file)){
							
						lodingBox = new uploadAjaxLoader($('#application_form'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});	
						
						$('#application_form').submit();
						
					}else{
						return false;				
					}
				});
	
			});
			
			//엑셀 파일 체크
			
			var isExcelFile = function(file){
				
				if(file == "" || (file.indexOf(".xls") < 0 && file.indexOf(".xlsx") < 0)){
					alert("Enter a file or Check the file format");
					return false;
				}else{
					return true;
				}
			};
			
			var callback = function(){
				self.close();
			};
		     
		</script>
	</body>
</html>