<%--  
§DESCRIPTION: 설계시수결재 - 휴일체크 메인 화면
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_HolidayCheckMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%@page import="java.text.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(request.getParameter("deptCode"));
    String deptName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("deptName")),"UTF-8");
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

    ArrayList holidayMHList = null;
    try {
        holidayMHList = getHolidayMHList(deptCode, dateFrom, dateTo);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>휴 일 체 크</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprHolidayCheckMain">

<table class="insertArea">
        <tr>
            <th>No</th>
            <th>일자</th>
            <th>부서</th>
            <th>사번</th>
            <th>직위</th>
            <th>성명</th>
        </tr>


        <%
        for (int i = 0; holidayMHList != null && i < holidayMHList.size(); i++) 
        {
            Map map = (Map)holidayMHList.get(i);

            String workdayStr = (String)map.get("WORK_DAY");
            String empNoStr = (String)map.get("EMPLOYEE_NO");
            String positionStr = (String)map.get("POSITION");
            String empNameStr = (String)map.get("EMP_NAME");
            %>
            <tr>
                <td><%=i + 1%></td>
                <td><%=workdayStr%></td>
                <td><%=deptName%></td>
                <td><%=empNoStr%></td>
                <td><%=positionStr%></td>
                <td><%=empNameStr%></td>
            </tr>
            <%
        }
        %>


    </table>

</form>
</body>
</html>