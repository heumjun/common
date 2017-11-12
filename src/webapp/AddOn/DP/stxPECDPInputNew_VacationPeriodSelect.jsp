<%--  
��DESCRIPTION: ����ü��Է� - Ư���ް� �Ⱓ ���� â
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECDPInputNew_VacationPeriodSelect.jsp
��CHANGING HISTORY: 
��    2014-12-10: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String opCode = emxGetParameter(request, "opCode");

    String jobDescStr = "?????";
    if (opCode.equals("D13")) jobDescStr = "�����Ʒ�";
    else if (opCode.equals("D14")) jobDescStr = "Ư���ް�";
    else if (opCode.equals("D17")) jobDescStr = "����";
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title><%=jobDescStr%> �Ⱓ ����</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPVacationPeriodSelect">

    <table width="100%" cellPadding="5" border="0" align="center">
        <tr height="28">
            <td style="font-family:����;font-weight:bold;font-size:11pt;"><%=jobDescStr%> �Ⱓ�� �����Ͻʽÿ�!</td>
        </tr>
    </table>

    <table width="100%" cellPadding="20" border="0" align="center" style="background-color:#ffffff">
        <tr>
            <td>
                <b>�Ⱓ: </b>
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
                <input type="button" value="Ȯ��" class="button_simple" onclick="selectSubmit();">&nbsp;&nbsp;
                <input type="button" value="���" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Į���ٸ� ���� ��¥���� �� ��¥ ��� ���ڿ��� ����ȭ
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

    // Ȯ��
    function selectSubmit()
    {
        var fromDate = DPVacationPeriodSelect.dateSelectedFrom.value;
        var toDate = DPVacationPeriodSelect.dateSelectedTo.value;

        if (fromDate == '' || toDate == '') {
            alert('���� �� �������� �����Ͻʽÿ�!');
            return;
        }

        // ����-���� ������ �ݴ��̸� ����
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