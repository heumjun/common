<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Model Management</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form name="listForm" id="listForm">
				<input type="hidden" name="h_ship_category" id="h_ship_category" />
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}" />
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>
				<div class="subtitle">
					Model Management
					<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
					<table class="searchArea conSearch">
					<col width="80px">
					<col width="100px">
					<col width="80px">
					<col width="300px">
					<col width="*">
						<tr>
							<th>Model</th>
							<td>
								<input type="text" id="p_model_no" name="p_model_no" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
							</td>
							
							<th>Description</th>
							<td>
								<input type="text" id="p_desc" name="p_desc" style="width:270px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
							</td>
							<td>
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
					<table id="modelMgntList"></table>
					<div id="btn_modelMgnt"></div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var idRow;
		var idCol;
		var kRow;
		var kCol;
		var tableId;
		var resultData = [];

		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			$( "#modelMgntList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : '',
				postData : fn_getFormData( "#listForm" ),
				colNames : [ 'Model', 'Model Type', 'Category', 'ship_type', 'Type',
				             'Description', 'Marketing Name', 'Marketing Text', 'Speed', '담당자', 
				             'class1', 'class2', 'Intended Cargo', 'Bulk Head', 'Ice Class', 'Cargo Pump', 
				             'Segregation', 'Cargo Hold', 'Capacity', 'GT', 'Principal Particulars', 
				             'Bow Thruster', '사용유무', '사용유무_changed', 'Oper' ],
				colModel : [{ name : 'model_no', index : 'model_no', width : 100, editable : true, editrules : { required : true } },
				            { name : 'model_type', index : 'model_type', width : 100, editable : true, editrules : { required : false } },
				            { name : 'category', index : 'category', width : 170, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'ship_type', index : 'ship_type', width : 30, hidden : true },
				             { name : 'ship_type_desc', index : 'ship_type_desc', width : 300, editable : false, align : 'left' },
				             //{ name : 'ship_type_popup', index : 'ship_type_popup', width : 30, editable : false, align : 'center' },
				             
				             { name : 'description', index : 'description', width : 150, editable : true, }, 
				             { name : 'marketing_name', index : 'marketing_name', width : 150, editable : true, }, 
				             { name : 'marketing_text', index : 'marketing_text', width : 150, editable : true, }, 
				             { name : 'speed', index : 'speed', width : 50, editable : true, }, 
				             { name : 'created_name', index : 'created_name', width : 50, editable : false, align : 'center' },
				             
				             { name : 'class_code', index : 'class_code', width : 180, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'class_code2', index : 'class_code2', width : 180, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, },
				             { name : 'intended_cargo', index : 'intended_cargo', width : 100, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'bulk_head_code', index : 'bulk_head_code', width : 100, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'ice_class_code', index : 'ice_class_code', width : 70, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'cargo_pump_code', index : 'cargo_pump_code', width : 100, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, },
				             
				             { name : 'segregation_code', index : 'segregation_code', width : 80, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'cargo_hold_code', index : 'cargo_hold_code', width : 90, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'capacity', index : 'capacity', width : 100, editable : true, align : 'right' }, 
				             { name : 'gt', index : 'gt', width : 100, editable : true, }, 
				             { name : 'principal_particulars', index : 'principal_particulars', width : 140, editable : true, },

				             { name : 'bow_thruster_code', index : 'bow_thruster_code', width : 100, sortable : false, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, },
				             { name : 'enable_flag', index : 'enable_flag', align : "center", width : 30, editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', hidden : true },
				             { name : 'oper', index : 'oper', hidden : true } ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				//shrinkToFit : false,
				autowidth : true,
				height : objectHeight,
				pager : $('#btn_modelMgnt'),
				cellEdit : true, // grid edit mode 1
				cellsubmit : 'clientArray', // grid edit mode 2
				rowList : [ 100, 500, 1000 ],
				rowNum : 100,
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					idRow = rowid;
					idCol = iCol;
					kRow = iRow;
					kCol = iCol;
				},
				beforeSaveCell : chmResultEditEnd,
				jsonReader : {
					root : "rows",
					page : "page",
					total : "total",
					records : "records",
					repeatitems : false,
				},
				imgpath : 'themes/basic/images',
				onPaging : function(pgButton) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					 * on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					 * where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					 */
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
				},
				loadComplete : function(data) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype') === 'json' ) {
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
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					$(this).saveCell( kRow, kCol );
					
					var cm = $(this).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $(this).jqGrid( 'getRowData', rowid );
					
					if( rowid != null ) {
						if( item.oper != "I" ) {
							$(this).jqGrid( 'setCell', rowid, 'model_no', '', 'not-editable-cell' );
							
						}
					}
					
					if ( colName['index'] == "ship_type_desc" ) {
						$( "#h_ship_category" ).val( item.category );
						if( item.category == "" ) {
							alert( "Category를 먼저 선택해 주세요." );
						} else {
							var rs = window.showModalDialog( "popUpModelShipType.do",
									window,
									"dialogWidth:500px; dialogHeight:400px; center:on; scroll:off; status:off" );
							
							if ( rs != null ) {
								$(this).setRowData( rowid, { ship_type : rs[0] } );
								$(this).setRowData( rowid, { ship_type_desc : rs[1] } );

								if ( item.oper != 'I' ) {
									$(this).setRowData( rowid, { oper : "U" } );
								}
							}
						}
					}
				},
				gridComplete : function () {
					//팝업버튼 표시 
					var rows = $(this).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var oper = $( "#modelMgntList" ).getCell( rows[i], "oper" );

						if( oper != "I" ) {
							$(this).jqGrid( 'setCell', rows[i], 'model_no', '', { color : 'black', background : '#DADADA' } );
							
						}
						if( oper != "U" ) {
							$(this).jqGrid( 'setCell', rows[i], 'ship_type_desc', '', { color : 'black', background : 'pink' } );	
						}
						
						
					}
					
				}
			} );

			//grid resize
			fn_gridresize( $(window), $( "#modelMgntList" ) );

			$( "#modelMgntList" ).jqGrid( 'navGrid', "#btn_modelMgnt", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			<c:if test="${userRole.attribute1 == 'Y'}">
			//Refresh
			$( "#modelMgntList" ).navButtonAdd( '#btn_modelMgnt', {
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
			$( "#modelMgntList" ).navButtonAdd( '#btn_modelMgnt', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#modelMgntList" ).navButtonAdd( '#btn_modelMgnt', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			//그리드 내 콤보박스 바인딩
			$.post( "infoComboCodeMaster.do?sd_type=SHIP_CATEGORY", "", function( data ) {
				$( '#modelMgntList' ).setObject({
					value : 'value',
					text : 'text',
					name : 'category',
					data : data
				} );
			}, "json");
			
			$.post( "infoComboCodeMaster.do?sd_type=INTENDED_CARGO", "", function( data ) {
				$( '#modelMgntList' ).setObject({
					value : 'value',
					text : 'text',
					name : 'intended_cargo',
					data : data
				} );
			}, "json");			

			$.post( "infoComboCodeMaster.do?sd_type=BULK_HEAD_TYPE", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'bulk_head_code',
					data : data
				} );
			}, "json" );

			$.post( "infoComboCodeMaster.do?sd_type=ICE_CLASS", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'ice_class_code',
					data : data
				} );
			}, "json" );

			$.post( "infoComboCodeMaster.do?sd_type=CARGO_PUMP", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'cargo_pump_code',
					data : data
				} );
			}, "json" );

			$.post( "infoComboCodeMaster.do?sd_type=SEGREGATION", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'segregation_code',
					data : data
				} );
			}, "json" );

			$.post( "infoComboCodeMaster.do?sd_type=CARGO_HOLD", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'cargo_hold_code',
					data : data
				} );
			}, "json" );

			$.post( "infoComboCodeMaster.do?sd_type=CLASS", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'class_code',
					data : data
				} );
			}, "json" );
			
			$.post( "infoComboCodeMaster.do?sd_type=CLASS", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'class_code2',
					data : data
				} );
			}, "json" );
			
			$.post( "infoComboCodeMaster.do?sd_type=BOW_THRUSTER", "", function( data ) {
				$( '#modelMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'bow_thruster_code',
					data : data
				} );
			}, "json" );

			//조회 버튼
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );

			//저장버튼
			$( "#btnSave" ).click( function() {
				fn_save();
			} );
			
			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
			
		} ); //end of ready Function 

		//그리드 변경된 내용을 가져온다.
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#modelMgntList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//조회
		function fn_search() {
			var sUrl = "modelMgntList.do";

			$( "#modelMgntList" ).jqGrid( "clearGridData" );
			$( "#modelMgntList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#listForm" )
			} ).trigger( "reloadGrid" );
		}
		
		//저장
		function fn_save() {
			$( '#modelMgntList' ).saveCell( kRow, idCol );
			
			var ids = $( "#modelMgntList" ).jqGrid( 'getDataIDs' );
			
			// 변경된 체크 박스가 있는지 체크한다.
			for( var i = 1; i < ids.length + 1; i++ ) {
				var item = $( '#modelMgntList' ).jqGrid( 'getRowData', ids[i] );
				
				if ( item.oper != 'I' && item.oper != 'U' ) {
					if ( item.enable_flag_changed != item.enable_flag ) {
						item.oper = 'U';
					}
					
					if ( item.oper == 'U' ) {
						// apply the data which was entered.
						$('#modelMgntList').jqGrid( "setRowData", ids[i], item );
					}
				}
			}
			
			//변경 사항 Validation
			if( !fn_checkValidate() ) {
				return;
			}
			
			if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
				var chmResultRows = [];
				
				getChangedChmResultData(function( data ) {
					chmResultRows = data;
					var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
					var url = 'saveModelMgnt.do';
					var formData = fn_getFormData( '#listForm' );
					var parameters = $.extend( {}, dataList, formData );

					loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
					
					$.post( url, parameters, function( data ) {
						alert(data.resultMsg);
						if ( data.result == 'success' ) {
							fn_search();
						}
					}, "json").error( function() {
						alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
					} ).always( function() {
						loadingBox.remove();
					} );
				} );
			}
		}

		//변경 사항 Validation 
		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#modelMgntList" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#modelMgntList" ).jqGrid( 'getCell', ids[i], 'oper' );
				if( oper == 'I' || oper == 'U') {
					nChangedCnt++;
					/* var val1 = $( "#modelMgntList" ).jqGrid( 'getCell', ids[i], 'model_name' );
					if ( $.jgrid.isEmpty( val1 ) ) {
						alert( "Model을 입력하십시오." );
						result = false;
						message = "Field is required";
// 						setErrorFocus( "#modelMgntList", ids[i], 0, 'model_name' );
						break;
					} */
					
					var val3 = $( "#modelMgntList" ).jqGrid( 'getCell', ids[i], 'model_no' );
					if ( $.jgrid.isEmpty( val3 ) ) {
						alert( "Model를 입력하십시오." );
						result = false;
						message = "Field is required";
 						setErrorFocus( "#modelMgntList", ids[i], 0, 'model_no' );
						break;
					}
					
					var val2 = $( "#modelMgntList" ).jqGrid( 'getCell', ids[i], 'ship_type' );
					if ( $.jgrid.isEmpty( val2 ) ) {
						alert( "Type을 입력하십시오." );
						result = false;
						message = "Field is required";
 						setErrorFocus( "#modelMgntList", ids[i], 0, 'ship_type' );
						break;
					}
					
					if ( val2 == "ALL" ) {
						alert( "Type을 입력하십시오." );
						result = false;
						message = "Field is required";
// 						setErrorFocus( "#modelMgntList", ids[i], 0, 'model_name' );
						break;
					}
				}
			}

			if ( nChangedCnt == 0 ) {
				result = false;
				alert( "변경된 내용이 없습니다." );
			}

// 			if (!result) {
// 			}

			return result;
		}

		//Del 버튼
		function deleteRow() {
			$( '#modelMgntList' ).saveCell( kRow, kCol );

			var selrow = $( '#modelMgntList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#modelMgntList' ).jqGrid( 'getRowData', selrow );

			if (item.oper == 'I') {
				$( '#modelMgntList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert( '저장된 데이터는 삭제할 수 없습니다.' );
			}
			
			$( '#modelMgntList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow(item) {
			$( '#modelMgntList' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#modelMgntList' ).jqGrid( 'getGridParam', 'colModel' );
			for( var i in colModel )
				item[colModel[i].name] = '';
			
			item.oper = 'I';
			item.ship_type_popup = '...';
			item.enable_flag = 'Y';

			$( '#modelMgntList' ).resetSelection();
			$( '#modelMgntList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
			tableId = '#modelMgntList';
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd(irowId, cellName, value, irow, iCol) {
			var item = $( '#modelMgntList' ).jqGrid( 'getRowData', irowId );
			
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#modelMgntList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			}
				
			
			$( '#modelMgntList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );

			/* //변경 된 row 이면 색 변경
			var ids = $( '#modelMgntList' ).jqGrid( 'getDataIDs' );

			if( item.oper == "U" ) {
				$( '#modelMgntList' ).jqGrid('setCell', ids[irow], ids[iCol - 1], '', { 'background' : '#6DFF6D' } );
			} */
		}
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#modelMgntList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#modelMgntList" ).jqGrid( "getGridParam", "colModel" );
			for(var i=0; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			var f    = document.listForm;
			f.action = "modelMgntExcelExport.do";
			f.method = "post";
			f.submit();
		}
		
		</script>
	</body>
</html>