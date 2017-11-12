<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Ship Type</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
<input type="hidden" 	id="txtCodeGbn"  	name="p_code_gbn" 	 value="shipType" />
<input type="hidden" 	id="txtStatesMain"  name="states_main"   value="MASTER_DATA" />
<input type="hidden" 	id="txtStatesType" 	name="states_type"   value="Ship Type" />




<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		 <input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform: uppercase;"  class="w200h25 mgt10" onchange="javascript:this.value=this.value.toUpperCase();" />
	</div>
	<div class="button">
<!-- 		<input type="button" id="btncheck" value="확인" /> -->
		<input type="button" id="btnfind" value="조회" class="btn_blue" />
		<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
	</div>
</div>
			<div class="content">
				<table id="shipTypeList"></table>
<!-- 				<div   id="pcatalogList"></div> -->
			</div>

<!-- <div> -->
<!-- 찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 340px;"/> -->
<!-- 	<input type="button" id="btnfind"   value="찾기"/> -->
<!-- <!-- 	<input type="button" id="btncheck"  value="확인"/> --> -->
<!-- 	<input type="button" id="btncancle" value="닫기"/> -->
<!-- </div> -->
<!-- <div style="margin-top: 10px;"> -->
<!-- 	<table id="shipTypeList" style="width:100%;height:50%"></table> -->
<!-- </div> -->
</form>
<script type="text/javascript">

var row_selected;
var sUrl = "popUpShipTypeList.do";
		
$(document).ready(function(){

	$("#shipTypeList").jqGrid({ 
             datatype : 'local',
             url	  : sUrl,
             postData : getFormData('#listForm'),
             editUrl  : 'clientArray',
        	 colNames :['ShipType','ShipType_Desc'],
                colModel:[
                    {name:'code',index:'code', width:150, editoptions:{size:11}},
                    {name:'data',index:'data', width:125, editoptions:{size:5}}
                ],
             gridview	: true,
             toolbar	: [false, "bottom"],
             viewrecords: false,
             autowidth	: true,
             height		: 250,
             rowNum		: 999999,
             loadonce	: true,
              
             pgbuttons	: false,
			 pgtext		: false,
			 pginput	: false,
             jsonReader : {
                 root	: "rows",
                 page	: "page",
                 total	: "total",
                 records: "records",  
                 repeatitems: false,
                },        
             imgpath: 'themes/basic/images',
             ondblClickRow: function(rowId) {
    			var rowData = jQuery(this).getRowData(rowId); 
    			
    			var returnValue = new Array();
      			returnValue[0] = rowData['code'];
      			returnValue[1] = rowData['data'];
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
    
    fn_searchShipType();  
        
    $('#btncancle').click(function(){
		self.close();
	});

	$('#btnfind').click(function(){
		fn_searchShipType();
	});

	$('#btncheck').click(function(){
  		
  		var ret = $("#shipTypeList").getRowData(row_selected);  		
		var returnValue = new Array();
		returnValue[0] = ret.code;
		returnValue[1] = ret.data;
		
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});

function fn_searchShipType() {
	
	$("#shipTypeList").jqGrid('setGridParam',{mtype:'POST',url:sUrl,page:1,datatype:'json',postData:getFormData('#listForm')}).trigger("reloadGrid");
        
}


$("input[name=p_code_find]").keydown(function (e) {
   if (e.which == 13){
	  
		jQuery("#shipTypeList").jqGrid('setGridParam',{url:sUrl,datatype:'json',page:1,postData:getFormData('#listForm')}).trigger("reloadGrid");

		return false;
   }
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
