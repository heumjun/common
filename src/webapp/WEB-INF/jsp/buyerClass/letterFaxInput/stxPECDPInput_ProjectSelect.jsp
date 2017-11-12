<%--  
§DESCRIPTION: 설계시수입력 - 호선 선택 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_ProjectSelect.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "../../../../AddOn/DP/stxPECDP_Include.inc" %>
<%@ include file = "../../../../AddOn/DP/stxPECGetParameter_Include.inc" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String designerID = emxGetParameter(request, "designerID");
    String errStr = "";

    ArrayList allProjectList = null;
    ArrayList allModelList = null;
    ArrayList selectedProjectList = null;
    ArrayList invalidSelectedProjectList = null;
    try {
        allProjectList = getAllProjectList(designerID);
        allModelList = getAllModelList();
        selectedProjectList = getSelectedProjectList(designerID);
        invalidSelectedProjectList = getInvalidSelectedProjectList(designerID);

        // 정렬
        for (int i = 0; i < allProjectList.size(); i++) {
            Map map = (Map)allProjectList.get(i);
            String projectNo = (String)map.get("PROJECTNO");
            String dlEffective = (String)map.get("DL_EFFECTIVE");
            if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) {
                projectNo = "Z" + projectNo;
                map.put("PROJECTNO", projectNo);
            }

        }
       // allProjectList.sort("PROJECTNO", "ascending", "string"); DIS-ERROR :sort 기능 대체 필요할 듯.
/*** 2015-01-21 Kang seonjung : Model 정보는 제외 (한경훈 과장 요청)
        for (int i = 0; i < allModelList.size(); i++) {
            Map map = (Map)allModelList.get(i);
            map.put("PROJECTNO", (String)map.get("MODEL_NO"));
            allProjectList.add(map);
        }
***/
        for (int i = 0; i < selectedProjectList.size(); i++) {
            Map map = (Map)selectedProjectList.get(i);
            String projectNo = (String)map.get("PROJECTNO");
            String dlEffective = (String)map.get("DL_EFFECTIVE");
            if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) {
                projectNo = "Z" + projectNo;
                map.put("PROJECTNO", projectNo);
            }
        }
     //   selectedProjectList.sort("PROJECTNO", "ascending", "string");
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
            <input type="button" value="추가 >>" onclick="selectTheSelectedItems();"><br><br>
            <input type="button" value="삭제 <<" onclick="unselectTheSelectedItems();">
        </td>
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">선 택 호 선</font></td>
    </tr>
    <tr>
        <td>
            <select name="allProjectsList" multiple size="14" style="width:140px" onDblClick="selectTheSelectedItems();">
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
                        String projectNoStr = projectNo;
                        if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);
                    %>
                        <option value="<%=projectNo%>" text="<%=projectNoStr%>"><%=projectNoStr%></option>
                    <%
                    }
                } 
                %>
            </select>
        </td>
        <td>
            <select name="allSelectedProjectsList" multiple size="14" style="width:140px" onDblClick="unselectTheSelectedItems();">
                <% 
                if (selectedProjectList == null || invalidSelectedProjectList == null) { 
                %>
                    <option value=""><%=errStr%></option>
                <% 
                } 
                else { 
                    for (int i = 0; i < selectedProjectList.size(); i++) {
                        Map map = (Map)selectedProjectList.get(i);
                        String projectNo = (String)map.get("PROJECTNO");
                        String projectNoStr = projectNo;
                        if (projectNo.startsWith("Z")) projectNo = projectNo.substring(1);
                    %>
                        <option value="<%=projectNo%>" text="<%=projectNoStr%>"><%=projectNoStr%></option>
                    <%
                    }

                    for (int i = 0; i < invalidSelectedProjectList.size(); i++) {
                        Map map = (Map)invalidSelectedProjectList.get(i);
                        String projectNo = (String)map.get("PROJECT_NO");
                    %>
                        <option value="invalid" style="background-color:#ff6347"><%=projectNo%></option>
                    <%
                    }
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

    function selectTheSelectedItems()
    {
        var allProjectsList = DPProjectSelect.allProjectsList;
        var allSelectedProjectsList = DPProjectSelect.allSelectedProjectsList;
        
        for (var i = 0; i < allSelectedProjectsList.options.length; i++) {
            allSelectedProjectsList.options[i].selected = false;
        }

        for (var i = 0; i < allProjectsList.options.length; i++) {
            if (allProjectsList.options[i].value == "null") continue;
            if (allProjectsList.options[i].selected) {
                var alreadySelected = false;
                for (var j = 0; j < allSelectedProjectsList.options.length; j++) {
                    if (allProjectsList.options[i].value == allSelectedProjectsList.options[j].value) {
                        alreadySelected = true;
                        break;
                    }
                }
                if (!alreadySelected) {
                    var newOption = new Option(allProjectsList.options[i].text, allProjectsList.options[i].value);
                    allSelectedProjectsList.options[allSelectedProjectsList.options.length] = newOption;
                }
                allProjectsList.options[i].selected = false;
            }
        }
    }

    function unselectTheSelectedItems()
    {
        var allProjectsList = DPProjectSelect.allProjectsList;
        var allSelectedProjectsList = DPProjectSelect.allSelectedProjectsList;
        
        for (var i = 0; i < allProjectsList.options.length; i++) {
            allProjectsList.options[i].selected = false;
        }

        for (var i = allSelectedProjectsList.options.length - 1; i >= 0; i--) {
            if (allSelectedProjectsList.options[i].value == "null") continue;
            if (allSelectedProjectsList.options[i].selected) {
                allSelectedProjectsList.options[i] = null;
            }
        }
    }
   
    function updateSelectedProjectList()
    {	
        var selectedProjects = "";
        var selectedProjectsStr = "";
        var allSelectedProjectsList = DPProjectSelect.allSelectedProjectsList;
        for (var i = 0; i < allSelectedProjectsList.options.length; i++) {
            if (allSelectedProjectsList.options[i].value == "null") continue;
            if (allSelectedProjectsList.options[i].value == "invalid") { 
                alert("유효하지 않은 호선(: 붉은색 바탕으로 표시)이 있습니다. 해당 항목을 삭제한 후 진행하십시오."); 
                return; 
            }

            if (selectedProjects != "") selectedProjects += "|";
            selectedProjects += allSelectedProjectsList.options[i].value;

            if (selectedProjectsStr != "") selectedProjectsStr += "|"; 
            selectedProjectsStr += allSelectedProjectsList.options[i].text; // 호출한 창으로 돌려줄 값은 'Z' prefix를 포함한 값을 리턴

        }
        
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.onreadystatechange = function() 
		{
           if (xmlHttp.readyState == 4) {
                if (xmlHttp.status == 200) {
					var resultMsg = xmlHttp.responseText;
					//trim 클래스를 못찾으므로 임식적으로 indexof를 적용하여 함
					if (resultMsg != null && resultMsg.indexOf("OK") > 0) {
                        window.returnValue = selectedProjectsStr;
                        window.close();
					}
                    else {
                        alert(resultMsg);
                    }
				}
				else {
					alert(resultMsg);
				}
			}		
		}

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=UpdateSelectedProjects&dpDesignerID=<%=designerID%>&projectList=" + selectedProjects, true);
		xmlHttp.send(null);
    }
    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, ''); 
    }
</script>


</html>