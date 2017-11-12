<%--  
§DESCRIPTION: 설계시수입력 - 결재조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_ApprovalsViewHeader.jsp
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
    <title>결 재 체 크</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalsViewHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>일자
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalsViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalsViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td style="text-align:center;">
                <input type="button" name="viewButton" value="조 회" style="width:80px;height:25px;" onclick="viewConfirmYNs();" />
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    var userID = (window.dialogArguments).userID;
    var userName = (window.dialogArguments).userName;
    var callerObject = (window.dialogArguments).callerObject;

    // 칼렌다를 통해 날짜변경 시 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr1 = DPApprovalsViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPApprovalsViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPApprovalsViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPApprovalsViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From 날짜 변경 시 To 날짜는 해당월 마지막 날로 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPApprovalsViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPApprovalsViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;
    }

    // 결재조회 실행 - 결재조회 메인화면(Content 화면)을 로드한다
    function viewConfirmYNs()
    {
        var urlStr = "stxPECDPInput_ApprovalsViewMain.jsp";
        urlStr += "?userID=" + userID;
        urlStr += "&userName=" + escape(encodeURIComponent(userName));
        urlStr += "&fromDate=" + DPApprovalsViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPApprovalsViewHeader.dateSelectedTo.value;

        parent.DP_APPRVIEW_MAIN.location = urlStr;
    }

    // 선택된 일자의 시수입력 사항을 Main 창에 표시
    function callViewDPInputs(dateStr)
    {
        callerObject.callViewDPInputs(dateStr);
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
    DPApprovalsViewHeader.dateSelectedTo.value = toYMD;
    DPApprovalsViewHeader.dateSelectedFrom.value = fromYMD;
    // 결재조회 창을 로드
    viewConfirmYNs();

</script>


</html>