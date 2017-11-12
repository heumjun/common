<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ECR To ECO Related</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		<style type="text/css">
		.disabled {
			background:#dddddd;
		}
		</style>
	</head>
	<body>
		<div id = "mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<%
					String sMainCode = request.getParameter( "main_code" ) == null ? "" : request.getParameter( "main_code" ).toString();
					String sEngChangeBasedOn = request.getParameter( "eng_change_based_on" ) == null ? "" : request.getParameter( "eng_change_based_on" ).toString();
				%>
				<input type="hidden" id="cmd" name="cmd" value="${cmd}" />
				<input type="hidden" id="save" name="save" value="<%=request.getParameter("save")%>" />
				<input type="hidden" id="sType" name="sType" value="ecoAddEcrRink" />
				<input type="hidden" name="main_code" id="main_code" value="<%=sMainCode %>" />
				<input type="hidden" name="eng_change_based_on" id="eng_change_based_on" value="<%=sEngChangeBasedOn %>" />
				<input type="hidden" name="main_type" id="main_type" value="ECO">
				<input type="hidden" name="eng_sub_type" id="eng_sub_type" value="ECO">
				<input type="hidden" name="eng_small_type" id="eng_small_type" value="RECO">
				<input type="hidden" id="p_code_gbn" name="p_code_gbn" value="ecr" />
				<input type="hidden" class="" id="loginid" name="loginid" value="${loginUser.user_id}" />
				<div class="topMain" style="margin-top: 0px;">
					<div class="conSearch" >
						<span class="only_eco pop_tit">ECO Name</span>
						<input type="text" class="only_eco" id="main_name" name="main_name" style="text-transform: uppercase; width: 80px; height:25px; maxlength="10" />
						<span class="only_eco">&nbsp;</span>
						<span class="only_eco pop_tit">작성자</span>
						<input type="text" class="only_eco" id="created_by" name="created_by" style="width: 50px;height:25px; " onkeyup="fn_clear();" />
						<input type="text" class="notdisabled only_eco" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px;height:25px;  margin-left: -5px;" />
						<input type="button" class="only_eco btn_gray2" id="btnEmpNo" name="btnEmpNo" value="검색" />
						<span class="hidden_ecr">&nbsp;</span>
						<span class="only_eco pop_tit">부서</span>
						<input type="text" class="only_eco" id="user_group" name="user_group" style="width: 50px;height:25px;" onkeyup="fn_clear2();" />
						<input type="text" class="notdisabled only_eco" id="user_group_name" name="user_group_name" readonly="readonly" style="margin-left: -5px;height:25px; " />
						<input type="button" class="only_eco btn_gray2" id="btnGroupNo" name="btnGroupNo" value="검색"  />
						<span class="only_eco">&nbsp;&nbsp;</span>
						<span class="only_eco pop_tit">ECO 생성일</span>
						<input type="text" id="created_date_start" name="created_date_start" class="datepicker only_eco" style="width: 70px;height:25px; "/>
						<span class="only_eco">~</span>
						<input type="text" id="created_date_end" name="created_date_end" class="datepicker only_eco" style="width: 70px;height:25px; "/>
						<span class="only_eco">&nbsp;&nbsp;</span>
						<span class="button">
						<input type="button" class="only_eco btn_blue" id="btnSelect" name="btnSelect" value="조회" />
						<input type="button" class="only_eco btn_blue" id="btnSave" name="btnSave" value="저장" />
						<input type="button" id="btncancle" value="닫기" class="btn_blue"/>
						<input type="hidden" value="${loginUser.user_id}" class="" id="loginid" name="loginid" style="text-transform: uppercase; width: 70px;" />
						</span>
						
					</div>
					
				</div>
				<div class="content">
					<table id="ecoList"></table>
					<div id="pecoList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		
		var tableId = '';
		var resultData = [];
		var enable_flag = "";
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var cmtypedesc;
		var kRow = 0;
		var kCol = 0;
		
		$(document).ready( function() {
			$( "#ecoList" ).jqGrid( {
				url:'',
				datatype: "json",
				mtype: '',
				postData : getFormData("#application_form"),
				colNames : [ '선택', '', 'Name', 'Description', '작성자', 'ECO 상태', '원인코드CD', '원인코드', '' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 20, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } }, 
				             { name : 'main_code', index : 'main_code', width : 70, hidden : true },
				             { name : 'main_name', index : 'main_name', align : "center", width : 80 },
				             { name : 'states_desc', index : 'states_desc', align : "center", width : 80 },
				             { name : 'main_description', index : 'main_description', width : 190, edittype : "textarea", editoptions : { rows : "3", cols : "40" } },
				             { name : 'created_by', index : 'created_by', width : 160 }, 
				             { name : 'eng_change_order_cause', index : 'eng_change_order_cause', width : 150, hidden : true },
				             { name : 'eng_change_order_cause_desc', index : 'eng_change_order_cause', width : 50 },
				             { name : 'oper', index : 'oper', width : 25, hidden : true } ],
			   	rowNum:100,
			   	cmTemplate: { title: false },
			   	rowList:[100,500,1000],
			   	pager: '#pecoList',
			   	sortname: 'emp_no',
			    viewrecords: true,
			    sortorder: "desc",
			    caption:"ECR",
			    hidegrid: false,
			   	autowidth : true,
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
				beforeEditCell : function( rowid, cellname, value, iRow, iCol) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				afterSaveCell : chmResultEditEnd,
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
			
			//nav button area set width 0 
			//$("#pecoList_left").css("width", 0);
			
			$("#ecoList").jqGrid('navGrid', "#pecoList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			});

			//조회 버튼
			$("#btnSelect").click( function() {
				fn_search();
			} );

			//afterSaveCell oper 값 지정
			function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
				var item = $('#ecoList').jqGrid('getRowData', irowId);
				if (item.oper != 'I')
					item.oper = 'U';
				$('#ecoList').jqGrid("setRowData", irowId, item);
				$("input.editable,select.editable", this).attr("editable", "0");
			};

			//저장버튼
			$("#btnSave").click( function() {

				$('#ecoList').saveCell( kRow, idCol );

				var chmResultRows = [];
				//변경된 row만 가져 오기 위한 함수
				getChangedChmResultData( function( data ) {
					chmResultRows = data;
					
					if( chmResultRows.length == 0 ) {
						alert( "연계할 ECO를 선택해주세요." );
						return;
					}
					
					var dataList = { chmResultList : JSON.stringify(chmResultRows) };
					var url = 'saveEcrToEcoRelated.do';
					var formData = getFormData('#application_form');
					
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData);  
					$.post( url, parameters, function( data ) {
						
						alert(data.resultMsg);
						if( data.result == "success" ) {
							var returnValue = 'ok';
							window.returnValue = returnValue;
							self.close();
						}
					}, "json" );
				} ); 
			} );
			
			//사번 조회 팝업... 버튼
			$("#btnEmpNo").click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do",
						"ECO",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$("#created_by").val( rs[0] );
					$("#created_by_name").val( rs[1] );
					$("#user_group").val( rs[2] );
					$("#user_group_name").val( rs[3] );
				}
			} );
			
			//부서 조회 팝업... 버튼
			$( "#btnGroupNo" ).click( function() {
				var rs = window.showModalDialog( "popUpGroup.do", 
						"ECO",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#user_group" ).val( rs[0] );
					$( "#user_group_name" ).val( rs[1] );
				}
			} );
			
			fn_weekDate( "created_date_start", "created_date_end" );
			
		}); //end of ready Function 
		
		$( function() {
			var dates = $( "#created_date_start, #created_date_end" ).datepicker( {
				prevText: '이전 달',
				nextText: '다음 달',
				monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				dayNames: ['일','월','화','수','목','금','토'],
				dayNamesShort: ['일','월','화','수','목','금','토'],
				dayNamesMin: ['일','월','화','수','목','금','토'],
				dateFormat: 'yy-mm-dd',
				showMonthAfterYear: true,
				yearSuffix: '년',
				onSelect: function( selectedDate ) {
					var option = this.id == "created_date_start" ? "minDate" : "maxDate",
					instance = $( this ).data( "datepicker" ),
					date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
					dates.not( this ).datepicker( "option", option, date );
				}
			} );
		} );
						
		//폼데이터를 Json Arry로 직렬화
		function getFormData(form) {
			var unindexed_array = $(form).serializeArray();
			var indexed_array = {};

			$.map(unindexed_array, function(n, i) {
				indexed_array[n['name']] = n['value'];
			});

			return indexed_array;
		}
		
		function getChangedChmResultData(callback) {
			//가져온 배열중에서 필요한 배열만 골라내기 
			var changedData = $.grep($("#ecoList").jqGrid('getRowData'), function( obj ) {
				return obj.enable_flag == 'Y';
			});
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		}
		
		function fn_search() {
			var sUrl = "popUpEcrToEcoRelatedList.do";
			jQuery("#ecoList").jqGrid( 'setGridParam', {
				url : sUrl,
				mtype: 'POST',
				page : 1,
				datatype: "json",
				postData : getFormData("#application_form")
			} ).trigger( "reloadGrid" );
		}

		$('#btncancle').click(function() {
			self.close();
		});
		
		//작성자 조회조건 삭제 시 작성자명, 부서코드, 부서명 초기화
		function fn_clear() {
			if( $("#created_by").val() == "" ) {
				$("#created_by_name").val( "" );
// 				$("#user_group").val( "" );
// 				$("#user_group_name").val( "" );
			}
		}
		
		//부서 조회조건 삭제 시 부서명 초기화
		function fn_clear2() {
			if ( $( "#user_group" ).val() == "" ) {
				$( "#user_group_name" ).val( "" );
			}
		}
		</script>
	</body>
</html>
