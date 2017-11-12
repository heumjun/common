<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Part List</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.required_cell{background-color:#F7FC96}
	.disabled_cell{background-color:#CDCDCD}
	input[type=text] {text-transform: uppercase;}
	td {text-transform: uppercase;}
</style>
</head>

<body>
<form id="application_form" name="application_form" >
	<input type="hidden" name="pageYn" id="pageYn" value="N" />
	<input type="hidden" name="p_is_excel" value="" />
	<input type="hidden" id="menu_id" name="menu_id" value="${menu_id}"/>
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	
	<div id="mainDiv" class="mainDiv">
	
		<div class= "subtitle">
			Part List
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="70">
			<col width="110">
			<col width="70">
			<col width="110">
			<col width="50">
			<col width="150">
			<col width="55">
			<col width="80">
			<col width="80">
			<col width="150">
			<col width="*">

			<tr>
				<th>PROJECT</th>
				<td>
					<input type="text" id="p_project_no" maxlength="13" name="p_project_no" value="" style="width:70px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				
				<th>DWG NO.</th>
				<td>
					<input type="text" id="p_dwg_no" maxlength="10" name="p_dwg_no" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				
				<th>MAKER</th>
				<td>
					<input type="text" id="p_maker" maxlength="10" name="p_maker" style="width:75px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				 
				<th>TAG NO.</th>
				<td>
					<input type="text" id="p_tag_no" maxlength="10" name="p_tag_no" style="width:55px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				
				<th>DESCRIPTION</th>
				<td>
					<input type="text" id="p_desc" name="p_desc" style="width:160px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>				
				<td>
					<div class="button endbox">
						<c:if test="${userRole.attribute1 == 'Y'}">
							<input type="button" value="조회" id="btnSearch" class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="저장" id="btnSave"  class="btn_blue" />
						</c:if>
					</div>
				</td>						
			</tr>
			
		</table>
		
		<table class="searchArea2">
			<col width="70">
			<col width="110">
			<col width="70">
			<col width="110">
			<col width="50">
			<col width="150">
			<col width="55">
			<col width="80">
			<col width="*">

			<tr>
				<th>ITEM CODE</th>
				<td style="height:30px;">
					<input type="text" id="p_item_code" maxlength="13" name="p_item_code" style="width:85px; ime-mode:disabled; text-transform: uppercase;" onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				
				<th>BLOCK</th>
				<td>
					<input type="text" id="p_dwg_no" maxlength="10" name="p_dwg_no" style="width:65px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				
				<th>STAGE</th>
				<td>
					<input type="text" id="p_stage_no" maxlength="10" name="p_stage_no" style="width:70px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				<th>STR</th>
				<td>
					<input type="text" id="p_str_flag" maxlength="10" name="p_str_flag" style="width:55px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				</td>
				<td>
					<div class="button endbox">
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="PRO-COPY" id="btnProjectCopy" class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="STAGE DIV" id="btnStageDiv"  class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="Execl출력" id="btnExport"  class="btn_blue" />
						</c:if>
						<c:if test="${userRole.attribute4 == 'Y'}">
							<input type="button" value="Execl등록" id="btnImport"  class="btn_blue" />
						</c:if>
					</div>
				</td>
			</tr>
		</table>
		
		<table class="searchArea2">
			<col width="70">
			<col width="110">
			<col width="70">
			<col width="110">
			<col width="50">
			<col width="150">
			<col width="55">
			<col width="80">
			<col width="*">
			
			<tr>
				<th>입력 여부</th>
				<td style="height:30px;">
					<fieldset style="border:none;width: 90px; display: inline;  height:20px; line-height:20px">		
						<input type="radio" name="loginGubun" value="plan" onclick="loginGubun_changed(this.value)" checked="checked"><label for="plan">ALL</label>&nbsp;
						<input type="radio" name="loginGubun" value="product" onclick="loginGubun_changed(this.value)"><label for="product">Y</label>&nbsp;
						<input type="radio" name="loginGubun" value="obtain" onclick="loginGubun_changed(this.value)"><label for="obtain">N</label>
					</fieldset>
				</td>
				<th>BUY-BUY</th>
				<td style="height:30px;">
					<fieldset style="border:none;width: 90px; display: inline;  height:20px; line-height:20px">		
						<input type="radio" name="loginGubun" value="plan" onclick="loginGubun_changed(this.value)" checked="checked"><label for="plan">ALL</label>&nbsp;
						<input type="radio" name="loginGubun" value="product" onclick="loginGubun_changed(this.value)"><label for="product">Y</label>&nbsp;
						<input type="radio" name="loginGubun" value="obtain" onclick="loginGubun_changed(this.value)"><label for="obtain">N</label>
					</fieldset>
				</td>
				<th>DEPT</th>
				<td>
					<select name="p_sel_dept" id="p_sel_dept" style="width:110px;" onchange="javascript:DeptOnChange(this);" ></select>
					<input type="hidden" name="p_dept_code" value="${loginUser.dwg_dept_code}" />
					<input type="hidden" name="p_dept_name" value="${loginUser.dwg_dept_name}" />
				</td>
				<th>USER</th>
				<td>
					<input type="text" id="p_user" maxlength="10" name="p_user" style="width:55px; "/>
				</td>
				<td style="border-left:none;">
				</td>			
			</tr>
		</table>		
				
		<div class="content">
			<table id = "jqGridPartList"></table>
			<div   id = "btnjqGridPartList"></div>
		</div>	
	</div>	
</form>

<script type="text/javascript">
var idRow;
var idCol;
var kRow;
var kCol;
var tableId;
var resultData = [];
var jqGridObj = $("#jqGridPartList");

var requiredColName = new Array("ea_plan", "primary_item_code");

$(document).ready(function(){
        
	getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);
	
	var objectHeight = gridObjectHeight(2);
	
	var gridColModel = [{label:'partlist_id', name:'partlist_id', index:'partlist_id', width:60, align:'center', sortable:false, hidden:true},
	                    {label:'bom_id', name:'bom_id', index:'bom_id', width:60, align:'center', sortable:false, hidden:true},
	                    {label:'PROJECT', name:'project_no', index:'project_no', width:60, align:'center', sortable:false},
	                    {label:'Equip', name:'equipment_name', index:'equipment_name', width:330, align:'left', sortable:false},
	                    {label:'Maker', name:'vendor_site_code_alt', index:'vendor_site_code_alt', width:330, align:'left', sortable:false},
						{label:'TAG NO.', name:'tag_no', index:'tag_no', width:100, align:'center', sortable:false}, 
						{label:'DESCRIPTION', name:'equip_description', index:'equip_description', width:330, align:'left', sortable:false}, 
						{label:'EA', name:'ea_obtain', index:'ea_obtain', width:40, align:'center', formatter:'integer', sortable:false}, 
						{label:'ITEM CODE', name:'plm_item_code', index:'plm_item_code', width:120, align:'center', sortable:false, editable:true, cellattr: function (){return 'class="required_cell"';}
							 , edittype:"select"
							 , editoptions:{
								 value:"YARD:YARD; MARKER:MARKER",
								 dataEvents : [ { type : 'change',
						 			              fn : function( e ) {
						 			    		      //입력 값 조정
						 			    		  	  cellItemCodeChangeAction(idRow, this.name, $(this).val());
						 				   		  }
						 				        },
						 				        //밖으로 빠져나갈 때 이벤트
						 				       { type : 'blur',
							 			              fn : function( e ) {
							 			    		      //입력 값 조정
							 			    		  	  cellItemCodeChangeAction(idRow, this.name, $(this).val());
							 				   		  }
							 				        }    
						 				        ]
							   }
						},
						{label:'EA', name:'ea_plan', index:'ea_plan', width:40, align:'center', formatter:'integer', sortable:false, editable:true, cellattr: function (){return 'class="required_cell"';}}, 
						{label:'BLOCK', name:'plm_block_no', index:'plm_block_no', width:60, align:'center', sortable:true, title:false, editable:true,
							editoptions: { 
					            dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setJobCode(rowId);
					                }
					            }]
							 }
						},
						{label:'STAGE', name:'plm_stage_no', index:'plm_stage_no', width:80, align:'center', sortable:false, editable:true},
						{label:'STR', name:'plm_str_flag', index:'plm_str_flag', width:60, align:'center', sortable:true, title:false, editable:true,
							 editoptions: { 
					            dataEvents: [{
					            	type: 'change'
					            	, fn: function(e) {
					            		var row = $(e.target).closest('tr.jqgrow');
					                    var rowId = row.attr('id');
					                    //job code 셋팅
					                    setJobCode(rowId);
					                }
					            }]
							 }
						},
						{label:'KEY', name:'plm_str_key', index:'plm_str_key', width:100, align:'center', sortable:false, editable:true},
						{label:'DWG NO.', name:'drawing_no', index:'drawing_no', width:100, align:'center', sortable:false},
						{label:'MOTHER', name:'plm_mother_code', index:'plm_mother_code', width:100, align:'center', sortable:false},
						{label:'JOB', name:'primary_item_code', index:'primary_item_code', width:160, align:'center', sortable:false, title:false, editable:true,
							 edittype : "select",
					   		 editrules : { required : false },
					   		 cellattr: function (){return 'class="required_cell"';},
					   		 editoptions: {
							 	dataUrl: function(){
					             	var item = jqGridObj.jqGrid( 'getRowData', idRow );
					             	var url = "";
					             	if(item.plm_block_no != ""){
					 					url = "emsPartListJobList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_block_no="+item.plm_block_no.toUpperCase()+"&p_str_flag="+item.plm_str_flag.toUpperCase();
							 		}
					 				return url;
							 	},
					   		 	buildSelect: function(data){
					   		 		var item = jqGridObj.jqGrid( 'getRowData', idRow );
							   		if(item.plm_block_no != ""){
							   			if(typeof(data)=='string'){
						      		 		data = $.parseJSON(data);
						      		 	}
						       		 	var rtSlt = '<select name="deptid">';
						       		 	
						       		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
											if(data.length == 2 && data[idx].value != " "){
												rtSlt +='<option value="'+data[idx].value+'">'+data[idx].text+'</option>';	
							       		 	}else{
							       		 		rtSlt +='<option value="'+data[idx].value+'">'+data[idx].text+'</option>';
							       		 	}
						       		 	}
							       		rtSlt +='</select>';
							       		
							       		return rtSlt;
							   		}
					   		 	}
					   		}
					   	},
						{label:'DATE', name:'creation_date', index:'creation_date', width:120, align:'center', sortable:false}, 
						{label:'DEPT', name:'dept_name', index:'dept_name', width:160, align:'center', sortable:false}, 
						{label:'USER', name:'user_name', index:'user_name', width:100, align:'center', sortable:false}, 
						{label:'COMMENT', name:'plm_comment', index:'plm_comment', width:150, align:'center', sortable:false, editable:true},
						{label:'lock_flag', name:'lock_flag', index:'lock_flag', width:100, align:'center', sortable:false, hidden:true},
						{label:'oper', name:'oper', index:'oper', width:100, align:'center', sortable:false, hidden:true}
			            ];
	
	jqGridObj.jqGrid( {
		datatype : 'json',
		mtype : '',
		url : '',
		postData : fn_getFormData( "#application_form" ), 
		colModel : gridColModel, 
		gridview : true, 
		toolbar : [ false, "bottom" ], 
		viewrecords : true,
		//shrinkToFit : false,
		multiselect: true,
		autowidth : true,
		height : objectHeight,
		pager : $('#btnjqGridPartList'),
		cellEdit : true, // grid edit mode 1
		cellsubmit : 'clientArray', // grid edit mode 2
		rowList : [ 100, 500, 1000 ],
		recordtext: '내용 {0} - {1}, 전체 {2}',
   	    emptyrecords:'조회 내역 없음',
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
			
			var rows = $(this).getDataIDs();
			
			for (var i=0; i < rows.length; i++ ) {
				var rowid = rows[i]-1;
				var item = $(this).jqGrid( 'getRowData', rows[i] );
				
				for (var j=0; j<requiredColName.length; j++){
					//컬럼 editable 설정
					if(item.plm_item_code != "YARD"){
						changeEditableByContainRow(jqGridObj, rowid, requiredColName[j],'',true);
					}else{
						syncClassByContainRow(jqGridObj, rowid, requiredColName[j],'', true,'required_cell');
					}
					
					
				}
			}
		},
		onCellSelect : function( rowid, iCol, cellcontent, e ) {
			$(this).saveCell( kRow, kCol );
			
			var cm = $(this).jqGrid( "getGridParam", "colModel" );
			var colName = cm[iCol];
			var item = $(this).jqGrid( 'getRowData', rowid );
			
			
// 			if( rowid != null ) {
// 				if( item.oper != "I" ) {
// 					$(this).jqGrid( 'setCell', rowid, 'model_no', '', 'not-editable-cell' );
// 				}
// 			}
		},
		gridComplete : function () {
			
			//
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				var oper = jqGridObj.getCell( rows[i], "oper" );

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
	fn_gridresize( $(window), jqGridObj, 80 );
	
	//조회 버튼 클릭
	$("#btnSearch").click(function(){
		
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		$("input[name=pageYn]").val("N");
		$("input[name=p_is_excel]").val("N");
		var sUrl = "emsPartListMainList.do";
		jqGridObj.jqGrid( "clearGridData" );
		jqGridObj.jqGrid( 'setGridParam', {
			url : sUrl,
			mtype : 'POST',
			datatype : 'json',
			page : 1,
			postData : fn_getFormData( "#application_form" )
		} ).trigger( "reloadGrid" );
		
		
	});
	

	// 저장버튼
	$("#btnSave").click(function(){
		
		var logingubun = $('#loginGubun').val();

		var itemcodes = "";
		var item_codes = "'";
		var rtn = true;
		jqGridObj.saveCell( kRow, idCol );
		
		
		if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
			var changeRows = [];
			getGridChangedData(jqGridObj,function(data) {				
				changeRows = data;

				if (changeRows.length == 0) {
					alert("저장할 내역이 없습니다.");
					return;
				}

				for(var i=0; i<changeRows.length; i++){
					if(changeRows[i].primary_item_code.trim() == ""){
						alert("Job을 입력하십시오.");
						rtn = false;
						return false;
					}
					if(changeRows[i].ea_plan.trim() == "0" || changeRows[i].ea_plan.trim() == ""){
						alert("EA를 입력하십시오.");
						rtn = false;
						return false;
					}
				}
				
				if(!rtn){
					return false;
				}
				
				var dataList = { chmResultList : JSON.stringify(changeRows) };
				var url = 'emsPartListSaveAction.do';
				var formData = fn_getFormData('#application_form');
				var parameters = $.extend( {}, dataList, formData );
				
				loadingBox = new ajaxLoader( $( '#mainDiv' ), { classOveride : 'blue-loader', bgColor : '#000', opacity : '0.3' } );
				
				$.post( url, parameters, function( data ) {
					alert(data.resultMsg);
					$("#btnSearch").click();
				}, "json").error( function() {
					alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
				} ).always( function() {
					loadingBox.remove();
				} );
			} );
		}
			
	});
	
	//Export 버튼 클릭 시 
	$("#btnExport").click(function(){
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
		var colName = new Array();
		var dataName = new Array();
		
		for(var i=0; i<gridColModel.length; i++ ){
			if(gridColModel[i].hidden != true){
				colName.push(gridColModel[i].label);
				dataName.push(gridColModel[i].name);
			}
		}
		
		form = $('#application_form');

		$("input[name=p_is_excel]").val("Y");
		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
		form.attr("action", "emsPartListExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName);
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();		
	});
	
	//Stage Div 클릭 시
	$("#btnStageDiv").click(function(){
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

		if(row_id.length > 1) {
			alert("1개의 행만 선택하십시오.");
			return false;
		}
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		
		var item = jqGridObj.jqGrid( 'getRowData', row_id );
		var sURL = "popUpEmsPartListStageDiv.do?p_partlist_id="+item.partlist_id;
		var popOptions = "dialogWidth: 1230px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;"; 
		window.showModalDialog(sURL, window, popOptions);
	});
	
	//Project Copy 클릭 시
	$("#btnProjectCopy").click(function(){
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');

		if(row_id.length > 1) {
			alert("1개의 행만 선택하십시오.");
			return false;
		}
		if(row_id == ""){
			alert("행을 선택하십시오.");
			return false;
		}
		
		var item = jqGridObj.jqGrid( 'getRowData', row_id );
		var sURL = "popUpEmsPartListProjectCopy.do?p_partlist_id="+item.partlist_id;
		var popOptions = "dialogWidth: 1230px; dialogHeight: 700px; center: yes; resizable: no; status: no; scroll: yes;"; 
		window.showModalDialog(sURL, window, popOptions);
	});
	
	//Import 클릭 시 
	$("#btnImport").click(function(){
		var sURL = "popUpEmsPartListExcelImport.do";
		var popOptions = "dialogWidth: 450px; dialogHeight: 160px; center: yes; resizable: yes; status: no; scroll: yes;"; 
		window.showModalDialog(sURL, window, popOptions);
	});
	
});	

//afterSaveCell oper 값 지정
function chmResultEditEnd(irowId, cellName, val, irow, iCol) {
	var item = jqGridObj.jqGrid( 'getRowData', irowId );
	
	if( item.oper != 'I' ){
		item.oper = 'U';
		jQuery("#"+irowId).css("background", "#CCFE87");
	}
	jqGridObj.jqGrid( "setRowData", irowId, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );

	//입력 후 대문자로 변환	
	jqGridObj.setCell (irowId, cellName, val.toUpperCase());
}

function cellItemCodeChangeAction(irow, cellName, cellValue, rowIdx){
	
	jqGridObj.saveCell(kRow, idCol );
	//선택한 행의 rowIdx 구함
	if(typeof(rowIdx) == "undefined" && kRow > 0){
		rowIdx = kRow-1;
	}
	
	
	//MARKER이면 수정 불가능
	if(cellValue != "YARD"){
		//컬럼 색상 변경 
		//jQuery(jqGridObj).setCell (irow, 'item_code','', noUniqCellBgColor);
		for (var i=0; i<requiredColName.length; i++){
			jQuery(jqGridObj).setCell (irow, requiredColName[i],'&nbsp;', '');
			syncClassByContainRow(jqGridObj, rowIdx, requiredColName[i],'', false,'required_cell');
			//컬럼 editable 설정
			changeEditableByContainRow(jqGridObj, rowIdx, requiredColName[i],'',true);
		}
	}else{
		//컬럼 색상 변경 (필수값)
		//jQuery(jqGridObj).setCell (irow, 'item_code','', uniqCellBgColor);		
		for (var i=0; i<requiredColName.length; i++){
			syncClassByContainRow(jqGridObj, rowIdx, requiredColName[i],'', true,'required_cell');
			//컬럼 editavle 설정 해제
			changeEditableByContainRow(jqGridObj, rowIdx, requiredColName[i],'',false);
		}
	}
}


function setJobCode(rowId){
		
	jqGridObj.saveCell(kRow, idCol );
	
	//초기화
	jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', "&nbsp;");
	
	var item = jqGridObj.jqGrid( 'getRowData', rowId );
	//속도 문제로 block No가 들어왔을 때만 실행.
	if(item.plm_block_no != ""){
	    $.ajax({
			url : "emsPartListJobList.do?p_project_no="+$("input[name=p_project_no]").val()+"&p_block_no="+item.plm_block_no.toUpperCase()+"&p_str_flag="+item.plm_str_flag.toUpperCase(),
			async : false,
			cache : false, 
			dataType : "json",
			success : function(data){
				if(data.length == 1){
					jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', data[0].value);
				}else{
					jqGridObj.jqGrid('setCell', rowId, 'primary_item_code', '&nbsp;');
				}
			}
		});
	}
}

</script>
</body>

</html>