<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
				<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>category Mgnt</title>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form name="listForm" id="listForm">
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				<input type="hidden" name="mode" id="mode" value="insert" />
				<input type="hidden" name="mgntDiv" id="mgntDiv" value="" />
				<!-- 카테고리 구분 하여 새로 고침하기-->
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="loginid" name="loginid" value="${loginUser.user_id}" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					CategoryMgnt
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
					<table class="searchArea conSearch">
						<col width="100px">
						<col width="260px">
						<col width="80">
						<col width="100">
						<col width="100">
						<col width="150">
						<col width="*" style="min-width:200px">
						<tr>
						<th>CATEGORY구분</th>
						<td>
							<input type="text" class='notdisabled' name="type_code" style="width: 50px;" readonly onchange="fn_typeCodeChange(this.value)" />&nbsp;
							<input type="text" class='notdisabled' name="type_code_desc" style="width: 150px; margin-left: -5px;" readonly />
							<input type="button" id="btnmain" value="검색" class="btn_gray2"/>
						</td>

						<th>CATEGORY</th>
						<td>
							<input type="text" name="category_code1" class="toUpper" style="width: 15px; text-align: center;" />
							<input type="text" name="category_code2" class="toUpper" style="width: 15px; text-align: center;" />
							<input type="text" name="category_code3" class="toUpper" style="width: 15px; text-align: center;" />
						</td>

						<th>DESCRIPTION</th>
						<td style="border-right:none;">
							<input type="text" name="category_desc" class="toUpper" style="width: 150px;" />
						</td>

						<td style="border-left:none;">
							<div class="button endbox">
								<c:if test="${userRole.attribute1 == 'Y'}">
									<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
								</c:if>

								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" class="btnAct btn_blue" id="btnSave" name="btnSave" value="저장" />
								</c:if>
								<c:if test="${userRole.attribute5 == 'Y'}">
									<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
								</c:if>
							</div>
						</td>
						</tr>
					</table>	


				<div class="content">
					<table id="categoryMgntList"></table>
					<div id="pcategoryMgntList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var tableId;
		var lodingBox;
		var resultData = [];
		var row_selected = 0;
		
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(2);
			
			var is_hidden = true;
			
			$( "#categoryMgntList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : fn_getFormData( "#listForm" ),
				colModel : [  {label:'Code',  name : 'type_code', index : 'type_code', width : 15, editrules : { required : true } }, 
				              /* { name : 'popup_type_code', index : 'popup_type_code', width : 10, align : "center" }, */ 
				              {label:'Meaning', name : 'type_desc', index : 'type_desc', width : 52, editrules : { required : true }, editoptions : { size : 5 } }, 
				              {label:'1', name : 'category_code1', index : 'category_code1', width : 10, editable : false, align : "center", editrules : { required : true } }, 
				              /* { name : 'popup_category_code1', index : 'popup_category_code1', width : 10, align : "center" }, */ 
				              {label:'2', name : 'category_code2', index : 'category_code2', width : 10, editable : true, align : "center", editrules : { required : true }, editoptions : {} }, 
				              {label:'3', name : 'category_code3', index : 'category_code3', width : 10, editable : true, align : "center", editrules : { required : true }, editoptions : {} }, 
				              {label:'속성id', name : 'attribute_id', index : 'attribute_id', width : 52, editrules : { required : true }, editoptions : { size : 5 }, hidden : is_hidden }, 
				              {label:'속성', name : 'attribute_code', index : 'attribute_code', width : 52 }, 
				              /* { name : 'popup_attribute_id', index : 'popup_attribute_id', width : 10, align : "center", editoptions : { size : 5 } }, */ 
				              {label:'Description', name : 'category_desc', index : 'category_desc', width : 85, editable : true, editrules : { required : true }, editoptions : { size : 80 }, classes : "onlyedit" }, 
				              {label:'비고', name : 'category_etc', index : 'category_etc', width : 52, editable : true, editrules : { required : true }, editoptions : { size : 50 }, classes : "onlyedit" }, 
				              {label:'무효일자', name : 'invalid_date', index : 'invalid_date', width : 30, classes : "disables" }, 
				              {label:'사용유무', name : 'enable_flag', index : 'enable_flag', width : 20, editable : true, align : "center", edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N", defaultValue : 'Y' }, formatoptions : { disabled : false }, classes : "onlyedit" }, 
				              {label:'enable_flag_changed', name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : is_hidden }, 
				              {label:'crud', name : 'oper', index : 'oper', width : 25, hidden : is_hidden }, 
				              {label:'category_id', name : 'category_id', index : 'category_id', width : 25, hidden : is_hidden },
				],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				rownumbers:true,
				height : objectHeight,
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				pager : $('#pcategoryMgntList'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				afterSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				gridComplete : function () {
					
					
					var rows = $( "#categoryMgntList" ).getDataIDs();
					
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#categoryMgntList" ).getCell( rows[i], "oper" );
						
						if( oper == "" ) {
							$( "#categoryMgntList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#DADADA' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'category_desc', '', { cursor : 'pointer', background : '#ffffff' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'category_etc', '', { cursor : 'pointer', background : '#ffffff' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'enable_flag', '', { cursor : 'pointer', background : '#ffffff' } );
						} else {
							//$( "#categoryMgntList .popup" ).css( "background", "pink" ).css("cursor","pointer");
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'type_desc','', { color : 'black', background : '#DADADA' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'invalid_date','', { color : 'black', background : '#DADADA' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'type_code', '', { cursor : 'pointer', background : 'pink' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'category_code1', '', { cursor : 'pointer', background : 'pink' } );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rows[i], 'attribute_code', '', { cursor : 'pointer', background : 'pink' } );
							
						}
					}
				},
				loadComplete : function( data ) {
					var $this = $(this);
					if ($this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
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

						if ( $this.jqGrid( 'getGridParam', 'sortname') !== '' ) {
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
				onPaging : function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( {
						datatype : 'json',
						postData : { pageYn : 'Y' }
					} ).triggerHandler( "reloadGrid" );

				},
				imgpath : 'themes/basic/images',
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					$( '#categoryMgntList' ).saveCell( kRow, idCol );
					
					row_selected = rowid;
					if ( rowid != null ) {
						var ret = $( "#categoryMgntList" ).getRowData( rowid );
						var oper = ret.oper;
						
						if( oper != "I" ) {
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'type_code', '', 'not-editable-cell' ); // 수정불가만들기
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'type_desc', '', 'not-editable-cell' );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'category_code1', '', 'not-editable-cell' );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'category_code2', '', 'not-editable-cell' );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'category_code3', '', 'not-editable-cell' );
							$( "#categoryMgntList" ).jqGrid( 'setCell', rowid, 'attribute_code', '', 'not-editable-cell' );
						} else {
							//CATEGORY TYPE 조회
							if( iCol == 1 ) {
								var type_code = ret.type_code;
								
								var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=CATEGORY_TYPE&type_code=" + type_code, 
										window,
										"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

								if ( rs != null ) {
									$( "#categoryMgntList" ).setRowData( rowid, { type_code : rs[0] } );
									$( "#categoryMgntList" ).setRowData( rowid, { type_desc : rs[1] } );
								}
							}
							
							//CATEGORY 첫번재 코드
							if( iCol == 3 ) {
								var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryType.do&sd_type=CATEGORY_TYPE",
										window,
										"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
							
								if ( rs != null ) {
									$( "#categoryMgntList" ).setRowData( rowid, { category_code1 : rs[0] } );
								}
							}
							
							//Attribute 조회
							if( iCol == 7 ) {
								if ( ret.type_code == '01' || ret.type_code == '02' ) {
									var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryMgnt.do&sd_type=" + ret.type_code, 
											window,
											"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

									if ( rs != null ) {
										$( "#categoryMgntList" ).setRowData( rowid, { attribute_id : rs[0] } );
										$( "#categoryMgntList" ).setRowData( rowid, { attribute_code : rs[1] } );
									}
								} else {
									alert( "Category 구분을 먼저 선택해주세요." );
									return;
								}
							}
						}
					}
				}
				,
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );
			
			//grid resize
		    fn_gridresize( $(window), $( "#categoryMgntList" ), 30 );

			$( "#jqg-first-row-header" ).css("height","0");

			$( "#categoryMgntList" ).jqGrid( 'setGroupHeaders', {
				useColSpanStyle : true,
				groupHeaders : [ { startColumnName : 'type_code', numberOfColumns : 2, titleText : 'Catalog 구분' }, 
				                 { startColumnName : 'category_code1', numberOfColumns : 4, titleText : 'Code' } ]
			} );

			$( "#categoryMgntList" ).jqGrid( 'navGrid', "#pcategoryMgntList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );

			<c:if test="${userRole.attribute1 == 'Y'}">
			$( "#categoryMgntList" ).navButtonAdd( "#pcategoryMgntList", {
				caption : "",
				buttonicon : "ui-icon-refresh",
				onClickButton : function() {
					fn_search();
				},
				position : "first",
				title : "Refresh",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#categoryMgntList" ).navButtonAdd( '#pcategoryMgntList', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
			});
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#categoryMgntList" ).navButtonAdd( '#pcategoryMgntList', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "Add",
				cursor : "pointer"
			} );
			</c:if>
			
			//조회 버튼
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );

			//저장버튼
			$( "#btnSave" ).click( function() {
				$( '#categoryMgntList' ).saveCell( kRow, idCol );
				
				var changedData = $( "#categoryMgntList" ).jqGrid( 'getRowData' );
				
				// 변경된 체크 박스가 있는지 체크한다.
				for ( var i = 1; i < changedData.length + 1; i++ ) {
					var item = $( '#categoryMgntList' ).jqGrid( 'getRowData', i );
					if ( item.oper != 'I' && item.oper != 'U' ) {
						if ( item.enable_flag_changed != item.enable_flag ) {
							item.oper = 'U';
						}
						if ( item.oper == 'U' ) {
							// apply the data which was entered.
							$( '#categoryMgntList' ).jqGrid( "setRowData", i, item );
						}
					}
				}
				
				if ( !fn_checkValidate() ) {
					return;
				}
				
				if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) !=0 ) {
					var chmResultRows=[];
					getChangedChmResultData( function( data ) {
						lodingBox = new ajaxLoader( $('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						chmResultRows = data;
						var dataList = { chmResultList:JSON.stringify( chmResultRows ) };
					
						var url = 'saveCategoryMgnt.do';
						var formData = fn_getFormData( '#listForm' );
						var parameters = $.extend( {}, dataList, formData );
						
						$.post( url, parameters, function( data ) {
							alert(data.resultMsg);
							if ( data.result == 'success' ) {
								fn_search();
							}
						}, "json" ).error( function () {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
					    	lodingBox.remove();	
						} );
					} );
				}
			} );

			$( "#btnmain" ) .click( function() {
				var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=infoCategoryBase.do&sd_type=CATEGORY_TYPE",
						window,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
				
				if (rs != null) {
					$( "input[name=type_code]" ).val( rs[0] );
					$( "input[name=type_code_desc]" ).val( rs[1] );
				}
			} );

			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
		} ); //end of ready Function 

		
		
		//Del 버튼
		function deleteRow() {
			if ( row_selected == 0 ) {
				return;
			}
			
			$( '#categoryMgntList' ).saveCell( kRow, kCol );

			var selrow = $( '#categoryMgntList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#categoryMgntList' ).jqGrid( 'getRowData', selrow );
			if ( item.oper == 'I' ) {
				$( '#categoryMgntList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert("저장된 데이터는 삭제할 수 없습니다.");
			}
			$( '#categoryMgntList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow( item ) {
			$( '#categoryMgntList' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#categoryMgntList' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.oper = 'I';
			item.enable_flag = 'Y';
			item.popup_type_code = '...';
			item.popup_category_code1 = '...';
			item.popup_attribute_id = '...';

			$( '#categoryMgntList' ).resetSelection();
			$( '#categoryMgntList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			tableId = '#categoryMgntList';
		}
		
		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#categoryMgntList' ).jqGrid( 'getRowData', irowId );
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#categoryMgntList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			}

			$( '#categoryMgntList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#categoryMgntList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		};
		
		function fn_search() {
			$( "#categoryMgntList" ).jqGrid( "clearGridData" );
			var sUrl = "categoryMgntList.do";

			$( "#categoryMgntList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#listForm" )
			} ).trigger( "reloadGrid" );
		}

		function fn_typeCodeChange( value ) {
			if ( value == "" ) $( "input[name=type_code_desc]" ).val( "" );
		}
/*사용안되고있음  */
		/* //CATEGORY TYPE 조회
		function searchCategoryType( obj, nCode, nData, nRow, nCol ) {

			searchIndex = $(obj).closest('tr').get(0).id;

			fn_applyData(tableId, nRow, nCol);

			var ret = jQuery("#categoryMgntList").getRowData(searchIndex);
			var type_code = ret.type_code;

			var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=popUpSdCodeInfo.do&sd_type=CATEGORY_TYPE&type_code=" + type_code, 
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

			if ( rs != null ) {
				$( "#categoryMgntList" ).setRowData( searchIndex, { type_code : rs[0] } );
				$("#categoryMgntList").setRowData(searchIndex, { type_desc : rs[1] } );
			}
		} */

		//Attribute 조회
// 		function searchAttribute( obj, nCode, nData, nRow, nCol ) {
// 			searchIndex = $(obj).closest('tr').get(0).id;
// 			fn_applyData( tableId, nRow, nCol );

// 			var item = $( '#categoryMgntList' ).jqGrid( 'getRowData', searchIndex );
// 			if ( item.type_code == '01' || item.type_code == '02' ) {
// 				var rs = window.showModalDialog( "popUpBaseInfo.do?cmd=popupCategoryMgntAttribute&sd_type=" + item.type_code, 
// 						window,
// 						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );

// 				if ( rs != null ) {
// 					$( "#categoryMgntList" ).setRowData( searchIndex, { attribute_id : rs[0] } );
// 					$( "#categoryMgntList" ).setRowData( searchIndex, { attribute_code : rs[1] } );
// 				}
// 			} else {
// 				alert( "Category type을 먼저 선택해주세요." );
// 			}
// 		}
/* 사용안되고있음 */
		/* function fn_applyData( gridId, nRow, nCol ) {
			$( gridId ).saveCell( nRow, nCol );
		} */

		/* $("input[name=type_code]").keydown( function( e ) {
			if (e.which == 9) {
				var rs = window.showModalDialog( "popUpCodeInfo.do?cmd=popUpSdCodeInfo.do&sd_type=CATEGORY_TYPE",
						window,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
				
				if (rs != null) {
					$("input[name=type_code]").val(rs[0]);
					$("input[name=type_code_desc]").val(rs[1]);
					$("#btnmain").focus();
				}
			}
		} ); */

		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#categoryMgntList" ).jqGrid( 'getDataIDs' );

			for ( var i = 0; i < ids.length; i++ ) {

				var oper = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'oper' );

				if ( oper == 'I' || oper == 'U' ) {
					nChangedCnt++;
					var val1 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'type_code' );
					var val2 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'category_code1' );
					var val3 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'category_code2' );
					var val4 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'category_code3' );
					var val5 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'attribute_code' );
					var val6 = $( "#categoryMgntList" ).jqGrid( 'getCell', ids[i], 'category_desc' );

					if ( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 1, 'type_code' );
						break;
					}

					if ( $.jgrid.isEmpty( val2 ) ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 4, 'category_code1' );
						break;
					}

					if ( $.jgrid.isEmpty( val3 ) ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 6, 'category_code2' );
						break;
					}

					if ( $.jgrid.isEmpty( val4 ) && val1 == '01' ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 7, 'category_code3' );
						break;
					}
					
					if ( $.jgrid.isEmpty( val5 ) ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 9, 'attribute_code' );
						break;
					}

					if ( $.jgrid.isEmpty( val6 ) ) {
						result = false;
						message = "Code Field is required";
						setErrorFocus( "#categoryMgntList", ids[i], 11, 'category_desc' );
						break;
					}
				}
			}

			if ( nChangedCnt == 0 ) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			if ( !result ) {
				alert( message );
			}

			return result;
		}

		function setErrorFocus( gridId, rowId, colId, colName ) {
			$( "#" + rowId + "_" + colName ).focus();
			$(gridId).jqGrid( 'editCell', rowId, colId, true );
		}
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#categoryMgntList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#categoryMgntList" ).jqGrid( "getGridParam", "colModel" );
			for(var i=1; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
						if (cn[i] == '1') {
							cn[i] = 'Code-1';
						}
						if (cn[i] == '2') {
							cn[i] = 'Code-2';
						}
						if (cn[i] == '3') {
							cn[i] = 'Code-3';
						}
						colName.push(cn[i]);
						dataName.push(cm[i]['index']);
					}
				}
				$('#p_col_name').val(colName);
				$('#p_data_name').val(dataName);

				var f = document.listForm;
				f.action = "categoryMgntExcelExport.do";
				f.method = "post";
				f.submit();
			}
		</script>
	</body>
</html>