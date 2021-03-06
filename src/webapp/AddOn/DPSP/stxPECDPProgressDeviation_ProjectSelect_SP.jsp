<%--  
§DESCRIPTION: 공정지연현황 - 조회가능 호선관리 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviation_ProjectSelect.jsp
§CHANGING HISTORY: 
§    2009-06-11: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
    String category = emxGetParameter(request, "category");
    String errStr = "";

    ArrayList allProjectList = null;
    try {
        allProjectList = getProgressSearchableProjectList(loginID, false, category);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>조회가능 호선관리</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProjectSelect">

<table width="100%" cellSpacing="0" cellpadding="6" border="0" align="center">
    <tr>
    <td style="vertical-align:top;">
        <div STYLE="height:280; overflow:auto; position:relative;">
        <table width="100%" cellSpacing="0" cellpadding="0" border="1" align="center">
            <tr height="20">
                <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">호 선</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="130"><font color="#ffffff">조회가능</font></td>
            </tr>
            
            <%
            for (int i = 0; allProjectList != null && i < allProjectList.size(); i++) 
            {
                Map map = (Map)allProjectList.get(i);
                String projectNo = (String)map.get("PROJECTNO");
                String state = (String)map.get("STATE");
                String colorStr = "#ffffff";
                if (state.equals("CLOSED")) colorStr = "#fff0f5";
                if (state.equals("ALL")) state = "OPEN";
                %>
                <tr height="20"  style="background-color:<%=colorStr%>">
                    <td width="140" class="td_standard"><%=projectNo%></td>
                    <td width="130" class="td_standard" ondblclick="toggleStateStr('<%=projectNo%>', this);"><%=state%></td>
                </tr>
                <%
            }
            %>
        </table>
        </div>
    </td>
    </tr>

    <tr height="45">
        <td style="vertical-align:middle;text-align:right;">
            <hr>
            <input type="button" value="확인" class="button_simple" onclick="updateSearchableProjectList();">&nbsp;&nbsp;
            <input type="button" value="취소" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>

</table>


</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    var changedList = new Array();

    // 상태(Opened - Closed) 값을 Toggle
    function toggleStateStr(projectNo, tdObject)
    {
        var str = tdObject.innerHTML;
        if (str == "OPEN") tdObject.innerHTML = "CLOSED";
        else if (str == "CLOSED") tdObject.innerHTML = "OPEN";

        str = tdObject.innerHTML;
        if (str == "OPEN") str = "ALL";
        
        var isExist = false;
        for (var i = 0; i < changedList.length; i++) {
            if (changedList[i].indexOf(projectNo + "|") >= 0) {
                changedList[i] = projectNo + "|" + str;
                break;
            }
        }
        if (!isExist) changedList[changedList.length] = projectNo + "|" + str;
    }
    
    // 변경사항을 저장(DB에 적용)
    function updateSearchableProjectList()
    {
        if (changedList.length <= 0) {
            alert("변경사항이 하나도 없습니다!");
            return;
        }
        
        var params = "";
        for (var i = 0; i < changedList.length; i++) {
            if (i > 0) params += ",";
            params += changedList[i];
        }

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=UpdateSearchableProjectList&params=" + params + 
                            "&loginID=<%=loginID%>&category=<%=category%>", false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            

            if (resultMsg != null && resultMsg.trim() == "OK") {
                alert("저장 완료!");
                window.returnValue = params;
                window.close();
            }
            else alert(resultMsg.trim());
        } 
        else alert("ERROR");
    }

</script>


</html>