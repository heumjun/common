<%--*************************************
@DESCRIPTION				: Ems Db(Main)
@AUTHOR (MODIFIER)			: Hwang Sung Jun
@FILENAME					: tbc_EmsDbMain.jsp
@CREATE DATE				: 2015-02-12
*************************************--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		
		<style>
			.headerBD {position:relative; height:80px; }
			.content {position:relative; width:280px; height:200px; overflow: auto; text-align:center;}
		</style>
		<title>
			EMS - POS Upload
		</title>
	</head>
	
	<body>
		<form id="application_form" name="application_form" action="popUpPurchasingSpecUploadFile.do" method="post" enctype="multipart/form-data">
		
			<input type="hidden" name="p_daoName" value="" />
			<input type="hidden" name="p_queryType" value="" />
			<input type="hidden" name="p_process" value="" />
			<input type="hidden" id="p_master" name="p_master" value="${p_master}" />
			<input type="hidden" id="p_dwg_no" name="p_dwg_no" value="${p_dwg_no}" />
			<input type="hidden" id="p_row_id" name="p_row_id" value="${p_row_id}" />
			<input type="hidden" id="rowCnt" name="rowCnt" value="" />
			<div class="headerBD">
				<table class="searchArea conSearch">
					<tr>						
						<td style="text-align:right;padding-right:10px;">
							<input type="button" value="ADD" id="btnAdd" class="btn_blue" />
							<input type="button" value="업로드" id="btnUpload" class="btn_blue" />					
							<input type="button" value="닫기" id="btnClose" class="btn_blue" />	
						</td>
					</tr>
				</table>
				<table class = "searchArea2">
					<tr>
						<th>MASTER</th>
						<td>${p_master}</td>
						<th>DWG No.</th>
						<td>${p_dwg_no}</td>
					</tr>
				</table>	
			</div>

			<div class="content">
				<table id="example">
					<tr>
						<td width="10px">1</td>
						<td>
							<input type="file" id="p_tech_spec_0" name="p_tech_spec_0" />
						</td>
					</tr>
				</table>
			</div>
		</form>
	</body>
	<script type="text/javascript" >
		var rowCnt = 1;
		$(document).ready(function(){
			
		});			
			
		//########  Upload 버튼 ########//
		$("#btnUpload").click(function(){
			var fileId = new Array;
							
			for(var a = 0; a < rowCnt; a++) {
				var file = $("#p_tech_spec_"+a).val().toLowerCase();
				
				if(file == "") {
					alert("업로드할 파일을 선택하여 주십시오.");
					return;
				}
				//if(!isExcelFile(file)){				
				//	return;
				//}
			}
				//fileId[a] = file;
				

			var form = $('#application_form');
			$("#rowCnt").val(rowCnt);
			
			form.submit(); 
			
			/* var url = "popUpPurchasingSpecUploadFile.do?rowCnt="+rowCnt;

			$(".loadingBoxArea").show();

			form.ajaxForm(
			{
				url:url,
				data:form.serialize(),
				dataType : 'json', 
				success:function(data)
				{
					fileUpload();
					$(".loadingBoxArea").hide();
				},
				error:function(jxhr,textStatus)
				{
					if(textStatus=="parsererror") 
						UpCallback($('#application_form'),eval(jxhr.responseText));
				}
			}); */
			//form.submit();
			
			//var p_spec_review_id = $("#p_spec_review_id").val();
			//opener.fileUpload(fileId, p_spec_review_id);
			//window.close();
		});
		
		//######## 추가버튼 ########//					
		$("#btnAdd").click(function(){
			rowCnt++;
			//if(rowCnt < 9) {
			//	$("#btnDel").attr("disabled",true);
			//} else {
			//	$("#btnDel").attr("disabled",false);
			//}
			
			$("#example").append("<tr><td>"+rowCnt+"</td><td><input type=\"file\" id=\"p_tech_spec_"+(rowCnt-1)+"\" name=\"p_tech_spec_"+(rowCnt-1)+"\" /></td></tr>");
		});				
	
		var UpCallback = function(form, json){
			//메시지 Call
			var msg = "";
			var file_id = "";
			for(var keys in json)
			{
				for(var key in json[keys])
				{
					if(key=='Result_Msg')
					{
						msg=json[keys][key];
					}
					if(key=='file_id')
					{
						file_id=json[keys][key];
					}
				}
			}
			alert(msg);
			
			if(msg.indexOf('완료') > -1) {
				var row_id = $("#p_row_id").val();
				opener.fileUpload(file_id, row_id);
				$(".loadingBoxArea").hide();
				window.close();
			}
		}
			
		//PDF 파일 체크
		var isExcelFile = function(file){
			if(file == "" || file.indexOf(".pdf") < 0){
				alert("PDF파일만 등록할 수 있습니다.");
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
		
		//파일 업로드 이후 부모 List에 파일 Bind
		function fileUpload() {
			var file_spt = parent.$("#p_file_ids").val().split(",");
			var file_ids_text = "";
			
			for(var i=0; i<file_spt.length; i++ ){
				file_ids_text += "<img src=\"/images/pdf_icon.gif\" border=\"0\" style=\"cursor:hand;\" onclick=\"fileView('"+file_spt[i]+"');\" />";
			}
			
			$('#jqGridPlanSpecList').jqGrid('setRowData',parent.$("#p_row_id").val(), {d_file_ids:file_ids, d_files:file_ids });
		}
	</script>
</html>