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
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" name="p_project_no" value="${p_project_no}" />
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">					
					<strong>ITEM CODE : </strong>
					<input type="text" class="w100h25" id="p_item_code" name="p_item_code" style="text-transform: uppercase;" value="${p_item_code}" />
					&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>ITEM DESC : </strong>
					<input type="text" class="w100h25" id="p_item_desc" name="p_item_desc" style="text-transform: uppercase;" value="" />
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
				url:'popUpItemList.do',
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
	      			
	      			$("#p_item_code", opener.document).val(rowData['item_code']);
	      			self.close();
				 },
				 gridComplete : function() {
						
				 },
				 loadComplete: function (data) {
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
			var sUrl = "popUpItemList.do";
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
