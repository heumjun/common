<%--  
§DESCRIPTION: 설계시수결재 - 시수 입력율 조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_InputRateViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@page import="java.text.*"%>
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
    String selectRate = StringUtil.setEmptyExt(emxGetParameter(request, "selectRate"));
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
<html>
<head>
    <title>시수입력율 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPInputRateViewMain">

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="2"><td></td></tr>
    </table>
    
    <div id="designHoursInputRate" STYLE="width:100%; height:94%; overflow:auto; position:relative;">
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standardSmall">No</td>
            <td class="td_standardSmall">부서</td>
            <td class="td_standardSmall">사번</td>
            <td class="td_standardSmall">직위</td>
            <td class="td_standardSmall">성명</td>
            <td class="td_standardSmall">상근</td>
            <td class="td_standardSmall">연근</td>
            <td class="td_standardSmall">특근</td>
            <td class="td_standardSmall">입력율</td>
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
            <tr height="15" bgcolor="#ffffff">
                <td class="td_standardSmall"><%=i + 1%></td>
                <td class="td_standardSmall"><%=deptName%></td>
                <td class="td_standardSmall"><%=empNoStr%></td>
                <td class="td_standardSmall"><%=positionStr%></td>
                <td class="td_standardSmall"><%=empNameStr%></td>
                <td class="td_standardSmall"><%=normalTime%></td>
                <td class="td_standardSmall"><%=overtime%></td>
                <td class="td_standardSmall"><%=specialTime%></td>
                <td class="td_standardSmall"><%=inputRatio%>%</td>
            </tr>
            <%
        }
        %>

    </table>
    </div>

    <div id="designHoursInputRateSum" STYLE="width:100%; overflow:hidden; position:relative;">
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="right" bgcolor="#cccccc">
        <tr>
            <td width="20%">&nbsp;</td>
            <td class="td_standardBold"><font color="#ff0000">상근: <%=normalTimeSum%></font></td>
            <td class="td_standardBold"><font color="#ff0000">연근: <%=overtimeSum%></font></td>
            <td class="td_standardBold"><font color="#ff0000">특근: <%=specialTimeSum%></font></td>
            <td class="td_standardBold"><font color="#ff0000">입력율: <%=df.format(totalInputRatio / inputRateList.size())%>%</font></td>
            <td width="10">&nbsp;</td>
        </tr>
    </table>
    </div>

</form>
</body>
</html>