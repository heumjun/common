<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" 						   %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" 						   %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	
</head>
<title>Text Filter</title>
<body>
<div id="wrap" class="mainDiv" style="display:block; float:none; width:1250px;">
	<div id="mainLeft" style="display:inline;">
		<fieldset style=" width: 500px; float: left;">
			<legend class="sc_tit sc_tit2 mgb5">공통 Item 속성 일괄반영</legend>
			<div style="width: 45%; float: left;  display: inline; ">
				<table id="catalogItemAttr"></table>
			</div>
			<div style="width: 5%;  display: inline; "> 
				<input style="margin-top: 280px; margin-left: 5px;" class="btn_gray2" type="button" id="btnApplySave" value=">>" /> 
			</div>
			<div style="width: 45%; float: right; display: inline; ">
				<table id="commonItemAttr"></table>
			</div>
		</fieldset>
		
	</div>
	<div id="mainRight" style="float: right; width: 700px; display:inline;">
		<fieldset style="width: 700px; float: left;">
			<legend class="sc_tit sc_tit2 mgb5">Catalog Item 속성 일괄반영</legend>
			<div>
				<fieldset style="margin-top: 5px; height:50px; padding-top:5px;">
					<legend >조회조건</legend>
					<div>
						<dl>
							<dd class="pop_tit" style="float:left; text-align:left; width: 30%; margin-left: 10px;">Catalog Item Description</dd>
							<dd style="float:left; text-align:left; width: 30%; margin-left: -60px;"><input type="text" name="p_attribute_name" class="mgl5" /></dd>
							<dd style="float:right; text-align:left; width: 5%; margin-right: 20px;"><input type="button" value="조회" id="btnSearch" class="btn_blue"/></dd>
						</dl>
					</div>
				</fieldset>
				<fieldset style="margin-top: 5px; height:50px; padding-top:5px;">
					<legend>일괄반영</legend>
					<div>
						<dl>
							<dd class="pop_tit"  style="float:left; text-align:left; width: 30%; margin-left: 10px; margin-right:5px;">Catalog Item Description</dd>
							<dd style="float:left; text-align:left; width: 30%; margin-left: -60px;"><input type="text" name="all_attribute_name" /></dd>
							<dd style="float:left; text-align:left; width: 5%; margin-left:190px; margin-right:15px;"><input type="button" value="저장" id="btnSave" class="btn_blue"/></dd>
							<dd style="float:left; text-align:left; width: 5%;"><input type="button" value="일괄적용" id="btnAllApply"class="btn_blue"/></dd>
						</dl>
					</div>
				</fieldset>
				<div style="margin-top: 10px;">
					<table id="changeCatalogItemAttr"></table>
					<div id="pchangeCatalogItemAttr"></div>
				</div>		
			</div>
		</fieldset>
		
		
	</div>
</div>

<script type="text/javascript">
	
	
	var change_catalog_row = 0;
	var change_catalog_row_num = 0;
	var change_catalog_col = 0;

	$(document)
			.ready(
					function() {

						$("#catalogItemAttr").jqGrid({
							datatype : 'json',
							mtype : 'POST',
							url : 'infoCatalogAttributeName.do',
							postData : {
								gbn : 1
							},
							colNames : [ 'Catalog Item속성' ],
							colModel : [ {
								name : 'attribute_name',
								index : 'attribute_name',
								width : 215
							}, ],

							gridview : true,
							cmTemplate: { title: false },
							toolbar : [ false, "bottom" ],
							sortname : 'attribute_name',
							sortorder : "asc",
							viewrecords : true,
							altRows : false,
							height : 628,
							rowNum:99999,
							pgbuttons : false,
							pgtext : false,
							pginput : false,
							
							jsonReader : {
								root : "rows",
								page : "page",
								total : "total",
								records : "records",
								repeatitems : false,
							},
							imgpath : 'themes/basic/images'

						});

						$("#commonItemAttr").jqGrid({
							datatype : 'json',
							mtype : 'POST',
							url : 'infoCommonAttributeName.do',
							postData : {
								gbn : 2
							},
							colNames : [ '공통코드 Item속성' ],
							colModel : [ {
								name : 'sd_code',
								index : 'sd_code',
								width : 215
							}, ],

							gridview : true,
							cmTemplate: { title: false },
							toolbar : [ false, "bottom" ],
							sortname : 'sd_code',
							sortorder : "asc",
							viewrecords : true,
							altRows : false,
							height : 628,
							rowNum:99999,	
							pgbuttons : false,
							pgtext : false,
							pginput : false,
							jsonReader : {
								root : "rows",
								page : "page",
								total : "total",
								records : "records",
								repeatitems : false,
							},
							imgpath : 'themes/basic/images'
						});

						$("#changeCatalogItemAttr").jqGrid(
								{
									datatype : 'json',
									mtype : 'POST',
									url : 'infoCatalogAttributeNameList.do',
									postData : {
										gbn : 3,
										p_attribute_name : $(
												"input[name=p_attribute_name]")
												.val()
									},
									colNames : [ 'Catalog',	'Catalog Description', '물성치',
											'기존값', '수정값', 'Row Id', 'attribute_data_type',
											'assy_attribute_code','attribute_data_min','attribute_data_max','Oper' ],
									colModel : [ {
										name : 'catalog_code',
										index : 'catalog_code',
										width : 150,
										editable : false
									}, {
										name : 'catalog_desc',
										index : 'catalog_desc',
										width : 200,
										editable : false
									}, {
										name : 'attribute_code',
										index : 'attribute_code',
										width : 80,
										editable : false
									}, {
										name : 'attribute_name',
										index : 'attribute_name',
										width : 120,
										editable : false
									}, {
										name : 'edit_attribute_name',
										index : 'edit_attribute_name',
										width : 120,
										editable : true
									}, {
										name : 'main_rowid',
										index : 'main_rowid',
										hidden : true
									}, {
										name : 'attribute_data_type',
										index : 'attribute_data_type',
										hidden : true
									}, {
										name : 'assy_attribute_code',
										index : 'assy_attribute_code',
										hidden : true
									}, {
										name : 'attribute_data_min',
										index : 'attribute_data_min',
										hidden : true
									}, {
										name : 'attribute_data_max',
										index : 'attribute_data_max',
										hidden : true
									}, {
										name : 'oper',
										index : 'oper',
										hidden : true
									} ],

									gridview : true,
									cmTemplate: { title: false },
									toolbar : [ false, "bottom" ],
									sortname : 'catalog_code',
									sortorder : "asc",
									viewrecords : true,
									//altRows : false,
									height : 470,
									rowList:[100,500,1000],
									
									rowNum:100,
									pager: jQuery('#pchangeCatalogItemAttr'),
									cellEdit : true,
									cellsubmit : 'clientArray',
									beforeSaveCell : changeCatalogItemEditEnd,
									beforeEditCell : function(row_id, colId,
											val, iRow, iCol) {
										if (row_id != null) {
											change_catalog_col = iCol;
											change_catalog_row_num = iRow;

											if (change_catalog_row != row_id) {
												change_catalog_row = row_id;
											}
										}
									},
									//pgbuttons : false,
									//pgtext : false,
									//pginput : false,
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

						$("#btnApplySave").click(function() {
							fn_applySave();
						});

						$("#btnSave").click(function() {
							fn_save();
						});

						$("#btnAllApply")
								.click(
										function() {

											fn_applyData(
													"#changeCatalogItemAttr",
													change_catalog_row_num,
													change_catalog_col);

											var ids = jQuery(
													"#changeCatalogItemAttr")
													.jqGrid('getDataIDs');

											for ( var i = 0; i < ids.length; i++) {
												var rowId = ids[i];
												var rowData = jQuery(
														'#changeCatalogItemAttr')
														.jqGrid('getRowData',
																rowId);

												if (rowData.oper != 'I')
													rowData.oper = 'U';

												rowData.edit_attribute_name = $(
														"input[name=all_attribute_name]")
														.val();

												// apply the data which was entered.
												$('#changeCatalogItemAttr')
														.jqGrid("setRowData",
																rowId, rowData);
											}

										});

					});

	function fn_search() {
		jQuery("#changeCatalogItemAttr").jqGrid('setGridParam', {
			url : "infoCatalogAttributeNameList.do",
			page : 1,
			postData : {
				gbn : 3,
				p_attribute_name : $("input[name=p_attribute_name]").val()
			}
		}).trigger("reloadGrid");
	}
	
	function fn_searchCatalogItemAttr() {
		jQuery("#catalogItemAttr").jqGrid('setGridParam', {
			url : "infoCatalogAttributeName.do",
			page : 1,
			postData : {
				gbn : 1
			}
		}).trigger("reloadGrid");
	}
	
	function fn_searchCommonItemAttr() {
		jQuery("#commonItemAttr").jqGrid('setGridParam', {
			url : "infoCommonAttributeName.do",
			page : 1,
			postData : {
				gbn : 2
			}
		}).trigger("reloadGrid");
	}
	
	function fn_applySave() {
		var url = 'saveCommonAttributeName.do';

		$.post(url, '', function(data) {
			alert(data.resultMsg);
			fn_searchCatalogItemAttr();
			fn_searchCommonItemAttr();
		}, 'json');
	}

	function changeCatalogItemEditEnd(irowId, cellName, value, irow, iCol) {
		var item = $('#changeCatalogItemAttr').jqGrid('getRowData', irowId);
		if (item.oper != 'I')
			item.oper = 'U';

		// apply the data which was entered.
		$('#changeCatalogItemAttr').jqGrid("setRowData", irowId, item);
		// turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function fn_applyData(gridId, nRow, nCol) {
		$(gridId).saveCell(nRow, nCol);
	}

	/* 
	 그리드 데이터 저장
	 */
	function fn_save() {
	
		
		fn_applyData("#changeCatalogItemAttr", change_catalog_row_num, change_catalog_col);
		
		var changeCatalogItemAttrResultRows = [];
		
		
		getChangedCatalogItemAttrResultData(function(data) {

			changeCatalogItemAttrResultRows = data;

			var dataList = {
				changeCatalogItemAttrList : JSON.stringify(changeCatalogItemAttrResultRows)
			};

			var url = 'saveChangeCatalogItemAttr.do';
			
			$.post(url, dataList, function(data) {
				alert(data.resultMsg);
				fn_searchCatalogItemAttr();
				fn_search();
			}, 'json');
		});
	}
	   
	function getChangedCatalogItemAttrResultData(callback) {
		var changedData = $.grep($("#changeCatalogItemAttr").jqGrid('getRowData'), function (obj) {
			return obj.oper == 'I' || obj.oper == 'U';
		});
		
		callback.apply(this, [changedData]);
	}
</script>

</body>
</html>