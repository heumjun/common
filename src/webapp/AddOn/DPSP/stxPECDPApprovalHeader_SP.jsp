<%--  
��DESCRIPTION: ����ü����� ȭ�� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPApprovalHeader.jsp
��CHANGING HISTORY: 
��    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // ������ ID
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    

    String employeeID = "";
    String userInfoStr = "";
    String deptInfoStr = "";
    String deptCode = "";
    String deptName = "";
    String userTitleStr = "";
    String userName = "";
    String isManager = "N";
    boolean isAdmin = false;       
    String terminationDate = "";
    ArrayList departmentList = null;

    String errStr = "";

    try {
        Map userInfoMap = getEmployeeInfo(loginID);
        if (userInfoMap != null) 
        {
            employeeID = loginID;

            deptCode = (String)userInfoMap.get("DEPT_CODE");
            deptName = (String)userInfoMap.get("DEPT_NAME");
            terminationDate = (String)userInfoMap.get("TERMINATION_DATE");

            deptInfoStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;";
            deptInfoStr += (String)userInfoMap.get("DEPT_NAME");
            
            userName = (String)userInfoMap.get("NAME");
            userInfoStr = employeeID + "&nbsp;&nbsp;&nbsp;&nbsp;" + userName;
            userTitleStr = (String)userInfoMap.get("TITLE");
            isManager = isDepartmentManagerYN(userTitleStr);

            if (((String)userInfoMap.get("IS_ADMIN")).equals("Y")) {
                isAdmin = true; 
                departmentList = getDepartmentList();
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
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (employeeID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // �ų���(��Ʈ��) ������ �ƴϸ� Exit
    <% if (!isManager.equals("Y") && !isAdmin) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

    // ������� ��� Exit
    <% if (!terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalHeader">

    <input type="hidden" name="deptName" value="<%=deptName%>" />
    <input type="hidden" name="userName" value="<%=userName%>" />    
    <input type="hidden" name="userTitleStr" value="<%=userTitleStr%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />    

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="4" height="2"></td>
        </tr>
        <tr height="30">
            <td colspan="2" class="td_title">���Ͻü� �������</td>
            <td colspan="2" style="text-align: right">
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewPartPersons();"/>
                <input type="button" name="SavaButton" value='�� ��' class="button_simple" onclick="saveApprovals();"/>
                <!--
                <input type="button" name="DeleteButton" value='�� ��' disabled class="button_simple" onclick="javascript:alert('����');"/>
                -->
            </td>
        </tr>
        <tr height="30">
            <td>�μ�
                <select name="departmentSel" style="width:250px;">
                    <% 
                    if (!isAdmin) { 
                    %>
                        <option value="<%=deptCode%>"><%=deptInfoStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCodeData = (String)map.get("DEPT_CODE");
                            String deptNameData = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCodeData + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptNameData;
                            String selected = ""; if (deptCode.equals(deptCodeData)) selected = "selected";
                            %>
                            <option value="<%=deptCodeData%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            
            </td>
            <td>&nbsp;<!--���
                <select name="employeeIDSel" style="width:200px;" disabled>
                    <option value="<%=employeeID%>"><%=userInfoStr%></option>
                </select>
                -->
            </td>
            <td>����
                <input type="text" name="dateSelected" value="" style="width:100px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalHeader', 'dateSelected', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;&nbsp;<input type="text" name="workingDayYN" value="" readonly style="width=80px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>
                <input type="button" name="ApprovalsViewButton" value='������ȸ' class="button_simple3" onclick="showApprovalsViewWin();"/>
                <input type="button" name="InputRateViewButton" value='�Է�����ȸ' class="button_simple3" onclick="showInputRateViewWin();"/>
                <input type="button" name="HolidayCheckButton" value='����üũ' class="button_simple3" onclick="showHolidayCheckWin();"/>
            </td>
        </tr>
        <tr height="24">
            <td><b>[��ü����]</b>&nbsp;
                <input type="radio" name="ApprovalAllSelect" value="APPROVE_ALL" onClick="checkAll();" />����&nbsp;
                <input type="radio" name="ApprovalAllSelect" value="APPROVE_NONE" onClick="unCheckAll();" />����&nbsp;
            </td>
            <td><b>[�μ�����]</b>&nbsp;
                �ѽü�: <input name="workTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                ����: <input name="normalTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                ����: <input name="overtimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                Ư��: <input name="specialTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
            <td colspan="2"><b>[��������]</b>&nbsp;
                ���: <input name="personInfo" value="" readonly style="background-color:#D8D8D8;width:100px;border:0;color:#000000;;font-weight:bold;" />
                �ѽü�: <input name="personWorkTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                ����: <input name="personNormalTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                ����: <input name="personOvertime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                Ư��: <input name="personSpecialTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
        </tr>
    </table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>
<script language="javascript">

    // Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ���� 
    document.onkeydown = keydownHandler;

    // ������ȸ ȭ�� Show
    function showApprovalsViewWin() 
    {
        var sProperties = 'dialogHeight:300px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.callerObject = self;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_ApprovalListViewFS_SP.jsp", paramObj, sProperties);
    }

    // �Է�����ȸ ȭ�� Show
    function showInputRateViewWin() 
    {
        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        var sProperties = 'dialogHeight:400px;dialogWidth:450px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.deptName = deptName;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_InputRateViewFS_SP.jsp", paramObj, sProperties);
    }

    // ����üũ ȭ�� Show
    function showHolidayCheckWin() 
    {
        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        var sProperties = 'dialogHeight:300px;dialogWidth:440px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.deptName = deptName;
        }
        var dhHolidayCheckResult = window.showModalDialog("stxPECDPApproval_HolidayCheckFS_SP.jsp", paramObj, sProperties);
    }

    // ���� ���� ���� �� ó��, Ư�� �ش� ������ ����/���� ���θ� ����
    function dateChanged()
    {
        var tmpStr = DPApprovalHeader.dateSelected.value;
        if (tmpStr == null || tmpStr.trim() == "") return;

        // �����ư�� ���¸� disabled�� �ʱ�ȭ
        //DPApprovalHeader.SavaButton.disabled = true;

        // ��¥ ��� ���ڿ��� ����ȭ
        var dateStr = formatDateStr(tmpStr);
        DPApprovalHeader.dateSelected.value = dateStr;

        // �ش� ��¥�� ����/���� ���ο� �ü����� ���θ� �����Ͽ� ǥ��
        DPApprovalHeader.workingDayYN.value = getWorkingDayYNString(DPApprovalHeader.dateSelected.value);

        viewPartPersons();
    }

    // ��Ʈ ������ ����� ��ȸ
    function viewPartPersons()
    {
        // ȭ���� ���� �׸� �ʱ�ȭ
        DPApprovalHeader.all('ApprovalAllSelect')[0].checked = false;
        DPApprovalHeader.all('ApprovalAllSelect')[1].checked = false;

        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        // ��Ʈ ������ ����� ����
        var urlStr = "stxPECDPApprovalPersonSelect_SP.jsp?deptCode=" + DPApprovalHeader.departmentSel.value;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&dateSelected=" + DPApprovalHeader.dateSelected.value;
        urlStr += "&loginID=<%=loginID%>";
        parent.DP_APPR_PERSON.location = urlStr;

        parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain_SP.jsp"; 
    }

    // �ü����� ������ ����
    function saveApprovals()
    {
        parent.DP_APPR_PERSON.saveApprovals();
    }

    // ��Ʈ ������ ����� ��� �׸��� üũ
    function checkAll()
    {
        parent.DP_APPR_PERSON.checkAll();
    }

    // ��Ʈ ������ ����� ��� �׸��� Un-check
    function unCheckAll()
    {
        parent.DP_APPR_PERSON.unCheckAll();
    }

    // ������ȸâ���� ���õ� ������ �ü����� ������ ��ȸ
    function callViewDPApprovals(dateStr)
    {
        DPApprovalHeader.dateSelected.value = dateStr;
        dateChanged();
        viewPartPersons();
    }

    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� ���� ��¥�� �������� �����ϰ� ���� â���� �ε� */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;
    DPApprovalHeader.dateSelected.value = ymd;
    dateChanged();
    // Header �������� ���� �ε�� �� ���� â�� �ε�ǵ���
    //parent.DP_APPR_PERSON.location = "stxPECDPApprovalPersonSelect_SP.jsp"; 
    //parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain_SP.jsp"; 
    viewPartPersons();


</script>


</html>