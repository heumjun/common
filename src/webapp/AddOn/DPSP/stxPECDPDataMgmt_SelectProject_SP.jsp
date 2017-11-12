<%--  
��DESCRIPTION: ����ü� DATA ���� - ȣ�� ���� â
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPDataMgmt_SelectProject.jsp
��CHANGING HISTORY: 
��    2009-08-19: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String selectedProjects = StringUtil.setEmptyExt(emxGetParameter(request, "selectedProjects"));

    String errStr = "";

    ArrayList allProjectList = null;
    ArrayList allModelList = null;
    ArrayList selectedProjectList = null;

    try {
        allProjectList = getAllProjectList(null);
        allModelList = getAllModelList();
        selectedProjectList = FrameworkUtil.split(selectedProjects, ",");

        HashMap tempMap = new HashMap();
        tempMap.put("PROJECTNO", "S000");
        allProjectList.add(tempMap);

        for (int i = 0; i < allModelList.size(); i++) {
            Map map = (Map)allModelList.get(i);
            map.put("PROJECTNO", (String)map.get("MODEL_NO"));
            allProjectList.add(map);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>ȣ �� �� ��</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProjectSelect">

<table width="100%" cellSpacing="6" border="1" align="center">
    <tr height="2">
        <td colspan="3"></td>
    <tr>
    <tr height="20">
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">�� ü ȣ ��</font></td>
        <td class="td_standard" rowspan="2" width="80">
            <input type="button" value="�߰� >>" onclick="selectTheSelectedItems();"><br><br>
            <input type="button" value="���� <<" onclick="unselectTheSelectedItems();">
        </td>
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">�� �� ȣ ��</font></td>
    </tr>
    <tr>
        <td style="vertical-align:top;">
            <select name="allProjectsList" multiple size="14" style="width:140px;" onDblClick="selectTheSelectedItems();">
                <% 
                for (int i = 0; i < allProjectList.size(); i++) {
                    Map map = (Map)allProjectList.get(i);
                    String projectNo = (String)map.get("PROJECTNO");
                %>
                    <option value="<%=projectNo%>"><%=projectNo%></option>
                <%
                }
                %>
            </select>
        </td>
        <td>
            <select name="selectedProjectList" multiple size="14" style="width:140px;" onDblClick="unselectTheSelectedItems();">
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
            <input type="button" value="Ȯ��" class="button_simple" onclick="updateSelectedProjectList();">&nbsp;&nbsp;
            <input type="button" value="���" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">


    // ��üȣ������ ���õ� �׸��� '���õ� ȣ��' ��Ͽ� �ݿ�
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

    // '���õ� ȣ��'���� �׸� ����
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

    // ��� â�� �����鼭 '���õ� ȣ��' ����� ����
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