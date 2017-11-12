<%--  
��DESCRIPTION: ����ü����� - ����üũ ��� ���� �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPApproval_HolidayCheckHeader.jsp
��CHANGING HISTORY: 
��    2009-04-09: Initiative
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
    <title>�� �� ü ũ</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprHolidayCheckHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>����
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprHolidayCheckHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprHolidayCheckHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td style="text-align:center;">
                <input type="button" name="viewButton" value="�� ȸ" style="width:60px;height:25px;" onclick="viewHolidayMHList();" />
                <input type="button" name="viewButton" value="�� ��" style="width:60px;height:25px;" onclick="viewReport();" />
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    var deptCode = (window.dialogArguments).deptCode;
    var deptName = (window.dialogArguments).deptName;

    // Į���ٸ� ���� ��¥���� �� ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr1 = DPApprHolidayCheckHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPApprHolidayCheckHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPApprHolidayCheckHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPApprHolidayCheckHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From ��¥ ���� �� To ��¥�� �ش� �� ���Ϸ� �ڵ� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPApprHolidayCheckHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPApprHolidayCheckHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // ����üũ ���� - ����üũ ����ȭ��(Content ȭ��)�� �ε��Ѵ�
    function viewHolidayMHList()
    {
        var urlStr = "stxPECDPApproval_HolidayCheckMain_SP.jsp";
        urlStr += "?deptCode=" + deptCode;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&fromDate=" + DPApprHolidayCheckHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPApprHolidayCheckHeader.dateSelectedTo.value;

        parent.DP_HOLIDAY_MAIN.location = urlStr;
    }

    // ����Ʈ(����Ʈ ���)
    function viewReport()
    {
        var paramStr = deptCode + ":::" + 
                       DPApprHolidayCheckHeader.dateSelectedFrom.value + ":::" + 
                       DPApprHolidayCheckHeader.dateSelectedTo.value; 
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPApproval_HolidayCheck.mrd&param=" + paramStr;
        window.open(urlStr, "", "");
    }

    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� �ش� �� 1�� ~ ���� �������� �����ϰ� ��ȸ â�� �ε� */   
    // ���� ��¥
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    var toYMD = y1 + "-" + m1 + "-" + d1;
    // �ش� �� 1��
    var fromYMD = y1 + "-" + m1 + "-01";    
    // �ʱ� From, To ��¥ ����
    DPApprHolidayCheckHeader.dateSelectedTo.value = toYMD;
    DPApprHolidayCheckHeader.dateSelectedFrom.value = fromYMD;

    // ��ȸ â�� �ε�
    viewHolidayMHList();

</script>

</html>