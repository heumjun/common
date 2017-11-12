<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grantor List</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head> 
<body>
<form id="application_form" name="application_form">
<input type="hidden" id="cmd" name="cmd" value="${cmd}"/>
<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="grantorList" />
<input type="hidden" id="dept" name="dept" value="${dept}" />

<div style="margin-top: 10px;">
	<table id="grantorList" style="width:100%;height:50%"></table>
	<div id="btn_grantorList"></div>
</div>
<div style="margin-top: 10px; margin-right:10px; float:right;">
	<input type="button" id="btncheck" value="확인" class="btn_blue"/> 
	<input type="button" id="btncancle" value="취소" class="btn_blue"/>
</div>
</form>
<script type="text/javascript">
var row_selected;

$(document).ready(function(){
	$("input[name=dept]").val(window.dialogArguments["dept"]);
	
	$("#grantorList").jqGrid({ 
             datatype: 'json', 
             mtype: 'POST', 
             url:'selectGrantorList.do',
             postData : $("#application_form").serialize(),
             editUrl: 'clientArray',
             colNames:['사번','이름'],
                colModel:[
                    {name:'emp_no',index:'emp_no', width:125, editable:false, sortable:false },
                    {name:'user_name',index:'user_name', width:125, editable:false, sortable:false },
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             rowNum: -1, 
             height: 320,
              
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
    			var emp_no 		= rowData['emp_no'];
    			var user_name	= rowData['user_name'];
    			var returnValue = new Array();
      			returnValue[0] = emp_no;
      			returnValue[1] = user_name;
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

	

	$('#btncheck').click(function(){
  		var ret = jQuery("#grantorList").getRowData(row_selected);
  		if(ret.emp_no==null){
  			alert('Please row select');
  		}
		var returnValue = new Array();
		returnValue[0] = ret.emp_no;
		returnValue[1] = ret.user_name;
		window.returnValue = returnValue;
      			
		self.close();
	});
    
});
</script>
</body>
</html>
