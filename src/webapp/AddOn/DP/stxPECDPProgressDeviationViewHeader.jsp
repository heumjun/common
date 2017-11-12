<%--  
��DESCRIPTION: ���� ������Ȳ ��ȸ ȭ�� Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPProgressDeviationViewHeader.jsp
��CHANGING HISTORY: 
��    2009-04-14: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
	
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
    //String loginID = context.getUser(); // ������ ID : ������(��Ʈ�� ����) or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    
    String designerID = "";             // ������ ID 
    String mhInputYN = "";              // �ü��Է� ���� ����(�� ������ �����Է� ������ ������)
    String progressInputYN = "";        // �����Է� ���� ����
    String terminationDate = "";        // �����(��翩��)
    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String dwgDepartmentCode = "";      // �μ�(��Ʈ) �ڵ� - ����μ� �ڵ�
    String isAdmin = "N"; 

    String errStr = "";                 // DB Query �� ���� �߻� ����

    ArrayList departmentList = null;
    ArrayList personsList = null;

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

            departmentList = getProgressDepartmentList();
            personsList = getPartPersonsForDPProgress(insaDepartmentCode);
        }
        // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
        else {
            loginUserInfo = getEmployeeInfo_Dalian(loginID);

            if (loginUserInfo != null) 
            {
                designerID = loginID;

                mhInputYN = (String)loginUserInfo.get("MH_YN");
                progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
                terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
                insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
                dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

                departmentList = getProgressDepartmentList();
                personsList = getPartPersons_Dalian(insaDepartmentCode);
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
    <title>���� ������Ȳ ��ȸ</title>
</head>
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
<form name="DPProgressDeviationHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="4" height="2"></td>
        </tr>
        <tr height="30">
            <td class="td_title">
                ���� ������Ȳ ��ȸ
            </td>
            <td width="360">ȣ��
                <input type="text" name="projectList" value="" readonly style="width:180px;" />
                <input type="button" name="ProjectsButton" value="��" style="width=22px;" onclick="showProjectSelectWin();"/>
                <% if (isAdmin.equals("Y")) { %>
                &nbsp;&nbsp;<input type="text" name="" value="��ȸ���� ȣ������" class="input_noBorder" 
                                   style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" 
                                   onclick="showSearchableProjects();" />
                <% } %>
            </td>
            <td>�μ�
                <select name="departmentList" style="width:220px;" onchange="departmentSelChanged();">
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
                ���
                <select name="designerList" style="width:120px;">
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
                	�Ϸ�List����<input type="checkbox" name="searchComplete" value="true">
                	<%if(isAdmin.equals("Y")){ %>��üList����<input type="checkbox" name="searchAll" value="true"><%} else {%><input type="hidden" name="searchAll" value="false"><%} %>
            </td>
            <td>
                <input type="button" name="ViewButton" value='�� ȸ' class="button_simple2" style="width:40px;" onclick="viewDPProgressDeviation();"/>
                <input type="button" name="SavaButton" value='�� ��' class="button_simple2" style="width:40px;" onclick="saveDPProgressDeviation();"/>
                <input type="button" name="PrintButton" value='�� ��' class="button_simple2" style="width:40px;" onclick="viewReport();"/>
                <input type="button" name="ExcelButton" value='�� ��' class="button_simple2" style="width:40px;" onclick="viewReportExcel();"/>
            </td>
        </tr>
        <tr height="28">
            <td style="width:300px;" style="border-right-style:none;">���������� 
                <input type="text" name="dateSelected_from" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressDeviationHeader', 'dateSelected_from', '', false, dateChanged_from);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    ~
                <input type="text" name="dateSelected_to" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressDeviationHeader', 'dateSelected_to', '', false, dateChanged_to);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td colspan="3" rowspan="2" style="background-color:#dddddd;border-left:none;">
                <table width="100%" cellSpacing="0" cellpadding="0" border="0" align="left">
                <tr>
                    <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        B<br>A<br>S<br>I<br>C<br>
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="bAll" style="width:9pt;" checked onclick="toggleBasicChecks();" />ALL
                        <input type="checkbox" name="bDS" value="bDS" style="width:9pt;" checked />Design Start
                        <input type="checkbox" name="bDF" value="bDF" style="width:9pt;" checked />Design Finish
                        <input type="checkbox" name="bOS" value="bOS" style="width:9pt;" checked />OwnerApp.Submit<br>
                        <input type="checkbox" name="bOF" value="bOF" style="width:9pt;" checked />OwnerApp.Receive
                        <input type="checkbox" name="bCS" value="bCS" style="width:9pt;" checked />ClassApp.Submit
                        <input type="checkbox" name="bCF" value="bCF" style="width:9pt;" checked />ClassApp.Receive<br>
                        <input type="checkbox" name="bRF" value="bRF" style="width:9pt;" checked />Issued for Working
                        <input type="checkbox" name="bWK" value="bWK" style="width:9pt;" checked />Issued for Const
                    </td>
                    <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        M<br>A<br>K<br>E<br>R<br>
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="mAll" style="width:9pt;" onclick="toggleMakerChecks();" />ALL
                        <input type="checkbox" name="mDS" value="mDS" style="width:9pt;" checked />P.R.
                        <input type="checkbox" name="mDF" value="mDF" style="width:9pt;" />Vender Selection
                        <input type="checkbox" name="mOS" value="mOS" style="width:9pt;" />P.O.<br>
                        <input type="checkbox" name="mOF" value="mOF" style="width:9pt;" checked />VenderDwg.Receive
                        <input type="checkbox" name="mCS" value="mCS" style="width:9pt;" checked />OwnerApp.Submit
                        <input type="checkbox" name="mCF" value="mCF" style="width:9pt;" checked />OwnerApp.Receive<br>
                        <input type="checkbox" name="mRF" value="mRF" style="width:9pt;" checked />Issued for Working
                        <input type="checkbox" name="mWK" value="mWK" style="width:9pt;" checked />Issued for Const
                    </td>
                    <td style="font-size:7pt;font-weight:bold;line-height:8px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        P<br>R<br>O<br>D<br>U<br>C<br>T
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="pAll" style="width:9pt;" onclick="toggleProductionChecks();" />ALL
                        <input type="checkbox" name="pDS" value="pDS" style="width:9pt;" />Design Start
                        <input type="checkbox" name="pDF" value="pDF" style="width:9pt;" />Design Finish
                        <input type="checkbox" name="pOS" value="pOS" style="width:9pt;" />OwnerApp.Submit<br>
                        <input type="checkbox" name="pOF" value="pOF" style="width:9pt;" />OwnerApp.Receive
                        <input type="checkbox" name="pCS" value="pCS" style="width:9pt;" />ClassApp.Submit
                        <input type="checkbox" name="pCF" value="pCF" style="width:9pt;" />ClassApp.Receive<br>
                        <input type="checkbox" name="pRF" value="pRF" style="width:9pt;" />Issued for Working
                        <input type="checkbox" name="pWK" value="pWK" style="width:9pt;" checked />Issued for Const
                    </td>
                </tr>
                </table>
                <!--
                <input type="checkbox" name="DW_S" value="DW_S" style="width:10pt;" checked />&nbsp;DW(S)
                <input type="checkbox" name="OW_S" value="OW_S" style="width:10pt;" checked />&nbsp;OW(S)
                <input type="checkbox" name="CL_S" value="CL_S" style="width:10pt;" checked />&nbsp;CL(S)
                <input type="checkbox" name="RF" value="RF" style="width:10pt;" checked />&nbsp;RF
                <input type="checkbox" name="WK" value="WK" style="width:10pt;" checked />&nbsp;WK<br>
                <input type="checkbox" name="DW_F" value="DW_F" style="width:10pt;" checked />&nbsp;DW(F)
                <input type="checkbox" name="OW_F" value="OW_F" style="width:10pt;" checked />&nbsp;OW(F)
                <input type="checkbox" name="CL_F" value="CL_F" style="width:10pt;" checked />&nbsp;CL(F)
                -->
            </td>
        </tr>
        <tr height="30">
            <td bgcolor="#00ffff">
                <b>Total Deviation:</b>&nbsp;
                <input type="text" name="totalDeviation" value="" style="width:50px;background-color:#ffffcc" readonly="readonly" />
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    parent.PROGRESS_DEV_MAIN.location = "stxPECDPProgressDeviationViewMain.jsp"; // Header �������� ���� �ε�� �� Main �������� �ε�ǵ���.

	// Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    // ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged_from()
    {
        var tmpStr = DPProgressDeviationHeader.dateSelected_from.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressDeviationHeader.dateSelected_from.value = dateStr;
        }
    }
    
    function dateChanged_to()
    {
        var tmpStr = DPProgressDeviationHeader.dateSelected_to.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressDeviationHeader.dateSelected_to.value = dateStr;
        }
    }

    // ȣ������ ȭ�� �˾�
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPProgressDeviationHeader.projectList.value;
        paramStr += "&loginID=" + DPProgressDeviationHeader.loginID.value;
        paramStr += "&category=DEVIATION";
        var selectedProjects = window.showModalDialog("stxPECDPProgressDeviationView_ProjectSelect.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPProgressDeviationHeader.projectList.value = selectedProjects;
    }

    // ��ȸ���� ȣ������ â�� Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPProgressDeviationHeader.loginID.value;
        paramStr += "&category=DEVIATION";
        window.showModalDialog("stxPECDPProgressDeviation_ProjectSelect.jsp?" + paramStr, "", sProperties);
    }

    // �μ� ������ ����Ǹ� �ش� �μ��� ������(��Ʈ��)�� ����� �����Ͽ� ��� SELECT LIST�� ä��
    function departmentSelChanged() 
    {
        for (var i = DPProgressDeviationHeader.designerList.options.length - 1; i > 0; i--) {
            DPProgressDeviationHeader.designerList.options[i] = null;
        }
        if (DPProgressDeviationHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=getPartPersonsForDPProgress&departCode=" + 
                            DPProgressDeviationHeader.departmentList.value, false);
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
                        DPProgressDeviationHeader.designerList.options[i + 1] = newOption;
                    }
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // BASIC ���� ���������� üũ�׸��� ��� üũ or ��� üũ ����
    function toggleBasicChecks()
    {
        var checked = DPProgressDeviationHeader.bAll.checked;

        DPProgressDeviationHeader.bDS.checked = checked;
        DPProgressDeviationHeader.bDF.checked = checked;
        DPProgressDeviationHeader.bOS.checked = checked;
        DPProgressDeviationHeader.bOF.checked = checked;
        DPProgressDeviationHeader.bCS.checked = checked;
        DPProgressDeviationHeader.bCF.checked = checked;
        DPProgressDeviationHeader.bRF.checked = checked;
        DPProgressDeviationHeader.bWK.checked = checked;
    }

    // MAKER ���� ���������� üũ�׸��� ��� üũ or ��� üũ ����
    function toggleMakerChecks()
    {
        var checked = DPProgressDeviationHeader.mAll.checked;

        DPProgressDeviationHeader.mDS.checked = checked;
        DPProgressDeviationHeader.mDF.checked = checked;
        DPProgressDeviationHeader.mOS.checked = checked;
        DPProgressDeviationHeader.mOF.checked = checked;
        DPProgressDeviationHeader.mCS.checked = checked;
        DPProgressDeviationHeader.mCF.checked = checked;
        DPProgressDeviationHeader.mRF.checked = checked;
        DPProgressDeviationHeader.mWK.checked = checked;
    }

    // PRODUCTION ���� ���������� üũ�׸��� ��� üũ or ��� üũ ����
    function toggleProductionChecks()
    {
        var checked = DPProgressDeviationHeader.pAll.checked;

        DPProgressDeviationHeader.pDS.checked = checked;
        DPProgressDeviationHeader.pDF.checked = checked;
        DPProgressDeviationHeader.pOS.checked = checked;
        DPProgressDeviationHeader.pOF.checked = checked;
        DPProgressDeviationHeader.pCS.checked = checked;
        DPProgressDeviationHeader.pCF.checked = checked;
        DPProgressDeviationHeader.pRF.checked = checked;
        DPProgressDeviationHeader.pWK.checked = checked;
    }

    // �Է� ���� üũ
    function checkInputs()
    {
        if (DPProgressDeviationHeader.projectList.value == "") {
            alert("ȣ���� �����Ͻʽÿ�.");
            return false;
        }

        //if (DPProgressDeviationHeader.departmentList.value == "") {
        //    alert("�μ��� �����Ͻʽÿ�.");
        //    return false;
        //}
        if (DPProgressDeviationHeader.dateSelected_to.value == "") {
            alert("������������ �Է��Ͻʽÿ�.");
            return false;
        }

        if (DPProgressDeviationHeader.bDS.checked == false && 
            DPProgressDeviationHeader.bDF.checked == false && 
            DPProgressDeviationHeader.bOS.checked == false && 
            DPProgressDeviationHeader.bOF.checked == false && 
            DPProgressDeviationHeader.bCS.checked == false && 
            DPProgressDeviationHeader.bCF.checked == false && 
            DPProgressDeviationHeader.bRF.checked == false && 
            DPProgressDeviationHeader.bWK.checked == false && 
            DPProgressDeviationHeader.mDS.checked == false && 
            DPProgressDeviationHeader.mDF.checked == false && 
            DPProgressDeviationHeader.mOS.checked == false && 
            DPProgressDeviationHeader.mOF.checked == false && 
            DPProgressDeviationHeader.mCS.checked == false && 
            DPProgressDeviationHeader.mCF.checked == false && 
            DPProgressDeviationHeader.mRF.checked == false && 
            DPProgressDeviationHeader.mWK.checked == false && 
            DPProgressDeviationHeader.pDS.checked == false && 
            DPProgressDeviationHeader.pDF.checked == false && 
            DPProgressDeviationHeader.pOS.checked == false && 
            DPProgressDeviationHeader.pOF.checked == false && 
            DPProgressDeviationHeader.pCS.checked == false && 
            DPProgressDeviationHeader.pCF.checked == false && 
            DPProgressDeviationHeader.pRF.checked == false && 
            DPProgressDeviationHeader.pWK.checked == false
           )
        {
            alert("���������� ������ �ϳ� �̻� üũ�Ͻʽÿ�.");
            return false;
        }

        return true;
    }

    // ���� ������Ȳ ��ȸ ����
    function viewDPProgressDeviation()
    {
        if (!checkInputs()) return;

        //// ����� �Է»����� ������ ��������� ���� ����
        //if (parent.PROGRESS_DEV_MAIN.DPProgressDeviationMain != null) {
        //    var dataChanged = parent.PROGRESS_DEV_MAIN.DPProgressDeviationMain.dataChanged.value;
        //    if (dataChanged == "true") {
        //        var msg = "����� ������ �ֽ��ϴ�. ��������� �����Ͻðڽ��ϱ�?\n\n" + 
        //                  "[Ȯ��] : ������� ���� , [���] ������� ����";
        //        if (confirm(msg)) saveDPProgressDeviation();
        //    }
        //}

        // ��ȸ
        var urlStr = "stxPECDPProgressDeviationViewMain.jsp?projectNo=" + DPProgressDeviationHeader.projectList.value;
        urlStr += "&deptCode=" + DPProgressDeviationHeader.departmentList.value;
        urlStr += "&designerId=" + DPProgressDeviationHeader.designerList.value;
        urlStr += "&dateSelected_to=" + DPProgressDeviationHeader.dateSelected_to.value;
        urlStr += "&dateSelected_from=" + DPProgressDeviationHeader.dateSelected_from.value;
        urlStr += "&searchComplete=" + DPProgressDeviationHeader.searchComplete.checked;
        urlStr += "&searchAll=" + DPProgressDeviationHeader.searchAll.checked;
        urlStr += "&userDept=" + DPProgressDeviationHeader.dwgDepartmentCode.value;
        urlStr += "&isAdmin=" + DPProgressDeviationHeader.isAdmin.value;

        urlStr += "&bDS=" + (DPProgressDeviationHeader.bDS.checked ? "Y" : "N");
        urlStr += "&bDF=" + (DPProgressDeviationHeader.bDF.checked ? "Y" : "N");
        urlStr += "&bOS=" + (DPProgressDeviationHeader.bOS.checked ? "Y" : "N");
        urlStr += "&bOF=" + (DPProgressDeviationHeader.bOF.checked ? "Y" : "N");
        urlStr += "&bCS=" + (DPProgressDeviationHeader.bCS.checked ? "Y" : "N");
        urlStr += "&bCF=" + (DPProgressDeviationHeader.bCF.checked ? "Y" : "N");
        urlStr += "&bRF=" + (DPProgressDeviationHeader.bRF.checked ? "Y" : "N");
        urlStr += "&bWK=" + (DPProgressDeviationHeader.bWK.checked ? "Y" : "N");
        urlStr += "&mDS=" + (DPProgressDeviationHeader.mDS.checked ? "Y" : "N");
        urlStr += "&mDF=" + (DPProgressDeviationHeader.mDF.checked ? "Y" : "N");
        urlStr += "&mOS=" + (DPProgressDeviationHeader.mOS.checked ? "Y" : "N");
        urlStr += "&mOF=" + (DPProgressDeviationHeader.mOF.checked ? "Y" : "N");
        urlStr += "&mCS=" + (DPProgressDeviationHeader.mCS.checked ? "Y" : "N");
        urlStr += "&mCF=" + (DPProgressDeviationHeader.mCF.checked ? "Y" : "N");
        urlStr += "&mRF=" + (DPProgressDeviationHeader.mRF.checked ? "Y" : "N");
        urlStr += "&mWK=" + (DPProgressDeviationHeader.mWK.checked ? "Y" : "N");
        urlStr += "&pDS=" + (DPProgressDeviationHeader.pDS.checked ? "Y" : "N");
        urlStr += "&pDF=" + (DPProgressDeviationHeader.pDF.checked ? "Y" : "N");
        urlStr += "&pOS=" + (DPProgressDeviationHeader.pOS.checked ? "Y" : "N");
        urlStr += "&pOF=" + (DPProgressDeviationHeader.pOF.checked ? "Y" : "N");
        urlStr += "&pCS=" + (DPProgressDeviationHeader.pCS.checked ? "Y" : "N");
        urlStr += "&pCF=" + (DPProgressDeviationHeader.pCF.checked ? "Y" : "N");
        urlStr += "&pRF=" + (DPProgressDeviationHeader.pRF.checked ? "Y" : "N");
        urlStr += "&pWK=" + (DPProgressDeviationHeader.pWK.checked ? "Y" : "N");

        parent.PROGRESS_DEV_MAIN.location = urlStr;
    }

    // �Է»��� ����
    function saveDPProgressDeviation()
    {
        parent.PROGRESS_DEV_MAIN.saveDPProgressDev();
    }

    // ����Ʈ(����Ʈ ���) - VIEW & PRINT ���
    function viewReport()
    {
        var rdFileName = "stxPECDPProgressDeviationViewAdmin.mrd";
        //if (DPProgressDeviationHeader.isAdmin.value != "Y") rdFileName = "stxPECDPProgressDeviationView.mrd";
        viewReportProc(rdFileName);
    }

    // ����Ʈ(����Ʈ ���) - EXCEL EXPORT ���
    function viewReportExcel()
    {
        viewReportProc("stxPECDPProgressDeviationViewExcel.mrd");
    }

    // ����Ʈ(����Ʈ ���) ���� ���ν���
    function viewReportProc(rdFileName)
    {
        if (!checkInputs()) return;

        var projectNoStrs = DPProgressDeviationHeader.projectList.value;

		var strs = projectNoStrs.split(",");
        projectNoStrs = "";
		for (var i = 0; i < strs.length; i++) {
			var tempStr = strs[i];
			if (i > 0) projectNoStrs += ",";
			projectNoStrs += "'" + tempStr.trim() + "'";
		}

        var paramStr = projectNoStrs + ":::" + 
                       DPProgressDeviationHeader.departmentList.value + ":::" + 
                       DPProgressDeviationHeader.dateSelected_to.value + ":::";

        paramStr += (DPProgressDeviationHeader.bDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.dateSelected_from.value == '' ? 'N' : DPProgressDeviationHeader.dateSelected_from.value) + ":::";
        paramStr += (DPProgressDeviationHeader.searchComplete.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.searchAll.checked ? "Y" : "N");
        //paramStr = encodeURIComponent(paramStr);
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=<%=reportFileUrl%>" + rdFileName 
                      + "&param=" + paramStr;
        window.open(urlStr, "", "");
    }

    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� ���� ��¥�� �������� ���� */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;

    DPProgressDeviationHeader.dateSelected_to.value = ymd;


</script>


</html>