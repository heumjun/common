<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	 uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>ITEM Excel Upload</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	
	<body>
		<h1 class="ex_upload">ITEM Excel Upload</h1><br />
		<form id="application_form" name="application_form" enctype="multipart/form-data" action="itemExcelImport.do" method="post">
			<input type="hidden" 	id="txtCatalog_code" 	name="catalog_code"   value=<c:out value="${catalog_code}" />>
			<input type="hidden" 	id="txtDelete_Yn" 		name="delete_yn" 	  value="" />
			<div>
				<div class="txt_box">
					<div class="red_txt">※ Warning</div>
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
			
			$(document).ready(function(){
				//Close 버튼 클릭.
				$("#btnClose").click(function(){
					self.close();
				});
				//엑셀 업로드 클릭
				$("#btnExlUp").click(function(){
							
					if ($("#txtCatalog_code").val() == '') {
						alert("Catalog를 선택해주십시오.");
						return false;
					}
										
					var file = $("#fileExl").val().toLowerCase();
					
					if(isExcelFile(file)){
							
						//var url= "catalogItemExist.do?catalog_code="+$("#txtCatalog_code").val();
					
						var url			= "tempCatalogItemExist.do";
						var parameters 	= fn_getFormData('#application_form');
						
						$.post(url, parameters, function(data) {
					
							if (data == "Y") {
								
								if (confirm("기존에 Upload한 자료가 Temp 테이블에 존재합니다. 삭제하시겠습니까?") == true) {
							 		
							 		$("#txtDelete_Yn").val("Y");
							 		$('#application_form').submit();
							 		//opener.location.href="javascript:fn_search();";
							 		//self.close();
							 	}
							 	
							} else {
								$("#txtDelete_Yn").val("N");
								$('#application_form').submit();
								//self.close();
							}
							
						});
			
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