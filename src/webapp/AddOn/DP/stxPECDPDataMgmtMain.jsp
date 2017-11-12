<%--  
��DESCRIPTION: ����ü� DATA ���� ȭ�� ���� �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPDataMgmtMain.jsp
��CHANGING HISTORY: 
��    2009-07-30: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String causeDeptCode = StringUtil.setEmptyExt(emxGetParameter(request, "causeDeptCode"));
    String drawingNo1 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo1"));
    String drawingNo2 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo2"));
    String drawingNo3 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo3"));
    String drawingNo4 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo4"));
    String drawingNo5 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo5"));
    String drawingNo6 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo6"));
    String drawingNo7 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo7"));
    String drawingNo8 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo8"));
    String opCode = StringUtil.setEmptyExt(emxGetParameter(request, "opCode"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
    String firstCall = StringUtil.setEmptyExt(emxGetParameter(request, "firstCall"));
    String isAdmin = StringUtil.setEmptyExt(emxGetParameter(request, "isAdmin"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));

    // From, To Date ������ �ݴ��̸� ��ȣ ��ü�Ѵ� 
    if (!dateFrom.equals("") && !dateTo.equals("")) {
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd"); 
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd"); 
        java.util.Date date1 = sdf1.parse(dateFrom); 
        java.util.Date date2 = sdf1.parse(dateTo); 
        if (date1.after(date2)) {
            String temp = dateFrom;
            dateFrom = dateTo;
            dateTo = temp;
        }
    }

    String errStr = "";

    ArrayList dpInputsList = null;
    ArrayList departmentList = null;
    try {
        if (!firstCall.equals("Y")) {
            String[] drawingNoArray = {drawingNo1, drawingNo2, drawingNo3, drawingNo4, drawingNo5, drawingNo6, drawingNo7, drawingNo8};
            dpInputsList = getDesignMHInputsList2(deptCode, designerID, dateFrom, dateTo, projectNo, causeDeptCode, drawingNoArray, 
                                                  opCode, factorCase);
            
            departmentList = getDepartmentList();
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>����ü� DATA ����</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript">

    // Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    var activeDeptCodeTD = null;
    var activeDeptNameTD = null;
    var activeDBKey = "";
    var isNewShow = false;
    var departmentChangedList = new Array();
    document.onclick = mouseClickHandler;

    // �μ� ����(����) ȭ�� Show
    function changeDepartment(tdObject, idx, dbKey)
    {
        activeDeptCodeTD = document.getElementById("td1_" + idx);
        activeDeptNameTD = document.getElementById("td2_" + idx);
        
        var objPosition = getAbsolutePosition(tdObject);
        DepartmentListDiv.style.left = objPosition.x + tdObject.offsetWidth;
        DepartmentListDiv.style.top = objPosition.y - document.documentElement.scrollTop - 1;
        
        activeDBKey = dbKey;
        var currentValue = tdObject.innerHTML.trim();

        for (var i = 0; i < DPDataMgmtMain.DepartmentList.options.length; i++) {
            var str = DPDataMgmtMain.DepartmentList.options[i].value;
            if (str.indexOf(currentValue + "|") == 0) {
                DPDataMgmtMain.DepartmentList.selectedIndex = i;
                break;
            }
        }

        DepartmentListDiv.style.display = '';
        isNewShow = true;
    }

    // �μ� ���� ȭ�� Hidden
    function hideDepartmentSelect()
    {
        DepartmentListDiv.style.display = 'none';
    }

    // �μ� ����(�Է�) ó��
    function departmentSelChanged()
    {
        var str = DPDataMgmtMain.DepartmentList.value;
        var strs = str.split("|");

        activeDeptCodeTD.innerHTML = strs[0];
        activeDeptNameTD.innerHTML = strs[1];

        activeDeptCodeTD.style.backgroundColor = "#ffcccc";
        activeDeptNameTD.style.backgroundColor = "#ffcccc";

        // �߰� or ���� ��� ��Ͽ� �̹� ������ ������Ʈ, ������ �߰�
        var isExist = false;
        for (var i = 0; i < departmentChangedList.length; i++) {
            var str2 = departmentChangedList[i];
            if (str2.indexOf(activeDBKey + "|") >= 0) {
                departmentChangedList[i] = activeDBKey + "|" + strs[0];
                isExist = true;
                break;
            }
        }
        if (!isExist) departmentChangedList[departmentChangedList.length] = activeDBKey + "|" + strs[0];

        hideDepartmentSelect();
    }

    // �μ� ����ȭ�� �� �ٸ� �κ��� Ŭ�� �� �μ� ����ȭ���� Hidden
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        if (DepartmentListDiv.style.display == 'none') return;

        var posX = event.clientX + document.body.scrollLeft;
        var posY = event.clientY + document.body.scrollTop;
        var objPos = getAbsolutePosition(DepartmentListDiv);
        if (posX < objPos.x || posX > objPos.x + DepartmentListDiv.offsetWidth || 
            posY < objPos.y  || posY > objPos.y + DepartmentListDiv.offsetHeight)
        {
            hideDepartmentSelect();
        }
    }

    // ���� �����ü� �Է»��� ����
    function saveDepartmentChange()
    {
        if (departmentChangedList.length <= 0) {
            alert("��������� �����ϴ�!");
            return;
        }

        var msg = "��������� �����Ͻðڽ��ϱ�?";
        if (!confirm(msg)) return;

        var str = "";
        for (var i = 0; i < departmentChangedList.length; i++) {
            if (i > 0) str += "��";
            str += departmentChangedList[i];
        }

        var params = "deptChanged=" + str + "&loginID=<%=loginID%>";

        var resultMsg = callDPCommonAjaxPostProc("SaveDepartmentChange", params);

        if (resultMsg == "Y") {
            alert("���� �Ϸ�");

            var urlStr = "stxPECDPDataMgmtMain.jsp?";
            urlStr += "&deptCode=<%=deptCode%>";
            urlStr += "&designerID=<%=designerID%>";
            urlStr += "&dateFrom=<%=dateFrom%>";
            urlStr += "&dateTo=<%=dateTo%>";
            urlStr += "&projectNo=<%=projectNo%>";
            urlStr += "&causeDeptCode=<%=causeDeptCode%>";
            urlStr += "&drawingNo1=<%=drawingNo1%>";
            urlStr += "&drawingNo2=<%=drawingNo2%>";
            urlStr += "&drawingNo3=<%=drawingNo3%>";
            urlStr += "&drawingNo4=<%=drawingNo4%>";
            urlStr += "&drawingNo5=<%=drawingNo5%>";
            urlStr += "&drawingNo6=<%=drawingNo6%>";
            urlStr += "&drawingNo7=<%=drawingNo7%>";
            urlStr += "&drawingNo8=<%=drawingNo8%>";
            urlStr += "&opCode=<%=opCode%>";
            urlStr += "&factorCase=<%=factorCase%>";
            urlStr += "&isAdmin=<%=isAdmin%>";
            urlStr += "&firstCall=N";
            urlStr += "&loginID=<%=loginID%>";
            urlStr += "&showMsg=N";
            parent.DP_DATAMGMT_MAIN.location = urlStr;
        }
        else alert("���� �߻�");
    }

</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPDataMgmtMain">

    <% if (!errStr.equals("")) { %>
    <%=errStr%>
    <% } %>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="2"><td></td></tr>
    </table>
    
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold">NO</td>
            <td class="td_standardBold">PROJECT</td>
            <td class="td_standardBold">�۾�����</td>
            <td class="td_standardBold">���</td>
            <td class="td_standardBold">����</td>
            <td class="td_standardBold">�μ�CODE</td>
            <td class="td_standardBold">�μ�</td>
            <td class="td_standardBold">�����ȣ</td>
            <td class="td_standardBold">OP�ڵ�</td>
            <td class="td_standardBold">���κμ�</td>
            <td class="td_standardBold">����</td>
            <td class="td_standardBold">�ܾ�</td>
            <td class="td_standardBold">Ư��</td>
            <td class="td_standardBold">E1</td>
            <td class="td_standardBold">E2</td>
            <td class="td_standardBold">E3</td>
        </tr>

        <%
        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);

            boolean isEditable = false;
            String dbKeyStr = "";
            if (isAdmin.equals("Y")) {
                isEditable = true;
                dbKeyStr = (String)map.get("WORKDAY") + "��" + (String)map.get("EMPLOYEE_NO") + "��" + 
                           (String)map.get("PROJECT_NO") + "��" + (String)map.get("DWG_CODE") + "��" + 
                           (String)map.get("OP_CODE") + "��" + (String)map.get("START_TIME");
            }
            %>
            <tr height="20" bgcolor="#ffffff" >
                <td class="td_standard"><%=i + 1%></td>
                <td class="td_standard"><%=(String)map.get("PROJECT_NO")%></td>
                <td class="td_standard"><%=(String)map.get("WORKDAY")%></td>
                <td class="td_standard"><%=(String)map.get("EMPLOYEE_NO")%></td>
                <td class="td_standard"><%=(String)map.get("EMP_NAME")%></td>
                <% if (isEditable) { %>
                    <td id="td1_<%=i%>" class="td_smallYellowBack" style="cursor: hand;" nowrap 
                        onclick="changeDepartment(this, '<%=i%>', '<%=dbKeyStr%>');">
                        <%=(String)map.get("DEPT_CODE")%>
                    </td> 
                <% } else { %>
                    <td id="td1_<%=i%>" class="td_standard"><%=(String)map.get("DEPT_CODE")%></td>
                <% } %>
                <td id="td2_<%=i%>" class="td_standard"><%=(String)map.get("DEPT_NAME")%></td>
                <td class="td_standard"><%=(String)map.get("DWG_CODE")%></td>
                <td class="td_standard"><%=(String)map.get("OP_CODE")%></td>
                <td class="td_standard"><%=(String)map.get("CAUSE_DEPART")%></td>
                <td class="td_standard"><%=(String)map.get("NORMAL")%></td>
                <td class="td_standard"><%=(String)map.get("OVERTIME")%></td>
                <td class="td_standard"><%=(String)map.get("SPECIAL")%></td>
                <td class="td_standard"><%=(String)map.get("EVENT1")%></td>
                <td class="td_standard"><%=(String)map.get("EVENT2")%></td>
                <td class="td_standard"><%=(String)map.get("EVENT3")%></td>
            </tr>
            <%
        }
        %>
    </table>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="4"><td>&nbsp;</td></tr>
    </table>

<div id="DepartmentListDiv" style="position:absolute;display:none;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="DepartmentList" style="width:260px;background-color:#fff0f5" onchange="departmentSelChanged();">
            <% 
            for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
            {
                Map map = (Map)departmentList.get(i);
                String deptCode2 = (String)map.get("DEPT_CODE");
                String deptName = (String)map.get("DEPT_NAME");
                String upDeptName = (String)map.get("UP_DEPT_NAME");
                String deptStr = deptCode2 + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                %>
                <option value="<%=deptCode2%>|<%=deptName%>"><%=deptStr%></option>
                <% 
            } 
            %>
        </select>
    </td></tr>
    </table>
</div>

</form>
</body>
</html>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // ��ȸ �Ϸ� �޽��� 
    <% if (!firstCall.equals("Y") && !showMsg.equals("N")) { %>
        alert("��ȸ �Ϸ�");
    <% } %>

</script>