<%--  
��DESCRIPTION: ����ü��Է� - �Է½ü� ��ȸ Bottom Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_InputListViewBottom.jsp
��CHANGING HISTORY: 
��    2009-04-09: Initiative
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
    <title>�� �� ü ũ</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputListViewBottom">

    <table width="100%" height="100%" cellSpacing="0" border="0">
        <tr>
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="��� & ����" class="button_simple" style="width:100px;" onclick="printPage();">&nbsp;&nbsp;
                <!--<input type="button" value="�� ��" class="button_simple" onclick="alert('PRINT');">&nbsp;&nbsp;-->
                <input type="button" value="Ȯ ��" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // ����ȭ�� ����Ʈ
    function printPage()
    {
        parent.DP_VIEW_HEADER.printPage();
    }

</script>

</html>