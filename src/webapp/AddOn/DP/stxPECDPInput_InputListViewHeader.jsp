<%--  
��DESCRIPTION: ����ü��Է� - �Է½ü� ��ȸ Header Toolbar �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_InputListViewHeader.jsp
��CHANGING HISTORY: 
��    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
	//String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/ematrix/report/";
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
	//System.out.println("reportFileUrl = "+reportFileUrl);

    String dpDesignerID = "";           // ������ ID
    String dpDesignerName = "";         // ������ �̸�

    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String insaDepartmentName = "";     // �μ�(��Ʈ) �̸� - �λ������� �̸�
    String insaUpDepartmentName = "";   // �����μ� �̸�

    boolean isAdmin = false;            // ������ ����
    boolean isManager = false;             // ��Ʈ�� ����

    ArrayList departmentList = null;      // ����μ� ��� 
    ArrayList personList = null;          // ������ �μ� �Ҽ��� ������ ���
    ArrayList selectedProjectList = null; // ���ð��� ȣ�� ���
    String errStr = "";                 // DB Query �� ���� �߻� ����

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try 
    {
        Map loginUserInfo = getEmployeeInfo(loginID);
        if (loginUserInfo != null) 
        {
            dpDesignerID = loginID;     
            dpDesignerName = (String)loginUserInfo.get("NAME");

            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            insaDepartmentName = (String)loginUserInfo.get("DEPT_NAME");
            insaUpDepartmentName = (String)loginUserInfo.get("UP_DEPT_NAME");

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            if ("Y".equals(isDepartmentManagerYN(titleStr))) isManager = true;
            departmentList = getDepartmentList();

            if (isAdmin || isManager) personList = getPartPersons(insaDepartmentCode);
            selectedProjectList = getSelectedProjectList(loginID);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>�� �� ü ũ</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputListViewHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="28">
            <td>�μ�
                <select name="departmentSel" class="input_small" style="width:210px;" onchange="departmentSelChanged();">
                    <% 
                    if (!isAdmin) { 
                        String insaDepartmentStr = insaDepartmentCode + ":" /*+ insaUpDepartmentName + "-"*/ + insaDepartmentName;
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
                            String deptStr = deptCode + ":" + /*upDeptName + "-" +*/ deptName;
                            String selected = ""; if (insaDepartmentCode.equals(deptCode)) selected = "selected";
                            %>
                            <option value="<%=deptCode%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td>����
                <input type="text" name="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputListViewHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                <a href="javascript:showCalendar('DPInputListViewHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                <input type="text" name="" value="clear" class="input_noBorder" style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearSelectedDate();" />
            </td>
            <td>ȣ��
                <input type="text" name="projectInput" value="" style="width:60px; height:19px;" onKeyUp="javascript:this.value=this.value.toUpperCase();"
                       onkeydown="inputCtrlKeydownHandler();">
                <input type="button" name="showprojectListBtn" value="+" style="width:20px;height:20px;font-weight:bold;" 
                       onclick="showProjectSel();">

                <div id="projectListDiv" STYLE="position:absolute; left:717; top:6; display:none;">
                <select name="projectSel" class="input_small" style="width:83px;" onchange="projectListChanged();">
                    <option value="">&nbsp;</option>
                    <option value="S000">S000</option>
                    <%
                    for (int j = 0; selectedProjectList != null && j < selectedProjectList.size(); j++) {
                        Map map = (Map)selectedProjectList.get(j);
                        String projectNo = (String)map.get("PROJECTNO");
                        String dlEffective = (String)map.get("DL_EFFECTIVE");
                        if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNo = "Z" + projectNo;
                    %>
                        <option value="<%=projectNo%>"><%=projectNo%></option>
                    <%
                    }
                    %>
                </select>
                </div>
            </td>
            <td colspan="2">���κμ�
                <select name="causeDepartmentSel" class="input_small" style="width:210px;">
                    <option value="">&nbsp;</option>
                    <% 
                    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String deptCode = (String)map.get("DEPT_CODE");
                        String deptName = (String)map.get("DEPT_NAME");
                        String upDeptName = (String)map.get("UP_DEPT_NAME");
                        String deptStr = deptCode + ":" + /*upDeptName + "-" +*/ deptName;
                        %>
                        <option value="<%=deptCode%>"><%=deptStr%></option>
                        <%
                    }
                    %>
                </select>
            </td>
        </tr>

        <tr height="28">
            <td>���
                <select name="dpDesignerIDSel" class="input_small" style="width:150px;">
                    <% 
                    if (!isAdmin && !isManager) { 
                        String dpDesignerStr = dpDesignerID + ":" + dpDesignerName;
                    %>
                        <option value="<%=dpDesignerID%>"><%=dpDesignerStr%></option>
                    <% 
                    } else { 
                        %>
                        <option value="">&nbsp;</option>
                        <%
                        for (int i = 0; personList != null && i < personList.size(); i++) {
                            Map map = (Map)personList.get(i);
                            String designerID = (String)map.get("EMPLOYEE_NO");
                            String designerName = (String)map.get("EMPLOYEE_NAME");
                            String designerStr = designerID + ":" + designerName;
                            String selected = ""; if (dpDesignerID.equals(designerID)) selected = "selected";
                            %>
                            <option value="<%=designerID%>" <%=selected%>><%=designerStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td>�����ȣ
                <input type="text" name="drawingNo1" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo2" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo3" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo4" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo5" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo6" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo7" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="drawingNo8" value="" maxlength="1" style="width:18px;" />
                <input type="text" name="" value="clear" class="input_noBorder" style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDrawingNo();" />
            </td>
            <td>OP&nbsp;
                <input type="text" name="opCode" value="" class="input_small" style="width:50px;" />
            </td>
            <td>Event
                <input type="checkbox" name="checkE1" value="E1" class="input_small" />E1
                <input type="checkbox" name="checkE2" value="E2" class="input_small" />E2
                <input type="checkbox" name="checkE3" value="E3" class="input_small" />E3
            </td>
            <td>
                <input type="button" name="viewButton" value="�� ȸ" style="width:80px;height:25px;" onclick="viewInputList();" />
            </td>
        </tr>
    </table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    // ������ ��忡�� �μ��� ����Ǹ� ����� ���õ� �׸���� ��� �ʱ�ȭ
    function departmentSelChanged() 
    {
        for (var i = DPInputListViewHeader.dpDesignerIDSel.options.length - 1; i >= 1; i--) 
            DPInputListViewHeader.dpDesignerIDSel.options[i] = null;

        if (DPInputListViewHeader.departmentSel.value == "") return;

        // ���õ� �μ�(��Ʈ)�� ������(��Ʈ��) ����� ����
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetPartPersons&departCode=" + 
                            DPInputListViewHeader.departmentSel.value, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    var strs = resultMsg.split("+");

                    for (var i = 0; i < strs.length; i++) {
                        var strs2 = strs[i].split("|");
                        var newOption = new Option(strs2[0] + ":" + strs2[1], strs2[0]);
                        DPInputListViewHeader.dpDesignerIDSel.options[i + 1] = newOption;
                    }
                }
            }
            else alert(resultMsg);
        }
        else alert(resultMsg);
    }

    // Į���ٸ� ���� ��¥���� �� ��¥ ��� ���ڿ��� ����ȭ
    function dateChanged()
    {
        var tmpStr1 = DPInputListViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPInputListViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPInputListViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPInputListViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From ��¥ ���� �� To ��¥�� �ش�� ������ ���� ����
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPInputListViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPInputListViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;
    }

    // ���� �Է��� ��� Clear
    function clearSelectedDate()
    {
        DPInputListViewHeader.dateSelectedFrom.value = "";
        DPInputListViewHeader.dateSelectedTo.value = "";
    }

    // �����ȣ �Է��� ��� Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) DPInputListViewHeader.all("drawingNo" + i).value = "";
    }

    // �ü��Է� ��Ȳ�� ��ȸ
    function viewInputList() 
    {
        var departmentSel = DPInputListViewHeader.departmentSel.value;
        var designerIDSel = DPInputListViewHeader.dpDesignerIDSel.value;
        var dateSelectedFrom = DPInputListViewHeader.dateSelectedFrom.value;
        var dateSelectedTo = DPInputListViewHeader.dateSelectedTo.value;
        var projectSel = DPInputListViewHeader.projectInput.value;

        //if (departmentSel == "" || designerIDSel == "") {
        //    alert("��ȸ�� �μ��� �����ڸ� ���� �����Ͻʽÿ�!");
        //    return;
        //}
        if (projectSel == "" && (dateSelectedFrom == "" || dateSelectedTo == "")) 
        {
            alert("��ȸ���� �Ǵ� ȣ�� �� ��� �ϳ��� ������ �Ǿ�� �մϴ�!");
            return;
        }

        /*
        if (projectSel != "")
        {
            DPInputListViewHeader.projectSel.options.selectedIndex = 0;
            for (var i = 0; i < DPInputListViewHeader.projectSel.options.length; i++) {
                if (DPInputListViewHeader.projectSel.options[i].value == projectSel) {
                    DPInputListViewHeader.projectSel.options.selectedIndex = i;
                    break;
                }
            }
            if (DPInputListViewHeader.projectSel.value == "") {
                alert("�ùٸ� ȣ���̸��� �����Ͻʽÿ�.");
                return false;
            }
        }
        */

        var urlStr = "stxPECDPInput_InputListViewMain.jsp?";
        urlStr += "deptCode=" + departmentSel;
        urlStr += "&designerID=" + designerIDSel;
        urlStr += "&dateFrom=" + dateSelectedFrom;
        urlStr += "&dateTo=" + dateSelectedTo;
        urlStr += "&projectNo=" + projectSel;
        urlStr += "&causeDeptCode=" + DPInputListViewHeader.causeDepartmentSel.value;
        urlStr += "&drawingNo1=" + DPInputListViewHeader.drawingNo1.value;
        urlStr += "&drawingNo2=" + DPInputListViewHeader.drawingNo2.value;
        urlStr += "&drawingNo3=" + DPInputListViewHeader.drawingNo3.value;
        urlStr += "&drawingNo4=" + DPInputListViewHeader.drawingNo4.value;
        urlStr += "&drawingNo5=" + DPInputListViewHeader.drawingNo5.value;
        urlStr += "&drawingNo6=" + DPInputListViewHeader.drawingNo6.value;
        urlStr += "&drawingNo7=" + DPInputListViewHeader.drawingNo7.value;
        urlStr += "&drawingNo8=" + DPInputListViewHeader.drawingNo8.value;
        urlStr += "&opCode=" + DPInputListViewHeader.opCode.value;
        urlStr += "&e1=" + DPInputListViewHeader.checkE1.checked;
        urlStr += "&e2=" + DPInputListViewHeader.checkE2.checked;
        urlStr += "&e3=" + DPInputListViewHeader.checkE3.checked;

        parent.DP_VIEW_MAIN.location = urlStr;

    }

    // ����Ʈ(����Ʈ ���)
    function printPage()
    {
        var designerIDSel = DPInputListViewHeader.dpDesignerIDSel.value;
        var dateSelectedFrom = DPInputListViewHeader.dateSelectedFrom.value;
        var dateSelectedTo = DPInputListViewHeader.dateSelectedTo.value;
        var projectSel = DPInputListViewHeader.projectInput.value;
        var causeDeptCode = DPInputListViewHeader.causeDepartmentSel.value;
        var departmentSel = DPInputListViewHeader.departmentSel.value;
        
        if (projectSel == "" && (dateSelectedFrom == "" || dateSelectedTo == "")) 
        {
            alert("��ȸ���� �Ǵ� ȣ�� �� ��� �ϳ��� ������ �Ǿ�� �մϴ�!");
            return;
        }

        /*
        if (projectSel != "")
        {
            DPInputListViewHeader.projectSel.options.selectedIndex = 0;
            for (var i = 0; i < DPInputListViewHeader.projectSel.options.length; i++) {
                if (DPInputListViewHeader.projectSel.options[i].value == projectSel) {
                    DPInputListViewHeader.projectSel.options.selectedIndex = i;
                    break;
                }
            }
            if (DPInputListViewHeader.projectSel.value == "") {
                alert("�ùٸ� ȣ���̸��� �����Ͻʽÿ�.");
                return false;
            }
        }
        */

		var drawingNo = "";
        drawingNo += DPInputListViewHeader.drawingNo1.value == "" ? "_" : DPInputListViewHeader.drawingNo1.value;
        drawingNo += DPInputListViewHeader.drawingNo2.value == "" ? "_" : DPInputListViewHeader.drawingNo2.value;
        drawingNo += DPInputListViewHeader.drawingNo3.value == "" ? "_" : DPInputListViewHeader.drawingNo3.value;
        drawingNo += DPInputListViewHeader.drawingNo4.value == "" ? "_" : DPInputListViewHeader.drawingNo4.value;
        drawingNo += DPInputListViewHeader.drawingNo5.value == "" ? "_" : DPInputListViewHeader.drawingNo5.value;
        drawingNo += DPInputListViewHeader.drawingNo6.value == "" ? "_" : DPInputListViewHeader.drawingNo6.value;
        drawingNo += DPInputListViewHeader.drawingNo7.value == "" ? "_" : DPInputListViewHeader.drawingNo7.value;
        drawingNo += DPInputListViewHeader.drawingNo8.value == "" ? "_" : DPInputListViewHeader.drawingNo8.value;
        if (drawingNo == "________") drawingNo = "";
        else drawingNo = "%" + drawingNo + "%";

        var opCode = DPInputListViewHeader.opCode.value;
        var e1 = DPInputListViewHeader.checkE1.checked ? "Y" : "N";
        var e2 = DPInputListViewHeader.checkE2.checked ? "Y" : "N";
        var e3 = DPInputListViewHeader.checkE3.checked ? "Y" : "N";

        var paramStr = designerIDSel + ":::" + 
                       dateSelectedFrom + ":::" + 
                       dateSelectedTo + ":::" + 
                       projectSel + ":::" + 
                       causeDeptCode + ":::" + 
                       drawingNo + ":::" +  
                       opCode + ":::" +  
                       e1 + ":::" +  
                       e2 + ":::" +  
                       e3 + ":::" +  
                       departmentSel; 
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=<%=reportFileUrl%>stxPECDPInput_InputListView.mrd&param=" + paramStr;

        window.open(urlStr, "", "");
    }


    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // ȣ�� ���� SELECT BOX SHOW
    function showProjectSel()
    {
        var str = DPInputListViewHeader.projectInput.value.trim();
        DPInputListViewHeader.projectSel.options.selectedIndex = 0;
        for (var i = 0; i < DPInputListViewHeader.projectSel.options.length; i++) {
            if (DPInputListViewHeader.projectSel.options[i].value == str) {
                DPInputListViewHeader.projectSel.options.selectedIndex = i;
                break;
            }
        }
        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // ȣ�� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function projectListChanged()
    {
        DPInputListViewHeader.projectInput.value = DPInputListViewHeader.projectSel.value;
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


    /* ȭ��(���)�� ����Ǹ� �ʱ� ���¸� ���� ��¥ & -1�� �� �������� �����ϰ� ��ȸâ�� �ε� */   
    // ���� ��¥
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    // ���� ��¥ - 7��
    var weekAgoDay = new Date(today - (3600000 * 24 * 7));
    var y2 = weekAgoDay.getFullYear().toString();
    var m2 = (weekAgoDay.getMonth() + 1).toString();
    if (m2.length == 1) m2 = 0 + m2;
    var d2 = weekAgoDay.getDate().toString();
    if (d2.length == 1) d2 = 0 + d2;
    // �ʱ� From, To ��¥ ����
    var toYMD = y1 + "-" + m1 + "-" + d1;
    var fromYMD = y2 + "-" + m2 + "-" + d2;    
    DPInputListViewHeader.dateSelectedTo.value = toYMD;
    DPInputListViewHeader.dateSelectedFrom.value = fromYMD;
    
    // ��ȸ â�� �ε�
    viewInputList();

</script>

</html>