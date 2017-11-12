<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>POPUP (Model 조회)</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" name="sType" id="sType" value="select_model" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">
					
					<strong>POPUP (Model 조회)</strong>
					<input type="text" class="w100h25" id="p_model" name="p_model" style="text-transform: uppercase;" />
					<input type="text" style="display: none;" /> <!-- text가 페이지에 한개만 있으면 엔터키를 누를때 자동 submit 이 되므로 이를 방지하기 위해 한개 더 생성 -->
				</div>
				<div class="button">
					<input type="button" id="btnSelect" name="btnSelect" value="조회" class="btn_blue" />
					<input type="button" id="btncancle" name="btncancle" value="닫기" class="btn_blue" />
				</div>
			</div>
			<div class="content">
				<table id="modelList"></table>
				<div id="pmodelList"></div>
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
			
// 			var openerObj = window.dialogArguments;
// 			$( "#p_delegate_project_no" ).val( openerObj.$( "#p_delegate_project_no" ).val() );
// 			$( "#p_model_no" ).val( openerObj.$( "#p_model_no" ).val() );
			
			$( "#modelList" ).jqGrid( {
				url:'popUpTestSourceList.do',
				mtype : 'POST',
				datatype: "json",
				postData : fn_getFormData("#application_form"),
				colNames : [ 'Model_No', 'Model_Desc' ],
				colModel : [ { name : 'model_no', index : 'model_no', width : 40 },
				             { name : 'model_desc', index : 'model_desc', width : 40, align : "left" } ],
			   	rowNum : -1,
// 			   	rowList : [100,500,1000],
			   	rownumbers : true,
			   	pager: '#pmodelList',
// 			   	sortname: 'emp_no',
			    viewrecords: true,
// 			    sortorder: "desc",
			   	autowidth : true,
				pgbuttons : false,
				pgtext : false,
				pginput : false,
			   	height : 275,
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
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					var rowData = $(this).getRowData(rowid);
					var model = rowData['model_no'];
					var model_desc = rowData['model_desc'];

					var returnValue = new Array();
					returnValue[0] = model;
					returnValue[1] = model_desc;
					window.returnValue = returnValue;
					self.close();
				},
				onSelectRow : function(row_id) {
					if (row_id != null) {
						row_selected = row_id;
					}
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
			
// 			//register_type이 없을 경우 선택 radio 숨김
// 			if( $("#register_type").val() == "" ) {
// 				$("#modelList").jqGrid('hideCol', 'enable_flag');
				
// 				$(window).bind('resize', function() {
// 				    $("#modelList").setGridWidth($(window).width()-30);
// 				}).trigger('resize');
// 			} else {
// 				$("#modelList").jqGrid('showCol', 'enable_flag');
// 			}
			
			
			//nav button area set width 0 
			$("#pmodelList_left").css("width", 0);
			
			$( "#modelList" ).jqGrid( 'navGrid', "#pmodelList", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} );
			
			//조회 버튼
			$("#btnSelect").click(function() {
				fn_search();
			});
			
			$('#btncancle').click(function(){
				self.close();
			});

			//afterSaveCell oper 값 지정
			function chmResultEditEnd(irow, cellName) {
				var item = $('#modelList').jqGrid('getRowData', irow);
				if (item.oper != 'I')
					item.oper = 'U';
				$('#modelList').jqGrid("setRowData", irow, item);
				$("input.editable,select.editable", this).attr( "editable", "0" );
			};
			
			
		}); //end of ready Function 

		function fn_search() {
			var sUrl = "popUpTestSourceList.do";
			$("#modelList").jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype: "json",
				postData : fn_getFormData("#application_form")
			} ).trigger("reloadGrid");
		}
		</script>
	</body>
</html>
