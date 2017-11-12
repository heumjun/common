<%--  
§TITLE: 설계시수 DATA 관리 화면 - 부서 선택 창 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPDataMgmt_SelectDepartment.jsp
§CHANGING HISTORY: 
§    2009-07-30: Initiative
§DESCRIPTION: 
        설계시수 DATA 관리 화면에서 부서선택 버튼을 클릭하면 실행되는 Modal 창이
    다. 설계부서 목록 전체를 리스트로 보여주고 설계시수 조회를 원하는 부서들을
    선택할 수 있게 한다.
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String selectedDepartments = emxGetParameter(request, "selectedDepartments");
    String errStr = "";

    ArrayList allDepartmentList = null;
    try {
        allDepartmentList = getMHInputDepartmentList();
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>부 서 선 택</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPDepartmentSelect">

<table width="100%" cellSpacing="6" border="1" align="center">
    <tr height="2">
        <td colspan="3"></td>
    <tr>
    <tr height="20">
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">전 체 부 서</font></td>
        <td class="td_standard" rowspan="2" width="80">
            <input type="button" value="추가 >>" onclick="selectTheSelectedItems();"><br><br>
            <input type="button" value="삭제 <<" onclick="unselectTheSelectedItems();">
        </td>
        <td class="td_standardBold" style="background-color:#336699;" width="140"><font color="#ffffff">선 택 부 서</font></td>
    </tr>
    <tr>
        <td>
            <select name="allDepartmentList" multiple size="14" style="width:280px" onDblClick="selectTheSelectedItems();">
                <% 
                if (allDepartmentList == null) { 
                %>
                    <option value=""><%=errStr%></option>
                <% 
                } 
                else { 
                    for (int i = 0; i < allDepartmentList.size(); i++) 
                    {
                        Map map = (Map)allDepartmentList.get(i);
                        String str1 = (String)map.get("DEPT_CODE");
                        String str2 = str1 + ":&nbsp;";
                        str2 += (String)map.get("DEPT_NAME");
                        %>
                        <option value="<%=str1%>"><%=str2%></option>
                        <%
                    }
                } 
                %>
            </select>
        </td>
        <td>
            <select name="selectedDepartmentList" multiple size="14" style="width:280px" onDblClick="unselectTheSelectedItems();">
                <%
                ArrayList selectedDepartmentList = FrameworkUtil.split(selectedDepartments, ",");

                for (int i = 0; i < allDepartmentList.size(); i++) 
                {
                    Map map = (Map)allDepartmentList.get(i);
                    String str1 = (String)map.get("DEPT_CODE");

                    for (int j = 0; j < selectedDepartmentList.size(); j++) 
                    {
                        String selectedDeptCode = (String)selectedDepartmentList.get(j);
                        if (str1.equals(selectedDeptCode)) 
                        {
                            String str2 = str1 + ":&nbsp;";
                            str2 += (String)map.get("DEPT_NAME");
                            %>
                            <option value="<%=str1%>"><%=str2%></option>
                            <%
                        }
                    }
                }
                %>
            </select>
        </td>
    </tr>
    <tr height="45">
        <td colspan="3" style="vertical-align:middle;text-align:right;">
            <input type="button" value="확인" class="button_simple" onclick="updateSelectedDepartmentList();">&nbsp;&nbsp;
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
        var allDepartmentList = DPDepartmentSelect.allDepartmentList;
        var selectedDepartmentList = DPDepartmentSelect.selectedDepartmentList;
        
        for (var i = 0; i < selectedDepartmentList.options.length; i++) {
            selectedDepartmentList.options[i].selected = false;
        }

        for (var i = 0; i < allDepartmentList.options.length; i++) {
            if (allDepartmentList.options[i].value == "null") continue;
            if (allDepartmentList.options[i].selected) {
                var alreadySelected = false;
                for (var j = 0; j < selectedDepartmentList.options.length; j++) {
                    if (allDepartmentList.options[i].value == selectedDepartmentList.options[j].value) {
                        alreadySelected = true;
                        break;
                    }
                }
                if (!alreadySelected) {
                    var newOption = new Option(allDepartmentList.options[i].text, allDepartmentList.options[i].value);
                    selectedDepartmentList.options[selectedDepartmentList.options.length] = newOption;
                }
                allDepartmentList.options[i].selected = false;
            }
        }
    }

    function unselectTheSelectedItems()
    {
        var allDepartmentList = DPDepartmentSelect.allDepartmentList;
        var selectedDepartmentList = DPDepartmentSelect.selectedDepartmentList;
        
        for (var i = 0; i < allDepartmentList.options.length; i++) {
            allDepartmentList.options[i].selected = false;
        }

        for (var i = selectedDepartmentList.options.length - 1; i >= 0; i--) {
            if (selectedDepartmentList.options[i].value == "null") continue;
            if (selectedDepartmentList.options[i].selected) {
                selectedDepartmentList.options[i] = null;
            }
        }
    }

    function updateSelectedDepartmentList()
    {
        var selectedStr = "";
        var selectedStr2 = "";
        for (var i = 0; i < DPDepartmentSelect.selectedDepartmentList.options.length; i++) {
            if (i > 0) selectedStr += ","; 
            if (i > 0) selectedStr2 += ","; 
            selectedStr += DPDepartmentSelect.selectedDepartmentList.options[i].value;
            selectedStr2 += DPDepartmentSelect.selectedDepartmentList.options[i].text;
        }
        window.returnValue = selectedStr + "|" + selectedStr2;
        window.close();
    }

</script>


</html>