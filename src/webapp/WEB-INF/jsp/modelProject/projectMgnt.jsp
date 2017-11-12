<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Project Management</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
		<style>
		.ui-jqgrid .ui-jqgrid-htable th div {
		    height:auto;
		    overflow:hidden;
		    padding-right:0px;
		    padding-left:0px;
		    padding-top:0px;
		    padding-bottom:1px;
		    position:relative;
		    vertical-align:tetext-top;
		    white-space:normal !important;
		}
		</style>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<div class="subtitle">
				Project Management
				<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
				<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
			</div>
			<form name="listForm" id="listForm">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" name="rowid" id="rowid" />
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				<input type="hidden" id="p_col_name" name="p_col_name"/>
				<input type="hidden" id="p_data_name" name="p_data_name"/>


					
				
				<!--
				<div class="searchbox">
				<div class="conSearch" >
				
				<label class="sc_tit">Project Name</label>
				<input type="text" id="p_project_no" name="p_project_no" style="width:300px; text-transform: uppercase;" />				

				<div class="button endbox">
					<input type="button" class="btn_blue" id="btnSave" value="저장" />
					<input type="button" class="btn_blue" id="btnSearch" value="조회" />
				</div>
	
				</div>
				</div>	
				-->
					
					<table class="searchArea conSearch">
						<col width="65px">
						<col width="100px">
						<col width="75px">
						<col width="100px">
						<col width="65px">
						<col width="100px">
						<col width="85px">
						<col width="100px">
						<col width="65px">
						<col width="100px">
						<col width="65px">
						<col width="100px">
						<col width="*">

						<tr>
						<th>Project</th>
						<td>
							<input type="text" id="p_project_no" name="p_project_no" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
						</td>
						
						<th>Model No</th>
						<td>
							<input type="text" id="p_model_no" name="p_model_no" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
						</td>
						
						<th>대표호선</th>
						<td>
							<input type="text" id="p_representative_pro_num" name="p_representative_pro_num" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
						</td>
						
						<th>Paint 대표호선</th>
						<td>
							<input type="text" id="p_pis_representative_pro_num" name="p_pis_representative_pro_num" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
						</td>
						
						<th>사용유무</th>
						<td>
							<select name="p_enable_flag" class="commonInput" style="width:50px;">
							<option value="ALL" selected="selected">ALL</option>
							<option value="Y" >Y</option>
							<option value="N" >N</option>
						</select>
						</td>

						<th>문서호선</th>
						<td style="border-right:none;">
							<input type="text" id="p_doc_project_no" name="p_doc_project_no" style="width:80px; text-transform: uppercase;" onkeydown="javascript:this.value=this.value.toUpperCase();"/>
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

					<!--	
					Project Name
					<input type="text" id="p_project_no" name="p_project_no" style="width: 100px; text-transform: uppercase;" />
					<div class="button">
						<input type="button" value="저장" id="btnSave" />
						<input type="button" value="조회" id="btnSearch" />
					</div>
					-->
					
				<div class="content">
					<div class="content">
						<table id="projectMgntList"></table>
						<div id="btn_projectMgnt"></div>
					</div>
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
		
		var loadingBox;

		$(document).ready( function() {
			fn_all_text_upper();
			
			var objectHeight = gridObjectHeight(1);
			
			var sUrl = '';

			//key evant 
			$( "input[type=text]" ).keypress( function( event ) {
				if( event.which == 13 ) {
					event.preventDefault();
					$( '#btnSearch' ).click();
				}
			} );
			
			var is_hidden = true;
			var is_paint_user = false;
			if ("${userRole.attribute2}" != "Y") {
				is_paint_user = true;
			}
			
			$( "#projectMgntList" ).jqGrid( {
				datatype : 'json',
				mtype : '',
				url : sUrl,
				postData : fn_getFormData( "#listForm" ),
				colNames : [ 'Project', 'Model No', 'Model', 'Marketing Text', 'STX Site', '대표호선', '대표호선<br>유무', 'representative_pro_yn_changed', '차수', '참조호선', 'CLASS1', 'CLASS2', 'FLAG', 'BUYER', '사용유무', 'enable_flag_changed', 'PAINT<br>RULE', 'PAINT RULE_changed','PAINT<br>대표호선', 'SUPPLY<br>FLAG', 'SUPPLY<br>FLAG_flag', 'SUPPLY<br>CLOSE', 'SUPPLY CLOSE_flag', '계획인도일', '실인도일', '호선상태', 'D/L<br>FLAG', 'D/L FLAG_flag', '문서호선', '문서호선<br>사용유무', '문서호선 사용유무_flag', 'Oper' ],
				colModel : [ { name : 'project_no', index : 'project_no', width : 36, editable : true, align : 'center', editrules : { required : true }, editoptions: {maxlength : 10, dataInit: function (el) { $(el).css('text-transform', 'uppercase'); }} }, 
				             { name : 'model_no', index : 'model_no', width : 50, editable : false, align : 'center' },
				             { name : 'model_desc', index : 'model_desc', width : 70, hidden : is_hidden },
				             //{ name : 'model_popup', index : 'model_popup', width : 30, editable : false, align : 'center' },
				             { name : 'marketing_text', index : 'marketing_text', width : 120, editable : true }, 
				             { name : 'stxsite', index : 'stxsite', width : 50, editable : true, edittype : "select", formatter : 'select', align : 'center', editrules : { required : true }, hidden:true}, 
				             { name : 'representative_pro_num', width : 40, index : 'representative_pro_num', align : "center", editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'representative_pro_yn', width : 40, index : 'representative_pro_yn', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" }, 
				             { name : 'representative_pro_yn_changed', index : 'representative_pro_yn_changed', width : 70, hidden : is_hidden }, 
				             { name : 'series', index : 'series', width : 25, editable : true, align : 'center' }, 
				             { name : 'reference_pro_num', index : 'reference_pro_num', width : 40, editable : true, align : 'center', edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'class1', index : 'class1', align : "left", width : 110, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'class2', index : 'class2', align : "left", width : 110, editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, }, 
				             { name : 'flag', index : 'flag', align : "left", width : 60, editable : true, }, 
				             { name : 'buyer', index : 'buyer', width : 80, editable : true }, 
				             { name : 'enable_flag', width : 40, index : 'enable_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'enable_flag_changed', index : 'enable_flag_changed', hidden : is_hidden },
				             { name : 'paint_new_rule_flag', width : 40, index : 'paint_new_rule_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'paint_new_rule_flag_changed', index : 'paint_new_rule_flag_changed', hidden : is_hidden },
				             { name : 'pis_representative_pro_num', width : 40, index : 'pis_representative_pro_num', align : "center", editable : true, edittype : "select", formatter : 'select', editrules : { required : true }, },
				             { name : 'supply_enable_flag', width : 40, index : 'supply_enable_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'supply_enable_flag_changed', index : 'supply_enable_flag_changed', hidden : is_hidden },
				             { name : 'supply_close_flag', width : 40, index : 'supply_close_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'supply_close_flag_changed', index : 'supply_close_flag_changed', hidden : is_hidden },
				             { name : 'saps_dl', index : 'saps_dl', width : 50, editable : true, align : 'center' }, 
				             { name : 'erp_indo_date', index : 'erp_indo_date', width : 50, editable : true, align : 'center' }, 
				             { name : 'erp_status', index : 'erp_status', width : 50, editable : true, align : 'center' }, 
				             { name : 'dl_flag', width : 40, index : 'dl_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'dl_flag_changed', index : 'dl_flag_changed', hidden : is_hidden },
				             { name : 'doc_project_no', index : 'series', width : 40, editable : true, align : 'center' }, 
				             { name : 'doc_enable_flag', width : 40, index : 'doc_enable_flag', align : "center", editable : true, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : is_paint_user }, classes : "onlyedit" },
				             { name : 'doc_enable_flag_changed', index : 'doc_enable_flag_changed', hidden : is_hidden },
				             { name : 'oper', index : 'oper', hidden : is_hidden, width : 50 }
				             ],
				gridview : true,
				toolbar : [ false, "bottom" ],
				viewrecords : true,
// 				shrinkToFit : false,
				autowidth : true,
				height : objectHeight,
				pager : $('#btn_projectMgnt'),
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
				afterSaveCell  : function(rowid,name,val,iRow,iCol) {
	            	if (name == "project_no") setUpperCase("#projectMgntList",rowid,name);	
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
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					
					
					var cm = $(this).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $(this).jqGrid( 'getRowData', rowid );
					if(!is_paint_user){
						if ( colName['index'] == "model_no" ) {
							$( "#h_ship_category" ).val( item.category );
							if( item.category == "" ) {
								alert( "Category를 먼저 선택해 주세요." );
							} else {
								var rs = window.showModalDialog( "popUpModel.do",
										window,
										"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
								
								if ( rs != null ) {
									
									$(this).setRowData( rowid, { model_no : rs[0] } );
									$(this).setRowData( rowid, { model_desc : rs[1] } );

									var item = $(this).jqGrid( 'getRowData', rowid );

									if ( item.oper != 'I' ) {
										$(this).setRowData( rowid, { oper : "U" } );
									}
								}
							}
						}
					}
					
				},
				gridComplete : function () {
					//팝업버튼 표시
					var rows = $(this).getDataIDs();
					for ( var i = 0; i < rows.length; i++ ) {
						var ret = $(this).getRowData( rows[i] );
						if( ret.oper != "I" ){
							$(this).jqGrid( 'setCell', rows[i], 'project_no', '', { color : 'black', background : '#DADADA' } );	
							$(this).jqGrid( 'setCell', rows[i], 'project_no', '', 'not-editable-cell' );
						}
						if(is_paint_user){
							$(this).jqGrid( 'setCell', rows[i], 'model_no', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'model_no', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'marketing_text', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'marketing_text', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'stxsite', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'stxsite', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'representative_pro_num', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'representative_pro_num', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'representative_pro_yn', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'representative_pro_yn', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'series', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'series', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'reference_pro_num', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'reference_pro_num', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'class1', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'class1', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'class2', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'class2', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'buyer', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'buyer', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'enable_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'enable_flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'paint_new_rule_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'paint_new_rule_flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'supply_enable_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'supply_enable_flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'supply_close_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'supply_close_flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'dl_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'dl_flag', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'doc_project_no', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'doc_project_no', '', { color : 'black', background : '#DADADA' } );
							$(this).jqGrid( 'setCell', rows[i], 'doc_enable_flag', '', 'not-editable-cell' );
							$(this).jqGrid( 'setCell', rows[i], 'doc_enable_flag', '', { color : 'black', background : '#DADADA' } );
						} else {
							$(this).jqGrid( 'setCell', rows[i], 'model_no', '', { color : 'black', background : 'pink' } );	
						}
						
						
					}
				}
			});

			//grid resize
			fn_gridresize( $(window), $( "#projectMgntList" ) );

			$( "#projectMgntList" ).jqGrid( 'navGrid', "#btn_projectMgnt", {
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			<c:if test="${userRole.attribute3 == 'Y'}">
			$( "#projectMgntList" ).navButtonAdd( '#btn_projectMgnt', {
				caption : "",
				buttonicon : "ui-icon-minus",
				onClickButton : deleteRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>
			
			<c:if test="${userRole.attribute2 == 'Y'}">
			$( "#projectMgntList" ).navButtonAdd( '#btn_projectMgnt', {
				caption : "",
				buttonicon : "ui-icon-plus",
				onClickButton : addChmResultRow,
				position : "first",
				title : "",
				cursor : "pointer"
			} );
			</c:if>

			/* //그리드 내 콤보박스 바인딩
			$.post( "getProjectCodeList.do?codeType=MODEL", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'model',
					data : data
				} );
			}, "json" ); */
			
			//그리드 내 콤보박스 바인딩
			$.post("infoComboCodeMaster.do?sd_type=STX_SITE", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'stxsite',
					data : data
				} );
			}, "json" );
			
			//그리드 내 콤보박스 바인딩 - 대표호선
// 			$.post( "getMasterList.do?codeType=REPRESENTATIVE_PRO_NUM", "", function( data ) {
// 				$( '#projectMgntList' ).setObject( {
// 					value : 'value',
// 					text : 'text',
// 					name : 'representative_pro_num',
// 					data : data.list
// 				} );
// 			}, "json" );
			
			//그리드 내 콤보박스 바인딩 - 참조호선
// 			$.post( "getProjectList.do?codeType=REFERENCE_PRO_NUM", "", function( data ) {
// 				$( '#projectMgntList' ).setObject( {
// 					value : 'value',
// 					text : 'text',
// 					name : 'reference_pro_num',
// 					data : data.list
// 				} );
// 			}, "json" );
			
			//그리드 내 콤보박스 바인딩
			$.post( "infoComboCodeMaster.do?sd_type=CLASS", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'class1',
					data : data
				} );
			}, "json" );
			
			//그리드 내 콤보박스 바인딩
			$.post( "infoComboCodeMaster.do?sd_type=CLASS", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'class2',
					data : data
				} );
			}, "json" );
			
			//model 콤보박스
// 			$.post( "getProjectModelCodeList.do", "", function( data ) {
// 				$( '#projectMgntList' ).setObject( {
// 					value : 'value',
// 					text : 'text',
// 					name : 'model',
// 					data : data
// 				} );
// 			}, "json" );

			//대표호선, 참조호선 콤보박스 로딩
			fn_comboboxload();

			//조회 버튼
			$( "#btnSearch" ).click( function() {
				fn_search();
			} );

			//저장버튼
			$( "#btnSave" ).click( function() {
				$( '#projectMgntList' ).saveCell( kRow, idCol );

				var changedData = $( "#projectMgntList" ).jqGrid( 'getRowData' );

				// 변경된 체크 박스가 있는지 체크한다.
				for( var i = 1; i < changedData.length + 1; i++ ) {
					var item = $( '#projectMgntList' ).jqGrid( 'getRowData', i );
					if( item.oper != 'I' && item.oper != 'U' ) {
						if( item.representative_pro_yn_changed != item.representative_pro_yn ) {
							item.oper = 'U';
						}
						
						if( item.enable_flag_changed != item.enable_flag ) {
							item.oper = 'U';
						}
						
						if( item.paint_new_rule_flag_changed != item.paint_new_rule_flag ) {
							item.oper = 'U';
						}
						
						if( item.supply_enable_flag_changed != item.supply_enable_flag ) {
							item.oper = 'U';
						}
						
						if( item.supply_close_flag_changed != item.supply_close_flag ) {
							item.oper = 'U';
						}
						
						if( item.dl_flag_changed != item.dl_flag ) {
							item.oper = 'U';
						}
						
						if( item.doc_enable_flag_changed != item.doc_enable_flag ) {
							item.oper = 'U';
						}
						
						if (item.oper == 'U') {
							// apply the data which was entered.
							$( '#projectMgntList' ).jqGrid( "setRowData", i, item );
						}
					}
				}

				if( !fn_checkValidate() ) {
					return;
				}

				if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
					var chmResultRows = [];
					getChangedChmResultData( function( data ) {
						loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
						chmResultRows = data;
						var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
						var url = 'saveProjectMgnt.do';
						var formData = fn_getFormData( '#listForm' );
						var parameters = $.extend( {}, dataList, formData );
						$.post( url, parameters, function( data ) {							
							alert(data.resultMsg);
							fn_comboboxload();
							if ( data.result == 'success' ) {
								fn_search();
							}
						}, "json" ).error( function() {
							alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
						} ).always( function() {
							loadingBox.remove();
						} );
					} );
				}
			} );
			
			
			//엑셀 export 버튼
			$("#btnExcelExport").click(function() {
				fn_downloadStart();
				fn_excelDownload();	
			});
			
		} ); //end of ready Function 

		//그리드 변경된 내용을 가져온다.
		function getChangedChmResultData( callback ) {
			var changedData = $.grep( $( "#projectMgntList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
			} );
			
			callback.apply(this, [ changedData.concat(resultData) ]);
		};

		//조회
		function fn_search() {
			var sUrl = "projectMgntList.do";

			$( "#projectMgntList" ).jqGrid( "clearGridData" );
			$( "#projectMgntList" ).jqGrid( 'setGridParam', {
				mtype : 'POST',
				url : sUrl,
				datatype : 'json',
				page : 1,
				postData : fn_getFormData( "#listForm" )
			} ).trigger( "reloadGrid" );

			//콤보 박스 로드.
			fn_comboboxload();
		}

		function fn_checkValidate() {
			var result = true;
			var message = "";
			var nChangedCnt = 0;
			var ids = $( "#projectMgntList" ).jqGrid( 'getDataIDs' );

			for( var i = 0; i < ids.length; i++ ) {
				var oper = $( "#projectMgntList" ).jqGrid( 'getCell', ids[i], 'oper' );
				if( oper == 'I' || oper == 'U' ) {
					nChangedCnt++;
					var val1 = $( "#projectMgntList" ).jqGrid( 'getCell', ids[i], 'project_no' );
					if( $.jgrid.isEmpty( val1 ) ) {
						alert( "Project Name을 입력하십시오." );
						result = false;
						message = "Field is required";
// 						setErrorFocus( "#projectMgntList", ids[i], 0, 'project_no' );
						break;
					}
					var val2 = $( "#projectMgntList" ).jqGrid( 'getCell', ids[i], 'model_no' );
					if( $.jgrid.isEmpty( val2 ) ) {
						alert( "Model을 입력하십시오." );
						result = false;
						message = "Field is required";
// 						setErrorFocus( "#projectMgntList", ids[i], 0, 'project_no' );
						break;
					}
				}
			}

			if( nChangedCnt == 0 ) {
				result = false;
				message = "변경된 내용이 없습니다.";
			}

			/* if ( !result ) {
				alert( message );
			} */

			return result;
		}
		
		function fn_comboboxload() {
			//참조호선 콤보박스
			$.post( "infoProjectSelectBox.do?type=PROJECT", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'reference_pro_num',
					data : data
				} );
			}, "json" );

			//대표호선 콤보박스
			$.post( "infoProjectSelectBox.do?type=MASTER", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'representative_pro_num',
					data : data
				} );
			}, "json" );
			
			//참조호선 콤보박스
			$.post( "infoProjectSelectBox.do?type=PROJECT", "", function( data ) {
				$( '#projectMgntList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'pis_representative_pro_num',
					data : data
				} );
			}, "json" );
		}
		
		//Del 버튼
		function deleteRow() {
			$( '#projectMgntList' ).saveCell( kRow, kCol );

			var selrow = $( '#projectMgntList' ).jqGrid( 'getGridParam', 'selrow' );
			var item = $( '#projectMgntList' ).jqGrid( 'getRowData', selrow );

			if (item.oper == 'I') {
				$( '#projectMgntList' ).jqGrid( 'delRowData', selrow );
			} else {
				alert( '저장된 데이터는 삭제할 수 없습니다.' );
			}

			$( '#projectMgntList' ).resetSelection();
		}

		//Add 버튼 
		function addChmResultRow() {
			$( '#projectMgntList' ).saveCell( kRow, idCol );

			var item = {};
			var colModel = $( '#projectMgntList' ).jqGrid( 'getGridParam', 'colModel' );
			for( var i in colModel )
				item[colModel[i].name] = '';
			
			item.oper = 'I';
			item.enable_flag = 'Y';
			item.paint_new_rule_flag = 'Y';
			item.supply_enable_flag = 'Y';
			item.supply_close_flag = 'Y';
			item.dl_flag = 'N';
			item.doc_enable_flag = 'Y';
			item.model_popup = '...';

			$( '#projectMgntList' ).resetSelection();
			$( '#projectMgntList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}

		//afterSaveCell oper 값 지정
		function chmResultEditEnd( irowId, cellName, value, irow, iCol ) {
			var item = $( '#projectMgntList' ).jqGrid( 'getRowData', irowId );
			if( item.oper != 'I' ){
				item.oper = 'U';
				$( '#projectMgntList' ).jqGrid('setCell', irowId, cellName, '', { 'background' : '#6DFF6D' } );
			}
			
			$( '#projectMgntList' ).jqGrid( "setRowData", irowId, item );
			$( "input.editable,select.editable", this ).attr( "editable", "0" );

			/* //변경 된 row 이면 색 변경
			var ids = $( '#projectMgntList' ).jqGrid( 'getDataIDs' );
			if (item.oper == "U") {
				$( '#projectMgntList' ).jqGrid( 'setCell', ids[irow - 1], ids[iCol - 1], '', { 'background' : '#6DFF6D' } );
			} */
		}
		// 그리드 cell편집시 대문자로 변환하는 함수
		function setUpperCase(gridId, rowId, colNm){
			
			if (rowId != 0 ) {
				
				var $grid  = $(gridId);
				var sTemp  = $grid.jqGrid("getCell", rowId, colNm);
						
				$grid.jqGrid("setCell", rowId, colNm, sTemp.toUpperCase());
			}
		}
		
		//엑셀 다운로드 화면 호출
		function fn_excelDownload() {
			//그리드의 label과 name을 받는다.
			//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
			var colName = new Array();
			var dataName = new Array();
			
			var cn = $( "#projectMgntList" ).jqGrid( "getGridParam", "colNames" );
			var cm = $( "#projectMgntList" ).jqGrid( "getGridParam", "colModel" );
			for(var i=0; i<cm.length; i++ ){
				
				if(cm[i]['hidden'] == false) {
					colName.push(cn[i]);
					dataName.push(cm[i]['index']);	
				}
			}
			$( '#p_col_name' ).val(colName);
			$( '#p_data_name' ).val(dataName);
			var f    = document.listForm;
			f.action = "projectMgntExcelExport.do";
			f.method = "post";
			f.submit();
		}
		</script>
	</body>
</html>