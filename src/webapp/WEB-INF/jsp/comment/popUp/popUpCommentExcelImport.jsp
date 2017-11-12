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
	$(document).ready(function(){
		//Close 버튼 클릭.
		$("#btnClose").click(function(){
			self.close();
		});
		//엑셀 업로드 클릭
		$("#btnExlUp").click(function(){
			
			var args = window.dialogArguments;
			args.$(".loadingBoxArea").show();
			
			var file = $("#fileExl").val().toLowerCase();
			if(!isExcelFile(file)){
				return false;	
			}
			
			$('#application_form').submit();
		});
		//File Implode Submit Form 셋팅.
		(function() {
			
			var args = window.dialogArguments;
			var projectNo = args.$("input[name=p_project_no]").val();
			var dwgNo = args.$("input[name=p_dwg_no]").val();
			var issuer = args.$("input[name=p_issuer]").val();
			var receiptNo = args.$("#p_receipt_no").find("option:selected").val();
			var receiptDetailId = args.$("#p_receipt_no").find("option:selected").attr("name");
			
			//Excel 업로드 제한.
			var limitCnt = 100000000;
			
			var form = $('#application_form');
			
			var url = "commentExcelImportAction.do?p_project_no=" + projectNo + "&p_dwg_no=" + dwgNo + "&p_issuer=" + issuer + "&p_receipt_no=" + receiptNo + "&p_receipt_detail_id=" + receiptDetailId;
			
			//getAjaxJsonFormAsyncForTarget(url,form,callback); 
			
			var jsonObj;

			//ajax 를 이용해  multipart/form 넘김....
			form.ajaxForm(
			{
				url:url,		
				data: jsonObj,
				dataType : 'json',
				success:function(jsonObj)
				{
					callback(jsonObj);
				},
				error:function(jxhr,textStatus)
				{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
					/* if(textStatus=="parsererror") {
						callback(eval(jxhr.responseText));
					} */
				}
			});
			
			
		})();
		
	});
	
	//엑셀 파일 체크
	var isExcelFile = function(file) {
		var args = window.dialogArguments;
		if(file == "" || ( file.indexOf(".xls") < 0 && file.indexOf(".xlsx") < 0) ){
			alert("Enter a file or Check the file format");
			args.$(".loadingBoxArea").hide();
			return false;
		}else{
			return true;
		}
	}
	
	var callback = function(json) {
		
		var args = window.dialogArguments;
		var jsonGridData = new Array();
		
		//Json Grid 에 넣기 위해 엑셀에서 받아온 헤더를 치환.
		for(var i=0; i<json.rows.length; i++){
			var rows = json.rows[i];
			jsonGridData.push({receipt_no : rows.receipt_no
				             , list_no : rows.list_no
				             , sub_no : rows.sub_no
				             , sub_title : rows.sub_title
				             , initials : rows.initials
				             , upload_enable_flag : rows.upload_enable_flag
				             , upload_result : rows.upload_result
				             , work_key :  rows.work_key
				             , oper : 'I'});
		}
		
		args.jqGridObj.jqGrid( "clearGridData" );

		var cnt = jsonGridData.length * 1;
		args.jqGridObj.jqGrid('setGridParam',
        { 
            datatype: 'local',
            data: jsonGridData,
            rowNum :  cnt,
            gridview: true,
            loadonce : false,
            jsonReader : {
              	repeatitems: false,
            }
        }).trigger("reloadGrid");
		args.$(".loadingBoxArea").hide();
		self.close();
	}
    
</script>
</body>
</html>