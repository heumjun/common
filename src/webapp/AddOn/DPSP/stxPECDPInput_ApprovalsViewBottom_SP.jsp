<%--  
§DESCRIPTION: 설계시수입력 - 결재조회 화면 Bottom Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_ApprovalsViewBottom.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
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
    <title>결 재 체 크</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalsViewBottom">

    <table width="100%" height="100%" cellSpacing="0" border="0">
        <tr>
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="출 력" class="button_simple" onclick="printPage();">&nbsp;&nbsp;
                <input type="button" value="확 인" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 메인화면 프린트
    function printPage()
    {
        parent.DP_APPRVIEW_MAIN.printPage();
    }

</script>


</html>