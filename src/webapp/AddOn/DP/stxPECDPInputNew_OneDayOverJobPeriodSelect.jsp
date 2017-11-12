<%--  
§DESCRIPTION: 설계시수입력 - 사외 협의 검토, 기술회의 및 교육, 일반출장 기간 선택 창
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPInputNew_OneDayOverJobPeriodSelect.jsp
§CHANGING HISTORY: 
§    2014-12-10: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String opCode = request.getParameter("opCode");
    
    String jobDescStr = "?????";
    if (opCode.equals("B46")) jobDescStr = "사외 협의 검토(공사관련 출장)";
    else if (opCode.equals("C22")) jobDescStr = "기술회의 및 교육(사내외)";
    else if (opCode.equals("C31")) jobDescStr = "일반출장(기술소위원회, 세미나)";
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title><%=jobDescStr%> 기간 선택</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPOneDayOverJobPeriodSelect">

    <table width="100%" cellSpacing="0" border="1" align="center">
        <tr height="20">
            <td></td>
        </tr>
    </table>

    <table width="100%" border="0" align="center" style="background-color:#ffffff;">
        <tr height="18">
            <td style="font-family:돋움;font-weight:bold;font-size:10pt;padding:15px 10px 0px 10px;">
                <%=jobDescStr%> 기간을 선택하십시오!
            </td>
        </tr>
        <tr>
            <td style="padding:0px 10px 5px 40px;">
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPOneDayOverJobPeriodSelect', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPOneDayOverJobPeriodSelect', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
        </tr>
        <tr height="18">
            <td style="font-family:돋움;font-weight:bold;font-size:10pt;padding:10px 10px 0px 10px;">
                업무내용*
            </td>
        </tr>
        <tr>
            <td style="padding:0px 10px 18px 40px;">
                <input type="text" name="inputWorkContent" value="" class="input_small" style="width:300px;">
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
        var tmpStr1 = DPOneDayOverJobPeriodSelect.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPOneDayOverJobPeriodSelect.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPOneDayOverJobPeriodSelect.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPOneDayOverJobPeriodSelect.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // 확인
    function selectSubmit()
    {
        var fromDate = DPOneDayOverJobPeriodSelect.dateSelectedFrom.value;
        var toDate = DPOneDayOverJobPeriodSelect.dateSelectedTo.value;
        var workContent = DPOneDayOverJobPeriodSelect.inputWorkContent.value;

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
            alert("<%=jobDescStr%> 시작일자는 오늘로부터 일주일 이내여야 합니다!");
            return;
        }

        window.returnValue = fromDate + "¸" + toDate + "¸" + workContent;
        window.close();
    }

</script>


</html>