<%--  
��DESCRIPTION: ���� �⵵���� ��ȸ Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPHardCopyDwgDeployedListHeader.jsp
��CHANGING HISTORY: 
��    2010-03-26: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // ������ ID : ������ or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    
    
    String designerID = "";             // ������ ID 
    String isAdmin = "N";               // ������ ����
    String mhInputYN = "";              // �ü��Է� ���� ����(�� ������ �����Է� ������ ������)
    String progressInputYN = "";        // �����Է� ���� ����
    String terminationDate = "";        // �����(��翩��)
    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String insaDepartmentName = "";     // �μ�(��Ʈ) �̸� - �λ������� �̸�
    String dwgDepartmentCode = "";      // �μ�(��Ʈ) �ڵ� - ����μ� �ڵ�

    String errStr = "";                 // DB Query �� ���� �߻� ����

    ArrayList departmentList = null;

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            insaDepartmentName = (String)loginUserInfo.get("DEPT_NAME");
            dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

            departmentList = getDepartmentList();

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 
            else if (designerID.equals("200043")) isAdmin = "Y"; // �����ؾ翬���� �̱��� ����
                                                                 // ������ Hard Copy �⵵���� ��ȸ�� �ʿ��Ͽ� ���������� ����
        }
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }    

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>���� �⵵���� ��ȸ</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // �����ڰ� �ƴ� ��� Exit
    <% if (!isAdmin.equalsIgnoreCase("Y") || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPHardCopyDwgDeployedHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="6" height="2"></td>
        </tr>


        <tr height="30">
            <td class="td_title" width="110" rowspan="2">
                ���� �⵵����<br>�� ȸ
            </td>


            <td width="500">ȣ��
                <input type="text" name="projectList" value="" style="width:220px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();"/>
                <input type="button" name="ProjectsButton" value="��" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="(�Է� �� ',' �� ����)" class="input_noBorder" 
                       style="width:110px;background-color: #D8D8D8;" />
                <% if (isAdmin.equals("Y")) { %>
                <input type="text" name="" value="[��ȸ���� ȣ������]" class="input_noBorder" 
                                   style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" 
                                   onclick="showSearchableProjects();" />
                <% } %>
            </td>


            <td width="280">�μ�
                <select name="departmentList" style="width:220px;">
                    <% 
                    if (!isAdmin.equals("Y")) { 
                        String insaDepartmentStr = insaDepartmentCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + insaDepartmentName;
                    %>
                        <option value="<%=insaDepartmentCode%>"><%=insaDepartmentStr%></option>
                    <% 
                    } else { 
                        %>
                        <option value="">&nbsp;</option>
                        <%
                        for (int i = 0; departmentList != null && i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCode = (String)map.get("DEPT_CODE");
                            String deptName = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                            String selected = ""; if (insaDepartmentCode.equals(deptCode)) selected = "selected";
                            %>
                            <option value="<%=deptCode%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>


            <td width="320">�Ⱓ                
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgDeployedHeader', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgDeployedHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                <!--
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" 
                       onclick="dateSelectedFrom.value='';dateSelectedTo.value='';" />
                -->
            </td>


            <td>
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewHardCopyDeployedData();"/>
            </td>
        </tr>


        <tr height="30">
            <td colspan="3">
                <input type="checkbox" name="chkboxIncludeSeries" value="">Series ����&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="chkboxIncludeEarlyRev" value="">�ð� �� ������ ����
            </td>
        
            <td>
                <!--
                <input type="button" name="PrintButton" value='�� ��' class="button_simple" onclick="viewReport();"/>
                -->
                &nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���.
    parent.HARDCOPY_DEPLOYED_MAIN.location = "stxPECDPHardCopyDwgDeployedListMain.jsp?showMsg=false&firstLoad=true"; 

	// Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    // ȣ������ ȭ�� �˾�
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPHardCopyDwgDeployedHeader.projectList.value;
        paramStr += "&loginID=" + DPHardCopyDwgDeployedHeader.loginID.value;
        paramStr += "&category=DEPLOY";
        var selectedProjects = window.showModalDialog("stxPECDPProgressDeviationView_ProjectSelect.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPHardCopyDwgDeployedHeader.projectList.value = selectedProjects;
    }

    // ��ȸ���� ȣ������ â�� Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPHardCopyDwgDeployedHeader.loginID.value;
        paramStr += "&category=DEPLOY";
        window.showModalDialog("stxPECDPProgressDeviation_ProjectSelect.jsp?" + paramStr, "", sProperties);
    }

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr = DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgDeployedHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgDeployedHeader.dateSelectedTo.value = dateStr;
        }
    }

    // ��ȸ
    function viewHardCopyDeployedData()
    {
        // ��ȸ�Ⱓ�� �� �� �̳�(Series ������ ��� 1���� �̳�)���� üũ
        var sDateFrom = DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        var sDateTo = DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        var tempArray = sDateFrom.split("-");
        var dateFromObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
        tempArray = sDateTo.split("-");
        var dateToObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
        if (dateToObj - dateFromObj < 0) {
            var tempObj = dateFromObj;
            dateFromObj = dateToObj;
            dateToObj = tempObj;
        }
        var iDayDiff = (dateToObj - dateFromObj) / 86400000;
        if (!DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked && iDayDiff >= 31) {
            alert("��ȸ�Ⱓ�� �� ��(31��)�� �ʰ��� �� �����ϴ�!");
            return;
        }
        else if (DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked && iDayDiff >= 7) {
            alert("Series ������ ���, ��ȸ�Ⱓ�� ������(7��)�� �ʰ��� �� �����ϴ�!");
            return;
        }

        // ��ȸ
        var urlStr = "stxPECDPHardCopyDwgDeployedListMain.jsp?projectList=" + DPHardCopyDwgDeployedHeader.projectList.value;
        urlStr += "&deptCode=" + DPHardCopyDwgDeployedHeader.departmentList.value;
        urlStr += "&dateFrom=" + DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        urlStr += "&includeSeries=" + (DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked ? "true" : "false");
        urlStr += "&includeEarlyRev=" + (DPHardCopyDwgDeployedHeader.chkboxIncludeEarlyRev.checked ? "true" : "false");
        urlStr += "&isAdmin=" + DPHardCopyDwgDeployedHeader.isAdmin.value;
        urlStr += "&showMsg=true&firstLoad=false";

        parent.HARDCOPY_DEPLOYED_MAIN.location = urlStr;
    }

    // ����Ʈ(����Ʈ ���)
    function viewReport()
    {
        //
    }

    /* ȭ��(���)�� ����Ǹ� �⺻ ��ȸ�Ⱓ�� 1�� �� ~ ���ó�¥�� ���� */   
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    var d1 = today.getDate().toString();
    var oneWeekBefore = new Date(Date.parse(today) - 6 * 1000 * 60 * 60 * 24);
    var y2 = oneWeekBefore.getFullYear().toString();
    var m2 = (oneWeekBefore.getMonth() + 1).toString();
    var d2 = oneWeekBefore.getDate().toString();

    var toYMD = y1 + ". " + m1 + ". " + d1 + ".";
    var fromYMD = y2 + ". " + m2 + ". " + d2 + ".";    

    DPHardCopyDwgDeployedHeader.dateSelectedFrom.value = formatDateStr(fromYMD);
    DPHardCopyDwgDeployedHeader.dateSelectedTo.value = formatDateStr(toYMD);

</script>

</html>