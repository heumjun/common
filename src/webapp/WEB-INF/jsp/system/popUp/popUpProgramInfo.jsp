<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>프로그램 조회</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form" method="post">
			<input type="hidden" name="sType" id="sType" value="programList" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">					
					<strong>프로그램명</strong>
					<input type="text" class="w100h25" id="p_pgm_name" name="p_pgm_name" style="text-transform: uppercase;" />
				</div>
				<div class="button">
					<input type="button" id="btnSelect" name="btnSelect" value="조회" class="btn_blue" />
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
				url:'programList.do',
				mtype : 'POST',
				datatype: "json",
				postData : fn_getFormData( "#application_form" ),
				colNames : ['프로그램ID', '프로그램명', 'URL', 'Description', 'attribute1', 'attribute2', 'attribute3', 'attribute4', 'attribute5', 'enable_flag_changed', 'crud'],
				colModel : [{name : 'pgm_id', index : 'pgm_id', width : 160},
							{name : 'pgm_name', index : 'pgm_name', width : 160},
							{name : 'file_url', index : 'file_url', width : 250, hidden : true},
							{name : 'description', index : 'description', width : 250},
							{name : 'attribute1', index : 'attribute1', width : 25, hidden : true},
							{name : 'attribute2', index : 'attribute2', width : 25, hidden : true},
							{name : 'attribute3', index : 'attribute3', width : 25, hidden : true},
							{name : 'attribute4', index : 'attribute4', width : 25, hidden : true},
							{name : 'attribute5', index : 'attribute5', width : 25, hidden : true},
							{name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true},
							{name : 'oper', index : 'oper', width : 25, hidden : true}
				           ],
			   	rowNum : 1000,
			   	rowList : [100,500,1000],
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
				ondblClickRow : function(rowId) {
					var rowData = $(this).getRowData(rowId);
					var pgm_id = rowData['pgm_id'];
					var pgm_name = rowData['pgm_name'];
					var file_url = rowData['file_url'];
					var description = rowData['description'];

					var returnValue = new Array();
					returnValue[0] = pgm_id;
					returnValue[1] = pgm_name;
					returnValue[2] = file_url;
					returnValue[3] = description;
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
			
			//register_type이 없을 경우 선택 radio 숨김
			if( $("#register_type").val() == "" ) {
				$("#dataList").jqGrid('hideCol', 'enable_flag');
				
				$(window).bind('resize', function() {
				    $("#dataList").setGridWidth($(window).width()-30);
				}).trigger('resize');
			} else {
				$("#dataList").jqGrid('showCol', 'enable_flag');
			}

			//nav button area set width 0 
			$("#pDataList_left").css("width", 0);
			
			$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
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
				var item = $('#dataList').jqGrid('getRowData', irow);
				if (item.oper != 'I')
					item.oper = 'U';
				$('#dataList').jqGrid("setRowData", irow, item);
				$("input.editable,select.editable", this).attr( "editable", "0" );
			};
			
			
		}); //end of ready Function 

		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#dataList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmCheckResultData(callback) {
			var changedData = $.grep($("#dataList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == 'P';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		function fn_search() {
			var sUrl = "programList.do";
			$("#dataList").jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				mtype : 'POST',
				datatype: "json",
				postData : fn_getFormData( "#application_form" )
			} ).trigger("reloadGrid");
		}

		//저장버튼 사용안되고있음
		/* $("#btnSave").click(function() {
			$('#dataList').saveCell(kRow, idCol);
			var changedData = $("#dataList").jqGrid('getRowData');
			
			if ( $("#sub_emp_no").val() == "" ) {
				alert("radio 버튼을 선택 후 Register버튼을 클릭해주세요.");
				return;
			}
			
			// 변경된 체크 박스가 있는지 체크한다.
			for ( var i = 1; i < changedData.length + 1; i++) {
				var item = $('#dataList').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}
					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#dataList').jqGrid("setRowData", i, item);
					}
				}
			}
			
			var chmResultRows = [];
			getChangedChmResultData(function(data) {
				chmResultRows = data;
				var dataList = {
					chmResultList : JSON.stringify(chmResultRows)
				};

				var url = 'saveEngineerRegister.do';
				var formData = fn_getFormData('#application_form');
				var parameters = $.extend({}, dataList, formData);
				lodingBox = new ajaxLoader( $( '#wrap' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				$.post(url, parameters, function(data2) {
					var msg    = "";
					var result = "";

					for ( var keys in data2) {
						for ( var key in data2[keys]) {
							if (key == 'Result_Msg') {
								msg = data2[keys][key];
							}

							if (key == 'result') {
								result = data2[keys][key];
							}
						}
					}

					alert(msg);

					if (result == "success") {
						var returnValue = new Array();
						returnValue[0] = emp_no;
						returnValue[1] = emp_no + "(" + user_name + ", " + dept_name + ")";
						returnValue[2] = user_name;
						returnValue[3] = dept_code;
						returnValue[4] = dept_name;
						window.returnValue = returnValue;
						self.close();
					} else {
						fn_search();
					}
				} ,'json').error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	lodingBox.remove();	
				} );
			} );
		} ); */

		function fn_checkRadio(rowid) {
			var item = $('#dataList').jqGrid('getRowData', rowid);
			
			emp_no = item.emp_no;
			user_name = item.user_name;
			dept_code = item.dept_code;
			dept_name = item.dept_name;
			
			$("#sub_emp_no").val(emp_no);
		}
		</script>
	</body>
</html>
