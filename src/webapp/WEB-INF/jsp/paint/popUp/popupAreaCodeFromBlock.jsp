<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Area Code</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listform" name="listform">
	<input type="hidden"  id="txtCodeGbn"   name="p_code_gbn" 	value="areaCodeFromBlock" 	/>
	<input type="hidden"  id="txtProjectNo" name="project_no" 	value=""   					/>
	<input type="hidden"  id="txtRevision"  name="revision"   	value=""   					/>


	<div class="topMain" style="margin:0px;line-height: 45px;">
		<div class="conSearch">
			<span class="pop_tit">Area</span>
			<input type="text" id="txtAreaCode" name="area_code"   style="width: 150px; height:25px;"/>
					&nbsp;&nbsp;
			<span class="pop_tit">Loss</span>
			<input type="text" id="txtBlockCode" name="loss_code"   style="width: 80px; height:25px;"/>
		</div>
		<div class="button">
			<input type="button" id="btnfind"   value="��ȸ" class="btn_blue"/>
			<input type="button" id="btncheck"  value="Ȯ��" class="btn_blue"/>
			<!-- <input type="button" id="btncancle" value="���" class="btn_blue"/> -->
		</div>
	</div>
	<div class="content">
		<table id="areaCodeList"></table>
	</div>






<!-- 	<div> -->
<!-- 		<span class="pop_tit">Area</span> -->
<!-- 		<input type="text" id="txtAreaCode" name="area_code"   style="width: 150px; height:25px;"/> -->
<!-- 				&nbsp;&nbsp; -->
<!-- 		<span class="pop_tit">Loss</span> -->
<!-- 		<input type="text" id="txtBlockCode" name="loss_code"   style="width: 80px; height:25px;"/> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<table id="areaCodeList" style="width:100%;height:50%"></table> -->
<!-- 	</div> -->
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<input type="button" id="btnfind"   value="ã��" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncheck"  value="Ȯ��" class="btn_blue"/> -->
<!-- 		<input type="button" id="btncancle" value="���" class="btn_blue"/> -->
<!-- 	</div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
		
	$("input[name=project_no]").val(window.dialogArguments["project_no"]);
	$("input[name=revision]").val(window.dialogArguments["revision"]);
	$("input[name=area_code]").val(window.dialogArguments["area_code"]);
	
	$("#areaCodeList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'selectPaintAreaCodeListFromBlock.do',
             postData 	: getFormData("#listform"),
             editUrl  	: 'clientArray',
        	 colNames :['Area Code','Area Desc','Loss Code'],
                colModel:[
                    {name:'area_code',index:'area_code', width:100, sortable:false, editoptions:{size:11}},
                    {name:'area_desc',index:'area_desc', width:120, sortable:false, editoptions:{size:5}},
                    {name:'loss_code',index:'loss_code', width:50, sortable:false, editoptions:{size:5}}
                ],
             gridview	: true,
             cmTemplate: { title: false },
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
      			returnValue[0]  = ret.area_code;
      			returnValue[1]  = ret.area_desc;
      			returnValue[2]  = ret.loss_code;
      			
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function() {
             	var rowCnt = $("#areaCodeList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		//self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#areaCodeList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.area_code;
					returnValue[1]  = ret.area_desc;
					returnValue[2]  = ret.loss_code;
					
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
		var sUrl = "selectPaintAreaCodeListFromBlock.do";
		jQuery("#areaCodeList").jqGrid('setGridParam',{url:sUrl,page:1,postData:getFormData("#listform")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#areaCodeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.area_code;
		returnValue[1] = ret.area_desc;
		returnValue[2] = ret.loss_code;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});

//�������͸� Json Arry�� ����ȭ
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
