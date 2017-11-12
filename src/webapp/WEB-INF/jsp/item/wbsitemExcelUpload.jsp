<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" 	 uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
	<title>ITEM Excel Upload</title>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<%
		String saveType = request.getParameter("saveType") == null ? "" : request.getParameter("saveType").toString();
	%>
	<body>
		<div id="body">
		<h1 class="ex_upload">ITEM Excel Upload</h1><br />
		<form id="application_form" name="application_form" enctype="multipart/form-data" action="wbsitemExcelImport.do" method="post">
			<input type="hidden" 	id="txtCatalog_code" 	name="catalog_code"   value=<c:out value="${catalog_code}" />>
			<input type="hidden" 	id="saveType" 	name="saveType"   value="<%=saveType %>" />
			<input type="hidden" 	id="txtDelete_Yn" 		name="delete_yn" 	  value="" />
			<div>
				<div class="txt_box">
					<div class="red_txt">�� Warning</div>
					- ���ε� ������ ������ Ȯ���ڴ� <b><u>.xls .xlsx</u></b>�Դϴ�.<br />
					<!-- - ���ε� ������ <b><u>DRM�� �� ������ ��</u></b> ���ε� �ٶ��ϴ�.<br /> -->
					- �ٿ���� ������ �����  <b><u>������ ��� ������ �߻�</u></b> �մϴ�.<br />
				</div>
				<div class="ex_btn">
					<input type="file"   value="Import" name="file" id="fileExl" size="60"/>
					<input type="button" value="Upload" id="btnExlUp" class="btn_blue"/>
					<input type="button" value="Close"  id="btnClose" class="btn_blue"/>
				</div>
			</div>
			
		</form>	
	</div>
	
	
	
		<script type="text/javascript" >
		var loadingBox;
			$(document).ready(function(){
				//Close ��ư Ŭ��.
				$("#btnClose").click(function(){
					self.close();
				});
				//���� ���ε� Ŭ��
				$("#btnExlUp").click(function(){
					loadingBox = new ajaxLoader( $( '#body' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

					if ($("#txtCatalog_code").val() == '' && $("#saveType").val() == '') {
						alert("Catalog�� �������ֽʽÿ�.");
						return false;
					}
					
					
					
					var file = $("#fileExl").val().toLowerCase();
					
					if(isExcelFile(file)){
							
						//var url= "catalogItemExist.do?catalog_code="+$("#txtCatalog_code").val();
					
						var url			= "catalogItemExist.do";
						var parameters 	= fn_getFormData('#application_form');
						
						$.post(url, parameters, function(data) {
					
							if (data == "Y") {
								
								if (confirm("������ Upload�� �ڷᰡ Temp ���̺� �����մϴ�. �����Ͻðڽ��ϱ�?") == true) {
							 		
							 		$("#txtDelete_Yn").val("Y");
							 		$('#application_form').submit();	
							 	}
							 	
							} else {
								
								$("#txtDelete_Yn").val("N");
								$('#application_form').submit();
							}
							
						} ).always( function() {
					    	loadingBox.remove();
						} );
			
					}else{
						loadingBox.remove();
						return false;				
					}
				});
	
			});
			
			//���� ���� üũ
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