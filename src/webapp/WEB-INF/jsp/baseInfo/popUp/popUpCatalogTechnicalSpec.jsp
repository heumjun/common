<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Technical Spec</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div id = "wrap">
	<form id="application_form">
		<input type="hidden" 	id="p_code_gbn" 	  name="p_code_gbn" 	 value="sdTypeCode" />
		<input type="hidden" 	id="p_sd_type"  	  name="p_sd_type"  	 value="ITEM_TYPE"	/>
		<input type="hidden" 	id="p_code_find" 	  name="p_code_find" 	  value=""			/>
		
		<div class="content">
			<table id="technicalSpecList"></table>
		</div>
	</form>
</div>

<script type="text/javascript">
	
	//var selCatalog = opener.$("#catalogMain").getRowData(opener.catalog_row);	
	var p_catalog_code = window.dialogArguments["p_catalog_code"];
	var p_catalog_desc = window.dialogArguments["p_catalog_desc"];
	var p_category_id = window.dialogArguments["p_category_id"];
	var p_uom_code = window.dialogArguments["p_uom_code"];
	$(document)
			.ready(
					function() {

						$("#technicalSpecList").jqGrid(
								{
									datatype : 'json',
									mtype 	 : 'POST',
									url 	 : 'infoCategoryBase.do',
									postData : $("#application_form").serialize(),
									colNames : [ 'Sd Code',	'Sd Desc', 'Creation' ],
									colModel : [ {
										name  : 'sd_code',
										index : 'sd_code',
										width : 120,
										editable : false
									}, {
										name  : 'sd_desc',
										index : 'sd_desc',
										width : 220,
										editable : false
									}, {
										name  : 'oper',
										index : 'oper',
										width : 60,
										align : 'center',
										formatter: actionButtonFormatter
									} ],

									gridview  : true,
									cmTemplate: { title: false },
									toolbar   : [ false, "bottom" ],
									sortname  : 'sd_code',
									sortorder : "asc",
									viewrecords : true,
									altRows : false,
									height  : 410,
									rowNum:999999,
								
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


			});

	function actionButtonFormatter(cellvalue, options, rowObject) {	
            var rowid= options.rowId;
            var button = "<input style='align:center; ' class= 'btn_gray4' type='button' onclick=creation('"+rowid+"'); value='생성'</input>";
            return button;
    };
 
	//formatter로 생성한 버튼 클릭시 저장
	function creation(rowid){
		
		if (typeof p_catalog_code == 'undefined') {
			alert("Catalog를 선택해주십시오.");
			return;
		}	
		
		var ret = jQuery("#technicalSpecList").getRowData(rowid);
		
		var dataList = {
				catalog_code		: p_catalog_code,
				catalog_desc		: p_catalog_desc,
				category_code		: p_category_id,
				uom_code			: p_uom_code,
				sd_code				: ret.sd_code
			};

		var url = 'saveTechnicalSpec.do';
		
		$.post(url, dataList, function(data) {
			alert(data.resultMsg);

			if (data.result == "success")
				fn_search();
		}, 'json');
		
	}
	
</script>

</body>
</html>