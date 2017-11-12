<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>사원 조회</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<form id="application_form" name="application_form">
			<input type="hidden" name="sType" id="sType" />
			<input type="hidden" id="pageYn" name="pageYn" value="N" />
			<input type="hidden" value="${loginUser.user_id}" id="loginid" name="loginid" />
			
			<div class="topMain" style="margin: 0px;line-height: 45px;">
				<div class="conSearch">
					<select name="sel_condition" id="sel_condition">
						<option value="empname" selected="selected">이름</option>
						<option value="empno">사번</option>
					</select>
					<input type="text" class="" id="txt_condition" name="txt_condition" style="width: 80px; height:25px;  text-transform:uppercase;" />
					<!-- <span id="dateSearch">
					&nbsp;&nbsp;<strong>기간</strong>
					<input type="text" id="created_date_start" name="created_date_start" class="datepicker w70h25" style="height:25px;"/>
					~
					<input type="text" id="created_date_end" name="created_date_end" class="datepicker w70h25"/>
					</span> -->
				</div>
				<div class="button">
					<input type="button" class="btn_blue" id="btnSelect" name="" value="조회"/>
					<input type="button" class="btn_blue" id="btnClose" name="" value="닫기"/>
				</div>
			</div>
			
			<div class="content"  style="float:left; width:99%;">
				<table id="empPopup"></table>
				<div id="pempPopup"></div>
			</div>
		</form>
		<script type="text/javascript">
		var tableId = '';
		var resultData = [];
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var kRow = 0;
		
		var emp_no;
		var user_name;
		var dept_code;
		var dept_name;
		$("#sType").val(window.dialogArguments);
		if(window.dialogArguments == "ITEM"){
			$("#dateSearch").hide();
		}
		$(document).ready( function() {
			fn_all_text_upper();
			
			$( "#empPopup" ).jqGrid( {
				url:'',
				datatype: "json",
				colNames : [ '사번', '이름', '', '부서' ],
				colModel : [ { name : 'emp_no', index : 'emp_no', width : 40, editable : false, align : "center", editrules : { required : true }, editoptions : { size : 5 } }, 
				             { name : 'user_name', index : 'user_name', width : 40, editable : false, align : "center", editoptions : { size : 11 } }, 
				             { name : 'dept_code', index : 'dept_code', width : 40, editable : false, align : "center", editoptions : { size : 11 }, hidden : true }, 
				             { name : 'dept_name', index : 'dept_name', width : 90, editable : false, align : "center", editoptions : { size : 11 } }
				           ],
			   	rowNum:100,
			   	rowList:[100,500,1000],
			   	pager: $('#pempPopup'),
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
				ondblClickRow : function( rowid, iRow, iCol, e ) {
					var rowData = jQuery(this).getRowData( rowid );
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
				loadComplete: function ( data ) {
					var $this = $(this);
					if ( $this.jqGrid('getGridParam', 'datatype') === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if ( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler('reloadGrid');
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid('getGridParam', 'pageServer'),
							records: $this.jqGrid('getGridParam', 'recordsServer'),
							lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
						} );
						this.updatepager(false, true);
					}
				}
			} );
						
			//nav button area set width 0 
			//$( "#pempPopup_left" ).css( "width", 0 );
			
			/* $( "#empPopup" ).jqGrid( 'navGrid', "#pempPopup", {
				search : false,
				edit : false,
				add : false,
				del : false,
				refresh : false
			} ); */
			
			//조회 버튼
			$( "#btnSelect" ).click( function() {
				fn_search();
			} );
			
			
			//닫기 버튼
			$( "#btnClose" ).click( function() {
				self.close();
			} );
			
			
			
			
			fn_weekDate( "created_date_start", "created_date_end" );
			
		}); //end of ready Function 

		//datepicker 설정
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
		
		function fn_search() {
			var sUrl = "infoSearchCreateByList.do";
			jQuery( "#empPopup" ).jqGrid( 'setGridParam', {
				url : sUrl,
				mtype : 'POST',
				page : 1,
				datatype: "json",
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		</script>
	</body>
</html>
