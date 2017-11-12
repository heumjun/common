<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PopUpBaseInfo</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">
<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
<input type="hidden" id="dept" name="dept" value="${dept}"/>
<input type="hidden" id="shipNo" name="shipNo" value="${shipNo}"/>
<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="dwgList" />
<input type="hidden" id="p_deptGubun" name="p_deptGubun" />
<input type="hidden" id="GrCode" name="GrCode" value="${loginUser.gr_code}"/>
<input type="hidden" id="DpGubun" name="DpGubun" value="${loginUser.dp_gubun}"/>



<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		<input type="text" id="p_dwg_no" name="p_dwg_no" value="" style="text-transform:uppercase;"  class="w100h25" onchange="javascript:this.value=this.value.toUpperCase();"/>
		<input type="text" id="p_block_no" name="p_block_no" value="" style="text-transform:uppercase;" class="w50h25"  onchange="javascript:this.value=this.value.toUpperCase();"/>
	</div>
	<div class="button">
		<input type="button" id="btnfind" value="조회" class="btn_blue" /> 
		<input type="button" id="btncheck" value="확인" class="btn_blue"/>
		<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
	</div>
</div>
<div class="content">
	<table id="dwgList"></table>
	<div id="btn_dwgList"></div>
</div>
		



<!-- <div class="topMain" style="margin:0px;line-height: 45px;"> -->
<!-- 	<div class="conSearch"> -->
<!-- 		<input type="text" id="p_dwg_no" name="p_dwg_no" value="" style="text-transform:uppercase;"  class="w100h25" onchange="javascript:this.value=this.value.toUpperCase();"/> -->
<!-- 		<input type="text" id="p_block_no" name="p_block_no" value="" style="text-transform:uppercase;" class="w50h25"  onchange="javascript:this.value=this.value.toUpperCase();"/> -->
<!-- 	</div> -->
<!-- 	<div class="button"> -->
<!-- 		<input type="button" id="btncheck" value="확인" class="btn_blue" /> -->
<!-- 		<input type="button" id="btnfind" value="조회"  class="btn_blue"/> -->
<!-- 		<input type="button" id="btncancle" value="닫기" class="btn_blue" /> -->
<!-- 	</div> -->
<!-- </div> -->
<!-- <div class="content"> -->
<!-- 	<table id="dwgList"></table> -->
<!-- 	<div id="btn_dwgList"></div> -->
<!-- </div> -->









<!-- <div class="pop_sarea"> -->

<!-- <input type="text" id="p_dwg_no" name="p_dwg_no" value="" style="text-transform:uppercase;"  class="w100h25" onchange="javascript:this.value=this.value.toUpperCase();"/> -->
<!-- <input type="text" id="p_block_no" name="p_block_no" value="" style="text-transform:uppercase;" class="w50h25"  onchange="javascript:this.value=this.value.toUpperCase();"/> -->

<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="dwgList" style="width:100%;height:50%"></table> -->
<!-- 	<div id="btn_dwgList"></div> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px; margin-right:10px; float:right;"> -->
<!-- 	<input type="button" id="btnfind" value="찾기" class="btn_blue"/> -->
<!-- 	<input type="button" id="btncheck" value="확인" class="btn_blue"/> -->
<!-- 	<input type="button" id="btncancle" value="취소" class="btn_blue"/> -->
<!-- </div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
// 	$("input[name=dept]").val(window.dialogArguments["dept"]);
// 	$("input[name=shipNo]").val(window.dialogArguments["shipNo"]);
// 	$("input[name=p_dwg_no]").val(window.dialogArguments["dwgNo"]);
// 	$("input[name=p_block_no]").val(window.dialogArguments["blockNo"]);


	var openerObj = window.dialogArguments;
	var main_params = openerObj.fn_main_getFormData();
	
	$( "#dept" ).val( main_params.dept );
	$( "#shipNo" ).val( main_params.shipNo );
	$( "#p_deptGubun" ).val( main_params.p_deptGubun );
	
	$( "#p_dwg_no" ).val( main_params.dwgNo );
	$( "#p_block_no" ).val( main_params.blockNo );
	
	$("#dwgList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'selectDPDwgList.do',
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['도면'],
                colModel:[
                    {name:'object',index:'object', width:125, editable:false, sortable:false, editrules:{required:true},},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             rowNum: -1, 
             height: 350,
             //pager: jQuery('#btn_dwgList'),
              
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var rowData = jQuery(this).getRowData(rowId); 
    			var sd_code = rowData['object'];
    			var returnValue = new Array();
      			returnValue[0] = sd_code.substring(0, 5);
      			returnValue[1] = sd_code.substring(5, 8);
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function (data) {
			 	var allRowsInGrid = $('#dwgList').jqGrid('getRowData');
			 	var ids = jQuery("#dwgList").jqGrid('getDataIDs');
  			    if(allRowsInGrid.length==1){
				    var rowId = ids[0];
				    var rowData = jQuery('#dwgList').jqGrid ('getRowData', rowId);
				    var sd_code = rowData['object'];
	    			
	    			var returnValue = new Array();
	      			returnValue[0] = sd_code.substring(0, 5);
      				returnValue[1] = sd_code.substring(5, 8);
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
		
		var sUrl = "selectDPDwgList.do";
		jQuery("#dwgList").jqGrid('setGridParam',{url:sUrl,page:1,datatype: 'json',postData:$("#application_form").serialize()}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		var ret = jQuery("#dwgList").getRowData(row_selected);
  		if(ret.object==null){
  			alert('Please row select');
  		}
		var returnValue = new Array();
		var sd_code = ret.object;
		returnValue[0] = sd_code.substring(0, 5);
		returnValue[1] = sd_code.substring(5, 8);
		window.returnValue = returnValue;
		self.close();
	});
    
});
</script>
</body>
</html>
