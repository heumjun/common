<%--  
§DESCRIPTION: 공정 지연현황 조회 - 호선 선택 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviationView_ProjectSelect.jsp
§CHANGING HISTORY: 
§    2009-05-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String selectedProjects = StringUtil.setEmptyExt(emxGetParameter(request, "selectedProjects"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));
    //String openedOnly = StringUtil.setEmptyExt(emxGetParameter(request, "openedOnly"));
    boolean openedOnlyB = true;//openedOnly.equalsIgnoreCase("false") ? false : true;
    String sCategory = StringUtil.setEmptyExt(emxGetParameter(request, "category"));

    String errStr = "";

    ArrayList allProjectList = null;
    ArrayList selectedProjectList = null;
    try {
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
            allProjectList = getProgressSearchableProjectList_Dalian(loginID, openedOnlyB, sCategory);
        else allProjectList = getProgressSearchableProjectList(loginID, openedOnlyB, sCategory);

        selectedProjectList = FrameworkUtil.split(selectedProjects, ",");
        
        if(selectedProjectList.size() == 0)
        {
        	ArrayList mlProject = getSaveSelectedPrj(loginID);
        	Iterator itrPrj = mlProject.iterator();
        	while(itrPrj.hasNext())
        	{
        		Map mapPrj = (Map)itrPrj.next();
        		String PROJECT = (String)mapPrj.get("PROJECT");
        		selectedProjectList.add(PROJECT);
        	}
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>호 선 선 택</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProjectSelect">

<table width="100%" cellSpacing="6" border="1" align="center">
    <tr height="2">
        <td colspan="3"></td>
    <tr>
    <tr height="20">
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">전 체 호 선</font></td>
        <td class="td_standard" rowspan="2" width="80">
            <input type="button" value="저장" onclick="saveSelectedItems();"><br><br>
            <input type="button" value="추가 >>" onclick="selectTheSelectedItems();"><br><br>
            <input type="button" value="삭제 <<" onclick="unselectTheSelectedItems();">
        </td>
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">선 택 호 선</font></td>
    </tr>
    <tr>
        <td style="vertical-align:top;">
            <input type="checkbox" name="motherProjectOnly" onclick="showMotherProjectOnly();" /><font color="#0000ff">대표호선만 표시</font><br>
            <select name="allProjectsList" multiple size="13" style="width:140px;height:210px;" onDblClick="selectTheSelectedItems();">
                <% 
                if (allProjectList == null) { 
                %>
                    <option value=""><%=errStr%></option>
                <% 
                } 
                else { 
                    for (int i = 0; i < allProjectList.size(); i++) {
                        Map map = (Map)allProjectList.get(i);
                        String projectNo = (String)map.get("PROJECTNO");
                    %>
                        <option value="<%=projectNo%>"><%=projectNo%></option>
                    <%
                    }
                } 
                %>
            </select>
        </td>
        <td>
            <select name="selectedProjectList" multiple size="14" style="width:140px;height:225px;" onDblClick="unselectTheSelectedItems();">
                <% 
                for (int i = 0; selectedProjectList != null && i < selectedProjectList.size(); i++) 
                {
                    String projectNo = (String)selectedProjectList.get(i);
                %>
                    <option value="<%=projectNo%>"><%=projectNo%></option>
                <%
                }
                %>
            </select>
        </td>
    </tr>
    <tr height="45">
        <td colspan="3" style="vertical-align:middle;text-align:right;">
            <input type="button" value="확인" class="button_simple" onclick="updateSelectedProjectList();">&nbsp;&nbsp;
            <input type="button" value="취소" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 전체호선 목록을 배열에 저장 ('대표호선만 표시' 체크 여부에 대응하기 위해)
    var allProjectsListArray = new Array();
    <% 
    for (int i = 0; i < allProjectList.size(); i++) 
    { 
        Map map = (Map)allProjectList.get(i);
        String projectNo = (String)map.get("PROJECTNO");
        String serialNo = (String)map.get("SERIALNO");
    %>
        allProjectsListArray[<%=i%>] = '<%= projectNo + "|" + serialNo %>';
    <%
    }
    %>
    
    function saveSelectedItems() 
    {
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
		
		var projects = "";
		
		var optionPrj = DPProjectSelect.selectedProjectList.options;
		for(var i= 0 ;i<optionPrj.length;i++)
		{
			projects += (projects == "")?optionPrj[i].value:","+optionPrj[i].value;
		}
		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=saveSelectedProjects&loginID=<%=loginID%>&projects="+projects, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;

                if (resultMsg != null) 
                {
                    resultMsg = resultMsg.trim();
                    alert(resultMsg);
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // 전체호선에서 선택된 항목을 '선택된 호선' 목록에 반영
    function selectTheSelectedItems()
    {
        var allProjectsList = DPProjectSelect.allProjectsList;
        var selectedProjectList = DPProjectSelect.selectedProjectList;
        
        for (var i = 0; i < selectedProjectList.options.length; i++) {
            selectedProjectList.options[i].selected = false;
        }

        for (var i = 0; i < allProjectsList.options.length; i++) {
            if (allProjectsList.options[i].value == "null") continue;
            if (allProjectsList.options[i].selected) {
                var alreadySelected = false;
                for (var j = 0; j < selectedProjectList.options.length; j++) {
                    if (allProjectsList.options[i].value == selectedProjectList.options[j].value) {
                        alreadySelected = true;
                        break;
                    }
                }
                if (!alreadySelected) {
                    var newOption = new Option(allProjectsList.options[i].text, allProjectsList.options[i].value);
                    selectedProjectList.options[selectedProjectList.options.length] = newOption;
                }
                allProjectsList.options[i].selected = false;
            }
        }
    }

    // '선택된 호선'에서 항목 제거
    function unselectTheSelectedItems()
    {
        var allProjectsList = DPProjectSelect.allProjectsList;
        var selectedProjectList = DPProjectSelect.selectedProjectList;
        
        for (var i = 0; i < allProjectsList.options.length; i++) {
            allProjectsList.options[i].selected = false;
        }

        for (var i = selectedProjectList.options.length - 1; i >= 0; i--) {
            if (selectedProjectList.options[i].value == "null") continue;
            if (selectedProjectList.options[i].selected) {
                selectedProjectList.options[i] = null;
            }
        }
    }

    // 대표호선만 표시 여부를 반영
    function showMotherProjectOnly()
    {
        // 전체호선 OPTION 항목들을 모두 삭제
        for (var i = DPProjectSelect.allProjectsList.options.length - 1; i >= 0; i--) DPProjectSelect.allProjectsList.options[i] = null;

        // '대표호선만 표시' 체크 여부에 따라 전체호선 또는 대표호선만 전체호선 OPTION 항목으로 생성
        var idx = 0;
        for (var i = 0; i < allProjectsListArray.length; i++) {
            var str = allProjectsListArray[i];
            var strs = str.split("|");
            // '대표호선만 표시' 체크이면 대표호선만 추가
            if (DPProjectSelect.motherProjectOnly.checked) {
                if (strs[1] == "0") DPProjectSelect.allProjectsList.options[idx++] = new Option(strs[0], strs[0]);
            }
            // '대표호선만 표시' 체크가 아니면 모든 호선 추가
            else {
                DPProjectSelect.allProjectsList.options[idx++] = new Option(strs[0], strs[0]);
            }
        }
    }

    // 모달 창을 닫으면서 '선택된 호선' 목록을 리턴
    function updateSelectedProjectList()
    {
        var selectedProject = "";
        var selectedProjectList = DPProjectSelect.selectedProjectList;

        for (var i = 0; i < selectedProjectList.options.length; i++) {
            if (selectedProjectList.options[i].value == "null") continue;
            if (selectedProject != "") selectedProject += ",";
            selectedProject += selectedProjectList.options[i].value;
        }

        window.returnValue = selectedProject;
        window.close();
    }

</script>


</html>