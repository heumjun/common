<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>발신문서 DWG No. 입력</title>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<script src="//github.com/fyneworks/multifile/blob/master/jQuery.MultiFile.min.js" type="text/javascript" language="javascript"></script>

<style>
 	.popMainDiv{margin:0px; } 
 	.popMainDiv .WarningArea{width:490px;  border:1px solid #ccc; padding:8px; margin-bottom:0px; } 
 	.popMainDiv .WarningArea .tit{font-size:12pt; margin-bottom:6px; color:red; font-weight:bold;}
</style>
</head>
<body>
<form id="application_form" name="application_form" enctype="multipart/form-data" method="post">
<input type="hidden" id="row_selected" name="row_selected" value="${row_selected}" />
<input type="hidden" id="p_project_no" name="p_project_no" value="${p_project_no}" />
<input type="hidden" id="p_send_id" name="p_send_id" value="${p_send_id}" />
<input type="hidden" id="p_user_id" name="p_user_id" value="${p_user_id}" />
<input type="hidden" id="p_dept_code" name="p_dept_code" value="${p_dept_code}" />
<input type="hidden" id="p_send_type" name="p_send_type" value="${p_send_type}" />
<input type="hidden" id="p_dwg_edit" name="p_dwg_edit" value="${p_dwg_edit}" />

	<div id="mainDiv" class="mainDiv" style="margin-left:0px;width:100%">			 
		<div class= "subtitle">
			발신문서 DWG No. 입력
		</div>
		<table class="searchArea conSearch">
			<col width="10">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 

			</td>
			<td style="border-left:none;">
				<div class="button endbox">
					<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
					<input type="button" class="btn_blue2" value="DELETE" id="btnDel"/>
					<input type="button" value="SAVE" id="btnSave" class="btn_blue2" />
				</div>
			</td>						
			</tr>
		</table>
		<div class="content">
			<table id = "jqGridList"></table>
			<div   id = "btnjqGridList"></div>
		</div>	
	</div> <!-- .mainDiv end -->
</form>

<script type="text/javascript" >
//File Implode Submit Form 셋팅.
$(function() {

}); //function end

var idRow;
var idCol;
var kRow;
var kCol;
var resultData = [];

var jqGridObj = $('#jqGridList');

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'Drawing No', name:'dwg_no', index:'dwg_no', width:35, align:'center', editable:true, sortable:false, title:false,
		edittype : "select",
		editoptions: {
			dataUrl: function(){
				var item = jqGridObj.jqGrid( 'getRowData', idRow );
				var url = "popupCommentSendGridDwgNo.do?p_project_no="+$("#p_project_no").val()
						+"&p_dept_code="+$("#p_dept_code").val()
						+"&p_send_type="+$("#p_send_type").val();
				return url;
		 	},
 		 	buildSelect: function(data){
    		 	if(typeof(data)=='string'){
    		 		data = $.parseJSON(data);
    		 	}
     		 	var rtSlt = '<select id="gridDwgNo" name="gridDwgNo" >';
     		 	for ( var idx = 0 ; idx < data.length ; idx ++) {
     		 		rtSlt +='<option value="'+data[idx].value+'" name="'+data[idx].dwg_desc+'" >'+data[idx].value+' : '+data[idx].dwg_desc+'</option>';	
     		 	}
	       		rtSlt +='</select>';
	       		return rtSlt;
 		 	},
			dataEvents: [{
				type: 'change',
				fn: function(e) {
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					var dwgDesc = $(e.target).find("option:selected").attr('name');
					
					jqGridObj.jqGrid( "setCell", rowId, 'dwg_desc', dwgDesc );
					changeDwgNo(rowId, e.target.value);
				}
			},{
				type : 'keydown', 
				fn : function( e) { 
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					var key = e.charCode || e.keyCode; 
					var dwgDesc = $(e.target).find("option:selected").attr('name');
					
					if( key == 13 || key == 9) {
						
						jqGridObj.jqGrid( "setCell", rowId, 'dwg_desc', dwgDesc );
						changeDwgNo(rowId, e.target.value);
	            	}
	            }
			},{
				type : 'blur', 
				fn : function( e) { 
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					var dwgDesc = $(e.target).find("option:selected").attr('name');
					
					jqGridObj.jqGrid( "setCell", rowId, 'dwg_desc', dwgDesc );
					changeDwgNo(rowId, e.target.value);
	            }
			}]
 		}	
	});
	gridColModel.push({label:'Rev.', name:'dwg_rev', index:'dwg_rev', width:15, align:'center', editable:true, sortable:false, title:false,
		editoptions: {
			dataInit: function (el) { 
				$(el).css('text-transform', 'uppercase'); 
				
			}
		}	
	});
	gridColModel.push({label:'DESCRIPTION', name:'dwg_desc', index:'dwg_desc', width:100, align:'left', sortable:false});
	gridColModel.push({label:'App. Submit', name:'app_submit', index:'app_submit', width:30, align:'center', sortable:false, title:false});
	gridColModel.push({label:'App. Receive', name:'app_receive', index:'app_receive', width:30, align:'center', sortable:false, title:false});
	gridColModel.push({label:'OPER', name:'oper', index:'oper', width:20, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'OPER TEMP', name:'oper_temp', index:'oper_temp', width:20, align:'center', sortable:false, hidden:true});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	
	var dwgEdit = $("#p_dwg_edit").val();
	if(dwgEdit == 'N'){
		fn_buttonDisabled2([ "#btnAdd" ]);
		fn_buttonDisabled2([ "#btnDel" ]);
		fn_buttonDisabled2([ "#btnSave" ]);
	}
	
	jqGridObj.jqGrid({ 
		datatype: 'json', 
		mtype: 'POST', 
		url:'popUpCommentSendDwgNoList.do',
		postData : fn_getFormData('#application_form'),
		colModel:gridColModel,
		gridview: true,
		multiselect: true,
		toolbar: [false, "bottom"],
		viewrecords: true,
		autowidth: true,
		height: 470,
		cellEdit : true,
		pgbuttons : false,
		pgtext : false,
		pginput : false,
		cellsubmit : 'clientArray', // grid edit mode 2
		scrollOffset : 17,
		shrinkToFit:true,
		pager: $('#btnjqGridList'),
		//rowList:[100,500,1000],
		recordtext: '내용 {0} - {1}, 전체 {2}',
		emptyrecords:'조회 내역 없음',
		rowNum:100, 
		beforeEditCell :  function(rowid, cellname, value, iRow, iCol) {
			idRow=rowid;
			idCol=iCol;
			kRow = iRow;
			kCol = iCol;
		},
		jsonReader : {
			root: "rows",
			page: "page",
			total: "total",
			records: "records",  
			repeatitems: false,
		},        
		imgpath: 'themes/basic/images',
		onPaging: function(pgButton) {

		},			
		loadComplete: function (data) {
			var $this = $(this);
			if ($this.jqGrid('getGridParam', 'datatype') === 'json') {
				$this.jqGrid('setGridParam', {
					datatype: 'local',
					data: data.rows,
					pageServer: data.page,
					recordsServer: data.records,
					lastpageServer: data.total
				});
				
				this.refreshIndex();
				
				if ($this.jqGrid('getGridParam', 'sortname') !== '') {
					$this.triggerHandler('reloadGrid');
				}
			} else {
				$this.jqGrid('setGridParam', {
					page: $this.jqGrid('getGridParam', 'pageServer'),
					records: $this.jqGrid('getGridParam', 'recordsServer'),
					lastpage: $this.jqGrid('getGridParam', 'lastpageServer')
				});
				this.updatepager(false, true);
			}		
			
			/* 입력 활성화 권한으로 들어왔을때 */
			if(dwgEdit == 'Y'){
				//저장된 DWG NO 리스트를 메인화면에 되돌려줌
				var dwgNo = "";
				var dwgNoList = "";
				var row_id = jqGridObj.jqGrid( 'getDataIDs' );
				
				// 'D80000000 외3건' 과 같은 형식 
				var item = jqGridObj.jqGrid( 'getRowData', row_id[0]);
				dwgNo = item.dwg_no;
				if(row_id.length > 1){
					dwgNo += " 외";
					dwgNo += row_id.length-1;
					dwgNo += "건";
				}
				
				// 'D80000000(AB), V2500000(A), V2600000(AB)' 과 같은 형식
				for(var i=0; i<row_id.length; i++){
					var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
					if(dwgNoList != "") dwgNoList += ", ";
					dwgNoList += item.dwg_no + "(" + item.dwg_rev + ")";
				}
					
				if(dwgNoList != ""){
					window.dialogArguments.jqGridObj.setCell( $("#row_selected").val(), 'dwg_no', dwgNo);
					window.dialogArguments.jqGridObj.setCell( $("#row_selected").val(), 'dwg_no', '', '', {title : dwgNoList} );
				}else{
					window.dialogArguments.jqGridObj.setCell( $("#row_selected").val(), 'dwg_no', '&nbsp;');
					window.dialogArguments.jqGridObj.setCell( $("#row_selected").val(), 'dwg_no', '', '', {title : ''} );
				}
				window.dialogArguments.jqGridObj.setCell( $("#row_selected").val(), 'oper', 'U');
			}
			/* 입력 비활성화 권한으로 들어왔을때 */
			else if(dwgEdit == 'N'){
				var row_id = jqGridObj.jqGrid( 'getDataIDs' );
				for(var i=0; i<row_id.length; i++){
					//해당 CELL 비활성 모드
					jQuery("#jqGridList").jqGrid('setCell', row_id[i], 'dwg_no', '', 'not-editable-cell');
					jQuery("#jqGridList").jqGrid('setCell', row_id[i], 'dwg_rev', '', 'not-editable-cell');
					//changeEditableByContainRow(jqGridObj, i, 'dwg_no','',true);
					//changeEditableByContainRow(jqGridObj, i, 'dwg_rev','',false);
				}
			}

		},	
		onCellSelect : function( rowid, iCol, cellcontent, e ) {

		},
		afterSaveCell : chmResultEditEnd
	}); //end of jqGrid
	
});	//ready function end

//DwgNo를 변경하였을때 DESCRIPTION 변경
var changeDwgNo = function(rowId, dwgNo){
	jqGridObj.saveCell(kRow, idCol );

	var sendType = $("#p_send_type").val();
	firstDwgNo = dwgNo.substring(0,1);
	
	$.ajax({
		url : "popupCommentSendGridDwgNoAppSubmit.do?p_project_no="+$("#p_project_no").val()
			+"&p_send_type="+$("#p_send_type").val()
			+"&p_dwg_no="+dwgNo,
		async : true, //동기: false, 비동기: ture
		cache : false, 
		dataType : "json",
		success : function(data){
			
			if(sendType == 'C') {
				jqGridObj.jqGrid( "setCell", rowId, 'app_submit', data[0].cl_plan_s );	
				jqGridObj.jqGrid( "setCell", rowId, 'app_receive', data[0].cl_plan_f );
			} else {
				
				if(firstDwgNo == 'V') {
					jqGridObj.jqGrid( "setCell", rowId, 'app_submit', data[0].cl_plan_s );	
					jqGridObj.jqGrid( "setCell", rowId, 'app_receive', data[0].cl_plan_f );
				} else {
					jqGridObj.jqGrid( "setCell", rowId, 'app_submit', data[0].ow_plan_s );
					jqGridObj.jqGrid( "setCell", rowId, 'app_receive', data[0].ow_plan_f );	
				}
				
			}
			
			jqGridObj.saveCell(kRow, idCol );
		}
	});
}

//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {
	
	var item = jqGridObj.jqGrid( 'getRowData', irow );
	
	if (item.oper == 'D'){
		item.oper_temp = 'U';
	}else if (item.oper != 'I'){
		item.oper = 'U';
	}
	
	jqGridObj.jqGrid( "setRowData", irow, item );
	$( "input.editable,select.editable", this ).attr( "editable", "0" );
	
	if(val == null) val = "";
	//입력 후 대문자로 변환
	jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
}

function fn_search() {
	var sUrl = "popUpCommentSendDwgNoList.do";
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
}

//저장버튼
$( "#btnSave" ).click( function() {
	fn_save();
} );

//저장
function fn_save() {
	jqGridObj.saveCell( kRow, idCol );
	
	//변경 사항 Validation
	if( !fn_checkValidate() ) {
		return;
	}
	
	//도면번호 중복 체크
	var rows = jqGridObj.getDataIDs();
	for(var i=0; i<rows.length; i++){
		for(var j=i+1; j<rows.length; j++){
			var item1 = jqGridObj.jqGrid( 'getRowData', rows[i] );
			var item2 = jqGridObj.jqGrid( 'getRowData', rows[j] );
			if(item1.dwg_no == item2.dwg_no){
				alert(item1.dwg_no + " 도면번호가 중복입니다.");
				return;
			}
		}
	}
	
	
	if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
		var chmResultRows = [];
		
		getChangedChmResultData(function( data ) {
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'popUpCommentSendDwgNoSave.do';
			var formData = fn_getFormData( '#application_form' );
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

//그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( jqGridObj.jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );
	callback.apply(this, [ changedData.concat(resultData) ]);
};

//변경 사항 Validation
function fn_checkValidate() {
	var result = true;
	var message = "";
	var nChangedCnt = 0;
	var ids = jqGridObj.jqGrid( 'getDataIDs' );

	for( var i = 0; i < ids.length; i++ ) {
		var oper = jqGridObj.jqGrid( 'getCell', ids[i], 'oper' );

		if( oper == 'I' || oper == 'U' || oper == 'D' ) {
			nChangedCnt++;
			
			//필수항목 체크 : dwg_no
			var val1 = jqGridObj.jqGrid( 'getCell', ids[i], 'dwg_no' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "Drawing No 를 입력하십시오." );
				return;
			}
			//필수항목 체크 : dwg_no
			var val2 = jqGridObj.jqGrid( 'getCell', ids[i], 'dwg_rev' );
			if ( $.jgrid.isEmpty( val2 ) ) {
				alert( "Rev. 를 입력하십시오." );
				return;
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

//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
$("#btnAdd").click(function(){
	jqGridObj.saveCell(kRow, idCol );
	var item = {};
	item.oper = 'I';
	jqGridObj.resetSelection();
	jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );

	jqGridObj.saveCell(kRow, idCol );
});

//del 버튼  클릭
$("#btnDel").click(function(){
	var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
	if(row_id == ""){
		alert("행을 선택하십시오.");
		return false;
	}		
	
	for(var i=0; i<row_id.length; i++){
		var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
		if(item.oper == 'I'){		
			jqGridObj.jqGrid('delRowData',row_id[i]);	
		}else if(item.oper == 'U' || item.oper == ''){
			item.oper_temp = item.oper;
			item.oper = 'D';
			jqGridObj.jqGrid( "setRowData", row_id[i], item );
			jQuery("#"+row_id[i]).css("background", "#F4B5A9");
		}else if(item.oper == 'D'){
			item.oper = item.oper_temp;
			item.oper_temp = '';
			jqGridObj.jqGrid( "setRowData", row_id[i], item );
			jQuery("#"+row_id[i]).css("background", "");
		}
	}
	
	//전체 체크 해제
	jqGridObj.resetSelection();
});

</script>
</body>
</html>