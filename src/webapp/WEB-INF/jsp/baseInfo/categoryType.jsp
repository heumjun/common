<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>Category Type</title>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form name="listForm" id="listForm">
				<input type="hidden" id="pageYn" name="pageYn" value="N">
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					CategoryType
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				
						<table class="searchArea conSearch">
						<col width="45">
						<col width="180">
						<col width="45">
						<col width="180">
						<col width="45">
						<col width="150">
						<col width="" style="min-width:200px">

						<tr>
						<th class="first">TYPE</th>
						<td>
							<input type="text" name="p_category_type" class="toUpper" style="width: 150px;" />
						</td>

						<th>DESC</th>
						<td><input type="text" name="p_category_type_desc" class="toUpper" style="width: 150px;" /></td>

						<th>MEAN</th>
						<td  style="border-right:none;">
							<input type="text" name="p_category_type_mean" class="toUpper" style="width: 150px;" />
						</td>

						<td class="end" style="border-left:none;">
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
					
					
				<!--<div class="topMain">
					<div class="conSearch">
						<span class="spanMargin">
							<span class="sc_name">TYPE</span>
							<input type="text" name="p_category_type" class="toUpper" style="width: 150px;" />
						</span>
					</div>
					<div class="conSearch">
						<span class="spanMargin">
							<span class="sc_name">Desc</span>
							<input type="text" name="p_category_type_desc" class="toUpper" style="width: 150px;" />
						</span>
					</div>
					<div class="conSearch">
						<span class="spanMargin">
							<span class="sc_name">Mean</span>
							<input type="text" name="p_category_type_mean" class="toUpper" style="width: 150px;" />
						</span>
					</div>
					<div class="button">
						<input type="button" value="저장" id="btnSave"  class="btn_blue"/>
						<input type="button" value="조회" id="btnSearch"  class="btn_blue"/>
					</div>
				</div>
-->
				<div class="content">
					<table id="categoryType"></table>
					<div id="pcategoryType"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var lodingBox;
		var resultData = [];
		var row_selected = 0;
		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#categoryType" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : '',
				colNames : [ 'Category Type', 'Category Type Desc', 'Category Type Mean', '사용유무', 'enable_flag_change', 'crud' ],
				colModel : [ { name : 'category_type', index : 'category_type', width : 52, editable : true, editrules : { required : true } },
				             { name : 'category_type_desc', index : 'category_type_desc', width : 85, editable : true },
				             { name : 'category_type_mean', index : 'category_type_mean', width : 55, editable : true },
				             { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true }, 
				             { name : 'oper', index : 'oper', width : 25, hidden : true } ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				autowidth : true,
				height : objectHeight,
				rownumbers:true,
				pager : $('#pcategoryType'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
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
						postData : {
							pageYn : 'Y'
						}
					} ).triggerHandler( "reloadGrid" );

				},
				loadComplete : function( data ) {
					var $this = $(this);
					if ( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
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
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				imgpath : 'themes/basic/images',
				onCellSelect : function( row_id, colId ) {
					row_selected = row_id;
					if ( row_id != null ) {
						var ret = $( "#categoryType" ).getRowData( row_id );
						
						if( ret.oper == "" ) {
							$( "#categoryType" ).jqGrid( 'setCell', row_id, 'category_type', '', 'not-editable-cell' );
						}
					}
				},
				gridComplete : function() {
					var rows = $( "#categoryType" ).getDataIDs();

					for ( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var oper = $( "#categoryType" ).getCell( rows[i], "oper" );
						
						if( oper == "" ) {
							$( "#categoryType" ).jqGrid( 'setCell', rows[i], 'category_type', '', { color : 'black', background : '#DADADA' } );
						}
					}
				},
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );
			
			fn_gridresize($(window),$("#categoryType"));

			$( "#categoryType" ).jqGrid( 'navGrid', "#pcategoryType", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			<c:if test="${userRole.attribute1 == 'Y'}">
			$( "#categoryType" ).navButtonAdd( '#pcategoryType', {
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
			$( "#categoryType" ).navButtonAdd( '#pcategoryType', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "Del",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#categoryType" ).navButtonAdd( '#pcategoryType', {
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
				fn_save();
			});

			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
		}); //end of ready Function 

		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#categoryType" ).jqGrid( 'getRowData' ), function(obj) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		}

		function fn_search() {
			$( "#categoryType" ).jqGrid( "clearGridData" );
			var sUrl = "categoryTypeList.do";
			$( "#categoryType" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#listForm" )
			}).trigger( "reloadGrid" );
		}
		
		function fn_save() {
			$( '#categoryType' ).saveCell( kRow, idCol );
			
			var changedData = $( "#categoryType" ).jqGrid( 'getRowData' );
			
			// 변경된 체크 박스가 있는지 체크한다.
			for ( var i = 1; i < changedData.length + 1; i++) {
				var item = $( '#categoryType' ).jqGrid( 'getRowData', i );
				if ( item.oper != 'I' && item.oper != 'U' ) {
					if ( item.enable_flag_changed != item.enable_flag ) {
						item.oper = 'U';
					}
					if ( item.oper == 'U' ) {
						// apply the data which was entered.
						$( '#categoryType' ).jqGrid( "setRowData", i, item );
					}
				}
			}

			if ( !fn_checkCategoryTypeValidate() ) {
				return;
			}
			
			if ( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];
				getChangedChmResultData( function( data ) {
					lodingBox = new ajaxLoader( $('#mainDiv'), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };

					var url = 'saveCategoryType.do';
					var formData = fn_getFormData( '#listForm' );
					var parameters = $.extend( {}, dataList, formData);
					
					
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
		}
		
		//Del 버튼
		function deleteRow() {
			if ( row_selected == 0 ) {
				return;
			}
			$( '#categoryType' ).saveCell( kRow, kCol );

			var selrow = $( '#categoryType' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#categoryType' ).jqGrid( 'getRowData', selrow );

			if ( item.oper == 'I' ) {
				$( '#categoryType' ).jqGrid( 'delRowData', selrow );
			} else {
				alert( '저장된 데이터는 삭제할 수 없습니다.' );
			}

			$('#categoryType').resetSelection();
		}

		//Add 버튼 
		function addChmResultRow( item ) {
			$( '#categoryType' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#categoryType' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel)
				item[colModel[i].name] = '';
			
			item.oper = 'I';
			item.enable_flag = 'Y';

			$( '#categoryType' ).resetSelection();
			$( '#categoryType' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#categoryType' ).jqGrid( 'getRowData', irowId );
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#categoryType' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			}
			
			$( '#categoryType' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );
		}

		function fn_checkCategoryTypeValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#categoryType" ).jqGrid( 'getDataIDs' );

			for ( var i = 0; i < ids.length; i++) {

				var oper = $( "#categoryType" ).jqGrid( 'getCell', ids[i], 'oper' );

				if ( oper == 'I' || oper == 'U') {
					nChangedCnt++;

					var val1 = $( "#categoryType" ).jqGrid( 'getCell', ids[i], 'category_type' );

					if ( $.jgrid.isEmpty( val1 ) ) {
						result = false;
						message = "Category Type Field is required";

						setErrorFocus( "#categoryType", ids[i], 0, 'category_type' );
						break;
					}
				}
			}

			if ( nChangedCnt == 0) {
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
			$( gridId ).jqGrid( 'editCell', rowId, colId, true);
		}
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#categoryType" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#categoryType" ).jqGrid( "getGridParam", "colModel" );
			for(var i=1; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			
			var f    = document.listForm;
			f.action = "categoryTypeExcelExport.do";
			f.method = "post";
			f.submit();
		}
		</script>
	</body>
</html>