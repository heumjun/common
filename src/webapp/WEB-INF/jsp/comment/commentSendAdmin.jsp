<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>발신문서_승인</title>
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
	
	<input type="hidden" name="p_is_excel" id="p_is_excel"  value="" />
	<input type="hidden" name="p_auth_code" id="p_auth_code"  value="${loginUser.author_code}" />
	<input type="hidden" id="init_flag" name="init_flag" value="first" />
	
	<input type="hidden" name="p_check_series" id="p_check_series" value="${p_chk_series}" />
	<input type="hidden" name="search_project_no" id="search_project_no"  value="" />
	<input type="hidden" name="h_user_name" id="h_user_name"  value="${loginUser.user_name}" />
	<input type="hidden" name="h_user_id" id="h_user_id"  value="${loginUser.user_id}" />
	<input type="hidden" name="upper_dwg_dept_code" id="upper_dwg_dept_code"  value="${loginUser.upper_dwg_dept_code}" />
	<input type="hidden" name="dwg_dept_code" id="dwg_dept_code"  value="${loginUser.dwg_dept_code}" />
	
	<div id="mainDiv" class="mainDiv">
		<div class= "subtitle">
			발신문서_승인
			<jsp:include page="../common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="/images/content/yellow.gif"/>&nbsp;필수입력사항</span>
		</div>
			 
		<table class="searchArea conSearch">
			<col width="1070px">
			<col width="*">
			<tr>
			<td class="sscType" style="border-right:none;"> 
				Project
				<input type="text" id="p_project_no" name="p_project_no" maxlength="10" style="width:50px; ime-mode:disabled;" onchange="javascript:this.value=this.value.toUpperCase();" alt="호선정보"/>
				&nbsp;
				REF No.
				<input type="text" id="p_ref_no" name="p_ref_no" style="width:110px;"/>
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
				Subject
				<input type="text" id="p_subject" name="p_subject" style="width:210px;"/>
				&nbsp;
				발신팀
				<input type="text" name="p_request_team_name" class="disableInput" value="<c:out value="${loginUser.upper_dwg_dept_name}" />" style="width:110px;" readonly="readonly" />
				<input type="hidden" name="p_request_team_code" value="<c:out value="${loginUser.upper_dwg_dept_code}" />"  /> &nbsp;
				&nbsp;
				발신파트
				<select name="p_sel_request_dept" id="p_sel_request_dept" style="width:100px;" onchange="javascript:DeptOnChange(this);" >
				</select>
				<input type="hidden" name="p_request_dept_code" id="p_request_dept_code" value="<c:out value="${loginUser.dwg_dept_code}" />"  />
				<input type="hidden" name="p_request_dept_name" id="p_request_dept_name" value="<c:out value="${loginUser.dwg_dept_name}" />"  />
			</td>
			<td style="border-left:none;">
				<div class="button endbox">
					<c:if test="${userRole.attribute1 == 'Y'}">
						<input type="button" value="승 인" id="btnApply" class="btn_blue2" style="font-size:11px; line-height:2.2;" />
						<input type="button" value="반 려" id="btnReject"  class="btn_blue2" style="font-size:11px; line-height:2.2;" />
						<input type="button" value="SEARCH" id="btnSearch" class="btn_blue2" />
					</c:if>
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
</body>
<script type="text/javascript">

var idRow;
var idCol;
var kRow;
var kCol;

var jqGridObj = $('#jqGridList');

//달력 셋팅
$(function() {
	
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

if(typeof($("#p_sel_request_dept").val()) !== 'undefined'){
	getAjaxHtml($("#p_sel_request_dept"), "commentRequestDeptSelectBoxDataList.do?p_upper_dept_code="+$("input[name=upper_dwg_dept_code]").val()+"&p_dept_code="+$("input[name=dwg_dept_code]").val(), null, null);
}

var DeptOnChange = function(obj){
	$("input[name=p_request_dept_code]").val($(obj).find("option:selected").val());
	$("input[name=p_request_dept_name]").val($(obj).find("option:selected").text());
}

function getMainGridColModel(){

	var gridColModel = new Array();
	
	gridColModel.push({label:'SEND ID', name:'send_id', index:'send_id', width:50, align:'center', sortable:false, hidden:true}); //HIDDEN 예정
	gridColModel.push({label:'Project', name:'project_no', index:'project_no', title:false, width:40, align:'center', sortable:false, title:false});
	gridColModel.push({label:'REF No.', name:'ref_no', index:'ref_no', width:100, align:'center', sortable:false, title:false});
	gridColModel.push({label:'DWG No.', name:'dwg_no', index:'dwg_no', width:50, align:'center', sortable:false});
	gridColModel.push({label:'DWG No. LIST', name:'dwg_no_list', index:'dwg_no_list', editable:false, width:50, align:'center', sortable:false, hidden:true});
	gridColModel.push({label:'구분' ,name:'send_type', index:'send_type', width:40, align:'center', sortable:false, edittype : "select", formatter : 'select', title:false});
	gridColModel.push({label:'O/C' ,name:'oc_type', index:'oc_type', width:30, align:'center', sortable:false, title:false});
	gridColModel.push({label:'Subject', name:'subject', index:'subject', width:200, align:'left', sortable:false});
	gridColModel.push({label:'View', name:'view_flag', index:'view_flag', width:30, align:'center', sortable:false, title:false});
	gridColModel.push({label:'첨부', name:'doc_cnt', index:'doc_cnt', width:30, align:'center', sortable:false, title:false});
	gridColModel.push({label:'발신부서', name:'dwg_dept_name', index:'dwg_dept_name', width:90, align:'center', sortable:false, title:false, title:false});
	gridColModel.push({label:'발신부서code', name:'dwg_dept_code', index:'dwg_dept_code', width:80, align:'center', sortable:false, title:false, hidden:true}); //HIDDEN 예정
	gridColModel.push({label:'발신자', name:'request_user_name', index:'request_user_name', width:80, align:'center', sortable:false, title:false});	
	gridColModel.push({label:'발신자code', name:'request_user_id', index:'request_user_id', width:80, align:'center', sortable:false, hidden:true}); //HIDDEN 예정
	gridColModel.push({label:'Date', name:'creation_date', index:'creation_date', width:50, align:'center', sortable:false, title:false});
	gridColModel.push({label:'승인자' ,name:'confirm_user_name' , index:'confirm_user_name' ,width:60 ,align:'center', sortable:false, title:false});
	gridColModel.push({label:'승인자code' ,name:'confirm_user_id' , index:'confirm_user_id' ,width:60 ,align:'center', sortable:false, hidden:true}); //HIDDEN 예정
	gridColModel.push({label:'승인일자' ,name:'confirm_date' , index:'confirm_date' ,width:50 ,align:'center', sortable:false, title:false});
	
	return gridColModel;
}

var gridColModel = getMainGridColModel();

$(document).ready(function(){
	
	jqGridObj.jqGrid({ 
		datatype: 'json', 
		mtype: 'POST', 
		url:'commentSendAdminList.do?p_chk_series=',
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
			else if(pgButton == 'next_btnjqGridAdminList'){
				pages = currentPageIndex+1;
			} 
			else if(pgButton == 'last_btnjqGridAdminList'){
				pages = lastPageX;
			}
			else if(pgButton == 'prev_btnjqGridAdminList'){
				pages = currentPageIndex-1;
			}
			else if(pgButton == 'first_btnjqGridAdminList'){
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
				var item = $(this).jqGrid( 'getRowData', rows[i] );
				$(this).jqGrid( 'setCell', rows[i], 'dwg_no', '','', {title : item.dwg_no_list} );
			}	
		},	
		onCellSelect : function( rowid, iCol, cellcontent, e ) {
			var cm = jqGridObj.jqGrid( "getGridParam", "colModel" );
			var colName = cm[iCol];
			var item = $(this).jqGrid( 'getRowData', rowid );
				
			if ( colName['index'] == "doc_cnt" ) {
				
				var viewFlag = item.view_flag;
				// 자신의 부서 항목이 아닐때
				if( viewFlag =="N" ){
					alert("VIEW FLAG가 N인 항목은 첨부문서를 볼 수 없습니다.");
					return;
				}
				var sURL = "popUpCommentSendAttach.do?row_selected="+rowid+"&send_id="+item.send_id+"&view_flag=N";
					
				var popOptions = "dialogWidth:800px; dialogHeight: 380px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
			}
			
			//SUB 도면번호 팝업창
			if ( colName['index']=="dwg_no") {
				var sURL = "popUpCommentSendDwgNo.do?row_selected="+rowid
						+"&p_project_no="+item.project_no
						+"&p_send_id="+item.send_id
						+"&p_user_id="+$("#h_user_id").val()
						+"&p_dept_code="+$("#h_dept_code").val()
						+"&p_send_type="+item.send_type
						+"&p_dwg_edit=N";
				var popOptions = "dialogWidth:600px; dialogHeight: 620px; center: yes; resizable: no; status: no; scroll: no;"; 
				window.showModalDialog(sURL, window, popOptions);
			}
			jqGridObj.saveCell( kRow, idCol );
		}
	}); //end of jqGrid

	//jqGrid 크기 동적화
	fn_gridresize( $(window), $( "#jqGridList" ), -20 );
	
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
	
	$("#search_project_no").val( $("#p_project_no").val() ); 
	if(uniqeValidation()){
		fn_search();
	}
});

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
	
	var sUrl = "commentSendAdminList.do?p_chk_series="+ar_series;
	jqGridObj.jqGrid( "clearGridData" );
	jqGridObj.jqGrid( 'setGridParam', {
		url : sUrl,
		mtype : 'POST',
		datatype : 'json',
		page : 1,
		//rowNum : pageCnt,
		postData : fn_getFormData( "#application_form" )
	}).trigger( "reloadGrid" );
}

//발신문서 승인 버튼
$( "#btnApply" ).click( function() {
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
		
		if(item.confirm_date != ""){
			
			alert("승인완료 항목이 포함되어 있습니다.");								
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
	$.post("commentSendAdminApply.do?send_id_array="+send_id_array+"&p_mail_type=C&p_mail_comment=", form.serialize(),function(json)
	{	
		alert(json.resultMsg);
		$(".loadingBoxArea").hide();
		fn_search();
	},"json");
	
} );

//발신문서 반려 버튼
$( "#btnReject" ).click( function() {
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
		
		if(item.confirm_date != ""){
			
			alert("승인완료 항목이 포함되어 있습니다.");								
			rtn = false;
			return false;
		}
		send_id_array.push(item.send_id);
	}
	
	if(!rtn){
		return false;
	}
	
	//반려내용 작성 팝업창 실행
	var url = "popUpCommentSendAdminRefuseContent.do?send_id_array="+send_id_array;					
	var nwidth = 600;
	var nheight = 210;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;
	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";
	window.open(url,"",sProperties).focus();
} );
</script>
</html>