<%--  
��DESCRIPTION: ����ü��Է� ȭ�� Header Toolbar �κ� 
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInputHeader.jsp
��CHANGING HISTORY: 
��    2009-04-06: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    // FOR TEST
    // stx    TEST���� : DPS ��Ͼȵ� �����
    // PD0169 ����öJI : ���� ���� �����
    // 206294 �ڴ�öGJ : �Ϲݼ�����(����ö��2P - �μ��ڵ�: 445200)
    // 206143 ��â��GJ : ��Ʈ��(����ö��2P)
    // 196235 ����öCJ : ����(���弳��1��)
    // 207027 �Ѱ���JI : Admin.

    //String loginID = context.getUser(); // ������ ID : ������(��Ʈ�� ����) or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");     

    String dpDesignerID = "";           // ������ ID : �ü���ȸ & �Է��� ���
    String dpDesignerName = "";         // ������ �̸�

    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String insaDepartmentName = "";     // �μ�(��Ʈ) �̸� - �λ������� �̸�
    String insaUpDepartmentName = "";   // �����μ� �̸�

    boolean isAdmin = false;            // ������ ����
    boolean isManager = false;          // ��Ʈ�� ����
    String mhInputYN = "";              // �ü��Է� ���� ����
    String terminationDate = "";        // �����(��翩��)

    ArrayList departmentList = null;      // ����μ� ��� : �λ� DB ���� �μ���� �� SDPS�� ��ϵ� �μ����� ������ ������ ���� (Admin. Mode���� ���)
    ArrayList personList = null;          // ������ �μ� �Ҽ��� ������ ��� (Admin. Mode���� ���)
    String errStr = "";                 // DB Query �� ���� �߻� ����

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);
        if (loginUserInfo != null) 
        {
            // �ü���ȸ & �Է��� ��� �����ڴ� Login User�� �ʱⰪ���� �Ѵ�
            // �Ϲ� ������� ��� �����ڿ� Login User�� ����. Admin.�� ��� ��� �����ڸ� ���� ������

            dpDesignerID = loginID;     
            dpDesignerName = (String)loginUserInfo.get("NAME");

            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            insaDepartmentName = (String)loginUserInfo.get("DEPT_NAME");
            insaUpDepartmentName = (String)loginUserInfo.get("UP_DEPT_NAME");

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            if ("Y".equals(isDepartmentManagerYN(titleStr))) isManager = true;

            if (isAdmin) 
            {
                departmentList = getDepartmentList();
                personList = getPartPersons(insaDepartmentCode);
            }            
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (dpDesignerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // �ü��Է� ������ ����ڰ� �ƴ� ��� Exit
    <% if (!mhInputYN.equalsIgnoreCase("Y") || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputHeader">
    
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />
    <input type="hidden" name="workdaysGap" value="" />


    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="5" height="2"></td>
        </tr>
        <tr height="40">
            <td colspan="2" class="td_title">�� �� �� ��</td>
            <td>
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewDPInputs('');"/>
                <input type="button" name="SavaButton" value='�� ��' class="button_simple" onclick="saveDPInputs();"/>
                <input type="button" name="DeleteButton" value='��ü����' class="button_simple" onclick="deleteDPInputs();"/>
            </td>
            <td>&nbsp;
                <% if (isAdmin) { %>
                <input type="button" name="LockButton" value='�ü��Է� LOCK' class="button_simple" style="width:120px;" onclick="showDPInputLockWin();"/>
                <% } %>
            </td>
            <td>
                <input type="button" name="PrintButton" value='��� & ����' class="button_simple" style="width:100px;" onclick="printPage();"/>
                <!--<input type="button" name="ExcelButton" value='�� ��' style="background-color:#ee4400" class="button_simple" onclick="javascript:alert('����');"/>-->
            </td>
        </tr>
        <tr height="40">
            <td width="310">�μ�
                <select name="departmentSel" style="width:280px;" onchange="departmentSelChanged();">
                    <% 
                    if (!isAdmin) { 
                        String insaDepartmentStr = insaDepartmentCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*insaUpDepartmentName + "-" +*/ insaDepartmentName;
                    %>
                        <option value="<%=insaDepartmentCode%>|<%=insaDepartmentName%>"><%=insaDepartmentStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCode = (String)map.get("DEPT_CODE");
                            String deptName = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                            String selected = ""; if (insaDepartmentCode.equals(deptCode)) selected = "selected";
                            %>
                            <option value="<%=deptCode%>|<%=deptName%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td width="240">���
                <select name="dpDesignerIDSel" style="width:200px;" onchange="dpDesignerSelChanged();">
                    <% 
                    if (!isAdmin) { 
                        String dpDesignerStr = dpDesignerID + "&nbsp;&nbsp;&nbsp;&nbsp;" + dpDesignerName;
                    %>
                        <option value="<%=dpDesignerID%>|<%=dpDesignerName%>"><%=dpDesignerStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < personList.size(); i++) {
                            Map map = (Map)personList.get(i);
                            String designerID = (String)map.get("EMPLOYEE_NO");
                            String designerName = (String)map.get("EMPLOYEE_NAME");
                            String designerStr = designerID + "&nbsp;&nbsp;&nbsp;&nbsp;" + designerName;
                            String selected = ""; if (dpDesignerID.equals(designerID)) selected = "selected";
                            %>
                            <option value="<%=designerID%>|<%=designerName%>" <%=selected%>><%=designerStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td>����
                <input type="text" name="dateSelected" value="" style="width:100px;" readonly="readonly" />
                <a href="javascript:showCalendarWin();">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;&nbsp;<input type="text" name="workingDayYN" value="" readonly style="width=80px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>ȣ���߰�
                <input type="button" name="ProjectsButton" value="��" style="height:22px;width=22px;" onclick="showProjectSelectWin();"/>&nbsp;
                &nbsp;&nbsp;&nbsp;��������
                <input type="text" name="MHConfirmYN" value="" readonly style="width=20px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>
                <input type="button" name="DHViewButton" value='�ü�üũ' class="button_simple2" onclick="showDesignHoursViewWin();"/>
                <input type="button" name="ApprovalViewButton" value='����üũ' class="button_simple2" onclick="showDesignHoursApprViewWin();"/>
            </td>
        </tr>
    </table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Docuemnt�� Keydown �ڵ鷯 ���� - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ���� ��
    document.onkeydown = keydownHandler;

    // ����ȭ�� ����Ʈ
    function printPage()
    {
        parent.DP_MAIN.printPage();
    }

    // ȣ������ ȭ�� �˾�
    function showProjectSelectWin() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("�����ڸ� ���� �����Ͻʽÿ�.");
            return;
        }

        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "designerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
        var selectedProjects = window.showModalDialog("stxPECDPInput_ProjectSelect_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects != null && selectedProjects != 'undefined') parent.DP_MAIN.changedSelectedProject(selectedProjects);
    }

    // �ü�üũ ȭ�� �˾�
    function showDesignHoursViewWin() 
    {
        if (DPInputHeader.departmentSel.value == "" || DPInputHeader.dpDesignerIDSel.value == "") {
            alert("��ȸ�� �μ��� �����ڸ� ���� �����Ͻʽÿ�.");
            return;
        }
    
        var urlStr = "stxPECDPInput_InputListViewFS_SP.jsp?loginID=" + DPInputHeader.loginID.value;
        var sProperties = 'dialogHeight:600px;dialogWidth:1200px;scroll=no;center:yes;resizable=no;status=no;';
        var dhCheckResult = window.showModalDialog(urlStr, "", sProperties);
    }

    // ����üũ ȭ�� �˾�
    function showDesignHoursApprViewWin() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("��ȸ�� �����ڸ� ���� �����Ͻʽÿ�.");
            return;
        }

        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.userID = ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
            this.userName = ((DPInputHeader.dpDesignerIDSel.value).split("|"))[1];
            this.callerObject = self;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPInput_ApprovalsViewFS_SP.jsp", paramObj, sProperties);
    }

    var currentDate = "";
    var currentWorkingDayYN = "";
    var currentMHConfirmYN = "";
    var currentWorkdaysGap = "";

    // �޷�â Show
    function showCalendarWin()
    {
        currentDate = DPInputHeader.dateSelected.value;
        currentWorkingDayYN = DPInputHeader.workingDayYN.value;
        currentMHConfirmYN = DPInputHeader.MHConfirmYN.value;
        currentWorkdaysGap = DPInputHeader.workdaysGap.value;

        showCalendar('DPInputHeader', 'dateSelected', '', false, dateChanged);
    }

    // ���� ���� ���� �� ó��, Ư�� �ش� ������ ����/���� ���ο� ���翩�θ� ����
    function dateChanged()
    {
        var tmpStr = DPInputHeader.dateSelected.value;
        if (tmpStr == null || tmpStr.trim() == "") return;

        //// �����ư�� ���¸� disabled�� �ʱ�ȭ
        //DPInputHeader.SavaButton.disabled = true;

        // ��¥ ��� ���ڿ��� ����ȭ
        var dateStr = formatDateStr(tmpStr);
        DPInputHeader.dateSelected.value = dateStr;

        // �̷�(���� ��) ��¥ ���� �� �޽���
        var today = new Date();
        var strs = dateStr.split("-");
        var selectedDate = new Date(strs[0], strs[1] - 1, strs[2]);
        if (today - selectedDate < 0) {
            DPInputHeader.dateSelected.value = currentDate;
            alert("���� ��¥ �Ǵ� ���� ��¥�� �����Ͻʽÿ�.");
            return;
        }
        var resultMsg = getDateDPInfo(((DPInputHeader.dpDesignerIDSel.value).split("|"))[0], DPInputHeader.dateSelected.value);
        if (resultMsg == "ERROR") {
            DPInputHeader.workingDayYN.value = "ERROR";
            DPInputHeader.MHConfirmYN.value = "ERROR";
        }
        else {
            strs = resultMsg.split("|");

            // �ش� ���� + Work Day 2���� ����Ǿ����� ����, ���ڸ� Rollback
            var strs2 = strs[1].split("-");
            var dpInputLockDate = new Date(strs2[0], strs2[1] - 1, strs2[2]);
            //if (DPInputHeader.isAdmin.value != "true" && (selectedDate - dpInputLockDate < 0)) {
            //    DPInputHeader.dateSelected.value = currentDate;
            //    alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
            //    return;
            //}

            if (strs[0] == 'Y') DPInputHeader.workingDayYN.value = "����";
            else if (strs[0] == 'N') DPInputHeader.workingDayYN.value = "����";
            else DPInputHeader.workingDayYN.value = strs[0];
            DPInputHeader.workdaysGap.value = strs[1];
            DPInputHeader.MHConfirmYN.value = strs[2];
            //if (strs[1] != "Y") DPInputHeader.SavaButton.disabled = false;

            if (viewDPInputs("true") == false) {
                DPInputHeader.dateSelected.value = currentDate;
                DPInputHeader.workingDayYN.value = currentWorkingDayYN;
                DPInputHeader.MHConfirmYN.value = currentMHConfirmYN;
                DPInputHeader.workdaysGap.value = currentWorkdaysGap;
            }
        }
    }

    // �ü��Է� ������ ����
    function saveDPInputs()
    {
        parent.DP_MAIN.saveDPInputs();
    }

    // ���õ� ��¥�� �Է½ü��� �ϰ� ����
    function deleteDPInputs()
    {
        parent.DP_MAIN.deleteDPInputs();
    }

    // ����üũâ���� ���õ� ������ �ü��Է� ������ ��ȸ
    function callViewDPInputs(dateStr)
    {
        // TODO ���õ� ���ڰ� LOCK ���� ������ �˻�

        var resultMsg = getDateDPInfo(((DPInputHeader.dpDesignerIDSel.value).split("|"))[0], dateStr);

        if (resultMsg == "ERROR") alert("ERROR!");
        else {
            var strs = resultMsg.split("|");

            var workingDayYN = strs[0];
            if (workingDayYN == 'Y') workingDayYN = "����";
            else if (workingDayYN == 'N') workingDayYN = "����";

            viewDPInputs("false", dateStr, workingDayYN, strs[2], strs[1]);
        }
    }

    // ���õ� ��¥�� �ü��Է� ������ ��ȸ
    function viewDPInputs(showMsg, dateSelected, workingDayYN, MHConfirmYN, workdaysGap)
    {
        if (dateSelected == null || dateSelected == "") dateSelected = DPInputHeader.dateSelected.value;
        if (workingDayYN == null || workingDayYN == "") workingDayYN = DPInputHeader.workingDayYN.value;
        if (MHConfirmYN == null || MHConfirmYN == "") MHConfirmYN = DPInputHeader.MHConfirmYN.value;
        if (workdaysGap == null || workdaysGap == "") workdaysGap = DPInputHeader.workdaysGap.value;


        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("��ȸ�� �����ڸ� ���� �����Ͻʽÿ�.");
            return false;
        }

        // ����� �Է»����� ������ ��������� ���� ����
        if (parent.DP_MAIN.DPInputMain != null) {
            var dataChanged = parent.DP_MAIN.DPInputMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "����� ������ �ֽ��ϴ�!\n\n��������� �����ϰ� ��ȸ�� �����Ͻðڽ��ϱ�?";
                if (!confirm(msg)) return false;
            }
        }

        // ���õ� ��¥�� �ü��Է� ������ ��ȸ
        var urlStr = "stxPECDPInputMain_SP.jsp?deptCode=" + ((DPInputHeader.departmentSel.value).split("|"))[0];
        urlStr += "&deptName=" + escape(encodeURIComponent(((DPInputHeader.departmentSel.value).split("|"))[1]));
        urlStr += "&designerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
        urlStr += "&designerName=" + escape(encodeURIComponent(((DPInputHeader.dpDesignerIDSel.value).split("|"))[1]));
        urlStr += "&dateSelected=" + dateSelected;
        urlStr += "&workingDayYN=" + escape(encodeURIComponent(workingDayYN));
        urlStr += "&MHConfirmYN=" + MHConfirmYN;
        urlStr += "&workdaysGap=" + workdaysGap;
        urlStr += "&loginID=" + DPInputHeader.loginID.value;
        urlStr += "&showMsg=" + escape(encodeURIComponent(showMsg));
        parent.DP_MAIN.location = urlStr;

        return true;
    }

    // ������ ��忡�� �μ��� ����Ǹ� ����� ���õ� �׸���� ��� �ʱ�ȭ
    function departmentSelChanged() 
    {
        for (var i = DPInputHeader.dpDesignerIDSel.options.length - 1; i >= 0; i--) {
            DPInputHeader.dpDesignerIDSel.options[i] = null;
        }
        DPInputHeader.MHConfirmYN.value = "";

        // ���õ� �μ�(��Ʈ)�� ������(��Ʈ��) ����� ����
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=GetPartPersons&departCode=" + ((DPInputHeader.departmentSel.value).split("|"))[0], false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    var strs = resultMsg.split("+");

                    var newOption = new Option("", "");
                    DPInputHeader.dpDesignerIDSel.options[0] = newOption;

                    for (var i = 0; i < strs.length; i++) {
                        var strs2 = strs[i].split("|");
                        newOption = new Option(strs2[0] + "    " + strs2[1], strs2[0] + "|" + strs2[1]);
                        DPInputHeader.dpDesignerIDSel.options[i + 1] = newOption;
                    }
                }
            }
            else {
                alert(resultMsg);
            }
        }
        else {
            alert(resultMsg);
        }
    }

    // ������ ��忡��, ���(������) ������ ����� ��� ����� ����� �����͸� ����
    function dpDesignerSelChanged() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            DPInputHeader.MHConfirmYN.value = "";
        }
        else {
            // �ش� ��� + ��¥�� �ü����� ���θ� �����Ͽ� ǥ��
            var xmlHttp;
            if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

            xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=GetConfirmYN&dpDesignerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0] + 
                                "&dateStr=" + DPInputHeader.dateSelected.value, false);
            xmlHttp.send(null);

            if (xmlHttp.status == 200) {
                if (xmlHttp.statusText == "OK") {
                    var resultMsg = xmlHttp.responseText;
                    
                    if (resultMsg != null)
                    {
                        resultMsg = resultMsg.trim();
                        DPInputHeader.MHConfirmYN.value = resultMsg;
                    }
                }
                else {
                    alert("ERROR");
                }
            }
            else {
                alert("ERROR");
            }
        }
    }

    // �ü��Է� LOCk ����ȭ�� �˾�
    function showDPInputLockWin()
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;status=no;';
        var result = window.showModalDialog("stxPECDPInput_LockControl_SP.jsp", "", sProperties);
    }


    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� ���� ��¥�� �������� �����ϰ� �ü��Է� â�� �ε� */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;

    DPInputHeader.dateSelected.value = ymd;
    dateChanged();
    parent.DP_TIMESELECT.location = "stxPECDPInputTimeSelect_SP.jsp"; // Header �������� ���� �ε�� �� Time Select â�� �ε�ǵ���.
    viewDPInputs("false");

    showDesignHoursApprViewWin();

</script>

</html>