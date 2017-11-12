<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>호선 조회</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" name="sType" id="sType" value="select_project_no" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" id="p_delegate_project_no" name="p_delegate_project_no" />
			<input type="hidden" id="pipe_project" name="pipe_project" value="${pipe_project}"/>
			
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">
					
					<strong>호선명</strong>
					<input type="text" class="w100h25" id="p_project_no" name="p_project_no" style="text-transform: uppercase;" />
					<input type="text" style="display: none;" /> <!-- text가 페이지에 한개만 있으면 엔터키를 누를때 자동 submit 이 되므로 이를 방지하기 위해 한개 더 생성 -->
				</div>
				<div class="button">
					<input type="button" id="btnSelect" name="btnSelect" value="조회" class="btn_blue" />
					<input type="button" id="btncancle" name="btncancle" value="닫기" class="btn_blue" />
				</div>
			</div>
			<div class="content">
				<table id="delegateProjectNoList"></table>
				<div id="pdelegateProjectNoList"></div>
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
		
		var p_Url = "infoProjectNo.do";
		$(document).ready( function() {
			fn_all_text_upper();
			
			var openerObj = window.dialogArguments;
			if("${p_delegate_project_no}" == "none"){
				$( "#p_delegate_project_no" ).val( "${p_delegate_project_no}" );
			} else {
				$( "#p_delegate_project_no" ).val( openerObj.$( "#p_delegate_project_no" ).val() );
			}
			$( "#p_project_no" ).val( openerObj.$( "#p_project_no" ).val() );
			
			if("${searchType}" == "PAINT"){
				p_Url = "selectSeriesProjectNo.do?project_no="+$( "#p_delegate_project_no" ).val();
			}
			$( "#delegateProjectNoList" ).jqGrid( {
				url:p_Url,
				datatype: "json",
				postData : fn_getFormData("#application_form"),
				colNames : [ '호선' ],
				colModel : [ { name : 'project_no', index : 'project_no', width : 40, align : "left" } ],
			   	rowNum : -1,
// 			   	rowList : [100,500,1000],
			   	rownumbers : true,
			   	pager: '#pdelegateProjectNoList',
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
					var project_no = rowData['project_no'];

					var returnValue = new Array();
					returnValue[0] = project_no;
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
					
					
					var rowCnt = $("#delegateProjectNoList").getGridParam("reccount");
	             	
	             	if (rowCnt == 0) {
	             		//self.close();	
	             	} else if (rowCnt == 1) {
	             		var ret = jQuery("#delegateProjectNoList").getRowData(1);  		
			
	             		var returnValue = new Array();
						returnValue[0] = ret.project_no;
						window.returnValue = returnValue;
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
			
			//register_type이 없을 경우 선택 radio 숨김
			if( $("#register_type").val() == "" ) {
				$("#delegateProjectNoList").jqGrid('hideCol', 'enable_flag');
				
				$(window).bind('resize', function() {
				    $("#delegateProjectNoList").setGridWidth($(window).width()-30);
				}).trigger('resize');
			} else {
				$("#delegateProjectNoList").jqGrid('showCol', 'enable_flag');
			}
			
			//STATE 값에 따라서 checkbox 생성
			function formatOpt1( cellvalue, options, rowObject ) {
				if( rowObject.enable_flag == "" || rowObject.enable_flag == undefined ) {
					var rowid = options.rowId;
					var str = "<input type='radio' name='checkbox' id="
							+ rowid + "_chkBoxOV value=" + cellvalue
							+ " onclick='fn_checkRadio(" + rowid + ")' />";
	
					return str;
				}
			}

			//nav button area set width 0 
			$("#pdelegateProjectNoList_left").css("width", 0);
			
			$( "#delegateProjectNoList" ).jqGrid( 'navGrid', "#pdelegateProjectNoList", {
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
				var item = $('#delegateProjectNoList').jqGrid('getRowData', irow);
				if (item.oper != 'I')
					item.oper = 'U';
				$('#delegateProjectNoList').jqGrid("setRowData", irow, item);
				$("input.editable,select.editable", this).attr( "editable", "0" );
			};
			
			
		}); //end of ready Function 

		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#delegateProjectNoList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmCheckResultData(callback) {
			var changedData = $.grep($("#delegateProjectNoList").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == 'P';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		function fn_search() {
			var sUrl = p_Url;
			$("#delegateProjectNoList").jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype: "json",
				postData : fn_getFormData("#application_form")
			} ).trigger("reloadGrid");
		}
		$( "#p_project_no" ).keydown( function( e ) {
			if ( e.which == 13 ) {
				fn_search();
				return false;
			}
		} );
		/*
		사용안되고 있음
		//저장버튼
		$("#btnSave").click(function() {
			$('#delegateProjectNoList').saveCell(kRow, idCol);
			var changedData = $("#delegateProjectNoList").jqGrid('getRowData');
			
			if ( $("#sub_emp_no").val() == "" ) {
				alert("radio 버튼을 선택 후 Register버튼을 클릭해주세요.");
				return;
			}
			
			// 변경된 체크 박스가 있는지 체크한다.
			for ( var i = 1; i < changedData.length + 1; i++) {
				var item = $('#delegateProjectNoList').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}
					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#delegateProjectNoList').jqGrid("setRowData", i, item);
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
		} );
 */
		function fn_checkRadio(rowid) {
			var item = $('#delegateProjectNoList').jqGrid('getRowData', rowid);
			
			emp_no = item.emp_no;
			user_name = item.user_name;
			dept_code = item.dept_code;
			dept_name = item.dept_name;
			
			$("#sub_emp_no").val(emp_no);
		}
 
		</script>
	</body>
</html>
