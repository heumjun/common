<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 	 uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Catalog Excel Upload</title>
	<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	
	<body>
	
		<h1 class="ex_upload">Catalog Excel Upload</h1><br />
		<form id="application_form" name="application_form" enctype="multipart/form-data" action="catalogExcelImport.do" method="post">
			<input type="hidden" 	id="txtCatalog_code" 	name="catalog_code" 	      value="" />
			<input type="hidden" 	id="txtDelete_Yn" 		name="delete_yn" 			  value="" />
			<div id="uploadDiv">
				<div class="txt_box">
					<div  class="red_txt">※ Warning</div>
					- 업로드 가능한 파일의 확장자는 <b><u>.xls .xlsx</u></b>입니다.<br />
					<!-- - 업로드 파일의 <b><u>DRM을 꼭 해제한 후</u></b> 업로드 바랍니다.<br /> -->
					- 다운받은 파일의 양식을  <b><u>변경할 경우 오류가 발생</u></b> 합니다.<br />
				</div>
				<div class="ex_btn">
					<input type="file"   value="Import" name="file" id="fileExl" size="60" style="border:1px solid #cbcdcd;"/>
					<input type="button" value="Upload" id="btnExlUp" class="btn_blue"/>
					<input type="button" value="Close"  id="btnClose" class="btn_blue"/>
				</div>
			</div>
		</form>	
		<script type="text/javascript" >
			var selCatalog = opener.$("#catalogMain").getRowData(opener.catalog_row);	
			$("#txtCatalog_code").val(selCatalog.catalog_code);
			//$("#txtCatalog_code").val(window.dialogArguments["p_catalog_code"]);
			
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
						
						var url= "infoCatalogAttrExist.do?catalog_code="+$("#txtCatalog_code").val();;
	
						$.get(url, function(data) {
						  
							if (data == "Y") {
								if (confirm("기존에 Upload한 자료가 Temp 테이블에 존재합니다. 삭제하시겠습니까?") == true) {
									var filelodingBox = new uploadAjaxLoader($('#uploadDiv'), {
										classOveride : 'blue-loader',
										bgColor : '#000',
										opacity : '0.3'
									});
									$("#txtDelete_Yn").val("Y");
						 			$('#application_form').submit();		
							 	}
							} else {
								$("#txtDelete_Yn").val("N");
								$('#application_form').submit();
							}
							
						});

					}else{
						return false;				
					}
				});
	
			});
			
			//엑셀 파일 체크
			var isExcelFile = function(file){
				if(file == "" || (file.indexOf(".xls") < 0 && file.indexOf(".xlsx") < 0)) {
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