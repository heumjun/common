<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>category Mgnt</title>
	</head>
	<body>

		<div id="mainDiv" class="mainDiv">
			<form name="listForm" id="listForm" method="get">
				<input type="hidden" name="mode" id="mode" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<input type="hidden" id="column_name" name="column_name" value=""/>
				<input type="hidden" id="item_order" name="item_order" value=""/>
				<div class="subtitle">
					CatalogMgnt
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				
					<table class="searchArea conSearch">
					<col width="100">
					<col width="150">
					<col width="100">
					<col width="150">
					<col width="100">
					<col width="150">
					<col width="100">
					<col width="150">
					<col width="*" style="min-width:280px">

					<tr>
					<th>CATALOG</th>
					<td>
						<input type="text" name="p_catalog_code" style="width: 80px; ime-mode: disabled; text-transform: uppercase;" onchange="onlyUpperCase(this);" />
						<input type="button" class="btn_gray2" id="btnCatalog" value="검색" />
					</td>

					<th>CATALOG DESC</th>
					<td>
						<input type="text" name="p_catalog_desc" class="toUpper" style="width: 90px;" />
					</td>

					<th>CATEGORY</th>
					<td>
						<input type="text" name="p_category_code" class="toUpper" style="width: 90px;" />
					</td>
					
					<th>CATEGORY DESC</th>
					<td style="border-right:none;">
						<input type="text" name="p_category_desc" class="toUpper" style="width: 90px;" />
					</td>
					
					<td style="border-left:none; padding:10px 0 10px 0;">
						<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnSearch" name="btnSearch" value="조회"  class="btn_blue"/>
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" id="btnSave" name="btnSave" value="저장"  class="btn_blue"/>
						</c:if>
						<c:if test="${userRole.attribute5 == 'Y'}">
						<input type="button" id="btnExcelDownLoad" name="btnExcelDownLoad" value="Excel　▽" class="btn_blue"/>
						</c:if>
						<c:if test="${userRole.attribute6 == 'Y'}">
						<input type="button" id="btnExcelUpLoad" name="btnExcelUpLoad" value="Excel　△"  class="btn_blue"/>
						</c:if>
						</div>
						</td>
						</tr>
						</table>
					<table class="searchArea2" >
					<tr>
					<td><div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnAddItemAttr" name="btnAddItemAttr" value="부가속성" class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnCatalogHis" name="btnCatalogHis" value="Catalog　His"  class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnItemBomHis" name="btnItemBomHis" value="Item/Bom　His" class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" id="btnTextFilter" name="btnTextFilter" value="Text　Filter"  class="btn_blue"/><br/>
						</c:if>
						</div>
					</td>
					</tr>
				</table>
				

					
					<div id="upperDiv"  class="content" style="position:relative; float: left; width: 100%;">
						<div style="float:left; width: 54%;" id="catalogMainFS" >
							<fieldset style="border:none">
								<legend class="sc_tit sc_tit2">CATALOG</legend>
								<table id="catalogMain"></table>
								<div id="pcatalogMain"></div>
							</fieldset>
						</div>
						
						<div style="float:right; width: 15%;" id="productionInfoFS" >
							<fieldset style="border:none">
								<legend class="sc_tit sc_tit2">생산정보</legend>
								<table id="productionInfo"></table>
								<div id="pproductionInfo"></div>
								<legend class="sc_tit sc_tit2">LENGTH</legend>
								<table id="catalogLengthInfo"></table>
								<div id="pcatalogLengthInfo"></div>
							</fieldset>
						</div>
						
						<div style="float:right; width: 15%;" id="purchaseInfoFS" >
							<fieldset style="border:none">
								<legend class="sc_tit sc_tit2">구매정보</legend>
								<table id="purchaseInfo"></table>
								<div id="ppurchaseInfo"></div>
								<div>
									<dl>
										<dd style="float: left; text-align: right; height: 20px; line-height: 20px; width: 40%; margin: 0px; vertical-align: middle;">
											<span style="margin-right: 6px;" class="pop_tit">계획</span>
										</dd>
										<dd style="float: left; text-align: left; height: 20px; width: 60%; margin: 0 0 3px 0;">
											<input type="text" style="width: 95%;" id="txtPlan" readonly />
										</dd>
									</dl>
									<dl>
										<dd style="float: left; text-align: right; height: 20px; line-height: 20px; width: 40%; margin: 0px; vertical-align: middle;">
											<span style="margin-right: 6px;" class="pop_tit">표준 L/T</span>
										</dd>
										<dd style="float: left; text-align: left; height: 20px; width: 60%; margin: 0 0 3px 0;">
											<input type="text" style="width: 95%;" id="txtStandard" readonly />
										</dd>
									</dl>
									<dl>
										<dd style="float: left; text-align: right; height: 20px; line-height: 20px; width: 40%; margin: 0px; vertical-align: middle;">
											<span style="margin-right: 6px;" class="pop_tit">구매담당자</span>
										</dd>
										<dd style="float: left; text-align: left; height: 20px; width: 60%; margin: 0 0 3px 0;">
											<input type="text" style="width: 95%;" id="txtBuyer" readonly />
										</dd>
									</dl>
								</div>
							</fieldset>
						</div>
						
						<div style="float:right; width: 15%;" id="designInfoFS" >
							<fieldset style="border:none">
								<legend class="sc_tit sc_tit2">설계정보</legend>
								<table id="designInfo"></table>
								<div id="pdesignInfo"></div>
								<div>
									<dl class="mgt10">
										<dd style="float: left; text-align: center; height: 20px; width: 45%; margin: 0px 0px 10px 0px;">
											<input type="button" id="btnHighLinkCatalog" value="상위 Catalog" class="btn_gray2"/>
										</dd>
										<dd style="float: left; text-align: center; height: 20px; width: 55%; margin: 0px 0px 10px 0px;">
											<input type="button" id="btnTechnicalSpec" value="비용성 코드 생성"  class="btn_gray2"/>
										</dd>
									</dl>
									<dl>
										<dd style="float: left; text-align: right; height: 20px; width: 40%; margin: 0px 5px 10px 0px;">
											<span class="pop_tit"><strong>Value Code</strong></span>
										</dd>
										<dd style="float: left; height: 20px; width: 30%; margin: 0px 0px 10px 0px;">
											<input type="text" style="width:60px; border:1px solid #d0d9e1;" name="p_value_code" />
										</dd>
										<dd style="float: left; text-align: right; height: 20px; width: 20%; margin: 0px 0px 10px 0px;">
											<input type="button" value="조회" id="btnAttrValSearch"   class="btn_gray2"/>
										</dd>
									</dl>
								</div>
							</fieldset>
						</div>
						
						
					</div>
					
					
					<div id="underDiv" style="position:relative; float: left; width: 100%;">
						<fieldset style="border:none;position:relative; float:left; width: 54%;">
							<legend class="sc_tit sc_tit2">ITEM 속성</legend>
							<div id="itemAttrBaseDiv" style="position: relative; float: left; width: 55%;">
								<table id="itemAttributeBase"></table>
								<div id="pitemAttributeBase"></div>
							</div>
							<div id="itemValueDiv" style="position: relative; float: left; width: 23%;">
								<table id="itemValue"></table>
								<div id="pitemValue"></div>
							</div>
							<div id="topItemValueDiv" style="position: relative; float: left; width: 22%;">
								<table id="topItemValue"></table>
								<div id="ptopItemValue"></div>
							</div>
						</fieldset>
						<fieldset style="border:none;margin-left:5px;position:relative; float:right; width: 45%;">
							<legend class="sc_tit sc_tit2">BOM 속성</legend>
							<div id="bomAttrBaseDiv" style="position: relative; float: left; width: 55%;">
							<table id="bomAttributeBase"></table>
							<div id="pbomAttributeBase"></div>
							</div>
							<div id="bomValueDiv" style="position: relative; float: left; width: 23%;">
							<table id="bomValue"></table>
							<div id="pbomValue"></div>
							</div>
							<div id="topBomValueDiv" style="position: relative; float: left; width: 22%;">
							<table id="topBomValue"></table>
							<div id="ptopBomValue"></div>
							</div>
						</fieldset>
					</div>
					
					
			</form>
		</div>
		<script type="text/javascript">
		
		//페이지 분기 파라미터
		var pageParameters = null;

		var tableId = '';

		var serviceProcessData = [];

		//작업처리자 데이터
		var chargeData = [];
		var service_catalog_mainList = [], service_catalog_subList = [], chm_charge_user_idList = [];

		//삭제 데이터
		var catalogDeleteData = [];
		var designDeleteData = [];
		var purchaseDeleteData = [];
		var productionDeleteData = [];
		var catalogLengthDeleteData = [];

		var itemAttributeDeleteData = [];
		var itemValueDeleteData = [];
		var topItemValueDeleteData = [];

		var bomAttributeDeleteData = [];
		var bomValueDeleteData = [];
		var topBomValueDeleteData = [];

		//처리실적 데이터
		var testData = [];

		var catalog_row = 0; //catalog 선택한 row_id
		var catalog_row_num = 0; //catalog 선택한 row
		var catalog_col = 0; //catalog 선택한 col

		var designInfo_row = 0; //설계 선택한 row_id
		var designInfo_row_num = 0; //설계 선택한 row
		var designInfo_col = 0; //설계 선택한 col

		var purchaseInfo_row = 0; //구매 선택한 row_id
		var purchaseInfo_row_num = 0; //구매 선택한 row
		var purchaseInfo_col = 0; //구맨 선택한 col

		var productionInfo_row = 0; //생산 선택한 row_id
		var productionInfo_row_num = 0; //생산 선택한 row
		var productionInfo_col = 0; //생산 선택한 col
		
		var catalogLengthInfo_row = 0; //Length 선택한 row_id
		var catalogLengthInfo_row_num = 0; //Length 선택한 row
		var catalogLengthInfo_col = 0; //Length 선택한 col

		var item_attr_row = 0; //item속성 선택한 row_id
		var item_attr_row_num = 0; //item속성 선택한 row			
		var item_attr_col = 0; //item속성 선택한 col

		var item_value_row = 0; //itmeValue 선택한 row_id
		var item_value_row_num = 0;
		var item_value_col = 0;

		var topitem_value_row = 0;
		var topitem_value_row_num = 0;
		var topitem_value_col = 0;

		var bom_attr_row = 0; //bom속성 선택한 row_id
		var bom_attr_row_num = 0;
		var bom_attr_col = 0;

		var bom_value_row = 0; //bomValue 선택한 row_id
		var bom_value_row_num = 0;
		var bom_value_col = 0;

		var topbom_value_row = 0;
		var topbom_value_row_num = 0;
		var topbom_value_col = 0;

		var fv_catalog_code = "";

		var fv_attribute_code = "";
		var fv_value_code = "";
		var fv_item_make_value = "";

		var fv_bom_attr_code = "";
		var fv_bom_val_code = "";
		var fv_bom_make_code = "";

		var fv_sd_type = "";

		var changedRows = [];
		var nRow = 0;
		var searchIndex = 0;
		var win = null;
		var isPopup = false;

		var lodingBox;

		$(document).ready( function() {
			fn_all_text_upper();
			
			var myCustomCheck = function(value, colname) { return [ true ]; };

			//CATALOG MAIN 그리드
			$( "#catalogMain" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				//editUrl: 'clientArray',
				//cellSubmit: 'clientArray',
				colNames : [ 'Catalog', 'Desc', 'Length', 'Category', 'Desc', 'Uom', 'PartFamily', 'Desc', '무효일자', 'WBS', 'WBS하위', 'ACT', 'PAINT JOB', 'PD', 'PAINT', 'PAINT USC', '사용유무', 'Act_1', 'Job_1', 'Wbs_1', 'Wbs_sub_1', 'PD_1', 'PAINT_1', 'PAINT_USC_1', '사용유무_1', 'Link_catalog', 'Oper', 'Category id' ],
				colModel : [ { name : 'catalog_code', index : 'catalog_code', width : 52, editable : true, sortable : false, editrules : { custom : true, custom_func : myCustomCheck }, editoptions : { size : 5, dataInit : function( el) { $(el) .css( 'text-transform', 'uppercase'); }, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#catalogMain'; isPopup = true; /* searchCatalogCode( this, 0, 1, catalog_row_num, catalog_col); */ } } } ] } },				              
				             { name : 'catalog_desc', index : 'catalog_desc', width : 95, editable : true, sortable : false, editoptions : { size : 11 } },
				             { name : 'catalog_length', index : 'catalog_length', width : 50, classes : 'disables', sortable : false, align : "center" },
				             { name : 'category_code', index : 'category_code', width : 60, editable : false, classes : 'disables', sortable : false, editoptions : { size : 5 } }, 
				             { name : 'category_desc', index : 'category_desc', width : 90, editable : false, classes : 'disables', sortable : false, editoptions : { size : 10 } },				             
				             { name : 'uom_code', index : 'uom_code', width : 40, editable : false, align : "center", sortable : false, editoptions : { size : 5, dataInit : function( el) { $(el) .css( 'text-transform', 'uppercase'); }, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#catalogMain'; searchUomCode( this, 5, -1, catalog_row_num, catalog_col); } } } ] } }, 
				             { name : 'part_family_code', index : 'part_family_code', width : 70, editable : false, sortable : false, align : "center", editoptions : { size : 5, dataInit : function( el) { $(el) .css( 'text-transform', 'uppercase'); }, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#catalogMain'; isPopup = true; searchPartFamilyCode( this, 6, 7, catalog_row_num, catalog_col); } } } ] } }, 
				             { name : 'part_family_desc', index : 'part_family_desc', width : 80, classes : 'disables', sortable : false }, 
				             { name : 'invalid_date', index : 'invalid_date', width : 70, classes : 'disables', sortable : false }, 
				             { name : 'wbs_flag', index : 'wbs_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center", hidden : true  }, 
				             { name : 'wbs_sub_flag', index : 'wbs_sub_flag', width : 60, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" , hidden : true },
				             { name : 'activity_flag', index : 'activity_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" , hidden : true }, 
				             { name : 'job_flag', index : 'job_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'pd_flag', index : 'pd_flag', width : 20, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" , hidden : true }, 
				             { name : 'paint_flag', index : 'paint_flag', width : 40, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
				             { name : 'paint_usc_flag', index : 'paint_usc_flag', width : 70, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
				             { name : 'enable_flag', index : 'enable_flag', width : 50, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'activity_flag_changed', index : 'activity_flag_changed', hidden : true }, 
				             { name : 'job_flag_changed', index : 'job_flag_changed', hidden : true }, 
				             { name : 'wbs_flag_changed', index : 'wbs_flag_changed', hidden : true }, 
				             { name : 'wbs_sub_flag_changed', index : 'wbs_sub_flag_changed', hidden : true },
				             { name : 'pd_flag_changed', index : 'pd_flag_changed', hidden : true },
				             { name : 'paint_flag_changed', index : 'paint_flag_changed', hidden : true },
				             { name : 'paint_usc_flag_changed', index : 'paint_usc_flag_changed', hidden : true },
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', hidden : true }, 
				             { name : 'sel_catalog_code', index : 'sel_catalog_code', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true }, 
				             { name : 'category_id', index : 'category_id', hidden : true }, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				//sortname: 'catalog_code', 
				//sortorder: "asc", 
				//shrinkToFit : false,
				autowidth : true,
// 				width : 595,
				viewrecords : true,
				height : $(window).height()/2-180,
				pager : $('#pcatalogMain'),
				//pgbuttons: false,
				//pgtext: false,
				//pginput:false,
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeEditCell : function( row_id, colId, val, iRow, iCol) {
					if( row_id != null ) {
						var ret = $( "#catalogMain" ).getRowData( row_id );
						catalog_col = iCol;
						catalog_row_num = iRow;

						fv_catalog_code = ret.catalog_code;
						if( catalog_row != row_id ) {
							catalog_row = row_id;
							fn_detailSearch();
						}
					}
				},
				beforeSaveCell : catalogEditEnd,
				//afterInsertRow : catalogEditEnd,
				afterSaveCell : function( rowid, name, val, iRow, iCol ) {
					if( name == "catalog_code" || name == "part_family_code" || name == "uom_code") {
						setUpperCase( "#catalogMain", rowid, name );
					}

					var item = $( "#catalogMain" ).jqGrid( 'getRowData', rowid );

					if( isPopup == false && ( name == "catalog_code" || name == "part_family_code" ) ) {
						fn_searchCategory( item.catalog_code, item.part_family_code, rowid );
					}
				},
				loadComplete : function() {
					var rows = $( "#catalogMain" ).getDataIDs();
					if(rows.length != 0){
						var ret = $( "#catalogMain" ).getRowData( 1 );
						catalog_row = 1;
						fv_catalog_code = ret.catalog_code;
						$( "#catalogMain" ).jqGrid( 'editCell', 1, 0, false );
						fn_detailSearch();	
					}
				},
				gridComplete : function() {
					
					
					var rows = $( "#catalogMain" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#catalogMain" ).getCell( rows[i], "oper" );
						if( oper != "D" ) {
							if( oper != "I" ) {
								$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'catalog_code', '', { background : '#DADADA' } );
								//$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'catalog_code', '', { cursor : 'pointer', background : 'pink' } );	
							}
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'uom_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'part_family_code', '', { cursor : 'pointer', background : 'pink' } );
							//미입력 영역 회색 표시
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'catalog_length', '', { background : '#DADADA' } );
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'category_code', '', { background : '#DADADA' } );
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'category_desc', '', { background : '#DADADA' } );
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'part_family_desc', '', { background : '#DADADA' } );
							$( "#catalogMain" ).jqGrid( 'setCell', rows[i], 'invalid_date', '', { background : '#DADADA' } );
						}
					}
					
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onCellSelect : function( row_id, colId ) {
					var cm = $("#catalogMain").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#catalogMain').jqGrid( 'getRowData', row_id );
					/* if ( colName['index'] == "catalog_code" ) {
						if(item.oper == "I" ){
							searchCatalogCode( item, 0, 1, row_id, colId);		
						}												
					} */
					if ( colName['index'] == "uom_code" ) {
						searchUomCode( item, 5, -1, row_id, colId)		
					}
					if ( colName['index'] == "part_family_code" ) {
						searchPartFamilyCode( item, 6, 7, row_id, colId)		
					}
					
					
					
					if( row_id != null ) {

						var ret = $( "#catalogMain" ).getRowData( row_id );

						fv_catalog_code = ret.catalog_code;

						if( colId == 0 && ret.oper != "I" )
							$( "#catalogMain" ).jqGrid( 'setCell', row_id, 'catalog_code', '', 'not-editable-cell' );

						if( catalog_row != row_id ) {
							catalog_row = row_id;
							fn_detailSearch();
						}
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );
			
			

			$( "#catalogMain" ).jqGrid( 'navGrid', "#pcatalogMain", {
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#catalogMain" ).navButtonAdd( '#pcatalogMain', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteCatalogRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#catalogMain" ).navButtonAdd( '#pcatalogMain', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addCatalogRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//설계정보 그리드
			$( "#designInfo" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				editurl : '',
				colNames : [ '항목', '구분DESC', '항목값', '사용유무', '사용유무1', 'oper' ],
				colModel : [ { name : 'd_code', index : 'd_code', width : 30, editable : false, sortable : false, editrules : { required : true }, editoptions : { size : 2, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#designInfo'; fv_sd_type = "CATALOG_DESIGN"; searchItem( this, 0, 1, designInfo_row_num, designInfo_col); } } } ] } }, 
				             { name : 'd_desc', index : 'd_desc', width : 90, editable : false, sortable : false }, 
				             { name : 'd_value', index : 'd_value', width : 40, editable : true, sortable : false, editrules : { required : true }, editoptions : { size : 4 } }, 
				             { name : 'd_flag', index : 'd_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'd_flag_changed', index : 'd_flag_changed', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				autowidth : true,
				//sortname: 'catalog_code', 
				//sortorder: "asc", 
				viewrecords : true,
				//altRows: false, 
				height : $(window).height()/2-250,
				rowNum : 999999,
				pager : '#pdesignInfo',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : designInfoEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						designInfo_col = iCol;
						designInfo_row_num = iRow;

						//fv_catalog_code = ret.catalog_code;
						if( designInfo_row != row_id ) {
							designInfo_row = row_id;
							//	fn_detailSearch(); 
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#designInfo" ).getDataIDs();
					var addItemFlag = false;
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#designInfo" ).getCell( rows[i], "oper" );
						var d_code = $( "#designInfo" ).getCell( rows[i], "d_code" );
						var d_value = $( "#designInfo" ).getCell( rows[i], "d_value" );
						var d_flag = $( "#designInfo" ).getCell( rows[i], "d_flag" );
						
						if(d_code == '11' && d_value == 'Y' && d_flag == 'Y') {
							addItemFlag = true;
						}
						if( oper == "I" ) {
							
							$( "#designInfo" ).jqGrid( 'setCell', rows[i], 'd_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#designInfo" ).jqGrid( 'setCell', rows[i], 'd_desc','', {background : '#DADADA' } );
						} else  if(oper == '') {
							$( "#designInfo" ).jqGrid( 'setCell', rows[i], 'd_code','', {background : '#DADADA' } );
							$( "#designInfo" ).jqGrid( 'setCell', rows[i], 'd_desc','', {background : '#DADADA' } );
						}
					}
					if(addItemFlag) {
						fn_buttonEnable([ "#btnAddItemAttr"]);
					} else {
						fn_buttonDisabled([ "#btnAddItemAttr"]);	
					}
					
				},
				onCellSelect : function( row_id, colId ) {
					var cm = $("#designInfo").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#designInfo').jqGrid( 'getRowData', row_id );
					if ( colName['index'] == "d_code" ) {
						if(item.oper == "I" ){
							searchItem( "#designInfo", "CATALOG_DESIGN", 0, 1, row_id, colId);	
						}
					}
					
					
					
					if( row_id != null ) {
						var ret = $( "#designInfo" ).getRowData( row_id );

						if( colId == 0 && ret.oper != "I" )
							$( "#designInfo" ).jqGrid( 'setCell', row_id, 'd_code', '', 'not-editable-cell' );

						if( designInfo_row != row_id ) {
							designInfo_row = row_id;
						}
					}
					
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        },
				
				imgpath : 'themes/basic/images'
			} );
			

			$( "#designInfo" ).jqGrid( 'navGrid', "#pdesignInfo", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#designInfo" ).navButtonAdd( '#pdesignInfo', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteDesignInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#designInfo" ).navButtonAdd( '#pdesignInfo', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addDesignInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>	

			//구매정보 그리드 
			$( "#purchaseInfo" ).jqGrid( {
				datatype : 'json',
				mtype : '',
// 				height : 'auto',
				url : '',
				editurl : '',
				colNames : [ '항목', '구분DESC', '항목값', '사용유무', '사용유무1', 'oper' ],
				colModel : [ { name : 'p_code', index : 'p_code', width : 30, editable : false, sortable : false, editrules : { required : true }, editoptions : { size : 2, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#purchaseInfo'; fv_sd_type = "CATALOG_PO"; searchItem( this, 0, 1, purchaseInfo_row_num, purchaseInfo_col); } } } ] } }, 
				             { name : 'p_desc', index : 'p_desc', width : 85, editable : false, sortable : false }, 
				             { name : 'p_value', index : 'p_value', width : 40, editable : true, sortable : false, editrules : { required : true }, editoptions : { size : 4 } }, 
				             { name : 'p_flag', index : 'p_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'p_flag_changed', index : 'p_flag_changed', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				autowidth : true,
				//sortname: 'catalog_code', 
				//sortorder: "asc", 
				viewrecords : true,
				height : $(window).height()/2-250,
				rowNum : 999999,
				pager : '#ppurchaseInfo',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : purchaseInfoEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						purchaseInfo_col = iCol;
						purchaseInfo_row_num = iRow;

						//fv_catalog_code = ret.catalog_code;
						if( purchaseInfo_row != row_id ) {
							purchaseInfo_row = row_id;
							//	fn_detailSearch(); 
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#purchaseInfo" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#purchaseInfo" ).getCell( rows[i], "oper" );
						if( oper == "I" ) {
							$( "#purchaseInfo" ).jqGrid( 'setCell', rows[i], 'p_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#purchaseInfo" ).jqGrid( 'setCell', rows[i], 'p_desc','', {background : '#DADADA' } );
						} else  if(oper == '') {
							$( "#purchaseInfo" ).jqGrid( 'setCell', rows[i], 'p_code','', {background : '#DADADA' } );
							$( "#purchaseInfo" ).jqGrid( 'setCell', rows[i], 'p_desc','', {background : '#DADADA' } );
						}
					}
					
				},
				onCellSelect : function( row_id, colId ) {
					var cm = $("#purchaseInfo").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#purchaseInfo').jqGrid( 'getRowData', row_id );
					if ( colName['index'] == "p_code" ) {
						if(item.oper == "I" ){
							searchItem( "#purchaseInfo", "CATALOG_PO", 0, 1, row_id, colId);	
						}
					}
					
					if( row_id != null ) {

						var ret = $( "#purchaseInfo" ).getRowData( row_id );

						if( colId == 0 && ret.oper != "I" )
							$( "#purchaseInfo" ).jqGrid( 'setCell', row_id, 'p_code', '', 'not-editable-cell' );

						if( purchaseInfo_row != row_id ) {
							purchaseInfo_row = row_id;
						}
					}
				},
				loadComplete : function() {
					fn_additionalPurchaseInfo();
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onSelectRow : function( row_id ) {
					if( row_id != null ) {
						//catalog_row = row_id;
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );

			$( "#purchaseInfo" ).jqGrid( 'navGrid', "#ppurchaseInfo", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#purchaseInfo" ).navButtonAdd( '#ppurchaseInfo', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deletePurchaseInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#purchaseInfo" ).navButtonAdd( '#ppurchaseInfo', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addPurchaseInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//생산정보 그리드 
			$( "#productionInfo" ).jqGrid( {
				datatype : 'json',
				mtype : '',
// 				height : 'auto',
				url : '',
				editurl : '',
				colNames : [ '항목', '구분DESC', '항목값', '사용유무', '사용유무1', 'oper' ],
				colModel : [ { name : 't_code', index : 't_code', width : 30, editable : false, sortable : false, editrules : { required : true }, editoptions : { size : 2, dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#productionInfo'; fv_sd_type = "CATALOG_WIP"; searchItem( this, 0, 1, productionInfo_row_num, productionInfo_col); } } } ] } }, 
				             { name : 't_desc', index : 't_desc', width : 70, editable : false, sortable : false }, { name : 't_value', index : 't_value', width : 40, editable : true, sortable : false, editrules : { required : true }, editoptions : { size : 4 } }, 
				             { name : 't_flag', index : 't_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 't_flag_changed', index : 't_flag_changed', hidden : true }, { name : 'oper', index : 'oper', hidden : true }, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				autowidth : true,
				//sortname: 'catalog_code', 
				//sortorder: "asc", 
				viewrecords : true,
				height : $(window).height()/2-270,
				rowNum : 999999,
				pager : '#pproductionInfo',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : productionInfoEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						productionInfo_col = iCol;
						productionInfo_row_num = iRow;

						//fv_catalog_code = ret.catalog_code;
						if( productionInfo_row != row_id ) {
							productionInfo_row = row_id;
							//	fn_detailSearch(); 
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#productionInfo" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#productionInfo" ).getCell( rows[i], "oper" );
						if( oper == "I" ) {
							$( "#productionInfo" ).jqGrid( 'setCell', rows[i], 't_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#productionInfo" ).jqGrid( 'setCell', rows[i], 't_desc','', {background : '#DADADA' } );
						} else  if(oper == '') {
							$( "#productionInfo" ).jqGrid( 'setCell', rows[i], 't_code','', {background : '#DADADA' } );
							$( "#productionInfo" ).jqGrid( 'setCell', rows[i], 't_desc','', {background : '#DADADA' } );
						}
					}
					
				},
				onCellSelect : function( row_id, colId ) {
					var cm = $("#productionInfo").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#productionInfo').jqGrid( 'getRowData', row_id );
					if ( colName['index'] == "t_code" ) {
						if(item.oper == "I" ){
							searchItem( "#productionInfo", "CATALOG_WIP", 0, 1, row_id, colId);	
						}
					}
					if( row_id != null ) {
						var ret = $( "#productionInfo" ).getRowData( row_id );

						if( colId == 0 && ret.oper != "I" )
							$( "#productionInfo" ).jqGrid( 'setCell', row_id, 't_code', '', 'not-editable-cell' );

						if( productionInfo_row != row_id ) {
							productionInfo_row = row_id;
						}
					}
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onSelectRow : function( row_id ) {
					if( row_id != null ) {
						//row_selected = row_id;
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );

			$( "#productionInfo" ).jqGrid('navGrid', "#pproductionInfo", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#productionInfo" ).navButtonAdd( '#pproductionInfo', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteProductionInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#productionInfo" ).navButtonAdd( '#pproductionInfo', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addProductionInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			//LENGTH 그리드
			$( "#catalogLengthInfo" ).jqGrid( {
				datatype : 'json',
				mtype : '',
//	 			height : 'auto',
				url : '',
				editurl : '',
				colNames : [ 'LENGTH', '사용유무', '', 'oper' ],
				colModel : [ { name : 'catalog_length', index : 'catalog_length', width : 100, editable : true, sortable : false, editrules : { required : true }, align : "center"}, 
				             { name : 'enable_flag', index : 'enable_flag', width : 100, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				altRows : false,
				autowidth : true,
				height : $(window).height()/2-270,
				rowNum : 999999,
				pager : '#pcatalogLengthInfo',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : catalogLengthInfoEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						catalogLengthInfo_col = iCol;
						catalogLengthInfo_row_num = iRow;
					}
				},
				gridComplete : function() {
					
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onSelectRow : function( row_id ) {
					if( row_id != null ) {
						//row_selected = row_id;
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );

			$( "#catalogLengthInfo" ).jqGrid( 'navGrid', "#pcatalogLengthInfo", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#catalogLengthInfo" ).navButtonAdd( '#pcatalogLengthInfo', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteCatalogLengthInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#catalogLengthInfo" ).navButtonAdd( '#pcatalogLengthInfo', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addCatalogLengthInfoRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//ITEM속성
			$( "#itemAttributeBase" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				editurl : '',
				colNames : [ '물성치', '항목', 'Data Type', 'Desc', 'MIN', 'MAX', '상위물성치','<input type="checkbox" id="checkAll" />', '', 'oper' ],
				colModel : [ { name : 'item_attribute_code', index : 'item_attribute_code', width : 50, editable : false, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#itemAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_CODE"; searchItem( this, 0, -1, item_attr_row_num, item_attr_col); } } } ] } }, 
				             { name : 'item_attribute_name', index : 'item_attribute_name', width : 120, editable : false, sortable : false, editrules : { required : true }, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#itemAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_NAME"; searchAttrItem( this, 1, -1, item_attr_row_num, item_attr_col); } } } ] } }, 
				             { name : 'item_attribute_data_type', index : 'item_attribute_data_type', width : 40, editable : false, sortable : false, editrules : { required : true }, editoptions : { maxlength : "100", dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#itemAttributeBase'; fv_sd_type = "CATALOG_DATA_TYPE"; searchItem( this, 2, 3, item_attr_row_num, item_attr_col); } } } ] } }, 
				             { name : 'item_attribute_data_type_desc', index : 'item_attribute_data_type_desc', width : 105, editable : false, sortable : false, editoptions : { maxlength : "60" } }, 
				             { name : 'item_attribute_data_min', index : 'item_attribute_data_min', width : 32, editable : true, sortable : false, editoptions : {}, editrules : { custom : true, number : true, maxValue : 30, custom_func : minMaxCheck } }, 
				             { name : 'item_attribute_data_max', index : 'item_attribute_data_max', width : 32, editable : true, sortable : false, editoptions : {}, editrules : { custom : true, number : true, maxValue : 30, custom_func : minMaxCheck } }, 
				             { name : 'item_assy_attribute_code', index : 'item_assy_attribute_code', width : 40, editable : true, sortable : false, editoptions : { maxlength : "100", dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#itemAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_CODE"; searchAttrItem( this, 6, -1, item_attr_row_num, item_attr_col); } } } ] } }, 
				             { name : 'item_attribute_required_flag', index : 'item_attribute_required_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
				             { name : 'item_attribute_rf_changed', index : 'item_attribute_rf_changed', hidden : true },
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				//sortname: 'catalog_code', 
				//sortorder: "asc", 
				viewrecords : true,
				height : $(window).height()/2-180,
// 				width : 370,
				autowidth : true,
				rowNum : 999999,
				pager : '#pitemAttributeBase',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : itemAttributeBaseEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						var ret = $( "#itemAttributeBase" ).getRowData( row_id );

						item_attr_col = iCol;
						item_attr_row_num = iRow;

						//선택한 attribute
						fv_attribute_code = ret.item_attribute_code;

						if( item_attr_row != row_id ) {
							item_attr_row = row_id;
							fn_searchAttributeBase();
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#itemAttributeBase" ).getDataIDs();
					
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#itemAttributeBase" ).getCell( rows[i], "oper" );
						if( oper == "I" ) {
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_name','', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_data_type','', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_data_type_desc','', {background : '#DADADA' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_assy_attribute_code','', { cursor : 'pointer', background : 'pink' } );
							
						} else if(oper == '') {
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_code','', {background : '#DADADA' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_name','', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_data_type','', { cursor : 'pointer', background : 'pink' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_attribute_data_type_desc','', {background : '#DADADA' } );
							$( "#itemAttributeBase" ).jqGrid( 'setCell', rows[i], 'item_assy_attribute_code','', { cursor : 'pointer', background : 'pink' } );
						}
					}		
				},
				loadComplete : function() {
					if( $( "#itemAttributeBase" ).getGridParam( "reccount") > 0 ) {
						var ret = $( "#itemAttributeBase" ).getRowData( 1 );
						item_attr_row = 1;
						fv_attribute_code = ret.item_attribute_code;
					} else {
						item_attr_row = 0;
						fv_attribute_code = "";
					}

					fn_searchAttributeBase();
				},
				onCellSelect : function( row_id, colId ) {
					var cm = $("#itemAttributeBase").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#itemAttributeBase').jqGrid( 'getRowData', row_id );
					if ( colName['index'] == "item_attribute_code" ) {
						if(item.oper == "I" ){
							searchItem( "#itemAttributeBase", "CATALOG_ATTRIBUTE_CODE", 0, -1, row_id, colId);	
						}
					}
					if ( colName['index'] == "item_attribute_name" ) {
						searchAttrItem( "#itemAttributeBase", "CATALOG_ATTRIBUTE_NAME", 1, -1, row_id, colId);	
					}
					if ( colName['index'] == "item_attribute_data_type" ) {
						searchItem( "#itemAttributeBase", "CATALOG_DATA_TYPE", 2, 3, row_id, colId);	
					}
					if ( colName['index'] == "item_assy_attribute_code" ) {
						searchAttrItem( "#itemAttributeBase", "CATALOG_ATTRIBUTE_CODE", 6, -1, row_id, colId);	
					}
					 
					 
					if( row_id != null ) {
						var ret = $( "#itemAttributeBase" ).getRowData( row_id );

						//선택한 attribute
						fv_attribute_code = ret.item_attribute_code;

						if( colId == 0 && ret.oper != "I" )
							$( "#itemAttributeBase" ).jqGrid( 'setCell', row_id, 'item_attribute_code', '', 'not-editable-cell' );

						if( item_attr_row != row_id ) {
							item_attr_row = row_id;
							fn_searchAttributeBase();
						}
					}
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        },
				imgpath : 'themes/basic/images'
				
			} );

			$( "#itemAttributeBase" ).jqGrid( 'navGrid', "#pitemAttributeBase", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#itemAttributeBase" ).navButtonAdd( '#pitemAttributeBase', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteAttributeBaseRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#itemAttributeBase" ).navButtonAdd( '#pitemAttributeBase', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addAttributeBaseRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//ITEM Value 그리드
			$( "#itemValue" ).jqGrid( {
				datatype : 'json',
				mtype : '',
// 				height : 'auto',
				url : '',
				editurl : '',
				colNames : [ 'Value', '번호', 'Value1', '번호1', 'oper' ],
				colModel : [ { name : 'item_value_code', index : 'item_value_code', width : 100, editable : true, sortable : true, editrules : { required : true }, editoptions : {} }, 
				             { name : 'item_item_make_value', index : 'item_item_make_value', width : 45, editable : true, sortable : true, editoptions : {} }, 
				             { name : 'org_value_code', index : 'org_value_code', hidden : true }, 
				             { name : 'org_item_make_value', index : 'org_item_make_value', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				sortname: 'item_value_code', 
				sortorder: "desc", 
				viewrecords : true,
				height : $(window).height()/2-180,
// 				width : 150,
				autowidth : true,
				rowNum : 999999,
				pager : '#pitemValue',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : itemValueEditEnd,				
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						var ret = $( "#itemValue" ).getRowData( row_id );

						item_value_col = iCol;
						item_value_row_num = iRow;

						//선택한 attribute
						fv_value_code = ret.item_value_code;
						fv_item_make_value = ret.item_item_make_value;

						if( item_value_row != row_id ) {
							item_value_row = row_id;
							fn_searchItemValue();
						}
					}
				},
				loadComplete : function() {
					if( $( "#itemValue" ).getGridParam( "reccount" ) > 0 ) {
						var ret = $( "#itemValue" ).getRowData( 1 );

						item_value_row = 1;
						fv_value_code = ret.item_value_code;
						fv_item_make_value = ret.item_item_make_value;
					} else {
						item_value_row = 0;
						fv_value_code = "";
						fv_item_make_value = "";
					}

					fn_searchItemValue();
				},
				onCellSelect : function( row_id, colId ) {
					if( row_id != null ) {
						var ret = $( "#itemValue" ).getRowData( row_id );
						//선택한 attribute
						fv_value_code = ret.item_value_code;
						fv_item_make_value = ret.item_item_make_value;

						if( item_value_row != row_id ) {
							item_value_row = row_id;
							fn_searchItemValue();
						}
					}
				},
				onSortCol: function(columnName, columnIndex, sortOrder) {// 헤더 클릭 이벤트 : 칼럼명, 인덱스, 정렬순서 
					/* if(columnName == 'item_value_code') {
						$("#itemValue").setGridParam({sortname:'item_value_code', sortorder:sortOrder});
						fn_searchItemValue();
					} */
					$( "#column_name" ).val(columnName);
					$( "#item_order" ).val(sortOrder);
					jQuery("#itemValue").jqGrid('setGridParam',{postData: getFormData('#listForm')}).trigger("reloadGrid");  
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        },
				imgpath : 'themes/basic/images',
			} );

			$( "#itemValue" ).jqGrid( 'navGrid', "#pitemValue", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#itemValue" ).navButtonAdd( '#pitemValue', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteItemValueRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#itemValue" ).navButtonAdd( '#pitemValue', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addItemValueRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//ITEM 상위속성 그리드
			$( "#topItemValue" ).jqGrid( {
				datatype : 'json',
				mtype : '',
// 				height : 'auto',
				url : '',
				editurl : '',
				colNames : [ '상위속성', '사용유무', '상위속성1', '사용유무1', 'oper' ],
				colModel : [ { name : 'item_assy_value_code', index : 'item_assy_value_code', width : 90, editable : false, sortable : false, editrules : { required : true, maxValue : 100 }, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#topItemValue'; searchHighRankAttr( this, 0, -1, topitem_value_row_num, topitem_value_col); } } } ] } }, 
				             { name : 'item_enable_flag', index : 'item_enable_flag', width : 42, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
				             { name : 'org_assy_value_code', index : 'org_assy_value_code', hidden : true }, 
				             { name : 'item_enable_flag_changed', index : 'item_enable_flag_changed', hidden : true }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				sortname : 'catalog_code',
				sortorder : "asc",
				viewrecords : true,
				altRows : false,
				autowidth : true,
				height : $(window).height()/2-180,
				rowNum : 999999,
				pager : '#ptopItemValue',
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				viewrecords : false,
				cellEdit : true,
				cellsubmit : 'clientArray',
				beforeSaveCell : topItemValueEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if( row_id != null ) {
						topitem_value_col = iCol;
						topitem_value_row_num = iRow;
					}
				},
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				gridComplete : function() {
					var rows = $( "#topItemValue" ).getDataIDs();
					
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#topItemValue" ).getCell( rows[i], "oper" );
						if( oper == "I" ) {
							$( "#topItemValue" ).jqGrid( 'setCell', rows[i], 'item_assy_value_code', '', { cursor : 'pointer', background : 'pink' } );
						} else if(oper == '') {
							$( "#topItemValue" ).jqGrid( 'setCell', rows[i], 'item_assy_value_code','', { cursor : 'pointer', background : 'pink' } );
						}
					}		
				},
				onCellSelect : function( row_id, colId ) {
					var cm = $("#topItemValue").jqGrid("getGridParam", "colModel");
					var colName = cm[colId];
					var item = $('#topItemValue').jqGrid( 'getRowData', row_id );
					if ( colName['index'] == "item_assy_value_code" ) {
						searchHighRankAttr( "#topItemValue", 0, -1, row_id, colId);
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
				,
				imgpath : 'themes/basic/images'
			} );

			$( "#topItemValue" ).jqGrid( 'navGrid', "#ptopItemValue", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#topItemValue" ).navButtonAdd( '#ptopItemValue', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteTopItemValueRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#topItemValue" ).navButtonAdd( '#ptopItemValue', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addTopItemValueRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			//BOM 속성 그리드     
			$( "#bomAttributeBase" ).jqGrid( {
				datatype : 'json',
				mtype : '',
// 				height : 'auto',
				width : 320,
				url : '',
				editurl : '',
				colNames : [ '물성치', '항목', 'Data Type', 'Desc', 'MIN', 'MAX', '상위물성치', 'oper' ],
				colModel : [ { name : 'bom_attribute_code', index : 'bom_attribute_code', width : 40, editable : false, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#bomAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_CODE"; searchItem( this, 0, -1, bom_attr_row_num, bom_attr_col); } } } ] } }, 
				             { name : 'bom_attribute_name', index : 'bom_attribute_name', width : 98, editable : false, sortable : false, editrules : { required : true }, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#bomAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_NAME"; searchAttrItem( this, 1, -1, bom_attr_row_num, bom_attr_col); } } } ] } }, 
				             { name : 'bom_attribute_data_type', index : 'bom_attribute_data_type', width : 30, editable : false, sortable : false, editrules : { required : true }, editoptions : { maxlength : "100", dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#bomAttributeBase'; fv_sd_type = "CATALOG_DATA_TYPE"; searchItem( this, 2, 3, bom_attr_row_num, bom_attr_col); } } } ] } }, 
				             { name : 'bom_attribute_data_type_desc', index : 'bom_attribute_data_type_desc', width : 92, editable : false, sortable : false, editoptions : { maxlength : "60" } }, 
				             { name : 'bom_attribute_data_min', index : 'bom_attribute_data_min', width : 32, editable : true, sortable : false, editoptions : {}, editrules : { custom : true, number : true, maxValue : 200, custom_func : minMaxCheck2 } }, 
				             { name : 'bom_attribute_data_max', index : 'bom_attribute_data_max', width : 32, editable : true, sortable : false, editoptions : {}, editrules : { custom : true, number : true, maxValue : 200, custom_func : minMaxCheck2 } }, 
				             { name : 'bom_assy_attribute_code', index : 'bom_assy_attribute_code', width : 30, editable : true, sortable : false, editoptions : { maxlength : "100", dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#bomAttributeBase'; fv_sd_type = "CATALOG_ATTRIBUTE_CODE"; searchAttrItem( this, 6, -1, bom_attr_row_num, bom_attr_col); } } } ] } }, 
				             { name : 'oper', index : 'oper', hidden : true } ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			//sortname: 'catalog_code', 
			//sortorder: "asc", 
			viewrecords : true,
			//altRows: false, 
			autowidth : true,
			height : $(window).height()/2-180,
			rowNum : 999999,
			pager : '#pbomAttributeBase',
			pgbuttons : false,
			pgtext : false,
			pginput : false,
			viewrecords : false,
			cellEdit : true,
			cellsubmit : 'clientArray',
			beforeSaveCell : bomAttributeBaseEditEnd,
			beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
				if( row_id != null ) {
					var ret = $( "#bomAttributeBase" ).getRowData( row_id );

					bom_attr_col = iCol;
					bom_attr_row_num = iRow;

					//선택한 attribute
					fv_bom_attr_code = ret.bom_attribute_code;

					if( bom_attr_row != row_id ) {
						bom_attr_row = row_id;
						fn_searchBomAttributeBase();
					}
				}
			},
			loadComplete : function() {
				if( $( "#bomAttributeBase" ).getGridParam( "reccount" ) > 0 ) {
					var ret = $( "#bomAttributeBase" ).getRowData( 1 );
					bom_attr_row = 1;
					fv_bom_attr_code = ret.bom_attribute_code;
				} else {
					bom_attr_row = 0;
					fv_bom_attr_code = "";
				}

				fn_searchBomAttributeBase();
			},
			gridComplete : function() {
				var rows = $( "#bomAttributeBase" ).getDataIDs();
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#bomAttributeBase" ).getCell( rows[i], "oper" );
					if( oper == "I" ) {
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_code', '', { cursor : 'pointer', background : 'pink' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_name', '', { cursor : 'pointer', background : 'pink' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_data_type', '', { cursor : 'pointer', background : 'pink' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_data_type_desc','', {background : '#DADADA' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_assy_attribute_code', '', { cursor : 'pointer', background : 'pink' } );
					} else  if(oper == '') {
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_code', '',  {background : '#DADADA' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_name', '', { cursor : 'pointer', background : 'pink' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_data_type', '', { cursor : 'pointer', background : 'pink' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_attribute_data_type_desc','', {background : '#DADADA' } );
						$( "#bomAttributeBase" ).jqGrid( 'setCell', rows[i], 'bom_assy_attribute_code', '', { cursor : 'pointer', background : 'pink' } );
					}
				}
				
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images',
			onCellSelect : function( row_id, colId ) {
				var cm = $("#bomAttributeBase").jqGrid("getGridParam", "colModel");
				var colName = cm[colId];
				var item = $('#bomAttributeBase').jqGrid( 'getRowData', row_id );
				if ( colName['index'] == "bom_attribute_code" ) {
					if(item.oper == "I" ){
						searchItem( "#bomAttributeBase","CATALOG_ATTRIBUTE_CODE", 0, -1, row_id, colId);
					}
				}
				if ( colName['index'] == "bom_attribute_name" ) {
					searchAttrItem( "#bomAttributeBase","CATALOG_ATTRIBUTE_NAME", 1, -1, row_id, colId);
				}
				if ( colName['index'] == "bom_attribute_data_type" ) {
					searchItem( "#bomAttributeBase","CATALOG_DATA_TYPE", 2, 3, row_id, colId);
				}
				if ( colName['index'] == "bom_assy_attribute_code" ) {
					searchAttrItem(  "#bomAttributeBase","CATALOG_ATTRIBUTE_CODE", 6, -1, row_id, colId);
				}
				
				if( row_id != null ) {
					var ret = $( "#bomAttributeBase" ).getRowData( row_id );

					//선택한 attribute
					fv_bom_attr_code = ret.bom_attribute_code;

					if( colId == 0 && ret.oper != "I" )
						$( "#bomAttributeBase" ).jqGrid( 'setCell', row_id, 'bom_attribute_code', '', 'not-editable-cell' );

					if( bom_attr_row != row_id ) {
						bom_attr_row = row_id;
						fn_searchBomAttributeBase();
					}
				}
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#0AC9FF");
	        }
		} );

		$( "#bomAttributeBase" ).jqGrid( 'navGrid', "#pbomAttributeBase", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false
		} );

		<c:if test="${userRole.attribute3 == 'Y'}">
		$( "#bomAttributeBase" ) .navButtonAdd( '#pbomAttributeBase', {
			caption : "",
			buttonicon : "ui-icon-minus",
			onClickButton : deleteBomAttributeBaseRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		<c:if test="${userRole.attribute2 == 'Y'}">
		$( "#bomAttributeBase" ).navButtonAdd( '#pbomAttributeBase', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addBomAttributeBaseRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		//BOM Value 그리드
		$( "#bomValue" ).jqGrid( {
			datatype : 'json',
			mtype : '',
// 			height : 'auto',
			url : '',
			editurl : '',
			colNames : [ 'VALUE', 'VALUE1', 'oper' ],
			colModel : [ { name : 'bom_value_code', index : 'bom_value_code', width : 90, sortable : false, editable : true, editrules : { required : true }, editoptions : {} }, 
			             { name : 'org_value_code', index : 'org_value_code', hidden : true }, 
			             { name : 'oper', index : 'oper', hidden : true }, ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			sortname : 'catalog_code',
			sortorder : "asc",
			viewrecords : true,
			altRows : false,
			autowidth : true,
			height : $(window).height()/2-180,
			rowNum : 999999,
			pager : '#pbomValue',
			pgbuttons : false,
			pgtext : false,
			pginput : false,
			viewrecords : false,
			cellEdit : true,
			cellsubmit : 'clientArray',
			beforeSaveCell : bomValueEditEnd,
			beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
				if( row_id != null ) {
					var ret = $( "#bomValue" ).getRowData( row_id );

					bom_value_col = iCol;
					bom_value_row_num = iRow;

					//선택한 attribute
					fv_bom_val_code = ret.bom_value_code;

					if( bom_value_row != row_id ) {
						bom_value_row = row_id;
						fn_searchBomValue();
					}
				}
			},
			loadComplete : function() {
				if( $( "#bomValue" ).getGridParam( "reccount" ) > 0 ) {
					var ret = $( "#bomValue" ).getRowData( 1 );
					bom_value_row = 1;
					fv_bom_val_code = ret.bom_value_code;
				} else {
					bom_value_row = 0;
					fv_bom_val_code = "";
				}
				fn_searchBomValue();
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images',
			onCellSelect : function( row_id, colId ) {
				if( row_id != null ) {
					var ret = $( "#bomValue" ).getRowData( row_id );

					//선택한 attribute
					fv_bom_val_code = ret.bom_value_code;

					if( bom_value_row != row_id ) {
						bom_value_row = row_id;
						fn_searchBomValue();
					}
				}
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#0AC9FF");
	        }
		} );

		$( "#bomValue" ).jqGrid( 'navGrid', "#pbomValue", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false
		} );

		<c:if test="${userRole.attribute3 == 'Y'}">
		$( "#bomValue" ).navButtonAdd( '#pbomValue', {
			caption : "",
			buttonicon : "ui-icon-minus",
			onClickButton : deleteBomValueRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		<c:if test="${userRole.attribute2 == 'Y'}">
		$( "#bomValue" ).navButtonAdd( '#pbomValue', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addBomValueRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		//BOM 상위속성 그리드
		$( "#topBomValue" ).jqGrid( {
			datatype : 'json',
			mtype : '',
// 			height : 'auto',
			url : '',
			editurl : '',
			colNames : [ '상위속성', '사용유무', '상위속성1', '사용유무1', 'oper' ],
			colModel : [ { name : 'bom_assy_value_code', index : 'bom_assy_value_code', width : 70, editable : false, sortable : false, editrules : { required : true, maxValue : 100 }, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if( key == 13 || key == 9) {/*enter,tab*/ tableId = '#topBomValue'; searchHighRankAttr( this, 0, -1, topbom_value_row_num, topbom_value_col); } } } ] } }, 
			             { name : 'bom_enable_flag', index : 'bom_enable_flag', width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" }, 
			             { name : 'org_assy_value_code', index : 'org_assy_value_code', hidden : true }, 
			             { name : 'bom_enable_flag_changed', index : 'bom_enable_flag_changed', hidden : true }, 
			             { name : 'oper', index : 'oper', hidden : true } ],
			gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			sortname : 'catalog_code',
			sortorder : "asc",
			viewrecords : true,
			altRows : false,
			autowidth : true,
			height : $(window).height()/2-180,
			rowNum : 999999,
			pager : '#ptopBomValue',
			pgbuttons : false,
			pgtext : false,
			pginput : false,
			viewrecords : false,
			cellEdit : true,
			cellsubmit : 'clientArray',
			beforeSaveCell : topBomValueEditEnd,
			beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
				if( row_id != null ) {
					topbom_value_col = iCol;
					topbom_value_row_num = iRow;
				}
			},
			gridComplete : function() {
				var rows = $( "#topBomValue" ).getDataIDs();
				
				for ( var i = 0; i < rows.length; i++ ) {
					var oper = $( "#topBomValue" ).getCell( rows[i], "oper" );
					if( oper == "I" ) {
						$( "#topBomValue" ).jqGrid( 'setCell', rows[i], 'bom_assy_value_code', '', { cursor : 'pointer', background : 'pink' } );
					} else if(oper == '') {
						$( "#topBomValue" ).jqGrid( 'setCell', rows[i], 'bom_assy_value_code','', { cursor : 'pointer', background : 'pink' } );
					}
				}		
			},onCellSelect : function( row_id, colId ) {
				var cm = $("#topBomValue").jqGrid("getGridParam", "colModel");
				var colName = cm[colId];
				var item = $('#topBomValue').jqGrid( 'getRowData', row_id );
				if ( colName['index'] == "bom_assy_value_code" ) {
					searchHighRankAttr( "#topBomValue", 0, -1, row_id, colId);
				}
			},
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			imgpath : 'themes/basic/images',
			onSelectRow : function( row_id ) {
				if( row_id != null ) {
					//row_selected = row_id;
				}
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				jQuery("#"+rowid).css("background", "#0AC9FF");
	        }
		} );

		$( "#topBomValue" ).jqGrid( 'navGrid', "#ptopBomValue", {
			refresh : false,
			search : false,
			edit : false,
			add : false,
			del : false
		} );

		<c:if test="${userRole.attribute3 == 'Y'}">
		$( "#topBomValue" ).navButtonAdd( '#ptopBomValue', {
			caption : "",
			buttonicon : "ui-icon-minus",
			onClickButton : deleteTopBomValueRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		<c:if test="${userRole.attribute2 == 'Y'}">
		$( "#topBomValue" ).navButtonAdd( '#ptopBomValue', {
			caption : "",
			buttonicon : "ui-icon-plus",
			onClickButton : addBomTopBomValueRow,
			position : "first",
			title : "",
			cursor : "pointer"
		} );
		</c:if>

		//------버튼 이벤트---------------------------------------------------------------------------------------------------------------

		//조회버튼 클릭한다.
		$( "#btnSearch" ).click( function() {
			fn_search();
		} );

		//저장버튼 클릭한다.
		$( "#btnSave" ).click( function() {
			fn_save();
		} );

		//Value코드 조회 버튼을 클릭한다.
		$( "#btnAttrValSearch" ).click( function() {
			fn_searchAttributeBase();
		} );

		//부가속성버튼 클릭한다.
		$( "#btnAddItemAttr" ).click( function() {
			fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
	
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			if( rowId == null ) {
				alert( "Catalog 선택 후 부가속성 등록 바랍니다!" );
				return;
			}
	
			if( win != null ) {
				win.close();
			}
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			var rowData = $( "#catalogMain" ).getRowData( rowId );
			var args = { p_catalog_code : rowData.catalog_code };
			var rs = window.showModalDialog( "popUpCatalogAddItemAttr.do",
					args,
					"dialogWidth:600px; dialogHeight:480px; center:on; scroll:off; status:off;" );
			//setTimeout( "win = window.open('./catalogHistory.do?gbn=catalogAddItemAttr','listForm','height=480,width=600,top=200,left=200,location=no')", 200 );
		} );

		//Catalog History버튼 클릭한다.
		$( "#btnCatalogHis" ).click( function() {

			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			var rowData = $( "#catalogMain" ).getRowData( rowId );

			if( win != null ) {
				win.close();
			}

			win = window.open( "./popUpCatalogHistory.do?sel_catalog_code=" + rowData.sel_catalog_code,
					"listForm",
					"height=800,width=1300,top=200,left=200,location=no" );
		} );

		//Item/Bom History버튼 클릭한다.	
		$( "#btnItemBomHis" ).click( function() {
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			var rowData = $( "#catalogMain" ).getRowData( rowId );

			if( win != null ) {
				win.close();
			}

			win = window.open( "./popUpItemBomHistory.do?sel_catalog_code=" + rowData.sel_catalog_code,
					"listForm",
					"height=800,width=1300,top=200,left=200,location=no" );
		} );

		//TextFilter버튼 클릭한다.
		$( "#btnTextFilter" ).click( function() {
			if( win != null ) {
				win.close();
			}
			
			win = window.open( "./popUpCatalogItemDescChange.do",
					"listForm",
					"height=700,width=1268,top=200,left=200,location=no,scrollbars=yes" );
		} );

		//엑셀 업로드버튼 클릭한다.
		$( "#btnExcelUpLoad" ).click( function() {
			fn_excelUpload();
		} );

		//엑셀 다운로드버튼 클릭한다.
		$( "#btnExcelDownLoad" ).click( function( e ) {
			fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
			
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			if( rowId == null ) {
				alert( "Catalog 선택 후 Excel 다운로드 바랍니다!" );
				return;
			}
			fn_downloadStart();
			location.href = 'catalogExcelExport.do?catalog_code=' + fv_catalog_code;
		} );

		//상위Catalog버튼 클릭한다.
		$( "#btnHighLinkCatalog" ).click( function() {
			fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			if( rowId == null ) {
				alert( "Catalog 선택 바랍니다!" );
				return;
			}
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			var rowData = $( "#catalogMain" ).getRowData( rowId );
			var args = { p_catalog_code : rowData.catalog_code };
			var rs = window.showModalDialog( "popUpCatalogHighRankCatalog.do",
					args,
					"dialogWidth:450px; dialogHeight:500px; center:on; scroll:off; status:off;" );

			//setTimeout( "win = window.open('popUpCatalogHighRankCatalog.do','listForm','height=500,width=450,top=200,left=200,location=no')", 200 );
		} );

		//조회버튼 클릭한다.
		$( "#btnTechnicalSpec" ).click( function() {
			fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
			
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			if( rowId == null ) {
				alert( "Catalog 선택 후 비용성 코드 생성 바랍니다!" );
				return;
			}
			var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
			var rowData = $( "#catalogMain" ).getRowData( rowId );
			var args = { p_catalog_code : rowData.catalog_code,
					p_catalog_desc : rowData.catalog_desc,
					p_category_id : rowData.category_id,
					p_uom_code : rowData.uom_code};
			var rs = window.showModalDialog( "popUpCatalogTechnicalSpec.do",
					args,
					"dialogWidth:440px; dialogHeight:470px; center:on; scroll:off; status:off;" );
			//setTimeout( "win = window.open('popUpCatalogTechnicalSpec.do','listForm','height=470,width=440,top=200,left=200,location=no')", 200 );
		} );

		//조회버튼 클릭한다.
// 		$( "#btnModify" ).click( function() {
// 			if( trid < 0 ) {
// 				alert( "Please select item" );
// 				return;
// 			}

// 			$( "#mode" ).val( "update" );

// 			var sCategory_code3 = $( "#p_tr_" + trid ).find( "td:eq(5)" ).text();

// 			window.open( "./categoryMgntForm.do?mode=" + $( "#mode" ).val() + "&type_code=" + $( "#p_tr_" + trid ).find( "td:eq(1)").text() + "&category_code1=" + $( "#p_tr_" + trid ).find( "td:eq(3)" ).text() + "&category_code2=" + $( "#p_tr_" + trid ).find( "td:eq(4)" ).text() + "&category_code3=" + sCategory_code3,
// 					"listForm",
// 					"height=350,width=360,top=200,left=200" );
// 		} );

// 		//조회버튼 클릭한다.
// 		$( "#btnModifyDiv" ).click( function() {
// 			if( trid < 0 ) {
// 				alert( "Please select item" );
// 				return;
// 			}

// 			$( "#mode" ).val( "update" );

// 			window.open( "./categoryMgntDivForm.do?mode=" + $( "#mode" ).val() + "&category_id=" + $( "#p_tr_div" + trid ).find( "td:eq(1)" ).text(),
// 					"listForm",
// 					"height=180,width=360,top=200,left=200" );
// 		} );

		//Catalog 조회버튼 클릭한다.
		$( "#btnCatalog" ).click( function() {
			var args = { p_code_find : $( "input[name=p_catalog_code]" ).val() };
			var rs = window.showModalDialog( "popUpCatalogInfo.do",
					args,
					"dialogWidth:600px; dialogHeight:480px; center:on; scroll:off; status:off" );
			
			if( rs != null )
				$( "input[name=p_catalog_code]" ).val( rs[0] );
		} );
		
		
		//grid resize
		fn_insideGridresize( $(window), $( "#catalogMainFS" ), $( "#catalogMain" ),-70,0.5 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#designInfoFS" ), $( "#designInfo" ) ,0,0.5 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#purchaseInfoFS" ), $( "#purchaseInfo" ) ,0,0.5 );

		//grid resize
		fn_insideGridresize( $(window), $( "#productionInfoFS" ), $( "#productionInfo" ),-105,0.25 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#productionInfoFS" ), $( "#catalogLengthInfo" ),-105,0.25  );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#itemAttrBaseDiv" ), $( "#itemAttributeBase" ) ,0,0.5 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#itemValueDiv" ), $( "#itemValue" ) ,0,0.5 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#topItemValueDiv" ), $( "#topItemValue" ) ,0,0.5 );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#bomAttrBaseDiv" ), $( "#bomAttributeBase" ),0,0.5  );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#bomValueDiv" ), $( "#bomValue" ),0,0.5  );
		
		//grid resize
		fn_insideGridresize( $(window), $( "#topBomValueDiv" ), $( "#topBomValue" ) ,0,0.5 );
		
		$("#checkAll").click(function(){

			var rows = $( "#itemAttributeBase" ).getDataIDs();
			
			for ( var i = 0; i < rows.length; i++ ) {
				$( "#itemAttributeBase" ).setCell( rows[i], 'item_attribute_required_flag', 'Y' );
			}
		});
		
		
	} ); //end of ready

	/***********************************************************************************************																
	 * 이벤트 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	//------그리드 cell변경시---------------------------------------------------------------------------------------------------------------
	function catalogEditEnd( irowId, cellName, value, irow, iCol ) {
		var item = $( '#catalogMain' ).jqGrid( 'getRowData', irowId );
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#catalogMain' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#catalogMain' ).jqGrid( "setRowData", irowId, item );

		//turn off editing.
		$( "input.editable,select.editable", this ).attr( "editable", "0" );

		if( cellName == "catalog_code" || cellName == "part_family_code" ) {
			//fn_searchCategory(item.catalog_code, item.part_family_code, irowId);
		}
	}

	function designInfoEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#designInfo' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#designInfo' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#designInfo' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function purchaseInfoEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#purchaseInfo' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#purchaseInfo' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#purchaseInfo' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function productionInfoEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#productionInfo' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#productionInfo' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#productionInfo' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}
	
	function catalogLengthInfoEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#catalogLengthInfo' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#catalogLengthInfo' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#catalogLengthInfo' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function itemAttributeBaseEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#itemAttributeBase' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#itemAttributeBase' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#itemAttributeBase' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function itemValueEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#itemValue' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#itemValue' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#itemValue' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function topItemValueEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#topItemValue' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#topItemValue' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#topItemValue' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function bomAttributeBaseEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#bomAttributeBase' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#bomAttributeBase' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#bomAttributeBase' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function bomValueEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#bomValue' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#bomValue' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#bomValue' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	function topBomValueEditEnd(irowId, cellName, value, irow, iCol) {

		var item = $( '#topBomValue' ).jqGrid('getRowData', irowId);
		if( item.oper != 'I' ){
			item.oper = 'U';
			$( '#topBomValue' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
		}

		//apply the data which was entered.
		$( '#topBomValue' ).jqGrid("setRowData", irowId, item);
		//turn off editing.
		$("input.editable,select.editable", this).attr("editable", "0");
	}

	//------그리드 추가/삭제---------------------------------------------------------------------------------------------------------------
	function addCatalogRow() {
		gridClear();

		//현재 수정중인데 cell저장	
		fn_applyData( "#catalogMain", catalog_row_num, catalog_col );

		var item = {};
		var colModel = $( '#catalogMain' ).jqGrid( 'getGridParam', 'colModel' );
		for( var i in colModel )
			item[colModel[i].name] = '';

		item.oper = 'I';
		item.enable_flag = 'Y';

		$( '#catalogMain' ).resetSelection();
		$( '#catalogMain' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );

		tableId = '#catalogMain';
	}

	function deleteCatalogRow() {
		fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
		fn_deleteRow( "#catalogMain" );
	}

	function addDesignInfoRow( item ) {
		fn_applyData( "#designInfo", designInfo_row_num, designInfo_col );
		fn_addRow( "#designInfo", item );
	}

	function deleteDesignInfoRow() {
		fn_applyData( "#designInfo", designInfo_row_num, designInfo_col );
		fn_deleteRow( "#designInfo" );
	}

	function addPurchaseInfoRow( item ) {
		fn_applyData( "#purchaseInfo", purchaseInfo_row_num, purchaseInfo_col );
		fn_addRow( "#purchaseInfo", item );
	}

	function deletePurchaseInfoRow() {
		fn_applyData( "#purchaseInfo", purchaseInfo_row_num, purchaseInfo_col );
		fn_deleteRow( "#purchaseInfo" );
	}

	function addProductionInfoRow( item ) {
		fn_applyData( "#productionInfo", productionInfo_row_num, productionInfo_col);
		fn_addRow( "#productionInfo", item );
	}

	function deleteCatalogLengthInfoRow() {
		fn_applyData( "#catalogLengthInfo", catalogLengthInfo_row_num, catalogLengthInfo_col );
		fn_deleteRow( "#catalogLengthInfo");
	}
	
	function addCatalogLengthInfoRow( item ) {
		fn_applyData( "#catalogLengthInfo", catalogLengthInfo_row_num, catalogLengthInfo_col);
		fn_addRow( "#catalogLengthInfo", item );
	}

	function deleteProductionInfoRow() {
		fn_applyData( "#productionInfo", productionInfo_row_num, productionInfo_col );
		fn_deleteRow( "#productionInfo");
	}

	function addAttributeBaseRow( item ) {
		fn_applyData( "#itemAttributeBase", item_attr_row_num, item_attr_col );
		fn_addRow( "#itemAttributeBase", item );
	}

	function deleteAttributeBaseRow() {
		fn_applyData( "#itemAttributeBase", item_attr_row_num, item_attr_col );
		fn_deleteRow( "#itemAttributeBase" );
	}

	function addItemValueRow( item ) {
		fn_applyData( "#itemValue", item_value_row_num, item_value_col );
		fn_addRow( "#itemValue", item );
	}

	function deleteItemValueRow() {
		fn_applyData( "#itemValue", item_value_row_num, item_value_col );
		fn_deleteRow( "#itemValue" );
	}

	function addTopItemValueRow( item ) {
		fn_applyData( "#topItemValue", topitem_value_row_num, topitem_value_col );
		fn_addRow( "#topItemValue", item );
	}

	function deleteTopItemValueRow() {
		fn_applyData( "#topItemValue", topitem_value_row_num, topitem_value_col );
		fn_deleteRow( "#topItemValue" );
	}

	function addBomAttributeBaseRow( item ) {
		fn_applyData( "#bomAttributeBase", bom_attr_row_num, bom_attr_col );
		fn_addRow( "#bomAttributeBase", item );
	}

	function deleteBomAttributeBaseRow() {
		fn_applyData( "#bomAttributeBase", bom_attr_row_num, bom_attr_col );
		fn_deleteRow( "#bomAttributeBase" );
	}

	function addBomValueRow( item ) {
		fn_applyData( "#bomValue", bom_value_row_num, bom_value_col );
		fn_addRow( "#bomValue", item );
	}

	function deleteBomValueRow() {
		fn_applyData( "#bomValue", bom_value_row_num, bom_value_col );
		fn_deleteRow( "#bomValue" );
	}

	function addBomTopBomValueRow( item ) {
		fn_applyData( "#topBomValue", topbom_value_row_num, topbom_value_col );
		fn_addRow( "#topBomValue", item );
	}

	function deleteTopBomValueRow() {
		fn_applyData( "#topBomValue", topbom_value_row_num, topbom_value_col );
		fn_deleteRow( "#topBomValue" );
	}

	function fn_addRow( gridId, item ) {
		var item = {};
		var colModel = $( gridId ).jqGrid( 'getGridParam', 'colModel' );
		for( var i in colModel )
			item[colModel[i].name] = '';

		item.oper = 'I';

		$( gridId ).resetSelection();
		if(gridId == "#itemAttributeBase"){
			$( gridId ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
		}else{
			$( gridId ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}
		

		tableId = gridId;
	}

	function fn_deleteRow( gridId ) {
		var selrow = $( gridId ).jqGrid( 'getGridParam', 'selrow' );
		var item = $( gridId ).jqGrid( 'getRowData', selrow );

		if( item.oper != 'I' ) {
			item.oper = 'D';
			if( gridId == "#catalogMain" ) {
				catalogDeleteData.push(item);
			} else if( gridId == "#designInfo" ) {
				designDeleteData.push( item );
			} else if( gridId == "#purchaseInfo" ) {
				purchaseDeleteData.push( item );
			} else if( gridId == "#productionInfo" ) {
				productionDeleteData.push( item );
			} else if( gridId == "#catalogLengthInfo" ) {
				catalogLengthDeleteData.push( item );
			} else if( gridId == "#itemAttributeBase" ) {
				//itemAttributeDeleteData.push( item );
				alert("해당 데이터는 삭제가 불가능 합니다.");
				return;
			} else if( gridId == "#itemValue" ) {
				itemValueDeleteData.push( item );
			} else if( gridId == "#topItemValue" ) {
				topItemValueDeleteData.push( item );
			} else if( gridId == "#bomAttributeBase" ) {
				bomAttributeDeleteData.push( item );
			} else if( gridId == "#bomValue" ) {
				bomValueDeleteData.push( item );
			} else if( gridId == "#topBomValue" ) {
				topBomValueDeleteData.push( item );
			}
			
			$(gridId).jqGrid("setRowData", selrow, item);
			gridDelColorEdit(gridId,selrow);
			
		} else {
			$( gridId ).jqGrid( 'delRowData', selrow );
		}

		
		$( gridId ).resetSelection();
		
	}

	/***********************************************************************************************																
	 * 기능 함수 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	//변경된 Catalog, 설계정보, 구매정보, 생산정보, Item속성, Bom속성 Validation체크한다.
	function fn_checkCatalogValidate( arr1, arr2, arr3, arr4, arr5, arr6, arr7, arr8, arr9, arr10 ) {
		var result = true;
		var message = "";
		var ids = $( "#catalogMain" ).jqGrid( 'getDataIDs' );

		var changeCatalog = getChangedGridInfo( "#catalogMain" );

		for( var i = 0; i < ids.length; i++ ) {
			var oper = $( "#catalogMain" ).jqGrid( 'getCell', ids[i], 'oper' );

			if( oper == 'I' || oper == 'U' ) {
				var val1 = $( "#catalogMain" ).jqGrid( 'getCell', ids[i], 'catalog_code' );
				var val2 = $( "#catalogMain" ).jqGrid( 'getCell', ids[i], 'part_family_code' );
				var val3 = $( "#catalogMain" ).jqGrid( 'getCell', ids[i], 'category_code' );

				if( $.jgrid.isEmpty( val1 ) ) {
					result = false;
					message = "Catalog Code Field is required";
					setErrorFocus( "#catalogMain", ids[i], 0, 'catalog_code' );
					break;
				}

				if( $.jgrid.isEmpty( val2 ) ) {
					result = false;
					message = "Part Family Code Field is required";
					setErrorFocus( "#catalogMain", ids[i], 5, 'part_family_code' );
					break;
				}

				if( $.jgrid.isEmpty( val3 ) ) {
					result = false;
					message = "Category Code Field is required";
					setErrorFocus( "#catalogMain", ids[i], 2, 'category_code' );
					break;
				}
			}
		}

		var sertData = fn_getSelectRowData();

		if( arr1.length > 0 || arr2.length > 0 || arr3.length > 0 || arr4.length > 0 || arr5.length > 0 || arr6.length > 0 || arr7.length > 0 || arr8.length > 0 || arr9.length > 0 || arr10.length > 0 ) {
			if( typeof sertData.catalog_code == 'undefined' || $.jgrid.isEmpty( sertData.catalog_code ) ) {
				result = false;
				message = "Catalog Code is selected";
			}
		} else {
			if( changeCatalog.length == 0 ) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}
		}

		if( arr5.length > 0 || arr6.length > 0 ) {
			if( typeof sertData.attribute_code == 'undefined' || $.jgrid.isEmpty( sertData.attribute_code ) ) {
				result = false;
				message = "Item속성 물성치 is selected";
			}
		}

		if( arr6.length > 0 ) {
			if( typeof sertData.value_code == 'undefined' || $.jgrid.isEmpty( sertData.value_code ) ) {
				result = false;
				message = "Item속성 Value is selected";
			}
		}

		if( arr8.length > 0 || arr9.length > 0 ) {
			if( typeof sertData.bom_attr_code == 'undefined' || $.jgrid.isEmpty( sertData.bom_attr_code ) ) {
				result = false;
				message = "BOM속성 물성치 is selected";
			}
		}

		if( arr9.length > 0 ) {
			if( typeof sertData.bom_val_code == 'undefined' || $.jgrid.isEmpty( sertData.bom_val_code ) ) {
				result = false;
				message = "BOM속성 Value is selected";
			}
		}

		if( result && arr1.length > 0 ) {

			ids = $( "#designInfo" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#designInfo" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#designInfo" ).jqGrid( 'getCell', ids[i], 'd_code' );
					var val2 = $( "#designInfo" ).jqGrid( 'getCell', ids[i], 'd_value' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "설계정보의 항목 is required";
						setErrorFocus( "#designInfo", ids[i], 0, 'd_code' );
						break;
					}

					if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "설계정보의 항목값 is required";
						setErrorFocus( "#designInfo", ids[i], 2, 'd_value' );
						break;
					}
				}
			}
		}

		if( result && arr2.length > 0 ) {
			ids = $( "#purchaseInfo" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#purchaseInfo" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#purchaseInfo" ).jqGrid( 'getCell', ids[i], 'p_code' );
					var val2 = $( "#purchaseInfo" ).jqGrid( 'getCell', ids[i], 'p_value' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "구매정보의 항목 is required";
						setErrorFocus( "#purchaseInfo", ids[i], 0, 'p_code' );
						break;
					}

					if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "구매정보의 항목값 is required";
						setErrorFocus( "#purchaseInfo", ids[i], 2, 'p_value' );
						break;
					}
				}
			}
		}

		if( result && arr3.length > 0 ) {

			ids = $( "#productionInfo" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#productionInfo" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {

					var val1 = $( "#productionInfo" ).jqGrid( 'getCell', ids[i], 't_code' );
					var val2 = $( "#productionInfo" ).jqGrid( 'getCell', ids[i], 't_value' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "생산정보의 항목 is required";
						setErrorFocus( "#productionInfo", ids[i], 0, 't_code' );
						break;
					}

					if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "생산정보의 항목값 is required";
						setErrorFocus( "#productionInfo", ids[i], 2, 't_value' );
						break;
					}
				}
			}
		}

		if( result && arr4.length > 0 ) {
			ids = $( "#itemAttributeBase" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#itemAttributeBase" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#itemAttributeBase" ).jqGrid( 'getCell', ids[i], 'item_attribute_code' );
					var val2 = $( "#itemAttributeBase" ).jqGrid( 'getCell', ids[i], 'item_attribute_name' );
					var val3 = $( "#itemAttributeBase" ).jqGrid( 'getCell', ids[i], 'item_attribute_data_type' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Item속성의 물성치 Field is required";
						setErrorFocus( "#itemAttributeBase", ids[i], 0, 'item_attribute_code' );
						break;
					}
					if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "Item속성의 항목 Field is required";
						setErrorFocus( "#itemAttributeBase", ids[i], 0, 'item_attribute_name' );
						break;
					}
					if( $.jgrid.isEmpty( val3 ) ) {
						result = false;
						message = "Item속성의 DataType Field is required";
						setErrorFocus( "#itemAttributeBase", ids[i], 0, 'item_attribute_data_type' );
						break;
					}
				}
			}
		}

		if( result && arr5.length > 0 ) {
			ids = $( "#itemValue" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#itemValue" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#itemValue" ).jqGrid( 'getCell', ids[i], 'item_value_code' );
					var val2 = $( "#itemValue" ).jqGrid( 'getCell', ids[i], 'item_item_make_value' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Item속성의 Value Field is required";
						setErrorFocus( "#itemValue", ids[i], 0, 'item_value_code' );
						break;
					}
					/* if( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "Item속성의 번호 Field is required";
						setErrorFocus( "#itemValue", ids[i], 0, 'item_item_make_value' );
						break;
					} */
				}
			}
		}

		if( result && arr6.length > 0 ) {
			ids = $( "#topItemValue" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#topItemValue" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#topItemValue" ).jqGrid( 'getCell', ids[i], 'item_assy_value_code' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Item속성의 상위속성 Field is required";
						setErrorFocus( "#topItemValue", ids[i], 0, 'item_assy_value_code' );
						break;
					}
				}
			}
		}

		if( result && arr7.length > 0 ) {

			ids = $( "#bomAttributeBase" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#bomAttributeBase" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {

					var val1 = $( "#bomAttributeBase" ).jqGrid( 'getCell', ids[i], 'bom_attribute_code' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "BOM속성의 물성치 Field is required";
						setErrorFocus( "#bomAttributeBase", ids[i], 0, 'bom_attribute_code' );
						break;
					}
				}
			}
		}

		if( result && arr8.length > 0 ) {

			ids = $( "#bomValue" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#bomValue" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#bomValue" ).jqGrid( 'getCell', ids[i], 'bom_value_code' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "BOM속성의 Value Field is required";
						setErrorFocus( "#bomValue", ids[i], 0, 'bom_value_code' );
						break;
					}
				}
			}
		}

		if( result && arr9.length > 0 ) {
			ids = $( "#topBomValue" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#topBomValue" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					var val1 = $( "#topBomValue" ).jqGrid( 'getCell', ids[i], 'bom_assy_value_code' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "BOM속성의 상위속성 Field is required";
						setErrorFocus( "#topBomValue", ids[i], 0, 'bom_assy_value_code' );
						break;
					}
				}
			}
		}
		
		if( result && arr10.length > 0 ) {

			ids = $( "#catalogLengthInfo" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#catalogLengthInfo" ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {

					var val1 = $( "#catalogLengthInfo" ).jqGrid( 'getCell', ids[i], 'catalog_length' );

					if( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Length is required";
						setErrorFocus( "#catalogLengthInfo", ids[i], 0, 'catalog_length' );
						break;
					}
				}
			}
		}

		if( !result ) {
			alert( message );
		}

		return result;
	}

	//재조회시 삭제된 데이터 지운다.
	function deleteArrayClear( gbn ) {
		//전부 삭제한다.
		if( gbn == "all" ) {
			if( catalogDeleteData.length > 0 ) catalogDeleteData.splice( 0, catalogDeleteData.length );
		}

		if( gbn == "all" || gbn == "catalog" ) {
			if( designDeleteData.length > 0 ) designDeleteData.splice( 0, designDeleteData.length );
			if( purchaseDeleteData.length > 0 ) purchaseDeleteData.splice( 0, purchaseDeleteData.length );
			if( productionDeleteData.length > 0 ) productionDeleteData.splice( 0, productionDeleteData.length );
			if( catalogLengthDeleteData.length > 0 ) catalogLengthDeleteData.splice( 0, catalogLengthDeleteData.length );
			if( itemAttributeDeleteData.length > 0 ) itemAttributeDeleteData.splice( 0, itemAttributeDeleteData.length );
			if( bomAttributeDeleteData.length > 0 ) bomAttributeDeleteData.splice( 0, bomAttributeDeleteData.length );
		}

		if( gbn == "all" || gbn == "catalog" || gbn == "itemAttributeBase" ) {
			if( itemValueDeleteData.length > 0 ) itemValueDeleteData.splice( 0, itemValueDeleteData.length );
		}

		if( gbn == "all" || gbn == "catalog" || gbn == "itemAttributeBase" || gbn == "itemValue" ) {
			if( topItemValueDeleteData.length > 0 ) topItemValueDeleteData.splice( 0, topItemValueDeleteData.length );
		}

		if( gbn == "all" || gbn == "catalog" || gbn == "bomAttributeBase" ) {
			if( bomValueDeleteData.length > 0 ) bomValueDeleteData.splice( 0, bomValueDeleteData.length );
		}

		if( gbn == "all" || gbn == "catalog" || gbn == "bomAttributeBase" || gbn == "bomValue" ) {
			if( topBomValueDeleteData.length > 0 ) topBomValueDeleteData.splice( 0, topBomValueDeleteData.length );
		}
	}

	//Grid데이터 Clrea한다.
	function gridClear() {
		$( "#designInfo" ).clearGridData( true );
		$( "#purchaseInfo" ).clearGridData( true );
		$( "#productionInfo" ).clearGridData( true );
		$( "#itemAttributeBase" ).clearGridData( true );
		$( "#itemValue" ).clearGridData( true );
		$( "#topItemValue" ).clearGridData( true );
		$( "#bomAttributeBase" ).clearGridData( true );
		$( "#bomValue" ).clearGridData( true );
		$( "#topBomValue" ).clearGridData( true );
	}

	//그리드 변경된 내용을 가져온다.
	function getChangedCatalogResultData( callback ) {
		var changedData = $.grep( $( "#catalogMain" ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U';
		} );
		
		callback.apply( this, [ changedData.concat(catalogDeleteData) ] );
	}

	//그리드의 선택된 Row의 내용을 가져온다.
	function fn_getSelectRowData() {

		var ret = $( "#catalogMain" ).getRowData( catalog_row );
		fv_catalog_code = ret.catalog_code;

		ret = $( "#itemAttributeBase" ).getRowData( item_attr_row );
		fv_attribute_code = ret.item_attribute_code;

		ret = $( "#itemValue" ).getRowData( item_value_row );
		fv_value_code = ret.item_value_code;
		fv_item_make_value = ret.item_item_make_value;

		ret = $( "#bomAttributeBase" ).getRowData( bom_attr_row );
		fv_bom_attr_code = ret.bom_attribute_code;

		ret = $( "#bomValue" ).getRowData( bom_value_row );
		fv_bom_val_code = ret.bom_value_code;

		var selectData = {
			catalog_code : fv_catalog_code,
			attribute_code : fv_attribute_code,
			value_code : fv_value_code,
			item_make_value : fv_item_make_value,
			bom_attr_code : fv_bom_attr_code,
			bom_val_code : fv_bom_val_code
		};

		return selectData;
	}

	//그리드 변경된 내용을 가져온다.
	function getChangedGridInfo( gridId ) {
		var changedData = $.grep( $( gridId ).jqGrid( 'getRowData' ), function( obj ) {
			return obj.oper == 'I' || obj.oper == 'U';
		} );

		if( gridId == "#designInfo" ) {
			changedData = changedData.concat( designDeleteData );
		} else if( gridId == "#purchaseInfo" ) {
			changedData = changedData.concat( purchaseDeleteData );
		} else if( gridId == "#productionInfo" ) {
			changedData = changedData.concat( productionDeleteData );
		} else if( gridId == "#catalogLengthInfo" ) {
			changedData = changedData.concat( catalogLengthDeleteData );
		} else if( gridId == "#itemAttributeBase" ) {
			changedData = changedData.concat( itemAttributeDeleteData );
		} else if( gridId == "#itemValue" ) {
			changedData = changedData.concat( itemValueDeleteData );
		} else if( gridId == "#topItemValue" ) {
			changedData = changedData.concat( topItemValueDeleteData );
		} else if( gridId == "#bomAttributeBase" ) {
			changedData = changedData.concat( bomAttributeDeleteData );
		} else if( gridId == "#bomValue" ) {
			changedData = changedData.concat( bomValueDeleteData );
		} else if( gridId == "#topBomValue" ) {
			changedData = changedData.concat( topBomValueDeleteData );
		} else if( gridId == "#catalogMain" ) {
			changedData = changedData.concat( catalogDeleteData );
		}
		
		return changedData;
	}
	function gridDelColorEdit(gridId,selrow) {
		var colModel = $( gridId ).jqGrid( 'getGridParam', 'colModel' );
		for( var i in colModel ) {
			$( gridId ).jqGrid( 'setCell', selrow, colModel[i].name,'', {background : '#FF7E9D' } );
		}
	}
	//대문자 변환
	function cUpper( cObj ) {
		cObj.value = cObj.value.toUpperCase();
	}

	//포커스 이동
	function setErrorFocus( gridId, rowId, colId, colName ) {
		$( "#" + rowId + "_" + colName ).focus();
		$( gridId ).jqGrid( 'editCell', rowId, colId, true );
	}

	//max와min 비교	
	function minMaxCheck( value, colname ) {
		var id = $( "#itemAttributeBase" ).jqGrid( 'getGridParam', 'selrow' );
		var item = $( "#itemAttributeBase" ).jqGrid( 'getRowData', id );

		if( colname == "MIN" ) {
			if( item.item_attribute_data_max != '' && typeof item.item_attribute_data_max != "undefined" && value != '' && typeof value != "undefined" ) {
				if( Number( value ) > Number( item.item_attribute_data_max ) ) {
					return [ false, "Min value can't be < tha Max value" ];
				} else {
					return [ true, "" ];
				}
			} else {
				return [ true, "" ];
			}
		} else if( colname == "MAX" ) {
			if( item.item_attribute_data_min != '' && typeof item.item_attribute_data_min != "undefined" && value != '' && typeof value != "undefined" ) {
				if( Number( value ) < Number( item.item_attribute_data_min ) ) {
					return [ false, "Min value can't be < tha Max value" ];
				} else {
					return [ true, "" ];
				}
			} else {
				return [ true, "" ];
			}
		}
	}

	//max와min 비교
	function minMaxCheck2( value, colname ) {
		var id = $( "#bomAttributeBase" ).jqGrid( 'getGridParam', 'selrow' );
		var item = $( "#bomAttributeBase" ).jqGrid( 'getRowData', id );

		if( colname == "MIN" ) {

			if( item.bom_attribute_data_max != '' && typeof item.bom_attribute_data_max != "undefined" && value != '' && typeof value != "undefined" ) {
				if( Number( value ) > Number( item.bom_attribute_data_max ) ) {
					return [ false, "Min value can't be < tha Max value" ];
				} else {
					return [ true, "" ];
				}
			} else {
				return [ true, "" ];
			}
		} else if( colname == "MAX" ) {
			if( item.bom_attribute_data_min != '' && typeof item.bom_attribute_data_min != "undefined" && value != '' && typeof value != "undefined" ) {
				if( Number( value ) < Number( item.bom_attribute_data_min ) ) {
					return [ false, "Min value can't be < tha Max value" ];
				} else {
					return [ true, "" ];
				}
			} else {
				return [ true, "" ];
			}
		}
	}

	//그리드 대문자 입력한다.
	function setUpperCase( gridId, rowId, colNm ) {
		if( rowId != 0 ) {
			var $grid = $( gridId );
			var sTemp = $grid.jqGrid( "getCell", rowId, colNm );

			$grid.jqGrid( "setCell", rowId, colNm, sTemp.toUpperCase() );
		}
	}

	//input box 대문자 입력
	function onlyUpperCase( obj ) {
		obj.value = obj.value.toUpperCase();
	}

	//그리드 변경중인 cell 데이터 저장
	function fn_applyData( gridId, nRow, nCol ) {
		$( gridId ).saveCell( nRow, nCol );
	}

	function setChmResultWipList() {
		var special_code1 = 'WORK';
		if( attribute5 == 'Y') {
			special_code1 = 'RESULT';
		}

		$( '#catalogMain' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'chm_result_wip',
			data : $.grep( chm_result_wipList, function(obj) {
				return ( obj.special_code1 == special_code1 || obj.special_code1 == 'PLAN' );
			} )
		} );
	}

	function catalogSelected( irow, colId ) {
		//작업범주에 한정시는 아래의 코멘트 해제..
		//setChmResultWipList();
	}

	/***********************************************************************************************																
	 * 서비스 호출하는 부분 입니다. 	
	 *
	 ************************************************************************************************/
	//엑셀다운로드 호출한다.
	function fn_excelUpload() {
		fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
		
		var rowId = $( "#catalogMain" ).jqGrid( 'getGridParam', 'selrow' );
		if( rowId == null ) {
			alert( "Catalog 선택 후 엑셀 업로드 바랍니다!" );
			return;
		}
		if( win != null ) {
			win.close();
		}
		
		win = window.open( "popUpCatalogExcelUpload.do", "listForm", "height=260,width=650,top=200,left=200" );
	}

	/* 
	 catalog Main조회 
	 */
	function fn_search() {
		$( "#catalogMain" ).jqGrid( 'setGridParam', {
			url : "catalogMgntList.do",
			mtype : 'POST',
			page : 1,
			postData : {
				p_catalog_code : $( "input[name=p_catalog_code]" ).val(),
				p_catalog_desc : $( "input[name=p_catalog_desc]" ).val(),
				p_category_code : $( "input[name=p_category_code]" ).val(),
				p_category_desc : $( "input[name=p_category_desc]" ).val()
			}
		} ).trigger( "reloadGrid" );
		
		//array클리어
		deleteArrayClear( "all" );
	}

	/* 
	 catalog Detail조회 
	 */
	function fn_detailSearch() {
		$( "#designInfo" ).jqGrid( 'setGridParam', {
			url : "catalogMgntDesignInfo.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'GET',
			page : 1
		} );
		
		$( "#purchaseInfo" ).jqGrid( 'setGridParam', {
			url : "catalogMgntPurchaseInfo.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'GET',
			page : 1
		} );
		
		$( "#productionInfo" ).jqGrid( 'setGridParam', {
			url : "catalogMgntProductionInfo.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'GET',
			page : 1
		} );
		
		$( "#catalogLengthInfo" ).jqGrid( 'setGridParam', {
			url : "catalogMgntCatalogLengthInfo.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'GET',
			page : 1
		} );
		
		$( "#itemAttributeBase" ).jqGrid( 'setGridParam', {
			url : "catalogMgntItemAttributeBase.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'POST',
			page : 1
		} );
		
		$( "#bomAttributeBase" ).jqGrid( 'setGridParam', {
			url : "catalogMgntBomAttributeBase.do?isPaging=N&catalog_code=" + fv_catalog_code,
			mtype : 'POST',
			page : 1
		} );

		$( "#designInfo" ).trigger( 'reloadGrid' );
		$( "#purchaseInfo" ).trigger( 'reloadGrid' );
		$( "#productionInfo").trigger( 'reloadGrid' );
		$( "#catalogLengthInfo").trigger( 'reloadGrid' );
		$( "#itemAttributeBase" ).trigger( 'reloadGrid' );
		$( "#bomAttributeBase" ).trigger( 'reloadGrid' );

		deleteArrayClear( "catalog" );
	}

	/* 
	 AttributeBase 조회 
	 */
	function fn_searchAttributeBase() {
		$( "#itemValue" ).jqGrid( 'setGridParam', {
			url : "catalogMgntItemValue.do",
			mtype : 'POST',
			page : 1,
			postData : {
				isPaging : 'N',
				catalog_code : fv_catalog_code,
				attribute_code : fv_attribute_code,
				value_code : $( "input[name=p_value_code]" ).val()
			}
		} ).trigger( "reloadGrid" );

		deleteArrayClear( "itemAttributeBase" );
	}


	/* 
	 ItemValue 조회 
	 */
	function fn_searchItemValue() {
		$( "#topItemValue" ).jqGrid( 'setGridParam', {
			url : "catalogMgntTopItemValue.do",
			mtype : 'POST',
			page : 1,
			postData : {
				isPaging : 'N',
				catalog_code : fv_catalog_code,
				attribute_code : fv_attribute_code,
				value_code : fv_value_code,
				item_make_value : fv_item_make_value
			}
		} ).trigger( "reloadGrid" );

		deleteArrayClear( "bomAttributeBase" );
	}

	/* 
	 BomAttributeBase 조회 
	 */
	function fn_searchBomAttributeBase() {
		$( "#bomValue" ).jqGrid( 'setGridParam', {
			url : "catalogMgntBomValue.do",
			mtype : 'POST',
			page : 1,
			postData : {
				isPaging : 'N',
				catalog_code : fv_catalog_code,
				attribute_code : fv_bom_attr_code
			}
		} ).trigger( "reloadGrid" );

		deleteArrayClear( "itemValue" );
	}
	
	/* 
	 BomValue 조회 
	 */
	function fn_searchBomValue() {
		$( "#topBomValue" ).jqGrid( 'setGridParam', {
			url : "catalogMgntTopBomValue.do",
			mtype : 'POST',
			page : 1,
			postData : {
				isPaging : 'N',
				catalog_code : fv_catalog_code,
				attribute_code : fv_bom_attr_code,
				value_code : fv_bom_val_code
			}
		} ).trigger( "reloadGrid" );

		deleteArrayClear( "bomValue" );
	}

	/* 
	 추가 구매 정보 
	 */
	function fn_additionalPurchaseInfo() {

		var url = "additionalPurchaseInfo.do";

		var parameters = {
			gbn : 10,
			catalog_code : fv_catalog_code,
			attribute_code : '',
			value_code : ''
		};

		//트리 컨트롤 데이터 : $는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
		$.post( url, parameters, function( data ) {

			if( data !=null ) {
				$( '#txtPlan').val( data.mrp_planning_desc);
				$( '#txtStandard').val( data.full_lead_time);
				$( '#txtBuyer').val( data.buyer);
			} else {
				$( '#txtPlan' ).val( '' );
				$( '#txtStandard' ).val( '' );
				$( '#txtBuyer' ).val( '' );
			}
		} );
	}

	/* 
	 Category 조회
	 */
	function fn_searchCategory( sCatalog, sPartFamily, nRowId ) {
		
		var url = 'categoryFromPartFamily.do';

		if( sCatalog == "" || sPartFamily == "" ) {

		} else {
			var parameters = {
				catalog_code : sCatalog,
// 				category_code1 : sCatalog.substr( 1, 1 ),
// 				category_code2 : sCatalog.substr( 2, 1 ),
 				part_family_code : sPartFamily
			};

			//트리 컨트롤 데이터 : $는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
			$.post( url, parameters, function( data ) {

				if( data != null) {
					$( '#catalogMain' ).setCell( nRowId, "category_desc", data.category_desc );
					$( '#catalogMain' ).setCell( nRowId, "category_code", data.category_code );
					$( '#catalogMain' ).setCell( nRowId, "category_id", data.category_id );
				} else {
					$( '#catalogMain' ).setCell( nRowId, "category_desc", null );
					$( '#catalogMain' ).setCell( nRowId, "category_code", null );
					$( '#catalogMain' ).setCell( nRowId, "category_id", null );

					if( isPopup == false )
						alert( "해당 되는 카테코리가 없습니다." );
				}
			} );
		}
	}

	//그리드 데이터 저장
	function fn_save() {
		fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
		fn_applyData( "#designInfo", designInfo_row_num, designInfo_col );
		fn_applyData( "#purchaseInfo", purchaseInfo_row_num, purchaseInfo_col );
		fn_applyData( "#productionInfo", productionInfo_row_num, productionInfo_col );
		fn_applyData( "#catalogLengthInfo", catalogLengthInfo_row_num, catalogLengthInfo_col );
		fn_applyData( "#itemAttributeBase", item_attr_row_num, item_attr_col );
		fn_applyData( "#itemValue", item_value_row_num, item_value_col );
		fn_applyData( "#topItemValue", topitem_value_row_num, topitem_value_col );
		fn_applyData( "#bomAttributeBase", bom_attr_row_num, bom_attr_col );
		fn_applyData( "#bomValue", bom_value_row_num, bom_value_col );
		fn_applyData( "#topBomValue", topbom_value_row_num, topbom_value_col );

		var changedData = $( "#catalogMain" ).jqGrid( 'getRowData' );

		lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

		//변경된 체크 박스가 있는지 체크한다.
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#catalogMain' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				
				
				if( item.paint_flag_changed != item.paint_flag ) {
					item.oper = 'U';
				}
				
				if( item.paint_usc_flag_changed != item.paint_usc_flag ) {
					item.oper = 'U';
				}
				
				if( item.enable_flag_changed != item.enable_flag ) {
					item.oper = 'U';
				}
				
				if( item.activity_flag_changed != item.activity_flag ) {
					item.oper = 'U';
				}

				if( item.job_flag_changed != item.job_flag ) {
					item.oper = 'U';
				}

				if( item.wbs_flag_changed != item.wbs_flag ) {
					item.oper = 'U';
				}
				
				if( item.wbs_sub_flag_changed != item.wbs_sub_flag ) {
					item.oper = 'U';
				}

				if( item.pd_flag_changed != item.pd_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#catalogMain' ).jqGrid( "setRowData", i, item );
				}
			}
		}

		changedData = $( "#designInfo" ).jqGrid( 'getRowData' );
		//변경된 체크 박스가 있는지 체크한다.
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#designInfo' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.d_flag_changed != item.d_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#designInfo' ).jqGrid( "setRowData", i, item );
				}
			}
		}

		changedData = $( "#purchaseInfo" ).jqGrid( 'getRowData' );
		//변경된 체크 박스가 있는지 체크한다.
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#purchaseInfo' ).jqGrid('getRowData', i);

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.p_flag_changed != item.p_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#purchaseInfo' ).jqGrid( "setRowData", i, item );
				}
			}
		}

		changedData = $( "#productionInfo" ).jqGrid( 'getRowData' );
		//변경된 체크 박스가 있는지 체크한다.
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#productionInfo' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.t_flag_changed != item.t_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#productionInfo' ).jqGrid( "setRowData", i, item );
				}
			}
		}
		
		changedData = $( "#catalogLengthInfo" ).jqGrid( 'getRowData' );
		//변경된 체크 박스가 있는지 체크한다.
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#catalogLengthInfo' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.enable_flag_changed != item.enable_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#catalogLengthInfo' ).jqGrid( "setRowData", i, item );
				}
			}
		}

		changedData = $( "#topItemValue" ).jqGrid( 'getRowData' );
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#topItemValue' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.item_enable_flag_changed != item.item_enable_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#topItemValue' ).jqGrid( "setRowData", i, item );
				}
			}
		}

		changedData = $( "#topBomValue" ).jqGrid( 'getRowData' );
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#topBomValue' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.bom_enable_flag_changed != item.bom_enable_flag ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#topBomValue' ).jqGrid( "setRowData", i, item );
				}
			}
		}
		
		changedData = $( "#itemAttributeBase" ).jqGrid( 'getRowData' );
		for( var i = 1; i < changedData.length + 1; i++ ) {
			var item = $( '#itemAttributeBase' ).jqGrid( 'getRowData', i );

			if( item.oper != 'I' && item.oper != 'U' ) {
				if( item.item_attribute_required_flag != item.item_attribute_rf_changed ) {
					item.oper = 'U';
				}

				if( item.oper == 'U' ) {
					//apply the data which was entered.
					$( '#itemAttributeBase' ).jqGrid( "setRowData", i, item );
				}
			}
		}
		
		var catalogResultRows = [];
		var designInfoResultRows = getChangedGridInfo( "#designInfo" );
		var purchaseInfoResultRows = getChangedGridInfo( "#purchaseInfo" );
		var productionInfoResultRows = getChangedGridInfo( "#productionInfo" );
		var catalogLengthInfoResultRows = getChangedGridInfo( "#catalogLengthInfo" );

		var itemAttributeBaseResultRows = getChangedGridInfo( "#itemAttributeBase" );
		var itemValueResultRows = getChangedGridInfo( "#itemValue" );
		var topItemValueResultRows = getChangedGridInfo( "#topItemValue" );

		var bomAttributeBaseResultRows = getChangedGridInfo( "#bomAttributeBase" );
		var bomValueResultRows = getChangedGridInfo( "#bomValue" );
		var topBomValueResultRows = getChangedGridInfo( "#topBomValue" );

		if( !fn_checkCatalogValidate( designInfoResultRows, purchaseInfoResultRows, productionInfoResultRows, itemAttributeBaseResultRows, itemValueResultRows, topItemValueResultRows, bomAttributeBaseResultRows, bomValueResultRows, topBomValueResultRows, catalogLengthInfoResultRows ) ) {
			lodingBox.remove();
			return;
		}

		getChangedCatalogResultData( function( data ) {
			catalogResultRows = data;

			var dataList = {
				catalogList : JSON.stringify( catalogResultRows ),
				designInfoList : JSON.stringify( designInfoResultRows ),
				purchaseInfoList : JSON.stringify( purchaseInfoResultRows ),
				productionInfoList : JSON.stringify( productionInfoResultRows ),
				catalogLengthInfoList : JSON.stringify( catalogLengthInfoResultRows ),
				itemAttributeBaseList : JSON.stringify( itemAttributeBaseResultRows ),
				itemValueList : JSON.stringify( itemValueResultRows ),
				topItemValueList : JSON.stringify( topItemValueResultRows ),
				bomAttributeBaseList : JSON.stringify( bomAttributeBaseResultRows ),
				bomValueList : JSON.stringify( bomValueResultRows ),
				topBomValueList : JSON.stringify( topBomValueResultRows )
			};

			var sertData = fn_getSelectRowData();

			var url = 'saveCatalogMgnt.do';
			var formData = fn_getFormData('#');
			var parameters = $.extend( {}, dataList, formData );
			
			parameters = $.extend( {}, parameters, sertData );

			$.post( url, parameters, function( data ) {
				alert(data.resultMsg);
				if ( data.result == 'success' ) {
					fn_search();
				}

			}, 'json' ).error( function() {
				alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
			} ).always( function() {
				lodingBox.remove();
			} );
		} );
	}
	//물성치 조회
	function searchItem( p_tableId, p_sdType,  nCode, nData, nRow, nCol ) {
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;

		//fn_applyData( tableId, nRow, nCol );

		fn_applyData( "#catalogMain", catalog_row_num, catalog_col );
		var ret = $( "#catalogMain" ).getRowData( catalog_row );
		var cmd = "?cmd=infoCategoryBase.do";
		var sd_type = "&sd_type="+p_sdType;
		var catalog_code = "&catalog_code="+ ret.catalog_code;
		var table_id = "&table_id=catalogInfo";
		var sUrl = "popUpCodeInfo.do" + cmd + sd_type + catalog_code + table_id;
		//var sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=" + fv_sd_type + "&catalog_code=" + ret.catalog_code + "&table_id=catalogInfo";

		if( p_sdType == "CATALOG_ATTRIBUTE_CODE" ) {
			sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=" + p_sdType + "&catalog_code=" + ret.catalog_code + "&table_id=" + tableId.substr(1);
		} else if( p_sdType == "CATALOG_DATA_TYPE" ) {
			sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=" + p_sdType;
		}

		var rs = window.showModalDialog( sUrl,
				window,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

		if( rs != null ) {
			$( p_tableId ).setCell( nRow, nCode, rs[0] );
			$( p_tableId ).setCell( nRow, nData, rs[1] );

			var item = $( p_tableId ).jqGrid( 'getRowData', nRow );
			
			if( item.oper != 'I' )
				$( p_tableId ).setCell( nRow, "oper", "U" );
		}
	}

	//상위물성치 조회
	function searchAttrItem( p_tableId, p_sdType,  nCode, nData, nRow, nCol ){
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;

		//fn_applyData( tableId, nRow, nCol );

		var sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=" + p_sdType + "&table_id=item";
		
		if( p_tableId == "#bomAttributeBase" ) {
			sUrl = "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=" + p_sdType + "&table_id=bom";
		}

		var rs = window.showModalDialog( sUrl,
				window,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

		if( rs != null ) {
			$( p_tableId ).setCell( nRow, nCode, rs[0] );

			var item = $( p_tableId ).jqGrid( 'getRowData', nRow );
			
			if( item.oper != 'I' )
				$( p_tableId ).setCell( nRow, "oper", "U" );
		}
	}

	//상위물성치 조회
	function searchHighRankAttr( p_tableId, nCode, nData, nRow, nCol ) {
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;

		//fn_applyData( tableId, nRow, nCol );

		//fn_applyData( "#catalogMain", catalog_row_num, catalog_col );

		//var rs1 = $( "#catalogMain" ).getRowData( catalog_row );
		//var sUrl = "popUpHighRankAttrInfo.do?&catalog_code=" + rs1.catalog_code;
		
		var sUrl = "popUpHighRankAttrInfo.do?&catalog_code=" + fv_catalog_code;
		var rs2;

		if( p_tableId == "#topItemValue" ) {
			//fn_applyData( "#itemAttributeBase", item_attr_row_num, item_attr_col );

			rs2 = $( "#itemAttributeBase" ).getRowData( item_attr_row );
			sUrl = sUrl + "&attribute_type=ITEM&assy_attribute_code=" + rs2.item_assy_attribute_code;
		} else {
			fn_applyData( "#bomAttributeBase", bom_attr_row_num, bom_attr_col );

			rs2 = $( "#bomAttributeBase" ).getRowData( bom_attr_row );
			sUrl = sUrl + "&attribute_type=BOM&assy_attribute_code=" + rs2.bom_assy_attribute_code;
		}

		var rs = window.showModalDialog( sUrl,
				window,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

		if( rs != null ) {
			$( p_tableId ).setCell( nRow, nCode, rs[0] );

			var item = $( p_tableId ).jqGrid( 'getRowData', nRow );
			
			if( item.oper != 'I' )
				$( p_tableId ).setCell( nRow, "oper", "U" );
		}
	}

	//Catalog 조회
	function searchCatalogCode( item, nCode, nData, nRow, nCol ) {
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;

		//fn_applyData( tableId, nRow, nCol );

		//var item = $( tableId ).jqGrid( 'getRowData', searchIndex );
		var args = { p_code_find : item.catalog_code };
		var rs = window.showModalDialog( "popUpCatalogInfo.do",
				args,
				"dialogWidth:400px; dialogHeight:480px; center:on; scroll:off; status:off" );
		
		isPopup = false;

		if( rs != null ) {
			$( "#catalogMain" ).setCell( nRow, nCode, rs[0] );
			$( "#catalogMain" ).setCell( nRow, nData, rs[1] );
			fn_searchCategory( rs[0], item.part_family_code, nRow );
			if( item.oper != 'I')
				$( "#catalogMain" ).setCell( nRow, "oper", "U" );
		}
		
		//if( tableId == '#catalogMain' ) {
			//item = $( tableId ).jqGrid( 'getRowData', nRow );
			//fn_searchCategory( item.catalog_code, item.part_family_code, nRow );
		//}
	}

	//PartFamily 조회
	function searchPartFamilyCode( item, nCode, nData, nRow, nCol ) {
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;

		//fn_applyData( tableId, nRow, nCol );

		//var item = $( tableId ).jqGrid( 'getRowData', nRow );
		var args = { p_code_find : item.part_family_code };
		
		var rs = window.showModalDialog( "popUpPartFamilyInfo.do", 
				args,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
		
		isPopup = false;

		if( rs != null ) {
			$( "#catalogMain" ).setCell( nRow, nCode, rs[0] );
			$( "#catalogMain" ).setCell( nRow, nData, rs[1] );
			fn_searchCategory( item.catalog_code, rs[0], nRow );
			if( item.oper != 'I' )
				$( "#catalogMain" ).setCell( nRow, "oper", "U" );
		}

		//if( tableId == '#catalogMain' ) {
			//item = $( tableId ).jqGrid( 'getRowData', nRow );
			//fn_searchCategory( item.catalog_code, item.part_family_code, searchIndex );
		//}
	}

	//UOM CODE 조회
	function searchUomCode( item, nCode, nData, nRow, nCol ) {
		//searchIndex = $( obj ).closest( 'tr' ).get( 0 ).id;
		//fn_applyData( tableId, nRow, nCol );

		//var item = $( tableId ).jqGrid( 'getRowData', nRow );
		var args = new Array();

		args["p_code_find"] = item.uom_code;

		var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=UOM_CODE",
				args,
				"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off; location:no" );

		if( rs != null ) {
			$( "#catalogMain" ).setCell( nRow, nCode, rs[0] );
			$( "#catalogMain" ).setCell( nRow, nData, rs[1] );

			if( item.oper != 'I' )
				$("#catalogMain").setCell( nRow, "oper", "U" );
		}
	}
	
	//폼데이터를 Json Arry로 직렬화
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