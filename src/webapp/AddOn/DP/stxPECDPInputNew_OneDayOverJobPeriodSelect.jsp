<%--  
��DESCRIPTION: ����ü��Է� - ��� ���� ����, ���ȸ�� �� ����, �Ϲ����� �Ⱓ ���� â
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECDPInputNew_OneDayOverJobPeriodSelect.jsp
��CHANGING HISTORY: 
��    2014-12-10: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String opCode = request.getParameter("opCode");
    
    String jobDescStr = "?????";
    if (opCode.equals("B46")) jobDescStr = "��� ���� ����(������� ����)";
    else if (opCode.equals("C22")) jobDescStr = "���ȸ�� �� ����(�系��)";
    else if (opCode.equals("C31")) jobDescStr = "�Ϲ�����(���������ȸ, ���̳�)";
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
<form name="DPOneDayOverJobPeriodSelect">

    <table width="100%" cellSpacing="0" border="1" align="center">
        <tr height="20">
            <td></td>
        </tr>
    </table>

    <table width="100%" border="0" align="center" style="background-color:#ffffff;">
        <tr height="18">
            <td style="font-family:����;font-weight:bold;font-size:10pt;padding:15px 10px 0px 10px;">
                <%=jobDescStr%> �Ⱓ�� �����Ͻʽÿ�!
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
            <td style="font-family:����;font-weight:bold;font-size:10pt;padding:10px 10px 0px 10px;">
                ��������*
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
        var tmpStr1 = DPOneDayOverJobPeriodSelect.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPOneDayOverJobPeriodSelect.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPOneDayOverJobPeriodSelect.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPOneDayOverJobPeriodSelect.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // Ȯ��
    function selectSubmit()
    {
        var fromDate = DPOneDayOverJobPeriodSelect.dateSelectedFrom.value;
        var toDate = DPOneDayOverJobPeriodSelect.dateSelectedTo.value;
        var workContent = DPOneDayOverJobPeriodSelect.inputWorkContent.value;

        if (fromDate == '' || toDate == '') {
            alert('���� �� �������� �����Ͻʽÿ�!');
            return;
        }

        if (workContent.trim() == '') {
            alert('���������� �Է��Ͻʽÿ�!');
            return;
        }

        // ����-���� ������ �ݴ��̸� ����
        var tempStrs = fromDate.split("-");
        var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        tempStrs = toDate.split("-");
        var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);

        if (fromDateObj > toDateObj) {
            var tempDate = fromDate;
            fromDate = toDate;
            toDate = tempDate;
        }

        // �������� ���÷κ��� �������� �Ѿ�� ���� X
        tempStrs = fromDate.split("-");
        var today = new Date();
        fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2] - 7); // �����Ͽ��� 7�� �� ��¥(7�� ��)
        if (fromDateObj - today > 0) {
            alert("<%=jobDescStr%> �������ڴ� ���÷κ��� ������ �̳����� �մϴ�!");
            return;
        }

        window.returnValue = fromDate + "��" + toDate + "��" + workContent;
        window.close();
    }

</script>


</html>