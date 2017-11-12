<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title></title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>

</head>
<body>
<div id="wrap">
	<form id="itemValueRule_form" name="itemValueRule_form" onSubmit="return false;">
	<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="itemValueRule"/>
	<div style="margin:20px 0 20px 5px">
		<span class="pop_tit">ITEM 채번규칙</span> <input type="text" id="item_value_rule" name="item_value_rule" style="width:250px; height:25px;" value="${item_value_rule}" readonly/>
	<div style="float:right;">
		<input type="button" id="btncheck"  value="확인" class="btn_blue"/>
		<input type="button" id="btnclear"  value="삭제" class="btn_blue"/>
		<input type="button" id="btncancle" value="취소" class="btn_blue"/>
		<input type="hidden" id="isPaging" name="isPaging" value="N" />
	</div>
	</div>
	<div style="height:380px; margin: 5px">
		<table id="itemValueRuleList"></table>
	</div>
	</form>
</div>

<script type="text/javascript">
var idRow 	  = 0;
var idCol 	  = 0;	
var kRow  	  = 0;
var kCol  	  = 0;

var index	  	   = 0;
var item_rule_desc = "";
var itemValue 	   = new Array();

$(document).ready(function(){
	
	// 파라키터 설정	
	item_rule_desc  = window.dialogArguments["item_rule_desc"];
	$("#item_value_rule").val(window.dialogArguments["item_value_rule"]);
	
	// 값이 존재할 경우 어레이로 변환한다	
	if (item_rule_desc.length > 0) {
		fn_getToArrary();
	}
	
	$("#itemValueRuleList").jqGrid({ 
             datatype : 'json', 
             mtype	  : 'POST', 
             url	  :'infoItemValueRule.do',
             postData : $("#itemValueRule_form").serialize(),
             editUrl  : 'clientArray',
        	//cellSubmit: 'clientArray',
             colNames:['Code','Data','Desc'],
                colModel:[
                    {name:'code', index:'code',  width:100, editable:false, sortable:false, editrules:{required:true}, align:"center"}, 
                    {name:'data', index:'data',  width:140, editable:false, sortable:false},
                    {name:'desc1',index:'desc1', width:150, editable:true,  sortable:false}
                ],
             gridview: true,
             cmTemplate: { title: false },
             toolbar: [false, "bottom"],
             viewrecords: true,
             autowidth: true,
             height: 375,
             rowNum :1000,
             //pager: jQuery('#pcodeMasterList'),
             pgbuttons: false,
			 pgtext: false,
			 pginput:false,
			 cellEdit: true,             // grid edit mode 1
	         cellsubmit: 'clientArray',  // grid edit mode 2
			 beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
             	idRow=rowid;
             	idCol=iCol;
             	kRow = iRow;
             	kCol = iCol;
   			 },
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
    			
    			var code = rowData['code'];
    			var	data = rowData['data'];
    			var desc = rowData['desc1'];
    			//var item_rule=$("#item_value_rule").val();
    			//var item_rule=$("input[name=item_value_rule]").val();
    			if(code=='A'){
    				if(desc=='' || desc==null){
    					alert("Key-in항목은 Desc에 입력이 필수입니다.");
						return;	
    				}
    				$("#item_value_rule").val($("#item_value_rule").val() + desc);	
    				itemValue[index++] = code+"/"+desc;
    			}else if(code == 'F'){
					if(desc=='' || desc==null){
    					alert("NonStandard항목은 Desc에 입력이 필수입니다.");
						return;	
    				}
    				$("#item_value_rule").val($("#item_value_rule").val() + desc);
    				itemValue[index++] = code+"/"+desc;
    			}else{
    				$("#item_value_rule").val($("#item_value_rule").val() + data);
    				itemValue[index++] = code;
    			}
    			
    			
    			
    		 },
			
    });
    
    $('#btncancle').click(function(){
		self.close();
	});

	$('#btnclear').click(function(){
		index     = 0;
		
		$("#item_value_rule").val("");
				
		if (itemValue.length  > 0) itemValue.splice(0, itemValue.length); //itemValue 초기화
		 
	});

	$('#btncheck').click(function(){
		var 	returnValue = new Array();
		var 	nRow		= 0;
		
		returnValue[nRow++] = $("#item_value_rule").val();
		returnValue[nRow++] = fn_getToString();
  		
  		window.returnValue = returnValue;
      	self.close();
	});
    
});

function fn_getToArrary() {	
	var arrDesc = item_rule_desc.split(",");				
	for(var i=0; i<arrDesc.length; i++) {
		itemValue[index++] = arrDesc[i];
	}
}

function fn_getToString()
{
	var sDesc = "";
	
	for(var i =0 ; i<itemValue.length; i++) {
		
		if ( i == 0 ) {
			sDesc += itemValue[i];
		} else {
			sDesc += "," + itemValue[i];
		}		
	}
	
	return sDesc;
}
			
</script>

</body>
</html>
