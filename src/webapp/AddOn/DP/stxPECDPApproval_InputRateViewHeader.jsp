<%--  
��DESCRIPTION: ����ü����� - �ü� �Է��� ��ȸ ȭ�� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPApproval_InputRateViewHeader.jsp
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
    <title>�ü��Է��� ��ȸ</title>
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
            <td>����
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputRateViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputRateViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="viewButton" value="�� ȸ" style="width:80px;height:25px;" onclick="viewInputRateList();" />
                <input type="button" name="printButton" value="�� ��" style="width:80px;height:25px;" onclick="viewReport();" />
            </td>
        </tr>

        <tr height="28">
            <td>&nbsp;</td>
            <td>
                <input type="radio" name="selectRate" value="all" id="selectRate1" /><label for="selectRate1">�� ü&nbsp;&nbsp;</label>
                <input type="radio" name="selectRate" value="under100" checked id="selectRate2" /><label for="selectRate2">�Է��� < 100</label>
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
        var tmpStr1 = DPInputRateViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPInputRateViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From ��¥ ���� �� To ��¥�� �ش� �� ���Ϸ� �ڵ� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPInputRateViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPInputRateViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // �Է�����ȸ ���� - ����ȭ��(Content ȭ��)�� �ε��Ѵ�
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

    // ����Ʈ(����Ʈ ���)
    function viewReport()
    {
        var paramStr = deptCode + ":::" + 
                       DPInputRateViewHeader.dateSelectedFrom.value + ":::" + 
                       DPInputRateViewHeader.dateSelectedTo.value + ":::";
        paramStr += DPInputRateViewHeader.selectRate[1].checked  ? "Y" : "";
                       
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPApproval_InputRatesView.mrd&param=" + paramStr;
        window.open(urlStr, "", "");
    }

    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� �ش� �� 1�� ~ ���� �������� ���� */   
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
    DPInputRateViewHeader.dateSelectedTo.value = toYMD;
    DPInputRateViewHeader.dateSelectedFrom.value = fromYMD;

    // ��ȸ â�� �ε�
    viewInputRateList();

</script>


</html>