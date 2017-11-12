<%--  
§DESCRIPTION: 설계시수결재 - 결재조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_ApprovalListViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(request.getParameter("deptCode"));
    String dateFrom = StringUtil.setEmptyExt(request.getParameter("fromDate"));
    String dateTo = StringUtil.setEmptyExt(request.getParameter("toDate"));

    // From, To Date 순서가 반대이면 상호 교체한다 
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
    <title>결 재 조 회</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>

<script language="javascript">
    //document.onkeydown = keydownHandlerIncludeCloseFunc;
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalListViewMain">
    <table class="insertArea">
        <tr>
            <th>No</th>
            <th>일자</th>
            <th>결재</th>
        </tr>

        <%
        for (int i = 0; dpApprovalList != null && i < dpApprovalList.size(); i++) 
        {
            Map map = (Map)dpApprovalList.get(i);

            String workdayStr = (String)map.get("WORK_DAY");
            String confirmYN = (String)map.get("CONFIRM_YN");
            String bgColor = "";
            if (confirmYN.equals("N")) bgColor = "#fff0f5";
            %>
            <tr bgcolor="<%=bgColor%>" ondblclick="callViewDPApprovals('<%=workdayStr%>');">
                <td><%=i + 1%></td>
                <td><%=workdayStr%></td>
                <td><%=confirmYN%></td>
            </tr>
            <%
        }
        %>

    </table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 선택된 일자의 시수입력사항을 부모창에 표시
    function callViewDPApprovals(workdayStr)
    {
        parent.callViewDPApprovals(workdayStr);
    }

</script>

</html>
