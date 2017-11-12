<%--  
§DESCRIPTION: 설계시수관리 - 시수 적용율(FACTOR) CASE 관리 Bottom 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_MHFactorCaseBottom.jsp
§CHANGING HISTORY: 
§    2009-07-27: Initiative
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
    <title>시수 적용율(FACTOR) CASE 관리</title>
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
                <input type="button" value="적 용" class="button_simple" onclick="saveAddedMHFactorCase();">&nbsp;&nbsp;
                <input type="button" value="닫 기" class="button_simple" onclick="closeWindow();">&nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 추가사항 저장
    function saveAddedMHFactorCase()
    {
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) 
            parent.DP_MHFACTOR_MAIN.saveAddedMHFactorCase();
    }

    // 창 닫기
    function closeWindow()
    {
        // 사용자 입력사항이 있으면 변경사항을 먼저 저장
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 작업을 종료하시겠습니까?";
                if (!confirm(msg)) return false;
            }
        }

        parent.window.close();
    }

</script>


</html>