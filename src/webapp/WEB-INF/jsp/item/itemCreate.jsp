<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item Create</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			
		<form name="listForm" id="listForm">
			<input type="hidden" id="loginId" name="loginId" value="${loginUser.user_id}" />
			<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}" />
			<input type="hidden" name="shiptype_flag" id="shiptype_flag"/>
			<input type="hidden" name="weight_flag" id="weight_flag"/>
			<input type="hidden" name="popupChk" id="popupChk" value="${popupChk }" />
			<input type="hidden" name="p_item_code" id="p_item_code" value="${p_item_code }" />
			<input type="hidden" name="p_catalog_code" id="p_catalog_code" value="${p_catalog_code }" />
			<input type="hidden" value="1" id="stepState" name="p_stepstate"/>
			<input type="hidden" value="N" id="backFlag" name="backFlag"/>
			<div class="subtitle">
				Create Item
				<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>

			<div id="top">
			<fieldset style="border:none;width:100%;">
			<legend class="sc_tit mgt10 sc_tit2">채번조건1</legend>
			
			<table class="searchArea conSearch">
				<col width="110">
				<col width="160">
				<%-- <col width="100">
				<col width="160"> --%>
				<col width="100">
				<col width="160">
				<col width="80">
				<col width="160">
				<col width="150">
				<col width="190">
				<col width="*">

				<tr>
				<th>ITEM TYPE</th>
				<td>
				<input type="hidden" name="part_family_code" />
				<input type="text" name="part_family_desc" style="text-transform: uppercase;" onchange="fn_changedPartFamilyDesc(this)"  class="wid80"/>
				<input type="button" value="검색" id="btnPartFamilyType" class="btn_gray2"/>
				</td>
			
				<!-- <th>COST<br/> CATEGORY</th>
				<td>
				<input type="hidden" name="cost_category_id" />
				<input type="hidden" name="cost_category_code" />
				<input type="text" name="cost_category_desc" style="text-transform: uppercase;" onchange="fn_changedCostCategoryDesc(this)" class="wid80" />
				<input type="button" value="검색" id="btnCostCategory" class="btn_gray2"/>
				</td> -->
				
				<th><!-- INV<br/>  -->CATEGORY</th>
				<td>
				<input type="hidden" name="inv_category_id" />
				<input type="hidden" name="inv_category_code" />
				<input type="text" name="inv_category_desc" style="text-transform: uppercase;" onchange="fn_changedInvCategoryDesc(this)" class="wid80"  />
				<input type="button" value="검색" id="btnInvCategory" class="btn_gray2" />
				</td>
				
				<th>CATALOG</th>
				<td>
				<input type="text" name="catalog_code" style="text-transform: uppercase; background-color:#FCFFA6" onchange="fn_changedCatalogCode(this)" />
				<input type="button" value="검색" id="btnCatalog" class="btn_gray2"/>
				</td>
				
				<th>CATALOG<br/> DESCRIPTION</th>
				<td style="border-right:none;">
				<input type="text" name="catalog_desc" style="text-transform: uppercase; width:200px; background-color:rgb(218, 218, 218);" onchange="fn_changedCatalogDesc(this)" readonly />
				<!-- <input type="button" value="검색" id="btnCatalogDesc" class="btn_gray2"/> -->
				</td>
				
				<td style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
						<!-- <input type="button" value="조회" id="btnSearch" class="btn_blue" /> -->
						</c:if>
					</div>
				</td>						
				</tr>
		</table>	
		</fieldset>

				<fieldset style="border:none;margin-top:10px">
					<legend class="sc_tit  sc_tit2" >채번조건2</legend>
					<table class="searchArea">	
						<col width="80"><!--uom-->
						<col width="150">
						<col width="80"><!--ship type-->
						<col width="140">
						<%-- <col width="80">
						<col width="160"> --%>
						<col width="*"><!--버튼-->

						<tr>
						<th>UOM</th>
						<td>
						<input type="hidden" name="unit_of_measure" />
						<input type="text" class="wid120" style="margin-top:1px; text-transform: uppercase; background-color:rgb(218, 218, 218);" name="uom_code" readonly onchange="onlyUpperCase(this)" />
						</td>

						<th>SHIP TYPE</th>
						<td>
						<input type="text" style="width: 60px; text-transform: uppercase;" id="shipType" name="shipType" onchange="onlyUpperCase(this)" />
						<input type="button" value="검색" id="btnShipType" class="btn_gray2" />
						</td>

						<!-- <th>GROUP</th>
						<td>
						<input type="hidden" name="attr00_code" />
						<input type="text" name="attr00_desc" style="width: 100px; text-transform: uppercase;" onchange="onlyUpperCase(this)" />
						<input type="button" value="검색" id="btnGroup" class="btn_gray2"/>
						</td> -->

						<td>
							<div class="button endbox">
								
								<input type="button" class="btn_red2" value="COPY" id="btnCopy" onclick="javascript:copyItemRow('');" style="vertical-align: bottom;"/>
								<input type="button" class="btn_red2" value="+" id="btnAdd" onclick="javascript:addItemRow('');" style="width:28px; font-size:16px; vertical-align: bottom;"/>
								<input type="button" class="btn_red2" value="-" id="btnDel" onclick="javascript:deleteRow();" style="width:28px; font-size:16px; vertical-align: bottom;"/>
								&nbsp;&nbsp;&nbsp;&nbsp;
								
								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" class="btn_blue2" value="BACK" id="btnBack" style="display:none; vertical-align: bottom;"/>
								</c:if>
								
								<c:if test="${userRole.attribute6 == 'Y'}">
									<input type="button" id="btnExcelUpload" value="Excel　△"  class="btn_blue" style="line-height: 23px;" />
								</c:if>
								<c:if test="${userRole.attribute5 == 'Y'}">
									<input type="button" id="btnExcelDownLoad" value="Excel　▽"  class="btn_blue"/>
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" id="btnChaebeon" value="NEXT"   class="btn_blue" style="vertical-align: bottom;"/>
								</c:if>
							</div>
						</td>						
						</tr>
					</table>	
					</fieldset>
				</div>


				<div class="content">
					<table id="itemCreateGrid"></table>
					<div id="pitemCreateGrid"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var change_item_row = 0;
		var change_item_row_num = 0;
		var change_item_col = 0;

		var tableId = "#itemCreateGrid";
		var deleteData = [];
		//var type_code			= "00";
		var searchIndex = 0;
		var lodingBox;
		var win;
		var catalogColumn;
		
		var uniqStyle = {'background':'#FEFF93'};
		var nomalStyle = {'background':'#FFFFFF'};
		var noneStyle = {'background':'#FFFFFF'};
		
		var is_hidden  = true;
		var data_attr;
		
		var backList = '';
		
		$(document).ready( function() {
			
			if($("#popupChk").val() == "Y") {
				
				var parameters = {
					p_item_code : $("#p_item_code").val()
				};
				
				var sUrl = 'itemCloneAction.do'; 
				$.post(sUrl, parameters, function(data) {
					 //alert(data.resultMsg);
				});
				
				$("input[name=catalog_code]").val($("#p_catalog_code").val());
				fn_searchCatalog();
			}
			
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$("#itemCreateGrid").jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : {},
				colNames : [ '상태','ITEM CODE','DESCRIPTION','EXCEL', 'CATALOG', 'Weight', 'Old_Item_Code', 
				             'ATTR00_CODE', 'ATTR00', 'ATTR01_CODE', 'ATTR01', 'ATTR02_CODE', 'ATTR02', 
				             'ATTR03_CODE', 'ATTR03', 'ATTR04_CODE', 'ATTR04', 'ATTR05_CODE', 'ATTR05', 
				             'ATTR06_CODE', 'ATTR06', 'ATTR07_CODE', 'ATTR07', 'ATTR08_CODE', 'ATTR08', 
				             'ATTR09_CODE', 'ATTR09', 'ATTR10_CODE', 'ATTR10', 'ATTR11_CODE', 'ATTR11', 
				             'ATTR12_CODE', 'ATTR12', 'ATTR13_CODE', 'ATTR13', 'ATTR14_CODE', 'ATTR14', 
				             'ATTR15_CODE', 'ATTR15', 
				             '부가속성01', '부가속성02', '부가속성03', 
				             '부가속성04', '부가속성05', '부가속성06', 
				             '부가속성07', '부가속성08', '부가속성09', 
				             '부가속성10', '부가속성11', '부가속성12', 
				             '부가속성13', '부가속성14', '부가속성15', 
				             'Oper', 'rowId','operId',
				             'item_code_error_yn'
				             ],
				colModel : [ 
							{ name : 'msg', index : 'msg', width : 60, sortable : false, hidden:is_hidden,  },
							{ name : 'item_code', index : 'item_code', width : 60, sortable : false, hidden:is_hidden,  },
							{ name : 'item_desc', index : 'item_desc', width : 120, sortable : false, hidden:is_hidden,  },
				             { name : 'excel_upload_flag', index : 'excel_upload_flag', width : 35, sortable : false, hidden:is_hidden  },
				             { name : 'catalog_code', index : 'catalog_code', width : 110, editable : false, sortable : false },
				             { name : 'weight', 	   index : 'weight', 		width : 60,  editrules:{number:true}, editable : true, sortable : false }, 
				             { name : 'old_item_code', index : 'old_item_code', width : 110, editable : true, sortable : false,  hidden : is_hidden }, 
				             { name : 'attr00_code', width : 60, index : 'attr00_code', hidden : is_hidden }, 
				             { name : 'attr00_desc', width : 60, index : 'attr00_desc', hidden : is_hidden }, 
				             { name : 'attr01_code', width : 60, index : 'attr01_code', hidden : is_hidden }, 
				             { name : 'attr01_desc', index : 'attr01_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr01_code', 'attr01_desc', '01'); */} } } ] } }, 
				             { name : 'attr02_code', width : 60, index : 'attr02_code', hidden : is_hidden }, 
				             { name : 'attr02_desc', index : 'attr02_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr02_code', 'attr02_desc', '02'); */} } } ] } }, 
				             { name : 'attr03_code', width : 60, index : 'attr03_code', hidden : is_hidden }, 
				             { name : 'attr03_desc', index : 'attr03_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr03_code', 'attr03_desc', '03'); */} } } ] } }, 
				             { name : 'attr04_code', width : 60, index : 'attr04_code', hidden : is_hidden }, 
				             { name : 'attr04_desc', index : 'attr04_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr04_code', 'attr04_desc', '04'); */} } } ] } }, 
				             { name : 'attr05_code', width : 60, index : 'attr05_code', hidden : is_hidden }, 
				             { name : 'attr05_desc', index : 'attr05_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr05_code', 'attr05_desc', '05'); */} } } ] } }, 
				             { name : 'attr06_code', width : 60, index : 'attr06_code', hidden : is_hidden }, 
				             { name : 'attr06_desc', index : 'attr06_desc', width : 82, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr06_code', 'attr06_desc', '06'); */} } } ] } }, 
				             { name : 'attr07_code', width : 60, index : 'attr07_code', hidden : is_hidden }, 
				             { name : 'attr07_desc', index : 'attr07_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr07_code', 'attr07_desc', '07'); */} } } ] } }, 
				             { name : 'attr08_code', width : 60, index : 'attr08_code', hidden : is_hidden }, 
				             { name : 'attr08_desc', index : 'attr08_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr08_code', 'attr08_desc', '08'); */} } } ] } }, 
				             { name : 'attr09_code', width : 60, index : 'attr09_code', hidden : is_hidden }, 
				             { name : 'attr09_desc', index : 'attr09_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr09_code', 'attr09_desc', '09'); */} } } ] } }, 
				             { name : 'attr10_code', width : 60, index : 'attr10_code', hidden : is_hidden }, 
				             { name : 'attr10_desc', index : 'attr10_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr10_code', 'attr10_desc', '10'); */} } } ] } }, 
				             { name : 'attr11_code', width : 60, index : 'attr11_code', hidden : is_hidden }, 
				             { name : 'attr11_desc', index : 'attr11_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr11_code', 'attr11_desc', '11'); */} } } ] } }, 
				             { name : 'attr12_code', width : 60, index : 'attr12_code', hidden : is_hidden }, 
				             { name : 'attr12_desc', index : 'attr12_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr12_code', 'attr12_desc', '12'); */} } } ] } }, 
				             { name : 'attr13_code', width : 60, index : 'attr13_code', hidden : is_hidden }, 
				             { name : 'attr13_desc', index : 'attr13_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr13_code', 'attr13_desc', '13'); */} } } ] } }, 
				             { name : 'attr14_code', width : 60, index : 'attr14_code', hidden : is_hidden }, 
				             { name : 'attr14_desc', index : 'attr14_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr14_code', 'attr14_desc', '14'); */} } } ] } }, 
				             { name : 'attr15_code', width : 60, index : 'attr15_code', hidden : is_hidden }, 
				             { name : 'attr15_desc', index : 'attr15_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAttribute( this, 'attr15_code', 'attr15_desc', '15'); */} } } ] } }, 
				             { name : 'add_attr01_desc', index : 'add_attr01_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr01_desc', '01'); */} } } ] } }, 
				             { name : 'add_attr02_desc', index : 'add_attr02_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr02_desc', '02'); */} } } ] } }, 
				             { name : 'add_attr03_desc', index : 'add_attr03_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr03_desc', '03'); */} } } ] } }, 
				             { name : 'add_attr04_desc', index : 'add_attr04_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr04_desc', '04'); */} } } ] } }, 
				             { name : 'add_attr05_desc', index : 'add_attr05_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr05_desc', '05'); */} } } ] } }, 
				             { name : 'add_attr06_desc', index : 'add_attr06_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr06_desc', '06'); */} } } ] } }, 
				             { name : 'add_attr07_desc', index : 'add_attr07_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr07_desc', '07'); */} } } ] } }, 
				             { name : 'add_attr08_desc', index : 'add_attr08_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr08_desc', '08'); */} } } ] } }, 
				             { name : 'add_attr09_desc', index : 'add_attr09_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr10_desc', index : 'add_attr10_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr11_desc', index : 'add_attr11_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr12_desc', index : 'add_attr12_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr13_desc', index : 'add_attr13_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr14_desc', index : 'add_attr14_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'add_attr15_desc', index : 'add_attr15_desc', width : 80, editable : true, sortable : false, editoptions : { dataEvents : [ { type : 'keydown', fn : function( e) { var key = e.charCode || e.keyCode; if (key == 13 || key == 9) {/*enter,tab searchItemAddAttribute( this, 'add_attr09_desc', '09'); */} } } ] } },
				             { name : 'oper', 	index : 'oper', width : 80, hidden : is_hidden  }, 
				             { name : 'item_rowid', index : 'item_rowid', hidden : is_hidden }, 
				             { name : 'operId', 	index : 'operId', 	  hidden : is_hidden },
				             { name : 'item_code_error_yn', index : 'item_desc', width : 120, sortable : false, hidden:true  }
				            ],
				gridview 	: true,
				toolbar 	: [ false, "bottom" ],
				viewrecords : true,
				autowidth 	: true,
				//forceFit:true,
				//altRows : false,
				//width	  : 1373,
				height 		: objectHeight,
				rowNum 		: -1,
				pgbuttons 	: false,
				pgtext 		: false,
				pginput 	: false,
				//shrinkToFit : false,
				pager 		: $('#pitemCreateGrid'),
				cellEdit : true,
				cellsubmit : 'clientArray',
				//beforeSaveCell : changeCatalogItemEditEnd,
				beforeEditCell : function( row_id, colId, val, iRow, iCol ) {
					if (row_id != null) {
						change_item_col = iCol;
						change_item_row_num = iRow;

						if (change_item_row != row_id) {
							change_item_row = row_id;
						}
					}
				},
				onCellSelect : function( row_id, colId ) {
					
					if($("#stepState").val() != "2") {
						if (row_id != null) {
							var ret = jQuery("#itemCreateGrid").getRowData(row_id);
							var colModel = $('#itemCreateGrid').jqGrid('getGridParam','colModel');
							
							if (ret.oper == "I") {
								for(var j=0; j<data_attr.length; j++){
									var no = j + 1;
									var attr_desc;
									var attr_code;
									if(no < 16 ) {
										if(no < 10){
											no = '0' + no;
										}
										attr_code = "attr"+no+"_code";
										attr_desc = "attr"+no+"_desc";
									} else {
										no = no - 15;
										if(no < 10){
											no = '0' + no;
										}
										attr_code = "add_attr"+no+"_code";
										attr_desc = "add_attr"+no+"_desc";
									}
									if(data_attr[j] != null && data_attr[j] != ""){
										if(data_attr[j].split("/")[5] =="Y"){	
											if(colModel[colId]['index'] == attr_desc){
												if(j > 14) {
													searchItemAddAttribute( "#itemCreateGrid", attr_desc, no, row_id, j);
												} else {
													searchItemAttribute( "#itemCreateGrid", attr_code, attr_desc, no, row_id, j);	
												}
												
											}
										}
									}
									
								}
							}
	
							if (change_item_row != row_id) {
								change_item_row = row_id;
							}
						}
					}
				},
				loadComplete : function(data){					
					
					//기본 1행 추가
					if($("#popupChk").val() != "Y") {
						
						if($("#stepState").val() != "2" && $("#backFlag").val() == "N") {
							addItemRow('');
						}
					}
					
					var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
					
					if($("#stepState").val() != "2") {
						
						$.each( ids, 
								function(idx, rowId){
									fn_setUniqCellControll(idx);
									$('#itemCreateGrid').jqGrid('setCell', rowId, 'oper', 'I');
								});
						
						var parameters = {
							p_catalog_code : $("input[name=catalog_code]").val()
						};
						$.post("itemAttributeDelete.do", parameters, function(data) {
						});
						
					} else {
						
						$.each( ids, 
								function(idx, rowId){
									$('#itemCreateGrid').jqGrid('setCell', rowId, 'oper', 'I');
								});
						
						var err_style = { color : '#FFFFFF', background : 'red'};

						//필수 필드 배열 세팅
						for ( var i = 0; i < ids.length; i++ ) {
							
							$(this).jqGrid('setRowData',ids[i],false, {  background:'#DADADA' });
							
							var err_msg = $(this).getCell( ids[i], "msg" );
							var err_feild_val = $(this).getCell( ids[i], "item_code_error_yn" );
							
							if(err_feild_val != "N"){
								$(this).setCell (ids[i], "item_code",'', err_style, {title : err_msg});
							} 
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
				imgpath : 'themes/basic/images'
			});


			// ------버튼 이벤트---------------------------------------------------------------------------------------------------------------
						
			//$("#itemCreateGrid").jqGrid('setFrozenColumns');
			//$("#itemCreateGrid").jqGrid('setFrozenColumns');
			
			// 그리드 아래 버튼 설정
			$("#itemCreateGrid").jqGrid('navGrid', "#pitemCreateGrid", {
				search : false,
				edit : false,
				add : false,
				del : false
			});

			// 그리드 삭제하는 함수 설정
			/* $("#itemCreateGrid").navButtonAdd('#pitemCreateGrid', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "",
				cursor : "pointer"
			});

			// 그리드 추가하는 함수 설정
			$("#itemCreateGrid").navButtonAdd('#pitemCreateGrid', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addItemRow,
				position : "first",
				title : "",
				cursor : "pointer"
			}); */
			

			/***********************************************************************************************																
			* 페이지 진입시 이벤트
			************************************************************************************************/
			//기본 1행 추가
			
			
			//기본 필수 입력 값 배경색 변경
// 			$('#itemCreateGrid').jqGrid('setLabel', "catalog_code", "", uniqStyle );
// 			$('#itemCreateGrid').jqGrid('setLabel', "weight", "", uniqStyle );
			
			//grid resize
			fn_gridresize($(window), $("#itemCreateGrid"), 117);

			
			/***********************************************************************************************																
			* 버튼 이벤트 binding
			************************************************************************************************/
			
			// 엑셀 다운로드 버튼 클릭이벤트
			$("#btnExcelDownLoad").click( function() {
				if ($("input[name=catalog_code]").val() == "") {
					alert("Catalog 선택 후 Excel Download 하시기 바랍니다!");
					return;
				}

				fn_excelDownload();
			});
			
			// 엑셀 업로드 버튼 클릭이벤트
			$("#btnExcelUpload").click(function() {
				if ($("input[name=catalog_code]").val() == "") {
					alert("Catalog 선택 후 Excel Upload 하시기 바랍니다!");
					return;
				}

				fn_excelUpload();

			});
			
			// PartFamilyType 버튼 클릭이벤트
			$("#btnPartFamilyType").click(function() {
				fn_searchPartFamilyType();
			});
			
			// CostCategory 버튼 클릭이벤트
			$("#btnCostCategory").click(function() {
				fn_searchCostCategory();
			});
			
			// InvCategory 버튼 클릭이벤트
			$("#btnInvCategory").click(function() {
				fn_searchInvCategory();
			});
			
			// Catalog 버튼 클릭이벤트
			$("#btnCatalog").click(function() {
				fn_searchCatalog();
			});
			
			// Catalog Desc 버튼 클릭이벤트
			$("#btnCatalogDesc").click(function() {
				fn_searchCatalogDesc();
			});
			
			// Catalog Desc 버튼 클릭이벤트
			$("#btnCatalogSearch").click(function() {
				fn_searchCatalog2();
			});

			// ShipType 버큰 클릭 이벤트
			$("#btnShipType").click(function() {
				fn_searchShipType();
			});

			// Group 버튼 클릭 이벤트
			$("#btnGroup").click(function() {
				fn_searchAttr00();
			});
			
			// 조회 버튼 클릭 이벤트
			$("#btnSearch").click(function() {
				//fn_search();
			});
			
			// 채번 버튼 클릭 이벤트
			$("#btnChaebeon").click(function() {
				fn_save();
			});
			
			//Back 기능
			$("#btnBack").click(function(){
				
				var jsonGridData = new Array();
				
				if(confirm('뒤로 돌아가시겠습니까?')){
					
					$("#backFlag").val("Y");
					
					$("#itemCreateGrid").jqGrid( "clearGridData" );
					$('#itemCreateGrid').jqGrid( 'setGridParam', {
						cellEdit : true
					} ).trigger( "reloadGrid" );
					
					for ( var i = 0; i < backList.length; i++ ) {
						
						jsonGridData.push({
							excel_upload_flag : backList[i].excel_upload_flag
				             , catalog_code : backList[i].catalog_code
				             , weight : backList[i].weight
				             , old_item_code : backList[i].old_item_code
				             , attr00_code : backList[i].attr00_code
				             , attr00_desc : backList[i].attr00_desc
				             , attr01_code : backList[i].attr01_code
				             , attr01_desc : backList[i].attr01_desc
				             , attr02_code : backList[i].attr02_code
				             , attr02_desc : backList[i].attr02_desc
				             , attr03_code : backList[i].attr03_code
				             , attr03_desc : backList[i].attr03_desc
				             , attr04_code : backList[i].attr04_code
				             , attr04_desc : backList[i].attr04_desc
				             , attr05_code : backList[i].attr05_code
				             , attr05_desc : backList[i].attr05_desc
				             , attr06_code : backList[i].attr06_code
				             , attr06_desc : backList[i].attr06_desc
				             , attr07_code : backList[i].attr07_code
				             , attr07_desc : backList[i].attr07_desc
				             , attr08_code : backList[i].attr08_code
				             , attr08_desc : backList[i].attr08_desc
				             , attr09_code : backList[i].attr09_code
				             , attr09_desc : backList[i].attr09_desc
				             , attr10_code : backList[i].attr10_code
				             , attr10_desc : backList[i].attr10_desc
				             , attr11_code : backList[i].attr11_code
				             , attr11_desc : backList[i].attr11_desc
				             , attr12_code : backList[i].attr12_code
				             , attr12_desc : backList[i].attr12_desc
				             , attr13_code : backList[i].attr13_code
				             , attr13_desc : backList[i].attr13_desc
				             , attr14_code : backList[i].attr14_code
				             , attr14_desc : backList[i].attr14_desc
				             , attr15_code : backList[i].attr15_code
				             , attr15_desc : backList[i].attr15_desc
				             , add_attr01_desc : backList[i].add_attr01_desc
				             , add_attr02_desc : backList[i].add_attr02_desc
				             , add_attr03_desc : backList[i].add_attr03_desc
				             , add_attr04_desc : backList[i].add_attr04_desc
				             , add_attr05_desc : backList[i].add_attr05_desc
				             , add_attr06_desc : backList[i].add_attr06_desc
				             , add_attr07_desc : backList[i].add_attr07_desc
				             , add_attr08_desc : backList[i].add_attr08_desc
				             , add_attr09_desc : backList[i].add_attr09_desc
				             , add_attr10_desc : backList[i].add_attr10_desc
				             , add_attr11_desc : backList[i].add_attr11_desc
				             , add_attr12_desc : backList[i].add_attr12_desc
				             , add_attr13_desc : backList[i].add_attr13_desc
				             , add_attr14_desc : backList[i].add_attr14_desc
				             , add_attr15_desc : backList[i].add_attr15_desc
				             , oper : backList[i].oper
				             , item_rowid : backList[i].item_rowid
				             , operId : backList[i].operId
				             , item_code_error_yn : backList[i].item_code_error_yn
						});
					
					}	
					$("#stepState").val("1");
					$("#btnChaebeon").attr("value", "NEXT");
					$("#btnBack").hide();
					$('#itemCreateGrid').showCol('catalog_code');
					$('#itemCreateGrid').hideCol('item_code');
					$('#itemCreateGrid').hideCol('item_desc');
					
					$("#btnCopy").removeAttr("disabled");
					$("#btnAdd").removeAttr("disabled");
					$("#btnDel").removeAttr("disabled");
					$("#btnExcelUpload").removeAttr("disabled");
					$("#btnExcelDownLoad").removeAttr("disabled");
					
					var ranId = $.jgrid.randId();
					$("#itemCreateGrid").jqGrid('addRowData', ranId, jsonGridData, 'last' );
					
					
					/* var cm ;
					for(var i=0; i<data_attr.length; i++){
						var no = i + 1;
						if(no < 16 ) {
							// 01~15번 설정
							if(no < 10){
								no = '0' + no;
							}
							// 그리드 컬럼을 취득
							cm = $('#itemCreateGrid').jqGrid('getColProp',"attr"+no+"_desc");
							// 서버에서 취득한 속성값과 [ATTR01~15]이 같다면 CATALOG설정이 되어 있지 않은 속성이므로 해당 컬럼을 숨긴다.
							// DB 취득시에 NODATA의 경우[ATTR01~15]로 설정해야함
							if (data_attr[i] == "ATTR"+no ||data_attr[i] == "undefined" || data_attr[i] == null || data_attr[i] == "") {
								$('#itemCreateGrid').hideCol('attr'+no+'_desc');
								cm.editable = false;
							}  else {
								// 서버취득 속성값이 존재 하는 경우 라벨은 서버에서 취득한 라벨로 변경
								// DATA : 0:속성명/1:필수Flag/2:DATATYPE/3:최소값/4:최대값/5:속성값(N&Y)
								$('#itemCreateGrid').jqGrid('setLabel', "attr"+no+"_desc", data_attr[i].split("/")[0]);
								$('#itemCreateGrid').showCol('attr'+no+'_desc');
								// 속성값이 없는경우는 수기 입력
								if(data_attr[i].split("/")[5] == 'N') {
									cm.editable = true;
								} else {
									cm.editable = false;	
								}
							}	
						} 
						// 부가속성 설정
						else {
							// 01~15번 설정
							no = no - 15;
							if(no < 10){
								no = '0' + no;
							}
							cm = $('#itemCreateGrid').jqGrid('getColProp',"add_attr"+no+"_desc");
							// 서버에서 취득한 속성값과 [부가속성01~15]이 같다면 CATALOG설정이 되어 있지 않은 속성이므로 해당 컬럼을 숨긴다.
							// DB 취득시에 NODATA의 경우[부가속성01~15]로 설정해야함
							 if(data_attr[i] == "부가속성"+no ||data_attr[i] == "undefined" || data_attr[i] == null || data_attr[i] == "") {
									$('#itemCreateGrid').hideCol('add_attr'+no+'_desc');
									cm.editable = false;
							} else {
								// 서버취득 속성값이 존재 하는 경우 라벨은 서버에서 취득한 라벨로 변경
								// DATA : 0:속성명/1:필수Flag/2:DATATYPE/3:최소값/4:최대값/5:속성값(N&Y)
								$('#itemCreateGrid').jqGrid('setLabel', "add_attr"+no+"_desc", data_attr[i].split("/")[0]);
								$('#itemCreateGrid').showCol('add_attr'+no+'_desc');
								// 속성값이 없는경우는 수기 입력
								if(data_attr[i].split("/")[5] == 'N') {
									cm.editable = true;
								} else {
									cm.editable = false;	
								}
							}	
						}
						
						
					} */
					
					var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
					
					$.each( ids, function(idx, rowId){
						fn_setUniqCellControll(idx);
						$('#itemCreateGrid').jqGrid('setCell', rowId, 'oper', 'I');
					});
					
				}//confirm
				
				//검색 시 스크롤 깨짐현상 해결
				$("#itemCreateGrid").closest(".ui-jqgrid-bdiv").scrollLeft(0); 
				fn_gridresize($(window), $("#itemCreateGrid"), 117);
			});
			
		});
		
		/***********************************************************************************************																
		* 이벤트 함수 호출하는 부분 입니다. 	
		*
		************************************************************************************************/
		// catalog가 변경된 경우 호출되는 함수
		function fn_changedCatalogCode(obj) {
			onlyUpperCase(obj);
		
			var firstSCatalog = obj.value.substring(0,1);
			if (obj.value == "" || obj.value == 'undefined') {
				fn_clearParam(1);
			} else {
				fn_searchItemAllCatalog(obj.value);
				
				if (obj.value == "2P0" || obj.value == "2Q0" || firstSCatalog == "V"){
					$( "#btnShipType" ).attr( "disabled", false );
					$('#shipType').attr("disabled",false); 
				} else {
					$( "#btnShipType" ).attr( "disabled", true );
					$('#shipType').attr("disabled",true); 
				}
			}
		}
		
		// 그리드 row가 변경된 경우 호출되는 함수
		function changeCatalogItemEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $('#itemCreateGrid').jqGrid('getRowData', irowId);
			if (item.oper != 'I')
				item.oper = 'U';

			// apply the data which was entered.
			$('#itemCreateGrid').jqGrid("setRowData", irowId, item);
			// turn off editing.
			$("input.editable,select.editable", this).attr("editable", "0");
		}
		
		
		//Del 버튼
		function deleteRow() {
			fn_applyData("#itemCreateGrid", change_item_row_num, change_item_col);

			var selrow = $('#itemCreateGrid').jqGrid('getGridParam', 'selrow');
			var item = $('#itemCreateGrid').jqGrid('getRowData', selrow);

			if (item.oper != 'I') {
				item.oper = 'D';
				//deleteData.push(item);
			}

			$('#itemCreateGrid').jqGrid('delRowData', selrow);
			$('#itemCreateGrid').resetSelection();
		}

		//Add 버튼 
		function addItemRow(item) {
			fn_applyData("#itemCreateGrid", change_item_row_num, change_item_col);
			if($("input[name=catalog_code]").val() == ""){
				alert("CATALOG 선택후 추가 바랍니다.");
				return;
			}
			var item = {'catalog_code' : $("input[name=catalog_code]").val()};
			var colModel = $('#itemCreateGrid').jqGrid('getGridParam', 'colModel');
			
			for ( var i in colModel){
				item[colModel[i].name] = '';
			}
			
			item.oper = 'I';

			var ranId = $.jgrid.randId();
			
			$('#itemCreateGrid').resetSelection();
			$('#itemCreateGrid').jqGrid('addRowData', ranId, item, 'last');
			tableId = '#itemCreateGrid';
			
			var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
			
			//카달로그 셀에 카달로그 코드 입력
			//$('#itemCreateGrid').jqGrid('setCell', ids[0], 'catalog_code', $("input[name=catalog_code]").val());
			$('#itemCreateGrid').jqGrid('setCell', ranId, 'catalog_code', $("input[name=catalog_code]").val());
			
			//필수 입력 필드와 아닌 필드 구분 제한
			//fn_setUniqCellControll(0);
			fn_setUniqCellControllAdd(ranId);
			
			fn_gridresize($(window), $("#itemCreateGrid"), 117);
		}
		
		//Add 버튼 
		function copyItemRow(item) {
			fn_applyData("#itemCreateGrid", change_item_row_num, change_item_col);
			if($("input[name=catalog_code]").val() == ""){
				alert("CATALOG 선택후 추가 바랍니다.");
				return;
			}
			var item = {'catalog_code' : $("input[name=catalog_code]").val()};
			var colModel = $('#itemCreateGrid').jqGrid('getGridParam', 'colModel');
			
			for ( var i in colModel){
				item[colModel[i].name] = '';
			}
			
			item.oper = 'I';
			
			var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
			var cl = ids[ids.length-1];
            var rowData = $('#itemCreateGrid').getRowData(cl);
			
            item.excel_upload_flag = rowData['excel_upload_flag'];
            item.weight = rowData['weight'];
            item.old_item_code = rowData['old_item_code'];
            item.attr00_code = rowData['attr00_code'];
            item.attr00_desc = rowData['attr00_desc'];
            item.attr01_code = rowData['attr01_code'];
            item.attr01_desc = rowData['attr01_desc'];
            item.attr02_code = rowData['attr02_code'];
            item.attr02_desc = rowData['attr02_desc'];
            item.attr03_code = rowData['attr03_code'];
            item.attr03_desc = rowData['attr03_desc'];
            item.attr04_code = rowData['attr04_code'];
            item.attr04_desc = rowData['attr04_desc'];
            item.attr05_code = rowData['attr05_code'];
            item.attr05_desc = rowData['attr05_desc'];
            item.attr06_code = rowData['attr06_code'];
            item.attr06_desc = rowData['attr06_desc'];
            item.attr07_code = rowData['attr07_code'];
            item.attr07_desc = rowData['attr07_desc'];
            item.attr08_code = rowData['attr08_code'];
            item.attr08_desc = rowData['attr08_desc'];
            item.attr09_code = rowData['attr09_code'];
            item.attr09_desc = rowData['attr09_desc'];
            item.attr10_code = rowData['attr10_code'];
            item.attr10_desc = rowData['attr10_desc'];
            item.attr11_code = rowData['attr11_code'];
            item.attr11_desc = rowData['attr11_desc'];
            item.attr12_code = rowData['attr12_code'];
            item.attr12_desc = rowData['attr12_desc'];
            item.attr13_code = rowData['attr13_code'];
            item.attr13_desc = rowData['attr13_desc'];
            item.attr14_code = rowData['attr14_code'];
            item.attr14_desc = rowData['attr14_desc'];
            item.attr15_code = rowData['attr15_code'];
            item.attr15_desc = rowData['attr15_desc'];
            
            item.add_attr01_desc = rowData['add_attr01_desc'];
            item.add_attr02_desc = rowData['add_attr02_desc'];
            item.add_attr03_desc = rowData['add_attr03_desc'];
            item.add_attr04_desc = rowData['add_attr04_desc'];
            item.add_attr05_desc = rowData['add_attr05_desc'];
            item.add_attr06_desc = rowData['add_attr06_desc'];
            item.add_attr07_desc = rowData['add_attr07_desc'];
            item.add_attr08_desc = rowData['add_attr08_desc'];
            item.add_attr09_desc = rowData['add_attr09_desc'];
            item.add_attr10_desc = rowData['add_attr10_desc'];
            item.add_attr11_desc = rowData['add_attr11_desc'];
            item.add_attr12_desc = rowData['add_attr12_desc'];
            item.add_attr13_desc = rowData['add_attr13_desc'];
            item.add_attr14_desc = rowData['add_attr14_desc'];
            item.add_attr15_desc = rowData['add_attr15_desc'];

			var ranId = $.jgrid.randId();
			
			$('#itemCreateGrid').resetSelection();
			$('#itemCreateGrid').jqGrid('addRowData', ranId, item, 'last');
			tableId = '#itemCreateGrid';
            
			//카달로그 셀에 카달로그 코드 입력
			//$('#itemCreateGrid').jqGrid('setCell', ids[0], 'catalog_code', $("input[name=catalog_code]").val());
			$('#itemCreateGrid').jqGrid('setCell', ranId, 'catalog_code', $("input[name=catalog_code]").val());
			
			//필수 입력 필드와 아닌 필드 구분 제한
			//fn_setUniqCellControll(0);
			fn_setUniqCellControllAdd(ranId);
			
			fn_gridresize($(window), $("#itemCreateGrid"), 117);
		}
		
		//필수 입력 필드와 아닌 필드 구분 제한
		function fn_setUniqCellControll(idx){
			var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
			var colNames = $("#itemCreateGrid").jqGrid('getGridParam','colNames')
			
			for ( var i=0; i<colNames.length; i++){
				for(var j=0; j<data_attr.length; j++){
					var no = j + 1;
					var attr_desc;
					if(no < 16 ) {
						if(no < 10){
							no = '0' + no;
						}
						attr_desc = "attr"+no+"_desc";
					} else {
						no = no - 15;
						if(no < 10){
							no = '0' + no;
						}
						attr_desc = "add_attr"+no+"_desc";
					}
					if(data_attr[j] != null && data_attr[j] != ""){
						if(data_attr[j].split("/")[5] =="Y"){	
							if(colNames[i] == data_attr[j].split("/")[0]){
								$( "#itemCreateGrid" ).jqGrid( 'setCell', ids[idx], attr_desc, '', { cursor : 'pointer', background : 'pink' } );
							}
						}	
					}
				}
				
				if(colNames[i].indexOf('ATTR') < 0 && colNames[i] != "EXCEL" && colNames[i].indexOf('부가속성') < 0 ){
					//배경 색 지정 : 필수 입력 필드
					//$('#itemCreateGrid').jqGrid('setCell', ids[idx], i, "", uniqStyle );
					//필수 입력 필드는 수정 가능
					$('#itemCreateGrid').jqGrid('setColProp', ids[idx], i, "", {editable:true} );
				}else{
					//배경 색 지정 : 일반 
					//$('#itemCreateGrid').jqGrid('setCell', ids[idx], i, "", noneStyle );
					//필수 입력 필드는 수정 불가능
					$('#itemCreateGrid').jqGrid('setColProp', ids[idx], i, "", {editable:false} );		
				}
			}
		}
		
		//필수 입력 필드와 아닌 필드 구분 제한
		function fn_setUniqCellControllAdd(ranId){
			var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
			var colNames = $("#itemCreateGrid").jqGrid('getGridParam','colNames')
			
			for ( var i=0; i<colNames.length; i++){
				for(var j=0; j<data_attr.length; j++){
					var no = j + 1;
					var attr_desc;
					if(no < 16 ) {
						if(no < 10){
							no = '0' + no;
						}
						attr_desc = "attr"+no+"_desc";
					} else {
						no = no - 15;
						if(no < 10){
							no = '0' + no;
						}
						attr_desc = "add_attr"+no+"_desc";
					}
					if(data_attr[j] != null && data_attr[j] != ""){
						if(data_attr[j].split("/")[5] =="Y"){	
							if(colNames[i] == data_attr[j].split("/")[0]){
								$( "#itemCreateGrid" ).jqGrid( 'setCell', ranId, attr_desc, '', { cursor : 'pointer', background : 'pink' } );
							}
						}	
					}
				}
				
				if(colNames[i].indexOf('ATTR') < 0 && colNames[i] != "EXCEL" && colNames[i].indexOf('부가속성') < 0 ){
					//배경 색 지정 : 필수 입력 필드
					//$('#itemCreateGrid').jqGrid('setCell', ids[idx], i, "", uniqStyle );
					//필수 입력 필드는 수정 가능
					$('#itemCreateGrid').jqGrid('setColProp', ranId, i, "", {editable:true} );
				}else{
					//배경 색 지정 : 일반 
					//$('#itemCreateGrid').jqGrid('setCell', ids[idx], i, "", noneStyle );
					//필수 입력 필드는 수정 불가능
					$('#itemCreateGrid').jqGrid('setColProp', ranId, i, "", {editable:false} );		
				}
			}
		}
		
		// catalog Desc가 변경된 경우 출되는 함수
		function fn_changedCatalogDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(2);
			//}
		}
		
		// Inv Category가 변경된 경우 출되는 함수
		function fn_changedInvCategoryDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(3);
			//}
		}
		
		// Cost Category가 변경된 경우 출되는 함수
		function fn_changedCostCategoryDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(4);
			//}
		}
		
		// partFamily Desc가 변경된 경우 출되는 함수
		function fn_changedPartFamilyDesc(obj) {
			//if (newValue == "" || newValue == 'undefined') {
			onlyUpperCase(obj);
			fn_clearParam(5);
			//}
		}
		/***********************************************************************************************																
		* 기능 함수 호출하는 부분 입니다. 	
		*
		************************************************************************************************/
		// 조회조건이 변경된 경우 초기화하는 함수
		function fn_clearParam(nGbn) {
			if (nGbn > 0) {
				$("input[name=catalog_desc]").val("");
			}

			if (nGbn > 1) {
				$("input[name=catalog_code]").val("");
			}

			if (nGbn > 2) {
				$("input[name=inv_category_id]").val("");
				$("input[name=inv_category_code]").val("");
			}

			if (nGbn > 3) {
				$("input[name=inv_category_desc]").val("");

				$("input[name=cost_category_id]").val("");
				$("input[name=cost_category_code]").val("");

			}

			if (nGbn > 4) {
				$("input[name=cost_category_desc]").val("");
				$("input[name=part_family_code]").val("");
				//$("input[name=part_family_desc]").val("");
			}
			
			if (nGbn > 5) {
				$("input[name=part_family_desc]").val("");
			}
			
			$("input[name=unit_of_measure]").val("");
			$("input[name=uom_code]").val("");
		}
		
		// 그리드 헤드컬럼값 초기화하는 함수
		function fn_clearGridHead() {
			$('#itemCreateGrid').jqGrid('setLabel', "attr01_desc", "ATTR01");
			$('#itemCreateGrid').jqGrid('setLabel', "attr02_desc", "ATTR02");
			$('#itemCreateGrid').jqGrid('setLabel', "attr03_desc", "ATTR03");
			$('#itemCreateGrid').jqGrid('setLabel', "attr04_desc", "ATTR04");
			$('#itemCreateGrid').jqGrid('setLabel', "attr05_desc", "ATTR05");
			$('#itemCreateGrid').jqGrid('setLabel', "attr06_desc", "ATTR06");
			$('#itemCreateGrid').jqGrid('setLabel', "attr07_desc", "ATTR07");
			$('#itemCreateGrid').jqGrid('setLabel', "attr08_desc", "ATTR08");
			$('#itemCreateGrid').jqGrid('setLabel', "attr09_desc", "ATTR09");
			$('#itemCreateGrid').jqGrid('setLabel', "attr10_desc", "ATTR10");
			$('#itemCreateGrid').jqGrid('setLabel', "attr11_desc", "ATTR11");
			$('#itemCreateGrid').jqGrid('setLabel', "attr12_desc", "ATTR12");
			$('#itemCreateGrid').jqGrid('setLabel', "attr13_desc", "ATTR13");
			$('#itemCreateGrid').jqGrid('setLabel', "attr14_desc", "ATTR14");
			$('#itemCreateGrid').jqGrid('setLabel', "attr15_desc", "ATTR15");

			$('#itemCreateGrid').jqGrid('setLabel', "add_attr01_desc", "부가속성01");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr02_desc", "부가속성02");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr03_desc", "부가속성03");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr04_desc", "부가속성04");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr05_desc", "부가속성05");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr06_desc", "부가속성06");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr07_desc", "부가속성07");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr08_desc", "부가속성08");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr09_desc", "부가속성09");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr10_desc", "부가속성10");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr11_desc", "부가속성11");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr12_desc", "부가속성12");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr13_desc", "부가속성13");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr14_desc", "부가속성14");
			$('#itemCreateGrid').jqGrid('setLabel', "add_attr15_desc", "부가속성15");
		}
		
		//폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}
				
		// 그리드 변경된 내용 가져오는 함수
		function getChangedItemCreateResultData(callback) {
			var changedData = $.grep($("#itemCreateGrid").jqGrid('getRowData'), function(obj) { return obj.oper == 'I' || obj.oper == 'U' || obj.excel_upload_flag == 'Y'; });

			callback.apply(this, [ changedData.concat(deleteData) ]);
		}
		
		// 그리드의 변경중인  cell 저장		
		function fn_applyData(gridId, nRow, nCol) {
			$(gridId).saveCell(nRow, nCol);
		}
		
		// 대문자로 변환
		function onlyUpperCase(obj) {
			obj.value = obj.value.toUpperCase();
		}
		
		/***********************************************************************************************																
		* 서비스 호출하는 부분 입니다. 	
		*
		************************************************************************************************/

		// Part Family Type 조회
		function fn_searchPartFamilyType() {

			var rs = window
					.showModalDialog(
							"popUpPartFamilyDesc.do",
							"",
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {

				if ($("input[name=part_family_code]").val() != rs[0])
					fn_clearParam(5);

				$("input[name=part_family_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=part_family_desc]").val(rs[1] == "" ? null : rs[1]);
			}
		}

		// Cost Categroy Type 조회
		function fn_searchCostCategory() {

			var args = new Array();
			args["part_family_code"] = $("input[name=part_family_code]").val();

			var rs = window
					.showModalDialog(
							"popUpCostCategory.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=cost_category_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=cost_category_desc]").val(rs[1] == "" ? null : rs[1]);
				$("input[name=cost_category_id]").val(rs[2] == "" ? null : rs[2]);
			}
		}

		// Inv Categroy Type 조회
		function fn_searchInvCategory() {

			var args = new Array();
			args["part_family_code"] = $("input[name=part_family_code]").val();
			args["cost_category_code"] = $("input[name=cost_category_code]")
					.val();

			var rs = window
					.showModalDialog(
							"popUpInvCategory.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				
				$("input[name=inv_category_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=inv_category_desc]").val(rs[1] == "" ? null : rs[1]);
				$("input[name=inv_category_id]").val(rs[2] == "" ? null : rs[2]);

				var parameters = {
					category_id : $("input[name=inv_category_id]").val()
				};
				var url = 'selectCostCategoryFromInvCategory.do';

				//트리 컨트롤 데이터 : Jquery는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
				$.post(url, parameters, function(data) {

					var obj = jQuery.parseJSON(data);

					if (obj.length > 0) {
						$("input[name=cost_category_code]").val(obj[0].cost_category_code);
						$("input[name=cost_category_desc]").val(obj[0].cost_category_desc);
						$("input[name=cost_category_id]").val(obj[0].cost_category_id);
					} else {
						$("input[name=cost_category_code]").val("");
						$("input[name=cost_category_desc]").val("");
						$("input[name=cost_category_id]").val("");
					}
				});
			}
		}

		// ship type 조회
		function fn_searchShipType() {
			var rs = window.showModalDialog( "popUpModelShipType.do?p_ship_category2=MASTER_DATA",
					window,
					"dialogWidth:500px; dialogHeight:400px; center:on; scroll:off; status:off" );
			
			if ( rs != null ) {
				$( "#shipType").val(rs[0]);
			}
			
			/* var args = new Array();
			var rs = window
					.showModalDialog(
							"popUpShipType.do",
							args,
							"dialogWidth:500px; dialogHeight:360px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=shipType]").val(rs[0] == "" ? null : rs[0]);
			} */
		}

		// catalog 조회
		function fn_searchCatalog() {
			
 			var args = new Array();
// 			args["part_family_code"] = $("input[name=part_family_code]").val();
// 			args["cost_category_code"] = $("input[name=cost_category_code]").val();
// 			args["inv_category_id"] = $("input[name=inv_category_id]").val();

			var args = { p_code_find : $( "input[name=catalog_code]" ).val() ,
						inv_category_id : $("input[name=inv_category_id]").val(),
						inv_category_desc : $("input[name=inv_category_desc]").val(),
						part_family_code : $("input[name=part_family_code]").val(),
						part_family_desc : $("input[name=part_family_desc]").val()
					   };
			
			var rs = window
					.showModalDialog(
							"popUpCatalogInfo.do",
							args,
							"dialogWidth:600px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=catalog_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=catalog_desc]").val(rs[1] == "" ? null : rs[1]);

				fn_searchItemAllCatalog(rs[0]);
				
				
			}
		}
		
		// catalog desc 조회
		function fn_searchCatalog2() {

			var args = new Array();
			args["catalog_desc"] = $("input[name=catalog_desc]").val();

			var rs = window
					.showModalDialog(
							"popUpCatalogCodeDesc.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=catalog_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=catalog_desc]").val(rs[1] == "" ? null : rs[1]);

				fn_searchItemAllCatalog(rs[0]);
			}
		}
		
		// attr00 조회 팝업창 띄운다
		function fn_searchAttr00() {

			var selrow = $('#itemCreateGrid').jqGrid('getGridParam', 'selrow');
			var args = {
				catalog_code : $("input[name=catalog_code]").val(),
				type_code : '00'
			};

			var colModel = $('#itemCreateGrid').jqGrid('getGridParam',
					'colModel');

			for ( var i in colModel) {
				args[colModel[i].name] = $('#itemCreateGrid').getCell(selrow,colModel[i].name);
			}

			args["attr00_desc"] = $("input[name=attr00_desc]").val();

			var rs = window
					.showModalDialog(
							"popUpItemAttribute.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=attr00_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=attr00_desc]").val(rs[1] == "" ? null : rs[1]);
			}
		}
		
		// catalog Desc 조회하는 팝업창을 띄운다
		function fn_searchCatalogDesc() {
			var args = new Array();
			args["part_family_code"] = $("input[name=part_family_code]").val();
			args["cost_category_code"] = $("input[name=cost_category_code]").val();
			args["inv_category_id"] = $("input[name=inv_category_id]").val();

			var rs = window
					.showModalDialog(
							"popUpCatalogDesc.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$("input[name=catalog_code]").val(rs[0] == "" ? null : rs[0]);
				$("input[name=catalog_desc]").val(rs[1] == "" ? null : rs[1]);

				fn_searchItemAllCatalog(rs[0]);
			}
		}
		
		// attr01~15 선택가능한 Code를 조회하는 팝업창을 띄운다
		function searchItemAttribute(obj, sCode, sDesc, sTypeCode, row_id, selectNo) {

			var searchIndex = row_id;
			fn_applyData("#itemCreateGrid", change_item_row_num,
					change_item_col);

			var args = {
				catalog_code : $("input[name=catalog_code]").val(),
				type_code : sTypeCode
			};

			var colModel = $('#itemCreateGrid').jqGrid('getGridParam','colModel');
			for ( var i in colModel) {
				args[colModel[i].name] = $('#itemCreateGrid').getCell(searchIndex, colModel[i].name);
				if ("attr" + sTypeCode + "_desc" == colModel[i].name) {
					args["value_code"] = $('#itemCreateGrid').getCell(searchIndex, colModel[i].name);
				}
			}

			var rs = window.showModalDialog(
							"popUpItemAttribute.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				$('#itemCreateGrid').setCell(searchIndex, sCode, rs[0]);
				$('#itemCreateGrid').setCell(searchIndex, sDesc, rs[1]);
			} else {
				$('#itemCreateGrid').setCell(searchIndex, sCode, null);
				$('#itemCreateGrid').setCell(searchIndex, sDesc, null);
			}
			
			
			var parameters = {
				p_catalog_code : $("input[name=catalog_code]").val(),
				p_attribute_code : sTypeCode
			};
			var url = 'itemAttributeCheck.do';
			var arrayAttr = '';
			
			var attrArray = new Array();
			$.post(url, parameters, function(data) {
				if (data != null && data != "") {
					attrArray = data.split(",");
					
					for(i=0; i<attrArray.length-1; i++) {
						$('#itemCreateGrid').setCell(searchIndex, "attr"+attrArray[i]+"_code", null);
						$('#itemCreateGrid').setCell(searchIndex, "attr"+attrArray[i]+"_desc", null);
					}
				} 
				
			});
			
			
			
			// 종속설정을 고려하여 입력된 필드의 후행값은 삭제한다.
			/* for(var j=selectNo+1; j<data_attr.length; j++){
				var no = j + 1;
				var attr_desc;
				var attr_code;
				if(no < 16 ) {
					if(no < 10){
						no = '0' + no;
					}
					attr_code = "attr"+no+"_code";
					attr_desc = "attr"+no+"_desc";
				} else {
					break;
				}
				$('#itemCreateGrid').setCell(searchIndex, attr_code, null);
				$('#itemCreateGrid').setCell(searchIndex, attr_desc, null);
			} */
		}
		
		// 아이쳄 부가 속성 attr10~15 선택가능한 Code를 조회하는 팝업창을 띄운다
		function searchItemAddAttribute(obj, sDesc, sTypeCode, row_id, selectNo) {

			var args = {
				catalog_code : $("input[name=catalog_code]").val(),
				type_code : sTypeCode,
				value_code : $("#itemCreateGrid").getCell(row_id,"add_attr" + sTypeCode + "_desc")
			};

			var rs = window
					.showModalDialog(
							"popUpItemAddAttribute.do",
							args,
							"dialogWidth:500px; dialogHeight:480px; center:on; scroll:off; status:off; location:no");

			if (rs != null) {
				//$('#itemCreateGrid').setCell(searchIndex,sCode,rs[0]);
				$('#itemCreateGrid').setCell(row_id, sDesc, rs[1]);
			}
		}
		
		// catalog에 연관된 partFamily, category, uom등을 조회한다.
		function fn_searchItemAllCatalog(sCatalog) {
			
			var firstSCatalog = sCatalog.substring(0,1);
			
			if (sCatalog == "2P0" || sCatalog == "2Q0" || firstSCatalog == "V"){
				$( "#btnShipType" ).attr( "disabled", false );
				$('#shipType').attr("disabled",false); 
			} else {
				$( "#btnShipType" ).attr( "disabled", true );
				$('#shipType').attr("disabled",true); 
			}
			
			var parameters = {
				catalog_code : sCatalog
			};
			var url = 'itemAllCatalog.do';

			//트리 컨트롤 데이터 : Jquery는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
			$.post(url, parameters, function(data) {
				
				if (data != null && data != "") {
					
					var str = ["1","2","3","4","T","R","E","A","Z","V"];
					//var strCata = ["VA1","VX1","VMA","VMB","VMC","VMD","VME","VM4","VS1","VS2","VS3","VI2","VT3"];
					
					if(str.indexOf(firstSCatalog) > -1 ) { //|| strCata.indexOf(sCatalog) > -1
						
						if(firstSCatalog == "T") {
							alert("T 기자재 CODE는 EMS에서만 생성 가능합니다.");
							return false;
						} else {
							$("input[name=inv_category_id]").val(data.inv_category_id);
							$("input[name=inv_category_code]").val(data.inv_category_code);
							$("input[name=inv_category_desc]").val(data.inv_category_desc);

							$("input[name=cost_category_id]").val(data.cost_category_id);
							$("input[name=cost_category_code]").val(data.cost_category_code);
							$("input[name=cost_category_desc]").val(data.cost_category_desc);

							$("input[name=part_family_code]").val(data.part_family_code);
							$("input[name=part_family_desc]").val(data.part_family_desc);

							$("input[name=uom_code]").val(data.uom_code);
							$("input[name=unit_of_measure]").val(data.unit_of_measure);
							$("input[name=catalog_desc]").val(data.catalog_desc);
							
							$("#weight_flag").val(data.weight_flag);
							$("#shiptype_flag").val(data.shiptype_flag);
							
							fn_searchItemCatalogAttribute(sCatalog);
						}
						
					} else {
						alert("(1,2,3,4,R,E,A,Z,V)로 시작하는 Code만 생성 가능합니다.");
						return false;
					}
					
				} else {
					
					alert("Catalog가 존재하지 않습니다.");
					fn_clearParam(6);
				}
				
			});
			
			
		}
		
		// catalog에 해당하는 아이템 속성값을 조회해서 Grid에 설정한다.
		function fn_searchItemCatalogAttribute(sCatalog) {
			var parameters = {
				catalog_code : sCatalog
			};
			var url = 'itemCatalogAttribute.do';
			
			var ids = $('#itemCreateGrid').jqGrid('getDataIDs');
			
			//트리 컨트롤 데이터 : Jquery는 비동기로 처리되어 데이터 조회 루틴에서  데이터 바인딩
			$.post(url, parameters, function(data) {
				
				var cm ;
				
				catalogColumn = data;				
						
				if (true) {
					// CATALOG 속성 15, 부가속성 15
					data_attr = new Array(data.attr01, data.attr02, data.attr03, data.attr04, data.attr05
							                , data.attr06, data.attr07, data.attr08, data.attr09, data.attr10
							                , data.attr11, data.attr12, data.attr13, data.attr14, data.attr15
							                , data.add_attr01, data.add_attr02, data.add_attr03, data.add_attr04
							                , data.add_attr05, data.add_attr06, data.add_attr07, data.add_attr08
							                , data.add_attr09, data.add_attr10, data.add_attr11, data.add_attr12
							                , data.add_attr13, data.add_attr14, data.add_attr15);
					//$('#itemCreateGrid').jqGrid('setLabel', "attr10_desc", "", {hidden:true});
					
					
					for(var i=0; i<data_attr.length; i++){
						var no = i + 1;
						if(no < 16 ) {
							// 01~15번 설정
							if(no < 10){
								no = '0' + no;
							}
							// 그리드 컬럼을 취득
							cm = $('#itemCreateGrid').jqGrid('getColProp',"attr"+no+"_desc");
							// 서버에서 취득한 속성값과 [ATTR01~15]이 같다면 CATALOG설정이 되어 있지 않은 속성이므로 해당 컬럼을 숨긴다.
							// DB 취득시에 NODATA의 경우[ATTR01~15]로 설정해야함
							if (data_attr[i] == "ATTR"+no ||data_attr[i] == "undefined" || data_attr[i] == null || data_attr[i] == "") {
								$('#itemCreateGrid').hideCol('attr'+no+'_desc');
								cm.editable = false;
							}  else {
								// 서버취득 속성값이 존재 하는 경우 라벨은 서버에서 취득한 라벨로 변경
								// DATA : 0:속성명/1:필수Flag/2:DATATYPE/3:최소값/4:최대값/5:속성값(N&Y)
								$('#itemCreateGrid').jqGrid('setLabel', "attr"+no+"_desc", data_attr[i].split("/")[0]);
								$('#itemCreateGrid').showCol('attr'+no+'_desc');
								// 속성값이 없는경우는 수기 입력
								if(data_attr[i].split("/")[5] == 'N') {
									cm.editable = true;
								} else {
									cm.editable = false;	
								}
							}	
						} 
						// 부가속성 설정
						else {
							// 01~15번 설정
							no = no - 15;
							if(no < 10){
								no = '0' + no;
							}
							cm = $('#itemCreateGrid').jqGrid('getColProp',"add_attr"+no+"_desc");
							// 서버에서 취득한 속성값과 [부가속성01~15]이 같다면 CATALOG설정이 되어 있지 않은 속성이므로 해당 컬럼을 숨긴다.
							// DB 취득시에 NODATA의 경우[부가속성01~15]로 설정해야함
							 if(data_attr[i] == "부가속성"+no ||data_attr[i] == "undefined" || data_attr[i] == null || data_attr[i] == "") {
									$('#itemCreateGrid').hideCol('add_attr'+no+'_desc');
									cm.editable = false;
							} else {
								// 서버취득 속성값이 존재 하는 경우 라벨은 서버에서 취득한 라벨로 변경
								// DATA : 0:속성명/1:필수Flag/2:DATATYPE/3:최소값/4:최대값/5:속성값(N&Y)
								$('#itemCreateGrid').jqGrid('setLabel', "add_attr"+no+"_desc", data_attr[i].split("/")[0]);
								$('#itemCreateGrid').showCol('add_attr'+no+'_desc');
								// 속성값이 없는경우는 수기 입력
								if(data_attr[i].split("/")[5] == 'N') {
									cm.editable = true;
								} else {
									cm.editable = false;	
								}
							}	
						}
						
						
					}
					fn_search();
					
				} else {
					fn_clearGridHead();
				}
			});
		}
		
		// catalog에 해당하는 미 채번으로 저장된 내용만 조회한다.
		function fn_search() {
			if($("input[name=catalog_code]").val() == ""){
				alert("CATALOG를 입력하십시오.");
				return false;
			}
			
			$("#itemCreateGrid").jqGrid('setGridParam', {
				mtype : 'POST',
				url : "itemCreateTempList.do",
				page : 1,
				postData : $("#listForm").serialize()
			}).trigger("reloadGrid");
			
			addItemRow('');
		}

		/* 
		 그리드 데이터 저장
		 */
		function fn_save() {
			
			var checkValidation = false;
			
			fn_applyData("#itemCreateGrid", change_item_row_num,change_item_col);

			var changeItemCreateResultRows = [];

			// ERROR표시를 위한 ROWID 저장
			var ids = $("#itemCreateGrid").jqGrid('getDataIDs');
			for ( var j = 0; j < ids.length; j++) {
				$('#itemCreateGrid').setCell(ids[j], 'operId', ids[j]);
			}

			getChangedItemCreateResultData(function(data) {
				changeItemCreateResultRows = data;

				if (changeItemCreateResultRows.length == 0) {
					alert("변경된 내용이 없습니다.");
					checkValidation = true;
					return;
				}
				
				var colNames = $("#itemCreateGrid").jqGrid('getGridParam','colNames');
				
				
				for(var i=0; i < changeItemCreateResultRows.length; i++){
					if($("#weight_flag").val() == "Y"){
						if(changeItemCreateResultRows[i].weight == 0 || changeItemCreateResultRows[i].weight == ""){
							alert("Weight는 0이나 공백일 수 없습니다.");
							checkValidation = true;
						}
					}
					for(var j=0; j<data_attr.length; j++){
						var no = j + 1;
						var attr_desc;
						// 속성 01~15
						if(no < 16 ) {
							if(no < 10){
								no = '0' + no;
							}
							attr_desc = "attr"+no+"_desc";
						}
						// 부가속성 01~15
						else {
							no = no - 15;
							if(no < 10){
								no = '0' + no;
							}
							attr_desc = "add_attr"+no+"_desc";
						}
						
						if(data_attr[j] != null && data_attr[j] != ""){
							// DATA : 0:속성명/1:필수Flag/2:DATATYPE/3:최소값/4:최대값/5:속성값(N&Y)
							// 필수체크
							if(data_attr[j].split("/")[1] =="Y"){			
								if(changeItemCreateResultRows[i][attr_desc] == ""){
									alert("["+data_attr[j].split("/")[0]+"]는 필수 입력 입니다.");
									checkValidation = true;
									return;
								}
							}
							if(changeItemCreateResultRows[i][attr_desc] != ""){
								
								if(!fnChkByte(changeItemCreateResultRows[i][attr_desc], 30)) {
									checkValidation = true;
									return;
								}
								
								// 최소값 체크
								if(data_attr[j].split("/")[2] =="S" || data_attr[j].split("/")[2] =="SS"){
									if(data_attr[j].split("/")[3] !=""){
										// 최소자리수 체크
										if(!eval(data_attr[j].split("/")[3] <= changeItemCreateResultRows[i][attr_desc].length)){
											alert("["+data_attr[j].split("/")[0]+"] 는 "+data_attr[j].split("/")[3]+" 자릿수 이상 입력 제약입니다.");
											checkValidation = true;
											return;
										}
									}
									if(data_attr[j].split("/")[4] !=""){
										// 최대자리수 체크
										if(!eval(data_attr[j].split("/")[4] >= changeItemCreateResultRows[i][attr_desc].length)){
											alert("["+data_attr[j].split("/")[0]+"] 는 "+data_attr[j].split("/")[4]+" 자릿수 이하 입력 제약입니다.");
											checkValidation = true;
											return;
										}
										
									}
									
								}
								if(data_attr[j].split("/")[2] =="N" || data_attr[j].split("/")[2] =="NS"){
									// 숫자체크
									if(isNaN(changeItemCreateResultRows[i][attr_desc])){
										alert("["+data_attr[j].split("/")[0]+"] 는 숫자 입력 제약입니다.");
										checkValidation = true;
										return;
									}
									// 최소값 체크
									if(data_attr[j].split("/")[3] !=""){
										if(!eval(data_attr[j].split("/")[3] <= parseInt(changeItemCreateResultRows[i][attr_desc]))){
											alert("["+data_attr[j].split("/")[0]+"] 는 "+data_attr[j].split("/")[3]+" 이상 숫자 입력 제약입니다.");
											checkValidation = true;
											return;
										}
									}
									// 최대값 체크
									if(data_attr[j].split("/")[4] !=""){
										if(!eval(data_attr[j].split("/")[4] >= parseInt(changeItemCreateResultRows[i][attr_desc]))){
											alert("["+data_attr[j].split("/")[0]+"] 는 "+data_attr[j].split("/")[4]+" 이하 숫자 입력 제약입니다.");
											checkValidation = true;
											return;
										}
										
									}
									
								}
							}
						}
					}
				}	
				
				if($("#shiptype_flag").val() == "Y"){
					if($("#shipType").val() == ""){
						alert("["+$("input[name=catalog_code]").val()+"] 의 shipType은 필수 입니다.");
						checkValidation = true;
						return;
					}
				}
				
			});
			
			if(checkValidation) {
				return false;
			}
			
			if($("#stepState").val() == "1") {

				lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' });
				
				//back버튼 클릭시 필요한 리스트
				backList = changeItemCreateResultRows;
				
				var dataList = { chmResultList : JSON.stringify(changeItemCreateResultRows) };
				var formData = getFormData('#listForm');
				var parameters = $.extend({}, dataList, formData);
				
				//그리드 초기화
				$('#itemCreateGrid').jqGrid( "clearGridData" );
				$('#itemCreateGrid').jqGrid( 'setGridParam', {
					url : 'saveItemNextAction.do',
					mtype : 'POST',
					async: true,
					datatype : 'json',
					postData : parameters,
					page : 1,
					rowNum : $('.ui-pg-selbox option:selected').val(),
					cellEdit : false
				} ).trigger( "reloadGrid" );
				
				$("#stepState").val("2");
				$("#btnChaebeon").attr("value", "채번");
				$("#btnBack").show();
				$('#itemCreateGrid').hideCol('catalog_code');
				$('#itemCreateGrid').showCol('item_code');
				$('#itemCreateGrid').showCol('item_desc');
				
				$("#btnCopy").attr("disabled", "disabled");
				$("#btnAdd").attr("disabled", "disabled");
				$("#btnDel").attr("disabled", "disabled");
				$("#btnExcelUpload").attr("disabled", "disabled");
				$("#btnExcelDownLoad").attr("disabled", "disabled");
				
				lodingBox.remove();
					
			} //step1(NEXT)
			else {
				
				fn_applyData("#itemCreateGrid", change_item_row_num,change_item_col);
				
				//프로세스가 NO 이면 진행 불가
				if(!chkgridProcess()){
					return false;
				}

				var changeItemCreateResultRows = [];

				// ERROR표시를 위한 ROWID 저장
				var ids = $("#itemCreateGrid").jqGrid('getDataIDs');
				for ( var j = 0; j < ids.length; j++) {
					$('#itemCreateGrid').setCell(ids[j], 'operId', ids[j]);
				}

				getChangedItemCreateResultData(function(data) {
					changeItemCreateResultRows = data;

					if (changeItemCreateResultRows.length == 0) {
						alert("변경된 내용이 없습니다.");
						return;
					}
					
					var colNames = $("#itemCreateGrid").jqGrid('getGridParam','colNames');
					
					if($("#shiptype_flag").val() == "Y"){
						if($("#shipType").val() == ""){
							alert("["+$("input[name=catalog_code]").val()+"] 의 shipType은 필수 입니다.");
							return;
						}
					}
					
					if (confirm("변경된 테이터를 채번하시겠습니까?") == 0) {
						return;
					}
					
					lodingBox = new ajaxLoader($('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' });
					var dataList = { chmResultList : JSON.stringify(changeItemCreateResultRows) };

					var url = 'saveItemCreate.do';

					var formData = getFormData('#listForm');

					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data) {
						lodingBox.remove();
						alert(data.resultMsg);
						fn_search();
						
						//var itemList = jQuery.parseJSON(data.itemList);
						if (data.resultMsg == "success") {
							
							var args = {createList : data.itemList
								   	   ,columnList : catalogColumn};
								   	   
							window.showModalDialog("itemCreateList.do",args,"dialogWidth:1280px; dialogHeight:680px; center:on; scroll:off; status:off; location:no");
							
//	 						if( rs == null ) {
//	 						}
						}
						
						
//	 					if (obj[0].result == "success") 
							
						/*
						if (obj.length == 1) {
							//$("#designInfo").clearGridData(true);
							if (obj[0].result == "success")
								fn_search();
						} else if (obj.length > 1) {

							for ( var i = 1; i < obj.length; i++) {

								if (obj[i].error_yn == "Y") {
									$("#itemCreateGrid").jqGrid('setRowData', obj[i].operId, false, { color : 'black', weightfont : 'bold', background : 'red' });
								} else {
									$("#itemCreateGrid").jqGrid('setRowData', obj[i].operId, false, { color : 'black', weightfont : '', background : '' });
									/
									for(var  j = 0; j < ids.length; j++) {	
										var index = $('#itemCreateGrid').jqGrid('getInd',ids[j]); 
										if (index == i) {
											$("#itemCreateGrid").jqGrid('setRowData', ids[j], false, {  color:'black',weightfont:'',background:''}); 
											break;
										}
									}/
								}
							}
						}*/

					}).fail(function(){
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						
						$("#stepState").val("1");
						$("#btnChaebeon").attr("value", "NEXT");
						$("#btnBack").hide();
						$('#itemCreateGrid').showCol('catalog_code');
						$('#itemCreateGrid').hideCol('item_code');
						$('#itemCreateGrid').hideCol('item_desc');
						
						$("#btnCopy").removeAttr("disabled");
						$("#btnAdd").removeAttr("disabled");
						$("#btnDel").removeAttr("disabled");
						$("#btnExcelUpload").removeAttr("disabled");
						$("#btnExcelDownLoad").removeAttr("disabled");
						
						$('#itemCreateGrid').jqGrid( 'setGridParam', {
							url : '',
							mtype : 'POST',
							cellEdit : true
						} ).trigger( "reloadGrid" );
						
						lodingBox.remove();	
					});
				});
				
			}//Step2
			
			fn_gridresize($(window), $("#itemCreateGrid"), 117);
		}
		
		//Process 필드가 NO인 것이 있으면 진행불가.
		var chkgridProcess = function(){
			
			var processData = $.grep($('#itemCreateGrid').jqGrid('getRowData'), function(obj) { 
				return obj.msg != 'OK'; 
			});	
			
			if(processData.length > 0){
				alert("올바르지 않은 데이터가 있습니다. \n데이터를 확인하십시오.");
				return false;
			}else{
				return true;		
			}
		}
		
		//엑셀 업로드 화면 호출
		function fn_excelUpload() {
			if (win != null) {
				win.close();
			}

			win = window.open( "./itemExcelUpload.do?gbn=itemExcelUpload&catalog_code=" + $("input[name=catalog_code]").val(), "listForm", "height=260,width=680,top=200,left=200");
		}
		
		// 엑셀 다운로드 서비스 호출
		function fn_excelDownload() {
			location.href = './itemExcelExport.do?catalog_code=' + $("input[name=catalog_code]").val();
		}
		
		
		function fnChkByte(obj, maxByte){

			var str = obj;
			var str_len = str.length;

			var rbyte = 0;
			var rlen = 0;
			var one_char = "";
			var str2 = "";

			for(var i=0; i<str_len; i++){

				one_char = str.charAt(i).charCodeAt(0);                               

				if (one_char <= 0x00007F) {
					rbyte += 1; 
				} else if (one_char <= 0x0007FF) {
					rbyte += 2; 
				} else if (one_char <= 0x00FFFF) {
					rbyte += 3;
				} else {
					rbyte += 4;
				}

				if(rbyte <= maxByte){
					rlen = i+1;                                         //return할 문자열 갯수
				}
	
			}

			if(rbyte > maxByte){
				alert("한글 "+(maxByte/3)+"자 / 영문 "+maxByte+"자를 초과 입력할 수 없습니다.\n최대 자릿수 " + maxByte + "Byte 이하 입력 제약입니다.(현재 입력 : " + rbyte + "Byte)");
				str2 = str.substr(0,rlen);                                  //문자열 자르기
				obj.value = str2;
				//fnChkByte(obj, maxByte);
				return false;
			} else{
				return true;
				//document.getElementById('byteInfo').innerText = rbyte;
			}

		}

			 
		
		</script>
	</body>
</html>