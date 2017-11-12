<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>BOM Attr</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form" method="post">
			<input type="hidden" name="sType" id="sType" value="bomAttr" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="mother_code" name="mother_code" value="${mother_code}" />
			<input type="hidden" id="item_code" name="item_code" value="${item_code}" />
			<input type="hidden" id="project_no" name="project_no" value="${project_no}" />
			
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
				url:'infoBomAttr.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['STATES', 'Mother Code', 'Item', 'Type', 'Catalog', 'Description', 'UOM', 'QTY', 'DWG NO', 'Creator', 'ECO NO', 'ECO Creator', 'FINDNUMBER',
				            'BOM1', 'BOM2', 'BOM3', 'BOM4', 'BOM5', 'BOM6', 'BOM7', 'BOM8', 'BOM9', 'BOM10', 'BOM11', 'BOM12', 'BOM13', 'BOM14', 'BOM15', ],
				colModel : [ { name : 'states_desc', index : 'states_desc', width : 80, align: "center"},
				             { name : 'mother_code', index : 'mother_code', width : 80, align : "left" },
				             { name : 'item_code', index : 'item_code', width: 100, align : "left" },
				             { name : 'bom_type', index : 'bom_type', width : 80, align : "center" }, 
				             { name : 'item_catalog', index : 'item_catalog', width : 80, align : "center" },
				             { name : 'item_desc', index : 'item_desc', width : 255, align : "left" }, 
				             { name : 'uom', index : 'uom', width : 40, align : "center" }, 
				             { name : 'qty', index : 'qty', width : 40, align : "right" },
				             { name : 'dwg_no', index : 'dwg_no', width : 80, align : "center" },
				             { name : 'emp_no', index : 'emp_no', width : 150, align : "center" }, 
				             { name : 'eco_no', index : 'eco_no', width : 80, align : "center" }, 
				             { name : 'created_by', index : 'created_by', width : 150, align : "center" },
				             { name : 'findnumber', index : 'findnumber', width : 150, align : "center" },
				             { name : 'bom1', index : 'bom1', width : 80, align : "center" },
				             { name : 'bom2', index : 'bom2', width : 80, align : "center" },
				             { name : 'bom3', index : 'bom3', width : 80, align : "center" },
				             { name : 'bom4', index : 'bom4', width : 80, align : "center" },
				             { name : 'bom5', index : 'bom5', width : 80, align : "center" },
				             { name : 'bom6', index : 'bom6', width : 80, align : "center" },
				             { name : 'bom7', index : 'bom7', width : 80, align : "center" },
				             { name : 'bom8', index : 'bom8', width : 80, align : "center" },
				             { name : 'bom9', index : 'bom9', width : 80, align : "center" },
				             { name : 'bom10', index : 'bom10', width : 80, align : "center" },
				             { name : 'bom11', index : 'bom11', width : 80, align : "center" },
				             { name : 'bom12', index : 'bom12', width : 80, align : "center" },
				             { name : 'bom13', index : 'bom13', width : 80, align : "center" },
				             { name : 'bom14', index : 'bom14', width : 80, align : "center" },
				             { name : 'bom15', index : 'bom15', width : 80, align : "center" }				             
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
			var sUrl = "infoBomAttr.do";
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
