<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>사원 조회</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<% String strRegisterType = request.getParameter("register_type") == null ? "" : request.getParameter("register_type").toString(); %>
			<input type="hidden" name="register_type" id="register_type" value="<%=strRegisterType%>" />
			<input type="hidden" name="main_type" id="main_type" value="<%=request.getParameter("main_type")%>" />
			<input type="hidden" name="main_code" id="main_code" value="<%=request.getParameter("main_code")%>" />
			<input type="hidden" name="sType" id="sType" value="EmpNo" />
			<input type="hidden" name="sub_emp_no" id="sub_emp_no" />
			<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			
			<div class = "topMain" style="margin-top: 0px;line-height: 45px;">
				<div class="conSearch">
					<select name="sel_condition" id="sel_condition" class="h25">
						<option value="empname" selected="selected">이름</option>
						<option value="empno">사번</option>
					</select>
					<input type="text" class="w100h25" id="txt_condition" name="txt_condition" style="text-transform: uppercase;" />
				</div>
				<div class="button">
					<%
						if (!("".equals(strRegisterType))) {
					%>
					<input type="button" id="btnSave" name="btnSave" value="확인" class="btn_blue"/>
					<%
						}
					%>
					<input type="button" id="btnSelect" name="" value="조회" class="btn_blue"/>
					<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
				</div>
			</div>
			<div class="content">
				<table id="empPopup"></table>
				<div id="pempPopup"></div>
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
		
		/* $(document).keydown(function (e) { 
			if (e.keyCode == 13) { 
				fn_search();
			} // enter조회
		}); */
		
		$(document).ready( function() {
			fn_all_text_upper();
			//엔터 버튼 클릭
			$(":text").keypress(function(event) {
			  if (event.which == 13) {
			        event.preventDefault();
			        $('#btnSelect').click();
			    }
			});
			$( "#empPopup" ).jqGrid( {
				url:'',
				datatype: "json",
				colNames : [ '선택', '사번', '이름', '', '부서' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', width : 10, align : "center", editable : true, formatter : formatOpt1, edittype : "radio" }, 
				             { name : 'emp_no', index : 'emp_no', width : 40, editable : false, align : "center", editrules : { required : true }, editoptions : { size : 5 } }, 
				             { name : 'user_name', index : 'user_name', width : 40, editable : false, align : "center", editoptions : { size : 11 } }, 
				             { name : 'dept_code', index : 'dept_code', width : 40, editable : false, align : "center", editoptions : { size : 11 }, hidden : true }, 
				             { name : 'dept_name', index : 'dept_name', width : 90, editable : false, align : "center", editoptions : { size : 11 } }
				           ],
			   	rowNum:100,
			   	rowList:[100,500,1000],
			   	pager: '#pempPopup',
			   	sortname: 'emp_no',
			    viewrecords: true,
			    sortorder: "desc",
			   	autowidth : true,
			   	height : 320,
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
					if( $( "#register_type").val() == "" ) {
						var rowData = jQuery(this).getRowData(rowId);
						var emp_no = rowData['emp_no'];
						var user_name = rowData['user_name'];
						var dept_code = rowData['dept_code'];
						var dept_name = rowData['dept_name'];

						var returnValue = new Array();
						returnValue[0] = emp_no;
						returnValue[1] = user_name;
						returnValue[2] = dept_code;
						returnValue[3] = dept_name;
						window.returnValue = returnValue;
						self.close();
					}
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
				$("#empPopup").jqGrid('hideCol', 'enable_flag');
				
				$(window).bind('resize', function() {
				    $("#empPopup").setGridWidth($(window).width()-30);
				}).trigger('resize');
			} else {
				$("#empPopup").jqGrid('showCol', 'enable_flag');
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
			//$("#pempPopup_left").css("width", 0);
			
			$( "#empPopup" ).jqGrid( 'navGrid', "#pempPopup", {
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
				var item = $('#empPopup').jqGrid('getRowData', irow);
				if (item.oper != 'I')
					item.oper = 'U';
				$('#empPopup').jqGrid("setRowData", irow, item);
				$("input.editable,select.editable", this).attr( "editable", "0" );
			};
			
		}); //end of ready Function 

		function getChangedChmResultData(callback) {
			var changedData = $.grep($("#empPopup").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//가져온 배열중에서 필요한 배열만 골라내기 
		function getChangedChmCheckResultData(callback) {
			var changedData = $.grep($("#empPopup").jqGrid('getRowData'), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D' || obj.oper == 'P';
			});
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		function fn_search() {
			var sUrl = "infoEmpNoList.do";
			jQuery("#empPopup").jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype: "json",
				postData : fn_getFormData("#application_form")
			} ).trigger("reloadGrid");
		}

		//저장버튼
		$("#btnSave").click(function() {
			$('#empPopup').saveCell(kRow, idCol);
			var changedData = $("#empPopup").jqGrid('getRowData');
			
			if ( $("#sub_emp_no").val() == "" ) {
				alert("radio 버튼을 선택 후 Register버튼을 클릭해주세요.");
				return;
			}
			
			// 변경된 체크 박스가 있는지 체크한다.
			for ( var i = 1; i < changedData.length + 1; i++) {
				var item = $('#empPopup').jqGrid('getRowData', i);

				if (item.oper != 'I' && item.oper != 'U') {
					if (item.enable_flag_changed != item.enable_flag) {
						item.oper = 'U';
					}
					if (item.oper == 'U') {
						// apply the data which was entered.
						$('#empPopup').jqGrid("setRowData", i, item);
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
					alert(data2.resultMsg);
					if ( data2.result == 'success' ) {
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

		function fn_checkRadio(rowid) {
			var item = $('#empPopup').jqGrid('getRowData', rowid);
			
			emp_no = item.emp_no;
			user_name = item.user_name;
			dept_code = item.dept_code;
			dept_name = item.dept_name;
			
			$("#sub_emp_no").val(emp_no);
		}
		</script>
	</body>
</html>
