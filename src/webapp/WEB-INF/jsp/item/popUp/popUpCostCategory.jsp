<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>CostCategory</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
<input type="hidden" id="txtCodeGbn" 	   name="p_code_gbn" value="costCategory" />
<input type="hidden" id="part_family_code" name="part_family_code" />

<div>
찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 350px;"/>
</div>
<div style="margin-top: 10px;">
	<table id="costCategoryList" style="width:100%;height:50%"></table>
</div>
<div style="margin-top: 10px;">
	<input type="button" id="btnfind"   value="찾기"/>
	<input type="button" id="btncheck"  value="확인"/>
	<input type="button" id="btncancle" value="취소"/>
</div>
</form>
<script type="text/javascript">
var row_selected;
var part_family_code  = window.dialogArguments["part_family_code"];

$(document).ready(function(){

	$("input[name=part_family_code]").val(part_family_code);
	
	$("#costCategoryList").jqGrid({ 
             datatype: 'json', 
             mtype : 'POST',
             url:'popUpCostCategoryList.do',
             postData : $("#listForm").serialize(),
             editUrl  : 'clientArray',
        	 colNames :['Category_Desc','Category_Code','Category_id'],
                colModel:[
                    {name:'cost_category_desc',index:'cost_category_desc', width:150, editoptions:{size:11}},
                    {name:'cost_category_code',index:'cost_category_code', width:70, editoptions:{size:5}},
                    {name:'cost_category_id',index:'cost_category_id', width:70, editoptions:{size:5}}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 320,
             rowNum: 999999,
           
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
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
    			
    			var returnValue = new Array();
    			returnValue[0] = rowData['cost_category_code'];
      			returnValue[1] = rowData['cost_category_desc'];
      			returnValue[2] = rowData['cost_category_id'];
      			window.returnValue = returnValue;
      			
      			self.close();
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
		var sUrl = "popUpCostCategoryList.do";
		jQuery("#costCategoryList").jqGrid('setGridParam',{mtype: 'POST',url:sUrl,page:1,postData: $("#listForm").serialize()}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#costCategoryList").getRowData(row_selected);  		
		var returnValue = new Array();
		
		returnValue[0] = ret.cost_category_code;
		returnValue[1] = ret.cost_category_desc;
		returnValue[2] = ret.cost_category_id;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});
</script>
</body>
</html>
