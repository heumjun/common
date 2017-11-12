<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>InvCategory</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
<input type="hidden" id="txtCodeGbn" 	   	 name="p_code_gbn" value="invCategory" />
<input type="hidden" id="part_family_code"   name="part_family_code" />
<input type="hidden" id="cost_category_code" name="cost_category_code" />


<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		<input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform: uppercase;" class="w200h25 mgt10" onchange="javascript:this.value=this.value.toUpperCase();" />
	</div>
	<div class="button">
		<input type="button" id="btncheck" value="확인"  class="btn_blue" />
		<input type="button" id="btnfind" value="조회"  class="btn_blue" />
		<input type="button" id="btncancle" value="닫기" class="btn_blue"  />
	</div>
</div>
			<div class="content">
				<table id="invCategoryList"></table>
			</div>






<!-- <div> -->
<!-- 찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 350px;"/> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="invCategoryList" style="width:100%;height:50%"></table> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<input type="button" id="btnfind"   value="찾기"/> -->
<!-- 	<input type="button" id="btncheck"  value="확인"/> -->
<!-- 	<input type="button" id="btncancle" value="취소"/> -->
<!-- </div> -->
</form>
<script type="text/javascript">
var row_selected;
var part_family_code  	= window.dialogArguments["part_family_code"];
var cost_category_code  = window.dialogArguments["cost_category_code"];

$(document).ready(function(){

	$("input[name=part_family_code]").val(part_family_code);
	$("input[name=cost_category_code]").val(cost_category_code);
	
	$("#invCategoryList").jqGrid({ 
             datatype: 'json', 
             mtype : 'POST', 
             url:'popUpInvCategoryList.do',
             postData : $("#listForm").serialize(),
             editUrl  : 'clientArray',
        	 colNames :['Category_Desc','Category_Code','Category_id'],
                colModel:[
                    {name:'inv_category_desc',index:'inv_category_desc', width:150, sortable:false, editoptions:{size:11}},
                    {name:'inv_category_code',index:'inv_category_code', width:70, sortable:false, editoptions:{size:5}},
                    {name:'inv_category_id',  index:'inv_category_id', width:70, hidden : false}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 360,
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
    			returnValue[0] = rowData['inv_category_code'];
      			returnValue[1] = rowData['inv_category_desc'];
      			returnValue[2] = rowData['inv_category_id'];
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
		var sUrl = "popUpInvCategoryList.do";
		jQuery("#invCategoryList").jqGrid('setGridParam',{mtype: 'POST', url:sUrl,page:1,postData: $("#listForm").serialize()}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#invCategoryList").getRowData(row_selected);  		
		var returnValue = new Array();
		
		returnValue[0] = ret.inv_category_code;
		returnValue[1] = ret.inv_category_desc;
		returnValue[2] = ret.inv_category_id;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});
</script>
</body>
</html>
