<%--  
��DESCRIPTION: ���� �⵵����(Hard Copy) ��ȸ �� ��� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPHardCopyDwgViewHeader.jsp
��CHANGING HISTORY: 
��    2010-03-17: Initiative
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

    ArrayList projectList = null;
    ArrayList departmentList = null;
    ArrayList personsList = null;

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

            projectList = getAllProjectList("");
            departmentList = getDepartmentList();
            personsList = getPartPersons(insaDepartmentCode);

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 
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
                departmentList = getDepartmentList();
                personsList = getPartPersons_Dalian(insaDepartmentCode);

                // (FOR MARITIME) �ؾ����ռ����� �ο��� ������ ���� üũ (* �ӽñ��)
                loginUserInfo = getEmployeeInfo_Maritime(loginID);
                if (loginUserInfo != null && ((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y";
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
<head><title>Drawing Distribution History Search and Resister</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS �ý��ۿ� ��ϵ� ����ڰ� �ƴ� ��� Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // �ü��Է� ������ ����ڰ� �ƴ� ��� Exit
    <% if ((!mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPHardCopyDwgViewHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="6" height="2"></td>
        </tr>


        <tr height="30">
            <td class="td_title" style="font-size:10pt;" width="170" rowspan="2">
                Drawing Distribution<br>History Search<br>and Resister
            </td>


            <td width="235">Project No.<br>
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
            </td>


            <td width="250">Dept.<br>
                <select name="departmentList" style="width:220px;" onchange="departmentSelChanged();">
                    <% 
                    if (1 != 1 /*!isAdmin.equals("Y")*/) { 
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


            <td width="290">Distribution No. Request Date<br>
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgViewHeader', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                <input type="text" name="" value="clear" class="input_noBorder" style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" 
                       onclick="clearDateSelected();" />
            </td>


            <td width="160">&nbsp;
            </td>


            <td colspan="2">
                <input type="button" name="ViewButton" value='Search' class="button_simple" onclick="viewHardCopyData();"/>
                <input type="button" name="PrintButton" value='Print' class="button_simple" onclick="viewReport();"/>
            </td>
        </tr>


        <tr height="30">
            <td>Dwg No.<br>
                <input type="text" name="drawingNo1" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '2');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo2" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '3');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo3" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '4');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo4" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '5');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo5" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '6');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo6" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '7');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo7" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '8');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo8" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '9');"  onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="" value="clear" class="input_noBorder" style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" 
                       onclick="clearDrawingNo();" />
            </td>


            <td>REV.<br>
                <input type="text" name="deployRevInput" value="" maxlength="2" style="width:100px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>

            
            <td>Distribution No. Requestor<br>
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


            <td>Distribution No.<br>
                <input type="text" name="deployNoInput" value="" maxlength="9" style="width:120px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>


            <td>
                <input type="button" name="CreateButton" value='Register' class="button_simple" onclick="createHardCopyData();"/>
                <% if (isAdmin.equals("Y")) { %>
                <input type="button" name="SavaButton" value='Save' class="button_simple" onclick="saveHardCopyData();"/>
                <input type="button" name="DeleteButton" value='Del.' class="button_simple" onclick="deleteHardCopyData();"/>
                <% } %>
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���.
    parent.HARDCOPY_VIEW_MAIN.location = "stxPECDPHardCopyDwgViewMain.jsp?showMsg=false&firstLoad=true"; 

	// Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // ȣ�� ���� SELECT BOX SHOW
    function showProjectSel()
    {
        var str = DPHardCopyDwgViewHeader.projectInput.value.trim();
        DPHardCopyDwgViewHeader.projectList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgViewHeader.projectList.options.length; i++) {
            if (DPHardCopyDwgViewHeader.projectList.options[i].value == str) {
                DPHardCopyDwgViewHeader.projectList.options.selectedIndex = i;
                break;
            }
        }

        var objPos = getAbsolutePosition(DPHardCopyDwgViewHeader.projectInput);
        projectListDiv.style.left = objPos.x;
        projectListDiv.style.top = objPos.y;

        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // ȣ�� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function projectListChanged()
    {
        DPHardCopyDwgViewHeader.projectInput.value = DPHardCopyDwgViewHeader.projectList.value;
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

    // �μ� ������ ����Ǹ� �ش� �μ��� ������(��Ʈ��)�� ����� �����Ͽ� ��� SELECT LIST�� ä��
    function departmentSelChanged() 
    {
        for (var i = DPHardCopyDwgViewHeader.designerList.options.length - 1; i > 0; i--) {
            DPHardCopyDwgViewHeader.designerList.options[i] = null;
        }
        if (DPHardCopyDwgViewHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetPartPersons&departCode=" + DPHardCopyDwgViewHeader.departmentList.value, false);
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
                        DPHardCopyDwgViewHeader.designerList.options[i + 1] = newOption;
                    }
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr = DPHardCopyDwgViewHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgViewHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPHardCopyDwgViewHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgViewHeader.dateSelectedTo.value = dateStr;
        }
    }

    // ���� �����׸� ��� ȭ�� Show
    function createHardCopyData()
    {
        var sProperties = 'dialogHeight:600px;dialogWidth:920px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPHardCopyDwgViewHeader.loginID.value;
        var selectedProjects = window.showModalDialog("stxPECDPHardCopyDwgCreateFS.jsp?" + paramStr, "", sProperties);
        //if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
    }

    // ��������� ����
    function saveHardCopyData()
    {
        parent.HARDCOPY_VIEW_MAIN.saveHardCopyData();
    }

    // ���õ� �׸��� ����
    function deleteHardCopyData()
    {
        parent.HARDCOPY_VIEW_MAIN.deleteHardCopyData();
    }

    // �Ƿ����� �Է��� ��� Clear
    function clearDateSelected()
    {
        DPHardCopyDwgViewHeader.dateSelectedFrom.value = "";
        DPHardCopyDwgViewHeader.dateSelectedTo.value = "";
    }

    // �����ȣ �Է��� ��� Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) {
            DPHardCopyDwgViewHeader.all("drawingNo" + i).value = "";
        }
    }

    // �����ȣ �Է� �� ���� ĭ���� �ڵ� �̵�
    function drawingNoKeyup(inputObject, next)
    {
        inputObject.value = inputObject.value.toUpperCase();

        //var e = window.event;
        //if (e.keyCode != 9) { // Tab key down�̸� ����
        //    DPHardCopyDwgViewHeader.all("drawingNo" + next).focus();
        //}
    }

    // ��ȸ
    function viewHardCopyData()
    {
        var urlStr = "stxPECDPHardCopyDwgViewMain.jsp?projectNo=" + DPHardCopyDwgViewHeader.projectInput.value;
        urlStr += "&deptCode=" + DPHardCopyDwgViewHeader.departmentList.value;
        urlStr += "&designerID=" + DPHardCopyDwgViewHeader.designerList.value;
        urlStr += "&dateFrom=" + DPHardCopyDwgViewHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPHardCopyDwgViewHeader.dateSelectedTo.value;
        urlStr += "&drawingNo1=" + DPHardCopyDwgViewHeader.drawingNo1.value;
        urlStr += "&drawingNo2=" + DPHardCopyDwgViewHeader.drawingNo2.value;
        urlStr += "&drawingNo3=" + DPHardCopyDwgViewHeader.drawingNo3.value;
        urlStr += "&drawingNo4=" + DPHardCopyDwgViewHeader.drawingNo4.value;
        urlStr += "&drawingNo5=" + DPHardCopyDwgViewHeader.drawingNo5.value;
        urlStr += "&drawingNo6=" + DPHardCopyDwgViewHeader.drawingNo6.value;
        urlStr += "&drawingNo7=" + DPHardCopyDwgViewHeader.drawingNo7.value;
        urlStr += "&drawingNo8=" + DPHardCopyDwgViewHeader.drawingNo8.value;
        urlStr += "&revNo=" + DPHardCopyDwgViewHeader.deployRevInput.value;
        urlStr += "&deployNo=" + DPHardCopyDwgViewHeader.deployNoInput.value;
        urlStr += "&isAdmin=" + DPHardCopyDwgViewHeader.isAdmin.value;
        urlStr += "&showMsg=true&firstLoad=false";

        parent.HARDCOPY_VIEW_MAIN.location = urlStr;
    }

    // ����Ʈ(����Ʈ ���) - VIEW & PRINT ���
    function viewReport()
    {
        var rdFileName = "stxPECDPHardCopyDwgView.mrd";
        viewReportProc(rdFileName);
    }

    // ����Ʈ(����Ʈ ���) ���� ���ν���
    function viewReportProc(rdFileName)
    {
        var paramStr = DPHardCopyDwgViewHeader.projectInput.value + ":::" + 
                       DPHardCopyDwgViewHeader.departmentList.value + ":::" + 
                       DPHardCopyDwgViewHeader.designerList.value + ":::";

        var fromDate = DPHardCopyDwgViewHeader.dateSelectedFrom.value;
        var toDate = DPHardCopyDwgViewHeader.dateSelectedTo.value;
        
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

        paramStr += fromDate + ":::" + 
                    toDate + ":::" + 
                    DPHardCopyDwgViewHeader.deployRevInput.value + ":::" + 
                    DPHardCopyDwgViewHeader.deployNoInput.value + ":::";

        var dwgCode = "";
        for (var i = 1; i <= 8; i++) {
            var str = DPHardCopyDwgViewHeader.all("drawingNo" + i).value;
            if (str == "") dwgCode += "_";
            else dwgCode += str;
        }

        paramStr += dwgCode + ":::";
        paramStr = encodeURIComponent(paramStr);

        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/" + rdFileName 
                     + "&param=" + paramStr;
        window.open(urlStr, "", "");
    }

</script>

</html>