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
					CatalogCodeLength
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

				<th>CATALOG CODE</th>
				<td>
					<input type="text" id="p_catalog_code" name="p_catalog_code" class="toUpper wid200" />
				</td>

				<th>CATALOG DESC</th>
				<td>
					<input type="text" id="p_catalog_desc" name="p_catalog_desc" class="toUpper wid200"/>
				</td>
				
				<th>CATALOG LENGTH</th>
				<td style="border-right:none;">
					<input type="text" id="p_catalog_length" name="p_catalog_length" class="toUpper wid200"/>
				</td>
				
				<td style="border-left:none;">
					<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" class="btnAct btn_blue" id="btnSearch" name="btnSearch" value="조회" />
						</c:if>
						<c:if test="${userRole.attribute5 == 'Y'}">
							<input type="button" value="Excel출력" id="btnExcelExport" class="btn_blue" />
						</c:if>
					</div>
				</td>
				</tr>
			</table>
						
			<div class="content">
				<table id="catalogLengthList"></table>
				<div id="pcatalogLengthList"></div>
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
			
			$( '#catalogLengthList' ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : fn_getFormData( '#listForm' ),
				colNames : [ 'Catalog Code', 'Catalog Description', 'Catalog Length', 'crud' ],
				colModel : [ { name : 'catalog_code', index : 'catalog_code', width : 100, editable : false, align : "center" }, 
				             { name : 'catalog_desc', index : 'catalog_desc', width : 200, editable : false }, 
				             { name : 'catalog_length', index : 'catalog_length', width : 150, editable : false, align : "center" }, 
				             { name : 'oper', index : 'oper', width : 25, hidden : true }, ],
				gridview : true,
				cmTemplate: { title: false },
				toolbar : [ false, 'bottom' ],
				viewrecords : true,
				autowidth : true,
				height : objectHeight,
				pager : $('#pcatalogLengthList'),
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
						var ret = $( '#catalogLengthList' ).getRowData( row_id );

						if (ret.oper == '')
							$( '#catalogLengthList' ).jqGrid( 'setCell', row_id, 'catalog_type', '', 'not-editable-cell' );
					}
				},
				gridComplete : function() {

				}
			} );

			//grid resize
			fn_gridresize( $(window), $( '#catalogLengthList' ) );

			$( '#catalogLengthList' ).jqGrid( 'navGrid', '#pcatalogLengthList', {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );			
			
			//조회 버튼
			$( '#btnSearch' ).click( function() {
				fn_search();
			} );
			
			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
		} ); //end of ready Function 
		
		//조회
		function fn_search() {
			var sUrl = 'catalogCodeLengthList.do';
			
			$( '#catalogLengthList' ).jqGrid( 'clearGridData' );
			$( '#catalogLengthList' ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( '#listForm' )
			} ).trigger( 'reloadGrid' );
		}		
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#catalogLengthList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#catalogLengthList" ).jqGrid( "getGridParam", "colModel" );
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