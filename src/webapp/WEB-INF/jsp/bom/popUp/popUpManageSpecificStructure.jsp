<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>특수구조관리</title>
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="sd_type" name="sd_type" value="${sd_type}">
				<div class="topMain" style="line-height: 45px;">
					<div class="conSearch">
						<span class="pop_tit">Type :</span> <select onchange="fn_search();" name="p_ship_type" id="p_ship_type">
							<c:forEach var="item" items="${spstShipTypeList}">
								<option value="${item.sd_code}">${item.sd_desc}</option>
							</c:forEach>
						</select>
					</div>
					<div class="button">
						<input type="button" class="btn_blue" id="btn_add" name="btn_add" value="ADD" />
						<input type="button" class="btn_blue" id="btn_del" name="btn_del" value="DEL" />
						<input type="button" class="btn_blue" id="btn_save" name="btn_save" value="저장" />
						<input type="button" class="btn_blue" id="btn_search" name="btn_search" value="조회" />
						<input type="button" class="btn_blue" id="btn_close" name="btn_close" value="닫기" />
					</div>
				</div>
				<div class="content">
					<table id="addActivityJobList"></table>
				<div id="btn_addActivityJobList"></div>
			</div>
			</form>
		</div>
		<script type="text/javascript">
		var change_item_row 	= 0;
		var change_item_row_num = 0;
		var change_item_col  	= 0;
		var opener = window.dialogArguments;
		
		var resultData = [];
		
		var loadingBox;
		
		$(document).ready( function() {
			
			var is_hidden = true;

			$( "#addActivityJobList" ).jqGrid( {
				url : 'infoManageSpecificStructure.do',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', 'oper', 'Ship Type', 'Type', 'states', '상태', 'BOM 연계유무',
				             'Level', '모 Catalog', '...', '모품목', 'wbs_sub_mother_id', '추가', '자 Catalog', '...', '자품목', 'wbs_sub_item_id',
				             'Find Number',
				             'ATTR01', 'ATTR02', 'ATTR03', 'ATTR04', 'ATTR05',
				             'ATTR06', 'ATTR07', 'ATTR08', 'ATTR09', 'ATTR10',
				             'ATTR11', 'ATTR12', 'ATTR13', 'ATTR14', 'ATTR15',
				             'BOM10', 'BOM11',
				             'item_create_error', 'item_connect_error',
				             '생성자', '생성일', '수정자', '수정일' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 25, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				             { name : 'oper', index : 'oper', width : 50, align : 'center', hidden : is_hidden }, 
				             { name : 'ship_type', index : 'ship_type', width : 100, align : 'center', hidden : is_hidden },
				             { name : 'ship_type_name', index : 'ship_type_name', width : 100, align : 'center' },
				             { name : 'states', index : 'states', width : 100, align : 'center', hidden : is_hidden },
				             { name : 'states_desc', index : 'states_desc', width : 50, align : 'center', hidden : is_hidden },
				             { name : 'bom_states', index : 'bom_states', width : 90, align : 'center', hidden : is_hidden },
				             
				             { name : 'level_no', index : 'level_no', width : 30, align : 'center' }, 
				             { name : 'mother_catalog', index : 'mother_catalog', width : 65, align : 'center' },
				             { name : 'mother_catalog_popup', index : 'mother_catalog_popup', align : 'center', width : 30 },
				             { name : 'mother_code', index : 'mother_code', width : 90, align : 'center', hidden : is_hidden },
				             { name : 'wbs_sub_mother_id', index : 'wbs_sub_mother_id', width : 110, align : 'center', hidden : is_hidden },
				             { name : 'sub_level_add_row', index : 'sub_level_add_row', width : 30, align : 'center', classes : 'cellClickArea' }, 
// 				             { name : 'item_catalog', index : 'item_catalog', align : 'center', width : 65, editable : true, edittype : 'select', formatter : 'select', editoptions : { value : ":;V71:V71;V72:V72;1K0:1K0" } },
				             { name : 'item_catalog', index : 'item_catalog', editable : false, align : 'center', sortable : false, width : 65 },
				             { name : 'item_catalog_popup', index : 'item_catalog_popup', align : 'center', width : 30 },
				             { name : 'item_code', index : 'item_code', width : 90, align : 'center', hidden : is_hidden },
				             { name : 'wbs_sub_item_id', index : 'wbs_sub_item_id', width : 110, align : 'center', hidden : is_hidden },
				             
				             { name : 'findnumber', index : 'findnumber', width : 60, editable : true, align : 'center', hidden : is_hidden },
				             
				             { name : 'item_attribute01', index : 'item_attribute01', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute02', index : 'item_attribute02', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute03', index : 'item_attribute03', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute04', index : 'item_attribute04', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute05', index : 'item_attribute05', width : 60, editable : true, align : 'center' },
				             
				             { name : 'item_attribute06', index : 'item_attribute06', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute07', index : 'item_attribute07', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute08', index : 'item_attribute08', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute09', index : 'item_attribute09', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute10', index : 'item_attribute10', width : 60, editable : true, align : 'center' },
				             
				             { name : 'item_attribute11', index : 'item_attribute11', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute12', index : 'item_attribute12', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute13', index : 'item_attribute13', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute14', index : 'item_attribute14', width : 60, editable : true, align : 'center' }, 
				             { name : 'item_attribute15', index : 'item_attribute15', width : 60, editable : true, align : 'center' },
				             
				             { name : 'bom10', index : 'bom10', width : 60, editable : true, align : 'center' }, 
				             { name : 'bom11', index : 'bom11', width : 60, editable : true, align : 'center' },
				             
				             { name : 'item_create_error', index : 'item_create_error', width : 150, align : 'center' }, 
				             { name : 'item_connect_error', index : 'item_connect_error', width : 150, align : 'center' },
				             
				             { name : 'create_by', index : 'create_by', width : 220, align : 'left' },
				             { name : 'create_date', index : 'create_date', width : 65, align : 'center' },
				             { name : 'modify_by', index : 'modify_by', width : 220, align : 'left' },
				             { name : 'modify_date', index : 'modify_date', width : 65, align : 'center' } ],
				rowNum : -1,
				sortname : 'sub_level_add_row',
				cmTemplate: { title: false },
				viewrecords : true,
				sortorder : "desc",
				shrinkToFit : false,
				autowidth : true,
				height : 500,
				pgbuttons : false,
				pgtext : false,
				pginput : false,
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				emptyrecords : '데이터가 존재하지 않습니다.',
				pager : $( '#btn_addActivityJobList' ),
				imgpath : 'themes/basic/images',
				jsonReader : {
					id : "wbs_sub_item_id",
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					
					if (rowid != null) {
						change_item_col  	= iCol;
						change_item_row_num = iRow;

						if (change_item_row != rowid) {
							change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#addActivityJobList' ).jqGrid( 'getRowData', rowid );
					if (item.oper != 'I')
						item.oper = 'U';

					$( '#addActivityJobList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function ( rowid, iCol, cellcontent, e ) {
					fn_applyData( "#addActivityJobList", change_item_row_num, change_item_col );
					
					var cm = $( this ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( this ).jqGrid( "getRowData", rowid );
					
					if ( rowid != null ) {
						//저장된 것은 수정 불가능함
						if( item.oper == "" ) {
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_catalog', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute01', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute02', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute03', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute04', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute05', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute06', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute07', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute08', '', 'not-editable-cell' );
							$( "#addActivityJobList" ).jqGrid( 'setCell', rowid, 'item_attribute09', '', 'not-editable-cell' );
						} 
						if ( colName['index'] == "mother_catalog_popup" ) {
							if(item.mother_catalog == ""){
								var rs = window.showModalDialog( "popUpMotherCatalogSearch.do?level_no="+item.level_no,
										window,
										"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off" );

								if ( rs != null ) {
									$( "#addActivityJobList" ).setRowData( rowid, { mother_catalog: rs[0] } );
								}
							}
						}
						
						if ( colName['index'] == "item_catalog_popup" ) {
							if( item.mother_catalog == "") {
								alert( "모 Catalog를 선택해 주세요." );
								return;
							} else {
								var rs = window.showModalDialog( "popUpItemCatalogSearch.do?mother_catalog=" + item.mother_catalog + "&level_no="+item.level_no,
										window,
										"dialogWidth:550px; dialogHeight:435px; center:on; scroll:off; status:off" );

								if ( rs != null ) {
									if(item.item_catalog != ""){
										$( "#addActivityJobList" ).setRowData( rowid, { item_catalog: rs[0], oper : "U" } );
									} else {
										$( "#addActivityJobList" ).setRowData( rowid, { item_catalog: rs[0] } );
									}
									
								}
							}
						}
					
						//추가 버튼 클릭 시 하위 라인 추가
						if( colName['index'] == "sub_level_add_row" ) {
							if( item.mother_catalog == "") {
								alert( "모 Catalog를 선택해 주세요." );
								return;
							} else if( item.item_catalog == "") {
								alert( "자 Catalog를 선택해 주세요." );
								return;
							} else {
								fn_sub_level_add_row( rowid, iCol, cellcontent, e );
							}
						}
					}
				},
				gridComplete : function() {
					//클릭 영역 색상 표시
					$( "#addActivityJobList .cellClickArea" ).css( "background","pink" ).css( "cursor","pointer" );
					
					var rows = $( "#addActivityJobList" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#addActivityJobList" ).getCell( rows[i], "oper" );
						
						//신규 추가 라인 색상 표시
						if( oper == "I" ) {
							$( "#addActivityJobList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#CEFBC9' } );
						}
					}
					
					$("#addActivityJobList td:contains('...')").css("background","pink").css("cursor","pointer");
				}
			} );
			
			//그리드 버튼 숨김
			$( "#addActivityJobList" ).jqGrid( 'navGrid', "#btn_addActivityJobList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
// 			//Refresh
// 			$( "#addActivityJobList" ).navButtonAdd( '#paddActivityJobList', {
// 				caption : "",
// 				buttonicon : "ui-icon-refresh",
// 				onClickButton : function() {
// 					fn_search();
// 				},
// 				position : "first",
// 				title : "Refresh",
// 				cursor : "pointer"
// 			} );
			
			//Del 버튼
			$( "#addActivityJobList" ).navButtonAdd( '#btn_addActivityJobList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
			} );
			
// 			//Add 버튼
// 			$( "#addActivityJobList" ).navButtonAdd( '#paddActivityJobList', {
// 				caption : "",
// 				buttonicon : "ui-icon-plus",
// 				onClickButton : addChmResultRow,
// 				position : "first",
// 				title : "Add",
// 				cursor : "pointer"
// 			});
			
// 			$( "#btn_addActivityJobList_center" ).hide();
			
			//column header merge
			$( "#addActivityJobList" ).jqGrid( 'setGroupHeaders', {
				useColSpanStyle : true, 
				groupHeaders : [ { startColumnName : 'level_no', numberOfColumns : 8, titleText : 'BOM TREE'} ]
			} );
			
			//copy
			//기존 호선의 WBS구조의 입력값만 COPY(가져와서 수정 후 채번함)
			$( "#btn_copy" ).click( function () {
				fn_copy();
			} );
			
			$( "#btn_search" ).click( function () {
				fn_search();
			} );
			
			//ADD
			//호선 Revision Approved 상태에서만 ADD가능(1Level)
			$( "#btn_add" ).click( function () {
				fn_level_add();
			} );
			
// 			//DEL
			$( "#btn_del" ).click( function () {
				fn_del();
			} );
			
			//채번
			$( "#btn_create_code" ).click( function () {
				fn_create_code();
			} );
			
			//저장
			$( "#btn_save" ).click( function () {
				fn_save();
			} );
			
			//닫기
			$( "#btn_close" ).click( function () {
				fn_close();
			} );
			/* 2015/12/9 황경호 사용안되고있음 */
			/* $.post( "selectSpstSubCatalog.do", "", function( data ) {
				$( '#addActivityJobList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'item_catalog',
					data : data
				} );
			}, "json" ); */
			
		} ); //$(document).ready(function() {
		
		//Del 버튼
		function deleteRow() {
			getSelectedChmResultData( function( data ) {
			
				if( data.length == 0 ) {
					alert( "삭제할 라인을 선택해주세요." );
				} else {
					for( var i = 0; i < data.length; i++ ) {
						if( data[i].oper == "I" ) {
							$( '#addActivityJobList' ).jqGrid( 'delRowData', data[i].wbs_sub_item_id );
						}
					}
					$( '#addActivityJobList' ).resetSelection();
				}
			} );
		}
			
		//ADD 버튼 클릭 시 LV1 라인 추가
		function fn_level_add() {
			fn_applyData( "#addActivityJobList", change_item_row_num, change_item_col );

			var item = {};
			var colModel = $( '#addActivityJobList' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel ){
				item[colModel[i].name] = '';
			}
				
			item.oper = "I";
				
			item.states = "A";
			item.states_desc = "추가";
			item.bom_states = "N";
			
			item.level_no = "1";
			item.mother_catalog = $( "#p_top_catalog" ).val();
			item.mother_code = $( "#p_top_item" ).val();
			item.wbs_sub_mother_id = 0;
			
			item.sub_level_add_row = "+";
			
			item.mother_catalog_popup = "...";
			item.item_catalog_popup = "...";
			
			item.ship_type = $("#p_ship_type option:selected").val();
			item.ship_type_name = $("#p_ship_type option:selected").text();
			
			item.wbs_sub_item_id = $.jgrid.randId();
			$( '#addActivityJobList' ).jqGrid( 'addRowData', item.wbs_sub_item_id , item, 'first' );
			/* var url = "getWbsSubItemSeqId.do";
			$.post( url, "", function( data ) {
				//wbs_sub_item_id seq 채번
				var wbs_sub_item_id = data[0].stx_dis_wbs_sub_item_seq_id;
				
				item.oper = "I";
				
				item.states = "A";
				item.states_desc = "추가";
				item.bom_states = "N";
				
				item.level_no = "1";
				item.mother_catalog = $( "#p_top_catalog" ).val();
				item.mother_code = $( "#p_top_item" ).val();
				item.wbs_sub_mother_id = 0;
				
				item.sub_level_add_row = "+";
				
				item.mother_catalog_popup = "...";
				item.item_catalog_popup = "...";
				
				item.ship_type = $("#p_ship_type option:selected").val();
				item.ship_type_name = $("#p_ship_type option:selected").text();
				
				item.wbs_sub_item_id = wbs_sub_item_id;
				$( '#addActivityJobList' ).jqGrid( 'addRowData', wbs_sub_item_id, item, 'first' );
			}, "json" ); */
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#addActivityJobList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'D';
			} );

			callback.apply( this, [ changedData.concat( resultData ) ] );
		}
		
		function fn_del() {
			$( '#addActivityJobList' ).saveCell( change_item_row_num, change_item_col );
			
			var chmResultRows = [];
			getSelectedChmResultData( function( data ) {
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				for( var i = 0; i < data.length; i++ ) {
					if( data[i].oper == "I" ) {
						alert('ADD작업 진행중인 BOM TREE는 선택 해제 바랍니다.');
						lodingBox.remove();
						return;
					}
				}
								
				chmResultRows = data;
				
				if( chmResultRows.length == 0 ) {
					alert( "선택된 ROW가 없습니다." );
					lodingBox.remove();
					return;
				} else {
				
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
		
					var url = 'deleteSpstSubItem.do';
					var formData = fn_getFormData( '#application_form' );
					var parameters = $.extend( {}, dataList, formData );
		
					$.post( url, parameters, function( data2 ) {
						alert(data2.resultMsg);
						if ( data2.result == 'success' ) {
							fn_search();
						}
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				}
			} );
		}
		
		function getAllChmData( callback ) {
			var changedData = $.grep( $( "#addActivityJobList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );

			callback.apply( this, [ changedData.concat( resultData ) ] );
		}
		/* 사용안되고있음 */
		/* function fn_create_code() {
			fn_applyData( "#addActivityJobList", change_item_row_num, change_item_col );
			
			var chmResultRows = [];
			getChangedChmResultData( function( data ) {
				chmResultRows = data;
				for( var k = 0; k < chmResultRows.length; k++ ) {
					if( chmResultRows[k].mother_catalog == chmResultRows[k].item_catalog ) {
						alert( "모 Catalog와 자 Catalog가 같습니다." );
						return;
					}
					
					if( chmResultRows[k].item_catalog == "" ) {
						alert( "자 Catalog는 필수입력입니다." );
						return;
					}
					
					if( chmResultRows[k].item_attribute01 == "" ) {
						alert( "ATTR01 필수입력입니다." );
						return;
					}
					
					if( chmResultRows[k].item_attribute02 == "" ) {
						alert( "ATTR02 필수입력입니다." );
						return;
					}
				}
				
				var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
				
				var url = 'saveWbsSubItem.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );

				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, parameters, function( data ) {
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();	
				} );
			} );
		} */
		
		function fn_save() {
			fn_applyData( "#addActivityJobList", change_item_row_num, change_item_col );
			var is_error = true;
			var nChangedCnt = 0;
			var chmResultRows = [];
			getAllChmData( function( data ) {
				chmResultRows = data;
				for( var k = 0; k < chmResultRows.length; k++ ) {
					if(chmResultRows[k].mother_catalog == ""){
						alert("모 Catalog를 입력해 주세요.");
						is_error = false;
						break;
					} else {					
						if( chmResultRows[k].mother_catalog == chmResultRows[k].item_catalog ) {
							alert( "모 Catalog와 자 Catalog가 같습니다." );
							is_error = false;
							break;
						}
						
						if( chmResultRows[k].item_catalog == "" ) {
							alert( "자 Catalog는 필수입력입니다." );
							is_error = false;
							break;
						}
					}
					if( chmResultRows[k].oper == 'I' || chmResultRows[k].oper == 'U' ) {
						nChangedCnt++;
					}
				}
				
				
			
			if( is_error ) {
				var dataList = {
					chmResultList : JSON.stringify(chmResultRows)
				};
				
				var url = 'saveSpstSubBom.do';
				var formData = fn_getFormData( '#application_form' );
				var parameters = $.extend( {}, dataList, formData );
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, parameters, function( data ) {
					alert(data.resultMsg);
					if ( data.result == 'success' ) {
						fn_search();
					}
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();	
				} );
			}
			} );
		}
		
		//취소
		function fn_close() {
			self.close();
		}
		
		function fn_search() {
			$( "#addActivityJobList" ).jqGrid( 'setGridParam', {
				url : 'infoManageSpecificStructure.do',
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//하위 레벨 추가
		function fn_sub_level_add_row( rowid, iCol, cellcontent, e ) {
			fn_applyData( "#addActivityJobList", change_item_row_num, change_item_col );
			var orign_item = $( "#addActivityJobList" ).jqGrid( "getRowData", rowid );
			if(orign_item.oper == 'I'){
				alert("저장전 하위 라인을 추가 할수 없습니다.");
				return;
			}
			var item = {};
			var colModel = $( '#addActivityJobList' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel ){
				item[colModel[i].name] = '';
			}
			item.oper = "I";
			item.states = "A";
			item.states_desc = "추가";
			item.bom_states = "N";
			item.level_no = parseInt(orign_item.level_no) + parseInt(1);
			item.mother_catalog = orign_item.item_catalog;
			item.mother_code = orign_item.item_code;
			item.wbs_sub_mother_id = orign_item.wbs_sub_item_id;
			item.sub_level_add_row = "+";
			item.mother_catalog_popup = "...";
			item.item_catalog_popup = "...";
			item.ship_type = orign_item.ship_type;
			item.ship_type_name = orign_item.ship_type_name;
			item.wbs_sub_item_id = $.jgrid.randId();
			$( "#addActivityJobList" ).jqGrid( 'addRowData', item.wbs_sub_item_id , item, 'after', rowid ); 
			
			/* var url = "getWbsSubItemSeqId.do";
			$.post( url, "", function( data ) {
				//wbs_sub_item_id seq 채번
				var wbs_sub_item_id = data[0].stx_dis_wbs_sub_item_seq_id;
				
				item.oper = "I";
				
				item.states = "A";
				item.states_desc = "추가";
				item.bom_states = "N";
				
				item.level_no = parseInt(orign_item.level_no) + parseInt(1);
				item.mother_catalog = orign_item.item_catalog;
				item.mother_code = orign_item.item_code;
				item.wbs_sub_mother_id = orign_item.wbs_sub_item_id;
				
				item.sub_level_add_row = "+";
				
				item.mother_catalog_popup = "...";
				item.item_catalog_popup = "...";
				
				item.ship_type = orign_item.ship_type;
				item.ship_type_name = orign_item.ship_type_name;
				
				item.wbs_sub_item_id = wbs_sub_item_id;
				$( "#addActivityJobList" ).jqGrid( 'addRowData', wbs_sub_item_id, item, 'after', rowid ); 
			}, "json" );  */
		}
		
		//delete row
		/* function fn_delete_row( rowid, iCol, cellcontent, e ) {
			if( !confirm( "선택하신 라인에 하위 종속된 라인도 삭제됩니다.\n삭제하시겠습니까?" ) ) {
				return;
			}
			var orign_item = $( "#addActivityJobList" ).jqGrid( "getRowData", rowid );
			
			//out2
			var arr_item_id1 = new Array();
			var rows = $( "#addActivityJobList" ).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				var temp_mother_code = $( "#addActivityJobList" ).getCell( rows[i], "temp_mother_code" );
				var temp_item_code = $( "#addActivityJobList" ).getCell( rows[i], "temp_item_code" );
				
				if( temp_mother_code == orign_item.temp_item_code ) {
					arr_item_id1.push(temp_item_code);
				}
			}
			
			//out3
			var arr_item_id2 = new Array();
			for ( var j = 0; j < arr_item_id1.length; j++ ) {
				for ( var k = 0; k < rows.length; k++ ) {
					var temp_mother_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_mother_code" );
					var temp_item_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_item_code" );
					
					if( temp_mother_code == arr_item_id1[j] ) {
						arr_item_id2.push(temp_item_code);
					}
				}
			}
			
			//out4
			var arr_item_id3 = new Array();
			for ( var j = 0; j < arr_item_id2.length; j++ ) {
				for ( var k = 0; k < rows.length; k++ ) {
					var temp_mother_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_mother_code" );
					var temp_item_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_item_code" );
					
					if( temp_mother_code == arr_item_id2[j] ) {
						arr_item_id3.push(temp_item_code);
					}
				}
			}
			
			//pd
			var arr_item_id4 = new Array();
			for ( var j = 0; j < arr_item_id3.length; j++ ) {
				for ( var k = 0; k < rows.length; k++ ) {
					var temp_mother_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_mother_code" );
					var temp_item_code = $( "#addActivityJobList" ).getCell( rows[k], "temp_item_code" );
					
					if( temp_mother_code == arr_item_id3[j] ) {
						arr_item_id4.push(temp_item_code);
					}
				}
			}
			
			//out1
			$( '#addActivityJobList' ).jqGrid( 'delRowData', rowid );
			
			//out2
			for ( var i = 0; i < arr_item_id1.length; i++ ) {
				$( '#addActivityJobList' ).jqGrid( 'delRowData', arr_item_id1[i] );
			}
			
			//out3
			for ( var i = 0; i < arr_item_id2.length; i++ ) {
				$( '#addActivityJobList' ).jqGrid( 'delRowData', arr_item_id2[i] );
			}
			
			//out4
			for ( var i = 0; i < arr_item_id3.length; i++ ) {
				$( '#addActivityJobList' ).jqGrid( 'delRowData', arr_item_id3[i] );
			}
			
			//pd
			for ( var i = 0; i < arr_item_id4.length; i++ ) {
				$( '#addActivityJobList' ).jqGrid( 'delRowData', arr_item_id4[i] );
			}
			
		} */
		
		function fn_applyData( gridId, nRow, nCol ) {
			$(gridId).saveCell( nRow, nCol );
		}
		
		function getSelectedChmResultData( callback ) {
			var changedData = $.grep( $( "#addActivityJobList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		</script>
	</body>
</html>