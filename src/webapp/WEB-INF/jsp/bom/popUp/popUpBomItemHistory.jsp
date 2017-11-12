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
			<input type="hidden" name="sType" id="sType" value="bomItemHistoryList" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="mother_code" name="mother_code" value="${mother_code}" />
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
				url:'infoBomItemHistory.do',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['ECO No', '모품목', '자품목', '호선', '작업일자', '작업자', '상태'],
				colModel : [{name : 'eco_no', index : 'eco_no', width : 80, sortable : true, align : "center"},
							{name : 'mother_code', index : 'mother_code', width : 100, sortable : true, align : "center"},
							{name : 'item_code', index : 'item_code', width : 100, sortable : true, align : "center"},
							{name : 'project_no', index : 'project_no', width : 80, sortable : true, align : "center"},
							{name : 'create_date', index : 'create_date', width : 110, sortable : true, align : "center"},
							{name : 'eco_user_name', index : 'eco_user_name', width : 180, sortable : true, align : "center"},
							{name : 'states', index : 'states', width : 60, sortable : true, align : "center"}
				           ],
			   	rowNum : -1,
			   	cmTemplate: { title: false },
			   	rownumbers : true,
			   	pager: '#pDataList',
			    viewrecords: true,
			   	autowidth : true,
			   	height : objectHeight,
			    cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				emptyrecords : '데이터가 존재하지 않습니다.',
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
			var sUrl = "infoBomItemHistory.do";
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
