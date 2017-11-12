<%--  
§DESCRIPTION: 도면 출도대장(Hard Copy) 항목 등록 화면 Bottom Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgCreateBottom.jsp
§CHANGING HISTORY: 
§    2010-03-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPHardCopyDwgCreateBottom">

    <table width="100%" height="100%" cellSpacing="0" border="0">
        <tr>
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="Save" class="button_simple" onclick="createHardCopyData();">&nbsp;&nbsp;
                <input type="button" value="Cancel" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 도면 출도대장(Hard Copy) 항목 등록
    function createHardCopyData()
    {
        parent.HARDCOPY_CREATE_MAIN.createHardCopyData();
    }

</script>


</html>