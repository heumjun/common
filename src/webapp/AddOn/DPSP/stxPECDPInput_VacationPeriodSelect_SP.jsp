<%--  
§DESCRIPTION: 설계시수입력 - 특별휴가 기간 선택 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_VacationPeriodSelect.jsp
§CHANGING HISTORY: 
§    2009-06-02: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String opCode = emxGetParameter(request, "opCode");

    String jobDescStr = "?????";
    if (opCode.equals("93")) jobDescStr = "예비군훈련";
    else if (opCode.equals("94")) jobDescStr = "특별휴가";
    else if (opCode.equals("97")) jobDescStr = "년차";
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title><%=jobDescStr%> 기간 선택</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPVacationPeriodSelect">

    <table width="100%" cellPadding="5" border="0" align="center">
        <tr height="28">
            <td style="font-family:돋움;font-weight:bold;font-size:11pt;"><%=jobDescStr%> 기간을 선택하십시오!</td>
        </tr>
    </table>

    <table width="100%" cellPadding="20" border="0" align="center" style="background-color:#ffffff">
        <tr>
            <td>
                <b>기간: </b>
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPVacationPeriodSelect', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPVacationPeriodSelect', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
        </tr>
    </table>

    <table width="100%" cellPadding="5" cellSpacing="0" border="1" align="center">
        <tr height="45">
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="확인" class="button_simple" onclick="selectSubmit();">&nbsp;&nbsp;
                <input type="button" value="취소" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 칼렌다를 통해 날짜변경 시 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr1 = DPVacationPeriodSelect.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPVacationPeriodSelect.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPVacationPeriodSelect.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPVacationPeriodSelect.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // 확인
    function selectSubmit()
    {
        var fromDate = DPVacationPeriodSelect.dateSelectedFrom.value;
        var toDate = DPVacationPeriodSelect.dateSelectedTo.value;

        if (fromDate == '' || toDate == '') {
            alert('시작 및 종료일을 지정하십시오!');
            return;
        }

        // 시작-종료 순서가 반대이면 조정
        var tempStrs = fromDate.split("-");
        var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        tempStrs = toDate.split("-");
        var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);

        if (fromDateObj > toDateObj) window.returnValue = toDate + "~" + fromDate;
        else window.returnValue = fromDate + "~" + toDate;

        window.close();
    }

</script>


</html>