<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>ATTRIBUTE</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<form id="listForm" name="listForm">
	<input type="hidden" id="txtCodeGbn"  name="p_code_gbn" 	value="itmAttribute" />
	<input type="hidden" id="txtCatalog"  name="catalog_code"/>
	<input type="hidden" id="txtTypeCode" name="type_code" 	 />
	<input type="hidden" id="txtAttr00"   name="attr00" 	 />
	<input type="hidden" id="txtAttr01"   name="attr01" 	 />
	<input type="hidden" id="txtAttr02"   name="attr02" 	 />
	<input type="hidden" id="txtAttr03"   name="attr03" 	 />
	<input type="hidden" id="txtAttr04"   name="attr04" 	 />
	<input type="hidden" id="txtAttr05"   name="attr05" 	 />
	<input type="hidden" id="txtAttr06"   name="attr06" 	 />
	<input type="hidden" id="txtAttr07"   name="attr07" 	 />
	<input type="hidden" id="txtAttr08"   name="attr08" 	 />
	<input type="hidden" id="txtAttr09"   name="attr09" 	 />
	<input type="hidden" id="txtAttr10"   name="attr10" 	 />
	<input type="hidden" id="txtAttr11"   name="attr11" 	 />
	<input type="hidden" id="txtAttr12"   name="attr12" 	 />
	<input type="hidden" id="txtAttr13"   name="attr13" 	 />
	<input type="hidden" id="txtAttr14"   name="attr14" 	 />
	<input type="hidden" id="txtAttr15"   name="attr15" 	 />
	<input type="hidden" id="txtValueCd"  name="value_code"	 />
	
	
<div class="topMain" style="margin: 0px;line-height: 45px;">
	<div class="conSearch">
		<input type="text" id="txtCodeFind" name="p_code_find" value="${cmtype}" style="text-transform:uppercase;" class="w200h25 mgt10" onchange="javascript:this.value=this.value.toUpperCase();" />
	</div>
	<div class="button">
		<input type="button" id="btncheck" value="확인" class="btn_blue" />
		<input type="button" id="btnfind" value="조회" class="btn_blue" />
		<input type="button" id="btncancle" value="닫기" class="btn_blue" />
	</div>
</div>
<div class="content">
	<table id="attributeList"></table>
</div>

<!-- 	<div> -->
<!-- 	찾기 <input type="text" id="txtCodeFind" name="p_code_find"   style="width: 350px;"/> -->
<!-- 	</div> -->
	
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<table id="attributeList" style="width:100%;height:50%"></table> -->
<!-- 	</div> -->
	
<!-- 	<div style="margin-top: 10px;"> -->
<!-- 		<input type="button" id="btnfind"   value="찾기"/> -->
<!-- 		<input type="button" id="btncheck"  value="확인"/> -->
<!-- 		<input type="button" id="btncancle" value="취소"/> -->
<!-- 	</div> -->
</form>
<script type="text/javascript">
var row_selected;

var catalog_code = window.dialogArguments["catalog_code"];
var type_code  	 = window.dialogArguments["type_code"];

$(document).ready(function(){
	
	$("input[name=catalog_code]").val(catalog_code);
	$("input[name=type_code]").val(type_code);
	$("input[name=value_code]").val(window.dialogArguments["value_code"]);
	
	$("input[name=attr00]").val(window.dialogArguments["attr00_desc"]);
	$("input[name=attr01]").val(window.dialogArguments["attr01_desc"]);
	$("input[name=attr02]").val(window.dialogArguments["attr02_desc"]);
	$("input[name=attr03]").val(window.dialogArguments["attr03_desc"]);
	$("input[name=attr04]").val(window.dialogArguments["attr04_desc"]);
	
	$("input[name=attr05]").val(window.dialogArguments["attr05_desc"]);
	$("input[name=attr06]").val(window.dialogArguments["attr06_desc"]);
	$("input[name=attr07]").val(window.dialogArguments["attr07_desc"]);
	$("input[name=attr08]").val(window.dialogArguments["attr08_desc"]);
	$("input[name=attr09]").val(window.dialogArguments["attr09_desc"]);
	
	$("input[name=attr10]").val(window.dialogArguments["attr10_desc"]);
	$("input[name=attr11]").val(window.dialogArguments["attr11_desc"]);
	$("input[name=attr12]").val(window.dialogArguments["attr12_desc"]);
	$("input[name=attr13]").val(window.dialogArguments["attr13_desc"]);
	$("input[name=attr14]").val(window.dialogArguments["attr14_desc"]);
	$("input[name=attr15]").val(window.dialogArguments["attr15_desc"]);
	
	$("#attributeList").jqGrid({ 
             datatype : 'json',
             mtype : 'POST',
             url	  : 'popUpItemAttributeList.do',
             postData : $("#listForm").serialize(),
             editUrl  : 'clientArray',
        	 colNames :['Description','채번코드'],
                colModel:[
                    {name:'value_code',index:'value_code', width:155, sortable:false, editoptions:{size:11}},
                    {name:'item_make_value',index:'item_make_value', width:125,  sortable:false, editoptions:{size:5}}
                ],
             gridview: true,
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 380,
             rowNum: 999999,
           	 emptyrecords : '데이터가 존재하지 않습니다. ',
           	 
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
    			returnValue[0]  = rowData['item_make_value'];
      			returnValue[1]  = rowData['value_code'];
      			
      			window.returnValue = returnValue;
      			self.close();
			 },
			 loadComplete: function() {
             	var rowCnt = $("#attributeList").getGridParam("reccount");
             	
             	if (rowCnt == 0) {
             		self.close();	
             	} else if (rowCnt == 1) {
             		var ret = jQuery("#attributeList").getRowData(1);  		
		
					var returnValue = new Array();
					returnValue[0]  = ret.item_make_value;
					returnValue[1]  = ret.value_code;
				
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
		var sUrl = "popUpItemAttributeList.do";
		jQuery("#attributeList").jqGrid('setGridParam',{mtype:'POST',url:sUrl,page:1,postData: $("#listForm").serialize()}).trigger("reloadGrid");
	});

	$('#btncheck').click(function(){
  		
  		var ret = jQuery("#attributeList").getRowData(row_selected);  		
		
		var returnValue = new Array();
		returnValue[0]  = ret.item_make_value;
		returnValue[1]  = ret.value_code;
	
		window.returnValue = returnValue;
      			
		self.close();
	});
	
});
</script>
</body>
</html>
