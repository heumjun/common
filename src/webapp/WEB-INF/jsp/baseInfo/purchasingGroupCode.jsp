<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Catalog Type</title>
			<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form name="listForm" id="listForm">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class="subtitle">
					PurchasingGroupCode
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				
			
				<table class="searchArea conSearch">
				<col width="140px">
				<col width="220px">
				<col width="210px">
				<col width="180px">
				<col width="*" style="min-width:120px">
				<tr>

				<th>CATALOG TYPE</th>
				<td>
					<input type="text" id="p_catalogType" name="p_catalogType" class="toUpper wid200" />
				</td>

				<th>CATALOG TYPE DESCRIPTION</th>
				<td style="border-right:none;">
					<input type="text" id="p_catalogTypeDesc" name="p_catalogTypeDesc" class="toUpper wid200"/>
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
				개발 진행 중
				<!-- <table id="catalogTypeList"></table> -->
				<div id="pcatalogTypeList"></div>
			</div>


			</form>
		</div>
		<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var resultData = [];
		var lodingBox;
		var row_selected = 0;
		
		$(document).ready( function() {
			
			var objectHeight = gridObjectHeight(1);
			
			fn_all_text_upper();
			
			$( '#catalogTypeList' ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : fn_getFormData( '#listForm' ),
				colNames : [ 'Catalog Type', 'Catalog Type Description', '표준유무', 'standard_flag_changed', '사용유무', 'enable_flag_change', 'crud' ],
				colModel : [ { name : 'catalog_type', index : 'catalog_type', width : 50, editable : true, editrules : { required : true }, editoptions : { maxlength : '1' } }, 
				             { name : 'catalog_type_desc', index : 'catalog_type_desc', width : 150, editable : true }, 
				             { name : 'standard_flag', index : 'standard_flag', align : 'center', width : 30, editable : true, edittype : 'checkbox', formatter : 'checkbox', editoptions : { value : 'Y:N' }, formatoptions : { disabled : false } }, 
				             { name : 'standard_flag_changed', index : 'standard_flag_changed', width : 25, hidden : true }, 
				             { name : 'enable_flag', index : 'enable_flag', align : 'center', width : 30, editable : true, edittype : 'checkbox', formatter : 'checkbox', editoptions : { value : 'Y:N' }, formatoptions : { disabled : false } }, 
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', width : 25, hidden : true }, 
				             { name : 'oper', index : 'oper', width : 25, hidden : true }, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, 'bottom' ],
				viewrecords : true,
				autowidth : true,
				height : objectHeight,
				pager : $('#pcatalogTypeList'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				rownumbers : true,
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				jsonReader : {
					root : 'rows',
					page : 'page',
					total : 'total',
					records : 'records',
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onPaging : function(pgButton) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( 'clearGridData' );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } }).triggerHandler( 'reloadGrid' );
				},
				loadComplete : function(data) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype') === 'json') {
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

						if( $this.jqGrid( 'getGridParam', 'sortname') !== '' ) {
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
				onCellSelect : function( row_id, colId ) {
					row_selected = row_id;
					if (row_id != null) {
						var ret = $( '#catalogTypeList' ).getRowData( row_id );

						if (ret.oper == '')
							$( '#catalogTypeList' ).jqGrid( 'setCell', row_id, 'catalog_type', '', 'not-editable-cell' );
					}
				},
				gridComplete : function() {
					var rows = $( '#catalogTypeList' ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						var oper = $( '#catalogTypeList' ).getCell( rows[i], 'oper' );

						if( oper == '' ) {
							$( '#catalogTypeList' ).jqGrid( 'setCell', rows[i], 'catalog_type', '', { color : 'black', background : '#DADADA' } );
						}
					}

					//미입력 영역 회색 표시
					$( '#catalogTypeList .disables' ).css('background', '#DADADA' );
				}
				,
				afterInsertRow : function(rowid, rowdata, rowelem){
					jQuery("#"+rowid).css("background", "#0AC9FF");
		        }
			} );

			//grid resize
			fn_gridresize( $(window), $( '#catalogTypeList' ) );

			$( '#catalogTypeList' ).jqGrid( 'navGrid', '#pcatalogTypeList', {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			<c:if test="${userRole.attribute1 == 'Y'}">
			$( '#catalogTypeList' ).navButtonAdd( '#pcatalogTypeList', {
				caption : '',
				buttonicon : 'ui-icon-refresh',
				onClickButton : function() {
					fn_search();
				},
				position : 'first',
				title : '',
				cursor : 'pointer'
			} );
			</c:if>
			
			<c:if test="${userRole.attribute3 == 'Y'}">
			$( '#catalogTypeList' ).navButtonAdd( '#pcatalogTypeList', {
				caption : '',
				buttonicon : 'ui-icon-minus',
				onClickButton : deleteRow,
				position : 'first',
				title : '',
				cursor : 'pointer'
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( '#catalogTypeList' ).navButtonAdd( '#pcatalogTypeList', {
				caption : '',
				buttonicon : 'ui-icon-plus',
				onClickButton : addChmResultRow,
				position : 'first',
				title : '',
				cursor : 'pointer'
			} );
			</c:if>
			
			//조회 버튼
			$( '#btnSearch' ).click( function() {
				fn_search();
			} );
			
			//저장버튼
			$( '#btnSave' ).click( function() {
				fn_save();
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
			
			$( '#catalogTypeList' ).saveCell( kRow, kCol );

			var selrow = $( '#catalogTypeList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#catalogTypeList' ).jqGrid( 'getRowData', selrow );
			
			if( item.oper == 'I' ) {
				$( '#catalogTypeList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert('저장된 데이터는 삭제할 수 없습니다.');
			}
			
			$( '#catalogTypeList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {
			$( '#catalogTypeList' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#catalogTypeList' ).jqGrid( 'getGridParam', 'colModel' );
			for( var i in colModel )
				item[colModel[i].name] = '';
			
			item.oper = 'I';
			item.standard_flag = 'Y';
			item.enable_flag = 'Y';

			$( '#catalogTypeList' ).resetSelection();
			$( '#catalogTypeList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd( rowid, cellname, value, iRow, iCol ) {
			var item = $( '#catalogTypeList' ).jqGrid( 'getRowData', rowid );
			
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#catalogTypeList' ).jqGrid('setCell', rowid, cellname, '', { 'background' : '#6DFF6D' } );
			}
			
			$( '#catalogTypeList' ).jqGrid( 'setRowData', rowid, item );
			$( 'input.editable,select.editable', this ).attr( 'editable', '0' );
		}

		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( '#catalogTypeList' ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			callback.apply(this, [ changedData.concat(resultData) ]);
		}
		
		//조회
		function fn_search() {
			var sUrl = 'catalogCodeLengthList.do';
			
			$( '#catalogTypeList' ).jqGrid( 'clearGridData' );
			$( '#catalogTypeList' ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( '#listForm' )
			} ).trigger( 'reloadGrid' );
		}
		
		//저장
		function fn_save() {
			$( '#catalogTypeList' ).saveCell( kRow, idCol );
			
			var changedData = $( '#catalogTypeList' ).jqGrid( 'getRowData' );
			
			// 변경된 체크 박스가 있는지 체크한다.
			for( var i = 1; i < changedData.length + 1; i++ ) {
				var item = $( '#catalogTypeList' ).jqGrid( 'getRowData', i );
				if( item.oper != 'I' && item.oper != 'U' ) {
					if( item.enable_flag_changed != item.enable_flag ) {
						item.oper = 'U';
					}

					if( item.standard_flag_changed != item.standard_flag ) {
						item.oper = 'U';
					}

					if( item.oper == 'U' ) {
						// apply the data which was entered.
						$( '#catalogTypeList' ).jqGrid( 'setRowData', i, item );
					}
				}
			}
			
			if ( !fn_checkValidate() ) {
				return;
			}
											
			if( confirm( '변경된 데이터를 저장하시겠습니까?' ) != 0 ) {
				var chmResultRows = [];
				
				lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				getChangedChmResultData( function( data ) {
					chmResultRows = data;
					
					var url = 'saveCatalogCodeLength.do';
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var formData = fn_getFormData( '#listForm' );
					var parameters = $.extend( {}, dataList, formData );
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						}
					}, 'json' ).error( function() {
						alert( '시스템 오류입니다.\n전산담당자에게 문의해주세요.' );
					} ).always( function() {
						lodingBox.remove();
					} );
				} );
			}
		}

		//필수입력 체크
		function fn_checkValidate() {
			var result = true;
			var message = '';
			var nChangedCnt = 0;
			var ids = $( '#catalogTypeList' ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( '#catalogTypeList' ).jqGrid( 'getCell', ids[i], 'oper' );

				if( oper == 'I' || oper == 'U' ) {
					nChangedCnt++;

					var val1 = $( '#catalogTypeList' ).jqGrid( 'getCell', ids[i], 'catalog_type' );

					if( $.jgrid.isEmpty( val1) ) {
						result = false;
						message = 'Catalog Type Field is required';

						setErrorFocus( '#catalogTypeList', ids[i], 0, 'catalog_type' );
						break;
					}
				}
			}

			if ( nChangedCnt == 0 ) {
				result = false;
				message = '변경된 내용이 없습니다.';
			}

			if ( !result ) {
				alert( message );
			}

			return result;
		}

		function setErrorFocus( gridId, rowId, colId, colName ) {
			$( '#' + rowId + '_' + colName ).focus();
			$(gridId).jqGrid( 'editCell', rowId, colId, true );
		}
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#catalogTypeList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#catalogTypeList" ).jqGrid( "getGridParam", "colModel" );
			for(var i=1; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			
			var f    = document.listForm;
			f.action = "catalogCodeLengthExcelExport.do";
			f.method = "post";
			f.submit();
		}
		</script>
	</body>
</html>