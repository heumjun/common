<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>상위 Catalog</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "wrap">
	<form id="application_form">
	<div class="topMain" style="line-height: 45px;margin: 0px;">
		<div class = "conSearch" >
				<span class = "spanMargin"><span class="pop_tit"> Catalog</span> <input type="text" class = "textBox" name="p_catalog_code" style="text-transform:uppercase;"> </span>
		</div>
		<div class = "button">
				<input type="button" class="btnAct btn_blue" id="btnSave" name="" value="저장" />
				<input type="button" class="btnAct btn_blue" id="btnSearch" name="" value="조회" />
				<input type="button" class="btnAct btn_blue" id="btnClose" name="" value="닫기"/>
		</div>
	</div>
	<div class="content">
		<table id="highRankCatalogList"></table>
	</div>
	</form>
</div>

<script type="text/javascript">
	
//var ret = opener.$("#catalogMain").getRowData(opener.catalog_row);	
var selCatalog = window.dialogArguments["p_catalog_code"];		
$(document).ready(function() {
	fn_all_text_upper();
	
	$("#highRankCatalogList").jqGrid({
			datatype : 'json',
			mtype 	 : 'POST',
			url 	 : 'infoHighRankCatalogList.do',
			postData : {
				p_catalog_code:$("input[name=p_catalog_code]").val(),
				catalog_code  :typeof selCatalog == 'undefined' ? '' :selCatalog
			},
			colNames : ['<input type="checkbox" id="headCheckbox" onclick="checkBox(event)" /> ','Catalog',	'Catalog Description', 'Enable Falg','Oper' ],
			colModel : [
			  { name  : 'enable_flag',
			    index : 'enable_flag', 
			    classes : 'chkboxItem', 
			    width : 25, 
			    editable : true, 
			    edittype : 'checkbox', 
			    formatter: "checkbox", 
			    editoptions: {value:"Y:N" },
			   
			    formatoptions:{disabled:false}
			}, {
				name  : 'assy_catalog_code',
				index : 'assy_catalog_code',
				width : 150,
				editable : false
			}, {
				name  : 'catalog_desc',
				index : 'catalog_desc',
				width : 240,
				editable : false
			}, {
				name   : 'enable_flag_changed',
				index  : 'enable_flag_changed',
				hidden : true
			},
			{	name   : 'oper',
				index  : 'oper',
				hidden : true},
			 ],
	
			gridview  : true,
			cmTemplate: { title: false },
			toolbar   : [ false, "bottom" ],
			sortname  : 'assy_catalog_code',
			sortorder : "asc",
			viewrecords : true,
			altRows : false,
			height  : 390,
			rowNum:999999,
			//multiselect: true,
			pgbuttons : false,
			pgtext 	  : false,
			pginput   : false,
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images'
		});

		// ------버튼 이벤트---------------------------------------------------------------------------------------------------------------

		$("#btnSearch").click(function() {
			fn_search();
		});

		$("#btnSave").click(function() {
			fn_save();
		});
		
		$("#btnClose").click(function() {
			self.close();
		});

});

function fn_search() {
	jQuery("#highRankCatalogList").jqGrid('setGridParam', {
		url  	 : "infoHighRankCatalogList.do",
		page 	 : 1,
		postData : {
			p_catalog_code:$("input[name=p_catalog_code]").val(),
			catalog_code  :typeof selCatalog == 'undefined' ? '' :selCatalog
		}
	}).trigger("reloadGrid");
}
	
/* 
 그리드 데이터 저장
 */
function fn_save() {
	
	if (typeof selCatalog == 'undefined') {
		alert("Catalog를 선택해주십시오.");
		return;
	}	
			
	var selectedCatalogResultRows = [];
	
	var ids = jQuery("#highRankCatalogList").jqGrid('getDataIDs'); 
	
	for(var i=0; i<ids.length; i++){ 
	   		var rowData = $('#highRankCatalogList').jqGrid('getRowData',ids[i]); 
		if(rowData.enable_flag_changed != rowData.enable_flag){	
			rowData.oper = "U";
			
	   			$('#highRankCatalogList').jqGrid("setRowData", ids[i], rowData);	
	   		}	
 	}
	
	getSelectedCatalogResultData(function(data) {

		selectedCatalogResultRows = data;

		var dataList = {
			selectedCatalogList : JSON.stringify(selectedCatalogResultRows),
			catalog_code		: selCatalog
		};

		var url = 'saveHighRankCatalog.do';
		
		$.post(url, dataList, function(data) {
			alert(data.resultMsg);

			if (data.result == "success")
				fn_search();
		}, 'json');
	});
}
	   
function getSelectedCatalogResultData(callback) {
	var changedData = $.grep($("#highRankCatalogList").jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U';
	});
	
	callback.apply(this, [changedData]);
}
	
function checkBox(e) { 

	e = e||event;/* get IE event ( not passed ) */ 
   	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true; 
 	//$(".chkboxItem").prop("checked", true);
   	
   	var ids = jQuery("#highRankCatalogList").jqGrid('getDataIDs'); 
       var enableFlag = 'N';      
 	   
  	if(($("#headCheckbox").is(":checked"))){
  		enableFlag = "Y";	
  	}
  
  	for(var i=0;i < ids.length;i++){ 
	   		var rowData = $('#highRankCatalogList').jqGrid('getRowData',ids[i]); 
	   		rowData.enable_flag = enableFlag;
	   
	   		$('#highRankCatalogList').jqGrid("setRowData", ids[i], rowData);		
 	} 
} 
	
</script>

</body>
</html>