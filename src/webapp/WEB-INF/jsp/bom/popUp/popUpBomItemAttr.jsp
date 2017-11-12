<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">					
					<!-- <strong>프로그램명</strong>
					<input type="text" class="w100h25" id="p_pgm_name" name="p_pgm_name" style="text-transform: uppercase;" /> -->
				</div>
				<div class="button">
					<input type="button" id="btncancle" name="btncancle" value="닫기" class="btn_blue" />
				</div>
			</div>
			<div class="content">
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
				url:'infoBomItemAttr.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['ITEM_CODE', 'ITEM_CATALOG', 'ITEM_CATEGORY', 'ITEM_DESC', 'ITEM_DESC_DETAIL', 'ITEM_WEIGHT',
				            'ATTR1', 'ATTR2', 'ATTR3', 'ATTR4', 'ATTR5', 'ATTR6', 'ATTR7', 'ATTR8', 'ATTR9', 'ATTR10', 'ATTR11', 'ATTR12', 'ATTR13', 'ATTR14', 'ATTR15',
				            'ITEM_MATERIAL1', 'ITEM_MATERIAL2', 'ITEM_MATERIAL3', 'ITEM_MATERIAL4', 'ITEM_MATERIAL5', 'PAINT_CODE1', 'PAINT_CODE2',
				            'CODE_TYPE', 'UOM', 'SHIP_PATTERN', 'ITEM_OLDCODE', 'CABLE_LENGTH', 'CABLE_TYPE', 'CABLE_OUTDIA', 'CAN_SIZE',
				            'STXSVR', 'THINNER_CODE', 'STX_STANDARD', 'PAINT_CODE', 'USER_ID', 'USER_NAME', 'CREATE_DATE', 'STATES_CODE', 'STATES_DESC' ],
				colModel : [{name : 'item_code', index : 'item_code', width : 80, align : "center"},
				            {name : 'item_catalog', index : 'item_catalog', width : 80, align : "center"},
				            {name : 'item_category', index : 'item_category', width : 80, align : "center"},
				            {name : 'item_desc', index : 'item_desc', width : 80, align : "center"},
				            {name : 'item_desc_detail', index : 'item_desc_detail', width : 80, align : "center"},
				            {name : 'item_weight', index : 'item_weight', width : 80, align : "center"},
				            {name : 'attr1', index : 'attr1', width : 80, align : "center"},
				            {name : 'attr2', index : 'attr2', width : 80, align : "center"},
				            {name : 'attr3', index : 'attr3', width : 80, align : "center"},
				            {name : 'attr4', index : 'attr4', width : 80, align : "center"},
				            {name : 'attr5', index : 'attr5', width : 80, align : "center"},
				            {name : 'attr6', index : 'attr6', width : 80, align : "center"},
				            {name : 'attr7', index : 'attr7', width : 80, align : "center"},
				            {name : 'attr8', index : 'attr8', width : 80, align : "center"},
				            {name : 'attr9', index : 'attr9', width : 80, align : "center"},
				            {name : 'attr10', index : 'attr10', width : 80, align : "center"},
				            {name : 'attr11', index : 'attr11', width : 80, align : "center"},
				            {name : 'attr12', index : 'attr12', width : 80, align : "center"},
				            {name : 'attr13', index : 'attr13', width : 80, align : "center"},
				            {name : 'attr14', index : 'attr14', width : 80, align : "center"},
				            {name : 'attr15', index : 'attr15', width : 80, align : "center"},
				            {name : 'item_material1', index : 'item_material1', width : 80, align : "center"},
				            {name : 'item_material2', index : 'item_material2', width : 80, align : "center"},
				            {name : 'item_material3', index : 'item_material3', width : 80, align : "center"},
				            {name : 'item_material4', index : 'item_material4', width : 80, align : "center"},
				            {name : 'item_material5', index : 'item_material5', width : 80, align : "center"},
				            {name : 'paint_code1', index : 'paint_code1', width : 80, align : "center"},
				            {name : 'paint_code2', index : 'paint_code2', width : 80, align : "center"},
				            {name : 'code_type', index : 'code_type', width : 80, align : "center"},
				            {name : 'uom', index : 'uom', width : 80, align : "center"},
				            {name : 'ship_pattern', index : 'ship_pattern', width : 80, align : "center"},
				            {name : 'item_oldcode', index : 'item_oldcode', width : 80, align : "center"},
				            {name : 'cable_length', index : 'cable_length', width : 80, align : "center"},
				            {name : 'cable_type', index : 'cable_type', width : 80, align : "center"},
				            {name : 'cable_outdia', index : 'cable_outdia', width : 80, align : "center"},
				            {name : 'can_size', index : 'can_size', width : 80, align : "center"},
				            {name : 'stxsvr', index : 'stxsvr', width : 80, align : "center"},
				            {name : 'thinner_code', index : 'thinner_code', width : 80, align : "center"},
				            {name : 'stx_standard', index : 'stx_standard', width : 80, align : "center"},
				            {name : 'paint_code', index : 'paint_code', width : 80, align : "center"},
				            {name : 'user_id', index : 'user_id', width : 80, align : "center"},
				            {name : 'user_name', index : 'user_name', width : 80, align : "center"},
				            {name : 'create_date', index : 'create_date', width : 80, align : "center"},
				            {name : 'states_code', index : 'states_code', width : 80, align : "center"},
				            {name : 'states_desc', index : 'states_desc', width : 80, align : "center"}
				           ],
	           gridview : true,
	           cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "",
				autowidth : true,
				height : objectHeight,
				//shrinkToFit : false,
				rowNum : -1,
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

		}); //end of ready Function 

		function fn_search() {
			var sUrl = "infoBomItemAttr.do";
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
