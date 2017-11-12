<%--  
��DESCRIPTION: ����ü��Է� - �ÿ��� �Ⱓ ���� â
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_SeaTrialPeriodSelect.jsp
��CHANGING HISTORY: 
��    2009-06-03: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String designerID = emxGetParameter(request, "designerID");
    
    ArrayList selectedProjectList = null;
    try {
        selectedProjectList = getSelectedProjectList(designerID);
    }
    catch (Exception e) {
        selectedProjectList = null;
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>�ÿ��� �Ⱓ ����</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPSeaTrialPeriodSelect">

    <table width="100%" cellPadding="5" border="0" align="center">
        <tr height="28">
            <td style="font-family:����;font-weight:bold;font-size:11pt;">�ÿ��� ȣ���� �Ⱓ�� �����Ͻʽÿ�!</td>
        </tr>
    </table>

    <table width="100%" cellPadding="8" border="0" align="center" style="background-color:#ffffff">
        <tr  height="5"><td colspan="2"></td></tr>
        <tr>
            <td style="width:100px;">
                <b>�����ȣ</b>
            </td>
            <td>
                <select name="projectSel" style="width:110px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; selectedProjectList != null && i < selectedProjectList.size(); i++) 
                    {
                        Map map = (Map)selectedProjectList.get(i);
                        String projectNo = (String)map.get("PROJECTNO");
                        String dlEffective = (String)map.get("DL_EFFECTIVE");
                        if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNo = "Z" + projectNo;
                    %>
                        <option value="<%=projectNo%>"><%=projectNo%></option>
                    <%
                    }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td style="width:100px;">
                <b>�ÿ��� ���۽ð�</b>
            </td>
            <td>
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPSeaTrialPeriodSelect', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                &nbsp;&nbsp;<b>:</b>&nbsp;&nbsp;
                <select name="fromTimeSel" style="width:80px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; i < timeKeys.length; i++) 
                    {
                        String timeKey = timeKeys[i];
                        if (timeKey == "1230") continue;
                        String timeKeyStr = timeKey.substring(0, 2) + ":" + timeKey.substring(2);
                    %>
                        <option value="<%=timeKey%>"><%=timeKeyStr%></option>
                    <%
                    }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td style="width:100px;">
                <b>�ÿ��� ����ð�</b>
            </td>
            <td>
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPSeaTrialPeriodSelect', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                &nbsp;&nbsp;<b>:</b>&nbsp;&nbsp;
                <select name="toTimeSel" style="width:80px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; i < timeKeys.length; i++) 
                    {
                        String timeKey = timeKeys[i];
                        if (timeKey == "1230") continue;
                        String timeKeyStr = timeKey.substring(0, 2) + ":" + timeKey.substring(2);
                    %>
                        <option value="<%=timeKey%>"><%=timeKeyStr%></option>
                    <%
                    }
                    %>
                </select>
            </td>
        </tr>
        <tr  height="5"><td colspan="2"></td></tr>
    </table>

    <table width="100%" cellPadding="5" cellSpacing="0" border="1" align="center">
        <tr height="50">
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
        var tmpStr1 = DPSeaTrialPeriodSelect.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPSeaTrialPeriodSelect.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPSeaTrialPeriodSelect.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPSeaTrialPeriodSelect.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // Ȯ��
    function selectSubmit()
    {
        var projectNo = DPSeaTrialPeriodSelect.projectSel.value;
        var fromDate = DPSeaTrialPeriodSelect.dateSelectedFrom.value;
        var fromTime = DPSeaTrialPeriodSelect.fromTimeSel.value;
        var toDate = DPSeaTrialPeriodSelect.dateSelectedTo.value;
        var toTime = DPSeaTrialPeriodSelect.toTimeSel.value;

        if (projectNo == '') {
            alert('�����ȣ�� �����Ͻʽÿ�!');
            return;
        }
        if (fromDate == '' || fromTime == '' || toDate == '' || toTime == '') {
            alert('���� �� ����ð��� �����Ͻʽÿ�!');
            return;
        }
        if (fromDate == toDate && fromTime == toTime) {
            alert('���۽ð��� ����ð��� �����ϴ�!');
            return;
        }

        // ����-���� ������ �ݴ��̸� ����
        var tempStrs = fromDate.split("-");
        var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        tempStrs = toDate.split("-");
        var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
        if (fromDateObj > toDateObj) {
            var temp = toDate;
            toDate = fromDate;
            fromDate = temp;
            temp = toTime;
            toTime = fromTime;
            fromTime = temp;
        }
        // ����-�������� ���� ����-���� �ð��� �ݴ��̸� ����
        else if (fromDateObj == toDateObj) {
            fromIndex = DPSeaTrialPeriodSelect.fromTimeSel.selectedIndex;
            toIndex = DPSeaTrialPeriodSelect.toTimeSel.selectedIndex;
            if (fromIndex > toIndex) {
                var temp = toTime;
                toTime = fromTime;
                fromTime = temp;
            }
        }

        window.returnValue = projectNo + "~" + fromDate + "|" + fromTime + "~" + toDate + "|" + toTime;
        window.close();
    }

</script>


</html>