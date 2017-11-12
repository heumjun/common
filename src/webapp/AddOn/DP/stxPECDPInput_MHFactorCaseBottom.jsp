<%--  
��DESCRIPTION: ����ü����� - �ü� ������(FACTOR) CASE ���� Bottom �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_MHFactorCaseBottom.jsp
��CHANGING HISTORY: 
��    2009-07-27: Initiative
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
    <title>�ü� ������(FACTOR) CASE ����</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPMHFactorCaseBottom">

    <table width="100%" height="100%" cellSpacing="0" border="0">
        <tr>
            <td style="vertical-align:middle;text-align:right;">
                <input type="button" value="�� ��" class="button_simple" onclick="saveAddedMHFactorCase();">&nbsp;&nbsp;
                <input type="button" value="�� ��" class="button_simple" onclick="closeWindow();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // �߰����� ����
    function saveAddedMHFactorCase()
    {
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) 
            parent.DP_MHFACTOR_MAIN.saveAddedMHFactorCase();
    }

    // â �ݱ�
    function closeWindow()
    {
        // ����� �Է»����� ������ ��������� ���� ����
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "����� ������ �ֽ��ϴ�!\n\n��������� �����ϰ� �۾��� �����Ͻðڽ��ϱ�?";
                if (!confirm(msg)) return false;
            }
        }

        parent.window.close();
    }

</script>


</html>