<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Mail Receiver</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "mainDiv">
<form id="application_form" name="application_form">

<input type="hidden" name="pageYn" id="pageYn" value="N" />


		<div class="topMain" style="margin: 0px;line-height: 45px;">
			<div class="conSearch">
				<input type="text" id="p_deptName" name="p_deptName" value="" style="text-transform: uppercase;" onchange="onlyUpperCase(this);" />
			</div>
			<div class="button">
				<input type="button" id="btnfind" value="조회" class="btn_blue" />
				<input type="button" id="btncheck" value="확인" class="btn_blue"/>
				<input type="button" id="btncancle" value="닫기"  class="btn_blue"/>
			</div>
		</div>
		<div class="content">
			<table id="deptList"></table>
			<div id="btn_deptList"></div>
		</div>
















<!-- <div style="float: left;"> -->
<!-- 	찾기  -->
<!-- 	<input type="text" id="p_deptName" name="p_deptName" value="" style="text-transform: uppercase;" onchange="onlyUpperCase(this);" />  -->
<!-- </div> -->
<!-- <div style="text-align: right;"> -->
<!-- 	<input type="button" id="btnfind" value="찾기"/> -->
<!-- 	<input type="button" id="btncheck" value="확인"/> -->
<!-- 	<input type="button" id="btncancle" value="취소"/> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="deptList" style="width:100%;height:50%"></table> -->
<!-- 	<div id="btn_deptList"></div> -->
<!-- </div> -->
	
</form>
</div>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){

	$("input[name=p_deptName]").val(window.dialogArguments["causedept"]);
	
	$("#deptList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'selectDwgDeptList.do',
             postData : getFormData('#application_form'),
             editUrl: 'clientArray',
             colNames:['부서코드','부서이름'],
                colModel:[
                    {name:'dept_code',index:'dept_code', width:10, align:'center', editable:false, sortable:false, editrules:{required:true},},
                    {name:'dept_name',index:'dept_name', width:30, editable:false, sortable:false, editrules:{required:true},},
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             autowidth: true,
             rowList:[100,500,1000],
             rownumbers:true,  
             rowNum: 100, 
             height: 325,
             pager: jQuery('#btn_deptList'),
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
    			var dept_code = rowData['dept_code'];
			    var dept_name = rowData['dept_name'];
    			
    			var returnValue = new Array();
      			returnValue[0] = dept_code;
     				returnValue[1] = dept_name;
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function (data) {
			 	var allRowsInGrid = $('#deptList').jqGrid('getRowData');
			 	var ids = jQuery("#deptList").jqGrid('getDataIDs');
  			    if(allRowsInGrid.length==1){
				    var rowId = ids[0];
				    var rowData = jQuery('#deptList').jqGrid ('getRowData', rowId);
				    var dept_code = rowData['dept_code'];
				    var dept_name = rowData['dept_name'];
	    			
	    			var returnValue = new Array();
	      			returnValue[0] = dept_code;
      				returnValue[1] = dept_name;
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
    
    
	
	
});
	$('#btncancle').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		
		var sUrl = "selectDwgDeptList.do";
		jQuery("#deptList").jqGrid('setGridParam',{url:sUrl,page:1,datatype: 'json',postData: getFormData('#application_form')}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		var ret = jQuery("#deptList").getRowData(row_selected);
  		if(ret.object==null){
  			alert('Please row select');
  		}
		var returnValue = new Array();
		var dept_code = ret.dept_code;
		var dept_name = ret.dept_name;
		returnValue[0] = dept_code;
		returnValue[1] = dept_name;
		window.returnValue = returnValue;
		self.close();			
		
	});
    function getFormData(form) {
	    var unindexed_array = $(form).serializeArray();
	    var indexed_array = {};
		
	    $.map(unindexed_array, function(n, i){
	        indexed_array[n['name']] = n['value'];
	    });
		
	    return indexed_array;
	};
	
	function onlyUpperCase(obj) {
		obj.value = obj.value.toUpperCase();	
	}
	
	$("#p_deptName").click(function(){
	});
</script>
</body>
</html>
