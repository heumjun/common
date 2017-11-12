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
			.content {position:relative; width:550px; height:30px; text-align:center;}
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
		<form id="application_form" name="application_form" action="popUpPurchasingPosUploadFile.do" onsubmit="return fsubmit(this);" method="post" enctype="multipart/form-data">
		
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
					<input type="submit" class="btn_blue" value="UPLOAD" />
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
				//########  Upload 버튼 ########//
				$("#btnUpload").click(function(){
					var file = $("#p_pos_file").val().toLowerCase();

					if(file == "") {
						alert("업로드할 파일을 선택하여 주십시오.");
						return;
					}

// 					var form = $('#application_form');
// 					var url = "emsPurchasingPosUploadFile.do";
// 					$(".loadingBoxArea").show();
// 					form.ajaxForm(
// 					{
// 						url:url,
// 						data:form.serialize(),
// 						dataType : 'json', 
// 						success:function(data)
// 						{
// 							UpCallback($('#application_form'),data);
							
// 						},
// 						error:function(jxhr,textStatus)
// 						{
// 							if(textStatus=="parsererror") 
// 								UpCallback($('#application_form'),eval(jxhr.responseText));
// 						}
// 					});
// 					form.submit();	
					
					
					var sUrl = "emsPurchasingPosUploadFile.do";
					
					$(".loadingBoxArea").show();
					$.post(sUrl,$("#application_form").serialize(),function(json)
					{
						afterDBTran(json);
						$(".loadingBoxArea").hide();
					},"json");

				});						
			});			
				
			var UpCallback = function(form, json){
				//메시지 Call
				var msg = "";
				var renVal = "";
				for(var keys in json)
				{
					for(var key in json[keys])
					{
						if(key=='Result_Msg')
						{
							msg=json[keys][key];
						}else if(key=='returnVal')
						{
							renVal=json[keys][key];
						}
					}
				}
				alert(msg);
				//opener.jqGridReload();
				opener.$("#p_file_id").val(renVal);
				//파일이 있을 경우 메시지 표시
				if(renVal > 0){
					opener.$(".warningArea").show();
				}
				
				$(".loadingBoxArea").hide();
				window.close();
			
			}
				
			//PDF 파일 체크
			var isExcelFile = function(file){
				if(file == "" || file.indexOf(".pdf") < 0){
					alert("Enter a file or Check the file format");
					return false;
				}else{
					return true;
				}
			}			
			
			//########  닫기버튼 ########//
			$("#btnClose").click(function(){
				window.close();					
			});
	
			//######## 메시지 Call ########//
			var afterDBTran = function(json){
	
			 	var msg = "";
				for(var keys in json)
				{
					for(var key in json[keys])
					{
						if(key=='Result_Msg')
						{
							msg=json[keys][key];
						}
					}
				}
					alert(msg);
			}
						
			//Header 체크박스 클릭시 전체 체크.
			var clickSubchkAll = function(){
				if(($("input[name=p_chkitem]").is(":checked"))){
					$(".chkboxItem").prop("checked", true);
				}else{
					$(".chkboxItem").prop("checked", false);
				}
			}
			
			//Body 체크박스 클릭시 Header 체크박스 해제
			var SubchkItemClick = function(){	
				$("input[name=p_chkitem]").prop("checked", false);
			}
			
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