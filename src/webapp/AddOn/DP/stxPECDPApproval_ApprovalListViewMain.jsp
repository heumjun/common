<%--  
��DESCRIPTION: ����ü����� - ������ȸ ȭ�� ���� �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPApproval_ApprovalListViewMain.jsp
��CHANGING HISTORY: 
��    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "fromDate"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "toDate"));

    // From, To Date ������ �ݴ��̸� ��ȣ ��ü�Ѵ� 
    if (!dateFrom.equals("") && !dateTo.equals("")) {
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd"); 
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd"); 
        java.util.Date date1 = sdf1.parse(dateFrom); 
        java.util.Date date2 = sdf1.parse(dateTo); 
        if (date1.after(date2)) {
            String temp = dateFrom;
            dateFrom = dateTo;
            dateTo = temp;
        }
    }

    String errStr = "";

    ArrayList dpApprovalList = null;
    try {
        dpApprovalList = getPartDPConfirmsList(deptCode, dateFrom, dateTo);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>�� �� �� ȸ</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
    //document.onkeydown = keydownHandlerIncludeCloseFunc;
</script>



<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPApprovalListViewMain">

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standardSmall">No</td>
            <td class="td_standardSmall">����</td>
            <td class="td_standardSmall">����</td>
        </tr>

        <%
        for (int i = 0; dpApprovalList != null && i < dpApprovalList.size(); i++) 
        {
            Map map = (Map)dpApprovalList.get(i);

            String workdayStr = (String)map.get("WORK_DAY");
            String confirmYN = (String)map.get("CONFIRM_YN");
            String bgColor = "#ffffff";
            if (confirmYN.equals("N")) bgColor = "#fff0f5";
            %>
            <tr height="15" bgcolor="<%=bgColor%>" ondblclick="callViewDPApprovals('<%=workdayStr%>');">
                <td class="td_standardSmall"><%=i + 1%></td>
                <td class="td_standardSmall"><%=workdayStr%></td>
                <td class="td_standardSmall"><%=confirmYN%></td>
            </tr>
            <%
        }
        %>

    </table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // ���õ� ������ �ü��Է»����� �θ�â�� ǥ��
    function callViewDPApprovals(workdayStr)
    {
        parent.DP_APPRLIST_HEADER.callViewDPApprovals(workdayStr);
    }

</script>

</html>
