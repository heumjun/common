<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Paint USC</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" name="ship_type" id="ship_type" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="subtitle">
					Paint USC
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide">
						<img src="/images/content/yellow.gif" /> 필수입력사항
					</span>
				</div>
				<table class="searchArea conSearch">
					<col width="80">
					<col width="120">
					<col width="80">
					<col width="120">
					<col width="50">
					<col width="120">
					<col width="80">
					<col width="120">
					<col width="80">
					<col width="120">
					<col width="80">
					<col width="">
					<tr>
						<th>대표호선</th>
						<td>
							<input type="text" id="p_delegate_project_no" name="p_delegate_project_no" class="required w50h25" style="width: 50px;" />
							<input type="button" id="btn_delegate_project_no" name="btn_delegate_project_no" class="btn_gray2" value="검색" />
						</td>
						<th>PROJECT</th>
						<td>
							<input type="text" id="p_project_no" name="p_project_no" class="required w50h25" style="width: 50px;" />
							<input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" />
<!-- 							<select id="p_project_no" name="p_project_no" class="required" onchange="fn_get_ship_type(this.value)" style="text-transform: uppercase; width: 65px;"> -->
<!-- 								<option value=''>선택</option> -->
<!-- 							</select> -->
						</td>
						<th>Level</th>
						<td>
							<input type="radio"	 name="p_level" value="0" id="all" /><label for="all">ALL</label>
							&nbsp;&nbsp;
							<input type="radio"  name="p_level" value="1" id="top_level" checked="checked" /><label for="top_level">1 Level</label>
						</td>
						<th>Item Code</th>
						<td>
							<input type="text" class="wid80" id="p_item_code" name="p_item_code" style="text-transform: uppercase; width: 100px;" />
						</td>
						<th>ATTR.1</th>
						<td>
							<input type="text" class="wid80" id="p_bom1" name="p_bom1" class="wid80" style="text-transform: uppercase;" />
						</td>
						<th>ATTR.2</th>
						<td style="border-right: none;">
							<input type="text" class="wid80" id="p_bom2" name="p_bom2" style="" />
							<div class="button endbox">
								<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" class="btn_blue" value="조회" id="btnSearch" name="btnSearch" />
								</c:if>
							</div>
						</td>
						
					</tr>
					</table>
					<table class="searchArea2">
					<tr>
						<td width="">
							<div id="divSeries" style="float: left;  margin-right: 5px;"></div>
						</td>
						<th width="100px">ECO NO.</th>
						<td width="180px">
								<input type="text" name="eco_main_name" id="eco_main_name" class="wid80" />
								<input type="button" class="btn_blue" value="ECO 추가" id="btnEcoAdd" />
						</td>
						<td width="170px">
							<div class="button endbox">
								
								<c:if test="${userRole.attribute2 == 'Y'}">
								<input type="button" class="btn_blue" value="WBS 분리" id="btnWbsReAdd" name="btnWbsReAdd" />
								</c:if>
<%-- 								<c:if test="${userRole.attribute3 == 'Y'}"> --%>
<!-- 								<input type="button" class="btn_blue" value="WBS 삭제" id="btnWbsDel" name="btnWbsDel" /> -->
<%-- 								</c:if> --%>
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" class="btn_blue" value="JOB 편집" id="btnJobEdit" name="btnJobEdit" />
								</c:if>
								
							</div>
						</td>
					</tr>
				</table>
				<div class="content">
					<table id="itemSearchList"></table>
					<div id="btn_itemSearchList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow = 0;
		var idCol = 0;
		var nRow = 0;
		var divCloseFlag = false;
		var kRow = 0;
		var resultData = [];
		var loadingBox;
		var menuId = '';

		var is_hidden = true;

		$(document).ready( function() {
			fn_all_text_upper(); //입력값을 대문자로 변경하여 저장

			var objectHeight = gridObjectHeight(1);

			$( "#itemSearchList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				editUrl : 'clientArray',
				colNames : [ 'states', 'Action', 'Level', 'Project No', '모품목', '자품목', 'Catalog', '도면 No', 'ECO No', 'ECO State', 'emp_no', 'QTY', 'Find Number', 'Top Item', 'Top Catalog', 'project_no', 'bom1', 'bom2', 'bom3', 'bom4', 'bom5', 'bom6', 'bom7', 'bom8', 'bom9', 'bom10', 'bom11', 'bom12', 'bom13', 'bom14', 'bom15', '생성자', '생성일자', '수정자', '수정일자', 'oper' ],
				colModel : [ { name : 'states', index : 'states', width : 100, align : "left", hidden : is_hidden }, 
				             { name : 'states_desc', index : 'states_desc', width : 50, align : "center" }, 
				             { name : 'level_no', index : 'level_no', width : 50, align : "center" }, 
				             { name : 'connect_project_no', index : 'connect_project_no', width : 120, align : "left" }, 
				             { name : 'mother_code', index : 'mother_code', width : 100, align : "left" }, 
				             { name : 'item_code', index : 'item_code', width : 100, align : "left" }, 
				             { name : 'item_catalog', index : 'item_catalog', width : 80, align : "center" }, 
				             { name : 'dwg_no', index : 'dwg_no', width : 60, align : "center" }, 
				             { name : 'eco_no', index : 'eco_no', width : 70, align : "center", classes : "handcursor" }, 
				             { name : 'eco_state', index : 'eco_state', width : 80, align : "left" }, 
				             { name : 'emp_no', index : 'emp_no', width : 100, align : "left", hidden : is_hidden }, 
				             { name : 'qty', index : 'qty', width : 50, align : "right" }, 
				             { name : 'findnumber', index : 'findnumber', width : 80, align : "right", hidden : is_hidden }, 
				             { name : 'top_item', index : 'top_item', width : 80, align : "right", hidden : is_hidden }, 
				             { name : 'top_catalog', index : 'top_catalog', width : 80, align : "right", hidden : is_hidden }, 
				             { name : 'project_no', index : 'project_no', width : 80, align : "right", hidden : is_hidden }, 
				             { name : 'bom1', index : 'bom1', width : 60, align : "left" }, 
				             { name : 'bom2', index : 'bom2', width : 60, align : "left" }, 
				             { name : 'bom3', index : 'bom3', width : 60, align : "left" }, 
				             { name : 'bom4', index : 'bom4', width : 60, align : "left" }, 
				             { name : 'bom5', index : 'bom5', width : 60, align : "left" }, 
				             { name : 'bom6', index : 'bom6', width : 60, align : "left" }, 
				             { name : 'bom7', index : 'bom7', width : 60, align : "left" }, 
				             { name : 'bom8', index : 'bom8', width : 60, align : "left" }, 
				             { name : 'bom9', index : 'bom9', width : 60, align : "left" }, 
				             { name : 'bom10', index : 'bom10', width : 60, align : "left" }, 
				             { name : 'bom11', index : 'bom11', width : 60, align : "left" }, 
				             { name : 'bom12', index : 'bom12', width : 60, align : "left" }, 
				             { name : 'bom13', index : 'bom13', width : 60, align : "left" }, 
				             { name : 'bom14', index : 'bom14', width : 60, align : "left" }, 
				             { name : 'bom15', index : 'bom15', width : 60, align : "left" }, 
				             { name : 'create_by', index : 'create_by', width : 220, align : "left" }, 
				             { name : 'create_date', index : 'create_date', width : 80, align : "center" }, 
				             { name : 'modify_by', index : 'modify_by', width : 220, align : "left" }, 
				             { name : 'modify_date', index : 'modify_date', width : 80, align : "center" }, 
				             { name : 'oper', index : 'oper', width : 50, align : "center", hidden : is_hidden } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "",
				height : objectHeight,
				autowidth : true,
				rownumbers : true,
				multiselect : true,
				hidegrid : false,
				rowNum : -1,
				//shrinkToFit : false,
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				emptyrecords : '데이터가 존재하지 않습니다. ',
				pager : $('#btn_itemSearchList'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
				},
				afterSaveCell : chmResultEditEnd,
				imgpath : 'themes/basic/images',
				onSelectRow : function( rowid, cellname, value, iRow, iCol ) {
				},
				gridComplete : function() {
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					var cm = $( "#itemSearchList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $("#itemSearchList").jqGrid( "getRowData", rowid );
					
					if ( colName['index'] == "eco_no" ) {
		              	var ecoName = item.eco_no;
		              	
		              //메뉴ID를 가져오는 공통함수 
		              	getMenuId("eco.do", callback_MenuId);
		              	
		              	if( ecoName != "" ) {
							var sUrl = "eco.do?ecoName=" + ecoName+"&popupDiv=Y&menu_id=" + menuId;
							window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:650px; center:on; scroll:off; status:off");
		              	}
					}
				}
			} );

			//grid resize
			fn_gridresize($(window), $( "#itemSearchList" ),37);

			//대표호선 만들기
// 			fn_selDelegateProjectNosearch();

			//조회 버튼
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );

			//JOB 편집
			$( "#btnJobEdit" ).click( function() {
				fn_popup_job_edit();
			} );

			//eco 추가 생성 버튼
			$("#btnEcoAdd").click(function() {
				var stste = ecoCheck();
				ecoAddStateFun();
			});

			/* //eco 삭제 버튼
			$("#btnEcoDel").click(function() {
				if (confirm("ECO를 삭제하시겠습니까?") != 0) {
					addEcoDel('del');
				}
			}); */
			
			/* $( "#btnWbsDel" ).click( function () {
				fn_wbs_del();
			} ); */
			
			$( "#btnWbsReAdd" ).click( function () {
				fn_wbs_re_add();
			} );
			
			$( "#p_delegate_project_no" ).change( function () {
				$( "#p_project_no" ).val( "" );
			} );
			
			$( "#p_project_no" ).change( function () {
				fn_get_ship_type( $(this).val() );
			} );
			
			$( "#btn_delegate_project_no" ).click( function () {
				var rs = window.showModalDialog( "popUpDelegateProjectNo.do",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_delegate_project_no" ).val( rs[0] );
					$( "#p_project_no" ).val( "" );
				}
			} );
			
			$( "#btn_project_no" ).click( function () {
				if( $( "#p_delegate_project_no" ).val() == "" ) {
					alert( "대표호선을 선택 후 조회해주세요." );
					$( "#btn_delegate_project_no" ).focus();
					return;
				}
				var rs = window.showModalDialog( "popUpProjectNo.do",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_project_no" ).val( rs[0] );
					fn_get_ship_type( rs[0] );
				}
			} );
			

		}); //end of ready Function
		
		
		function fn_wbs_re_add() {
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

			$( '#itemSearchList' ).saveCell( kRow, idCol );

			var chmResultRows = [];
			var selectProject = $( "#p_project_no" ).val();
			if( confirm( "선택한 WBS를 PROJECT " + selectProject + "로 분리하시겠습니까?" ) ) {
				var arrayData = [];
				var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

				if( selIDs.length == 0 ) {
					alert( "분리할 WBS를 선택해주세요." );
					loadingBox.remove();
					return;
				}

				//선택된 row 추출
				$.each( selIDs, function( index, value ) {
					arrayData[index] = $( "#itemSearchList" ).jqGrid( 'getRowData', value );
				} );
				
				chmResultRows = arrayData;
				var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
				
				var url = 'insertPaintWbsReCreate.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				
				$.post( url, parameters, function( data ) {
					alert( data.resultMsg );
					
					if ( data.result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();
				} );
			} else {
				loadingBox.remove();
			}
		}
		
		/* function fn_wbs_del() {
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

			$( '#itemSearchList' ).saveCell( kRow, idCol );

			var chmResultRows = [];
			if( confirm( "정말로 삭제하시겠습니까?" ) ) {
				var arrayData = [];
				var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

				if( selIDs.length == 0 ) {
					alert( "삭제할 WBS를 선택해주세요." );
					return;
				}

				//선택된 row 추출
				$.each( selIDs, function( index, value ) {
					arrayData[index] = $( "#itemSearchList" ).jqGrid( 'getRowData', value );
				} );
				
				chmResultRows = arrayData;
				var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
				
				var url = 'deletePaintWbs.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				
				$.post( url, parameters, function( data ) {
					var msg = "";
					var result = "";
					for ( var keys in data) {
						for ( var key in data[keys]) {
							if (key == 'Result_Msg') {
								msg = data[keys][key];
							}

							if (key == 'result') {
								result = data[keys][key];
							}
						}
					}
					
					alert( msg );
					
					if ( result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();
				} );
			} else {
				loadingBox.remove();
			}
		} */
		
		//ship type 조회
		function fn_get_ship_type( project_no ) {
			var url = 'infoProjectShipType.do';
			var formData = { p_selectProjectNo : project_no };
			$.post( url, formData, function( data ) {
				$( "#ship_type" ).val( data.ship_type );
			}, "json" );
		}

		//조회
		function fn_search() {
			if ( $( "#p_delegate_project_no" ).val() == "" ) {
				alert( "대표호선를 먼저 선택하세요." );
				$( "#p_delegate_project_no" ).focus();
				return;
			}
			
			
			if ( $( "#p_project_no" ).val() == "" ) {
				alert( "Project를 먼저 선택하세요." );
				$( "#p_project_no" ).focus();
				return;
			}
			
	
			var sUrl = "infoPaintUscList.do";
			$( "#itemSearchList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}

		//JOB 편집 팝업
		function fn_popup_job_edit() {
			var rowid = $( '#itemSearchList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#itemSearchList' ).jqGrid( 'getRowData', rowid );
			var ship_type = $( "#ship_type" ).val();

			if ( item.top_item == "" || item.top_item == undefined ) {
				alert( "하위구조를 생성할 WBS를 선택해 주세요." );
				return;
			}

			var rs = window.showModalDialog( "popUpPaintJobEdit.do?top_item="
						+ item.top_item
						+ "&ship_type="
						+ ship_type
						+ "&top_catalog="
						+ item.top_catalog
						+ "&project_no="
						+ item.project_no
						+ "&menu_id=${menu_id}",
					window,
					"dialogWidth:1300px; dialogHeight:680px; center:on; scroll:off; states:off" );
		}
		
		//설정된 값의 데이터만 리턴
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#itemSearchList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );

			callback.apply( this, [ changedData.concat( resultData ) ] );
		}
		
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irow, cellName ) {
			var item = $( '#itemSearchList' ).jqGrid( 'getRowData', irow );
			if ( item.oper != 'I' ) item.oper = 'U';
			$( '#itemSearchList' ).jqGrid( "setRowData", irow, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}

		//eco 연결 가능 여부 판단 확인
		function ecoAddStateFun() {
			var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

			if( selIDs.length == 0 ) {
				alert( "ECO를 추가할 대상을 선택해주세요." );
				return;
			}
			
			var dialog = $( '<p>ECO를 연결합니다.</p>' ).dialog( {
				buttons : {
					"조회" : function() {
						var rs = window.showModalDialog( "popUpECORelated.do?save=bomAddEco&ecotype=5",
								window,
								"dialogWidth:1100px; dialogHeight:460px; center:on; scroll:off; states:off" );
						if ( rs != null ) {
							$( "#eco_main_name" ).val( rs[1] );
							
							// eco 저장
							addEcoRow();
						}
						dialog.dialog( 'close' );
					},
					"생성" : function() {
						ecoCheck();
						dialog.dialog( 'close' );
						addEcoResultRow();

					},
					"Cancel" : function() {
						dialog.dialog( 'close' );
					}
				}
			} );
		}
		
		//ECO 저장 
		function addEcoRow(stateEco) {
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

			$( '#itemSearchList' ).saveCell( kRow, idCol );

			var chmResultRows = [];
			var arrayData = [];
			var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

			if( selIDs.length == 0 ) {
				alert( "ECO를 추가할 대상을 선택해주세요." );
				return;
			}

			//선택된 row 추출
			$.each( selIDs, function( index, value ) {
				arrayData[index] = $( "#itemSearchList" ).jqGrid( 'getRowData', value );
			} );
			
			chmResultRows = arrayData;
			
			
			var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
			
			var url = 'savePaintWbsEcoAdd.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			
			$.post( url, parameters, function( data ) {
				alert( data.resultMsg );
				
				if ( data.result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		

		function fn_require_chk(stateEco) {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#itemSearchList" ).jqGrid('getDataIDs');

			for (var i = 0; i < ids.length; i++) {

				var oper = $( "#itemSearchList" ).jqGrid('getCell', ids[i],
						'oper');
				
				if (oper == 'I' || oper == 'U' || oper == 'D' || oper == 'Y') {

					var eco_state = $( "#itemSearchList" ).jqGrid('getCell',
							ids[i], 'eco_state');
					var eco_no = $( "#itemSearchList" ).jqGrid('getCell', ids[i],
							'eco_no');
					
					if (!(eco_state == undefined || eco_state == null || eco_state == '')) {
						if (!(eco_state == "Create" || eco_no == "")) {
							alert("ECO가 진행중입니다. ");
							return;
						}
					}
					nChangedCnt++;
				}
			}

			if (nChangedCnt == 0) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			if (!result) {
				alert(message);
			}

			return result;
		}

		
		//진행가능 상태인지 체크
		function ecoCheck() {
			var iProRev = $("#p_revision_no option:selected").val();
			var states_desc = $('#states_desc').val();
			var eco_check = 'True';

			if (iProRev == "") {
				alert("조회후 실행해주십시요.");
				return 'fail';
			}

			var allData = $( "#itemSearchList" ).jqGrid('getGridParam',
					'selarrrow');
			var ids = $( "#itemSearchList" ).jqGrid('getDataIDs');

			// 변경된 체크 박스가 있는지 체크한다.
			for (var i = 0; i < ids.length; i++) {
				if ($( "#itemSearchList" ).getDataIDs().length > 0) {
					lastId = parseInt($( "#itemSearchList" ).getDataIDs().length) + 1;
				}

				var item = $( '#itemSearchList' ).jqGrid('getRowData', ids[i]);

				var eco_state = item.eco_state;
				var states = item.states;
				var oper = item.oper;

				if (states == 'A' || states == "D") {
					$( "#itemSearchList" ).setRowData(ids[i], {
						oper : "U"
					});
				}
			}
		}

		//ECO Add 버튼 
		function addEcoResultRow() {

			$( '#itemSearchList' ).saveCell(kRow, idCol);

			var wbsState = $("#wbsstates").val();

			var eng_eco_project = $("#eng_eco_project").val();
			var eng_eco_project_Code = $("#eng_eco_project_Code").val();
			var eco_main_name = $("#eco_main_name").val();

			var wbsStateMessage;

			wbsStateMessage = 'ECO를 생성하시겠습니까?';

			if (!fn_require_chk('ecoAdd')) {
				return;
			}

			var chmResultRows = [];
			if (confirm(wbsStateMessage) != 0
					&& (eco_main_name == '-' || eco_main_name == '' || eco_main_name == null)) {
				getChangedChmResultData(function(data) {
					chmResultRows = data;

					//필수입력 체크
					var dataList = {
						chmResultList : JSON.stringify(chmResultRows)
					};

					var sUrl = "eco.do?popupDiv=bomAddEco&eng_eco_project="
							+ eng_eco_project
							+ "&eng_eco_project_Code="
							+ eng_eco_project_Code + "&menu_id=${menu_id}";

					var rs = window
							.showModalDialog(sUrl, window,
							"dialogWidth:1200px; dialogHeight:500px; center:on; scroll:off; states:off");

				});
			}
			;
		}

		

		/* //ECO Add 버튼 
		function addEcoDel(stateEco) {
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );

			$( '#itemSearchList' ).saveCell( kRow, idCol );

			var chmResultRows = [];
			var selectProject = $( "#p_project_no option:selected" ).val();
			var arrayData = [];
			var selIDs = $( "#itemSearchList" ).jqGrid( 'getGridParam', 'selarrrow' );

			if( selIDs.length == 0 ) {
				alert( "ECO를 삭제할 대상을 선택해주세요." );
				return;
			}

			//선택된 row 추출
			$.each( selIDs, function( index, value ) {
				arrayData[index] = $( "#itemSearchList" ).jqGrid( 'getRowData', value );
			} );
			
			chmResultRows = arrayData;
			var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
			
			var url = 'insertPaintWbsReCreate.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				for ( var keys in data) {
					for ( var key in data[keys]) {
						if (key == 'Result_Msg') {
							msg = data[keys][key];
						}

						if (key == 'result') {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				
				if ( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		} */

		

		function fn_eco_check() {
			if ("-" != $("#eco_main_name").val()) {
				alert("ECO가 연결되어있습니다.\nECO를 Release 하거나 삭제 후 진행하세요.");
				return false;
			}
			return true;
		}
		
		
		var callback_MenuId = function(menu_id) {
			menuId = menu_id;
		}
		
		</script>
	</body>
</html>
