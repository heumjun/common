<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Item Interface</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<div class= "subtitle">
					Item Interface
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				<table class="searchArea conSearch">	
					<col width="80">
					<col width="140">
					<col width="*">
					<tr>
						<th>Item Code</th>
						<td>
							<input type="text" id="p_item_code" name="p_item_code" class="required w100h25" />
						</td>
						<td style="border-left:none;">
							<div class="button endbox">
								<c:if test="${userRole.attribute1 == 'Y'}"> 
									<input type="button" class="btn_blue" id="btnSearch" name="" value="조회" />
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
									<input type="button" value="　Interface　" id="btnSave" class="btn_blue"/>
								</c:if>
							</div>
						</td>
					</tr>
				</table>
				<div class="content" >
					<table id="itemList"></table>
					<div id="btn_itemList"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var change_item_row 	= 0;
		var change_item_row_num = 0;
		var change_item_col  	= 0;
		
		var resultData = [];
		
		var sUrl = 'itemInterfaceList.do';
		
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
				colNames : [ '선택', 'Item Code', 'Description', 'Catalog', 'Category', 'Ship Type', 'UOM', 'Weight', 
				             'Attr1', 'Attr2', 'Attr3', 'Attr4', 'Attr5', 'Attr6', 'Attr7', 'Attr8', 'Attr9', 'Attr10', 'Attr11', 'Attr12', 'Attr13', 'Attr14', 'Attr15', 
				             'Cable Length', 'Cable Type', 'Cable Outdia', 'Can Size', 'STXSVR', 'Thinner Code', 'STX Standard', 'Paint Code', 
				             'states_code', '상태', '생성자', '최종수정자', '최종수정일' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false }, align : "center" },
				             { name : 'item_code', index : 'item_code', align : 'left', width : 100 },
				             { name : 'item_desc', index : 'item_desc', align : 'left', width : 300 },
				             { name : 'item_catalog', index : 'item_catalog', align : 'center', width : 80 },
				             { name : 'item_category', index : 'item_category', align : 'center', width : 90 },
				             { name : 'ship_pattern', index : 'ship_pattern', align : 'center', width : 70 },
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
				             { name : 'stx_standard', index : 'stx_standard', align : 'left', width : 100 },
				             { name : 'paint_code', index : 'paint_code', align : 'left', width : 100 },
				             { name : 'states_code', index : 'states_code', align : 'left', width : 100, hidden : true },
				             { name : 'states_desc', index : 'states_desc', align : 'left', width : 100 },
				             { name : 'user_name', index : 'user_name', align : 'center', width : 100 },
				             { name : 'last_updated_by', index : 'last_updated_by', align : 'center', width : 100 },
				             { name : 'last_update_date', index : 'last_update_date', align : 'center', width : 110 } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				pager : '#btn_itemList',
				viewrecords : true,
				sortorder : "desc",
				shrinkToFit : false,
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
				},
				onPaging : function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
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
				}
			} );
			
			//grid resize
		    fn_gridresize( $(window), $( "#itemList" ) );
		} );
		
		
		function fn_init() {
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );
			
			$( "#btnSave" ).click( function() {
				fn_save();
			} );
		} // end function fn_init()
		
		//조회
		function fn_search() {
			if( $( "#p_item_code" ).val() == "" ) {
				alert( "Item Code를 입력 후 조회하세요." );
				return;
			}
			
			$( "#itemList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//item interface
		function fn_save() {
			$( '#itemList' ).saveCell( change_item_row_num, change_item_col );
			
			//변경된 row만 가져 오기 위한 함수
			getChangedChmResultData( function( data ) {
				chmResultRows = data;
				
				if( chmResultRows.length == 0 ) {
					alert("Interface 대상 Item을 선택해 주세요.");
					return
				} else {
					lodingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveItemToErp.do';
					var formData = fn_getFormData('#application_form');
					//객체를 합치기. dataList를 기준으로 formData를 합친다.
					var parameters = $.extend( {}, dataList, formData); 
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						fn_search();
					}, "json" ).error( function () {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
				    	lodingBox.remove();	
					} );
				}
			} );
		}
		
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#itemList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		</script>
	</body>
</html>
