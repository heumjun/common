<%--  
��DESCRIPTION: ����ü��Է� - ������ȸ ȭ�� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_ApprovalsViewHeader.jsp
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
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalsViewHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>����
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalsViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalsViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td style="text-align:center;">
                <input type="button" name="viewButton" value="�� ȸ" style="width:80px;height:25px;" onclick="viewConfirmYNs();" />
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

    // Į���ٸ� ���� ��¥���� �� ��¥ ��� ���ڿ��� ����ȭ
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

    // From ��¥ ���� �� To ��¥�� �ش�� ������ ���� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPApprovalsViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPApprovalsViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;
    }

    // ������ȸ ���� - ������ȸ ����ȭ��(Content ȭ��)�� �ε��Ѵ�
    function viewConfirmYNs()
    {
        var urlStr = "stxPECDPInput_ApprovalsViewMain.jsp";
        urlStr += "?userID=" + userID;
        urlStr += "&userName=" + escape(encodeURIComponent(userName));
        urlStr += "&fromDate=" + DPApprovalsViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPApprovalsViewHeader.dateSelectedTo.value;

        parent.DP_APPRVIEW_MAIN.location = urlStr;
    }

    // ���õ� ������ �ü��Է� ������ Main â�� ǥ��
    function callViewDPInputs(dateStr)
    {
        callerObject.callViewDPInputs(dateStr);
    }


    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� ���� ��¥ & -1�� �� �������� �����ϰ� ������ȸ â�� �ε� */   
    // ���� ��¥
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    // ���� ��¥ - 7��
    var weekAgoDay = new Date(today - (3600000 * 24 * 7));
    var y2 = weekAgoDay.getFullYear().toString();
    var m2 = (weekAgoDay.getMonth() + 1).toString();
    if (m2.length == 1) m2 = 0 + m2;
    var d2 = weekAgoDay.getDate().toString();
    if (d2.length == 1) d2 = 0 + d2;
    // �ʱ� From, To ��¥ ����
    var toYMD = y1 + "-" + m1 + "-" + d1;
    var fromYMD = y2 + "-" + m2 + "-" + d2;    
    DPApprovalsViewHeader.dateSelectedTo.value = toYMD;
    DPApprovalsViewHeader.dateSelectedFrom.value = fromYMD;
    // ������ȸ â�� �ε�
    viewConfirmYNs();

</script>


</html>