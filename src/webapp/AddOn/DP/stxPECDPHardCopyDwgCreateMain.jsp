<%--   
��DESCRIPTION: ���� �⵵����(Hard Copy) �׸� ��� ȭ�� ���� �κ�
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPHardCopyDwgCreateMain.jsp
��CHANGING HISTORY: 
��    2010-03-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// 2013-10-15 Kangseonjung : �μ�(��) �� ������ȣ �����ڵ� ���� �ϵ��ڵ�(��) �κ��� ��Ʈ�� ����ȭ (�λ�μ�) �ϰ� TABLE�� ����
	private static String searchDEPLOY_NO_PREFIX(String insaDeptCode) throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		String returnStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT DEPLOY_NO_PREFIX                          \n");
			queryStr.append("  FROM PLM_HARDCOPY_DWG_DEPLOY_NO                \n");
			queryStr.append(" WHERE INSA_DEPT_CDOE='"+insaDeptCode+"'         \n");

			stmt = conn.createStatement();
			rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
			{
				returnStr = rset.getString(1) == null ? "" : rset.getString(1);
			}
		} catch( Exception e)
		{
			//DBConnect.rollbackJDBCTransaction(conn);
			throw e;			
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return returnStr;
	}
%>
<%
    //String loginID = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");

    String errStr = "";             // DB Query �� ���� �߻� ����
    //String dwgDeptCode = "";        // �μ�(��Ʈ) �ڵ� - ����μ� �ڵ�
    String insaDeptCode = "";       // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String insaDeptName = "";       // �μ�(��Ʈ) �̸� - �λ������� �μ���
    String insaUpDeptName = "";     // �����μ�(��) �̸� - �λ������� �μ���
    String userName = "";           // ����� �̸�
    String deployNoPrefix = "";     // ���� NO.�� Prefix �κ�
    String currentDate = "";        // ���ó�¥

    ArrayList projectList = null;     // ȣ�����
    ArrayList departmentList = null;  // (����)�μ����

    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        // (FOR DALIAN) ����߰� �����ο����Ե� ��� �ο� (* �ӽñ��)
        if (loginUserInfo == null) loginUserInfo = getEmployeeInfo_Dalian(loginID);

        //dwgDeptCode = (String)loginUserInfo.get("DWG_DEPTCODE");
        insaDeptCode = (String)loginUserInfo.get("DEPT_CODE");
        insaDeptName = (String)loginUserInfo.get("DEPT_NAME");
        insaUpDeptName = (String)loginUserInfo.get("UP_DEPT_NAME");
        userName = (String)loginUserInfo.get("NAME");

		String searchdeployNoPrefix = searchDEPLOY_NO_PREFIX(insaDeptCode);

        /* Hard Coding �κ�: */ 
        /* �μ�(��) �� �����ڵ� ������� ����(�����������ý���) �� �̾ Hard Code ������ */
		/* 2013-10-15 Kangseonjung : �μ�(��) �� ������ȣ �����ڵ� ���� �ϵ��ڵ�(��) �κ��� ��Ʈ�� ����ȭ (�λ�μ�) �ϰ� TABLE�� ����
        if (insaUpDeptName.equals("�⺻�����")) deployNoPrefix = "B";
        else if (insaUpDeptName.equals("������������")) deployNoPrefix = "V"; //�������������� ->������������
        else if (insaUpDeptName.equals("���������")) deployNoPrefix = "V";
        else if (insaUpDeptName.equals("���������")) deployNoPrefix = "N"; //��ǰ������ ->���������
        else if (insaUpDeptName.equals("���ɱ����")) deployNoPrefix = "N";
        else if (insaUpDeptName.equals("��ı����")) deployNoPrefix = "M";
        else if (insaUpDeptName.equals("������������")) deployNoPrefix = "T";
        else if (insaUpDeptName.equals("�����ȹ��")) deployNoPrefix = "A";
        else if (insaUpDeptName.equals("��ü��ȹ��")) deployNoPrefix = "H";
        //else if (insaUpDeptName.equals("��ü������")) deployNoPrefix = "P"; // �μ��� ���� -> ��ü����1��, ��ü����2��
        else if (insaUpDeptName.equals("��ü����1��")) deployNoPrefix = "P";
        else if (insaUpDeptName.equals("��ü����2��")) deployNoPrefix = "P";
        else if (insaUpDeptName.equals("���弳��1��")) deployNoPrefix = "J";
        else if (insaUpDeptName.equals("���弳��2��")) deployNoPrefix = "Y";
        //else if (insaUpDeptName.equals("���弳��3��")) deployNoPrefix = "Z"; // �μ��� ���� -> ���Ǽ�����
        else if (insaUpDeptName.equals("���Ǽ�����")) deployNoPrefix = "Z"; 
        else if (insaUpDeptName.equals("���弳��1��")) deployNoPrefix = "O";
        else if (insaUpDeptName.equals("���弳��2��")) deployNoPrefix = "O";
        else if (insaUpDeptName.equals("���弳��1��")) deployNoPrefix = "E";
        else if (insaUpDeptName.equals("���弳��2��")) deployNoPrefix = "F";
        else if (insaUpDeptName.equals("���������")) deployNoPrefix = "K";
        else if (insaUpDeptName.equals("���������")) deployNoPrefix = "D";
        else if (insaUpDeptName.equals("��������")) deployNoPrefix = "C";
        else if (insaUpDeptName.equals("��ǰ���߿�����")) deployNoPrefix = "L";
		*/
		if(!"".equals(searchdeployNoPrefix)) deployNoPrefix = searchdeployNoPrefix;
        else if (insaDeptName.equals("�ؾ缳�������")) deployNoPrefix = "DM";
        else if (insaDeptName.equals("�ؾ����弳����-�������P")) deployNoPrefix = "PD"; //�ؾ����ý��ۼ����� -> �ؾ����弳����-�������P
        else if (insaDeptName.equals("�ؾ����弳����-��輳��P")) deployNoPrefix = "ME"; //�ؾ��輳���� -> �ؾ����弳����-��輳��P
        else if (insaDeptName.equals("�ؾ����弳����-���弳��P")) deployNoPrefix = "HO"; //�ؾ缱�弳���� -> �ؾ����弳����-���弳��P
        else if (insaDeptName.equals("�ؾ����弳����-���弳��P")) deployNoPrefix = "EL"; //�ؾ����弳���� -> �ؾ����弳����-���弳��P
        else if (insaDeptName.equals("�ؾ缱ü������")) deployNoPrefix = "PH";
        else if (insaDeptName.equals("�ؾ���������")) deployNoPrefix = "PP";
        else if (insaDeptName.equals("�ؾ�ö���弳����")) deployNoPrefix = "PO";
        else if (insaDeptName.equals("�ؾ����弱�Ǽ�����")) deployNoPrefix = "PE";
        else if (insaDeptName.equals("�ؾ����弳����-���Ǽ���P")) deployNoPrefix = "AC"; //�ؾ缱�Ǽ����� -> �ؾ����弳����-���Ǽ���P
        //else if (insaDeptName.equals("�ؾ�⺻������")) deployNoPrefix = "BA"; // �μ��� ���� -> �ؾ�⺻������
        //else if (insaDeptName.equals("�ؾ籸��������")) deployNoPrefix = "HU"; // �μ��� ���� -> �ؾ籸��������
        //else if (insaDeptName.equals("�ؾ籸��������-�⺻����P")) deployNoPrefix = "BA"; //�ؾ�⺻������ -> �ؾ籸��������-�⺻����P
        //else if (insaDeptName.equals("�ؾ籸��������-��������P")) deployNoPrefix = "HU"; //�ؾ籸�������� -> �ؾ籸��������-��������P
        // (FOR DALIAN) ����߰� �����ο����Ե� ��� �ο� (* �ӽñ��)
        else {
            String dwgDeptCode = (String)loginUserInfo.get("DWG_DEPTCODE");
            if (dwgDeptCode.equals("000073")) deployNoPrefix = "DP";
            else if (dwgDeptCode.equals("000074")) deployNoPrefix = "DA";
            else if (dwgDeptCode.equals("000075")) deployNoPrefix = "DH";
            else if (dwgDeptCode.equals("000076")) deployNoPrefix = "DE";
            else if (dwgDeptCode.equals("000077")) deployNoPrefix = "DO";
            else if (dwgDeptCode.equals("000106")) deployNoPrefix = "DI";
            else if (dwgDeptCode.equals("000060")) deployNoPrefix = "PP";
            else if (dwgDeptCode.equals("000061")) deployNoPrefix = "ME";
            else if (dwgDeptCode.equals("000062")) deployNoPrefix = "HO";
            else if (dwgDeptCode.equals("000138")) deployNoPrefix = "AC";
            else if (dwgDeptCode.equals("000063")) deployNoPrefix = "EL";
            else if (dwgDeptCode.equals("000058")) deployNoPrefix = "BA";
            else if (dwgDeptCode.equals("000059")) deployNoPrefix = "HU";
            else throw new Exception("Unknown Department(Team) Code! (Team Name: " + insaUpDeptName + ")");
        }

        Calendar c = Calendar.getInstance();
        String sYear = String.valueOf(c.get(Calendar.YEAR));
        deployNoPrefix += sYear.substring(2);

        currentDate = sYear + "-";
        String sTemp = String.valueOf(c.get(Calendar.MONTH) + 1);
        if (sTemp.length() < 2) sTemp = "0" + sTemp;
        currentDate += sTemp + "-";
        sTemp = String.valueOf(c.get(Calendar.DAY_OF_MONTH));
        if (sTemp.length() < 2) sTemp = "0" + sTemp;        
        currentDate += sTemp;

        // ȣ�����
        // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
            projectList = getProgressSearchableProjectList_Dalian(loginID, true, "PROGRESS");
        else projectList = getAllProjectList("");

        // (����)�μ����
        // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
            departmentList = getAllDepartmentOfSTXShipList_Dalian();
        else departmentList = getAllDepartmentOfSTXShipList();
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }    
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>Drawing Distribution History Resister</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPHardCopyDwgCreateMain">

    <input type="hidden" name="deployNoPrefix" value="<%=deployNoPrefix%>" />
    <input type="hidden" name="insaDeptCode" value="<%=insaDeptCode%>" />
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="requestDate" value="<%=currentDate%>" />
    <input type="hidden" name="deployDate" value="" />



<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                Error occurred!<br>
                ��Error Message: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>
    <!--<p style="font-size:12pt;font-weight:bold;color:darkblue;">���� �⵵����(Hard Copy) ���</p>-->

	<table width="100%" border="0" cellspacing="2" cellpadding="2">
		<tr>
			<td class="td_labelRequired" width="30%">Division</td>
			<td class="inputField">
                <input type="radio" name="inputGubun" value="�⵵��" checked 
                 onclick="gubun_printFromCopyRoomChecked();" />Copy Center
                <input type="radio" name="inputGubun" value="��ü" 
                 onclick="gubun_printFromDeptChecked();" />Itself
            </td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No.</td>
			<td class="inputField"><%=deployNoPrefix%>-<i>xxxxx</i></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Dept.</td>
			<td class="inputField"><%=insaDeptCode%>: <%=insaDeptName%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No. Requestor</td>
			<td class="inputField"><%=userName%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No. Request Date</td>
			<td class="inputField"><%=currentDate%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution Date</td>
			<td class="inputField" id="deployDateTD"></td>
		</tr>
    </table>
    
    <hr><br>

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#000000">
        <tr height="24" bgcolor="#dadada">
            <td class="td_smallLRMarginBlue" width="62">PROJECT</td>
            <td class="td_smallLRMarginBlue" width="24">REV.</td>
            <td class="td_smallLRMarginBlue" width="80">DwgNo.</td>
            <td class="td_smallLRMarginBlue" width="176">DESCRIPTION</td>
            <td class="td_smallLRMarginBlue" width="74">ECO No.</td>
            <td class="td_smallLRMarginBlue" width="50">Category of Change</td>
            <td class="td_smallLRMarginBlue" width="52">Change Request Dept.</td>
            <td class="td_smallLRMarginBlue" width="70">Distribution Time</td>
            <td class="td_smallLRMarginBlue">Note</td>
        </tr>

        <%
        for (int i = 0; i < 8; i++) 
        {
        %>
        <tr bgcolor="#ffffff">
            <!-- PROJECT -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="projectInput<%=i%>" value="" class="input_noBorder3" style="width:50px;height:20px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
                <input type="button" name="showprojectListBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showProjectSel('projectInput<%=i%>');">
            </td>
            <!-- REV. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="revInput<%=i%>" value="" maxlength="3" class="input_noBorder3" style="width:34px;height:20px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <!-- DRAWING NO. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="drawingNo<%=i%>" value="" class="input_noBorder3" style="width:68px;height:20px;" maxlength="8"
                       onKeyUp="drawingNoValueChanged(this, 'projectInput<%=i%>', 'dwgDesc<%=i%>', 'revTiming<%=i%>', 'dwgCategory<%=i%>');" 
                       onkeydown="inputCtrlKeydownHandler();" onChange="drawingNoValueChanged(this);">
                <input type="button" name="showprojectListBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showDrawingNoSel('drawingNo<%=i%>', 'projectInput<%=i%>', 'dwgDesc<%=i%>', 'revTiming<%=i%>', 'dwgCategory<%=i%>');">
            </td>
            <!-- DESCRIPTION -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="dwgDesc<%=i%>" value="" class="input_noBorder3" readonly 
                       style="width:180px;height:20px;background-color:#ffffff;">
            </td>
            <!-- ECO NO. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="ecoNo<%=i%>" value="" class="input_noBorder3" style="width:80px;height:20px;"
                       onKeyUp="checkECONo(this, '<%=i%>');" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <!-- �⵵���� -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="reasonCode<%=i%>" value="" readonly class="input_noBorder3" style="width:40px;height:20px;">
                <input type="button" name="showReasonCodeBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showReasonCodeWin('reasonCode<%=i%>', 'ecoNo<%=i%>');">
            </td>
            <!-- ���κμ� -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="causeDept<%=i%>" value="" class="input_noBorder3" style="width:60px;height:20px;" 
                       readonly onclick="showCauseDeptSel('causeDept<%=i%>');">
            </td>
            <!-- �⵵�ñ� -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="revTiming<%=i%>" value="" class="input_noBorder3" readonly 
                       style="width:90px;height:20px;">
                <input type="hidden" name="dwgCategory<%=i%>" value="" />
                <input type="button" name="showRevTimingBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showRevTimingWin('revTiming<%=i%>', 'dwgCategory<%=i%>');">
            </td>
            <!-- ��� -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <textarea name="deployDesc<%=i%>" value="" rows="2" class="input_noBorder3" 
                          style="width:164px;text-align:left;" onkeydown="inputCtrlKeydownHandler();"></textarea>
            </td>
        </tr>
        <%
        }
        %>
    </table>

    
    <!-- ȣ�� SELECT BOX (DIV) -->
    <div id="projectListDiv" STYLE="position:absolute; display:none;">
        <select name="projectList" style="width:74px; background-color:#eeeeee;" onchange="projectListChanged();">
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

    <!-- �����ȣ SELECT BOX (DIV) -->
    <div id="drawingNoListDiv" STYLE="position:absolute; display:none;">
        <select name="drawingNoList" style="width:310px; background-color:#eeeeee; font-size:9pt;" onchange="drawingNoListChanged();">
            <option value="">&nbsp;</option>
        </select>
    </div>

    <!-- ���κμ� SELECT BOX (DIV) -->
    <div id="causeDeptListDiv" STYLE="position:absolute; display:none;">
        <select name="causeDeptList" style="width:220px; background-color:#eeeeee;" onchange="causeDeptListChanged();">
            <option value="">&nbsp;</option>
            <%
            for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
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
    </div>
<%
}
%>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>

<script language="javascript">

	/** Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ���� */
	document.onkeydown = keydownHandler;


    /** ����(�⵵��|��ü) �� ���� �� �������� �� ���� ------------------------*/
    function gubun_printFromCopyRoomChecked()
    {
        DPHardCopyDwgCreateMain.deployDate.value = ""; 
        document.getElementById("deployDateTD").innerHTML = "";
    }
    function gubun_printFromDeptChecked()
    {
        DPHardCopyDwgCreateMain.deployDate.value = "<%=currentDate%>"; 
        document.getElementById("deployDateTD").innerHTML = "<%=currentDate%>";
    }


    /** ȭ�� Ŭ�� �� ���õ��� ���� SELECT BOX(DIV) ����� --------------------*/
    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // ���콺 Ŭ�� �� SELECT BOX ��Ʈ���� �����(�ش� ��Ʈ�ѿ� ���� ���콺 Ŭ���� �ƴ� ���)
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        // ȣ�� SELECT BOX �����
        mouseClickHandlerSubProc(e, projectListDiv);

        // �����ȣ SELECT BOX �����     
        mouseClickHandlerSubProc(e, drawingNoListDiv);

        // ���κμ� SELECT BOX �����     
        mouseClickHandlerSubProc(e, causeDeptListDiv);
    }
    // Sub-Procedure
    function mouseClickHandlerSubProc(e, divObj)
    {
        var posX = event.clientX;
        var posY = event.clientY;

        // ȣ�� SELECT BOX        
        if (divObj.style.display != "none") {
            var objPos = getAbsolutePosition(divObj);
            if (posX < objPos.x || posX > objPos.x + divObj.offsetWidth ||
                posY < objPos.y  || posY > objPos.y + divObj.offsetHeight)
            {
                divObj.style.display = "none";
            }
        }
    }


    /** ȣ������ SELECT BOX(DIV) ���̰� ����� -------------------------------*/
    var activeProjectInputObj = null;

    // ȣ�� ���� SELECT BOX SHOW
    function showProjectSel(projectInputId)
    {
        activeProjectInputObj = document.getElementById(projectInputId);        
        
        var str = activeProjectInputObj.value.trim();
        DPHardCopyDwgCreateMain.projectList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgCreateMain.projectList.options.length; i++) {
            if (DPHardCopyDwgCreateMain.projectList.options[i].value == str) {
                DPHardCopyDwgCreateMain.projectList.options.selectedIndex = i;
                break;
            }
        }

        var objPos = getAbsolutePosition(activeProjectInputObj);
        projectListDiv.style.left = objPos.x;
        projectListDiv.style.top = objPos.y - 1;

        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // ȣ�� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function projectListChanged()
    {
        activeProjectInputObj.value = DPHardCopyDwgCreateMain.projectList.value;
        projectListDiv.style.display = "none";
    }


    /** �����ȣ SELECT BOX(DIV) ���̰� ����� -------------------------------*/
    var activeDrawingNoInputObj = null;
    var activeDrawingDescInputObj = null;
    var activeRevTimingInputObj = null;
    var activeDwgCategoryInputObj = null;

    // �����ȣ ���� SELECT BOX SHOW
    function showDrawingNoSel(drawingNoInputId, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        activeDrawingNoInputObj = document.getElementById(drawingNoInputId);  
        activeDrawingDescInputObj = document.getElementById(dwgDescInputId);  
        activeRevTimingInputObj = document.getElementById(revTimingInputId);  
        activeDwgCategoryInputObj = document.getElementById(dwgCategoryInputId);  
        
        // Select Box �ʱ�ȭ 
        for (var i = DPHardCopyDwgCreateMain.drawingNoList.options.length - 1 ; i > 0; i--) 
        {   DPHardCopyDwgCreateMain.drawingNoList.options[i] = null;   }
        DPHardCopyDwgCreateMain.drawingNoList.selectedIndex = 0; 

        // �����ȣ ��� ������ ����
        drawingNoQueryProc(projectInputId, activeDrawingNoInputObj.value, DPHardCopyDwgCreateMain.drawingNoList);

        var objPos = getAbsolutePosition(activeDrawingNoInputObj);
        drawingNoListDiv.style.left = objPos.x;
        drawingNoListDiv.style.top = objPos.y - 1;

        drawingNoListDiv.style.display = "";
        isNewShow = true;
    }

    // �����ȣ �����Է� �� ó��
    function drawingNoValueChanged(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        // �빮�ڷ� ��ȯ
        drawingNoInputObj.value = drawingNoInputObj.value.toUpperCase(); 

        // ���� Desc., �⵵�ñ� ���� �ʱ�ȭ
        (document.getElementById(dwgDescInputId)).value = "";
        (document.getElementById(revTimingInputId)).value = "";
        (document.getElementById(dwgCategoryInputId)).value = "";

        // �����ڵ� 8 �ڸ��� �� �ԷµǾ����� �ش� ������ ������ �����ؼ� ���� Desc., �⵵�ñ� ���� ����
        if (drawingNoInputObj.value.trim().length == 8) {
            drawingNoQueryProc2(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId);
        }
    }

    // �����ȣ ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function drawingNoListChanged()
    {
        var strs = DPHardCopyDwgCreateMain.drawingNoList.value.split("��");
        activeDrawingNoInputObj.value = strs[0];
        activeDrawingDescInputObj.value = strs[1];
        //activeRevTimingInputObj.value = strs[2];
        activeDwgCategoryInputObj.value = strs[3];
        drawingNoListDiv.style.display = "none";
    }

    // ȣ�� + �μ��� ���� '�����ڵ�' ������ DB���� �����ؿ��� Select Box LOV�� ä��
    function drawingNoQueryProc(projectInputId, selectedValue, selectObj)
    {
        var selectedProject = (document.getElementById(projectInputId)).value.trim();
        if (selectedProject == "") return;

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork2" + 
                            "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value + 
                            "&projectNo=" + selectedProject, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("��");

                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split("��");
                            var newOption = new Option(strs2[0] + " : " + strs2[1], strs[i]);
                            selectObj.options[i + 1] = newOption;
                            if (selectedValue != "" && strs[i].indexOf(selectedValue + "��") >= 0) selectObj.selectedIndex = i + 1; 
                        }
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }

    // ȣ�� + �����ڵ忡 ���� ���������� DB���� ����
    function drawingNoQueryProc2(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        var selectedProject = (document.getElementById(projectInputId)).value.trim();
        if (selectedProject == "") {
            alert("Please select a PROJECT first!");
            //drawingNoInputObj.value = drawingNoInputObj.value.trim().substring(0, 6);
            return;
        }

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork3" + 
                            "&projectNo=" + selectedProject + 
                            "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value + 
                            "&dwgNo=" + drawingNoInputObj.value.trim(), false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
               
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("��");
                        if (strs.length == 4) {
                            (document.getElementById(dwgDescInputId)).value = strs[1];
                            //(document.getElementById(revTimingInputId)).value = strs[2];
                            (document.getElementById(dwgCategoryInputId)).value = strs[3];
                        }
                        else alert("Dwg No. '" + drawingNoInputObj.value.trim() + "' does not exist!");
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }


    /** �⵵���� �ڵ� ���� â�� SHOW -----------------------------------------*/
    function showReasonCodeWin(reasonCodeInputId, ecoNoInputId)
    {
        if (document.getElementById(ecoNoInputId).value.trim() != '') {
            alert("You cannot change 'Category of Change' when 'ECO NO.' was inputted!");
            return;
        }

        var sProperties = 'dialogHeight:600px;dialogWidth:600px;scroll=auto;center:yes;resizable=no;status=no;';
        var selectedCode = parent.window.showModalDialog("stxPECDPHardCopyDwgCreate_CodeSelect.jsp", "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            document.getElementById(reasonCodeInputId).value = selectedCode;
        }
    }


    /** (����)�μ� ���� SELECT BOX(DIV) ���̰� ����� ------------------------*/
    var activeCauseDeptInputObj = null;

    // ���κμ� ���� SELECT BOX SHOW
    function showCauseDeptSel(causeDeptInputId)
    {
        activeCauseDeptInputObj = document.getElementById(causeDeptInputId);        
        
        var str = activeCauseDeptInputObj.value.trim();
        DPHardCopyDwgCreateMain.causeDeptList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgCreateMain.causeDeptList.options.length; i++) {
            if (DPHardCopyDwgCreateMain.causeDeptList.options[i].value == str) {
                DPHardCopyDwgCreateMain.causeDeptList.options.selectedIndex = i;
                break;
            }
        }

        var objPos = getAbsolutePosition(activeCauseDeptInputObj);
        causeDeptListDiv.style.left = objPos.x;
        causeDeptListDiv.style.top = objPos.y - 1;

        causeDeptListDiv.style.display = "";
        isNewShow = true;
    }

    // ���κμ� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function causeDeptListChanged()
    {
        activeCauseDeptInputObj.value = DPHardCopyDwgCreateMain.causeDeptList.value;
        causeDeptListDiv.style.display = "none";
    }


    /** �⵵�ñ� ���� â�� SHOW -----------------------------------------*/
    function showRevTimingWin(revTimingInputId, dwgCategoryInputId)
    {
        var dwgCategory = document.getElementById(dwgCategoryInputId).value;
        if (dwgCategory == "") {
            alert("Please select 'Dwg No' first!");
            return;
        }

        var sProperties = 'dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var sUrl = "stxPECDPHardCopyDwgCreate_RevTimingSelect.jsp?dwgCategory=" + dwgCategory;
            sUrl = sUrl + "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value;
        var selectedCode = parent.window.showModalDialog(sUrl, "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            document.getElementById(revTimingInputId).value = selectedCode;
        }
    }


    /* ECO NO. �Է� �� �⵵���ΰ� ��� �� �ڵ��Է� */

    // ECO No. �Է� �� �����ϴ� ECO���� üũ�ϰ�, �����ϸ� ECO ������ �⵵���ΰ� ��� ���� �ڵ� �Է� 
    function checkECONo(ecoNoInputObj, indexNo)
    {
        // ECO �ڵ� 10 �ڸ��� �� �ԷµǾ����� �ش� ECO�� ������ �����ؼ� �⵵���ΰ� ��� ���� ����
        var ecoNo = ecoNoInputObj.value.trim();
        if (ecoNo.length == 10) {
            if (isStringNumber(ecoNo) == 0) {
                alert("Invalid 'ECO NO.'!");
                //ecoNoInputObj.value = "";
                return false;            
            }

            checkECONoSubProc(ecoNo, ecoNoInputObj, indexNo);
        }
    }

    // ECO ������ �о�ͼ� �⵵���ΰ� ��� ���� �ڵ� �Է� 
    function checkECONoSubProc(ecoNo, ecoNoInputObj, indexNo)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetECOInfo" + 
                            "&ecoNo=" + ecoNo, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
               
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') {
                        alert(resultMsg);
                        //ecoNoInputObj.value = "";
                    }
                    else {
                        if (resultMsg != "") {
                            var str1 = resultMsg.substring(0, resultMsg.indexOf("|"));
                            var str2 = resultMsg.substring(resultMsg.indexOf("|") + 1);
                            (document.getElementById("reasonCode" + indexNo)).value = str1;
                            (document.getElementById("deployDesc" + indexNo)).value = str2;
                        }
                        else {
                            alert("The 'ECO No.' inputted is not exist! Please check the 'ECO No.'");
                            //ecoNoInputObj.value = "";
                        }
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }


    /** ���� �⵵����(Hard Copy) ��� ----------------------------------------*/

    // ����
    function createHardCopyData()
    {
        if (!checkInputs()) return;

        // �Է°� ����
        var params = "";
        params += "loginID=" + DPHardCopyDwgCreateMain.loginID.value;
        params += "&deployNoPrefix=" + DPHardCopyDwgCreateMain.deployNoPrefix.value;
        params += "&deptCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value;
        params += "&requestDate=" + DPHardCopyDwgCreateMain.requestDate.value;
        params += "&deployDate=" + DPHardCopyDwgCreateMain.deployDate.value;
        if (DPHardCopyDwgCreateMain.inputGubun[0].checked) 
            params += "&gubun=" + DPHardCopyDwgCreateMain.inputGubun[0].value;
        else if (DPHardCopyDwgCreateMain.inputGubun[1].checked) 
            params += "&gubun=" + DPHardCopyDwgCreateMain.inputGubun[1].value;
   
        for (var i = 0; i < 8; i++)
        {
            var projectInput = (document.getElementById("projectInput" + i)).value.trim();
            if (projectInput == "") continue;

            params += "&project" + i + "=" + projectInput;
            params += "&rev" + i + "=" + (document.getElementById("revInput" + i)).value.trim();
            params += "&dwg" + i + "=" + (document.getElementById("drawingNo" + i)).value.trim();
            params += "&dwgDesc" + i + "=" + (document.getElementById("dwgDesc" + i)).value.trim().replaceAmpAll();
            params += "&ecoNo" + i + "=" + (document.getElementById("ecoNo" + i)).value.trim();
            params += "&reasonCode" + i + "=" + (document.getElementById("reasonCode" + i)).value.trim();
            params += "&causeDept" + i + "=" + (document.getElementById("causeDept" + i)).value.trim();
            params += "&revTiming" + i + "=" + (document.getElementById("revTiming" + i)).value.trim();
            params += "&deployDesc" + i + "=" + (document.getElementById("deployDesc" + i)).value.trim().replaceAmpAll();
        }
        params += "&maxCnt=8";

        //alert(params);

        // DB ����
        var resultMsg = callDPCommonAjaxPostProc2("SaveHardCopyInputs", params);
        if (resultMsg.indexOf("Y|") == 0) {
            alert("Saved! (Distribution No.: " + resultMsg.substring(2) + ")");
            window.close();
        }
        else alert("Error occurred on saving to DB!");
    }

    // �Է°����� ��ȿ���� üũ, �ʼ��׸� �Է� üũ
    function checkInputs()
    {
        var inputExist = false;

        for (var i = 0; i < 8; i++)
        {
            // ȣ���Է� ��ȿ��(�����ϴ� ȣ������) üũ
            var projectInput = (document.getElementById("projectInput" + i)).value.trim();
            if (projectInput != "") {
                DPHardCopyDwgCreateMain.projectList.options.selectedIndex = 0;
                for (var j = 0; j < DPHardCopyDwgCreateMain.projectList.options.length; j++) {
                    if (DPHardCopyDwgCreateMain.projectList.options[j].value == projectInput) {
                        DPHardCopyDwgCreateMain.projectList.options.selectedIndex = j;
                        break;
                    }
                }

                if (DPHardCopyDwgCreateMain.projectList.value == "") {
                    alert("Invalid or Unexisted Project No.!");
                    return false;
                }
            }

            // REV. �� ������ ��ȿ���� üũ
            var revInput = (document.getElementById("revInput" + i)).value.trim();
            if (revInput != "") {
                if (isStringNumber(revInput) == 0 && isStringAlphabet(revInput) == 0) {
                    if (isStringAlphabetPlusNumber(revInput) == 0) {
                        alert("Invalid REV.!");
                        return false;
                    }
                }
            }

            // �⵵���� �� ������ ��ȿ���� üũ
            var reasonCode = (document.getElementById("reasonCode" + i)).value.trim();
            /*
            if (reasonCode != "") {
                if (reasonCode.length != 2 || isStringAlphabet(reasonCode.charAt(0)) == 0 || isStringNumber(reasonCode.charAt(1)) == 0) {
                    alert("�ùٸ� �⵵���� ���� �Է��Ͻʽÿ�!");
                    return false;
                }
            } 
            */

            // �ʼ��׸� �Է� ���� üũ
            if (projectInput != "") 
            {
                if (revInput == "") {
                    alert("Please input the 'REV.'!");
                    return false;                
                } 
                if ((document.getElementById("drawingNo" + i)).value.trim() == "") {
                    alert("Please input the 'DwgNo.'!");
                    return false;                
                }                 
                if (reasonCode == "") {
                    alert("Please input the 'Category of Change'!");
                    return false;                
                }  
                if ((document.getElementById("revTiming" + i)).value.trim() == "") {
                    alert("Please input the 'Distribution Time'!");
                    return false;                
                }     

                inputExist = true;
            }
        }

        if (!inputExist) {
            alert("There is no item to save!");
            return false;                
        }

        return true;
    }

    // utility function
    function isStringNumber(str) 
    {
        var ref="0123456789";
        var sLength=str.length;
        var chr, idx, idx2;

        for(var i=0; i<sLength; i++) {
            chr=str.charAt(i);
            idx=ref.indexOf(chr);
            if(idx==-1) {
                return 0;
            }
        }
        
        return 1;
    }

    // utility function
    function isStringAlphabet(str) 
    {
        var ref="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var sLength=str.length;
        var chr, idx, idx2;

        for(var i=0; i<sLength; i++) {
            chr=str.charAt(i);
            idx=ref.indexOf(chr);
            if(idx==-1) {
                return 0;
            }
        }
        
        return 1;
    }

    // utility function
    function isStringAlphabetPlusNumber(str) 
    {
        var refAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var refNumber = "0123456789";
        
        var chr, idx, idx2;

        chr = str.charAt(0);
        idx = refAlphabet.indexOf(chr);
        if (idx == -1) return 0;
        
        for (var i = 1; i < str.length; i++) 
        {
            chr = str.charAt(i);
            idx = refNumber.indexOf(chr);
            if (idx == -1) return 0;
        }
        
        return 1;
    }

</script>


</html>
