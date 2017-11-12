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
<title>휴 일 체 크</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		휴 일 체 크
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="dept_code" value="">
		<input type="hidden" name="dept_name" value="">
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="4%"/>
				<col width="18%"/>
				<col width="9%"/>
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
						<input type="button" class="btn_blue" value="출력" id="btn_cancel" onclick="viewReport();"/>
						<input type="button" value="확 인" class="btn_blue" onclick="javascript:window.close();">
					</td>
				</tr>
			</table>
		</div>
		<div class="content" id="dataListDiv">
				<table id="dataList"></table>
				<div id="pDataList"></div>
		</div>
	</form>
</div>
<script type="text/javascript">
application_form.dept_code.value = (window.dialogArguments).dept_code;
application_form.dept_name.value = (window.dialogArguments).dept_name;
$( function() {
	fn_initDate("p_created_date_start","p_created_date_end");
	
	var dates = $( "#p_created_date_start, #p_created_date_end" ).datepicker( {
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		dayNames: ['일','월','화','수','목','금','토'],
		dayNamesShort: ['일','월','화','수','목','금','토'],
		dayNamesMin: ['일','월','화','수','목','금','토'],
		dateFormat: 'yy-mm-dd',
		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		showMonthAfterYear : true, //년 뒤에 월 표시
		yearSuffix: '년',
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
		}
	} );
	//조회 처리
	$("#btn_search").click(function(){
		//그리드 갱신을 위한 작업
		$( '#dataList' ).jqGrid( 'clearGridData' );
		//그리드 postdata 초기화 후 그리드 로드 
		$( '#dataList' ).jqGrid( 'setGridParam', {postData : null});
		$( '#dataList' ).jqGrid( 'setGridParam', {
			mtype : 'POST',
			url : '<c:url value="popUpApprovalHolidayCheckViewMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
	});
});

function fn_initDate( date_start, date_end ) {
    /* 화면(기능)이 실행되면 초기 상태를 해당 월 1일 ~ 오늘 기준으로 설정 */   
    // 오늘 날짜
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    var toYMD = y1 + "-" + m1 + "-" + d1;
    // 해당 월 1일
    var fromYMD = y1 + "-" + m1 + "-01";    
    // 초기 From, To 날짜 설정
    $("#"+date_end).val(toYMD);
    $("#"+date_start).val(fromYMD);
}
//프린트(리포트 출력)
function viewReport()
{
    var paramStr = application_form.dept_code.value + ":::" + 
    			   application_form.dateSelected_from.value + ":::" + 
    			   application_form.dateSelected_to.value + ":::";
    var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPApproval_HolidayCheck.mrd&param=" + paramStr;
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
			colNames : ['일자','부서','사번','직위','성명'],
			colModel : [
							{name : 'work_day', index : 'work_day', width: 40, align : "center"},
			            	{name : 'dept_name', index : 'dept_name', width: 40, align : "center"},
							{name : 'employee_no', index : 'employee_no', width: 10, align : "center"},
							{name : 'position', index : 'position', width: 10, align : "center"},
							{name : 'name', index : 'name', width: 20, align : "center"}
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
			},
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				for(var i=0; i<rows.length; i++){
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					$('#dataList').jqGrid('setCell',rows[i],'dept_name',application_form.dept_name.value);
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
		$("#btn_search").click();
	});	
</script>
</body> 
</html>