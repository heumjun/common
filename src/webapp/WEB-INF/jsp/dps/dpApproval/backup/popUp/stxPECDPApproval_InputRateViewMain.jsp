<%--  
§DESCRIPTION: 설계시수결재 - 시수 입력율 조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_InputRateViewMain.jsp
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
    String selectRate = StringUtil.setEmptyExt(request.getParameter("selectRate"));
    boolean under100Only = selectRate.equalsIgnoreCase("all") ? false : true;

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

    ArrayList inputRateList = null;
    try {
        inputRateList = getInputRateList(deptCode, dateFrom, dateTo, under100Only);
    }
    catch (Exception e) {
        errStr = e.toString();
    }


    float normalTimeSum = 0;
    float overtimeSum = 0;
    float specialTimeSum = 0;
    float totalInputRatio = 0;

    java.text.DecimalFormat df = new java.text.DecimalFormat("###.#"); 
%>


<%--========================== HTML HEAD ===================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>시수입력율 조회</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputRateViewMain">
   
    <div id="designHoursInputRate" STYLE="width:100%; height:280px; overflow:auto; position:relative;">
    <table class="insertArea">
        <tr>
            <th>No</th>
            <th>부서</th>
            <th>사번</th>
            <th>직위</th>
            <th>성명</th>
            <th>상근</th>
            <th>연근</th>
            <th>특근</th>
            <th>입력율</th>
        </tr>

        <%
        for (int i = 0; inputRateList != null && i < inputRateList.size(); i++) 
        {
            Map map = (Map)inputRateList.get(i);

            String empNoStr = (String)map.get("EMPLOYEE_NO");
            String positionStr = (String)map.get("POSITION");
            String empNameStr = (String)map.get("EMP_NAME");
            String normalTime = (String)map.get("NORMAL_TIME");
            String overtime = (String)map.get("OVERTIME");
            String specialTime = (String)map.get("SPECIAL_TIME");
            String inputRatio = (String)map.get("INPUT_RATIO");

            normalTimeSum += Float.parseFloat(normalTime);
            overtimeSum += Float.parseFloat(overtime);
            specialTimeSum += Float.parseFloat(specialTime);
            totalInputRatio += Float.parseFloat(inputRatio);
            %>
            <tr>
                <td><%=i + 1%></td>
                <td><%=deptName%></td>
                <td><%=empNoStr%></td>
                <td><%=positionStr%></td>
                <td><%=empNameStr%></td>
                <td><%=normalTime%></td>
                <td><%=overtime%></td>
                <td><%=specialTime%></td>
                <td><%=inputRatio%>%</td>
            </tr>
            <%
        }
        %>

    </table>
    </div>
    <div id="designHoursInputRateSum" style="width:100%; overflow:hidden; position:relative;">
    <table width="100%" height="30px" cellSpacing="1" cellpadding="0" border="0" align="center" style="text-align:center;color:#ff0000;font-size:12pt;">
        <tr>
            <td><font ><b>상근: <%=normalTimeSum%></b></font></td>
            <td><font ><b>연근: <%=overtimeSum%></b></font></td>
            <td><font ><b>특근: <%=specialTimeSum%></b></font></td>
            <td><font ><b>입력율: <%=df.format(totalInputRatio / inputRateList.size())%>%</b></font></td>
        </tr>
    </table>
    </div>

</form>
</body>
</html>