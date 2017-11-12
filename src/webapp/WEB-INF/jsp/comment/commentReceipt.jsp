<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>수신문서</title>
<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
<style>
	.totalEaArea {
		position: relative;
		margin-left: 10px;
		margin-right: 0px;
		padding: 4px 4px 6px 4px;
		font-weight: bold;
		border: 1px solid #ccc;
		background-color: #D7E4BC;
		vertical-align: middle;
	}
	
	.onMs {
		background-color: #FFFA94;
	}
	
	.sscType {
		color: #324877;
		font-weight: bold;
	}
</style>
</head>

<body>
<form id="application_form" name="application_form" >
	<input type="hidden" name="user_name" id="user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="user_id" id="user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="p_auth_code" id="p_auth_code"  value="${loginUser.author_code}" />
	
	<input type="hidden" name="upper_dwg_dept_code" id="upper_dwg_dept_code"  value="${loginUser.upper_dwg_dept_code}" />
	<input type="hidden" name="dwg_dept_code" id="dwg_dept_code"  value="${loginUser.dwg_dept_code}" />
	<input type="hidden" name="dwgabbr_eng" id="dwgabbr_eng"  value="${loginUser.dwgabbr_eng}" />
	
	<input type="hidden" name="p_check_series" value="${p_chk_series}" />
	<input type="hidden" id="p_arrDistinct" name="p_arrDistinct"/>
	
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			수신문서
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="70%">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				Project
				<input type="text" class="required" id="p_project_no" value="" maxlength="10" name="p_project_no" style="width:50px; ime-mode:disabled;" onkeyup="javascript:getDwgNos();" onchange="javascript:this.value=this.value.toUpperCase();" alt="Project"/>
				&nbsp;
				DWG No
				<input type="text" id="p_dwg_no" name="p_dwg_no" style="width:75px; ime-mode:disabled;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				&nbsp;
				Issuer
				<select name="p_issuer" id="p_issuer" style="width:80px;" >
					<option value="ALL">ALL</option>
					<option value="O">Owner</option>
					<option value="C">Class</option>
				</select>
				&nbsp;
				Subject
				<input type="text" id="p_subject" name="p_subject" style="width:150px; ime-mode:disabled; text-transform: uppercase;"  onchange="javascript:this.value=this.value.toUpperCase();"/>
				&nbsp;
				담당팀
				<select name="p_sel_receipt_team" id="p_sel_receipt_team" style="width:100px;" onchange="javascript:TeamOnChange(this);" >
				</select>
				<input type="hidden" name="p_receipt_team_code" id="p_receipt_team_code" value="<c:out value="${loginUser.upper_dwg_dept_code}" />"  />
				<input type="hidden" name="p_receipt_team_name" id="p_receipt_team_name" value="<c:out value="${loginUser.upper_dwg_dept_name}" />"  />
				&nbsp;
				담당파트
				<select name="p_sel_receipt_dept" id="p_sel_receipt_dept" style="width:100px;" onchange="javascript:DeptOnChange(this);" >
				</select>
				<input type="hidden" name="p_receipt_dept_code" id="p_receipt_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
				<input type="hidden" name="p_receipt_dept_name" id="p_receipt_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
			</td>
			<td style="border-left:none;">
				<div class="button endbox">
					<input type="button" class="btn_blue2" value="수신현황" id="btnReceiptChart"/>
					<c:if test="${loginUser.admin_yn == 'Y'}">
						<input type="button" class="btn_blue2" value="DELETE" id="btnDel"/>
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="ADD" id="btnAdd"  class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="COMMENT" id="btnComment" class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute1 == 'Y'}">
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
				수신 No
				<input type="text" id="p_receipt_no" name="p_receipt_no" maxlength="12" style="width:80px; ime-mode:disabled;" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
				&nbsp;
				등록일자
				<input type="text" name="p_issue_date_from" id="p_issue_date_from" class="commonInput" style="width:70px;" value=""/>
				~
				<input type="text" name="p_issue_date_to" id="p_issue_date_to" class="commonInput" style="width:70px;" value=""/>
				&nbsp;
				접수여부 
	        	<select name="p_receipt_status" id="p_receipt_status" style="width:80px;" >
					<option value="ALL">ALL</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				&nbsp;
				Reply 
	        	<select name="p_reply" id="p_reply" style="width:80px;" >
					<option value="ALL">ALL</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
				&nbsp;
				경과일
				<select name="p_delay" id="p_delay" style="width:80px;" >
					<option value="ALL">ALL</option>
					<option value="5">5</option>
					<option value="4">4</option>
					<option value="3">3</option>
					<option value="2">2</option>
					<option value="1">1</option>
				</select>
			</td>
									
			<td style="border-left:none;">
				<div class="button endbox">
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="EXPORT" id="btnExcel" class="btn_red2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="부서지정" id="btnTeam" class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="담당자" id="btnReceiptUserId" class="btn_blue2" />
					</c:if>
					<c:if test="${userRole.attribute4 == 'Y'}">
						<input type="button" value="DWG" id="btnDwg" class="btn_blue2" />
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

var menuId = '';

var jqGridObj = $('#jqGridList');

if(typeof($("#p_sel_receipt_team").val()) !== 'undefined'){
	getAjaxHtml($("#p_sel_receipt_team"), "commentReceiptTeamSelectBoxDataList.do?sb_type=all&p_dept_code="+$("input[name=upper_dwg_dept_code]").val(), null, null);
}

if(typeof($("#p_sel_receipt_dept").val()) !== 'undefined'){
	getAjaxHtml($("#p_sel_receipt_dept"), "commentReceiptDeptSelectBoxDataList.do?sb_type=all&p_upper_dept_code="+$("input[name=upper_dwg_dept_code]").val()+"&p_dept_code="+$("input[name=dwg_dept_code]").val(), null, null);
}

//달력 셋팅
$(function() {
	
	getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y&p_chk_series="+$("input[name=p_project_no]").val(), null);
	
	var dates = $( "#p_issue_date_from, #p_issue_date_to" ).datepicker({
    	dateFormat: 'yy-mm-dd',
    	prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년',
    	changeYear: true,
		changeMonth : true,
		/* onSelect : function( selectedDate ) {
			var option = this.id == "created_date_start" ? "minDate" : "maxDate", 
					instance = $( this ).data( "datepicker" ), 
					date = $.datepicker.parseDate( instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
			dates.not(this).datepicker( "option", option, date );
		} */
  	});
  	
  	fn_twoMonthDate("p_issue_date_from", "p_issue_date_to");
});

var getDwgNos = function(){
	if($("input[name=p_project_no]").val() != ""){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		form = $('#application_form');
		$.ajaxSetup({async: false});
		getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd=NO&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck=Y&p_chk_series="+$("input[name=p_project_no]").val(), null);
		$.ajaxSetup({async: true});
	}
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'수신 ID' ,name:'receipt_id' , index:'receipt_id' ,width:80 ,align:'center', sortable:true, title:false, hidden: true});
	gridColModel.push({label:'수신 DETAIL ID' ,name:'receipt_detail_id' , index:'receipt_detail_id' ,width:80 ,align:'center', sortable:false, title:false, hidden: true});
	gridColModel.push({label:'Project' ,name:'project_no' , index:'project_no' ,width:35 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'수신 No' ,name:'receipt_no' , index:'receipt_no' ,width:60 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'문서' ,name:'doc_type' , index:'doc_type' ,width:20 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'Issuer' ,name:'issuer' , index:'issuer' ,width:40 ,align:'center', sortable:true, title:false, formatter: issuerFormatter});
	gridColModel.push({label:'Subject' ,name:'subject' , index:'subject' ,width:300 ,align:'left', title:true, sortable:true});
	gridColModel.push({label:'Issue Date' ,name:'issue_date' , index:'issue_date' ,width:40 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'Com No.' ,name:'com_no' , index:'com_no' ,width:100 ,align:'center', sortable:true, title:true, editable:true});
	gridColModel.push({label:'담당팀ID' ,name:'receipt_team_code' , index:'receipt_team_code' ,width:80 ,align:'center', sortable:true, title:false, hidden:true});
	gridColModel.push({label:'담당팀' ,name:'receipt_team_name' , index:'receipt_team_name' ,width:80 ,align:'center', sortable:true, title:false});
	gridColModel.push({label:'담당파트ID' ,name:'receipt_dept_code' , index:'receipt_dept_code' ,width:80 ,align:'center', sortable:true, title:false, hidden:true});
	gridColModel.push({label:'담당파트' ,name:'receipt_dept_name' , index:'receipt_dept_name' ,width:80 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'담당자ID' ,name:'receipt_user_id' , index:'receipt_user_id' ,width:50 ,align:'center', sortable:true, title:false, hidden:true});
	gridColModel.push({label:'담당자' ,name:'receipt_user_name' , index:'receipt_user_name' ,width:40 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'접수일자' ,name:'receipt_confirm_date' , index:'receipt_confirm_date' ,width:50 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'DWG NO.' ,name:'dwg_no' , index:'dwg_no' ,width:50 ,align:'center', sortable:true});
	gridColModel.push({label:'Reply' ,name:'reply_result' , index:'reply_result' ,width:30 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'경과일' ,name:'delay_result' , index:'delay_result' ,width:30 ,align:'center', title:false, sortable:true});
	gridColModel.push({label:'첨부', name:'document_id', index:'document_id', width:20, align:'center', sortable:false, title:false, formatter: fileFormatter});
	gridColModel.push({label:'OPER', name:'oper', width:50, align:'center', sortable:true, title:false, hidden: true} );
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).keydown(function (e) { 
	if (e.keyCode == 27) { 
		e.preventDefault();
	} // esc 막기
	if(e.target.nodeName != "INPUT"){
		if(e.keyCode == 8) {
			return false;
		}
	}
});

$(document).ready(function(){
	
	jqGridObj.jqGrid({ 
	    datatype: 'json', 
	    mtype: 'POST', 
	    url:'',
	    postData : fn_getFormData('#application_form'),
	    colModel:gridColModel,
	    gridview: true,
	    toolbar: [false, "bottom"],
	    viewrecords: true,
	    autowidth: true,
	    scrollOffset : 17,
	    shrinkToFit:true,
	    multiselect: true,
	    pager: $('#btnjqGridList'),
	    rowList:[100,500,1000],
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
	    	
	    		var pageIndex         = parseInt($(".ui-pg-input").val());
	   			var currentPageIndex  = parseInt(jqGridObj.getGridParam("page"));// 페이지 인덱스
	   			var lastPageX         = parseInt(jqGridObj.getGridParam("lastpage"));  
	   			var pages = 1;
	   			var rowNum 			  = 100;	   			
	   			if (pgButton == "user") {
	   				if (pageIndex > lastPageX) {
	   			    	pages = lastPageX
	   			    } else pages = pageIndex;
	   			}
	   			else if(pgButton == 'next_btnjqGridList'){
	   				pages = currentPageIndex+1;
	   			} 
	   			else if(pgButton == 'last_btnjqGridList'){
	   				pages = lastPageX;
	   			}
	   			else if(pgButton == 'prev_btnjqGridList'){
	   				pages = currentPageIndex-1;
	   			}
	   			else if(pgButton == 'first_btnjqGridList'){
	   				pages = 1;
	   			}
	 	   		else if(pgButton == 'records') {
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
				var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
				
				var first = item.reply_result.split("/")[0];
				var last = item.reply_result.split("/")[1];
				
				if(last != '0') {
					if(first != last) {
						//$(this).setRowData(rows[i], false, {background: '#99bbff'});
						jqGridObj.setCell(rows[i], 'reply_result', '', { background: '#FCD5B4' });
					}
				} else {
					//$(this).setRowData(rows[i], false, {background: '#99bbff'});
					jqGridObj.setCell(rows[i], 'reply_result', '', { background: '#FCD5B4' });
				}
				
				
			}
		 }		           
	}); //end of jqGrid

	// jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#jqGridList" ), 36 );
	
	//del 버튼  클릭
	$("#btnDel").click(function(){
		jqGridObj.saveCell(kRow, idCol );
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		var ids = jqGridObj.getDataIDs();
			
		for(var i=selarrrow.length-1; i>=0; i--) {
			
			var item = jqGridObj.jqGrid("getRowData", selarrrow[i]);
			
			//삭제 하면 안되는 조건
			if(item.receipt_dept_name == '') {
				jqGridObj.setCell (selarrrow[i], 'oper','D', '');
				jqGridObj.setRowData(selarrrow[i], false, {background: '#FFFFA2'});
			}
			
		}
		
		if(confirm('담당파트 미지정만 삭제가능합니다.\n계속진행하시겠습니까?')){
			
			var changeResultRows =  getChangedGridInfo("#jqGridList");
			
			var url			= "commentReceiptDeleteAction.do";
			var dataList    = {chmResultList:JSON.stringify(changeResultRows)};
			var formData = fn_getFormData('#application_form');
			var parameters = $.extend({},dataList,formData);
			
			lodingBox = new ajaxLoader($('#mainDiv'), {classOveride: 'blue-loader', bgColor: '#000', opacity: '0.3'});
			
			$.post(url, parameters, function(data)
			{	
				var msg = '';
				var result = '';

				for ( var key in data) {
					if (key == 'resultMsg') {
						msg = data[key];
					}
					if (key == 'result') {
						result = data[key];
					}
				}
				
				alert(msg);
				
			},"json").error(function() {
				alert('시스템 오류입니다.\n전산담당자에게 문의해주세요.');
			}).always(function() {
				lodingBox.remove();
				fn_search();
			});
		}
		
	});
	
	// Search 버튼 클릭 시 Ajax로 리스트를 받아 넣는다.
	$("#btnSearch").click(function(){
		//모두 대문자로 변환
		$("input[type=text]").each(function(){
			$(this).val($(this).val().toUpperCase());
		});
		
		//if(uniqeValidation()){
		fn_search();
		//}
	});
	
	// Add 버튼 클릭 시 
	$("#btnAdd").click(function(){

		form = $('#application_form');
		
		form.attr("action", "commentReceiptAdd.do");
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();

	});
	
	// Comment 버튼 클릭 시
	$("#btnComment").click(function() {
		
		getMenuId("comment.do", callback_MenuId);
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(selarrrow.length < 1){
			alert("행을 선택하십시오.");
			return false;
		} else if(selarrrow.length > 1) {
			alert("2EA 이상 선택 되었습니다. 1EA만 선택 바랍니다.");
			return false;
		}
		
		var projectNo = '';
		var dwgNo = '';
		
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
			
			projectNo = item.project_no;
			dwgNo = item.dwg_no;
			issuer = item.issuer;
			
			if(issuer == 'OWNER') {
				issuer = "O";
			} else {
				issuer = "C";
			}
		}
		
		var rs = window.open("comment.do?p_project_no=" + projectNo + "&p_dwg_no=" + dwgNo + "&p_issuer=" + issuer + "&menu_id="+menuId, "", "height=850,width=1570,top=200,left=200,location=yes,scrollbars=yes, resizable=yes");
		
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
		}
		
	});
	
	// Excel 버튼 클릭 시 
	$("#btnExcel").click(function(){
		
		//시리즈 배열 받음
		var ar_series = new Array();
		for(var i=0; i < $("input[name=p_series]:checked").size(); i++ ){
			ar_series[i] = $("input[name=p_series]:checked").eq(i).val();
		}
		$("input[name=p_check_series]").val(ar_series);
		
		/* if($("input[name=p_series]:checked").size() < 1) {
			ar_series[0] = $("input[name=p_project_no]").val();
			getAjaxHtml($("#SeriesCheckBox"),"sscCommonSeriesCheckBox.do?p_item_type_cd="+$("input[name=p_item_type_cd]").val()+"&p_project_no="+$("input[name=p_project_no]").val()+"&p_ischeck="+p_ischeck+"&p_chk_series="+ar_series, null);
		} */
		
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
		
		//그리드의 label과 name을 받는다.
		//용도 : 엑셀 출력 시 헤더 및 데이터 맵퍼 자동 설정
				
		form = $('#application_form');
		//엑셀 출력시 Col 헤더와 데이터 네임을 넘겨준다.				
		form.attr("action", "commentReceiptExcelExport.do?p_col_name="+colName+"&p_data_name="+dataName+"&p_chk_series="+ar_series);
		form.attr("target", "_self");	
		form.attr("method", "post");	
		form.submit();
	});
	
	// DWG 버튼 클릭
	$("#btnDwg").click(function(){
		
		var rtn = true;
		
		var rows = jqGridObj.getDataIDs();
		for ( var i = 0; i < rows.length; i++ ) {
			var item = jqGridObj.jqGrid( 'getRowData', rows[i] );
		}
		
		if(!rtn) {
			return false;
		}
		
		var p_arr = new Array();
		var p_arrDistinct = new Array();
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(selarrrow.length < 1){
			alert("행을 선택하십시오.");
			return false;
		} else if(selarrrow.length > 1) {
			alert("2EA 이상 선택 되었습니다. 1EA만 선택 바랍니다.");
			return false;
		}
		
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
			
			if( item.receipt_team_code != "${loginUser.upper_dwg_dept_code}" ) {
				alert("담당팀 수신문서가 아닙니다.");
				rtn = false;
				return false;
			} 
			
			if( item.receipt_dept_code != "${loginUser.dwg_dept_code}" ) {
				alert("담당파트가 일치하지 않습니다.");
				rtn = false;
				return false;
			}
			
			if(item.receipt_team_name == '') {
				alert("담당팀을 지정해야 됩니다.");
				return false;
			}
			
			if(item.receipt_dept_name == "") {
				alert("담당파트를 지정해야 됩니다.");
				return false;
			}
			if(item.receipt_user_name == "") {
				alert("담당자를 지정해야 됩니다.");
				return false;
			}
			
			
			if(item.dwg_no == "") {
				item.dwg_no = "NULL";
			}
			
			p_arr.push(item.receipt_detail_id + "@" + item.receipt_id + "@" + item.receipt_no + "@" + item.project_no + "@" + item.doc_type 
					+ "@" + item.issuer + "@" + escape(encodeURIComponent(item.subject)) + "@" + item.issue_date + "@" + escape(encodeURIComponent(item.com_no)) 
					+ "@" + item.receipt_team_code+ "@" + escape(encodeURIComponent(item.receipt_team_name)) 
					+ "@" + item.receipt_dept_code+ "@" + escape(encodeURIComponent(item.receipt_dept_name)) 
					+ "@" + item.receipt_user_id+ "@" + escape(encodeURIComponent(item.receipt_user_name)) );
					/* + "@" + item.dwg_no  ); */
		}
		
		$(p_arr).each(function(index, item) {
			if($.inArray(item, p_arrDistinct) == -1) {
				p_arrDistinct.push(item);
			}
		});
		
		$("#p_arrDistinct").val(p_arrDistinct);
		
		window.showModalDialog( "popUpReceiptDwg.do?p_arrDistinct="+p_arrDistinct, window, "dialogWidth:1000px; dialogHeight:300px; center:on; scroll:off; status:off" );
		
	});
	
	//담당자 버튼 클릭
	$("#btnReceiptUserId").click(function(){
		
		var p_arr = new Array();
		var p_arrDistinct = new Array();
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(selarrrow.length < 1){
			alert("행을 선택하십시오.");
			return false;
		} else if(selarrrow.length > 1) {
			alert("1개의 행만 선택가능합니다.");
			return false;
		}
		
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
			
			if(item.receipt_team_code != "${loginUser.upper_dwg_dept_code}") {
				alert("담당팀 수신문서가 아닙니다.");
				rtn = false;
				return false;
			} 
			
			if(item.receipt_team_name == '') {
				alert("담당팀을 지정해야 됩니다.");
				return false;
			}
			
			if(item.receipt_dept_code == "") {
				item.receipt_dept_code = "NULL";
			}
			if(item.receipt_dept_name == "") {
				item.receipt_dept_name = "NULL";
			}
			if(item.receipt_user_id == "") {
				item.receipt_user_id = "NULL";
			}
			if(item.receipt_user_name == "") {
				item.receipt_user_name = "NULL";
			}
			
			p_arr.push(item.receipt_id + "@" +item.receipt_detail_id + "@" + item.receipt_no + "@" + item.project_no + "@" + item.doc_type 
					+ "@" + item.issuer + "@" + escape(encodeURIComponent(item.subject)) + "@" + item.issue_date + "@" + escape(encodeURIComponent(item.com_no)) 
					+ "@" + item.receipt_team_code+ "@" + escape(encodeURIComponent(item.receipt_team_name)) 
					+ "@" + item.receipt_dept_code+ "@" + escape(encodeURIComponent(item.receipt_dept_name)) 
					+ "@" + item.receipt_user_id+ "@" + escape(encodeURIComponent(item.receipt_user_name)) );
		}
		
		$(p_arr).each(function(index, item) {
			if($.inArray(item, p_arrDistinct) == -1) {
				p_arrDistinct.push(item);
			}
		});
		
		$("#p_arrDistinct").val(p_arrDistinct);
		
		window.showModalDialog( "popUpReceiptUserId.do?p_arrDistinct="+p_arrDistinct, window, "dialogWidth:1000px; dialogHeight:500px; center:on; scroll:off; status:off" );
		
	});
	
	//담당자 버튼 클릭
	$("#btnTeam").click(function(){
		
		var selarrrow = jqGridObj.jqGrid('getGridParam', 'selarrrow');
		
		if(selarrrow.length < 1){
			alert("행을 선택하십시오.");
			return false;
		} else if(selarrrow.length > 1) {
			alert("1개의 행만 선택가능합니다.");
			return false;
		}
		
		var p_receipt_id = '';
		for(var i=0; i<selarrrow.length; i++) {
			var item = jqGridObj.jqGrid( 'getRowData', selarrrow[i]);
			
			p_receipt_id = item.receipt_id;
			
		}
		
		window.showModalDialog( "popUpReceiptTeam.do?p_receipt_id="+p_receipt_id, window, "dialogWidth:1000px; dialogHeight:600px; center:on; scroll:off; status:off" );
		
	});
	
	$("#btnReceiptChart").click(function(){
		fn_receiptChart();
	});
	
	
});

var TeamOnChange = function(obj){
	$("input[name=p_receipt_team_code]").val($(obj).find("option:selected").val());
	$("input[name=p_receipt_team_name]").val($(obj).find("option:selected").text());
	
	getAjaxHtml($("#p_sel_receipt_dept"), "commentReceiptDeptSelectBoxDataList.do?sb_type=all&p_upper_dept_code="+$("input[name=p_receipt_team_code]").val()+"&p_dept_code="+$("input[name=dwg_dept_code]").val(), null, null);
	$("input[name=p_receipt_dept_code]").val($("#p_sel_receipt_dept").find("option:selected").val());
}

var DeptOnChange = function(obj){
	$("input[name=p_receipt_dept_code]").val($(obj).find("option:selected").val());
	$("input[name=p_receipt_dept_name]").val($(obj).find("option:selected").text());
}

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

//검색
function fn_search() {
	
	//모두 대문자로 변환
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
	
	var sUrl = "commentReceiptList.do?p_chk_series="+ar_series;
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		postData : fn_getFormData( "#application_form" )
	} ).trigger( "reloadGrid" );
}

// issuer 컬럼 포멧
function issuerFormatter(cellvalue, options, rowObject ) {
	
	if(cellvalue == 'O') {
		return "OWNER";		
	} else if(cellvalue == 'C') {
		return "CLASS"
	} else {
		return "";
	}
	
}

//첨부파일 컬럼 포멧
function fileFormatter(cellvalue, options, rowObject ) {
	
	if(rowObject.receipt_id == null) {
		return '';		
	} else {
		return "<img src=\"./images/icon_file.gif\" border=\"0\" style=\"cursor:pointer;vertical-align:middle;\" onclick=\"fileView('"+rowObject.receipt_id+"');\">";
	}
}

//첨부파일 다운로드
function fileView( receipt_id ) {
	var attURL = "commentReceiptFileDownload.do?p_receipt_id="+receipt_id;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
    window.open(attURL,"",sProperties);
}

var callback_MenuId = function(menu_id) {
	menuId = menu_id;
}

//그리드의 변경된 row만 가져오는 함수
function getChangedGridInfo(gridId) {
	var changedData = $.grep($(gridId).jqGrid('getRowData'), function (obj) {
		return obj.oper == 'I' || obj.oper == 'U' || obj.oper == 'D';
	});
	return changedData;
}

function fn_receiptChart() {

	var sURL = "popUpCommentReceiptChart.do";

    var popOptions = "width=800, height=400, resizable=yes, scrollbars=no, status=no";

	var popupWin = window.open(sURL, "popUpCommentReceiptChart", popOptions);
	setTimeout(function() {
		rs = popupWin.focus();
	}, 500);
    
}

</script>
</html>