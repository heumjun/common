<%--  
��DESCRIPTION: ���� ��ȸ/�Է� ȭ�� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPProgressViewHeader.jsp
��CHANGING HISTORY: 
��    2009-04-13: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
   // String loginID = context.getUser(); // ������ ID : ������(��Ʈ�� ����) or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");      
    String designerID = "";             // ������ ID 
    String isAdmin = "N";               // ������ ����
    String isManager = "N";             // ��Ʈ�� ����
    String mhInputYN = "";              // �ü��Է� ���� ����(�� ������ �����Է� ������ ������)
    String progressInputYN = "";        // �����Է� ���� ����
    String terminationDate = "";        // �����(��翩��)
    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String dwgDepartmentCode = "";      // �μ�(��Ʈ) �ڵ� - ����μ� �ڵ�

    String errStr = "";                 // DB Query �� ���� �߻� ����

    ArrayList projectList = null;
    ArrayList departmentList = null;
    ArrayList personsList = null;

    boolean isMaritimeBizTeam = false; // (FOR MARITIME) �ؾ���������/�ؾ����ռ����� �ο��� ������ȸ ��� �ο� (* �ӽñ��)

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try 
    {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) 
        {
            designerID = loginID;

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

            projectList = getProgressSearchableProjectList(loginID, true, "PROGRESS");
            departmentList = getProgressDepartmentList();
            personsList = getPartPersonsForDPProgress(insaDepartmentCode);

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            if ("��Ʈ��".equals(titleStr) || "����".equals(titleStr)) isManager = "Y";
        }
        else // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
        {
            loginUserInfo = getEmployeeInfo_Dalian(loginID);

            if (loginUserInfo != null) 
            {
                designerID = loginID;

                mhInputYN = (String)loginUserInfo.get("MH_YN");
                progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
                terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
                insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
                dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

                projectList = getProgressSearchableProjectList_Dalian(loginID, true, "PROGRESS");
                departmentList = getProgressDepartmentList();
                personsList = getPartPersons_Dalian(insaDepartmentCode);
            }     
        }

        // (FOR MARITIME) �ؾ���������/�ؾ����ռ����� �ο��� ������ȸ ��� �ο� (* �ӽñ��)
        //if (/*loginUserInfo != null &&*/ terminationDate.equals("") && !mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) 
        if(false)
        {
            loginUserInfo = getEmployeeInfo_Maritime(loginID);

            if (loginUserInfo != null) 
            {
                designerID = loginID;

                mhInputYN = (String)loginUserInfo.get("MH_YN");
                progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
                terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
                insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
                dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

                projectList = getProgressSearchableProjectList_Dalian(loginID, true, "PROGRESS");
                departmentList = getProgressDepartmentList();

                isMaritimeBizTeam = true;
            }     
        }
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }    

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>���� ��ȸ/�Է�</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // �ü��Է� ������ ����ڰ� �ƴ� ��� Exit
    <% if ((!mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPProgressViewHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="5" height="2"></td>
        </tr>
        <tr height="30">
            <td class="td_title" width="280">
                �� �� �� ȸ & �� ��
            </td>
            <td width="320">�μ�
                <select name="departmentList" style="width:280px;" onchange="departmentSelChanged();">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String str1 = (String)map.get("DEPT_CODE");
                        String str2 = str1 + ":&nbsp;";
                        //if (!((String)map.get("UP_DEPT_NAME")).equals((String)map.get("DEPT_NAME"))) 
                        //    str2 += (String)map.get("UP_DEPT_NAME") + "-" + (String)map.get("DEPT_NAME");
                        //else 
                        str2 += (String)map.get("DEPT_NAME");
                        String selected = ""; if (insaDepartmentCode.equals(str1)) selected = "selected";
                        %>
                        <option value="<%=str1%>" <%=selected%>><%=str2%></option>
                        <%
                    }
                    %>
                </select>
            </td>
            <td width="460">����
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressViewHeader', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                <select name="dateCondition" style="width:160px;background-color:#eeeeee;">
                    <option value="">&nbsp;</option>
                    <option value="DW_S">Drawing Start</option>
                    <option value="DW_F">Drawing Finish</option>
                    <option value="OW_S">Owner App. Submit</option>
                    <option value="OW_F">Owner App. Receive</option>
                    <option value="CL_S">Class App. Submit</option>
                    <option value="CL_F">Class App. Receive</option>
                    <option value="RF">Reference</option>
                    <option value="WK">Working</option>
                </select>
            </td>
            <td colspan="2">
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewDPProgress();"/>
                <input type="button" name="SavaButton" value='�� ��' class="button_simple" onclick="saveDPProgress();"/>
            </td>
        </tr>

        <tr height="30">
            <td>ȣ��
                <input type="text" name="projectInput" value="" style="width:100px;" onKeyUp="javascript:this.value=this.value.toUpperCase();"
                       onkeydown="inputCtrlKeydownHandler();">
                <input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" 
                       onclick="showProjectSel();">

                <div id="projectListDiv" STYLE="position:absolute; left:32; top:38; display:none;">
                <select name="projectList" style="width:130px; background-color:#eeeeee;" onchange="projectListChanged();">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; projectList != null && i < projectList.size(); i++) 
                    {
                        Map map = (Map)projectList.get(i);
                        String projectNo = (String)map.get("PROJECTNO");
                        String projectNoStr = projectNo;
                        //String dlEffective = (String)map.get("DL_EFFECTIVE");
                        //if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNoStr = "Z" + projectNo;
                        %>
                        <option value="<%=projectNo%>"><%=projectNoStr%></option>
                        <%
                    }
                    %>
                </select>
                </div>


                <% if (isAdmin.equals("Y")) { %>
                &nbsp;&nbsp;<input type="text" name="" value="��ȸ���� ȣ������" class="input_noBorder" style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" onclick="showSearchableProjects();" />
                <% } %>
            </td>
            <td>���
                <select name="designerList" style="width:160px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; personsList != null && i < personsList.size(); i++) {
                        Map map = (Map)personsList.get(i);
                        String empNo = (String)map.get("EMPLOYEE_NO");
                        String empName = (String)map.get("EMPLOYEE_NAME");
                        String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                        %>
                        <option value="<%=empNo%>"><%=empStr%></option>
                        <%
                    }
                    %>
                </select>
            </td>
            <td>�����ȣ
                <input type="text" name="drawingNo1" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '2');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo2" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '3');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo3" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '4');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo4" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '5');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo5" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '6');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo6" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '7');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo7" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '8');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo8" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '9');"  onkeydown="inputCtrlKeydownHandler();"/>
                <!--
                <input type="text" name="drawingNo9" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup('10');" />
                <input type="text" name="drawingNo10" value="" maxlength="1" style="width:18px;" />&nbsp;
                -->
                <input type="text" name="" value="clear" class="input_noBorder" style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDrawingNo();" />
                �����
                <input type="text" name="drawingTitle" value="" style="width:140px;" onkeydown="inputCtrlKeydownHandler();" onKeyUp="javascript:this.value=this.value.toUpperCase();" />
            </td>
            <td>
                <input type="button" name="PrintButton" value='�� ��' class="button_simple2" style="width:50px;" onclick="viewReport();"/>
                <% if ( true || isAdmin.equals("Y") || isMaritimeBizTeam/*(FOR MARITIME)*/) { %>
                    <input type="button" name="ExcelButton" value='�� ��' class="button_simple2" style="width:50px;" onclick="viewReportExcel();"/>
                <% } %>
            </td>
            <td>
                Total: <input name="projectTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;" />
            </td>
        </tr>

    
        <tr>
            <td colspan="5">
                <table width="100%" cellspacing="1" cellpadding="0" border="0" align="center">
                    <tr>
                    <td>
                        <table width="320" cellspacing="0" cellpadding="0" border="0" align="left">
                            <tr height="15">
                                <td class="td_keyEvent" rowspan="2" width="64" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:64px;background-color:#D8D8D8;" name="keyeventCT" />
                                </td>
                                <td class="td_keyEvent" rowspan="2" colspan="3" width="64" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:64px;background-color:#D8D8D8;" name="keyeventSC" />
                                </td>
                                <td class="td_keyEvent" colspan="2" width="64" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:64px;background-color:#D8D8D8;" name="keyeventKL" />
                                </td>
                                <td class="td_keyEvent" colspan="2" width="64" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:64px;background-color:#D8D8D8;" name="keyeventLC" />
                                </td>
                                <td class="td_keyEvent" rowspan="2" width="64" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:64px;background-color:#D8D8D8;" name="keyeventDL" />
                                </td>
                            </tr>
                            <tr height="6">
                                <td>
                                </td>
                                <td class="td_keyEvent" rowspan="2" colspan="2" bgcolor="#00008b">
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr height="3">
                                <td colspan="2">
                                </td>
                                <td rowspan="3" width="1%" bgcolor="#00008b">
                                </td>
                                <td class="td_keyEvent" colspan="2">
                                </td>
                                <td class="td_keyEvent" colspan="2">
                                </td>
                            </tr>
                            <tr style="height:3px;" bgColor="#00008b">
                                <td class="td_keyEvent" colspan="2">
                                </td>
                                <td class="td_keyEvent" colspan="6">
                                </td>
                            </tr>
                            <tr height="3">
                                <td class="td_keyEvent" colspan="2">
                                </td>
                                <td class="td_keyEvent" colspan="6">
                                </td>
                            </tr>
                        </table>
                    </td>

                    <td style="border: #00bb00 1px solid; font-size: 8pt;">
                        <input type="checkbox" name="colShowCheck1" checked />Project
                        <input type="checkbox" name="colShowCheck2" />Part
                        <input type="checkbox" name="colShowCheck3" />Drawing No.
                        <input type="checkbox" name="colShowCheck4" checked />Zone
                        <input type="checkbox" name="colShowCheck5" checked />Outsourcing Plan
                        <input type="checkbox" name="colShowCheck6" />Task
                        <input type="checkbox" name="colShowCheck7" />�����<br>
                        <input type="checkbox" name="colShowCheck8" />Drawing Start
                        <input type="checkbox" name="colShowCheck9" />Drawing Finish
                        <input type="checkbox" name="colShowCheck10" />Owner App. Submit
                        <input type="checkbox" name="colShowCheck11" />Owner App. Finish
                        <input type="checkbox" name="colShowCheck12" />Class App. Submit
                        <input type="checkbox" name="colShowCheck13" />Class App. Finish
                        <input type="checkbox" name="colShowCheck14" />REFERENCE
                        <input type="checkbox" name="colShowCheck15" />Construction
                    </td>

                    <% if (isAdmin.equals("Y")) { %>
                        <td style="border:#000000 2px solid;background-color: #f8f8f8;padding:0px, 4px, 0px, 4px;"
                            onmouseover="this.style.cursor='hand';" onclick="showProgressLockWin();">�� ��<br>�� ��
                        </td>
                    <% } %>
                </table>
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    parent.PROGRESS_VIEW_MAIN.location = "stxPECDPProgressViewMain_SP.jsp?showMsg=true"; // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���.

	// Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    // �μ� ������ ����Ǹ� �ش� �μ��� ������(��Ʈ��)�� ����� �����Ͽ� ��� SELECT LIST�� ä��
    function departmentSelChanged() 
    {
        for (var i = DPProgressViewHeader.designerList.options.length - 1; i > 0; i--) {
            DPProgressViewHeader.designerList.options[i] = null;
        }
        if (DPProgressViewHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=getPartPersonsForDPProgress&departCode=" + DPProgressViewHeader.departmentList.value, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null) 
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == "") return;

                    var strs = resultMsg.split("+");
                    for (var i = 0; i < strs.length; i++) {
                        var strs2 = strs[i].split("|");
                        var newOption = new Option(strs2[0] + "    " + strs2[1], strs2[0]);
                        DPProgressViewHeader.designerList.options[i + 1] = newOption;
                    }
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr = DPProgressViewHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressViewHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPProgressViewHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressViewHeader.dateSelectedTo.value = dateStr;
        }
    }

    // ��ȸ���� ȣ������ â�� Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPProgressViewHeader.loginID.value;
        var selectedProjects = window.showModalDialog("stxPECDPProgress_ProjectSelect_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;

        var changedList = selectedProjects.split(",");
        var currentSelect = DPProgressViewHeader.projectList.value;
        // Opened -> Closed�� ����� �׸��� ������ ����
        for (var i = 0; i < changedList.length; i++) {
            if (changedList[i].indexOf("CLOSED") > 0) {
                for (var j = DPProgressViewHeader.projectList.options.length - 1; j >= 1; j--) {
                    if (changedList[i].indexOf(DPProgressViewHeader.projectList.options[j].value) == 0) {
                        DPProgressViewHeader.projectList.options[j] = null;
                    }
                }
            }
        }
        // Closed -> Opened �� ����� �׸��� ������ �߰�
        for (var i = 0; i < changedList.length; i++) {
            if (changedList[i].indexOf("CLOSED") < 0) {
                var isExist = false;
                for (var j = 1; j < DPProgressViewHeader.projectList.options.length; j++) {
                    if (changedList[i].indexOf(DPProgressViewHeader.projectList.options[j].value) == 0) {
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) {
                    var strs = changedList[i].split("|");
                    DPProgressViewHeader.projectList.options[DPProgressViewHeader.projectList.options.length] = new Option(strs[0], strs[0]);
                }
            }
        }
    }

    // �Է����� ���� â�� Show
    function showProgressLockWin()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:400px;scroll=no;center:yes;status=no;';
        var result = window.showModalDialog("stxPECDPProgress_LockControl_SP.jsp", "", sProperties);
    }

    // �����ȣ �Է� �� ���� ĭ���� �ڵ� �̵�
    function drawingNoKeyup(inputObject, next)
    {
        inputObject.value = inputObject.value.toUpperCase();

        //var e = window.event;
        //if (e.keyCode != 9) { // Tab key down�̸� ����
        //    DPProgressViewHeader.all("drawingNo" + next).focus();
        //}
    }

    // �����ȣ �Է��� ��� Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) {
            DPProgressViewHeader.all("drawingNo" + i).value = "";
        }
    }

    // �Է� ���� üũ
    function checkInputs()
    {
        var str = DPProgressViewHeader.projectInput.value.trim();
        DPProgressViewHeader.projectList.options.selectedIndex = 0;
        for (var i = 0; i < DPProgressViewHeader.projectList.options.length; i++) {
            if (DPProgressViewHeader.projectList.options[i].value == str) {
                DPProgressViewHeader.projectList.options.selectedIndex = i;
                break;
            }
        }

        if (DPProgressViewHeader.projectList.value == "") {
            alert("�ùٸ� ȣ���̸��� �����Ͻʽÿ�.");
            return false;
        }
        //if (DPProgressViewHeader.departmentList.value == "") {
        //    alert("�μ��� �����Ͻʽÿ�.");
        //    return false;
        //}

        if ((DPProgressViewHeader.dateSelectedFrom.value != "" || DPProgressViewHeader.dateSelectedTo.value != "") &&
            DPProgressViewHeader.dateCondition.value == "")
        {
            alert("�˻����ڿ� ���� ������ �Է��Ͻʽÿ�!");
            DPProgressViewHeader.dateCondition.focus();
            return false;
        }

        return true;
    }

    // ������ȸ ����
    function viewDPProgress()
    {
        if (!checkInputs()) return;
        
        //// ����� �Է»����� ������ ��������� ���� ����
        //if (parent.PROGRESS_VIEW_MAIN.DPProgressViewMain != null) {
        //    var dataChanged = parent.PROGRESS_VIEW_MAIN.DPProgressViewMain.dataChanged.value;
        //    if (dataChanged == "true") {
        //        var msg = "����� ������ �ֽ��ϴ�. ��������� �����Ͻðڽ��ϱ�?\n\n" + 
        //                  "[Ȯ��] : ������� ���� , [���] ������� ����";
        //        if (confirm(msg)) saveDPInputs();
        //    }
        //}

        // ��ȸ
        var urlStr = "stxPECDPProgressViewMain_SP.jsp?projectNo=" + DPProgressViewHeader.projectList.value;
        urlStr += "&deptCode=" + DPProgressViewHeader.departmentList.value;
        urlStr += "&designerID=" + DPProgressViewHeader.designerList.value;
        urlStr += "&dateFrom=" + DPProgressViewHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPProgressViewHeader.dateSelectedTo.value;
        urlStr += "&dateCondition=" + DPProgressViewHeader.dateCondition.value;
        urlStr += "&drawingNo1=" + DPProgressViewHeader.drawingNo1.value;
        urlStr += "&drawingNo2=" + DPProgressViewHeader.drawingNo2.value;
        urlStr += "&drawingNo3=" + DPProgressViewHeader.drawingNo3.value;
        urlStr += "&drawingNo4=" + DPProgressViewHeader.drawingNo4.value;
        urlStr += "&drawingNo5=" + DPProgressViewHeader.drawingNo5.value;
        urlStr += "&drawingNo6=" + DPProgressViewHeader.drawingNo6.value;
        urlStr += "&drawingNo7=" + DPProgressViewHeader.drawingNo7.value;
        urlStr += "&drawingNo8=" + DPProgressViewHeader.drawingNo8.value;
        //urlStr += "&drawingNo9=" + DPProgressViewHeader.drawingNo9.value;
        //urlStr += "&drawingNo10=" + DPProgressViewHeader.drawingNo10.value;
        urlStr += "&drawingTitle=" + DPProgressViewHeader.drawingTitle.value;
        urlStr += "&isManager=" + DPProgressViewHeader.isManager.value;
        urlStr += "&isAdmin=" + DPProgressViewHeader.isAdmin.value;
        urlStr += "&userDept=" + DPProgressViewHeader.dwgDepartmentCode.value;
        
        urlStr += "&c1=" + DPProgressViewHeader.colShowCheck1.checked;
        urlStr += "&c2=" + DPProgressViewHeader.colShowCheck2.checked;
        urlStr += "&c3=" + DPProgressViewHeader.colShowCheck3.checked;
        urlStr += "&c4=" + DPProgressViewHeader.colShowCheck4.checked;
        urlStr += "&c5=" + DPProgressViewHeader.colShowCheck5.checked;
        urlStr += "&c6=" + DPProgressViewHeader.colShowCheck6.checked;
        urlStr += "&c7=" + DPProgressViewHeader.colShowCheck7.checked;
        urlStr += "&c8=" + DPProgressViewHeader.colShowCheck8.checked;
        urlStr += "&c9=" + DPProgressViewHeader.colShowCheck9.checked;
        urlStr += "&c10=" + DPProgressViewHeader.colShowCheck10.checked;
        urlStr += "&c11=" + DPProgressViewHeader.colShowCheck11.checked;
        urlStr += "&c12=" + DPProgressViewHeader.colShowCheck12.checked;
        urlStr += "&c13=" + DPProgressViewHeader.colShowCheck13.checked;
        urlStr += "&c14=" + DPProgressViewHeader.colShowCheck14.checked;
        urlStr += "&c15=" + DPProgressViewHeader.colShowCheck15.checked;

        parent.PROGRESS_VIEW_MAIN.location = urlStr;
    }

    // ���� �����ü� �Է»��� ����
    function saveDPProgress()
    {
        parent.PROGRESS_VIEW_MAIN.saveDPProgress();
    }

    // ����Ʈ(����Ʈ ���) - VIEW & PRINT ���
    function viewReport()
    {
        var rdFileName = "stxPECDPProgressView_SP.mrd";
        if (DPProgressViewHeader.isAdmin.value == "Y") rdFileName = "stxPECDPProgressViewAdmin_SP.mrd";
        viewReportProc(rdFileName);
    }
        
    // ����Ʈ(����Ʈ ���) - EXCEL EXPORT ���
    function viewReportExcel()
    {
        viewReportProc("stxPECDPProgressViewExcel_SP.mrd");
    }

    // ����Ʈ(����Ʈ ���) ���� ���ν���
    function viewReportProc(rdFileName)
    {
        if (!checkInputs()) return;

        var paramStr = DPProgressViewHeader.projectList.value + ":::" + 
                       DPProgressViewHeader.departmentList.value + ":::" + 
                       DPProgressViewHeader.designerList.value + ":::";

       var fromDate = DPProgressViewHeader.dateSelectedFrom.value;
       var toDate = DPProgressViewHeader.dateSelectedTo.value;
        
        if (fromDate != "" && toDate != "") { // ����-���� ������ �ݴ��̸� ����
            var tempStrs = fromDate.split("-");
            var fromDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
            tempStrs = toDate.split("-");
            var toDateObj = new Date(tempStrs[0], tempStrs[1] - 1, tempStrs[2]);
            if (fromDateObj > toDateObj) {
                var temp = toDate;
                toDate = fromDate;
                fromDate = temp;
            }
        }

        var dwStartFrom = ":::";
        var dwStartTo = ":::";
        var dwFinishFrom = ":::";
        var dwFinishTo = ":::";
        var owStartFrom = ":::";
        var owStartTo = ":::";
        var owFinishFrom = ":::";
        var owFinishTo = ":::";
        var clStartFrom = ":::";
        var clStartTo = ":::";
        var clFinishFrom = ":::";
        var clFinishTo = ":::";
        var rfStartFrom = ":::";
        var rfStartTo = ":::";
        var wkStartFrom = ":::";
        var wkStartTo = ":::";
        var sortValue = ":::";
        var sortType = "";

        if ((fromDate != "" || toDate != "") && DPProgressViewHeader.dateCondition.value != "") 
        {
            var dateCondition = DPProgressViewHeader.dateCondition.value;
            if (dateCondition == "DW_S") {
                dwStartFrom = fromDate + ":::";
                dwStartTo = toDate +  ":::";
            }
            if (dateCondition == "DW_F") {
                dwFinishFrom = fromDate + ":::";
                dwFinishTo = toDate +  ":::";
            }
            if (dateCondition == "OW_S") {
                owStartFrom = fromDate + ":::";
                owStartTo = toDate +  ":::";
            }
            if (dateCondition == "OW_F") {
                owFinishFrom = fromDate + ":::";
                owFinishTo = toDate +  ":::";
            }
            if (dateCondition == "CL_S") {
                clStartFrom = fromDate + ":::";
                clStartTo = toDate +  ":::";
            }
            if (dateCondition == "CL_F") {
                clFinishFrom = fromDate + ":::";
                clFinishTo = toDate +  ":::";
            }
            if (dateCondition == "RF") {
                rfStartFrom = fromDate + ":::";
                rfStartTo = toDate +  ":::";
            }
            if (dateCondition == "WK") {
                wkStartFrom = fromDate + ":::";
                wkStartTo = toDate +  ":::";
            }
        }

        var sortValue2 = parent.PROGRESS_VIEW_MAIN.DPProgressViewMain.sortValue.value;
        var sortType2 = parent.PROGRESS_VIEW_MAIN.DPProgressViewMain.sortType.value;
        if (rdFileName != "stxPECDPProgressViewExcel_SP.mrd")
        {
            if (sortValue2 != null && sortValue2 != "" && sortValue2 != "PROJECTNO" && sortValue2 != "DEPTNAME" && sortValue2 != "DWGZONE") 
            {
                if (sortValue2 == "NAME") sortValue2 = "EMPLOYEE_NAME";
                if (sortValue2 == "MAX_REV") sortValue2 = "MAX_REVISION";

                if (sortType2 == null || sortType2 == "" || sortType2 == "ascending") sortType2 = "ASC";
                else sortType2 = "DESC";

                sortValue = sortValue2 + ":::";
                sortType = sortType2;
            }
        }
        else
        {
            if (sortValue2 != null && sortValue2 != "" && sortValue2 != "DWGZONE") 
            {
                if (sortValue2 == "NAME") sortValue2 = "EMPLOYEE_NAME";
                if (sortValue2 == "MAX_REV") sortValue2 = "MAX_REVISION";

                if (sortType2 == null || sortType2 == "" || sortType2 == "ascending") sortType2 = "ASC";
                else sortType2 = "DESC";

                sortValue = sortValue2 + ":::";
                sortType = sortType2;
            }
        }

        paramStr += dwStartFrom + dwStartTo + dwFinishFrom + dwFinishTo + owStartFrom + owStartTo + owFinishFrom + owFinishTo + 
                    clStartFrom + clStartTo + clFinishFrom + clFinishTo + rfStartFrom + rfStartTo + wkStartFrom + wkStartTo;
  
        var dwgCode = "";
        for (var i = 1; i <= 8; i++) {
            var str = DPProgressViewHeader.all("drawingNo" + i).value;
            if (str == "") dwgCode += "_";
            else dwgCode += str;
        }

        paramStr += dwgCode + ":::";
        paramStr += DPProgressViewHeader.drawingTitle.value + ":::";
        paramStr += sortValue + sortType;
        paramStr = encodeURIComponent(paramStr);

        var urlStr = "http://172.16.2.13:7777/j2ee/STXDPSP/WebReport.jsp?src=<%=reportFileUrl%>" + rdFileName 
                     + "&param=" + paramStr;
        window.open(urlStr, "", "");
    }


    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // ȣ�� ���� SELECT BOX SHOW
    function showProjectSel()
    {
        var str = DPProgressViewHeader.projectInput.value.trim();
        DPProgressViewHeader.projectList.options.selectedIndex = 0;
        for (var i = 0; i < DPProgressViewHeader.projectList.options.length; i++) {
            if (DPProgressViewHeader.projectList.options[i].value == str) {
                DPProgressViewHeader.projectList.options.selectedIndex = i;
                break;
            }
        }
        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // ȣ�� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function projectListChanged()
    {
        DPProgressViewHeader.projectInput.value = DPProgressViewHeader.projectList.value;
        projectListDiv.style.display = "none";
    }

    // ���콺 Ŭ�� �� SELECT BOX ��Ʈ���� �����(�ش� ��Ʈ�ѿ� ���� ���콺 Ŭ���� �ƴ� ���)
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        var posX = event.clientX;
        var posY = event.clientY;
        var objPos = getAbsolutePosition(projectListDiv);
        if (posX < objPos.x || posX > objPos.x + projectListDiv.offsetWidth || posY < objPos.y  || posY > objPos.y + projectListDiv.offsetHeight)
        {
            projectListDiv.style.display = "none";
        }
    }


</script>

</html>