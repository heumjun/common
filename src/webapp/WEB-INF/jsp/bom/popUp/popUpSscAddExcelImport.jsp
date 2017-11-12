<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
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
			- 업로드 가능한 파일의 확장자는 <b><u style="font-size: 12px; color: red;">.xls</u> <u style="font-size: 12px; color: red;">.xlsx</u></b>입니다.<br />
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
			var master = args.$("input[name=p_master_no]").val();
			var dwgno = args.$("input[name=p_dwg_no]").val();
			var item_type_cd = args.$("input[name=p_item_type_cd]").val();
			//Excel 업로드 제한.
			var seriesCnt = args.$("input[name=p_series]:checked").length;			
			var limitCnt = 100000000;
			
			var form = $('#application_form');
			
			var target = args.$("#InputArea");
			var url = "sscAddExcelImportAction.do?p_master_no="+master+"&p_dwg_no="+dwgno+"&p_item_type_cd="+item_type_cd+"&p_series_cnt="+seriesCnt+"&p_limit_cnt="+limitCnt;
			
			//getAjaxJsonFormAsyncForTarget(url,form,callback); 
			
			var jsonObj;

			form.ajaxForm(//ajax 를 이용해  multipart/form 넘김....
			{
				url:url,		
				data:jsonObj,
				dataType : 'json',
				success:function(jsonObj)
				{
					callback(jsonObj);
				},
				error:function(jxhr,textStatus)
				{ //에러인경우 Json Text 를  Json Object 변경해 보낸다.
					if(textStatus=="parsererror") {
						callback(eval(jxhr.responseText));
					}
				}
			});
			
			
		})();
		
	});
	
	//엑셀 파일 체크
	var isExcelFile = function(file){
		var args = window.dialogArguments;
		if(file == "" || ( file.indexOf(".xls") < 0 && file.indexOf(".xlsx") < 0) ){
			alert("Enter a file or Check the file format");
			args.$(".loadingBoxArea").hide();
			return false;
		}else{
			return true;
		}
	}
	
	var callback = function(json){
		var args = window.dialogArguments;
		
		var master = args.$("input[name=p_master_no]").val();
		var dwgno = args.$("input[name=p_dwg_no]").val();
		var item_type_cd = args.$("input[name=p_item_type_cd]").val();
		
		var jsonGridData = new Array();

		//Json Grid 에 넣기 위해 엑셀에서 받아온 헤더를 치환.
		for(var i=0; i<json.rows.length; i++){
			var rows = json.rows[i];
			
			if(item_type_cd == "PI"){
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , bom_qty : rows.column5.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "SU"){
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , key_no : rows.column5.toUpperCase()
					             , bom_qty : rows.column6.toUpperCase()
					             , item_weight : rows.column7.toUpperCase()
					             , attr02 : rows.column8.toUpperCase()
					             , attr04 : rows.column9.toUpperCase()
					             , paint_code1 : rows.column10.toUpperCase()
					             , paint_code2 : rows.column11.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "VA") {
				jsonGridData.push({master_ship 	: master
					             , dwg_no 		: dwgno
					             , block_no 	: rows.column0.toUpperCase()
					             , stage_no 	: rows.column1.toUpperCase()
					             , str_flag 	: rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code 	: rows.column4.toUpperCase()
					             , key_no 		: rows.column5.toUpperCase()
					             , temp10 		: rows.column6.toUpperCase()
					             , temp01 		: rows.column7.toUpperCase()
					             , temp02 		: rows.column8.toUpperCase()
					             , temp03 		: rows.column9.toUpperCase()
					             , temp04 		: rows.column10.toUpperCase()
					             , temp05 		: rows.column11.toUpperCase()
					             , temp06 		: rows.column12.toUpperCase()
					             , temp07 		: rows.column13.toUpperCase()
					             , oper 		: 'I'});
			} else if(item_type_cd == "SE") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , item_category_code : rows.column5.toUpperCase()
					             , key_no : rows.column6.toUpperCase()
					             , bom_qty : rows.column7.toUpperCase()
					             , item_weight : rows.column8.toUpperCase()
					             , temp01 : rows.column9.toUpperCase()
					             , temp02 : rows.column10.toUpperCase()
					             , paint_code1 : rows.column11.toUpperCase()
					             , temp03 : rows.column12.toUpperCase()
					             , temp04 : rows.column13.toUpperCase()
					             , temp05 : rows.column14.toUpperCase() 
					             , oper : 'I'});
			} else if(item_type_cd == "CA") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , attr01 : rows.column5.toUpperCase()
					             , attr02 : rows.column6.toUpperCase()
					             , temp01 : rows.column7.toUpperCase()
					             , attr03 : rows.column8.toUpperCase()		                          
					             , oper : 'I'});
			} else if(item_type_cd == "OU") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , attr01 : rows.column5.toUpperCase()
					             , bom_qty : rows.column6.toUpperCase()
					             , item_weight : rows.column7.toUpperCase()
					             , bom_item_detail : rows.column8.toUpperCase()
					             , paint_code1 : rows.column9.toUpperCase()
					             , paint_code2 : rows.column10.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "PA") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , bom_qty : rows.column5.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "GE") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , bom_qty : rows.column5.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "TR") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , item_category_code : rows.column5.toUpperCase()
					             , key_no : rows.column6.toUpperCase()
					             , bom_qty : rows.column7.toUpperCase()
					             , item_weight : rows.column8.toUpperCase()
					             , temp01 : rows.column9.toUpperCase()
					             , paint_code1 : rows.column10.toUpperCase()
					             , temp02 : rows.column11.toUpperCase()
					             , temp03 : rows.column12.toUpperCase()
					             , oper : 'I'});
			} else if(item_type_cd == "EQ") {
				jsonGridData.push({master_ship : master
					             , dwg_no : dwgno
					             , block_no : rows.column0.toUpperCase()
					             , stage_no : rows.column1.toUpperCase()
					             , str_flag : rows.column2.toUpperCase()
					             , usc_job_type : rows.column3.toUpperCase()
					             , item_code : rows.column4.toUpperCase()
					             , bom_qty : rows.column5.toUpperCase()
					             , temp01 : rows.column6.toUpperCase()
					             , temp02 : rows.column7.toUpperCase()
					             , temp03 : rows.column8.toUpperCase()
					             , oper : 'I'});
			}
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
		
		args.$("p_excel").val("N");
		args.excelImportType();
		//args.jqGridObj.jqGrid('addRowData', $.jgrid.randId(), jsonGridData, 'last' );
		
		
		//모든 행 job code 셋팅
		//args.setAllJobCode();

		//모든 행 필수 입력 값 조정 세팅
		//args.setAllEditColumn();
		
		
// 		args.$("input[name=p_trayno]").each(function(){
// 			if($(this).val() != ""){
// 				var arrKey = $(this).val().split(",");
// 				$(this).parent().parent().find("input[name=p_ea]").val(arrKey.length);
// 			}
// 		});
		
// 		args.totalEaAction();
// 		args.$("input[name=p_block]").each(function(){
// 			if($(this).parent().parent().find("select[name=p_job_cd]").length > 0){
// 				args.inputBlockKeyIn(this, "block");
// 			}
// 		});
		
		self.close();
	}
    
</script>
</body>

</html>