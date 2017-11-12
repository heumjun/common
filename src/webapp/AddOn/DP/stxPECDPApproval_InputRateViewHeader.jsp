<%--  
§DESCRIPTION: 설계시수결재 - 시수 입력율 조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_InputRateViewHeader.jsp
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
    <title>시수입력율 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputRateViewHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28" width="50%">
            <td>일자
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputRateViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputRateViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="viewButton" value="조 회" style="width:80px;height:25px;" onclick="viewInputRateList();" />
                <input type="button" name="printButton" value="출 력" style="width:80px;height:25px;" onclick="viewReport();" />
            </td>
        </tr>

        <tr height="28">
            <td>&nbsp;</td>
            <td>
                <input type="radio" name="selectRate" value="all" id="selectRate1" /><label for="selectRate1">전 체&nbsp;&nbsp;</label>
                <input type="radio" name="selectRate" value="under100" checked id="selectRate2" /><label for="selectRate2">입력율 < 100</label>
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    var deptCode = (window.dialogArguments).deptCode;
    var deptName = (window.dialogArguments).deptName;

    // 칼렌다를 통해 날짜변경 시 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr1 = DPInputRateViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPInputRateViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From 날짜 변경 시 To 날짜는 해당 월 말일로 자동 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPInputRateViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPInputRateViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // 입력율조회 실행 - 메인화면(Content 화면)을 로드한다
    function viewInputRateList()
    {
        var urlStr = "stxPECDPApproval_InputRateViewMain.jsp";
        urlStr += "?deptCode=" + deptCode;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&fromDate=" + DPInputRateViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPInputRateViewHeader.dateSelectedTo.value;
        urlStr += "&selectRate=";
        urlStr += DPInputRateViewHeader.selectRate[0].checked  ? "all" : "under100";

        parent.DP_RATE_MAIN.location = urlStr;
    }

    // 프린트(리포트 출력)
    function viewReport()
    {
        var paramStr = deptCode + ":::" + 
                       DPInputRateViewHeader.dateSelectedFrom.value + ":::" + 
                       DPInputRateViewHeader.dateSelectedTo.value + ":::";
        paramStr += DPInputRateViewHeader.selectRate[1].checked  ? "Y" : "";
                       
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPApproval_InputRatesView.mrd&param=" + paramStr;
        window.open(urlStr, "", "");
    }

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
    DPInputRateViewHeader.dateSelectedTo.value = toYMD;
    DPInputRateViewHeader.dateSelectedFrom.value = fromYMD;

    // 조회 창을 로드
    viewInputRateList();

</script>


</html>