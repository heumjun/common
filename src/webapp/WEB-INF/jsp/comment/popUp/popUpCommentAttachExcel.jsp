<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Excel Import</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<script src="//github.com/fyneworks/multifile/blob/master/jQuery.MultiFile.min.js" type="text/javascript" language="javascript"></script>

<style>
	.popMainDiv{margin:10px; }
	.popMainDiv .WarningArea{width:490px;  border:1px solid #ccc; padding:8px; margin-bottom:0px; }
	.popMainDiv .WarningArea .tit{font-size:12pt; margin-bottom:6px; color:red; font-weight:bold;}	
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
	<div class="content" style="float:center; position:absolute; border:none; margin:5px 0 0 13px;">
		<table class="searchArea2 conSearch" style="width: 99%; float: center; margin:2px;">
			<col width="220"/>
			<col width="*"/>
			<tr>
				<td style="border-right:none;">
					<input type="file" name="fileName" id="fileName" size="51"  multiple="true" />
				</td>
				<td style="border-left:none;">
					<input type="button" value="확인" id="btnExlUp" class="btn_blue2"/>
					<input type="button" value="닫기" id="btnClose" class="btn_blue2"/>
				</td>
			</tr>
		</table>
		<br />
		<div id="some_file_queue" style="width:400px; height:300px; overflow: auto;"></div>
	</div>

</form>
<script type="text/javascript" >

var idx = 0;

//File Implode Submit Form 셋팅.
$(function() {
	$("#fileName").uploadify({
		auto 		: false,
		method   	: 'post',              //파하미터 전송 방식
		swf     	: '/images/system/uploadify.swf',
		uploader 	: 'commentReceiptExcelImportAction.do',
		height  	: 30,
		width    	: 120,
		queueID  	: 'some_file_queue', 
		fileDataName: 'fileName',
		onSelect : function(file){
			
			if(file.name == "CommentReceiptAdd.xlsx") {
				$('#fileName').uploadify('upload', file.id);
			}
			
		},
        onUploadSuccess : function(file, data, response) {  // 업로드 성공 후 업로드한 이미지를 해당 div에 세팅
        	
        	var name = file.name;
        	
        	var objfile = JSON.parse(data);
        	
        	var args = window.dialogArguments;
			var jsonGridData = new Array();
        
        	if(name == "CommentReceiptAdd.xlsx") {
    			
    			//Json Grid 에 넣기 위해 엑셀에서 받아온 헤더를 치환.
    			for(var i=0; i<objfile.rows.length; i++){
    				var rows = objfile.rows[i];
    				jsonGridData.push({project_no : rows.column0.toUpperCase()
    					             , doc_type : rows.column1.toUpperCase()
    					             , issuer : rows.column2.toUpperCase()
    					             , subject : rows.column3
    					             , issue_date : rows.column4.toUpperCase()
    					             , com_no : rows.column5.toUpperCase()
    					             , receipt_team_name : rows.column6.toUpperCase()
    					             , receipt_team_code : rows.column8
    					             , dwg_no : rows.column7.toUpperCase()
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
    			args.$("p_excel").val("N");
    			
        	} else {
        		
        		var rows = args.jqGridObj.getDataIDs();
        		
        		for ( var i = 0; i < rows.length; i++ ) {
        			
        			var subject = args.jqGridObj.getCell( rows[i], "subject" );
        			var tmpName = name.substring(0, name.lastIndexOf("."));
        			
        			if(tmpName == subject) {
        				args.jqGridObj.setCell(rows[i], 'document_name', name);
        				args.jqGridObj.setCell(rows[i], 'dec_document_name', objfile.rows[0].dec_document_name);
        			}
        			
        		}
        		
        	}
			
         },
         onQueueComplete : function(file) {
        	 //self.close();
         }
         
	}); // uploadify function end
	
}); 


$(document).ready(function(){
	
	//Close 버튼 클릭.
	$("#btnClose").click(function(){
		self.close();
	});
	
	$("#btnExlUp").click(function(){
		
		$('#fileName').uploadify('upload','*');
		setTimeout(function(){ 
			self.close();
		}, 20000);
		
    });

});	//ready function end

</script>
</body>
</html>