<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Catalog</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
	<% String p_bomCheck = request.getParameter("bomCheck") == null ? "" : request.getParameter("bomCheck").toString(); %>

<input type="hidden" id="txtCodeGbn"  		name="p_code_gbn" 	value="catalog" />
<input type="hidden" id="p_bomCheck"  		name="p_bomCheck" 	value="<%=p_bomCheck%>" />

<div>
Catalog <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 80px;"/>
Desc 	<input type="text" id="txtDescFind" name="p_desc_find"   style="width: 230px;"/>
</div>

<div style="margin-top: 10px;">
	<table id="catalogList" style="width:100%;height:50%"></table>
	<div   id="pcatalogList"></div>
</div>
<div style="margin-top: 10px;">
	<input type="button" id="btnfind"   value="찾기"/>
	<input type="button" id="btncheck"  value="확인"/>
	<input type="button" id="btncancle" value="취소"/>
</div>
</form>
<script type="text/javascript">
var row_selected;

var catalog_desc = window.dialogArguments["catalog_desc"];

$(document).ready(function(){
	
	$("input[name=p_desc_find]").val(catalog_desc);
		
	$("#catalogList").jqGrid({ 
             datatype	: 'json',
             mtype : 'POST',
             url		:'popUpCatalogCodeDescList.do',
             postData 	: getFormData("#listForm"),
             editUrl  	: 'clientArray',
        	 colNames :['Catalog_Code','Catalog_Desc'],
                colModel:[
                    {name:'catalog_code',index:'catalog_code', width:120, sortable:false, editoptions:{size:11}},
                    {name:'catalog_desc',index:'catalog_desc', width:155, sortable:false, editoptions:{size:5}}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
            // viewrecords: true,
             autowidth: true,
             height: 320,
             rowList:[100,500,1000],
			 rowNum:100,
             pager: jQuery('#pcatalogList'),
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
      			returnValue[0] = rowData['catalog_code'];
      			returnValue[1] = rowData['catalog_desc'];
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
		
		var sUrl = "popUpCatalogCodeDescList.do";
		jQuery("#catalogList").jqGrid('setGridParam',{mtype	: 'POST', url:sUrl,page:1,postData:getFormData("#listForm")}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#catalogList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0] = ret.catalog_code;
		returnValue[1] = ret.catalog_desc;
		
		window.returnValue = returnValue;
      			
		self.close();
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
