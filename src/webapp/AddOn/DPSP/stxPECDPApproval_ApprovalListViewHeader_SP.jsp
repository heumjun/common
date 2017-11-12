<%--  
§DESCRIPTION: 설계시수결재 - 결재조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_ApprovalListViewHeader.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>결 재 조 회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">
    //document.onkeydown = keydownHandlerIncludeCloseFunc;
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalListViewHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>일자
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalListViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalListViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td style="text-align:center;">
                <input type="button" name="viewButton" value="조 회" style="width:80px;height:25px;" onclick="viewConfirmYNsList();" />
            </td>
        </tr>
    </table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

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
        var urlStr = "stxPECDPApproval_ApprovalListViewMain_SP.jsp";
        urlStr += "?deptCode=" + deptCode;
        urlStr += "&fromDate=" + DPApprovalListViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPApprovalListViewHeader.dateSelectedTo.value;

        parent.DP_APPRLIST_MAIN.location = urlStr;
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
