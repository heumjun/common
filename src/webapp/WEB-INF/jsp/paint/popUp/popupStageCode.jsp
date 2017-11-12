<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Stage Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listform" name="listform">
	<input type="hidden" 	id="txtCodeGbn"    name="p_code_gbn" 	value="stageCode" />


	<div class="topMain" style="margin:0px;line-height: 45px;">
		<div class="conSearch">
			<span class="pop_tit">Stage Code</span>
			<input type="text" id="txtStageCode" name="stage_code" style="width:100px; height:25px;"/>
		</div>
		<div class="button">
			<input type="button" id="btnfind"   value="조회" class="btn_blue"/>
			<input type="button" id="btncheck"  value="확인" class="btn_blue"/>
			<!-- <input type="button" id="btncancel" value="취소" class="btn_blue"/> -->
		</div>
	</div>
	<div class="content">
		<table id="stageCodeList"></table>
	</div>













<!-- 	<div> -->
<!-- 		<span class = "spanMargin"> -->
<!-- 			<span class="pop_tit">Stage Code</span> -->
<!-- 			<input type="text" id="txtStageCode" name="stage_code" style="width:100px; height:25px;"/> -->
<!-- 		</span> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<table id="stageCodeList" style="width:100%;height:50%"></table> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<input type="button" id="btnfind"   value="찾기" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncheck"  value="확인" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncancel" value="취소" class="btn_blue"/> -->
<!-- 	</div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
	
	$("input[name=stage_code]").val(window.dialogArguments["stage_code"]);
	$("input[name=project_no]").val(window.dialogArguments["project_no"]);
	$("input[name=revision]").val(window.dialogArguments["revision"]);
	
	$("#stageCodeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'selectPaintStageCodeList.do',
             postData 	: getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames   :['Stage','Block Rate','PE Rate','Dock Rate','Quay Rate',''],
                colModel:[
                    {name:'stage_code',index:'stage_code', width:40, sortable:false},
                    {name:'block_rate',index:'block_rate', width:30, sortable:false, align : 'right'},
                    {name:'pe_rate',   index:'pe_rate',    width:30, sortable:false, align : 'right'},
                    {name:'dock_rate', index:'dock_rate',  width:30, sortable:false, align : 'right'},
                    {name:'quay_rate', index:'quay_rate',  width:30, sortable:false, align : 'right'},
                    {name:'oper',index:'oper', width:25, hidden:true },
                ],
             gridview	: true,
             cmTemplate: { title: false },
             toolbar	: [false, "bottom"],
             autowidth	: true,
             height		: 450,
             rowNum		: 99999,
             cellEdit	: true,             // grid edit mode 1
             
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var ret = jQuery(this).getRowData(rowId); 
    			
    			var returnValue = new Array();
      			returnValue[0]  = ret.stage_code;
      			
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function() {
             	var rowCnt = $("#stageCodeList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		//self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#stageCodeList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.stage_code;
					
					window.returnValue = returnValue;		
					self.close();
             	}	
			 },
			 onSelectRow: function(row_id)
             			  {
                             if(row_id != null) 
                             {
                                 row_selected = row_id;
                             }
                          }
    });
    
    $('#btncancel').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		var sUrl = "selectPaintStageCodeList.do";
		$("#stageCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData:getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#stageCodeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.block_code;
		returnValue[1] = ret.block_desc;
		returnValue[2] = ret.loss_code;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});

$("#txtStageCode").keydown(function (e) {
 
   if (e.which == 13){
	    var sUrl = "selectPaintStageCodeList.do";
		$("#stageCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData: getFormData("#listform")}).trigger("reloadGrid");
		
		return false;
   }
   
});

//폼데이터를 Json Arry로 직렬화
function getFormData(form) {
    var unindexed_array = $(form).serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });
	
    return indexed_array;
}

</script>
</body>
</html>
