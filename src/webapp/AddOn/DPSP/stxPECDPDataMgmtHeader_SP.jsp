<%--  
��TITLE: ����ü� DATA ���� ȭ�� Header �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPDataMgmtHeader.jsp
��CHANGING HISTORY: 
��    2009-07-29: Initiative
��DESCRIPTION:
        ����ü� DATA ���� ȭ���� Header �κ����� �� ����� ������ �� �ִ� ����
    �� �ִ��� üũ�ϰ�, DATA ��ȸ�� ����� OPTION �׸���� �����Ѵ�. 
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
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

    ArrayList departmentList = null;
    ArrayList factorCaseList = null;

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");

            departmentList = getProgressDepartmentList();
            factorCaseList = getMHFactorCaseAndValueList();

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            isManager = isDepartmentManagerYN(titleStr);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }    
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>����ü� DATA ����</title></head>
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
    <% if (!isAdmin.equalsIgnoreCase("Y") || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPDataMgmtHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">

        <tr>
            <td colspan="5" height="2"></td>
        </tr>

        <tr height="30">
            <td class="td_title" width="360">
                ����ü� DATA ����
            </td>
            <td id="departmentTD" width="360">�μ�
                <input type="text" name="departmentList" value="" readonly style="width:260px;" onmouseover="showDeptHint(this);" />
                <input type="button" name="departmentButton" value="��" style="width=22px;" onclick="showDepartmentSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDepartmentList();" />
            </td>
            <td width="280">����
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDataMgmtHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDataMgmtHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple" onclick="viewDPInputsList();"/>
                <input type="button" name="SavaButton" value='�� ��' class="button_simple" onclick="saveDPInputChange();"/>
            </td>
        </tr>

        <tr height="30">
            <td>ȣ��
                <input type="text" name="projectList" value="" style="width:260px;" />
                <input type="button" name="projectButton" value="��" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="projectList.value=''" />
            </td>
            <td>���
                <select name="designerList" style="width:160px;">
                    <option value="">&nbsp;</option>
                </select>
                <input type="text" name="designerInput" value="" style="width:80px;background-color:#e8e8e8;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <td>�����ȣ
                <input type="text" name="drawingNo1" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '2');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo2" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '3');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo3" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '4');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo4" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '5');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo5" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '6');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo6" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '7');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo7" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '8');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="drawingNo8" value="" maxlength="1" style="width:18px;" onkeyup="drawingNoKeyup(this, '9');"  
                       onkeydown="inputCtrlKeydownHandler();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDrawingNo();" />
            </td>
            <td>
                &nbsp;<!--<input type="button" name="reportButton" value='����Ʈ' class="button_simple2" onclick="viewReport();"/>-->
            </td>
        </tr>

        <tr height="30">
            <td>���� CASE
                <select name="factorCaseList" style="width:270px;">
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
            <td>OP CODE
                <input type="text" name="opCode" value="" style="width:130px;" />
            </td>
            <td>���κμ�
                <select name="causeDeptList" style="width:280px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String str1 = (String)map.get("DEPT_CODE");
                        String str2 = str1 + ":&nbsp;";
                        str2 += (String)map.get("DEPT_NAME");
                        String selected = ""; 
                        %>
                        <option value="<%=str1%>" <%=selected%>><%=str2%></option>
                        <%
                    }
                    %>
                </select>
            </td>
            <td>
                &nbsp;
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
        var paramStr = "selectedDepartments=" + DPDataMgmtHeader.departmentList.value;
        var selectedDepartmentsStr = window.showModalDialog("stxPECDPDataMgmt_SelectDepartment_SP.jsp?" + paramStr, "", sProperties);

        if (selectedDepartmentsStr != null && selectedDepartmentsStr != 'undefined') 
        {
            var strs = selectedDepartmentsStr.split("|");
            DPDataMgmtHeader.departmentList.value = strs[0];
            deptCodeHintStr = "";
            if (strs[1] != "") {
                var strs2 = strs[1].split(",");
                for (var i = 0; i < strs2.length; i++) {
                    deptCodeHintStr += strs2[i];
                    deptCodeHintStr += ";&nbsp;&nbsp;";
                }
            }

            departmentSelChanged();
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
        DPDataMgmtHeader.departmentList.value = "";
        deptCodeHintStr = "";
        departmentSelChanged();
    }

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr = DPDataMgmtHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPDataMgmtHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPDataMgmtHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPDataMgmtHeader.dateSelectedTo.value = dateStr;
        }
    }

    // From ��¥ ���� �� To ��¥�� �ش� �� ���Ϸ� �ڵ� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPDataMgmtHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPDataMgmtHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // ȣ������ ȭ�� �˾�
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPDataMgmtHeader.projectList.value;
        var selectedProjects = window.showModalDialog("stxPECDPDataMgmt_SelectProject_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPDataMgmtHeader.projectList.value = selectedProjects;
    }

    // �μ� ������ ����Ǹ� �ش� �μ��� ������(��Ʈ��)�� ����� �����Ͽ� ��� SELECT LIST�� ä��
    function departmentSelChanged() 
    {
        for (var i = DPDataMgmtHeader.designerList.options.length - 1; i > 0; i--) {
            DPDataMgmtHeader.designerList.options[i] = null;
        }
        if (DPDataMgmtHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", 
            "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=GetPartPersons2&departCodes=" + DPDataMgmtHeader.departmentList.value, false);
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
                        DPDataMgmtHeader.designerList.options[i + 1] = newOption;
                    }
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // �����ȣ �Է� �� ���� ĭ���� �ڵ� �̵�
    function drawingNoKeyup(inputObject, next)
    {
        inputObject.value = inputObject.value.toUpperCase();

        //var e = window.event;
        //if (e.keyCode != 9) { // Tab key down�̸� ����
        //    DPDataMgmtHeader.all("drawingNo" + next).focus();
        //}
    }

    // �����ȣ �Է��� ��� Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) {
            DPDataMgmtHeader.all("drawingNo" + i).value = "";
        }
    }

    // ��ȸ ����
    function viewDPInputsList()
    {
        //if (!checkInputs()) return;
        
        // ����� �Է»����� ������ ��������� ���� ����
        if (parent.DP_DATAMGMT_MAIN.DPDataMgmtMain != null) {
            var dataChangedCnt = parent.DP_DATAMGMT_MAIN.departmentChangedList.length;
            if (dataChangedCnt > 0) {
                var msg = "����� ������ �ֽ��ϴ�!\n\n��������� �����ϰ� ��ȸ�� �����Ͻðڽ��ϱ�?";
                if (!confirm(msg)) return;
            }
        }

        var projectNoStr = DPDataMgmtHeader.projectList.value.trim();
        if (projectNoStr != "") {
            var strs = projectNoStr.split(",");
            projectNoStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectNoStr += ",";
                projectNoStr += "'" + strs[i].trim() + "'";
            }
        }

        var departmentStr = DPDataMgmtHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }

        var opCodeStr = DPDataMgmtHeader.opCode.value.trim();
        if (opCodeStr != "") {
            var strs = opCodeStr.split(",");
            opCodeStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) opCodeStr += ",";
                opCodeStr += "'" + strs[i].trim() + "'";
            }
        }

        var urlStr = "stxPECDPDataMgmtMain_SP.jsp?";
        urlStr += "&deptCode=" + departmentStr;
        if (DPDataMgmtHeader.designerInput.value.trim() != "")
            urlStr += "&designerID=" + DPDataMgmtHeader.designerInput.value.trim();
        else 
            urlStr += "&designerID=" + DPDataMgmtHeader.designerList.value;
        urlStr += "&dateFrom=" + DPDataMgmtHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPDataMgmtHeader.dateSelectedTo.value;
        urlStr += "&projectNo=" + projectNoStr;
        urlStr += "&causeDeptCode=" + DPDataMgmtHeader.causeDeptList.value;
        urlStr += "&drawingNo1=" + DPDataMgmtHeader.drawingNo1.value;
        urlStr += "&drawingNo2=" + DPDataMgmtHeader.drawingNo2.value;
        urlStr += "&drawingNo3=" + DPDataMgmtHeader.drawingNo3.value;
        urlStr += "&drawingNo4=" + DPDataMgmtHeader.drawingNo4.value;
        urlStr += "&drawingNo5=" + DPDataMgmtHeader.drawingNo5.value;
        urlStr += "&drawingNo6=" + DPDataMgmtHeader.drawingNo6.value;
        urlStr += "&drawingNo7=" + DPDataMgmtHeader.drawingNo7.value;
        urlStr += "&drawingNo8=" + DPDataMgmtHeader.drawingNo8.value;
        urlStr += "&opCode=" + opCodeStr;
        urlStr += "&factorCase=" + DPDataMgmtHeader.factorCaseList.value;
        urlStr += "&isAdmin=" + DPDataMgmtHeader.isAdmin.value;
        urlStr += "&firstCall=N";
        urlStr += "&loginID=" + DPDataMgmtHeader.loginID.value;
        parent.DP_DATAMGMT_MAIN.location = urlStr;
    }

    // �μ� ���������� ����
    function saveDPInputChange()
    {
        parent.DP_DATAMGMT_MAIN.saveDepartmentChange();
    }

    //// ����Ʈ(����Ʈ ���)
    //function viewReport()
    //{
    //    alert("����(����) ��...");
    //}

    // �˻����ڸ� �⺻ ���ó�¥�� ����
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    var toYMD = y1 + "-" + m1 + "-" + d1;
    var fromYMD = toYMD;    

    DPDataMgmtHeader.dateSelectedFrom.value = fromYMD;
    DPDataMgmtHeader.dateSelectedTo.value = toYMD;
    
    // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���
    parent.DP_DATAMGMT_MAIN.location = "stxPECDPDataMgmtMain_SP.jsp?firstCall=Y"; 

</script>

</html>