<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>ACT.JOB.PD 생성</title>
		<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	</head>
	<body>
		<div id="mainDiv" class="mainDiv">
			<form id="application_form" name="application_form">
				<input type="hidden" id="pageYn" name="pageYn" value="N" />
				<input type="hidden" id="p_session_id" name="p_session_id" />
				<input type="hidden" id="p_hidden_usc_dwg_id" name="p_hidden_usc_dwg_id" />
				<input type="hidden" id="p_hidden_usc_history_id" name="p_hidden_usc_history_id" />
				<input type="hidden" id="p_hidden_wbs_item_code" name="p_hidden_wbs_item_code" />
				<input type="hidden" id="p_hidden_usc_detail_id" name="p_hidden_usc_detail_id" />
				<input type="hidden" id="p_hidden_dwg_no" name="p_hidden_dwg_no" />
				<input type="hidden" id="p_hidden_dwg_category" name="p_hidden_dwg_category" />
				<input type="hidden" id="p_confirm_flag" name="p_confirm_flag" />
				<input type="hidden" id="p_bom_trans_flag" name="p_bom_trans_flag" />
				<input type="hidden" id="p_job_dept_code" name="p_job_dept_code" />
				<input type="hidden" id="p_hidden_pd_catalog" name="p_hidden_pd_catalog" />
				<input type="hidden" id="p_hidden_block_no" name="p_hidden_block_no" />
				<input type="hidden" id="p_hidden_job_part_no" name="p_hidden_job_part_no" />
				
				
				
				
				
				
				<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
				
				<div class="subtitle">
					ACT.JOB.PD 생성
					<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
				</div>
				<table class="searchArea conSearch" style="min-width:65%;width:65%;float:left; margin-top:9px; margin-right:5px;"><!--검색1-->
					<col width="60">
					<col width="200">
					<col width="60">
					<col width="100">
					<col width="60">
					<col width="100">
					<col width="85">
					<col width="">
					<tr>
						<th>DPS부서</th>
						<td>
							<input type="text" name="p_dwg_dept_code" id="p_dwg_dept_code" value="${loginUser.dwgdeptcode}" class="toUpper" style="width: 50px;" />
							<input type="text" name="p_dwg_dept_name" id="p_dwg_dept_name" value="${loginUser.dwgdeptnm}" style="width: 90px; margin-left: -5px;" class="notdisabled" readonly="readonly" />
							<input type="button" name="btn_popup_dwg_dept" id="btn_popup_dwg_dept" value="검색" class="btn_gray2" />
						</td>
						<th>대표호선</th>
						<td>
							<input type="text" id="p_delegate_project_no" name="p_delegate_project_no" class="required w50h25" style="width: 50px;" />
							<input type="button" id="btn_delegate_project_no" name="btn_delegate_project_no" class="btn_gray2" value="검색" />
<!-- 							<select name="p_master_project_no" id="p_master_project_no" class="required" style="width: 70px;"> -->
<!-- 								<option value="">선택</option> -->
<!-- 							</select> -->
						</td>
						<th>시리즈</th>
						<td>
							<input type="text" id="p_project_no" name="p_project_no" class="w50h25" style="width: 50px;" />
							<input type="button" id="btn_project_no" name="btn_project_no" class="btn_gray2" value="검색" />
<!-- 							<select name="p_project_no" id="p_project_no" style="width: 70px;"> -->
<!-- 								<option value="">ALL</option> -->
<!-- 							</select> -->
						</td>
						<th>도면담당자</th>
						<td>
							<input type="hidden" id="p_dwg_emp_no" name="p_dwg_emp_no" />
							<input type="text" class="notdisabled" id="p_dwg_emp_by_name" name="p_dwg_emp_by_name" readonly="readonly" style="width: 50px;" />
							<input type="text" class="notdisabled" id="p_dwg_emp_group_name" name="p_dwg_emp_group_name" readonly="readonly" style="width: 100px; margin-left: -5px;" />
							<input type="button" id="btnDwgEmpNo" name="btnDwgEmpNo" value="검색" class="btn_gray2"  />
						</td>
					</tr>
					<tr>
						<th>분류</th>
						<td>
							<select name="p_dwg_group_type" id="p_dwg_group_type" style="width: 50px;">
								<option value="">ALL</option>
							</select>
							<input type="button" id="btnDwgAdd" name="btnDwgAdd" value="도면추가" class="btn_gray2"/>
							<input type="button" id="btnStandardAccept" name="btnStandardAccept" value="표준적용" class="btn_gray3" />
						</td>
						<th>도면NO</th>
						<td>
							<input type="text" name="p_dwg_no" id="p_dwg_no" class="toUpper" style="width: 50px;" />
						</td>
						<th>확정유무</th>
						<td>
							<select name="p_confirm_flag" id="p_confirm_flag" style="width: 70px;">
								<option value="">ALL</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<th>BOM전송유무</th>
						<td>
							<select name="p_bom_trans_flag" id="p_bom_trans_flag" style="width: 70px;">
								<option value="">ALL</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="bdl_no" colspan="8">
							<div class="button endbox" style="height:30px;margin-top:6px;">
								<c:if test="${userRole.attribute1 == 'Y'}">
								<input type="button" id="btnSearch" name="btnSearch" value="조회" class="btn_blue wid70"/>
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnSave" name="btnSave" value="저장"  class="btn_blue wid70"/>
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnComfirm" name="btnComfirm" value="확정"  class="btn_blue wid70"/>
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">								
								<input type="button" id="btnComfirmCancel" name="btnComfirmCancel" value="확정취소"  class="btn_blue wid70"/>
								</c:if>
							</div>
						</td>
					</tr>
				</table>
				
				<table class="searchArea conSearch" style="width:34%; min-width:34%;">
					<tr>
						<th>원인코드</th>
						<td>
							<input type="hidden" name="p_eco_reason_code" id="p_eco_reason_code" />
							<input type="text" name="p_eco_reason_desc" id="p_eco_reason_desc" style="width: 30px;" />
							<input type="button" id="btnEcoReasonCode" name="btnEcoReasonCode" value="검색" class="btn_gray2" />
						</td>
						<th>ECR</th>
						<td>
							<input type="hidden" name="p_eng_change_req_code" id="p_eng_change_req_code" />
							<input type="text" name="p_ecr_no" id="p_ecr_no" style="width: 80px;" />
							<input type="button" id="btnEcrCode" name="btnEcrCode" value="검색" class="btn_gray2" />
						</td>	
					</tr>
					<tr>
						<th>ECO</th>
						<td>
							<input type="hidden" name="p_eng_change_order_code" id="p_eng_change_order_code" />
							<input type="text" name="p_eco_no" id="p_eco_no" style="width: 80px;" />
							<input type="button" id="btnEcoCode" name="btnEcoCode" value="검색" class="btn_gray2"  />
						</td>
						<th>결재자</th>
						<td>
							<input type="hidden" id="p_created_by" name="p_created_by" />
							<input type="text" class="notdisabled" id="p_created_by_name" name="p_created_by_name" readonly="readonly" style="width: 50px;" />
							<input type="text" class="notdisabled" id="p_user_group_name" name="p_user_group_name" readonly="readonly" style="width: 100px; margin-left: -5px;" />
							<input type="button" id="btnEmpNo" name="btnEmpNo" value="검색" class="btn_gray2"  />
						</td>
					</tr>
					<tr>
						<td class="bdl_no" colspan="6">
							<div class="button endbox" style="height:30px;margin-top:6px;">
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnEcoCreate" name="btnEcoCreate" value="ECO 생성" class="btn_blue wid70"/>
								</c:if>
								<c:if test="${userRole.attribute4 == 'Y'}">
								<input type="button" id="btnCreate" name="btnCreate" value="채번 및 BOM생성"  class="btn_blue2"/>
								</c:if>
							</div>
						</td>
					</tr>
				</table>
				
				<div style="border:1px solid #fff; width:100%;">
					<div style="float:left; width: 29%;height:600px;">
						<div id="divDwgMaster">
							<table id="dwgMasterList"></table>
							<div id="btn_dwgMasterList"></div>
						</div>
						<div id="divDwgRevision">
							<table id="dwgRevList"></table>
							<div id="btn_dwgRevList"></div>
						</div>
					</div>
					<div style="float:left; width: 36%;height:600px;">
						<div id="divUscMaster">
							<table id="uscMasterList"></table>
							<div id="btn_uscMasterList"></div>
						</div>
						<div id="divDetail">
							<table id="uscDetailList"></table>
							<div id="btn_uscDetailList"></div>
						</div>
						<div id="divStageDetail">
							<table id="uscStageDetailList"></table>
							<div id="btn_uscStageDetailList"></div>
						</div>
					</div>
					<div style="float:left; width:35%; height:600px;">
						<div id="divEcoList">
							<table id="ecoList"></table>
							<div id="btn_ecoList"></div>
						</div>
						<div id="divDwg">
							<table id="dwgList"></table>
							<div id="btn_dwgList"></div>
						</div>
						<div id="divItem">
							<table id="bomItemList"></table>
							<div id="btn_bomItemList"></div>
						</div>
					</div>
				</div>
			</form>
		</div>
		<script type="text/javascript">
		var dwg_master_change_item_row = 0;
		var dwg_master_change_item_row_num = 0;
		var dwg_master_change_item_col = 0;
		
		var dwg_rev_change_item_row = 0;
		var dwg_rev_change_item_row_num = 0;
		var dwg_rev_change_item_col = 0;
		
		var usc_master_change_item_row = 0;
		var usc_master_change_item_row_num = 0;
		var usc_master_change_item_col = 0;
		
		var usc_detail_change_item_row = 0;
		var usc_detail_change_item_row_num = 0;
		var usc_detail_change_item_col = 0;
		
		var usc_stage_change_item_row = 0;
		var usc_stage_change_item_row_num = 0;
		var usc_stage_change_item_col = 0;
		
		var eco_change_item_row = 0;
		var eco_change_item_row_num = 0;
		var eco_change_item_col = 0;
		
		var dwg_change_item_row = 0;
		var dwg_change_item_row_num = 0;
		var dwg_change_item_col = 0;
		
		var bom_item_change_item_row = 0;
		var bom_item_change_item_row_num = 0;
		var bom_item_change_item_col = 0;
		
		var resultData = [];
		
		var dwgMasterListData = [];
		var dwgRevListData = [];
		var uscMasterListData = [];
		var uscDetailListData = [];
		var uscStageDetailListData = [];
		var ecoListData = [];
		var dwgListData = [];
		var bomItemListData = [];
		
		var loadingBox;
		
		$(document).ready( function() {
			//input 검색조건 upper 처리
			fn_all_text_upper();
			
			fn_get_job_dept_code();
			
			//grid column 숨김여부
			var is_hidden = true;
			
			/******************************************************************************
				DWG MASTER GRID
			******************************************************************************/
			$( "#dwgMasterList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '선택', 'PROJECT', '도면구분', '도면구분', '도면NO', 'dps부서코드', 'usc_dwg_id', '추가', 'usc_history_id', '확정유무', 'BOM전송', 'oper' ],
				colModel : [ { name : 'enable_flag', index : 'enable_flag', align : "center", width : 25, editable : true, sortable : false, edittype : 'checkbox', formatter : "checkbox", editoptions : { value : "Y:N" }, formatoptions : { disabled : false } },
				             { name : 'project_no', index : 'project_no', hidden : is_hidden },
				             { name : 'dwg_type', index : 'dwg_type', hidden : is_hidden },
				             { name : 'dwg_type_desc', index : 'dwg_type_desc', align : 'center', width : 60, sortable : false },
				             { name : 'dwg_no', index : 'dwg_no', align : 'center', width : 80, sortable : false, classes : "handcursor" },
				             { name : 'dps_dept_code', index : 'dps_dept_code', hidden : is_hidden },
				             { name : 'usc_dwg_id', index : 'usc_dwg_id', hidden : is_hidden },
				             { name : 'dwgrev_add_button', index : 'dwgrev_add_button', align : 'center', width : 30, sortable : false },
				             { name : 'usc_history_id', index : 'usc_history_id' , hidden : is_hidden },
				             { name : 'confirm_flag', index : 'confirm_flag', align : 'center', width : 50, sortable : false },
				             { name : 'bom_trans_flag', index : 'bom_trans_flag', align : 'center', width : 50, sortable : false },
				             { name : 'oper', index : 'oper', hidden : is_hidden } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_dwgMasterList',
				viewrecords : true,
				caption : "DWG MASTER",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 335,
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
					id : "dwg_no"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						dwg_master_change_item_col = iCol;
						dwg_master_change_item_row_num = iRow;
	
						if( dwg_master_change_item_row != rowid ) {
							dwg_master_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#dwgMasterList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#dwgMasterList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#dwgMasterList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( '#dwgMasterList' ).jqGrid( 'getRowData', rowid );
					
					if ( colName['index'] == "dwg_no" ) {
						$( "#p_hidden_usc_dwg_id" ).val( item.usc_dwg_id );
						$( "#p_hidden_dwg_no" ).val( item.dwg_no );
						$( "#p_confirm_flag" ).val( item.confirm_flag );
						$( "#p_bom_trans_flag" ).val( item.bom_trans_flag );
						
						//eco list 조회
						fn_search_dwg_revision();
						
						fn_search_eco();
						
						$( "#dwgRevList" ).jqGrid( "setCaption", 'DWG REVISION LIST - ' + item.dwg_no );
					}
					
					//dwg revision 추가
					if ( colName['index'] == "dwgrev_add_button" ) {
						$( "#p_hidden_usc_dwg_id" ).val( item.usc_dwg_id );
						$( "#p_confirm_flag" ).val( item.confirm_flag );
						$( "#p_bom_trans_flag" ).val( item.bom_trans_flag );
						
						//확정유무 및 BOM전송유무 체크
						if( fn_flag_check() ) {
							return;
						}
						
						var usc_dwg_id = item.usc_dwg_id;
						fn_add_dwg_revision( usc_dwg_id );
						
						$( "#dwgRevList" ).jqGrid( "setCaption", 'DWG REVISION LIST - ' + item.dwg_no );
					}
				},
				gridComplete : function () {
					var rows = $( "#dwgMasterList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var confirm_flag = $( "#dwgMasterList" ).getCell( rows[i], "confirm_flag" );
						var bom_trans_flag = $( "#dwgMasterList" ).getCell( rows[i], "bom_trans_flag" );

						if( confirm_flag == "Y" && bom_trans_flag == "N" ) {
							//확정유무가 Y인 경우 노란색으로 표시
							$( "#dwgMasterList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#FFFF00' } );
						}
						
						if( confirm_flag == "Y" && bom_trans_flag == "Y" ) {
							//BOM전송유무가 Y인 경우 빨간색으로 표시
							$( "#dwgMasterList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#dc5a60' } );
						}
					}
					
					$( "#dwgMasterList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					$( "#dwgMasterList td:contains('+')" ).css( "background", "pink" ).css( "cursor", "pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			/******************************************************************************
				DWG REVISION LIST GRID
			******************************************************************************/
			$( "#dwgRevList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'usc_dwg_id', 'usc_history_id', 'confirm_flag', 'bom_trans_flag', 'eco_confirm_flag', '도면 Rev', '원인코드', '원인코드', 'ECR_CODE', 'ECR', 'ECO_CODE', 'ECO', 'WBS', '일괄' ],
				colModel : [ { name : 'usc_dwg_id', index : 'usc_dwg_id', hidden : is_hidden },
				             { name : 'usc_history_id', index : 'usc_history_id', hidden : is_hidden },
				             { name : 'confirm_flag', index : 'confirm_flag', hidden : is_hidden },
				             { name : 'bom_trans_flag', index : 'bom_trans_flag', hidden : is_hidden },
				             { name : 'eco_confirm_flag', index : 'eco_confirm_flag', hidden : is_hidden },
				             { name : 'usc_dwg_rev', index : 'usc_dwg_rev', width : 55, sortable : false, align : 'right', classes : "handcursor" },
				             { name : 'eco_reason_code', index : 'eco_reason_code', hidden : is_hidden },
				             { name : 'eco_reason_desc', index : 'eco_reason_desc', width : 50, sortable : false, align : 'center' },
				             { name : 'eng_change_req_code', index : 'eng_change_req_code', hidden : is_hidden },
				             { name : 'ecr_no', index : 'ecr_no', width : 60, sortable : false, align : 'center', classes : "handcursor" },
				             { name : 'eng_change_order_code', index : 'eng_change_order_code', hidden : is_hidden },
				             { name : 'eco_no', index : 'eco_no', width : 65, sortable : false, align : 'center', classes : "handcursor" },
				             { name : 'wbs_add_button', index : 'wbs_add_button', width : 30, sortable : false, align : 'center', classes : "grid_popup_btn handcursor" },
				             { name : 'act_add_button', index : 'act_add_button', width : 30, sortable : false, align : 'center', classes : "grid_popup_btn handcursor" } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_dwgRevList',
				viewrecords : true,
				caption : "DWG REVISION LIST",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,
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
					id : "dwg_no"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						dwg_rev_change_item_col = iCol;
						dwg_rev_change_item_row_num = iRow;
	
						if( dwg_rev_change_item_row != rowid ) {
							dwg_rev_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#dwgRevList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#dwgRevList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#dwgRevList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $("#dwgRevList").jqGrid( "getRowData", rowid );
					
					if ( colName['index'] == "usc_dwg_rev" ) {
						var usc_history_id = item.usc_history_id;
						$( "#p_hidden_usc_history_id" ).val( usc_history_id );
						
						//wbs master 조회
						fn_search_usc_master();
						
// 						fn_search_bom_list();
					}
					
// 					if ( colName['index'] == "eco_reason_code_popup" ) {
// 						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupCause",
// 								window,
// 								"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
						
// 						if( rs != null ) {
// 							$( "#dwgRevList" ).setRowData( rowid, { eco_reason_code : rs[0] } );
// 							$( "#dwgRevList" ).setRowData( rowid, { eco_reason_desc : rs[2] } );
							
// 							if( item.oper != "I" )
// 								$( "#dwgRevList" ).setRowData( rowid, { oper : "U" } );
// 						}
// 					}
					
					if ( colName['index'] == "ecr_no" ) {
		              	var ecrName = item.ecr_no;
		              	
		              	if( ecrName != "" ) {
		            		var sUrl = "./popupEcr.do?ecr_name=" + ecrName;
		            		window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:750px; center:on; scroll:off; status:off");
		              	}
					}
					
					if ( colName['index'] == "eco_no" ) {
		              	var ecoName = item.eco_no;
		              	
		              	if( ecoName != "" ) {
							var sUrl = "./popupEco.do?ecoName=" + ecoName+"&popupDiv=Y&menu_id=${menu_id}";
							window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:750px; center:on; scroll:off; status:off");
		              	}
					}
					
// 					if ( colName['index'] == "ecr_no_popup" ) {
// 						if( item.eco_reason_code == "" ) {
// 							alert( "원인코드 입력 후 ECR을 찾아주세요." );
// 							return;
// 						}
						
// 						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEcrSearch" + "&eco_reason_code=" + item.eco_reason_code,
// 								window,
// 								"dialogWidth:800px; dialogHeight:500px; center:on; scroll:off; status:off" );
						
// 						if( rs != null ) {
// 							$( "#dwgRevList" ).setRowData( rowid, { ecr_no : rs[0] } );
// 							$( "#dwgRevList" ).setRowData( rowid, { eng_change_req_code : rs[1] } );
							
// 							if( item.oper != "I" )
// 								$( "#dwgRevList" ).setRowData( rowid, { oper : "U" } );
// 						}
// 					}
					
// 					if ( colName['index'] == "eco_no_popup" ) {
// 						if( item.eco_reason_code == "" ) {
// 							alert( "원인코드 입력 후 ECO을 찾아주세요." );
// 							return;
// 						}
						
// 						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEcoSearch" + "&eco_reason_code=" + item.eco_reason_code,
// 								window,
// 								"dialogWidth:800px; dialogHeight:500px; center:on; scroll:off; status:off" );
						
// 						if( rs != null ) {
// 							$( "#dwgRevList" ).setRowData( rowid, { eco_no : rs[0] } );
// 							$( "#dwgRevList" ).setRowData( rowid, { eng_change_order_code : rs[1] } );
							
// 							if( item.oper != "I" )
// 								$( "#dwgRevList" ).setRowData( rowid, { oper : "U" } );
// 						}
// 					}
					
					if ( colName['index'] == "wbs_add_button" ) {
						//확정유무 및 BOM전송유무 체크
						if( fn_flag_check2() ) {
							return;
						}
						
						var usc_history_id = item.usc_history_id;
						var master_project_no = $( "#p_delegate_project_no" ).val();
// 						var master_project_no = $( "#p_master_project_no option:selected" ).val();
						$( "#p_hidden_usc_history_id" ).val( usc_history_id );
						
						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupAddWbsMaster&usc_history_id=" + usc_history_id + "&master_project_no=" + master_project_no,
								window,
								"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
					}
					
					if ( colName['index'] == "act_add_button" ) {
						//확정유무 및 BOM전송유무 체크
						if( fn_flag_check2() ) {
							return;
						}
						
						var dwgData = $.grep( $("#dwgMasterList").jqGrid( 'getRowData' ), function( obj ) {
							return obj.usc_dwg_id == item.usc_dwg_id;
						} );
						
						var dwg_category = dwgData[0].dwg_no.substring(0,5);
						
						var usc_history_id = item.usc_history_id;
						var usc_dwg_id = item.usc_dwg_id;
						var master_project_no = $( "#p_delegate_project_no" ).val();
						$( "#p_hidden_usc_history_id" ).val( usc_history_id );
						$( "#p_hidden_usc_dwg_id" ).val( usc_dwg_id );
						$( "#p_hidden_dwg_category" ).val( dwg_category );
						
						
						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupCopyDetailToMaster",
								window,
								"dialogWidth:1280px; dialogHeight:768px; center:on; scroll:off; status:off" );
					}
				},
				gridComplete : function () {
					var rows = $( "#dwgRevList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var eco_confirm_flag = $( "#dwgRevList" ).getCell( rows[i], "eco_confirm_flag" );

						if( eco_confirm_flag == "Y" ) {
							//BOM전송유무가 Y인 경우 빨간색으로 표시
							$( "#dwgRevList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#C0C0C0' } );
						}
					}
					
					$( "#dwgRevList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					$( "#dwgRevList td:contains('+')" ).css( "background", "pink" ).css( "cursor", "pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			/******************************************************************************
				USC MASTER GRID
			******************************************************************************/
			$( "#uscMasterList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '삭제', 'ACT', 'ACT', 'PROJECT', 'WBS', '장소', 'WBS CD', 'usc_master_id', '추가', 'usc_dwg_id', 'usc_history_id', 'eco_trans_flag', 'oper' ],
				colModel : [ { name : 'master_delete_button', index : 'master_delete_button', align : 'center', width : 30, sortable : false },
				             { name : 'act_flag', index : 'act_flag', hidden : is_hidden },
				             { name : 'act_flag_desc', index : 'act_flag_desc', align : 'center', width : 40, sortable : false },
				             { name : 'connect_project', index : 'connect_project', align : 'center', width : 120, sortable : false },
				             { name : 'wbs_attr1', index : 'wbs_attr1', align : 'center', width : 50, sortable : false },
				             { name : 'wbs_attr2', index : 'wbs_attr2', align : 'center', width : 50, sortable : false },
				             { name : 'wbs_item_code', index : 'wbs_item_code', align : 'center', width : 90, sortable : false, classes : "handcursor" },
				             { name : 'usc_master_id', index : 'usc_master_id', hidden : is_hidden },
				             { name : 'detail_add_button', index : 'detail_add_button', align : 'center', width : 30, sortable : false },
				             { name : 'usc_dwg_id', index : 'usc_dwg_id',hidden : is_hidden },
				             { name : 'usc_history_id', index : 'usc_history_id', hidden : is_hidden },
				             { name : 'eco_trans_flag', index : 'eco_trans_flag', hidden : is_hidden },
				             { name : 'oper', index : 'oper', hidden : is_hidden } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers:true,
				pager : '#btn_uscMasterList',
				viewrecords : true,
				caption : "WBS LIST",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,
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
					id : "wbs_item_code"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						usc_master_change_item_col = iCol;
						usc_master_change_item_row_num = iRow;
	
						if( usc_master_change_item_row != rowid ) {
							usc_master_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#uscMasterList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#uscMasterList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#uscMasterList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( '#uscMasterList' ).jqGrid( 'getRowData', rowid );
					
					if ( colName['index'] == "master_delete_button" ) {
						var usc_history_id = item.usc_history_id;
						var wbs_item_code = item.wbs_item_code;
						
						//wbs master 및 wbs detail, stage 삭제
						fn_delete_wbs_master( usc_history_id, wbs_item_code );
					}
					
					if ( colName['index'] == "wbs_item_code" ) {
						$( "#p_hidden_wbs_item_code" ).val( item.wbs_item_code );
						$( "#p_hidden_usc_history_id" ).val( item.usc_history_id );
						$( "#p_hidden_block_no" ).val( item.wbs_attr1 );
						
						if( usc_history_id != "" ) {
							fn_search_usc_detail();
						}
					}
					
					if ( colName['index'] == "detail_add_button" ) {
						//확정유무 및 BOM전송유무 체크
						if( fn_flag_check2() ) {
							return;
						}
						
						var wbs_item_code = item.wbs_item_code;
						var usc_history_id = item.usc_history_id;
						$( "#p_hidden_usc_history_id" ).val( usc_history_id );
						var dwg_no = $( "#p_hidden_dwg_no" ).val();
						
						
						var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupAddWbsDetail&usc_history_id=" + usc_history_id + "&wbs_item_code=" + wbs_item_code + "&dwg_no=" + dwg_no,
								window,
								"dialogWidth:600px; dialogHeight:700px; center:on; scroll:off; status:off" );
					}
				},
				gridComplete : function () {
					$( "#uscMasterList td:contains('...')" ).css( "background", "pink" ).css( "cursor","pointer" );
					$( "#uscMasterList td:contains('+')" ).css( "background", "pink" ).css( "cursor","pointer" );
					$( "#uscMasterList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor","pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			/******************************************************************************
				USC DETAIL GRID
			******************************************************************************/
			$( "#uscDetailList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'usc_history_id', 'wbs_item_code', '삭제', 'ACT', 'ACT', 
				             '공정', 'TYPE', 'ACT CD', 'JOB CD', 
				             'JOB ATTR.3', 'STAGE', 'pd_list_id', 'usc_detail_id', 'eco_trans_flag', 'pd_catalog', 'oper' ],
				colModel : [ { name : 'usc_history_id', index : 'usc_history_id', hidden : is_hidden },
				             { name : 'wbs_item_code', index : 'wbs_item_code', hidden : is_hidden },
				             { name : 'detail_delete_button', index : 'detail_delete_button', align : 'center', width : 30, sortable : false },
				             { name : 'act_flag', index : 'act_flag', hidden : is_hidden },
				             { name : 'act_flag_desc', index : 'act_flag_desc', align : 'center', width : 30, sortable : false },
				             { name : 'work_type_desc', index : 'work_type_desc', align : 'center', width : 40, sortable : false, classes : "handcursor" },
				             { name : 'pd_type_desc', index : 'pd_type_desc', align : 'center', width : 80, sortable : false, hidden : is_hidden },
				             { name : 'act_part_no', index : 'act_part_no', align : 'center', width : 80, sortable : false },
				             { name : 'job_part_no', index : 'job_part_no', align : 'center', width : 80, sortable : false },
				             { name : 'attr3', index : 'attr3', align : 'center', width : 70, sortable : false },
				             { name : 'detail_stage_no', index : 'detail_stage_no', align : 'center', width : 40, sortable : false },
				             { name : 'pd_list_id', index : 'pd_list_id', hidden : is_hidden },
				             { name : 'usc_detail_id', index : 'usc_detail_id', hidden : is_hidden },
				             { name : 'eco_trans_flag', index : 'eco_trans_flag', hidden : is_hidden },
				             { name : 'pd_catalog', index : 'pd_catalog', hidden : is_hidden },
				             { name : 'oper', index : 'oper', hidden : is_hidden } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_uscDetailList',
				viewrecords : true,
				caption : "ACT/JOB LIST",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,//227.05,
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
					id : "usc_detail_id"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						usc_detail_change_item_col = iCol;
						usc_detail_change_item_row_num = iRow;
	
						if( usc_detail_change_item_row != rowid ) {
							usc_detail_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#uscDetailList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#uscDetailList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#uscDetailList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( '#uscDetailList' ).jqGrid( 'getRowData', rowid );
					
					if ( colName['index'] == "detail_delete_button" ) {
						var usc_history_id = item.usc_history_id;
						var usc_detail_id = item.usc_detail_id;
						var wbs_item_code = item.wbs_item_code;
						var pd_list_id = item.pd_list_id;
						
						//wbs detail 및 stage 삭제
						fn_delete_wbs_detail( usc_history_id, usc_detail_id, wbs_item_code, pd_list_id );
					}
					
					if ( colName['index'] == "work_type_desc" ) {
						var item = $( '#uscDetailList' ).jqGrid( 'getRowData', rowid );
						$( "#p_hidden_usc_history_id" ).val( item.usc_history_id );
						$( "#p_hidden_usc_detail_id" ).val( item.usc_detail_id );
						$( "#p_hidden_pd_catalog" ).val( item.pd_catalog );
						$( "#p_hidden_job_part_no" ).val( item.job_part_no );
						
						
						//detail 선택 시 Stage 조회
						fn_search_usc_stage();
					}
				},
				gridComplete : function () {
					$( "#uscDetailList td:contains('...')" ).css( "background", "pink" ).css( "cursor","pointer" );
					$( "#uscDetailList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor","pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler('reloadGrid');
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			/******************************************************************************
				USC STAGE GRID
			******************************************************************************/
			$( "#uscStageDetailList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ '삭제', 'ACT', 'ACT', 'usc_history_id', 'usc_detail_id', 'PD CD', 'STAGE', 'pd_catalog', 'dwg_no', 'SSC ITEM(수량)', 'oper' ],
				colModel : [ { name : 'stage_delete_button', index : 'stage_delete_button', align : 'center', width : 30, sortable : false },
				             { name : 'act_flag', index : 'act_flag', hidden : is_hidden },
				             { name : 'act_flag_desc', index : 'act_flag_desc', align : 'center', width : 30, sortable : false },
				             { name : 'usc_history_id', index : 'usc_history_id', hidden : is_hidden },
				             { name : 'usc_detail_id', index : 'usc_detail_id', hidden : is_hidden },
				             { name : 'pd_item_code', index : 'pd_item_code', align : 'center', width : 60, sortable : false },
				             { name : 'stage_no', index : 'stage_no', align : 'left', width : 60, editable : true, sortable : false, editoptions : { maxlength : "5" } },
				             { name : 'pd_catalog', index : 'pd_catalog', hidden : is_hidden },
				             { name : 'dwg_no', index : 'dwg_no', hidden : is_hidden },
				             { name : 'ssc_item', index : 'ssc_item', align : 'right', width : 60, sortable : false },
				             { name : 'oper', index : 'oper', hidden : is_hidden } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_uscStageDetailList',
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "PD LIST",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,
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
					id : "stage_no"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						usc_stage_change_item_col = iCol;
						usc_stage_change_item_row_num = iRow;
	
						if( usc_stage_change_item_row != rowid ) {
							usc_stage_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#uscStageDetailList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#uscStageDetailList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#uscStageDetailList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( '#uscStageDetailList' ).jqGrid( 'getRowData', rowid );
					
					if ( colName['index'] == "stage_delete_button" ) {
						var usc_history_id = item.usc_history_id;
						var usc_detail_id = item.usc_detail_id;
						var stage_no = item.stage_no;
						
						//stage 삭제
						fn_delete_stage( usc_history_id, usc_detail_id, stage_no );
					}
					
					if( item.oper == "" ) {
						$( "#uscStageDetailList" ).jqGrid( 'setCell', rowid, 'stage_no', '', 'not-editable-cell' );
					}
				},
				gridComplete : function () {
					$( "#uscStageDetailList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					$( "#uscStageDetailList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor", "pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			$( "#uscStageDetailList" ).jqGrid( 'navGrid', "#btn_uscStageDetailList", {
				refresh : false,
				search : false,
				edit : false,
				add : false,
				del : false
			} );
			
			<c:if test="${userRole.attribute2 == 'Y'}">
		 	$( "#uscStageDetailList" ).navButtonAdd( '#btn_uscStageDetailList', {
		 		caption:"", 
				buttonicon:"ui-icon-plus", 
				onClickButton: add_stage,
				position: "first", 
				title:"Stage Add", 
				cursor: "pointer"
			} );
		 	</c:if>
			
			/******************************************************************************
				ECO LIST GRID
			******************************************************************************/			
			$( "#ecoList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'ECO ID', 'dps_dept_code', '복구', 'ECO NO', '검토', '현황', '생성자', 'ECO상태', 'ECO코드', '오류체크' ],
				colModel : [ { name : 'usc_eco_id', index : 'usc_eco_id', align : 'center', width : 40, sortable : false, classes : "handcursor" },
				             { name : 'dps_dept_code', index : 'dps_dept_code', hidden : is_hidden },
				             { name : 'cancel_eco_button', index : 'cancel_eco_button', align : 'center', width : 30, sortable : false },
				             { name : 'eco_no', index : 'eco_no', align : 'center', width : 70, sortable : false, classes : "handcursor" },
				             { name : 'eco_check_flag', index : 'eco_check_flag', align : 'center', width : 30, sortable : false },
				             { name : 'confirm_flag', index : 'confirm_flag', align : 'center', width : 30, sortable : false },
				             { name : 'user_name', index : 'user_name', hidden : is_hidden },
				             { name : 'eco_status_desc', index : 'eco_status_desc', align : 'center', width : 70, sortable : false },
				             { name : 'eco_status_code', index : 'eco_status_desc', align : 'center', width : 70, sortable : false, hidden : true },
				             { name : 'eco_error_check', index : 'eco_error_check', align : 'center', width : 50, sortable : false } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers:true,
				pager : '#btn_ecoList',
				viewrecords : true,
				caption : "ECO LIST(부서별)",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,
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
					id : "usc_master_id"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						eco_change_item_col = iCol;
						eco_change_item_row_num = iRow;
	
						if( eco_change_item_row != rowid ) {
							eco_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#ecoList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#ecoList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				onCellSelect : function( rowid, iCol, cellcontent, e ) {
					//grid 수정내역 적용
					fn_grid_save_cell();
					
					var cm = $( "#ecoList" ).jqGrid( "getGridParam", "colModel" );
					var colName = cm[iCol];
					var item = $( '#ecoList' ).jqGrid( 'getRowData', rowid );
					
					if ( colName['index'] == "cancel_eco_button" ) {
						//eco cancel
						fn_eco_cancel( item.usc_eco_id );
					}
					
					if ( colName['index'] == "usc_eco_id" ) {
						//dwg list 조회
						fn_search_eco_dwg( item.usc_eco_id );
						
						fn_search_bom_item( item.usc_eco_id );
					}
					
					if ( colName['index'] == "eco_no" ) {
						var ecoName = item.eco_no;
		              	
		              	if( ecoName != "" ) {
							var sUrl = "./popupEco.do?ecoName=" + ecoName+"&popupDiv=Y&menu_id=${menu_id}";
							window.showModalDialog( sUrl, window, "dialogWidth:1500px; dialogHeight:750px; center:on; scroll:off; status:off");
		              	}
					}
					
					if ( colName['index'] == "eco_error_check" ) {
						if( item.eco_check_flag == "Y" && item.confirm_flag == "Y" ) {
							alert( "해당 ECO는 오류가 없습니다." );
							return;
						}
						
						//dwg list 조회
						fn_bom_trans( item.usc_eco_id );
					}
				},
				gridComplete : function () {
					var rows = $( "#ecoList" ).getDataIDs();

					for( var i = 0; i < rows.length; i++ ) {
						//수정 및 결재 가능한 리스트 색상 변경
						var confirm_flag = $( "#ecoList" ).getCell( rows[i], "confirm_flag" );
						var eco_status_code = $( "#ecoList" ).getCell( rows[i], "eco_status_code" );

						if( confirm_flag == "C" ) {
							//현황이 C인 경우
							$( "#ecoList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#C0C0C0' } );
						}
						
						if( eco_status_code == "11" ) {
							//ECO가 RELEASE된 경우
							$( "#ecoList" ).jqGrid( 'setRowData', rows[i], false, { color : 'black', background : '#C0C0C0' } );
						}
					}
					
					$( "#ecoList td:contains('...')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					$( "#ecoList td:contains('+')" ).css( "background", "pink" ).css( "cursor", "pointer" );
					$( "#ecoList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor", "pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );

			/******************************************************************************
				DWG LIST GRID
			******************************************************************************/
			$( "#dwgList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'usc_eco_id', '도면NO', '도면DESCRIPTION' ],
				colModel : [ { name : 'usc_eco_id', index : 'usc_eco_id', hidden : is_hidden },
				             { name : 'dwg_no', index : 'dwg_no', align : 'center', width : 15, sortable : false },
				             { name : 'dwg_desc', index : 'dwg_desc', align : 'left', width : 40, sortable : false } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_dwgList',
				viewrecords : true,
				caption : "ECO DETAIL(DWG)",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,//227.05,
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
					id : "usc_detail_id"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						dwg_change_item_col = iCol;
						dwg_change_item_row_num = iRow;
	
						if( dwg_change_item_row != rowid ) {
							dwg_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#dwgList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#dwgList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				gridComplete : function () {
					$( "#dwgList td:contains('...')" ).css( "background", "pink" ).css( "cursor","pointer" );
					$( "#dwgList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor","pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler('reloadGrid');
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			/******************************************************************************
				BOM ITEM LIST GRID
			******************************************************************************/
			$( "#bomItemList" ).jqGrid( {
				url : '',
				datatype : "json",
				mtype : 'POST',
				postData : fn_getFormData( "#application_form" ),
				colNames : [ 'usc_eco_id', '도면NO', 'WBS CD', '모품목', '자품목', '호선', '오류사유' ],
				colModel : [ { name : 'usc_eco_id', index : 'usc_eco_id', hidden : is_hidden },
				             { name : 'dwg_no', index : 'dwg_no', align : 'center', width : 60, sortable : false },
				             { name : 'wbs_item_code', index : 'wbs_item_code', align : 'center', width : 80, sortable : false },
				             { name : 'mother_code', index : 'mother_code', align : 'center', width : 80, sortable : false },
				             { name : 'item_code', index : 'item_code', align : 'center', width : 80, sortable : false },
				             { name : 'project_no', index : 'project_no', align : 'center', width : 40, sortable : false },
				             { name : 'bom_trans_reason', index : 'bom_trans_reason', align : 'center', width : 60, sortable : false } ],
				rowNum : 100,
				rowList : [ 100, 500, 1000 ],
				rownumbers : true,
				pager : '#btn_bomItemList',
				toolbar : [ false, "bottom" ],
				viewrecords : true,
				caption : "ECO DETAIL(ITEM)",
				hidegrid: false,
// 				shrinkToFit : false,
				autowidth : true,
				height : 126.5,
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
					id : "stage_no"
				},
				beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
					if( rowid != null ) {
						bom_item_change_item_col = iCol;
						bom_item_change_item_row_num = iRow;
	
						if( bom_item_change_item_row != rowid ) {
							bom_item_change_item_row = rowid;
						}
					}
				},
				afterSaveCell : function ( rowid, cellname, value, iRow, iCol ) {
					var item = $( '#bomItemList' ).jqGrid( 'getRowData', rowid );
					if(item.oper != 'I')
						item.oper = 'U';

					$( '#bomItemList' ).jqGrid( "setRowData", rowid, item );
					$( "input.editable,select.editable", this ).attr( "editable", "0" );
				},
				gridComplete : function () {
					$( "#bomItemList td:contains('...')" ).css( "background"," pink" ).css( "cursor","pointer" );
					$( "#bomItemList td:containsExact('-')" ).css( "background", "pink" ).css( "cursor","pointer" );
				},
				onPaging: function( pgButton ) {
					/*this is to fix the issue when we go to last page(say there are only 3 records and page size is 5) and click 
					* on sorting the grid fetches previously loaded data (may be from its buffer) and displays 5 records  
					* where in i am expecting only 3 records to be sorted out.along with this there should be a modification in source code.
					*/ 
					$(this).jqGrid( "clearGridData" );

					/* this is to make the grid to fetch data from server on page click*/
					$(this).setGridParam( { datatype : 'json', postData : { pageYn : 'Y' } } ).triggerHandler( "reloadGrid" );  
				},
				loadComplete: function ( data ) {
					var $this = $(this);
					if( $this.jqGrid( 'getGridParam', 'datatype' ) === 'json' ) {
						// because one use repeatitems: false option and uses no
						// jsonmap in the colModel the setting of data parameter
						// is very easy. We can set data parameter to data.rows:
						$this.jqGrid( 'setGridParam', {
							datatype: 'local',
							data: data.rows,
							pageServer: data.page,
							recordsServer: data.records,
							lastpageServer: data.total
						} );

						// because we changed the value of the data parameter
						// we need update internal _index parameter:
						this.refreshIndex();

						if( $this.jqGrid( 'getGridParam', 'sortname' ) !== '' ) {
							// we need reload grid only if we use sortname parameter,
							// but the server return unsorted data
							$this.triggerHandler( 'reloadGrid' );
						}
					} else {
						$this.jqGrid( 'setGridParam', {
							page: $this.jqGrid( 'getGridParam', 'pageServer' ),
							records: $this.jqGrid( 'getGridParam', 'recordsServer' ),
							lastpage: $this.jqGrid( 'getGridParam', 'lastpageServer' )
						} );
						this.updatepager( false, true );
					}
				}
			} );
			
			
		 	//그리드 초기화
		 	fn_grid_init();
		 	
			//조회조건 Combo 초기화 설정
			fn_get_combo();
			
			//조회 버튼 클릭
			$( "#btnSearch" ).click( function () {
				fn_search();
			} );
			
			//저장
			$( "#btnSave" ).click( function () {
				fn_save();
			} );
			
			$( "#btnDwgAdd" ).click( function () {
				fn_insert_dwg_info();
			} );
			
			$( "#btnStandardAccept" ).click( function () {
				fn_insert_standard_info();
			} );
			
			//원인코드
			$( "#btnEcoReasonCode" ).click( function () {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupCause",
						window,
						"dialogWidth:700px; dialogHeight:700px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_eco_reason_code" ).val( rs[0] );
					$( "#p_eco_reason_desc" ).val( rs[2] );
				}
			} );
			
			//ECR 검색팝업
			$( "#btnEcrCode" ).click( function () {
// 				var eco_reason_code = $( "#p_eco_reason_code" ).val();
				
// 				if( eco_reason_code == "" ) {
// 					alert( "원인코드 입력 후 ECR을 찾아주세요." );
// 					return;
// 				}
				
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEcrSearch",
						window,
						"dialogWidth:800px; dialogHeight:500px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_ecr_no" ).val( rs[0] );
					$( "#p_eng_change_req_code" ).val( rs[1] );
				}
			} );
			
			//ECO 검색팝업
			$( "#btnEcoCode" ).click( function () {
// 				var eco_reason_code = $( "#p_eco_reason_code" ).val();
				
// 				if( eco_reason_code == "" ) {
// 					alert( "원인코드 입력 후 ECO을 찾아주세요." );
// 					return;
// 				}
				
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEcoSearch",
						window,
						"dialogWidth:800px; dialogHeight:500px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_eco_no" ).val( rs[0] );
					$( "#p_eng_change_order_code" ).val( rs[1] );
				}
			} );
			
			//ECO 추가
			$( "#btnEcoAdd" ).click( function () {
				fn_dwg_eco_add();
			} );
			
			//ECO 생성
			$( "#btnEcoCreate" ).click( function () {
				fn_dwg_eco_create();
			} );
			
			fn_register();
			
			//사번 조회 팝업... 버튼
			$( "#btnEmpNo" ).click( function() {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEmpno&register_type=RME&main_type=ECO",
						window,
						"dialogWidth:600px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_created_by" ).val( rs[0] );
					$( "#p_created_by_name" ).val( rs[2] );
					$( "#p_user_group_name" ).val( rs[4] );
				}
			} );
			
			//도면 담당자 조회 팝업... 버튼
			$( "#btnDwgEmpNo" ).click( function() {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupEmpno",
						window,
						"dialogWidth:600px; dialogHeight:460px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_dwg_emp_no" ).val( rs[0] );
					$( "#p_dwg_emp_by_name" ).val( rs[1] );
					$( "#p_dwg_emp_group_name" ).val( rs[3] );
				}
			} );
			
			$( "#btn_popup_dwg_dept" ).click( function () {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupDpsDept",
						window,
						"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
				
				if( rs != null ) {
					$( "#p_dwg_dept_code" ).val( rs[0] );
					$( "#p_dwg_dept_name" ).val( rs[1] );
				}
			} );
			
			//확정
			$( "#btnComfirm" ).click( function () {
				fn_dwg_confirm();
			} );
			
			
			//확정취소
			$( "#btnComfirmCancel" ).click( function () {
				fn_dwg_confirm_cancel();
			} );
			
			//복구
			$( "#btnRecovery" ).click( function () {
				fn_dwg_recovery();
			} );
			
			$( "#btnCreate" ).click( function () {
				fn_bom_create();
			} );
			
			//대표호선 콤보박스 값 변경 시 이벤트, PROJECT 콤보박스 구성
// 			$( "#p_master_project_no" ).change( function () {
// 				$( "#p_project_no option" ).remove();
// 				$( "#p_project_no" ).append( "<option value=''>ALL</option>" );
				
// 				var url = 'selectComboProjectList.do';
// 				var formData = fn_getFormData( '#application_form' );
				
// 				$.post( url, formData, function( data ) {
// 					for( var i = 0; i < data.length; i++ ) {
// 						$( "#p_project_no" ).append( "<option value='" + data[i].sb_value + "'>" + data[i].sb_name + "</option>" );
// 					}
// 				}, "json" );
// 			} );
			
			$( "#p_delegate_project_no" ).change( function () {
				$( "#p_project_no" ).val( "" );
			} );
			
			$( "#btn_delegate_project_no" ).click( function () {
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupDelegateProjectNo",
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
				var rs = window.showModalDialog( "mainPopupSearch.do?cmd=popupProjectNo",
						window,
						"dialogWidth:400px; dialogHeight:400px; center:on; scroll:off; status:off" );
				
				if ( rs != null ) {
					$( "#p_project_no" ).val( rs[0] );
				}
			} );
			
			$( "#p_dwg_dept_code" ).change( function () {
				fn_get_job_dept_code();
			} );
			
			
			
		} ); // end of ready Function
		
		function fn_grid_init() {
			//그리드 내 콤보박스 바인딩
			fn_set_grid_combo();
			
			//get db session
			fn_get_session_id();
			
			//nav button area set width 0 
			$( "#btn_dwgMasterList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_dwgRevList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_uscMasterList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_uscDetailList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_uscStageDetailList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_ecoList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_dwgList_left" ).css( "width", 0 );
			
			//nav button area set width 0 
			$( "#btn_bomItemList_left" ).css( "width", 0 );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divDwgMaster" ), $( "#dwgMasterList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divDwgRevision" ), $( "#dwgRevList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divUscMaster" ), $( "#uscMasterList" ) );
			 
			//grid resize
			fn_insideGridresize( $(window), $( "#divDetail" ), $( "#uscDetailList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divStageDetail" ), $( "#uscStageDetailList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divEcoList" ), $( "#ecoList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divDwg" ), $( "#dwgList" ) );
			
			//grid resize
			fn_insideGridresize( $(window), $( "#divItem" ), $( "#bomItemList" ) );
		}
		
		//조회조건 Combo 초기화 설정
		function fn_get_combo() {
			//분류 콤보박스 데이터 바인딩
			$( "#p_dwg_group_type option" ).remove();
			$( "#p_dwg_group_type" ).append( "<option value=''>ALL</option>" );
			var param = { sd_type : "DWG_GROUP_TYPE" };
			$.post( "selectComboCodeMaster.do", param, function( data ) {
				for( var i = 0; i < data.length; i++ ) {
					$( "#p_dwg_group_type" ).append( "<option value='"+data[i].value+"'>"+data[i].text+"</option>" );
				}
			}, "json" );
		}
		
		//그리드 내 콤보박스 바인딩
		function fn_set_grid_combo() {
			//구분 콤보박스
			var param1 = { sd_type : "USC_PROJECT_TYPE" };
			$.post( "selectComboCodeMaster.do", param1, function( data ) {
				$( '#dwgMasterList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'project_type',
					data : data
				} );
			}, "json" );
			
			
			//구분 콤보박스
			var param2 = { sd_type : "DWG_TYPE" };
			$.post( "selectComboCodeMaster.do", param2, function( data ) {
				$( '#dwgMasterList' ).setObject( {
					value : 'value',
					text : 'text',
					name : 'dwg_type',
					data : data
				} );
			}, "json" );
		}
		
		function fn_get_job_dept_code() {
			var url = 'selectJobDeptCode.do';
			var formData = fn_getFormData( "#application_form" );
			$.post( url, formData, function( data ) {
				if( data[0] == null ) {
					alert( "도면부서와 JOB DEPT TYPE이 Mapping되지 않았습니다.\n관리자에게 문의해주세요." );
					fn_buttonDisabled( ['#btnSearch', '#btnSave', '#btnComfirm', '#btnComfirmCancel', '#btnEcoCreate', '#btnCreate'] );
				} else {
					$( "#p_job_dept_code" ).val( data[0].job_dept_code );
					fn_buttonEnable( ['#btnSearch', '#btnSave', '#btnComfirm', '#btnComfirmCancel', '#btnEcoCreate', '#btnCreate'] );
				}
			}, "json" );
		}
		
		//design engineer 등 가져오기
		function fn_register() {
			var url = 'empNoRegisterList.do';
// 			var formData = fn_getFormData( '#application_form' );
			var formData = { states_type : "ECO" };
			$.post( url, formData, function( data ) {
				for( var i = 0; data.length > i; i++ ) {
					if( data[i].register_type == "RME" ) {
	 					$( "#p_created_by" ).val( data[i].sub_emp_no );
	 					$( "#p_created_by_name" ).val( data[i].user_nm );
	 					$( "#p_user_group_name" ).val( data[i].dept_name );
					}
				}
			}, "json" );
		}
		
		//stage grid add row
		function add_stage() {
			//grid 수정내역 적용
			fn_grid_save_cell();
			
			//확정유무 및 BOM전송유무 체크
			if( fn_flag_check2() ) {
				return;
			}
			
			if( $( "#uscDetailList" ).getGridParam( "reccount" ) == 0 ) {
				alert( "WBS를 선택 후 STAGE를 추가하세요. " );
				return;
			}
			
			if( $( "#p_hidden_usc_detail_id" ).val() == "" ) {
				alert( "TYPE을 선택 후 STAGE를 추가하세요." );
				return;
			}
			
			if( $( "#p_hidden_pd_catalog" ).val() == "" ) {
				alert( "TYPE을 선택 후 STAGE를 추가하세요." );
				return;
			}
			
			if( $( "#p_hidden_dwg_no" ).val() == "" ) {
				alert( "선택된 되면이 없습니다." );
				return;
			}
			
			var item = {};
			var colModel = $( '#uscStageDetailList' ).jqGrid( 'getGridParam', 'colModel' );
			for ( var i in colModel )
				item[colModel[i].name] = '';

			item.stage_delete_button = '-';
			item.act_flag = 'A';
			item.act_flag_desc = 'ADD';
			item.usc_history_id = $( "#p_hidden_usc_history_id" ).val();
			item.usc_detail_id = $( "#p_hidden_usc_detail_id" ).val();
			item.pd_catalog = $( "#p_hidden_pd_catalog" ).val();
			item.dwg_no = $( "#p_hidden_dwg_no" ).val();
			item.oper = 'I';
			
			$( '#uscStageDetailList' ).resetSelection();
			$( '#uscStageDetailList' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
		}
		
		//grid 수정내역 적용
		function fn_grid_save_cell() {
			$( '#dwgMasterList' ).saveCell( dwg_master_change_item_row_num, dwg_master_change_item_col );
			$( '#dwgRevList' ).saveCell( dwg_rev_change_item_row_num, dwg_rev_change_item_col );
			$( '#uscMasterList' ).saveCell( usc_master_change_item_row_num, usc_master_change_item_col );
			$( '#uscDetailList' ).saveCell( usc_detail_change_item_row_num, usc_detail_change_item_col );
			$( '#uscStageDetailList' ).saveCell( usc_stage_change_item_row_num, usc_stage_change_item_col );
			$( '#ecoList' ).saveCell( eco_change_item_row_num, eco_change_item_col );
			$( '#dwgList' ).saveCell( dwg_change_item_row_num, dwg_change_item_col );
			$( '#bomItemList' ).saveCell( bom_item_change_item_row_num, bom_item_change_item_col );
		}
		
		//grid clear
		function fn_grid_clear( mode ) {
			if( mode == "dwgMasterList" ) {
				$( '#dwgRevList' ).jqGrid( 'clearGridData' );
				$( '#uscMasterList' ).jqGrid( 'clearGridData' );
				$( '#uscDetailList' ).jqGrid( 'clearGridData' );
				$( '#uscStageDetailList' ).jqGrid( 'clearGridData' );
				$( '#ecoList' ).jqGrid( 'clearGridData' );
				$( '#dwgList' ).jqGrid( 'clearGridData' );
				$( '#bomItemList' ).jqGrid( 'clearGridData' );
			} else if( mode == "dwgRevList" ) {
				$( '#uscMasterList' ).jqGrid( 'clearGridData' );
				$( '#uscDetailList' ).jqGrid( 'clearGridData' );
				$( '#uscStageDetailList' ).jqGrid( 'clearGridData' );
			} else if( mode == "uscMasterList" ) {
				$( '#p_hidden_usc_detail_id' ).val( '' );
				$( '#p_hidden_pd_catalog' ).val( '' );
				$( '#p_hidden_job_part_no' ).val( '' );
				
				
				
				$( '#uscDetailList' ).jqGrid( 'clearGridData' );
				$( '#uscStageDetailList' ).jqGrid( 'clearGridData' );
			} else if( mode == "uscDetailList" ) {
				$( '#p_hidden_usc_detail_id' ).val( '' );
				$( '#p_hidden_pd_catalog' ).val( '' );
				$( '#p_hidden_job_part_no' ).val( '' );
				
				$( '#uscStageDetailList' ).jqGrid( 'clearGridData' );
			} else if( mode == "ecoList" ) {
				$( '#dwgList' ).jqGrid( 'clearGridData' );
				$( '#bomItemList' ).jqGrid( 'clearGridData' );
			}
		}
		
		//dwg master 조회
		function fn_search() {
// 			if( $( "#p_master_project_no option:selected" ).val() == "" ) {
// 				alert( "대표호선을 선택해주세요." );
// 				$( "#p_master_project_no" ).focus();
// 				return;
// 			}
			
			if( $( "#p_delegate_project_no" ).val() == "" ) {
				alert( "대표호선을 선택해주세요." );
				$( "#p_delegate_project_no" ).focus();
				return;
			}
			
			//grid clear
			fn_grid_clear( "dwgMasterList" );
			
			$( "#dwgRevList" ).jqGrid( "setCaption", 'DWG REVISION LIST' );
			
			var sUrl = 'selectDwgMasterList.do';
			$( "#dwgMasterList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//eco list 조회
		function fn_search_dwg_revision() {
			//grid clear
			fn_grid_clear( "dwgRevList" );
			
			var sUrl = 'selectDwgRevList.do';
			$( "#dwgRevList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//master 조회
		function fn_search_usc_master() {
			//grid clear
			fn_grid_clear( "uscMasterList" );
			
			var sUrl = 'selectUscMasterList.do';
			$( "#uscMasterList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//detail 조회
		function fn_search_usc_detail() {
			//grid clear
			fn_grid_clear( "uscDetailList" );
			
			var sUrl = 'selectUscDetailList.do';
			$( "#uscDetailList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//stage 조회
		function fn_search_usc_stage() {
			var sUrl = 'selectUscStageDetailList.do';
			
			$( "#uscStageDetailList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( '#application_form' )
			} ).trigger( "reloadGrid" );			
		}
		
		function fn_search_eco() {
			fn_grid_clear( "ecoList" );
			
			var sUrl = 'selectUscEcoList.do';
			$( "#ecoList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		function fn_search_eco_dwg( usc_eco_id ) {
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, { p_usc_eco_id : usc_eco_id }, formData );
			
			var sUrl = 'selectEcoDwgList.do';
			$( "#dwgList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : parameters
			} ).trigger( "reloadGrid" );
		}
		
		function fn_search_bom_item( usc_eco_id ) {
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, { p_usc_eco_id : usc_eco_id }, formData );
			
			var sUrl = 'selectBomItemList.do';
			$( "#bomItemList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : parameters
			} ).trigger( "reloadGrid" );
		}
		
		function fn_eco_cancel( usc_eco_id ) {
			var url = 'saveEcoCancel.do';
// 			var formData = fn_getFormData( '#application_form' );
			var jsn = { p_usc_eco_id : usc_eco_id };
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, jsn, function( data ) {
				
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search();
				}
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		
		function fn_bom_trans( usc_eco_id ) {
			var url = 'saveBomCheck.do';
			var jsn = {
					p_usc_eco_id : usc_eco_id,
					p_job_dept_code : $( "#p_job_dept_code" ).val()
			};
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, jsn, function( data ) {
				
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search();
				}
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		
		
		function fn_search_bom_list() {
			var sUrl = 'selectUscBomWorkList.do';
			$( "#ecoList" ).jqGrid( 'setGridParam', {
				url : sUrl,
				page : 1,
				datatype : 'json',
				postData : fn_getFormData( "#application_form" )
			} ).trigger( "reloadGrid" );
		}
		
		//도면추가
		function fn_insert_dwg_info() {
// 			if( $( "#p_master_project_no option:selected" ).val() == "" ) {
// 				alert( "대표호선을 선택해주세요." );
// 				$( "#p_master_project_no" ).focus();
// 				return;
// 			}
			
			if( $( "#p_delegate_project_no" ).val() == "" ) {
				alert( "대표호선을 선택해주세요." );
				$( "#p_delegate_project_no" ).focus();
				return;
			}
			
			if( $( "#p_dwg_group_type option:selected" ).val() == "" ) {
				alert( "분류를 선택 해주세요." );
				$( "#p_dwg_group_type" ).focus();
				return;
			}
			
			alert( "작업시간이 다소 오래 걸릴 수 있습니다.\n확인을 누르신 후 잠시만 기다려주세요." );
			
			var url = 'insertDwgInfo.do';
			var formData = fn_getFormData( '#application_form' );
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, formData, function( data ) {
				
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search();
				}
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		
		//표준적용
		function fn_insert_standard_info() {
// 			if( $( "#p_master_project_no option:selected" ).val() == "" ) {
// 				alert( "대표호선을 선택해주세요." );
// 				$( "#p_master_project_no" ).focus();
// 				return;
// 			}

			if( $( "#p_delegate_project_no" ).val() == "" ) {
				alert( "대표호선을 선택해주세요." );
				$( "#p_delegate_project_no" ).focus();
				return;
			}
			
			var url = 'insertStandardInfo.do';
			var formData = fn_getFormData( '#application_form' );
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, formData, function( data ) {
				
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search();
				}
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		
		//확정
		function fn_dwg_confirm() {
			var chmResultRows = [];
			getSelectChmResultData( function( data ) {
				chmResultRows = data;
			} );
			
			if( chmResultRows.length == 0 ) {
				alert( "확정할 도면을 선택해주세요." );
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			
			var url = 'saveDwgBomConfirm.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for ( var keys in data) {
					for ( var key in data[keys]) {
						if(key == 'Result_Msg') {
							msg = data[keys][key];
						}

						if(key == 'result') {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				if( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
		
		
		
		//확정취소
		function fn_dwg_confirm_cancel() {
			var chmResultRows = [];
			getSelectChmResultData( function( data ) {
				chmResultRows = data;
			} );
			
			if( chmResultRows.length == 0 ) {
				alert( "확정할 도면을 선택해주세요." );
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			
			var url = 'saveDwgBomConfirmCancel.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for ( var keys in data) {
					for ( var key in data[keys]) {
						if(key == 'Result_Msg') {
							msg = data[keys][key];
						}

						if(key == 'result') {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				if( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
		
		//복구
		function fn_dwg_recovery() {
			var chmResultRows = [];
			getSelectChmResultData( function( data ) {
				chmResultRows = data;
			} );
			
			if( chmResultRows.length == 0 ) {
				alert( "복구할 도면을 선택해주세요." );
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			
			var url = 'saveDwgRecovery.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for ( var keys in data) {
					for ( var key in data[keys]) {
						if(key == 'Result_Msg') {
							msg = data[keys][key];
						}

						if(key == 'result') {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				if( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
		
		
		function fn_flag_check() {
// 			p_hidden_dwg_no
			
			var changedData = $( '#dwgMasterList' ).jqGrid( 'getRowData' );
			
			var confirm_flag = "";
			var bom_trans_flag = "";
			
			for( var i = 0; i < changedData.length; i++ ) {
				var item = changedData[i];
				if( item.dwg_no == $( "#p_hidden_dwg_no" ).val() ) {
					confirm_flag = item.confirm_flag;
					bom_trans_flag = item.bom_trans_flag;
				}
			}
			
			if( confirm_flag == "Y" && bom_trans_flag == "N" ) {
				alert( "해당 도면번호는 확정이 된 상태입니다.\n복구 후 수정작업을 진행해 주세요." );
				return true;
			}
			
			return false;
		}
		
		function fn_flag_check2() {
			var changedData = $( '#dwgMasterList' ).jqGrid( 'getRowData' );
			
			var confirm_flag = "";
			var bom_trans_flag = "";
			
			for( var i = 0; i < changedData.length; i++ ) {
				var item = changedData[i];
				if( item.dwg_no == $( "#p_hidden_dwg_no" ).val() ) {
					confirm_flag = item.confirm_flag;
					bom_trans_flag = item.bom_trans_flag;
				}
			}
			
			if( confirm_flag == "Y" && bom_trans_flag == "N" ) {
				alert( "해당 도면번호는 확정이 된 상태입니다.\n복구 후 수정작업을 진행해 주세요." );
				return true;
			}
			
			if( confirm_flag == "Y" && bom_trans_flag == "Y" ) {
				alert( "해당 도면번호는 BOM전송이 된 상태입니다." );
				return true;
			}
			
			return false;
		}
		
		
		//get db session
		function fn_get_session_id() {
			var url = "getWbsWorkTempSeqId.do";
			$.post( url, "", function( data ) {
				$( "#p_session_id" ).val( data[0].sessionId );
			}, "json");
		}
		
		function fn_delete_wbs_master( usc_history_id, wbs_item_code ) {
			//확정유무 및 BOM전송유무 체크
			if( fn_flag_check2() ) {
				return;
			}
			
			if( confirm( "WBS Master에 종속된 정보도 삭제됩니다.\n정말로 삭제하시겠습니까?" ) ) {
				var url = 'deleteWbsMasterInfo.do';
				var formData = { p_usc_history_id : usc_history_id, p_wbs_item_code : wbs_item_code };
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, formData, function( data ) {
					
					var msg = "";
					var result = "";
					
					for( var keys in data ) {
						for( var key in data[keys] ) {
							if( key == 'Result_Msg' ) {
								msg = data[keys][key];
							}
	
							if( key == 'result' ) {
								result = data[keys][key];
							}
						}
					}
					
					alert(msg);
	
					if( result == "success" ) {
						//재조회
						fn_search_usc_master();
					}
					
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();
				} );
			}
		}
		
		//wbs detail 및 stage 삭제
		function fn_delete_wbs_detail( usc_history_id, usc_detail_id, wbs_item_code, pd_list_id ) {
			//확정유무 및 BOM전송유무 체크
			if( fn_flag_check2() ) {
				return;
			}
			
			if( confirm( "WBS Detail에 종속된 Stage도 삭제됩니다.\n정말로 삭제하시겠습니까?" ) ) {
				var url = 'deleteWbsDetailInfo.do';
				var formData = { 
					p_usc_history_id : usc_history_id,
					p_usc_detail_id : usc_detail_id,
					p_wbs_item_code : wbs_item_code, 
					p_pd_list_id : pd_list_id 
				};
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, formData, function( data ) {
					
					var msg = "";
					var result = "";
					
					for( var keys in data ) {
						for( var key in data[keys] ) {
							if( key == 'Result_Msg' ) {
								msg = data[keys][key];
							}
	
							if( key == 'result' ) {
								result = data[keys][key];
							}
						}
					}
					
					alert(msg);
	
					if( result == "success" ) {
						//재조회
						fn_search_usc_detail();
					}
					
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();
				} );
			}
		}
		
		//stage 삭제
		function fn_delete_stage( usc_history_id, usc_detail_id, stage_no ) {
			//확정유무 및 BOM전송유무 체크
			if( fn_flag_check2() ) {
				return;
			}
			
			if( confirm( "Stage를 정말로 삭제하시겠습니까?" ) ) {
				var url = 'deleteStageInfo.do';
				
				var formData = { 
					p_usc_history_id : usc_history_id, 
					p_usc_detail_id : usc_detail_id, 
					p_stage_no : stage_no
				};
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, formData, function( data ) {
					
					var msg = "";
					var result = "";
					
					for( var keys in data ) {
						for( var key in data[keys] ) {
							if( key == 'Result_Msg' ) {
								msg = data[keys][key];
							}
	
							if( key == 'result' ) {
								result = data[keys][key];
							}
						}
					}
					
					alert(msg);
	
					if( result == "success" ) {
						//재조회
						fn_search_usc_detail();
					}
					
				}, "json" ).error( function () {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
			    	loadingBox.remove();
				} );
			}
		}
		
		//dwg revision 추가
		function fn_add_dwg_revision( usc_dwg_id ) {
			var url = 'insertDwgRevision.do';
			var formData = { p_usc_dwg_id : usc_dwg_id };
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			$.post( url, formData, function( data ) {
				
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search();
				}
				fn_search_dwg_revision();
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		
		
		//ECO 추가
		function fn_dwg_eco_add() {
			if( $( "#p_eng_change_order_code" ).val() == "" ) {
				alert( "추가 할 ECO를 입력해주세요." );
				return;
			}
			
			var chmResultRows = [];
			getSelectChmResultData( function( data ) {
				chmResultRows = data;
			} );
			
			if( chmResultRows.length == 0 ) {
				alert( "ECO 추가 할 도면을 선택해주세요." );
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			
			var url = 'saveDwgEcoAdd.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for ( var keys in data ) {
					for ( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				
				if( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
	
		//ECO 생성
		function fn_dwg_eco_create() {
			if( $( "#p_eco_reason_desc" ).val() == "" ) {
				alert( "추가 할 ECO의 원인코드를 입력해주세요." );
				return;
			}
			
			$( "#p_eco_no" ).val( "" );
			
			var url = 'saveDwgEcoCreate.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				var eco_no = "";
				
				for ( var keys in data ) {
					for ( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
						
						if( key == 'eco_no' ) {
							eco_no = data[keys][key];
						}
					}
				}
				
				alert( msg );
				
				if( result == 'success' ) {
					$( "#p_eco_no" ).val( eco_no );
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
		
		function fn_bom_create() {
			var chmResultRows = [];
			getSelectChmResultData( function( data ) {
				chmResultRows = data;
			} );
			
			if( chmResultRows.length == 0 ) {
				alert( "채번 및 BOM 생성 할 도면을 선택해주세요." );
				return;
			}
			
			if( $( "#p_eco_no" ).val() == "" ) {
				alert( "ECO NO를 생성 또는 추가하세요." );
				return;
			}
			
			var err = false;
			for( var k = 0; k < chmResultRows.length; k++ ) {
				if( chmResultRows[k].confirm_flag == "N" ) {
					alert( "확정되지 않은 도면이 있습니다." );
					err = true;
				}
				
				if( chmResultRows[k].bom_trans_flag == "Y" ) {
					alert( "채번 및 BOM생성이 진행된 도면이 있습니다." );
					err = true;
				}
				
				if( err ) {
					break;
				}
			}
			
			if( err ) {
				return;
			}
			
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			
			var url = 'saveBomTrans.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for ( var keys in data) {
					for ( var key in data[keys]) {
						if(key == 'Result_Msg') {
							msg = data[keys][key];
						}

						if(key == 'result') {
							result = data[keys][key];
						}
					}
				}
				
				alert( msg );
				if( result == 'success' ) {
					fn_search();
				}
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();	
			} );
		}
		
		//그리드 변경된 내용을 가져온다.
		function getChangedGridInfo( gridId ) {
			var changedData = $.grep( $( gridId ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.oper == 'I' || obj.oper == 'U';
			} );

			if( gridId == "#dwgMasterList" ) {
				changedData = changedData.concat( dwgMasterListData );
			} else if( gridId == "#dwgRevList" ) {
				changedData = changedData.concat( dwgRevListData );
			} else if( gridId == "#uscMasterList" ) {
				changedData = changedData.concat( uscMasterListData );
			} else if( gridId == "#uscDetailList" ) {
				changedData = changedData.concat( uscDetailListData );
			} else if( gridId == "#uscStageDetailList" ) {
				changedData = changedData.concat( uscStageDetailListData );
			} else if( gridId == "#ecoList" ) {
				changedData = changedData.concat( ecoListData );
			} else if( gridId == "#dwgList" ) {
				changedData = changedData.concat( dwgListData );
			} else if( gridId == "#bomItemList" ) {
				changedData = changedData.concat( bomItemListData );
			}
			
			return changedData;
		}
		
		function getSelectChmResultData( callback ) {
			var changedData = $.grep( $( "#dwgMasterList" ).jqGrid( 'getRowData' ), function( obj ) {
				return obj.enable_flag == 'Y';
			} );
			
			callback.apply( this, [ changedData.concat(resultData) ] );
		}
		
		function fn_save() {
			fn_grid_save_cell();
			
			var dwgMasterListResultRows = getChangedGridInfo( "#dwgMasterList" );
			var dwgRevListResultRows = getChangedGridInfo( "#dwgRevList" );
			var uscMasterListResultRows = getChangedGridInfo( "#uscMasterList" );
			var uscDetailListResultRows = getChangedGridInfo( "#uscDetailList" );
			var uscStageDetailListResultRows = getChangedGridInfo( "#uscStageDetailList" );
			var ecoListResultRows = getChangedGridInfo( "#ecoList" );
			var dwgListResultRows = getChangedGridInfo( "#dwgList" );
			var bomItemListResultRows = getChangedGridInfo( "#bomItemList" );
			
			loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
			
			var cnt = 0;
			if( dwgMasterListResultRows.length != 0 ) { cnt++; }
			if( dwgRevListResultRows.length != 0 ) { cnt++; }
			if( uscMasterListResultRows.length != 0 ) { cnt++; }
			if( uscDetailListResultRows.length != 0 ) { cnt++; }
			if( uscStageDetailListResultRows.length != 0 ) { cnt++; }
			if( ecoListResultRows.length != 0 ) { cnt++; }
			if( dwgListResultRows.length != 0 ) { cnt++; }
			if( bomItemListResultRows.length != 0 ) { cnt++; }
			
			if( cnt == 0 ) {
				alert( "변경내역이 없습니다." );
				loadingBox.remove();
				return;
			}
			
			var isError = false;
			var errMsg = "";
			
			for( var k = 0; k < uscStageDetailListResultRows.length; k++ ) {
				if( uscStageDetailListResultRows[k].stage_no == "" ) {
					errMsg = "STAGE는 필수입력입니다.";
					isError = true;
				}
			}
			
			if( isError ) {
				alert( errMsg );
				loadingBox.remove();
				return;
			}
			
			var dataList = {
				dwgMasterList : JSON.stringify( dwgMasterListResultRows ),
				dwgRevList : JSON.stringify( dwgRevListResultRows ),
				uscMasterList : JSON.stringify( uscMasterListResultRows ),
				uscDetailList : JSON.stringify( uscDetailListResultRows ),
				uscStageDetailList : JSON.stringify( uscStageDetailListResultRows ),
				ecoList : JSON.stringify( ecoListResultRows ),
				dwgList : JSON.stringify( dwgListResultRows ),
				bomItemList : JSON.stringify( bomItemListResultRows )
			};
			
			var url = 'saveActJobPdCreate.do';
			var formData = fn_getFormData( '#application_form' );
			var parameters = $.extend( {}, dataList, formData );
			
			$.post( url, parameters, function( data ) {
				var msg = "";
				var result = "";
				
				for( var keys in data ) {
					for( var key in data[keys] ) {
						if( key == 'Result_Msg' ) {
							msg = data[keys][key];
						}

						if( key == 'result' ) {
							result = data[keys][key];
						}
					}
				}
				
				alert(msg);

				if( result == "success" ) {
					//재조회
					fn_search_usc_detail();
				}
				
			}, "json" ).error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
			} ).always( function() {
		    	loadingBox.remove();
			} );
		}
		</script>
	</body>
</html>
