<%--  
§DESCRIPTION: 설계시수결재 - 결재조회 화면 Bottom Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_ApprovalListViewBottom.jsp
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
    <title>결 재 조 회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">
    //window.onkeydown = keydownHandlerIncludeCloseFunc;
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalListViewBottom">

    <table width="100%" height="100%" cellSpacing="0" border="0">
        <tr>
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="확 인" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


</html>
