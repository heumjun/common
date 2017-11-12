<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>MODEL SHIP TYPE</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">
<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
<input type="hidden" id="sType" name="sType" value="model_ship_type" />
<input type="hidden" id="p_ship_category" name="p_ship_category" />
<input type="hidden" id="p_ship_category2" name="p_ship_category2" value="${p_ship_category2}"/>



<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		CODE : 
 		<input type="text" id="p_sd_code" name="p_sd_code" value="" style="text-transform:uppercase;"  class="w50h25" onchange="javascript:this.value=this.value.toUpperCase();"/>
 		DESC : 
 		<input type="text" id="p_sd_desc" name="p_sd_desc" value="" style="text-transform:uppercase;" class="w100h25"  onchange="javascript:this.value=this.value.toUpperCase();"/>
	</div>
	<div class="button">
		<input type="button" id="btncheck" value="확인" class="btn_blue"/>
		<input type="button" id="btnfind" value="조회" class="btn_blue" />
		<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
	</div>
</div>
<div class="content">
	<table id="dwgList"></table>
	<div id="btn_dwgList"></div>
</div>
		






</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function() {
	//부모창에서 ship_category 가져와 p_ship_category 값 설정
	var openerObj = window.dialogArguments;
	$( "#p_ship_category" ).val( openerObj.$( "#h_ship_category" ).val() );
	
	$("#dwgList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'popUpModelShipTypeList.do',
             postData : fn_getFormData("#application_form"),
             editUrl: 'clientArray',
             colNames:['CODE','DESCRIPTION'],
                colModel:[
                    {name:'sd_code',index:'sd_code', width:40, editable:false, sortable:false, align : 'center' },
                    {name:'sd_desc',index:'sd_desc', width:125, editable:false, sortable:false }
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             rowNum: -1, 
             height: 300,
             //pager: $('#btn_dwgList'),
              
             jsonReader : {
                 root: "rows",
                 page: "page",
                 total: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var rowData = $(this).getRowData(rowId); 
//     			var sd_code = rowData['object'];
    			var returnValue = new Array();
//       			returnValue[0] = sd_code.substring(0, 5);
//       			returnValue[1] = sd_code.substring(5, 8);
      			
  				var sd_code = rowData['sd_code'];
  				var sd_desc = rowData['sd_desc'];
  				returnValue[0] = sd_code;
  				returnValue[1] = sd_desc;
  				
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function (data) {
			 	var allRowsInGrid = $('#dwgList').jqGrid('getRowData');
			 	var ids = $("#dwgList").jqGrid('getDataIDs');
  			    if(allRowsInGrid.length==1){
				    var rowId = ids[0];
				    var rowData = $('#dwgList').jqGrid ('getRowData', rowId);
	    			var returnValue = new Array();
// 				    var sd_code = rowData['object'];
// 	      			returnValue[0] = sd_code.substring(0, 5);
//       				returnValue[1] = sd_code.substring(5, 8);
      				
      				var sd_code = rowData['sd_code'];
      				var sd_desc = rowData['sd_desc'];
      				returnValue[0] = sd_code;
      				returnValue[1] = sd_desc;
      				
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
		
		var sUrl = "popUpModelShipTypeList.do";
		$("#dwgList").jqGrid('setGridParam',{url:sUrl,page:1,datatype: 'json',postData:fn_getFormData("#application_form")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		var ret = $("#dwgList").getRowData(row_selected);
  		if(ret.object==null){
  			alert('Please row select');
  		}
		var returnValue = new Array();
		var sd_code = ret.sd_code;
		var sd_desc = ret.sd_desc;
		returnValue[0] = sd_code;
		returnValue[1] = sd_desc;
		window.returnValue = returnValue;
		self.close();
	});
    
});
</script>
</body>
</html>
