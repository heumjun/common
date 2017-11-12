<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Loss Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listform" name="listform">
	<input type="hidden" 	id="txtCodeGbn"  name="p_code_gbn" 	value="lossCode" />
	
	<div class="topMain" style="margin:0px;line-height: 45px;">
		<div class="conSearch">
			<input type="text" id="txtCodeFind" name="p_code_find"   style="width: 300px;"/>
		</div>
		<div class="button">
			<input type="button" id="btncheck" value="확인" class="btn_blue" />
			<input type="button" id="btnfind" value="조회"  class="btn_blue"/>
			<input type="button" id="btncancle" value="닫기" class="btn_blue" />
		</div>
	</div>
	<div class="content">
		<table id="lossCodeList"></table>
	</div>
	
	
	
	
	
	
	
	
	
	
	
	
<!-- 	<div> -->
<!-- 		찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 350px;"/> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<table id="lossCodeList" style="width:100%;height:50%"></table> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<input type="button" id="btnfind"   value="찾기"/> -->
<!-- 		<input type="button" id="btncheck"  value="확인"/> -->
<!-- 		<input type="button" id="btncancle" value="취소"/> -->
<!-- 	</div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
		
	$("input[name=p_code_find]").val(window.dialogArguments["p_code_find"]);
	
	$("#lossCodeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'infoLossCodeList.do',
             postData 	: fn_getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames :['Loss Code','Loss Desc'],
                colModel:[
                    {name:'loss_code',index:'loss_code', width:100, sortable:false, editoptions:{size:11}},
                    {name:'loss_desc',index:'loss_desc', width:180, sortable:false, editoptions:{size:5}}
                ],
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: true,
             autowidth	: true,
             height		: 380,
             rowNum		: 99999,
           
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
      			returnValue[0]  = ret.loss_code;
      			returnValue[1]  = ret.loss_desc;
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function() {
             	var rowCnt = $("#lossCodeList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		//self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#lossCodeList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.loss_code;
					returnValue[1]  = ret.loss_desc;
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
    
        
    $('#btncancle').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		var sUrl = "infoLossCodeList.do";
		jQuery("#lossCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData:fn_getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#lossCodeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.loss_code;
		returnValue[1] = ret.loss_desc;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});

</script>
</body>
</html>
