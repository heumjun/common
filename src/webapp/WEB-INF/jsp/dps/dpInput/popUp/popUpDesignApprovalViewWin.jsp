<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%--========================== PAGE DIRECTIVES =============================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>시수 입력 - 결재 체크 </title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		시수 입력 - 결재 체크
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="designerId" value="">
		<input type="hidden" name="designerName" value="">
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="4%"/>
				<col width="20%"/>
				<col width="5%"/>
				<col width="*%"/>
				<tr>
					<th>일자</th>
					<td>
						<input style="height:0px; border:none; width: 0%;"/>
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" readonly="readonly" maxlength="10" style="width: 40%; text-align: center;"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 40%; text-align: center;" readonly="readonly"/>
					</td>
					<td>
						<input type="button" name="btn_search" value="조회" class="btn_blue" id="btn_search"/>
					</td>
				</tr>
			</table>
		</div>
		<div class="content" id="dataListDiv">
				<span id="headerText"></span>
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
		<span>시수 입력 해제 요청 방법 : (팀장 전결 - 유선 요청 절대 불가)<br>EP 전자결재 -> 새기안 -> 기술부문 -> 시수입력제한해제요청서 작성</span>
		<div align="right">
			<input type="button" class="btn_blue" value="출력" id="btn_print" onclick="printPage();"/>
			<input type="button" class="btn_blue" value="확인" id="btn_cancel" onclick="javascript:window.close();"/>
		</div>
	</form>	
</div>
<script type="text/javascript">

application_form.designerId.value = (window.dialogArguments).designerId;
application_form.designerName.value = (window.dialogArguments).designerName;

$( function() {
	fn_monthDate("p_created_date_start","p_created_date_end");
	var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		dateFormat: 'yy-mm-dd',
		showMonthAfterYear: true,
		yearSuffix: '년',
		changeYear : true, //년변경가능
		changeMonth : true, //월변경가능
		onSelect: function( selectedDate ,i) {
			if(this.id == "p_created_date_start"){
				var to_date_ary = selectedDate.split("-");
				$( "#p_created_date_end").val(to_date_ary[0]+"-"+to_date_ary[1]+"-"+( new Date( to_date_ary[0], to_date_ary[1], 0) ).getDate());
			} else {
				var start = $("#p_created_date_start").val().replace(/[^0-9]/g,"");
				var end = selectedDate.replace(/[^0-9]/g,"");
				if(start > end)
				{
					alert("종료날자가 시작날자보다 앞으로 갈 수 없습니다");
					$("#p_created_date_end").val(i.lastVal);					
				}
			}
			
			$("#headerText").text($("#p_created_date_start").val()+" ~ "+$("#p_created_date_end").val()+"("+application_form.designerName.value+")");
		}
	} );
});
function fn_monthDate(date_start,date_end){
	var url = 'selectWeekList.do';
	$.post( url, "", function( data ) {
		//파라미터값에 시작,종료날짜 여부에 따라 다른 세팅
		if( (window.dialogArguments).startDate == "none" && (window.dialogArguments).endDate == "none" ){
			$( "#" + date_start ).val( data.created_date_start );
		  	$( "#" + date_end ).val( data.created_date_end );
		}
		else{
			$( "#" + date_start ).val( (window.dialogArguments).startDate );
		  	$( "#" + date_end ).val( (window.dialogArguments).endDate );
		}
	  	$("#headerText").text($( "#" + date_start ).val()+" ~ "+$( "#" + date_end ).val()+"("+application_form.designerName.value+")");
		$("#btn_search").click();
	}, "json" );
}
//프린트(리포트 출력)
function printPage()
{
    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput_ApprovalsView.mrd&param=" +
                 $("#p_created_date_start").val()+":::" +$("#p_created_date_end").val()+":::" + application_form.designerId.value;
    window.open(urlStr);
}
</script>
<script type="text/javascript">
	//메인 컨테르 jqgrid작업 시작
	//마스터 그리드
	$(document).ready( function() {
		var objectHeight = gridObjectHeight(1);
		$( "#dataList" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : fn_getFormData( '#application_form' ),
			colNames : ['일자','사번','정상근무판별','정상','연장','특근','완료','결재'],
			colModel : [
			            	{name : 'workingday', index : 'workingday', width: 20, align : "center"},
							{name : 'employee_no', index : 'employee_no', width: 50, align : "center", hidden:true},
							{name : 'isworkday', index : 'isworkday', width: 20, align : "center", hidden:true},
							{name : 'normal', index : 'normal', width: 20, align : "center"},
							{name : 'overtime', index : 'overtime', width: 20, align : "center"},
							{name : 'special', index : 'special', width: 20, align : "center"},
							{name : 'inputdone_yn', index : 'inputdone_yn', width: 20, align : "center"},
							{name : 'confirm_yn', index : 'confirm_yn', width: 20, align : "center"}
			           ],
	        gridview : true,
	   		cmTemplate: { title: true },
	   		toolbar : [ false, "bottom" ],
	   		hidegrid: false,
	   		altRows:false,
	   		viewrecords : true,
	   		autowidth : true,
	   		height : objectHeight,	   		
	   		rowNum : -1,
	   		rownumbers: true,
	   		emptyrecords : '데이터가 존재하지 않습니다. ',
	   		pager : jQuery('#pDataList'),
	   		cellEdit : true, // grid edit mode 1
	   		cellsubmit : 'clientArray', // grid edit mode 2
	   		pgbuttons: false,     // disable page control like next, back button
		    pgtext: null,
	   		jsonReader : {
	   			root : "rows",
	   			page : "page",
	   			total : "total",
	   			records : "records"
	   		},
	   		ondblClickRow : function(rowid, iRow, iCol, e) {
				var rowData = $(this).getRowData(rowid);
				(window.dialogArguments).window.approvalViewCallBack(rowData.workingday);
				window.close();
			},
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				
				for(var i=0; i<rows.length; i++){
					var bgColor = "#ffffff";
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					if (rowData.inputdone_yn == "Y" && rowData.confirm_yn == "N" ) bgColor = "#fff0f5";
					else if (rowData.inputdone_yn != "Y"){
		                bgColor = "#d8bfd8";
		                $('#dataList').jqGrid('setCell',rows[i], 'confirm_yn', '&nbsp;');
		            }
					$("#dataList").setRowData(rows[i],false,{background:bgColor});
					if(rowData.confirm_yn == "N")$('#dataList').jqGrid('setCell',rows[i], 'confirm_yn', '',{background:'#ff0000;'});
				}
			}
		});
		$( "#dataList" ).jqGrid( 'navGrid', "#pDataList", {
			search : false,
			edit : false,
			add : false,
			del : false,
			refresh : false
		} );
		//그리드 넘버링 표시
		$("#dataList").jqGrid("setLabel", "rn", "No");
		resizeJqGridWidth($(window),$("#dataList"), $("#dataListDiv"),0.5);
		//그리드 사이즈 리사이징 메뉴div 영역 높이를 제외한 사이즈
		//fn_gridresize( $(window), $( "#dataList" ),$('#searchDiv').height() );
		
	});	
</script>
<script type="text/javascript">
$(document).ready(function(){
	//조회 처리
	$("#btn_search").click(function(){
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="popUpDesignApprovalViewMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
	});
});
</script>
</body> 
</html>