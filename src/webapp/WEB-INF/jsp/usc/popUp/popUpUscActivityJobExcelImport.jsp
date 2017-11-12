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
	<input type="hidden" id="type" name="type" value="" />
	<div class="popMainDiv">
		<div class="WarningArea">
			<div class="tit" >※ Warning</div>
			- 업로드 가능한 파일의 확장자는 <b><u>.xls 또는 .xlsx</u></b>입니다.<br />
			<!-- - 업로드 파일의 <b><u>DRM을 꼭 해제한 후</u></b> 업로드 바랍니다.<br /> -->
			- 다운받은 파일의 양식을  <b><u>변경할 경우 오류가 발생</u></b> 합니다.<br />
		</div>
		<div class="buttonArea">
			<input type="file" value="Import" name="fileName" id="fileExl" size="27"/>
			<input type="button" value="Upload" id="btnExlUp" class="btn_blue2" />
			<input type="button" value="Close" id="btnClose" class="btn_blue2"/>
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
			
			if(file.indexOf(".xlsx") >= 0) {
				$('#type').val("xlsx");					
			} else if(file.indexOf(".xls") >= 0) {
				$('#type').val("xls");	
			}
			
			$('#application_form').submit();
		});
		
		//File Implode Submit Form 셋팅.
		(function() {
			var args = window.dialogArguments;
			//var master = args.$("input[name=p_master_no]").val();
			//var dwgno = args.$("input[name=p_dwg_no]").val();
			//var item_type_cd = args.$("input[name=p_item_type_cd]").val();
			//Excel 업로드 제한.
			//var seriesCnt = args.$("input[name=p_series]:checked").length;	
			var type = "";
			
			var limitCnt = 100000000;

			var form = $('#application_form');

			var target = args.$("#InputArea");
			var url = "uscActivityStdExcelImportAction.do?p_limit_cnt="+limitCnt;

			getAjaxJsonFormAsyncForTarget(url,form,callback);
			
		})();
		
	});
	
	//엑셀 파일 체크
	var isExcelFile = function(file){
		if(file == "" || !(file.indexOf(".xls") > -1 || file.indexOf(".xlsx") > -1)){
			alert("Enter a file or Check the file format");
			return false;
		}else{
			return true;
		}
	}
	
	var callback = function(json){
		
		var args = window.dialogArguments;
		var jsonGridData = new Array();
		
		//Json Grid 에 넣기 위해 엑셀에서 받아온 헤더를 치환.
		for(var i=0; i<json.rows.length; i++){
			var rows = json.rows[i];

			jsonGridData.push({area : rows.column0
				             , block_catalog : rows.column1
				             , block_str_flag : rows.column2
				             , activity_catalog : rows.column3
				             , job_catalog : rows.column4
				             , str_flag : rows.column5
				             , usc_job_type : rows.column6
				             , job_description : rows.column7
				             , activity_area : rows.column8
				             , activity_type : rows.column9
				             , act_description : rows.column10
				             , use_yn : rows.column11
				             , use_yn_changed : rows.column11
				             , remark : rows.column12
				             , oper : 'I'});			
		}
		
		args.jqGridObj.clearGridData(true);
		args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'first' );
		
		self.close();
	}
    
</script>
</body>

</html>