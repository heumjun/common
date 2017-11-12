<%--  
§DESCRIPTION: 설계시수관리 - 시수 적용율(FACTOR) CASE 관리 Header 부분 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_MHFactorCaseHeader.jsp
§CHANGING HISTORY: 
§    2009-07-27: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // 접속자 ID : 설계자(파트장 포함) or 관리자(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");       
    boolean isAdmin = false;            // 관리자 여부

    ArrayList mhFactorCaseList = null;
    String errStr = "";

    // DB에서 데이터 쿼리하여 값 설정
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
    <title>시수 적용율(FACTOR) CASE 관리</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript">

    // Admin.이 아니면 Exit
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
                <input type="button" name="addButton" value="추 가" style="width:80px;height:25px;" onclick="addMHFactorCase();" />
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

    // 시수 적용율 Case 항목 선택이 변경되는 경우
    function mhFactorCaseSelChanged()
    {
        // 사용자 입력사항이 있으면 변경사항을 먼저 저장
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 조회를 실행하시겠습니까?";
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

    // 시수 적용율 Case 추가
    function addMHFactorCase()
    {
        // 사용자 입력사항이 있으면 변경사항을 먼저 저장
        if (parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain != null) {
            var dataChanged = parent.DP_MHFACTOR_MAIN.DPMHFactorCaseMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 진행하시겠습니까?";
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

    // Load 시 - Selected Case No(또는 Active Case No)가 있으면 그것을 보여주고 없으면 Add 모드로 보여준다
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