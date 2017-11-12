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
<title>시운전 기간 선택</title>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
</head>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		시운전 호선과 기간을 선택하십시오.
	</div>
	<form id="application_form" name="application_form">
		<div id="searchDiv">
			<table class="searchArea conSearch">
				<col width="4%"/>
				<col width="20%"/>
				<col width="*%"/>
				<tr>
					<th>공사번호</th>
					<td>
						<select name="projectList" style="width:80%;">
                    		<option value="">&nbsp;</option>
                    		<c:forEach var="item" items="${selectedProjectList }">
                    			<option value="<c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }">
								<c:if test="${item.dl_effective eq null or item.dl_effective eq 'N'}">Z</c:if>${item.projectno }</option>
                    		</c:forEach>
                    	</select>
					</td>
				</tr>
				<tr>
					<th>시운전 시작시간</th>
					<td>
						<input style="height:0px; border:none; width: 0%;"/>
						<input type="text" id="p_created_date_start" name="dateSelected_from" class="datepicker" maxlength="10" style="width: 40%; text-align: center;" readonly="readonly"/>
						:
						<select name="dateSelected_from_times" style="width:40%;">
                    		<option value="">&nbsp;</option>
                    		<c:forEach var="item" items="${timeKeys }">
                    			<c:if test="${item ne '1230' }">
                    				<option value="${item }">${fn:substring(item,0,2) }:${fn:substring(item,2,4) }</option>
                    			</c:if>
                    		</c:forEach>
                    	</select>
					</td>
				</tr>
				<tr>
					<th>시운전 종료시간</th>
					<td>
						<input style="height:0px; border:none; width: 0%;"/>
						<input type="text" id="p_created_date_end" name="dateSelected_to" class="datepicker" maxlength="10" style="width: 40%; text-align: center;" readonly="readonly"/>
						:
						<select name="dateSelected_to_times" style="width:40%;">
                    		<option value="">&nbsp;</option>
                    		<c:forEach var="item" items="${timeKeys }">
                    			<c:if test="${item ne '1230' }">
                    				<option value="${item }">${fn:substring(item,0,2) }:${fn:substring(item,2,4) }</option>
                    			</c:if>
                    		</c:forEach>
                    	</select>
					</td>
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
		changeMonth : true, //년변경가능
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
    var projectNo = application_form.projectList.value;
    var fromDate = application_form.dateSelected_from.value;
    var fromTime = application_form.dateSelected_from_times.value;
    var toDate = application_form.dateSelected_to.value;
    var toTime = application_form.dateSelected_to_times.value;

    if (projectNo == '') {
        alert('공사번호를 지정하십시오!');
        return;
    }
    if (fromDate == '' || fromTime == '' || toDate == '' || toTime == '') {
        alert('시작 및 종료시간을 지정하십시오!');
        return;
    }
    if (fromDate == toDate && fromTime == toTime) {
        alert('시작시간과 종료시간이 같습니다!');
        return;
    }

    // 시작-종료 순서가 반대이면 조정
    var tempStrs = fromDate.split("-");
    var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
    tempStrs = toDate.split("-");
    var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
    if (fromDateObj > toDateObj) {
        var temp = toDate;
        toDate = fromDate;
        fromDate = temp;
        temp = toTime;
        toTime = fromTime;
        fromTime = temp;
    }
    // 시작-종료일이 같고 시작-종료 시각이 반대이면 조정
    else if (fromDateObj == toDateObj) {
        fromIndex = application_form.dateSelected_from_times.selectedIndex;
        toIndex = application_form.dateSelected_to_times.selectedIndex;
        if (fromIndex > toIndex) {
            var temp = toTime;
            toTime = fromTime;
            fromTime = temp;
        }
    }
    window.returnValue = projectNo + "~" + fromDate + "|" + fromTime + "~" + toDate + "|" + toTime;
    window.close();
}
</script>
</body> 
</html>