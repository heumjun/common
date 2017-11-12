<%--  
��TITLE: �μ� �� �����ü� ��ȸ ȭ�� Header �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPRevisionDataHeader.jsp
��CHANGING HISTORY: 
��    2009-08-18: Initiative
��DESCRIPTION:
    ......
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
	//String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/ematrix/report/";
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
    //String loginID = context.getUser(); // ������ ID : ������(��Ʈ�� ����) or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");        
    String designerID = "";             // ������ ID 
    String isAdmin = "N";               // ������ ����
    String isManager = "N";             // ��Ʈ�� ����
    String mhInputYN = "";              // �ü��Է� ���� ����
    String terminationDate = "";        // �����(��翩��)
    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�

    String errStr = "";                 // DB Query �� ���� �߻� ����

    ArrayList factorCaseList = null;
    ArrayList departmentList = null;

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");

            factorCaseList = getMHFactorCaseAndValueList();
            departmentList = getAllDepartmentList();

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            isManager = isDepartmentManagerYN(titleStr);
            if (isTeamManager(titleStr)) insaDepartmentCode = getPartListUnderTeamStr(insaDepartmentCode);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }    
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>�μ� �� �����ü� ��ȸ</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE>   
    .hintstyle {   
        position:absolute;   
        background:#EEEEEE;   
        border:1px solid black;   
        padding:2px;   
    }   
</STYLE>  


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // �ü��Է� ������ ����ڰ� �ƴ� ��� Exit
    <% if ((!isManager.equalsIgnoreCase("Y") && !isAdmin.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPRevisionDataHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">

        <tr>
            <td colspan="5" height="2"></td>
        </tr>

        <tr height="30">
            <td class="td_title" width="300">
                �μ� �� �����ü� ��ȸ
            </td>
            <td id="departmentTD" width="400">�μ�
                <% if (isAdmin.equals("Y")) { %>
                    <input type="text" name="departmentList" value="" readonly style="width:260px;" onmouseover="showDeptHint(this);" />
                    <input type="button" name="departmentButton" value="��" style="width=22px;" onclick="showDepartmentSelectWin();"/>
                    <input type="text" name="" value="clear" class="input_noBorder" 
                           style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDepartmentList();" />
                <% } else { %>
                    <input type="text" name="departmentList" value="<%=insaDepartmentCode%>" readonly style="width:260px;" />
                <% } %>
            </td>
            <td width="360">����
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPRevisionDataHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPRevisionDataHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewDPInputsList();"/>
            </td>
        </tr>

        <tr height="30">
            <td>���κμ�
                <select name="causeDeptSel" style="width:240px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String deptCode = (String)map.get("DEPT_CODE");
                        String deptName = (String)map.get("DEPT_NAME");
                        String upDeptName = (String)map.get("UP_DEPT_NAME");
                        String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                        %>
                        <option value="<%=deptCode%>"><%=deptStr%></option>
                        <%
                    }
                    %>
                </select>            
            </td>
            <td>���� CASE
                <%
                String disableStr = "disabled";
                if (isAdmin.equals("Y") || isManager.equals("Y")) disableStr = "";
                %>
                <select name="factorCaseList" style="width:280px;" <%= disableStr %>>
                    <%
                    String factorCase = "";
                    String factorCaseStr = "";

                    for (int i = 0; factorCaseList != null && i < factorCaseList.size(); i++) 
                    {
                        Map map = (Map)factorCaseList.get(i);

                        if (factorCase.equals("")) factorCase = (String)map.get("CASE_NO");

                        if (!"1".equals((String)map.get("CAREER_MONTH_FROM"))) factorCaseStr += "; ";
                        factorCaseStr += (String)map.get("CAREER_MONTH_FROM") + "~" + (String)map.get("CAREER_MONTH_TO") + "M=";
                        factorCaseStr += (String)map.get("FACTOR_VALUE");
                        
                        boolean toHTMLPrintTime = false;
                        if (i == factorCaseList.size() - 1) toHTMLPrintTime = true;
                        if (i < factorCaseList.size() - 1) {
                            Map map2 = (Map)factorCaseList.get(i + 1);
                            if (!factorCase.equals((String)map2.get("CASE_NO"))) toHTMLPrintTime = true;
                        }
                        
                        if (toHTMLPrintTime)
                        {
                            String selected = "Y".equals((String)map.get("ACTIVE_CASE_YN")) ? "selected" : "";

                            %>
                            <option value="<%=factorCase%>" <%=selected%>><%=factorCase%>: <%=factorCaseStr%></option>
                            <%  
                            
                            factorCase = "";
                            factorCaseStr = "";
                        }
                    }
                    %>
                </select>
            </td>
            <td>ȣ��
                <input type="text" name="projectList" value="" style="width:260px;" />
                <input type="button" name="projectButton" value="��" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="projectList.value=''" />
            </td>
            <td>
                <input type="button" name="reportButton" value='����Ʈ' class="button_simple2" onclick="viewReport();"/>
            </td>
        </tr>

    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    var deptCodeHintStr = "";

    // �μ� ���� â�� Show
    function showDepartmentSelectWin()
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedDepartments=" + DPRevisionDataHeader.departmentList.value;
        var selectedDepartmentsStr = window.showModalDialog("stxPECDPDataMgmt_SelectDepartment_SP.jsp?" + paramStr, "", sProperties);

        if (selectedDepartmentsStr != null && selectedDepartmentsStr != 'undefined') 
        {
            var strs = selectedDepartmentsStr.split("|");
            DPRevisionDataHeader.departmentList.value = strs[0];
            deptCodeHintStr = "";
            if (strs[1] != "") {
                var strs2 = strs[1].split(",");
                for (var i = 0; i < strs2.length; i++) {
                    deptCodeHintStr += strs2[i];
                    deptCodeHintStr += ";&nbsp;&nbsp;";
                }
            }
        }
    }

    // �μ��ڵ� �κ� MouseOver �� �μ����� ��Ʈ ���·� ǥ��
    var hintcontainer = null;   
    function showDeptHint(obj) {   
        if (deptCodeHintStr == "") return;

        if (hintcontainer == null) {   
            hintcontainer = document.createElement("div");   
            hintcontainer.className = "hintstyle";   
            document.body.appendChild(hintcontainer);   
        }   
        obj.onmouseout = hideDeptHint;   
        obj.onmousemove = moveDeptHint;   
        hintcontainer.innerHTML = deptCodeHintStr;   
    }   
    function moveDeptHint(e) {   
        if (deptCodeHintStr == "") return;
        if (!e) e = event; // line for IE compatibility   
        hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
        hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
        hintcontainer.style.display = "";   
    }   
    function hideDeptHint() {   
        hintcontainer.style.display = "none";   
    }   

    // �μ��ڵ� ���û����� Clear
    function clearDepartmentList()
    {
        DPRevisionDataHeader.departmentList.value = "";
        deptCodeHintStr = "";
    }

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr = DPRevisionDataHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPRevisionDataHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPRevisionDataHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPRevisionDataHeader.dateSelectedTo.value = dateStr;
        }
    }

    // From ��¥ ���� �� To ��¥�� �ش� �� ���Ϸ� �ڵ� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPRevisionDataHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPRevisionDataHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // ȣ������ ȭ�� �˾�
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPRevisionDataHeader.projectList.value;
        var selectedProjects = window.showModalDialog("stxPECDPDataMgmt_SelectProject_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPRevisionDataHeader.projectList.value = selectedProjects;
    }

    // ��ȸ ����
    function viewDPInputsList()
    {
        var departmentStr = DPRevisionDataHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }
        var projectStr = DPRevisionDataHeader.projectList.value.trim();
        if (projectStr != "") {
            var strs = projectStr.split(",");
            projectStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectStr += ",";
                projectStr += "'" + strs[i].trim() + "'";
            }
        }

        var urlStr = "stxPECDPRevisionDataMain_SP.jsp?";
        urlStr += "&deptCode=" + departmentStr;
        urlStr += "&dateFrom=" + DPRevisionDataHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPRevisionDataHeader.dateSelectedTo.value;
        urlStr += "&factorCase=" + DPRevisionDataHeader.factorCaseList.value;
        urlStr += "&projectNo=" + projectStr;
        urlStr += "&causeDeptCode=" + DPRevisionDataHeader.causeDeptSel.value;
        urlStr += "&firstCall=N";
        parent.DP_REVDATA_MAIN.location = urlStr;
    }

    // ����Ʈ(����Ʈ ���)
    function viewReport()
    {
        var departmentStr = DPRevisionDataHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }
        var projectStr = DPRevisionDataHeader.projectList.value.trim();
        if (projectStr != "") {
            var strs = projectStr.split(",");
            projectStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectStr += ",";
                projectStr += "'" + strs[i].trim() + "'";
            }
        }

        var yearMonthStr = DPRevisionDataHeader.dateSelectedFrom.value;
        var tempStrs = yearMonthStr.split("-");
        yearMonthStr = tempStrs[0] + "." + tempStrs[1];

        var urlStr = "http://172.16.2.13:7777/j2ee/STXDPSP/WebReport.jsp?src=<%=reportFileUrl%>";
        urlStr += "stxPECDPDepartmentRevDataView_SP.mrd&param=";
        urlStr += DPRevisionDataHeader.dateSelectedFrom.value + ":::";
        urlStr += DPRevisionDataHeader.dateSelectedTo.value + ":::";
        urlStr += departmentStr + ":::";
        urlStr += projectStr + ":::";
        urlStr += DPRevisionDataHeader.causeDeptSel.value + ":::";
        urlStr += DPRevisionDataHeader.factorCaseList.value + ":::";
        urlStr += yearMonthStr + ":::";
        urlStr += (projectStr == "" ? "ALL" : "SELECTED") + ":::";
        urlStr += (departmentStr == "" ? "ALL" : "SELECTED");
        window.open(urlStr, "", "");
    }

    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� �ش� �� 1�� ~ �ش� �� ���� �������� ���� */   
    // �ش� �� 1��(������ 1 ~ 10�� �̸� ���� ����)
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    var d1 = today.getDate().toString();
    if (eval(d1) <= 10) {
        if (eval(m1) == 1) {
            m1 = "12";
            y1 = (today.getFullYear() - 1).toString();
        }
    }
    if (m1.length == 1) m1 = 0 + m1;
    if (d1.length == 1) d1 = 0 + d1;

    var fromYMD = y1 + "-" + m1 + "-01";    
    var maxDay = getMonthMaxDay(fromYMD);
    var toYMD = y1 + "-" + m1 + "-" + maxDay;
    
    DPRevisionDataHeader.dateSelectedFrom.value = fromYMD;
    DPRevisionDataHeader.dateSelectedTo.value = toYMD;
    
    // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���
    parent.DP_REVDATA_MAIN.location = "stxPECDPRevisionDataMain_SP.jsp?firstCall=Y"; 

</script>

</html>