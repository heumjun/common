<%--  
§DESCRIPTION: 설계시수결재 - 결재조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_ApprovalListViewHeader.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%--========================== JSP =========================================--%>
<%
%>

<%--========================== HTML HEAD ===================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>결 재 조 회</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>

<script language="javascript">
    //document.onkeydown = keydownHandlerIncludeCloseFunc;
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalListViewHeader">

    <table class="searchArea conSearch">
        <tr>
        	<th>일자</th>
            <td><input style="width:0px;border:0;" readonly="readonly">
                <input type="text" name="dateSelectedFrom" id="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" id="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
            </td>
            <td style="text-align:right; padding-right:10px;">
                <input type="button" name="viewButton" class="btn_blue" value="조 회" style="" onclick="viewConfirmYNsList();" />
                <input type="button" value="확 인" class="btn_blue" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
<iframe id="DP_APPRLIST_MAIN" src="" frameborder=0 marginwidth=0 marginheight=0 width=100% height=260px style=""></iframe>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">    
//달력 초기화 설정
$(function() {
	$("#dateSelectedFrom").datepicker({
		dateFormat : 'yy-mm-dd',
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],

		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		showMonthAfterYear : true, //년 뒤에 월 표시
	});
	$("#dateSelectedTo").datepicker({
		dateFormat : 'yy-mm-dd',
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],

		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		showMonthAfterYear : true, //년 뒤에 월 표시
	});
});
    var deptCode = (window.dialogArguments).deptCode;
    var callerObject = (window.dialogArguments).callerObject;

    // 칼렌다를 통해 날짜변경 시 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr1 = DPApprovalListViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPApprovalListViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPApprovalListViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPApprovalListViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

/**************************** 2015-02-04 To 날짜는 해당월 마지막 날로 변경에 따른 기존 로직 주석
    // From 날짜 변경 시 To 날짜는 From 날짜 + 7일로 자동 변경
    function dateChangedFrom()
    {
        dateChanged();

        var dateStrs = (DPApprovalListViewHeader.dateSelectedFrom.value).split("-");
        var toDate = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "+7")); // 7일 후
        
        var y = toDate.getFullYear().toString();
        var m = (toDate.getMonth() + 1).toString();
        if (m.length == 1) m = 0 + m;
        var d = toDate.getDate().toString();
        if (d.length == 1) d = 0 + d;

        DPApprovalListViewHeader.dateSelectedTo.value = y + "-" + m + "-" + d;;
    }
 ****************************/   
 
    // From 날짜 변경 시 To 날짜는 해당월 마지막 날로 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPApprovalListViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPApprovalListViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;
    }
    
    // 결재조회 실행 - 결재조회 메인화면(Content 화면)을 로드한다
    function viewConfirmYNsList()
    {
        var urlStr = "stxPECDPApproval_ApprovalListViewMain.do";
        urlStr += "?deptCode=" + deptCode;
        urlStr += "&fromDate=" + DPApprovalListViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPApprovalListViewHeader.dateSelectedTo.value;

        /* parent.DP_APPRLIST_MAIN.location = urlStr; */
        $("#DP_APPRLIST_MAIN").attr("src", urlStr);
    }

    // 선택된 일자의 시수입력 사항을 Main 창에 표시
    function callViewDPApprovals(workdayStr)
    {
        callerObject.callViewDPApprovals(workdayStr);
    }

    /* 화면(기능)이 실행되면 초기 상태를 오늘 날짜 & -1주 를 기준으로 설정하고 결재조회 창을 로드 */   
    // 오늘 날짜
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    // 오늘 날짜 - 7일
    var weekAgoDay = new Date(today - (3600000 * 24 * 7));
    var y2 = weekAgoDay.getFullYear().toString();
    var m2 = (weekAgoDay.getMonth() + 1).toString();
    if (m2.length == 1) m2 = 0 + m2;
    var d2 = weekAgoDay.getDate().toString();
    if (d2.length == 1) d2 = 0 + d2;
    // 초기 From, To 날짜 설정
    var toYMD = y1 + "-" + m1 + "-" + d1;
    var fromYMD = y2 + "-" + m2 + "-" + d2;    
    DPApprovalListViewHeader.dateSelectedTo.value = toYMD;
    DPApprovalListViewHeader.dateSelectedFrom.value = fromYMD;

    // 결재조회 창을 로드
    viewConfirmYNsList();

</script>

</html>
