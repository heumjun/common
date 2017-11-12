<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DP Ship List</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">
<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="shipList" />
<input type="hidden" id="dept" name="dept" value="${dept}" />
<input type="hidden" id="p_deptGubun" name="p_deptGubun" />
<input type="hidden" id="GrCode" name="GrCode" value="${loginUser.gr_code}"/>
<input type="hidden" id="DpGubun" name="DpGubun" value="${loginUser.dp_gubun}"/>


<div class="topMain" style="margin:0px;line-height: 45px;">
	<div class="conSearch">
		<input type="text" id="p_code_find" name="p_code_find" value="${shipNo}"  style="text-transform:uppercase;"  class="w200h25" onchange="javascript:this.value=this.value.toUpperCase();"/>
	</div>
	<div class="button">
		<input type="button" id="btnfind" value="조회"  class="btn_blue"/>
		<input type="button" id="btncheck" value="확인" class="btn_blue" />
		<input type="button" id="btncancle" value="닫기" class="btn_blue" />
	</div>
</div>
<div class="content">
	<table id="shipList"></table>
	<div id="btn_shipList"></div>
</div>






<!-- <div class="pop_sarea"> -->
<%-- <input type="text" id="p_code_find" name="p_code_find" value="${shipNo}"  style="text-transform:uppercase;"  class="w200h25" onchange="javascript:this.value=this.value.toUpperCase();"/> --%>

<!-- <div class="button"> -->
<!-- 	<input type="button" id="btnfind" value="찾기" class="btn_blue"/> -->
<!-- 	<input type="button" id="btncheck" value="확인" class="btn_blue"/> -->
<!-- 	<input type="button" id="btncancle" value="취소" class="btn_blue"/> -->
<!-- </div> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="shipList" style="width:100%;height:50%"></table> -->
<!-- 	<div id="btn_shipList"></div> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px; margin-right:10px; float:right;"> -->
<!-- </div> -->
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
	
	var openerObj = window.dialogArguments;
	var main_params = openerObj.fn_main_getFormData();
	
	$( "#p_code_find" ).val( main_params.shipNo );
	$( "#dept" ).val( main_params.dept );
	$( "#p_deptGubun" ).val( main_params.p_deptGubun );
	
	$("#shipList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'selectDPShipList.do',
             postData : fn_getFormData( '#application_form' ),
             editUrl: 'clientArray',
             colNames:['호선'],
                colModel:[
                    {name:'projectno',index:'projectno', width:125, editable:false, sortable:false, editrules:{required:true},},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             rowNum: -1, 
             height: 350,
             //pager: jQuery('#btn_shipList'),
              
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
    			var sd_code = rowData['projectno'];
    			
    			var returnValue = new Array();
      			returnValue[0] = sd_code;
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function (data) {
			 	var allRowsInGrid = $('#shipList').jqGrid('getRowData');
			 	var ids = jQuery("#shipList").jqGrid('getDataIDs');
  			    if(allRowsInGrid.length==1){
				    var rowId = ids[0];
				    var rowData = jQuery('#shipList').jqGrid ('getRowData', rowId);
				    var sd_code = rowData['projectno'];
	    			
	    			var returnValue = new Array();
	      			returnValue[0] = sd_code;
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
		var sUrl = "selectDPShipList.do";
		$( "#shipList" ).jqGrid( 'setGridParam',{
			url:sUrl,
			page:1,
			datatype: 'json',
			postData : fn_getFormData( '#application_form' )
		} ).trigger( "reloadGrid" );
	});
	
	
	$('#btncheck').click(function(){
  		var ret = jQuery("#shipList").getRowData(row_selected);
  		if(ret.projectno==null){
  			alert('Please row select');
  		}
		var returnValue = new Array();
		returnValue[0] = ret.projectno;
		window.returnValue = returnValue;
      			
		self.close();
	});
    $("#cmtype").keydown(function (e) {
	   if (e.which == 9){
	   		return;
	   }
	   if (e.which == 13){
	   		return;
	   }
	});
});
</script>
</body>
</html>
