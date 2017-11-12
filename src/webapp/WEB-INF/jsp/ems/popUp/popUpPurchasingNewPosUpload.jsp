<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.headerBD {position:relative; width:580px; height:30px; }
			.content {position:relative; width:550px;text-align:center;}
			.infoHeader {  height:22px; width:400px; float:left; border:1px solid #aaa }
			.infoTitle {border-bottom:2px solid #3399FF; display:block; background-color:#CDE0F2; padding:4px 4px 0 4px; height:18px; width:60px; font-weight:bold; float:left;}
			.infoCon {border-bottom:2px solid #CCC; display:block;  height:18px; width:60px; float:left; padding:4px 4px 0 0; }
			.infoBtn {display:block; width:150px; float:right; text-align: right;}
		</style>
		<title>
			EMS - POS Upload
		</title>
	</head>
	
	<body>
		<form id="application_form" name="application_form" action="popUpPurchasingNewPosUploadFile.do" method="post" enctype="multipart/form-data" style="width: 100%; height: 100%;">
		
			<input type="hidden" id="p_master" name="p_master" value="${master}" />
			<input type="hidden" id="p_dwg_no" name="p_dwg_no" value="${dwg_no}" />
			<input type="hidden" id="p_reason" name="p_reason" value="${p_reason}" />
			<input type="hidden" id="p_pos_rev" name="p_pos_rev" value="${pos_rev}" />
			
			<div class="headerBD">
				<div class="infoHeader">
					<span class="infoTitle">MASTER</span> <span class="infoCon">${master}</span>
					<span class="infoTitle">DWG NO</span> <span class="infoCon">${dwg_no}</span>
					<span class="infoTitle">POS REV</span> <span class="infoCon">${pos_rev}</span>
					
				</div>
				<div class="button endbox">
					<input type="button" class="btn_blue" value="UPLOAD" id="btnUpload" />
					<input type="button" class="btn_blue" value="CLOSE" id="btnClose" />
				</div>
			</div>

			<div class="content">				
				<input type="file" id="p_pos_file" name="p_pos_file" style="width:100%;"/>				
			</div> 
		</form>
		<script type="text/javascript">	
			$(document).ready(function(){
				window.focus();
				$("body").css("height",$(window).height());
				//########  Upload 버튼 ########//
				$("#btnUpload").click(function(){
					var file = $("#p_pos_file").val().toLowerCase();

					if(file == "") {
						alert("업로드할 파일을 선택하여 주십시오.");
						return;
					}
					
					loadingBox = new uploadAjaxLoader( $("#application_form"), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					$("#application_form").ajaxForm({
						dataType : 'text',
						success:function(jsonObj)
						{
							var jsonData = JSON.parse(jsonObj);
							if(jsonData.result =="fail"){
								alert("업로드에 실패하였습니다.");
								window.close();
								return;
							} else {
								alert("업로드에 성공하였습니다.");
								opener.fileCallBack(jsonData);
								loadingBox.remove();
								window.close();
							}
						},
						error:function(jxhr,textStatus)
						{
							if(textStatus=="parsererror") {
								loadingBox.remove();
								alert(eval(jxhr.responseText));
							}
						}
					}).submit();
				});						
			});			
			
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				window.close();					
			});
			
			function fsubmit(){
				var file = $("#p_pos_file").val().toLowerCase();

				if(file == "") {
					alert("업로드할 파일을 선택하여 주십시오.");
					return false;
				}
				return true;
			}
		</script>
	</body>
</html>