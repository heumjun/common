<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Item History</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form" method="post">
			<input type="hidden" name="sType" id="sType" value="bomItemAttr" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="item_code" name="item_code" value="${item_code}" />
			
			<input type="hidden" name="p_project_no" value="${p_project_no}" />
			<input type="hidden" name="p_mother_code" value="${p_mother_code}" />
			<%-- <input type="text" name="p_item_code" value="${p_item_code}" />
			<input type="text" name="p_item_desc" value="${p_item_desc}" /> --%>
			<input type="hidden" name="p_item_catalog" value="${p_item_catalog}"/>
			<input type="hidden" name="p_emp_no" value="${p_emp_no}" />
			<input type="hidden" name="p_item_attr1" value="${p_item_attr1}" />
			<input type="hidden" name="p_item_attr2" value="${p_item_attr2}" />
			<input type="hidden" name="p_item_attr3" value="${p_item_attr3}" />
			<input type="hidden" name="p_eng_change_order_code"  value="${p_eng_change_order_code}" />
			<input type="hidden" name="p_eco_no" value="${p_eco_no}" />
			<input type="hidden" name="p_eco_emp_no" value="${p_eco_emp_no}" />
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">					
					<strong>ITEM CODE : </strong>
					<input type="text" class="w100h25" id="p_item_code" name="p_item_code" style="text-transform: uppercase;" value="${p_item_code}" />
					&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>ITEM DESC : </strong>
					<input type="text" class="w100h25" id="p_item_desc" name="p_item_desc" style="text-transform: uppercase;" value="${p_item_desc}" />
				</div>
				<div class="button">
					<input type="button" id="btnSearch" name="btnSearch" value="조회" class="btn_blue" />
					<input type="button" id="btncancle" name="btncancle" value="닫기" class="btn_blue" />
				</div>
			</div>
			<div id="dataListDiv" class="content">
				<table id="dataList"></table>
				<div id="pDataList"></div>
			</div>
		</form>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var fv_catalog_code = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var emp_no;
		var user_name;
		var dept_code;
		var dept_name;
		
		var lodingBox;
		
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#dataList" ).jqGrid( {
				url:'infoSearchItem.do',
				type : "POST",
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['ITEM CODE','','MOTHER_CODE','DESCRIPTION', 'BOM TYPE', '상태', 'CATALOG', 'UOM', 'QTY',
				            'ECO', 'CREATED_BY','현황' ],
				colModel : [{name : 'item_code', index : 'item_code', width: 120, align : "left" },
				            { name : 'leaf', index : 'leaf', width : 80, align : "left", hidden : true },
				            {name : 'mother_code', index : 'mother_code', width: 100, align : "left"},
				            {name : 'item_desc', index : 'item_desc', width : 250, align : "left"},
				            {name : 'bom_type', index : 'bom_type', width : 60, align : "center"},
				            {name : 'item_states_desc', index : 'item_states_desc', width : 80, align : "center" },
				            {name : 'item_catalog', index : 'item_catalog', width : 50, align : "center"},
				            {name : 'uom', index : 'uom', width : 40, align : "center" },
				            {name : 'bom_qty', index : 'bom_qty', width : 40, align : "center" , hidden: true},
				            {name : 'eco_no', index : 'eco_no', width : 80, align : "center"},
				            {name : 'created_by', index : 'created_by', width : 130, align : "center", hidden: true},
				            { name : 'states_flag_desc', index : 'states_flag_desc', width : 40, align: "center", hidden : true}
				           ],
	           gridview : true,
	           cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "",
				autowidth : true,
				height : objectHeight,
				//shrinkToFit : false,
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				emptyrecords : '데이터가 존재하지 않습니다.',
				pager : jQuery('#pDataList'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				imgpath : 'themes/basic/images',
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				onPaging: function(pgButton) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid("clearGridData");

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");  
				},
				ondblClickRow: function(rowId) {
	    			var rowData = jQuery(this).getRowData(rowId); 
	    			
	    			/* var returnValue = new Array();
	    			returnValue[0] = rowData['mother_code'];
	      			returnValue[1] = rowData['item_code'];
	      			returnValue[2] = rowData['item_desc'];
	      			returnValue[3] = rowData['states_flag_desc'];
	      			returnValue[4] = rowData['bom_type'];
	      			returnValue[5] = rowData['item_states_desc'];
	      			returnValue[6] = rowData['item_catalog'];
	      			returnValue[7] = rowData['uom'];
	      			returnValue[8] = rowData['bom_qty'];
	      			returnValue[9] = rowData['eco_no'];
	      			returnValue[10] = rowData['created_by'];
	      			window.returnValue = returnValue; */
	      			
	      			$("#selectMotherCode", opener.document).html(rowData['mother_code']);
	      			$("#selectItemCode", opener.document).html(rowData['item_code']);
	      			$("#selectDescription", opener.document).html(rowData['item_desc']);
					
					if(rowData['states_flag_desc'] != "BOM"){
						$("#p_selectProjectNo", opener.document).val(rowData['states_flag_desc'].split("-")[0]);
						$("#selectProjectNo", opener.document).html(rowData['states_flag_desc'].split("-")[0]);
						$("#selectStatesFlag", opener.document).html(rowData['states_flag_desc'].split("-")[1]);
					} else {
						$("#selectProjectNo", opener.document).html("-");
						$("#selectStatesFlag", opener.document).html(rowData['states_flag_desc']);
					}
					
					$("#selectBomType", opener.document).html(rowData['bom_type']);
					//$("#selectStatus").html(rowData['item_states_desc']);
					$("#selectCatalog", opener.document).html(rowData['item_catalog']);
					$("#selectUom", opener.document).html(rowData['uom']);
					$("#selectQty", opener.document).html(rowData['bom_qty']);
					$("#selectEcoNo", opener.document).html(rowData['eco_no']);
					$("#selectEcoCreater", opener.document).html(rowData['created_by']);
					
					opener.fn_search();
	      			self.close();
				 },
				 gridComplete : function() {
						var rows = $( "#dataList" ).getDataIDs();
						for ( var i = 0; i < rows.length; i++ ) {
							//수정 및 결재 가능한 리스트 색상 변경
							var leaf = $( "#dataList" ).getCell( rows[i], "leaf" );
							if( leaf != "true" && leaf != "0"  ) {
								$( "#dataList" ).jqGrid( 'setRowData', rows[i],false, { background : '#819FF7' } );
							}
						}
						
					},
				loadComplete: function (data) {
					var rowCnt = $("#dataList").getGridParam("reccount");
	             	
	             	if (rowCnt == 0) {
	             		//self.close();	
	             	} else if (rowCnt == 1) {
	             		var rowData = jQuery(this).getRowData(1);		
			
// 	             		var returnValue = new Array();
// 		    			returnValue[0] = rowData['mother_code'];
// 		      			returnValue[1] = rowData['item_code'];
// 		      			returnValue[2] = rowData['item_desc'];
// 		      			returnValue[3] = rowData['states_flag_desc'];
// 		      			returnValue[4] = rowData['bom_type'];
// 		      			returnValue[5] = rowData['item_states_desc'];
// 		      			returnValue[6] = rowData['item_catalog'];
// 		      			returnValue[7] = rowData['uom'];
// 		      			returnValue[8] = rowData['bom_qty'];
// 		      			returnValue[9] = rowData['eco_no'];
// 		      			returnValue[10] = rowData['created_by'];
// 		      			window.returnValue = returnValue;
		      			
		      			
						if (data != null) {
							$("#selectMotherCode", opener.document).html(rowData['mother_code']);
			      			$("#selectItemCode", opener.document).html(rowData['item_code']);
			      			$("#selectDescription", opener.document).html(rowData['item_desc']);
							
							if(rowData['states_flag_desc'] != "BOM"){
								$("#p_selectProjectNo", opener.document).val(rowData['states_flag_desc'].split("-")[0]);
								$("#selectProjectNo", opener.document).html(rowData['states_flag_desc'].split("-")[0]);
								$("#selectStatesFlag", opener.document).html(rowData['states_flag_desc'].split("-")[1]);
							} else {
								$("#selectProjectNo", opener.document).html("-");
								$("#selectStatesFlag", opener.document).html(rowData['states_flag_desc']);
							}
							
							$("#selectBomType", opener.document).html(rowData['bom_type']);
							//$("#selectStatus").html(rowData['item_states_desc']);
							$("#selectCatalog", opener.document).html(rowData['item_catalog']);
							$("#selectUom", opener.document).html(rowData['uom']);
							$("#selectQty", opener.document).html(rowData['bom_qty']);
							$("#selectEcoNo", opener.document).html(rowData['eco_no']);
							$("#selectEcoCreater", opener.document).html(rowData['created_by']);
							opener.fn_search();
						}

		      			self.close();
	             	}
	             	
					var $this = $(this);
					if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid('setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						});

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if ($this.jqGrid('getGridParam', 'sortname') !== '') {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler('reloadGrid');
						}
					} else {
						$this.jqGrid('setGridParam', {
							page: $this.jqGrid('getGridParam', 'pageServer'),
							records: $this.jqGrid('getGridParam', 'recordsServer'),
							lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
						} );
						this.updatepager(false, true);
					}
				}
			} );
			
			$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			
			$('#btncancle').click(function(){
				self.close();
			});
			
			$('#btnSearch').click(function(){
				fn_search();
			});
			fn_insideGridresize($(window), $("#dataListDiv"), $("#dataList"));
		}); //end of ready Function 

		function fn_search() {
			var sUrl = "infoSearchItem.do";
			$("#dataList").jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype: "json",
				postData : fn_getFormData( "#application_form" )
			} ).trigger("reloadGrid");
		}
		</script>
	</body>
</html>
