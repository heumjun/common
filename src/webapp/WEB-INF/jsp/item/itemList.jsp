<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item 조회</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">

			<form id="application_form" name="application_form">
				<input type="hidden" id="download_token_value_id"/>
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					Search Item
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>

<table class="searchArea conSearch">
	<%-- <col width="120"/>
	<col width="210"/> --%>
	<col width="100"/>
	<col width="230"/>
	<col width="120"/>
	<col width="210"/>
	<col width="120"/>
	<col width="120"/>
	<col width="*" style="min-width:250px"/>
	<tr>
		<!-- <th class="bdl_no">ITEM TYPE</th>
		<td>
		<input type="text" class="toUpper" id="item_type_code" name="item_type_code" style="width: 30px;" onkeyup="fn_clear();" maxlength="10" />&nbsp;
		<input type="text" class="notdisabled" id="item_type" name="item_type" style="width: 100px; margin-left: -5px;" readonly="readonly" />
		<input type="button" value="검색" id="btnSearchCatalog" class="btn_gray2" />
		</td> -->
	
		<th>ITEM CODE</th>
		<td>
		<input type="text" id="item_code" name="item_code" class="toUpper required" style="width: 200px;" alt="ITEM CODE"/>
		</td>
		
		<th>ITEM DESCRIPTION</th>
		<td>
		<input type="text" id="item_desc" name="item_desc" class="toUpper" style="width: 150px;" />
		</td>
	
		<th>CATEGORY</th>
		<td style="border-right:none;">
		<input type="text" id="item_category" name="item_category" class="toUpper"/>
		</td>
		
		<td class="bdl_no"  style="border-left:none;">
			<div class="button endbox">
			<c:if test="${userRole.attribute1 == 'Y'}">
			<input type="button" value="조회" id="btnSearch" class="btn_blue"/>
			</c:if>
			<c:if test="${loginUser.admin_yn == 'Y'}">
			<input type="button" value="상태취소" id="btnCancel" class="btn_blue"/>
			</c:if>
			<c:if test="${userRole.attribute5 == 'Y'}">
				<input type="button" id="btnExcelDownLoad" value="Excel출력"   class="btn_blue"/>
			</c:if>
			
			</div>
		</td>	
		</tr>
		</table>
<table class="searchArea2">
	<col width="100"/>
	<col width="210"/>
	<col width="100"/>
	<col width="*"/>
	
	<tr>
		<th>생성일자</th>
		<td>
			<input type="text" id="created_date_start" name="created_date_start" class="datepicker" style="width: 70px;"/>
			~
			<input type="text" id="created_date_end" name="created_date_end" class="datepicker" style="width: 70px;"/>
		</td>
	
		<th>생성자</th>
		<td style="border-right:none;">
			<input type="text" id="created_by" name="created_by" class="toUpper" style="width: 50px;" onkeyup="fn_clear2();" />&nbsp;
			<input type="text" class="notdisabled" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
			<input type="button" id="btn_emp_no" name="btn_emp_no" value="검색" class="btn_gray2" />&nbsp;&nbsp;
			<input type="text" class="notdisabled" id="user_group" name="user_group" readonly="readonly" style="width: 50px;" />&nbsp;
			<input type="text" class="notdisabled" id="user_group_name" name="user_group_name" readonly="readonly" style="margin-left: -5px; width: 180px;" />
		</td>
	</tr>
</table>


				<!--
				<div class="conSearch">
						<div class="conCaption70">Item Type</div>
						<div class="conInput180">
							<input type="text" class="required" id="item_type_code" name="item_type_code" style="width: 30px;" onkeyup="fn_clear();" maxlength="10" />
							<input type="text" class="notdisabled" id="item_type" name="item_type" style="width: 100px; margin-left: -5px;" readonly="readonly" />
							<input type="button" value=".." id="btnSearchCatalog" />
						</div>
						<div class="conCaption70">Item Code</div>
						<div class="conInput130">
							<input type="text" id="item_code" name="item_code" class="toUpper" style="width: 70px;" />
						</div>
						<div class="conCaption100">Item Description</div>
						<div class="conInput130">
							<input type="text" id="item_desc" name="item_desc" class="toUpper" style="width: 70px;" />
						</div>
						<div class="conCaption70">Category</div>
						<div class="conInput130">
							<input type="text" id="item_category" name="item_category" class="toUpper" style="width: 70px;" />
						</div>
						<div class="conBr"></div>
						<div class="conCaption70">생성일자</div>
						<div class="conInput180">
							<input type="text" id="created_date_start" name="created_date_start" class="datepicker required" style="width: 70px;"/>
							~
							<input type="text" id="created_date_end" name="created_date_end" class="datepicker required" style="width: 70px;"/>
						</div>
						<div class="conCaption70">생성자</div>
						<div class="conInput400">
							<input type="text" id="created_by" name="created_by" class="toUpper" style="width: 50px;" onkeyup="fn_clear2();" />
							<input type="text" class="notdisabled" id="created_by_name" name="created_by_name" readonly="readonly" style="width: 50px; margin-left: -5px;" />
							<input type="button" id="btn_emp_no" name="btn_emp_no" value=".." />
							<input type="text" class="notdisabled" id="user_group" name="user_group" readonly="readonly" style="width: 50px;" />
							<input type="text" class="notdisabled" id="user_group_name" name="user_group_name" readonly="readonly" style="margin-left: -5px;" />
						</div>
					</div>-->
					<!--<div class="button">
						<input type="button" value="상태 취소" id="btnCancel" />
						<input type="button" value="조회" id="btnSearch" />
					</div>-->
				<div class="content" >
					<table id="itemList"></table>
					<div id="btn_itemList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		
		var change_item_row 	= 0;
		var change_item_row_num = 0;
		var change_item_col  	= 0;
		
		var resultData = [];
		
		var sUrl = 'searchItemList.do';
		
		var lodingBox;
		
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			fn_init();
			
			$( "#itemList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : '',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', 'Item Code', 'Item Desc', 'Item Type', 'Item Catalog', 'ShipType', 'UOM', 'Weight',
				             'attr1', 'attr2', 'attr3', 'attr4', 'attr5', 
				             'attr6', 'attr7', 'attr8', 'attr9', 'attr10', 
				             'attr11', 'attr12', 'attr13', 'attr14', 'attr15',
				             'Cable Length', 'Cable Type', 'Cable Outdia', 'Can Size', 'STXSVR', 'Thinner Code', 'Stx Standard', 'Paint Code',
				             'Item Category','dwg','Originateddate',
				             'Modified Date', 'Originator', '상태', 'OPER' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
				             { name : 'item_code', index : 'item_code', align : 'left', width : 100 },
				             { name : 'item_desc', index : 'item_desc', align : 'left', width : 300 },
				             { name : 'item_type', index : 'item_type', align : 'center', width : 70, hidden : true },
				             { name : 'item_catalog', index : 'item_catalog', align : 'center', width : 80 },
				             { name : 'ship_type', index : 'ship_type', align : 'center', width : 70, hidden : true },
				             { name : 'uom', index : 'uom', align : 'center', width : 40 },
				             { name : 'item_weight', index : 'item_weight', align : 'right', width : 50 },
				             
				             { name : 'attr1', index : 'attr1', align : 'left', width : 100 },
				             { name : 'attr2', index : 'attr2', align : 'left', width : 100 },
				             { name : 'attr3', index : 'attr3', align : 'left', width : 100 },
				             { name : 'attr4', index : 'attr4', align : 'left', width : 100 },
				             { name : 'attr5', index : 'attr5', align : 'left', width : 100 },
				             
				             { name : 'attr6', index : 'attr6', align : 'left', width : 100 },
				             { name : 'attr7', index : 'attr7', align : 'left', width : 100 },
				             { name : 'attr8', index : 'attr8', align : 'left', width : 100 },
				             { name : 'attr9', index : 'attr9', align : 'left', width : 100 },
				             { name : 'attr10', index : 'attr10', align : 'left', width : 100 },
				             
				             { name : 'attr11', index : 'attr11', align : 'left', width : 100 },
				             { name : 'attr12', index : 'attr12', align : 'left', width : 100 },
				             { name : 'attr13', index : 'attr13', align : 'left', width : 100 },
				             { name : 'attr14', index : 'attr14', align : 'left', width : 100 },
				             { name : 'attr15', index : 'attr15', align : 'left', width : 100 },
				             
				             { name : 'cable_length', index : 'cable_length', align : 'left', width : 100 },
				             { name : 'cable_type', index : 'cable_type', align : 'left', width : 100 },
				             { name : 'cable_outdia', index : 'cable_outdia', align : 'left', width : 100 },
				             { name : 'can_size', index : 'can_size', align : 'left', width : 100 },
				             { name : 'stxsvr', index : 'stxsvr', align : 'left', width : 100 },
				             { name : 'thinner_code', index : 'thinner_code', align : 'left', width : 100 },
				             { name : 'stx_standard', index : 'stx_standard', align : 'left', width : 100 ,hidden : true },
				             { name : 'paint_code', index : 'paint_code', align : 'left', width : 100 },
				             
				             { name : 'item_category', index : 'item_category', align : 'center', width : 90 },
				             { name : 'draw', index : 'draw', align : 'center', width : 60 },
				             { name : 'originated_date', index : 'originated_date', align : 'center', width : 120, hidden : true },
				             { name : 'modified_date', index : 'modified_date', align : 'center', width : 120 },
				             { name : 'originator', index : 'originator', align : 'left', width : 230 },
				             { name : 'states', index : 'states', align : 'left', width : 100 } ,
				             { name : 'oper', index : 'oper', width : 100, hidden : true }],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				pager : $("#btn_itemList"),
				viewrecords : true,
				sortorder : "desc",
				//shrinkToFit : false,
				autowidth : true,
				rownumbers:true,
				height : objectHeight,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				emptyrecords : '데이터가 존재하지 않습니다.',
				imgpath : 'themes/basic/images',
				multiselect : false,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
					id : "item_code"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if (rowid != null) {
						change_item_col  	= iCol;
						change_item_row_num = iRow;

						if (change_item_row != rowid) {
							change_item_row = rowid;
						}
					}
					
					idRow = rowid;
	             	idCol = iCol;
	             	kRow  = iRow;
	             	kCol  = iCol;
					
				},
				onPaging : function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					//$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					//$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
					
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
			    	 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
			     	 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
			     	 */ 
//	 				$(this).jqGrid("clearGridData");
			
			    	/* this is to make the grid to fetch data from server on page click*/
//	 	 			$(this).setGridParam({datatype: 'json', postData:{pageYn:'Y'}}).triggerHandler("reloadGrid");
	            	var pageIndex         = parseInt($(".ui-pg-input").val());
	 	   			var currentPageIndex  = parseInt($("#itemList").getGridParam("page"));// 페이지 인덱스
	 	   			var lastPageX         = parseInt($("#itemList").getGridParam("lastpage"));  
	 	   			var pages = 1;
	 	   			var rowNum 			  = 100;

	 	   			/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
	 	   			* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
	 	   			* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
	 	   			*/ 
	 	   			/* this is to make the grid to fetch data from server on page click*/
	 	   			if (pgButton == "user") {
	 	   				if (pageIndex > lastPageX) {
	 	   			    	pages = lastPageX
	 	   			    } else pages = pageIndex;
	 	   				
	 	   				rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'next_btn_itemList'){
	 	   				pages = currentPageIndex+1;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			} 
	 	   			else if(pgButton == 'last_btn_itemList'){
	 	   				pages = lastPageX;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'prev_btn_itemList'){
	 	   				pages = currentPageIndex-1;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
	 	   			else if(pgButton == 'first_btn_itemList'){
	 	   				pages = 1;
	 	   			rowNum = $('.ui-pg-selbox option:selected').val();
	 	   			}
		 	   		else if(pgButton == 'records') {
		   				rowNum = $('.ui-pg-selbox option:selected').val();                
		   			}
	 	   			//$(this).jqGrid("clearGridData");
	 	   			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid");
					
				},
				onCellSelect : function( rowid, cellname, value, iRow, iCol ) {
					if ( cellname == '2' ) {
							var item = $( this ).jqGrid( 'getRowData', rowid );
							var param = new Array();
							param[0] = item.item_code;
							param[1] = item.item_catalog;

							var sURL = "popUpItemDetail.do?p_item_code="+item.item_code+"&p_item_catalog="+item.item_catalog;
							var popOptions = "width=800, height=810, resizable=no, scrollbars=no, status=no";
							var popupWin = window.open(sURL, "popUpItemDetail", popOptions);
							setTimeout(function(){
								popupWin.focus();
							 }, 100);
							
							/* window.showModalDialog( "popUpItemDetail.do",
									param,
								"dialogWidth:500px; dialogHeight:590px; center:on; scroll:off; status:off" ); */
					} 
				},
				gridComplete : function() {
					var rows = $( "#itemList" ).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						$( "#itemList" ).jqGrid( 'setCell', rows[i], 'item_code', '', { cursor : 'pointer', background : 'pink' } );
						$( "#itemList" ).jqGrid( 'setCell', rows[i], 'oper', 'U');
					}
				},
				loadComplete : function( data ) {
					var $this = $(this);
					if ( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype : 'local',
							data : data.rows,
							pageServer : data.page,
							recordsServer : data.records,
							lastpageServer : data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if ( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page : $this.jqGrid( 'getGridParam', 'pageServer' ),
							records : $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage : $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						
						this.updatepager( false, true );
					}
				},
				ondblClickRow : function( rowid, iCol, cellcontent, e ) {
					
					$( "#itemList" ).saveCell(kRow, idCol );
					
					var rowData = $( "#itemList" ).getRowData(rowid);
					var dwg_file_name = rowData['dwg_file_name'];
					
					if(rowData['draw'] == 'Y') {
						dwgView(rowData['item_code']);
					}
					
				}
			} );
			
			//grid resize
		    fn_gridresize( $(window), $( "#itemList" ), 65 );
		} );
		
		
		function fn_init() {
			$( "#btnSearchCatalog" ).click( function() {
				popUpItemType();
			} );
			
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );
			
			$( "#btnCancel" ).click( function () {
				fn_Cancel();
			} );
			
			//사번 조회 팝업... 버튼
			$( "#btn_emp_no" ).click( function() {
				var rs = window.showModalDialog( "popUpSearchCreateBy.do?", 
						"ITEM",
						"dialogWidth:500px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#created_by" ).val( rs[0] );
					$( "#created_by_name" ).val( rs[1] );
					$( "#user_group" ).val( rs[2] );
					$( "#user_group_name" ).val( rs[3] );
				}
			} );
			// 엑셀 다운로드 버튼 클릭이벤트
			$("#btnExcelDownLoad").click( function() {
				if( $( "#item_code" ).val() == "" ) {
	 				alert( "ITEM CODE는 필수입력입니다." );
	 				$( "#item_code" ).focus();
	 				return;
	 			}
				fn_downloadStart();
				fn_excelDownload();
			});

				// 			fn_register();

				// 			fn_weekDate( "created_date_start", "created_date_end" );
			} // end function fn_init()
			// 엑셀 다운로드 서비스 호출
			function fn_excelDownload() {
				if(confirm('최대 10000건까지 출력 됩니다.\n진행 하시겠습니까?') != 0) {
					$('#application_form').attr('action', 'searchItemExcelExport.do').submit();
				}
			}
			$(function() {
				var dates = $("#created_date_start, #created_date_end")
						.datepicker(
								{
									prevText : '이전 달',
									nextText : '다음 달',
									monthNames : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월',
											'12월' ],
									monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월',
											'11월', '12월' ],
									dayNames : [ '일', '월', '화', '수', '목', '금', '토' ],
									dayNamesShort : [ '일', '월', '화', '수', '목', '금', '토' ],
									dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
									dateFormat : 'yy-mm-dd',
									showMonthAfterYear : true,
									yearSuffix : '년',
									changeYear: true,
									changeMonth : true,
									onSelect : function(selectedDate) {
										var option = this.id == "created_date_start" ? "minDate" : "maxDate", instance = $(
												this).data("datepicker"), date = $.datepicker.parseDate(
												instance.settings.dateFormat || $.datepicker._defaults.dateFormat,
												selectedDate, instance.settings);
										dates.not(this).datepicker("option", option, date);
									}
								});
			});

			//조회
			function fn_search() {
				
				$("input[type=text]").each(function(){
					$(this).val($(this).val().toUpperCase());
				});
				
				if ( !fn_require_chk() ) {
					return;
				}
				
				// 			if( $( "#item_type_code" ).val() == "" ) {
				// 				alert( "Item Type은 필수입력입니다." );
				// 				$( "#item_type_code" ).focus();
				// 				return;
				// 			}

				// 			if( $( "#created_date_start" ).val() == "" ) {
				// 				alert( "생성일자는 필수입력입니다." );
				// 				$( "#created_date_start" ).focus();
				// 				return;
				// 			}

				// 			if( $( "#created_date_end" ).val() == "" ) {
				// 				alert( "생성일자는 필수입력입니다." );
				// 				$( "#created_date_end" ).focus();
				// 				return;
				// 			}
				var searchFlag = false;
				
				if ($("#item_type_code").val() != "") {
					searchFlag = true;
				}
				if ($("#item_code").val() != "") {
					searchFlag = true;
				}
				if ($("#item_desc").val() != "") {
					searchFlag = true;
				}
				if ($("#item_category").val() != "") {
					searchFlag = true;
				}
				if ($("#created_date_start").val() != "") {
					searchFlag = true;
				}
				if ($("#created_date_end").val() != "") {
					searchFlag = true;
				}
				if ($("#created_by").val() != "") {
					searchFlag = true;
				}

				if (!searchFlag) {
					alert("조회 조건을 최소 1개 이상 지정바랍니다.");
					return;
				}
				$("#itemList").jqGrid('setGridParam', {
					mtype : 'POST',
					url : sUrl,
					page : 1,
					datatype : 'json',
					postData : fn_getFormData("#application_form")
				}).trigger("reloadGrid");
			}

			function popUpItemType() {
				var args = {
					p_code_find : $("#item_type_code").val()
				};

				var rs = window.showModalDialog("popUpPartFamilyInfo.do", args,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off");

				if (rs != null) {
					$("#item_type_code").val(rs[0]);
					$("#item_type").val(rs[1]);
				}
			}

			//item type code 삭제 시 item code desc 초기화
			function fn_clear() {
				if ($("#item_type_code").val() == "") {
					$("#item_type").val("");
				}
			}

			//작성자 조회조건 삭제 시 작성자명 초기화
			function fn_clear2() {
				if ($("#created_by").val() == "") {
					$("#created_by_name").val("");
					$("#user_group").val("");
					$("#user_group_name").val("");
				}
			}

			//접속자 정보 세팅
			function fn_register() {
				var url = 'selectUserInfo.do';
				var formData = fn_getFormData('#application_form');

				$.post(url, formData, function(data) {
					if (data.length != 0) {
						$("#created_by").val(data[0].emp_no);
						$("#created_by_name").val(data[0].user_name);
						$("#user_group").val(data[0].dept_code);
						$("#user_group_name").val(data[0].dept_name);
					}
				}, "json");
			}

			function fn_Cancel() {
				$('#itemList').saveCell(change_item_row_num, change_item_col);

				var chmResultRows = [];
				getChangedChmResultData(function(data) {
					lodingBox = new ajaxLoader($('#mainDiv'), {
						classOveride : 'blue-loader',
						bgColor : '#000',
						opacity : '0.3'
					});
					chmResultRows = data;

					if (chmResultRows.length == 0) {
						alert("선택된 Item이 없습니다.");
						return;
					}

					//저장 유무 체크
					if (!confirm("Item State를 Cancel로 처리 하시겠습니까?")) {
						return;
					}

					for (var k = 0; k < chmResultRows.length; k++) {
						if (chmResultRows[k].states == "Cancel") {
							alert("이미 Cancel된 Item이 있습니다.");
							return;
						}
					}

					var dataList = {
						chmResultList : JSON.stringify(chmResultRows)
					};

					var url = 'updateItemStatesCancel.do';
					var formData = fn_getFormData('#application_form');
					var parameters = $.extend({}, dataList, formData);

					$.post(url, parameters, function(data2) {
						alert(data2.resultMsg);
						if (data2.result == 'success') {
							fn_search();
						}
					}, "json").error(function() {
						alert("시스템 오류입니다.\n전산담당자에게 문의해주세요.");
					}).always(function() {
						lodingBox.remove();
					});
				});
			}

			function getChangedChmResultData(callback) {
				var changedData = $.grep($("#itemList").jqGrid('getRowData'), function(obj) {
					return obj.enable_flag == 'Y';
				});

				callback.apply(this, [ changedData.concat(resultData) ]);
			}
			
			function fn_require_chk() {
				var result = true;
				var message = "";

				var item_code = $( "#item_code" ).val();
				
				if( item_code.length <= 3 ) {
					result = false;
					message = "ITEM_CODE는 최소 3자리 이상 입력하셔야 됩니다.";
				}

				if( item_code == '' ) {
					result = false;
					message = "ITEM_CODE는 필수입력입니다.";
				}
				
				if( !result ) {
					alert( message );
				}

				return result;
			}
			
			//도면 뷰어
			var dwgView = function(item_code){	

				var sURL = "searchItemDwgPopupView.do?mode=dwgChkView&p_item_code="+item_code;
				form = $('#application_form');
				form.attr("action", sURL);
				var myWindow = window.open(sURL,"listForm","height=500,width=1200,top=150,left=200,location=no");
					    
				form.attr("target","listForm");
				form.attr("method", "post");	
						
				myWindow.focus();
				form.submit();
		    }
		</script>
	</body>
</html>
