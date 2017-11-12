<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>발신문서</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.sscType {
		color: #324877;
		font-weight: bold;
	}
</style>
</head>

<body>
<form id="application_form" name="application_form" >
	
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="p_auth_code" id="p_auth_code"  value="${loginUser.author_code}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	
	<input type="hidden" name="p_check_series" id="p_check_series" value="${p_chk_series}" />
	<input type="hidden" name="search_project_no" id="search_project_no"  value="" />
	<input type="hidden" name="h_user_name" id="h_user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="h_user_id" id="h_user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="confirm_user" id="confirm_user"  value="${loginUser.confirm_user}" />
	<input type="hidden" name="h_dept_name" id="h_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />" />
	<input type="hidden" name="h_dept_code" id="h_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />" /> 
	<input type="hidden" name="h_my_dept_yn" id="h_my_dept_yn" value="Y" /> 
	
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			발신문서
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="700">
			<col width="200">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				Project
				<input type="text" class="required" id="p_project_no" name="p_project_no" maxlength="10" style="width:50px; ime-mode:disabled;"  onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
				&nbsp;
				DWG No
				<input type="text" id="p_dwg_no" name="p_dwg_no" style="width:75px;"/>
				&nbsp;
				구분
				<select name="p_send_type" id="p_send_type" style="width:60px;" >
					<option value="ALL">ALL</option>
					<option value="O">BUYER</option>
					<option value="C">CLASS</option>
				</select>
				&nbsp;
				승인여부
				<select name="p_ssuer" id="p_ssuer" style="width:70px;" >
					<option value="ALL">ALL</option>
					<option value="R">승인요청</option>
					<option value="C">승인완료</option>
				</select>
				&nbsp;
				발신부서
				<select name="p_sel_dept" id="p_sel_dept" style="width:130px;" onchange="javascript:DeptOnChange(this);" >
				</select>
				<input type="hidden" id="p_dept_code" name="p_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
				<input type="hidden" id="p_dept_name" name="p_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  /> &nbsp;
			</td>
			<td style="border-left:none;border-right:none;">
				<div style="background-color: #F4B5A9;width:145px;padding:3px">
					<font><b>승인자</b></font>
					<select name="p_confirm_user_id" id="p_confirm_user_id" style="width:108px" >
					</select>
				</div>
			</td>
			<td style="border-left:none;">
				<div class="button endbox">
					
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" class="btn_blue2" value="ADD" id="btnAdd"/>
						<input type="button" class="btn_blue2" value="DELETE" id="btnDel"/>
						<input type="button" value="승인요청" id="btnRequest"  class="btn_blue2" style="font-size:11px; line-height:2.2;" />
						<input type="button" value="SAVE" id="btnSave" class="btn_blue2" />
						<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
					</c:if>
				</div>
			</td>						
			</tr>
		</table>
		<table class="searchArea2">
			<col width="70%">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				REF No.
				<input type="text" id="p_ref_no" name="p_ref_no" style="width:180px;"/>
				&nbsp;
				Subject
				<input type="text" id="p_subject" name="p_subject" style="width:353px;"/>
				&nbsp;
			</td>
									
			<td style="border-left:none;">
				<div class="button endbox">
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="FORM" id="btnForm"  class="btn_red2"/>
						<input type="button" value="EXPORT" id="btnExport"  class="btn_red2"/>
					</c:if>
				</div>
			</td>		
			</tr>
		</table>
		
		<div class="series"> 
			<table class="searchArea">
				<tr>
					<td>
						<div id="SeriesCheckBox" class="searchDetail seriesChk"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="content">
			<table id = "jqGridList"></table>
			<div   id = "btnjqGridList"></div>
		</div>	
		
	</div> <!-- .mainDiv end -->
</form>
</body>
<script type="text/javascript">

var idRow;
var idCol;
var kRow;
var kCol;
var resultData = [];

var jqGridObj = $('#jqGridList');

var arr_project_no = "";

//도면번호 받아온 후
var commentReceiptProjectNoCallback = function(txt){
	arr_project_no = txt.split("|");
}


$(function() {
	// Project 자동완성 기능
	var form = fn_getFormData('#application_form');
	getAjaxTextPost(null, "commentReceiptProjectNoList.do", form, commentReceiptProjectNoCallback);
	
	getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y&p_chk_series="+$("input[name=p_project_no]").val(), null);
	
	// 달력 세팅
  	$( "#p_start_date, #p_end_date" ).datepicker({
    	dateFormat: 'yy-mm-dd',
    	prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년'				    	
  	});
});

var getDwgNos = function(){
	if($("input[name=p_project_no]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		$.ajaxSetup({async: false});
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=N&p_chk_series="+$("input[name=p_project_no]").val(), null);
		//getAjaxTextPost(null, "emsNewAdminAutoCompleteDwgNoList.do", form.serialize(), getdwgnoCallback);
		$.ajaxSetup({async: true});
	}
}

//기술 기획일 경우 부서 선택 기능
if(typeof($("#p_sel_dept").val()) !== 'undefined'){
	getAjaxHtml($("#p_sel_dept"),"commonSelectBoxDataList.do?sb_type=all&p_query=getManagerDeptList&p_dept_code="+$("input[name=p_dept_code]").val(), null, null);	
}

//발신문서 승인자 선택
if(typeof($("#p_confirm_user_id").val()) !== 'undefined'){
	getAjaxHtml($("#p_confirm_user_id"),"commonSelectBoxDataList.do?sb_type=N&p_query=getCommentConfirmUserList&p_dept_code="+$("input[name=p_dept_code]").val() + "&confirm_user="+$("input[name=confirm_user]").val(), null, null);	
}

var DeptOnChange = function(obj){
	$("input[name=p_dept_code]").val($(obj).find("option:selected").val());
	$("input[name=p_dept_name]").val($(obj).find("option:selected").text());
	
	getAjaxHtml($("#p_confirm_user_id"),"commonSelectBoxDataList.do?sb_type=N&p_query=getCommentConfirmUserList&p_dept_code="+$("input[name=p_dept_code]").val() + "&confirm_user="+$("input[name=confirm_user]").val(), null, null);
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'STATUS', name:'status_flag', index:'status_flag', width:50, align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'SEND ID', name:'send_id', index:'send_id', width:50, align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'Project', name:'project_no', index:'project_no', editable:true, title:false, width:25, align:'center', sortable:true, title:false,
		edittype : "text",
		editoptions: { 
			size:"10", maxlength:"10",
			dataInit: function(elem) {
				$(elem).css('text-transform', 'uppercase'); 
				setTimeout(function(){ 
					$(elem).autocomplete({
						source: arr_project_no,
						minLength: 1,
		    			matchContains: true, 
		    			autosearch: true,
		    			autoFocus: true,
		    			selectFirst: true
					});
				}, 10);
			},
			dataEvents: [{
				type: 'change',
				fn: function(e) {
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					// OC TYPE 세팅
					changeProject(rowId);
				}
			},{
				type : 'keydown', 
				fn : function( e) { 
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					var key = e.charCode || e.keyCode; 
					if( key == 13 || key == 9) {
						// OC TYPE 세팅
	            		changeProject(rowId);
	            	}
	            }
			},{
				type : 'blur', 
				fn : function( e) { 
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					// OC TYPE 세팅
            		changeProject(rowId);
	            }
			}]
		}
	});
	gridColModel.push({label:'REF No.', name:'ref_no', index:'ref_no', width:70, align:'center', sortable:true, title:false});
	gridColModel.push({label:'DWG No.', name:'dwg_no', index:'dwg_no', editable:false, width:50, align:'center', sortable:true});
	gridColModel.push({label:'DWG No. LIST', name:'dwg_no_list', index:'dwg_no_list', editable:false, width:50, align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'구분' ,name:'send_type', index:'send_type', editable:true, width:30, align:'center', sortable:true, title:false, 
		edittype : "select", 
		formatter : 'select',
		editoptions: { 
			dataEvents: [{
				type: 'change',
				fn: function(e) {
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					// OC TYPE 세팅
					changeSendType(rowId);
				}
			},{
				type : 'keydown', 
				fn : function(e) { 
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					var key = e.charCode || e.keyCode; 
					if( key == 13 || key == 9) {
	            		// OC TYPE 세팅
	            		changeSendType(rowId);
	            	}
	            }
			}]
		}
	});
	gridColModel.push({label:'O/C' ,name:'oc_type', index:'oc_type', editable:true, width:30, align:'center', sortable:true, title:false, 
		editoptions: {
			dataInit: function (el) { 
				$(el).css('text-transform', 'uppercase'); 
				
			}
		}
	});
	gridColModel.push({label:'Subject', name:'subject', index:'subject', editable:true, width:220, align:'left', sortable:true,
		editoptions:{
			dataInit:function(el){
				$(el).css("ime-mode", "disabled");
			}
		}
	});
	gridColModel.push({label:'View', name:'view_flag', index:'view_flag', editable:true, width:20, align:'center', sortable:true, title:false,
		edittype : "select",
		editrules : { required : true },
		editoptions:{value:"Y:Y;N:N"}	
	});
	gridColModel.push({label:'첨부', name:'doc_cnt', index:'doc_cnt', width:20, align:'center', sortable:true, title:false});
	gridColModel.push({label:'발신부서', name:'dwg_dept_name', index:'dwg_dept_name', width:70, align:'center', sortable:true, title:false, title:false});
	gridColModel.push({label:'발신부서code', name:'dwg_dept_code', index:'dwg_dept_code', width:80, align:'center', sortable:true, title:false, hidden:true, title:false});
	gridColModel.push({label:'발신자', name:'request_user_name', index:'request_user_name', editable:true, width:50, align:'center', sortable:true, title:false,
		edittype : "select",
		editrules : { required : true },
		cellattr: function (){return 'class="required_cell"';},
		editoptions: {
			dataUrl: function(){
				var item = jqGridObj.jqGrid( 'getRowData', idRow );
				var url = "commentSendGridReqUser.do?p_dept_code="+item.dwg_dept_code;
				return url;
			},
			buildSelect: function(data){
				if(typeof(data)=='string'){
					data = $.parseJSON(data);
				}
				var rtSlt = '<select id="gridReqUser" name="gridReqUser" >';
				for ( var idx = 0 ; idx < data.length ; idx ++) {
					if(data[idx].text == $("#h_user_name").val()){
						rtSlt +='<option value="'+data[idx].text+'" name="'+data[idx].value+'" selected>'+data[idx].text+'</option>';
					}else{
						rtSlt +='<option value="'+data[idx].text+'" name="'+data[idx].value+'" >'+data[idx].text+'</option>';
					}
				}
				rtSlt +='</select>';
				return rtSlt;
			},
			dataEvents: [{
				type: 'change',
				fn: function(e) {
					var row = $(e.target).closest('tr.jqgrow');
					var rowId = row.attr('id');
					changeReqUser(rowId);
				}
			}]
		}	
	});	
	gridColModel.push({label:'발신자code', name:'request_user_id', index:'request_user_id', width:80, align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'Date', name:'creation_date', index:'creation_date', width:40, align:'center', sortable:true, title:false});
	gridColModel.push({label:'승인자' ,name:'confirm_user_name' , index:'confirm_user_name' ,width:50 ,align:'center', sortable:true, title:false});
	gridColModel.push({label:'승인자code' ,name:'confirm_user_id' , index:'confirm_user_id' ,width:80 ,align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'승인일자' ,name:'confirm_date' , index:'confirm_date' ,width:40 ,align:'center', sortable:true, title:false});
	gridColModel.push({label:'복호화NAME' ,name:'dec_sub_att_name' , index:'dec_sub_att_name' ,width:60 ,align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'복호화' ,name:'dec_sub_att' , index:'dec_sub_att' ,width:60 ,align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'FORM NAME' ,name:'form_name' , index:'dec_sub_att' ,width:60 ,align:'center', sortable:true, hidden:true});
	gridColModel.push({label:'OPER', name:'oper', index:'oper', width:20, align:'center', sortable:true, title:false, hidden:true});
	gridColModel.push({label:'OPER TEMP', name:'oper_temp', index:'oper_temp', width:20, align:'center', sortable:true, title:false, hidden:true});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

//발신자를 변경하였을때 문자열 자르기를 이용하여 'request_user_id'(발신자code) 칼럼에 값 넣어줌
var changeReqUser = function(rowId){
	jqGridObj.saveCell(kRow, idCol);
	var item = jqGridObj.jqGrid( 'getRowData', rowId );
	var leftPos = item.request_user_name.indexOf('(')+1;
	var rightPos = item.request_user_name.indexOf(')');
	var emp_no = item.request_user_name.substring(leftPos, rightPos);
	jqGridObj.jqGrid( "setCell", rowId, 'request_user_id', emp_no );
}

//Project를 변경하였을때 도면번호, OC TYPE 변경
var changeProject = function(rowId){
	jqGridObj.saveCell(kRow, idCol );
	var item = jqGridObj.jqGrid( 'getRowData', rowId );
	
	if(item.send_type == "O"){
		$.ajax({
			url : "commentSendGridOcType.do?p_project_no="+item.project_no,
			async : true, //동기: false, 비동기: ture
			cache : false, 
			dataType : "json",
			success : function(data){
				jqGridObj.jqGrid( "setCell", rowId, 'oc_type', data[0].value );
				jqGridObj.saveCell(kRow, idCol );
			}
		});
	}
}

//SEND_TYPE을 변경하였을때 OC TYPE 변경
var changeSendType = function(rowId){
	jqGridObj.saveCell(kRow, idCol);
	var item = jqGridObj.jqGrid( 'getRowData', rowId );
	
	if(item.send_type == "O"){
		jqGridObj.jqGrid( "setCell", rowId, 'oc_type', "&nbsp;" );
		//해당 CELL 비활성 모드
		changeEditableByContainRow(jqGridObj, kRow-1, 'oc_type','',true);
		if(item.project_no != ""){
			$.ajax({
				url : "commentSendGridOcType.do?p_project_no="+item.project_no,
				async : false, //동기: false, 비동기: ture
				cache : false, 
				dataType : "json",
				success : function(data){
					jqGridObj.jqGrid( "setCell", rowId, 'oc_type', data[0].value );
					jqGridObj.saveCell(kRow, idCol );
				}
			});
		}
	}
	else if(item.send_type == "C"){
		jqGridObj.jqGrid( "setCell", rowId, 'oc_type', "&nbsp;" );
		//해당 CELL 활성 모드
		changeEditableByContainRow(jqGridObj, kRow-1, 'oc_type','',false);
	}
	jqGridObj.saveCell(kRow, idCol);
}

$(document).ready(function(){
	
	jqGridObj.jqGrid({ 
		datatype: 'json', 
		mtype: 'POST', 
		url:'',
		postData : fn_getFormData('#application_form'),
		colModel:gridColModel,
		gridview: true,
		multiselect: true,
		toolbar: [false, "bottom"],
		viewrecords: true,
		autowidth: true,
		cellEdit : true,
		cellsubmit : 'clientArray', // grid edit mode 2
		scrollOffset : 17,
		shrinkToFit:true,
		pager: $('#btnjqGridList'),
		rowList:[100,500,1000],
		recordtext: '내용 {0} - {1}, 전체 {2}',
		emptyrecords:'조회 내역 없음',
		rowNum:100, 
		beforeEditCell : function(rowid, cellname, value, iRow, iCol) {
			idRow= rowid;
			idCol= iCol;
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
			var pageIndex         = parseInt($(".ui-pg-input").val());
			var currentPageIndex  = parseInt(jqGridObj.getGridParam("page"));// 페이지 인덱스
			var lastPageX         = parseInt(jqGridObj.getGridParam("lastpage"));  
			var pages = 1;
			var rowNum 			  = 100;	   			
			if (pgButton == "user") {
				if (pageIndex > lastPageX) {
					pages = lastPageX
				} else pages = pageIndex;
			} else if(pgButton == 'next_btnjqGridAdminList'){
				pages = currentPageIndex+1;
			} else if(pgButton == 'last_btnjqGridAdminList'){
				pages = lastPageX;
			} else if(pgButton == 'prev_btnjqGridAdminList'){
				pages = currentPageIndex-1;
			} else if(pgButton == 'first_btnjqGridAdminList'){
				pages = 1;
			} else if(pgButton == 'records') {
				rowNum = $('.ui-pg-selbox option:selected').val();                
			}
			$(this).jqGrid("clearGridData");
			$(this).setGridParam({datatype: 'json',page:''+pages, rowNum:''+rowNum}).triggerHandler("reloadGrid"); 		
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
			var rows = $(this).getDataIDs();
			for ( var i = 0; i < rows.length; i++ ) {
				var item = $(this).jqGrid( 'getRowData', rows[i] );
				if(item.status_flag != 'N'){
					$(this).setRowData(rows[i], false, {background: '#D9D9D9'});
					$(this).jqGrid( 'setCell', rows[i], 'project_no', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'send_type', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'oc_type', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'subject', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'view_flag', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'request_user_name', '', 'not-editable-cell' );
				} else if(item.oper != 'I') {
					$(this).jqGrid( 'setCell', rows[i], 'project_no', '', {background : '#FFFFCC'} );
					$(this).jqGrid( 'setCell', rows[i], 'oc_type', '', {background : '#FFFFCC'} );
					$(this).jqGrid( 'setCell', rows[i], 'subject', '', {background : '#FFFFCC'} );
					$(this).jqGrid( 'setCell', rows[i], 'project_no', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'send_type', '', 'not-editable-cell' );
					$(this).jqGrid( 'setCell', rows[i], 'oc_type', '', 'not-editable-cell' );
				}
				$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '','', {title : item.dwg_no_list} );
			}
		},	
		onCellSelect : function( rowid, iCol, cellcontent, e ) {
			var cm = jqGridObj.jqGrid( "getGridParam", "colModel" );
			var colName = cm[iCol];
			var item = $(this).jqGrid( 'getRowData', rowid );

			//파일 첨부 팝업창
			if ( colName['index'] == "doc_cnt" ) {
				var myDeptYn = $("#h_my_dept_yn").val();
				var viewFlag = item.view_flag;
				// 자신의 부서 항목이 아닐때
				if( myDeptYn == "N" && viewFlag =="N" ){
					alert("VIEW FLAG가 N인 항목은 첨부문서를 볼 수 없습니다.");
					return;
				}
				// 요청상태 이후면 수정할수 없도록 N 플레그를 던짐
				if(item.status_flag != 'N'){
					myDeptYn = "N";
				}
				var sURL = "popUpCommentSendAttach.do?row_selected="+rowid+"&send_id="+item.send_id+"&view_flag="+myDeptYn;
				var popOptions = "dialogWidth:800px; dialogHeight: 380px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
			}
			
			//SUB 도면번호 팝업창
			if ( colName['index']=="dwg_no" && item.oper!="D" ) {
				if(item.ref_no == ""){
					alert("REF No. 가 먼저 채번되어야 입력 가능합니다.");
					return;
				}
				var dwgEdit = "Y";
				if(item.status_flag!='N' || $("#h_dept_code").val()!=item.dwg_dept_code) dwgEdit = "N";
				var sURL = "popUpCommentSendDwgNo.do?row_selected="+rowid
						+"&p_project_no="+item.project_no
						+"&p_send_id="+item.send_id
						+"&p_user_id="+$("#h_user_id").val()
						+"&p_dept_code="+$("#h_dept_code").val()
						+"&p_send_type="+item.send_type
						+"&p_dwg_edit="+dwgEdit;
				var popOptions = "dialogWidth:600px; dialogHeight: 620px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
			}
			jqGridObj.saveCell( kRow, idCol );
		},
		afterInsertRow : function(rowid, rowdata, rowelem){
			$(this).jqGrid( 'setCell', rowid, 'project_no', '', {background : '#FFFFCC'} );
			$(this).jqGrid( 'setCell', rowid, 'oc_type', '', {background : '#FFFFCC'} );
			$(this).jqGrid( 'setCell', rowid, 'subject', '', {background : '#FFFFCC'} );
			$(this).jqGrid( 'setCell', rowid, 'dwg_no', '', {background : '#D9D9D9'} );
		},
		afterSaveCell : chmResultEditEnd
	}); //end of jqGrid

	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#jqGridList" ), 36 );
	
	//그리드 내 콤보박스 바인딩
	$.post( "infoComboCodeMaster.do?sd_type=COMMENT_ISSUER_TYPE", "", function( data ) {
		$( '#jqGridList' ).setObject( {
			value : 'value',
			text : 'text',
			name : 'send_type',
			data : data
		} );
	}, "json" );
});

//필수 항목 Validation
var uniqeValidation = function(){
	var rnt = true;
	$(".required").each(function(){
		if($(this).val() == ""){
			$(this).focus();
			alert($(this).attr("alt")+ "가 누락되었습니다.");
			rnt = false;
			return false;
		}
	});
	return rnt;
}

//Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
$("#btnSearch").click(function(){
	//모두 대문자로 변환
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});
	
	if(uniqeValidation()){
		fn_search();
	}
});

//Add 버튼 클릭 엑셀로 업로드 한경우 row 추가 
$("#btnAdd").click(function(){
	
	jqGridObj.saveCell(kRow, idCol );
	var item = {};
	var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
	var ids = jqGridObj.jqGrid('getDataIDs');
	
	// 1순위 - 하나만 체크인 상태에서 ADD할 경우, 체크된 ROW복사
	if(row_id.length == 1){
		var rowData = jqGridObj.getRowData(row_id[0]);
		item.project_no = rowData['project_no'];
		item.dwg_no = rowData['dwg_no'];
		item.send_type = rowData['send_type'];
		item.oc_type = rowData['oc_type'];
		item.subject = rowData['subject'];
		item.view_flag = rowData['view_flag'];
	}
	// 2순위 - 체크가 없는 상태에서 ADD할 경우, 바로 위의 ROW를 복사
// 	else if(ids.length > 0){
// 		var cl = ids[ids.length-1];
//         var rowData = jqGridObj.getRowData(cl);
//         item.project_no = rowData['project_no'];
// 		item.dwg_no = rowData['dwg_no'];
// 		item.send_type = rowData['send_type'];
// 		item.oc_type = rowData['oc_type'];
// 		item.subject = rowData['subject'];
// 		item.view_flag = rowData['view_flag'];
// 	}
	// 3순위 - 최초로 ADD할 경우
	else{
		item.project_no = ""
		item.send_type = "O";
		item.view_flag = "Y";
		item.dwg_no = "";
	}
	item.dwg_dept_code = $("#h_dept_code").val();
	item.dwg_dept_name = $("#h_dept_name").val();
	item.request_user_id = $("#h_user_id").val();
	item.request_user_name = $("#h_user_name").val() + "(" + $("#h_user_id").val() + ")";
	item.doc_cnt = "0건";
	item.oper = 'I';
	item.status_flag = 'N';

	jqGridObj.resetSelection();
	jqGridObj.jqGrid( 'addRowData', $.jgrid.randId(), item, 'last' );
	
	// 생성된 ROW가 OWNER 이면 비활성
	if(item.send_type == "O"){
		//해당 CELL 비활성 모드
		changeEditableByContainRow(jqGridObj, ids.length, 'oc_type','',true);
	}
	// 편집모드가 되면 승인요청 비활성
	fn_buttonDisabled2([ "#btnRequest" ]);
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
		if(item.status_flag != 'N'){
			
		}else if(item.oper == 'I'){		
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
	
	//편집모드가 되면 승인요청 비활성
	fn_buttonDisabled2([ "#btnRequest" ]);
});


//afterSaveCell oper 값 지정
function chmResultEditEnd( irow, cellName, val, iRow, iCol ) {

	var item = jqGridObj.jqGrid( 'getRowData', irow );
	if (item.oper == 'D'){
		item.oper_temp = 'U';
	}else if (item.oper != 'I'){
		item.oper = 'U';
	}

	if(val == null) val = "";
	
	jqGridObj.jqGrid( "setRowData", irow, item );
	//입력 후 대문자로 변환
	if(cellName == "project_no" || cellName == "oc_type"){
		//alert(cellName);
		jqGridObj.setCell(irow, cellName, val.toUpperCase(), '');
	}
	
	//편집모드가 되면 승인요청 비활성
	fn_buttonDisabled2([ "#btnRequest" ]);
}

function fn_search() {
	
	$("input[type=text]").each(function(){
		$(this).val($(this).val().toUpperCase());
	});

	//시리즈 배열 받음
	var ar_series = new Array();
	for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
		ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
	}
	
	$("input[name=p_check_series]").val(ar_series);

	//검색 시 스크롤 깨짐현상 해결
	jqGridObj.closest(".ui-jqgrid-bdiv").scrollLeft(0); 
	
	var sUrl = "commentSendList.do?p_chk_series="+ar_series;
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		//rowNum : pageCnt,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
	
	// 편집모드가 끝나면 승인요청 활성
	fn_buttonEnable2([ "#btnRequest" ]);
	
	// 타부서 조회 시 버튼 비활성화 
	if($("#h_dept_code").val() == $("#p_dept_code").val() && $("#p_dept_code").val() != ""){
		$("#h_my_dept_yn").val("Y");
		fn_buttonEnable2([ "#btnAdd" ]);
		fn_buttonEnable2([ "#btnDel" ]);
		fn_buttonEnable2([ "#btnRequest" ]);
		fn_buttonEnable2([ "#btnSave" ]);
	}else{
		$("#h_my_dept_yn").val("N");
		fn_buttonDisabled2([ "#btnAdd" ]);
		fn_buttonDisabled2([ "#btnDel" ]);
		fn_buttonDisabled2([ "#btnRequest" ]);
		fn_buttonDisabled2([ "#btnSave" ]);
	}
}

//저장버튼
$( "#btnSave" ).click( function() {
	fn_save();
} );

//저장
function fn_save() {
	jqGridObj.saveCell( kRow, idCol );
	var ids = jqGridObj.jqGrid( 'getDataIDs' );
	
	//변경 사항 Validation
	if( !fn_checkValidate() ) {
		return;
	}
	
	if( confirm( '변경된 데이터를 저장하시겠습니까?' ) ) {
		var chmResultRows = [];
		
		getChangedChmResultData(function( data ) {
			chmResultRows = data;
			var dataList = { chmResultList : JSON.stringify( chmResultRows ) };
			var url = 'commentSendSave.do';
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
			
			//필수항목 체크 : project_no
			var val1 = jqGridObj.jqGrid( 'getCell', ids[i], 'project_no' );
			if ( $.jgrid.isEmpty( val1 ) ) {
				alert( "Project를 입력하십시오." );
				return;
			}
			//필수항목 체크 : dwg_no
// 			var val2 = jqGridObj.jqGrid( 'getCell', ids[i], 'dwg_no' );
// 			if ( $.jgrid.isEmpty( val2 ) ) {
// 				alert( "DWG No.를 입력하십시오." );
// 				return;
// 			}
			//필수항목 체크 : send_type
			var val3 = jqGridObj.jqGrid( 'getCell', ids[i], 'send_type' );
			if ( $.jgrid.isEmpty( val3 ) ) {
				alert( "구분을 입력하십시오." );
				return;
			}
			//필수항목 체크 : oc_type
			var val4 = jqGridObj.jqGrid( 'getCell', ids[i], 'oc_type' );
			if ( $.jgrid.isEmpty( val4 ) ) {
				alert( "O/C를 입력하십시오." );
				return;
			}
			//필수항목 체크 : subject
			var val5 = jqGridObj.jqGrid( 'getCell', ids[i], 'subject' );
			if ( $.jgrid.isEmpty( val5 ) ) {
				alert( "Subject 입력하십시오." );
				return;
			}
			//필수항목 체크 : view_flag
			var val6 = jqGridObj.jqGrid( 'getCell', ids[i], 'view_flag' );
			if ( $.jgrid.isEmpty( val6 ) ) {
				alert( "View 입력하십시오." );
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

//그리드 변경된 내용을 가져온다.
function getChangedChmResultData( callback ) {
	var changedData = $.grep( jqGridObj.jqGrid( 'getRowData' ), function( obj ) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	} );
	callback.apply(this, [ changedData.concat(resultData) ]);
};

//승인요청 버튼
$( "#btnRequest" ).click( function() {
	var rtn = true;

	//행을 읽어서 키를 뽑아낸다.
	var send_id_array = new Array();
	var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
	
	if(row_id == ""){
		alert("행을 선택하십시오.");
		return false;
	}

	for(var i=0; i<row_id.length; i++){
		var item = jqGridObj.jqGrid( 'getRowData', row_id[i]);
		
		if(item.confirm_user_name != ""){
			alert("승인요청 또는 승인완료 항목이 포함되어 있습니다.");								
			rtn = false;
			return false;
		}
		
		if( item.doc_cnt == "0건" && item.dec_sub_att == "" ){
			alert("첨부파일이 없는 항목이 있습니다.");								
			rtn = false;
			return false;
		}
		
		send_id_array.push(item.send_id);
	}
	
	if(!rtn){
		return false;
	}
	
	var form = $('#application_form');
	$(".loadingBoxArea").show();
	$.post("commentSendRequest.do?send_id_array="+send_id_array, form.serialize(),function(json)
	{	
		alert(json.resultMsg);
		$(".loadingBoxArea").hide();
		fn_search();
	},"json");
	
} );

//Excel 버튼 클릭 시 
$("#btnExport").click(function(){
	
	var p_ischeck = 'N';
	if(($("#SerieschkAll").is(":checked"))){
		p_ischeck = 'Y';
	}
	
	//시리즈 배열 받음
	var ar_series = new Array();
	for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
		ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
	}
	
	if($("input[name=p_series]:checked").size() < 1) {
		ar_series[0] = $("input[name=p_project_no]").val();
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
	}
	
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
	form.attr("action", "commentSendExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName+"&p_chk_series="+ar_series);
	form.attr("target", "_self");	
	form.attr("method", "post");	
	form.submit();
});

//Form 클릭 다운로드	
$("#btnForm").click(function(){
	var ids = jqGridObj.jqGrid('getDataIDs');
	//리스트가 없는 상태에서 FORM 버튼 클릭 시
	if(ids.length == 0){
		if($("#p_project_no").val().length != 5){
			alert("Project 5자리를 입력하세요.");
			return;
		}
// 		if($("#p_dwg_no").val() == ""){
// 			alert("DWG No 를 입력하세요.");
// 			return;
// 		}
	 	$.ajax({
			url : "commentSendGetFormName.do?p_project_no="+$("#p_project_no").val()+"&p_dwg_no="+$("#p_dwg_no").val()+"&p_dept_code="+$("#p_dept_code").val(),
			async : false, //동기: false, 비동기: ture
			cache : false, 
			dataType : "json",
			success : function(data){
				var refNo = data.formName;
			   	var fileName = data.formName;
			   	var attURL = "commentSendFormDownload.do";
			    attURL += "?fileName=" + fileName;
			    attURL += "&refNo=" + refNo;
			    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
			    
			    window.open(attURL,"",sProperties);
			   	
			   	return;
			}
		});
	}
	//리스트가 있는 상태에서 FORM 버튼 클릭 시
	else{
		var row_id = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		var item = jqGridObj.jqGrid( 'getRowData', row_id[0]);
		
		if(row_id.length != 1){
			alert("행을 한개 선택하여야합니다.");
			return;
		}
		
		var refNo = item.ref_no;
	   	var fileName = item.form_name;
	   	var attURL = "commentSendFormDownload.do";
	    attURL += "?fileName=" + fileName;
	    attURL += "&refNo=" + refNo;
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	    
	    window.open(attURL,"",sProperties);
	   	
	   	return;
	}
});

</script>
</html>