<%--  
§DESCRIPTION: 설계시수결재 - 휴일체크 메인 화면
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_HolidayCheckMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ page import="java.text.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String deptName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "deptName")),"UTF-8");
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "fromDate"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "toDate"));

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
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPApprHolidayCheckMain">

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standardSmall">No</td>
            <td class="td_standardSmall">일자</td>
            <td class="td_standardSmall">부서</td>
            <td class="td_standardSmall">사번</td>
            <td class="td_standardSmall">직위</td>
            <td class="td_standardSmall">성명</td>
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
            <tr height="15" bgcolor="#ffffff">
                <td class="td_standardSmall"><%=i + 1%></td>
                <td class="td_standardSmall"><%=workdayStr%></td>
                <td class="td_standardSmall"><%=deptName%></td>
                <td class="td_standardSmall"><%=empNoStr%></td>
                <td class="td_standardSmall"><%=positionStr%></td>
                <td class="td_standardSmall"><%=empNameStr%></td>
            </tr>
            <%
        }
        %>


    </table>

</form>
</body>
</html>