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
<title>결 재 조 회 </title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		결 재 조 회
	</div>
	<form id="application_form" name="application_form">
		<input type="hidden" name="dept_code" value="${dept_code }">
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
						<input type="button" class="btn_blue" value="취소" id="btn_cancel" onclick="javascript:window.close();"/>
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
$( function() {
	fn_weekDate("p_created_date_start","p_created_date_end");
	
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
			url : '<c:url value="popUpApprovalListViewMainGrid.do"/>',
			datatype : 'json',
			page : 1,
			postData :fn_getFormData($('#application_form'))
		} ).trigger( 'reloadGrid' );
	});
});

function fn_weekDate( date_start, date_end ) {
	var url = 'selectWeekList.do';

	$.post( url, "", function( data ) {
		$( "#" + date_start ).val( data.created_date_start );
	  	$( "#" + date_end ).val( data.created_date_end );
	  	$("#btn_search").click();
	}, "json" );
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
			colNames : ['일자','결재'],
			colModel : [
			            	{name : 'work_day', index : 'workingday', width: 20, align : "center"},
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
				(window.dialogArguments).approvalViewCallBack(rowData.work_day);
			},
			loadComplete: function (data) {
			},
			gridComplete : function() {
				var rows = $( "#dataList" ).getDataIDs();
				
				for(var i=0; i<rows.length; i++){
					var bgColor = "#ffffff";
					var rowData = $('#dataList').jqGrid('getRowData', rows[i]);
					if(rowData.confirm_yn == "N")$("#dataList").setRowData(rows[i],false,{background:'#fff0f5;'});
					else $("#dataList").setRowData(rows[i],false,{background:bgColor}); 
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
	});	
</script>
</body> 
</html>