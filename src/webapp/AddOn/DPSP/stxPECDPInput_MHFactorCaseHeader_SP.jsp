<%--  
��DESCRIPTION: ����ü����� - �ü� ������(FACTOR) CASE ���� Header �κ� 
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_MHFactorCaseHeader.jsp
��CHANGING HISTORY: 
��    2009-07-27: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // ������ ID : ������(��Ʈ�� ����) or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");       
    boolean isAdmin = false;            // ������ ����

    ArrayList mhFactorCaseList = null;
    String errStr = "";

    // DB���� ������ �����Ͽ� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);
        if (loginUserInfo != null) 
        {
            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 

            if (isAdmin) {
                mhFactorCaseList = getMHFactorCaseList();
            }            
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    String activeCaseNo = "";
    String selectedCaseNo = StringUtil.setEmptyExt(emxGetParameter(request, "selectedCaseNo"));
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>�ü� ������(FACTOR) CASE ����</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript">

    // Admin.�� �ƴϸ� Exit
    <% if (!isAdmin) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPMHFactorCaseHeader">

<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                �۾� �߿� ������ �߻��Ͽ����ϴ�. IT ����ڿ��� �����Ͻñ� �ٶ��ϴ�.<br>
                �ؿ��� �޽���: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>
    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>CASE
                <select name="mhFactorCaseSelect" style="width:160px;" onchange="mhFactorCaseSelChanged();">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; mhFactorCaseList != null && i < mhFactorCaseList.size(); i++) 
                    {
                        Map map = (Map)mhFactorCaseList.get(i);
                        String caseNo = (String)map.get("CASE_NO");
                        String activeCaseYN = (String)map.get("ACTIVE_CASE_YN");
                        String displayStr = "";
                        String selected = "";
                        if (activeCaseYN.equals("Y")) {
                            activeCaseNo = caseNo;
                            displayStr = caseNo + " (* default case)";
                            if (selectedCaseNo.equals("")) selectedCaseNo = activeCaseNo;
                        } else displayStr = caseNo;

                        if (selectedCaseNo.equals(caseNo)) selected = "selected";
                        %>
                        <option value="<%=caseNo%>" <%=selected%>><%=displayStr%></option>
                        <%
                    }
                    %>
                </select>
            </td>
            <td style="text-align:center;">
                <input type="button" name="addButton" value="�� ��" style="width:80px;height:25px;" onclick="addMHFactorCase();" />
            </td>
        </tr>
    </table>

<%
}
%>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    var mhFactorCaseSelectedIdx = 0;

    // �ü� ������ Case �׸� ������ ����Ǵ� ���
    function mhFactorCaseSelChanged()
    {
        // ����� �Է»����� ������ ��������� ���� ����
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "����� ������ �ֽ��ϴ�!\n\n��������� �����ϰ� ��ȸ�� �����Ͻðڽ��ϱ�?";
                if (!confirm(msg)) {
                    DPMHFactorCaseHeader.mhFactorCaseSelect.options.selectedIndex = mhFactorCaseSelectedIdx;
                    return false;
                }
            }
        }

        mhFactorCaseSelectedIdx = DPMHFactorCaseHeader.mhFactorCaseSelect.options.selectedIndex;

        if (DPMHFactorCaseHeader.mhFactorCaseSelect.value == "") 
            parent.DP_MHFACTOR_MAIN.location = "stxPECDPEmpty.htm";
        else {
            var urlStr = "stxPECDPInput_MHFactorCaseMain_SP.jsp?loginID=<%=loginID%>";
            urlStr += "&mhFactorCase=" + DPMHFactorCaseHeader.mhFactorCaseSelect.value;
            if (DPMHFactorCaseHeader.mhFactorCaseSelect.value == "<%=activeCaseNo%>") urlStr += "&isActiveCase=true"; 
            else urlStr += "&isActiveCase=false";
            parent.DP_MHFACTOR_MAIN.location = urlStr;
        }

        return true;
    }

    // �ü� ������ Case �߰�
    function addMHFactorCase()
    {
        // ����� �Է»����� ������ ��������� ���� ����
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "����� ������ �ֽ��ϴ�!\n\n��������� �����ϰ� �����Ͻðڽ��ϱ�?";
                if (!confirm(msg)) return false;
            }
        }

        DPMHFactorCaseHeader.mhFactorCaseSelect.options.selectedIndex = 0;

        var urlStr = "stxPECDPInput_MHFactorCaseMain_SP.jsp?loginID=<%=loginID%>";
        urlStr += "&mhFactorCase=add";
        urlStr += "&isActiveCase=false";
        parent.DP_MHFACTOR_MAIN.location = urlStr;

        return true;
    }

    // Load �� - Selected Case No(�Ǵ� Active Case No)�� ������ �װ��� �����ְ� ������ Add ���� �����ش�
    <% if (!selectedCaseNo.equals("")) { %>
        var urlStr = "stxPECDPInput_MHFactorCaseMain_SP.jsp?loginID=<%=loginID%>";
        urlStr += "&mhFactorCase=<%=selectedCaseNo%>";
        <% if (selectedCaseNo.equals(activeCaseNo)) { %>
            urlStr += "&isActiveCase=true";
        <% } else { %>
            urlStr += "&isActiveCase=false";
        <% } %>
        parent.DP_MHFACTOR_MAIN.location = urlStr;
    <% } else { %>
        addMHFactorCase();
    <% } %>


</script>


</html>