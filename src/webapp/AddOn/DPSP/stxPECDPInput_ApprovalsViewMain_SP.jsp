<%--  
§DESCRIPTION: 설계시수입력 - 결재조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_ApprovalsViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>
<%@page import="java.text.*"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String userID = emxGetParameter(request, "userID");
    String userName = URLDecoder.decode(emxGetParameter(request, "userName"),"UTF-8");
    String fromDate = emxGetParameter(request, "fromDate");
    String toDate = emxGetParameter(request, "toDate");

    // From, To Date 순서가 반대이면 상호 교체한다 
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd"); 
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd"); 
    java.util.Date date1 = sdf1.parse(fromDate); 
    java.util.Date date2 = sdf1.parse(toDate); 
    if (date1.after(date2)) {
        String temp = fromDate;
        fromDate = toDate;
        toDate = temp;
    }

    String errStr = "";

    ArrayList confirmYNList = null;
    try {
        confirmYNList = getDesignMHConfirmYNs(userID, fromDate, toDate);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>결 재 체 크</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPApprovalsViewMain">

<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                ※에러 메시지: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0">
        <tr height="15">
            <td class="td_standardSmall" style="text-align:left;color:#A4AAA7;font-size:8pt;">
                <%=fromDate%>&nbsp;~&nbsp;<%=toDate%>&nbsp;(<%=userName%>)&nbsp;
            </td>
        </tr>
    </table>
    
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#000000">
        <tr height="18" bgcolor="#e5e5e5">
            <td class="td_standard">일자</td>
            <td class="td_standard">정상</td>
            <td class="td_standard">연장</td>
            <td class="td_standard">특근</td>
            <td class="td_standard">완료</td>
            <td class="td_standard">결재</td>
        </tr>

        <%
        for (int i = 0; i < confirmYNList.size(); i++)
        {
            Map map = (Map)confirmYNList.get(i);
            String dateStr = (String)map.get("WORKINGDAY");
            String employeeNo = (String)map.get("EMPLOYEE_NO");
            String isWorkday = (String)map.get("ISWORKDAY");
            String normalTime = (String)map.get("NORMAL");
            String overtime = (String)map.get("OVERTIME");
            String specialTime = (String)map.get("SPECIAL");
            String inputDoneYN = (String)map.get("INPUTDONE_YN");
            String confirmYN = (String)map.get("CONFIRM_YN");

            if (!isWorkday.equals("Y") && employeeNo.equals("")) { continue; }
            
            String bgColor = "#ffffff";
            if (inputDoneYN.equals("Y") && confirmYN.equals("N")) bgColor = "#fff0f5";
            else if (!inputDoneYN.equals("Y")){
                bgColor = "#d8bfd8";
                //normalTime = "";
                //overtime = "";
                //specialTime = "";
                confirmYN = "";
            }

            %>
            <tr height="18" bgcolor="<%=bgColor%>" ondblclick="javascript:showDPInputsOnParent('<%=dateStr%>');">
                <td class="td_standard"><%=dateStr%></td>
                <td class="td_standard"><%=normalTime%></td>
                <td class="td_standard"><%=overtime%></td>
                <td class="td_standard"><%=specialTime%></td>
                <td class="td_standard"><%=inputDoneYN%></td>
                <td class="td_standard" style="font-weight:bold;<%if(confirmYN.equals("N")){%>color:#ff0000;<%}%>"><%=confirmYN%></td>
            </tr>
            <%
        }
        %>
    </table>
<%
}
%>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 선택된 일자의 시수입력사항을 부모창에 표시
    function showDPInputsOnParent(dateStr)
    {
        parent.DP_APPRVIEW_HEADER.callViewDPInputs(dateStr);
    }

    // 프린트(리포트 출력)
    function printPage()
    {
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput_ApprovalsView.mrd&param=" +
                     "<%=fromDate%>:::" + "<%=toDate%>:::" + "<%=userID%>";
        window.open(urlStr, "", "");
    }

</script>


</html>
