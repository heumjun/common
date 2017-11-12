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
<title>${jobDescStr } 기간 선택</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		${jobDescStr }기간을 선택하십시오.
	</div>
	<form id="application_form" name="application_form">
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="4%"/>
				<col width="20%"/>
				<col width="*%"/>
				<tr>
					<th>일자</th>
					<td>
						<input style="height:0px; border:none; width: 0%;"/>
						<input type="text" id="p_created_date_start" value="" name="dateSelected_from" class="datepicker" readonly="readonly" maxlength="10" style="width: 40%; text-align: center;"/>
						~
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 40%; text-align: center;" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th>업무내용</th>
					<td><input type="text" name="inputWorkContent" value="" style="width:80%;"></td>
				</tr>
			</table>
		</div>
		<div align="right">
			<input type="button" class="btn_blue" value="확인" id="btn_ok" onclick="selectSubmit();"/>
			<input type="button" class="btn_blue" value="취소" id="btn_cancel" onclick="javascript:window.close();"/>
		</div>
	</form>	
</div>
<script type="text/javascript">
$( function() {
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
		changeMonth : true,
		onSelect: function( selectedDate ,i) {
			var start = $("#p_created_date_start").val().replace(/[^0-9]/g,"");
			var end = selectedDate.replace(/[^0-9]/g,"");
			if(start > end)
			{
				alert("종료날자가 시작날자보다 앞으로 갈 수 없습니다");
				$("#p_created_date_end").val(i.lastVal);					
			}
		}
	} );
});

//확인
function selectSubmit()
{
    var fromDate = application_form.dateSelected_from.value;
    var toDate = application_form.dateSelected_to.value;
    var workContent = application_form.inputWorkContent.value;

    if (fromDate == '' || toDate == '') {
        alert('시작 및 종료일을 지정하십시오!');
        return;
    }

    if (workContent.trim() == '') {
        alert('업무내용을 입력하십시오!');
        return;
    }

 	// 시작-종료 순서가 반대이면 조정
    var tempStrs = fromDate.split("-");
    var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
    tempStrs = toDate.split("-");
    var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);

    if (fromDateObj > toDateObj) {
        var tempDate = fromDate;
        fromDate = toDate;
        toDate = tempDate;
    }

    // 시작일이 오늘로부터 일주일을 넘어서면 적용 X
    tempStrs = fromDate.split("-");
    var today = new Date();
    fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2] - 7); // 시작일에서 7을 뺀 날짜(7일 전)
    if (fromDateObj - today > 0) {
        alert("${jobDescStr } 시작일자는 오늘로부터 일주일 이내여야 합니다!");
        return;
    }

    window.returnValue = fromDate + "¸" + toDate + "¸" + workContent;
    window.close();
}
</script>
</body> 
</html>