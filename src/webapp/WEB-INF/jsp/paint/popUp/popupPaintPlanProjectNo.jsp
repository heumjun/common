<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Paint Plan ProjectNo</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
<input type="hidden" id="txtCodeGbn"  		name="p_code_gbn" 	value="paintPlanProjectNo" />

<div class="mgt10 mgl10">
<strong class="pop_tit">Project No</strong> <input type="text" id="txtProjectNo" name="project_no"  maxlength="10" class="w100h25" style="ime-mode:disabled; text-transform:uppercase;" onKeyUp="javascript:this.value=this.value.toUpperCase();"/>
&nbsp;&nbsp;
<strong class="pop_tit">Revision</strong> <input type="text" id="txtRevision"  name="revision"   maxlength="2"  class="w100h25" style="ime-mode:disabled; text-transform:uppercase;" />
</div>

<div style="margin-top: 10px;">
	<table id="projectList" style="width:100%;height:50%"></table>
	<div   id="pprojectList"></div>
</div>
<div style="margin-top: 10px; margin-right:10px; float:right;">
	<input type="button" id="btnfind"   value="찾기" class="btn_blue"/>
	<input type="button" id="btncheck"  value="확인" class="btn_blue"/>
	<input type="button" id="btncancel" value="취소" class="btn_blue"/>
</div>
</form>
<script type="text/javascript">
var row_selected;

var project_no = window.dialogArguments["project_no"];
var revision   = window.dialogArguments["revision"];
var viewType   = window.dialogArguments["viewType"];
$(document).ready(function(){
	
	$("input[name=project_no]").val(project_no);
	$("input[name=revision]").val(revision);
		
	$("#projectList").jqGrid({ 
             datatype	: 'json', 
             mtype		: 'POST', 
             url		: 'selectPaintPlanProjectNo.do',
             postData 	: getFormData("#listForm"),
             editUrl  	: 'clientArray',
        	 colNames :['Project No','Revision','State','SearchFlag'],
                colModel:[
                    {name:'project_no',index:'project_no', width:80, sortable:false},
                    {name:'revision',  index:'revision',   width:40, sortable:false, align:'right'},
                    {name:'state_desc',index:'state_desc', width:80, sortable:false},
                    {name:'search_flag',index:'search_flag', width:80, hidden:true}
                ],
             gridview: true,
             cmTemplate: { title: false },
             toolbar: [false, "bottom"],
            // viewrecords: true,
             autowidth: true,
             height: 320,
             rowList:[100,500,1000],
			 rowNum:100,
             pager: jQuery('#pprojectList'),
             jsonReader : {
                 root	: "rows",
                 page	: "page",
                 total	: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             loadComplete: function() {
             	var rowCnt = $("#projectList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		//self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#projectList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.project_no;
					returnValue[1]  = ret.revision;
					returnValue[2] = ret.search_flag;
					window.returnValue = returnValue;		
					self.close();
             	}	
			 },
			 gridComplete : function () {
				 
				 if(viewType == 'MFC_VIEW') {
					 var rows = $("#projectList").getDataIDs(); 
					    for (var i = 0; i < rows.length; i++) {
					    	
					    	var state_desc = $("#projectList").getCell(rows[i],"state_desc");
					    	var search_flag = $("#projectList").getCell(rows[i],"search_flag");
					    	if ( state_desc == "Preliminary" ) {
					    		if ( search_flag == "Y" ) {
					    			$( "#projectList" ).jqGrid("setCell", rows[i], "state_desc", '조회가능');
					    		} else {
					    			$( "#projectList" ).jqGrid("setCell", rows[i], "state_desc", '작업중');					    			
					    		}
					    		$( "#projectList" ).jqGrid('setRowData',rows[i],false, {  color:'black',weightfont:'bold',background:'#FDE9D9'});
					    	}
					    }	 
				 }
			 },
             ondblClickRow: function(rowId) {
    			var rowData = jQuery(this).getRowData(rowId); 
    			
    			var returnValue = new Array();
      			returnValue[0] = rowData['project_no'];
      			returnValue[1] = rowData['revision'];
      			returnValue[2] = rowData['search_flag'];
      			window.returnValue = returnValue;
      			self.close();
			 },
			 onSelectRow: function(row_id) {
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
		
		var sUrl = "selectPaintPlanProjectNo.do";
		jQuery("#projectList").jqGrid('setGridParam',{url:sUrl,page:1,postData:getFormData("#listForm")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		if (row_selected == null) {
  			alert("Not selected in the Project No");
  			return;
  		} else {
	  		var ret = jQuery("#projectList").getRowData(row_selected);  		
			
			var returnValue = new Array();
			returnValue[0] = ret.project_no;
			returnValue[1] = ret.revision;
			returnValue[2] = ret.search_flag;
			window.returnValue = returnValue;
	      			
			self.close();
		}
	});
	
});

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
