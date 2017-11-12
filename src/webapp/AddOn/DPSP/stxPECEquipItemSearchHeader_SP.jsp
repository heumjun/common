<%--  
��DESCRIPTION: ������ ���� ���� �� DP���� ���հ��� ��ȸ header
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECEquipItemSearchHeader_SP.jsp
��CHANGING HISTORY: 
��    2010-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
    // Tech Spec ��� ���� �μ��� ������.
	private static synchronized ArrayList getDepartmentList_1() throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,                                                                              ");
			queryStr.append("       A.DEPT_NAME AS DEPT_NAME,                                                                              ");
			queryStr.append("       (SELECT B.DEPT_NAME FROM STX_COM_INSA_DEPT@STXERP B WHERE B.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME ");
			queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A                                                                             ");
			queryStr.append(" WHERE DEPT_CODE IN (                                                                                         ");
			queryStr.append("                        SELECT C.DEPTCODE                                                                     ");
			queryStr.append("                          FROM DCC_DEPTCODE C                                                                 ");
			queryStr.append("                         WHERE C.DWGDEPTCODE IN (SELECT DWG_DEPT_CODE                                         ");
			queryStr.append("                                                   FROM PLM_VENDOR_DWG_PR_INFO )                              ");
			queryStr.append("                    )                                                                                         ");
			queryStr.append("   AND A.USE_YN = 'Y'                                                                                         ");
			queryStr.append(" ORDER BY DEPT_CODE                                                                                           ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("UP_DEPT_NAME", rset.getString(3));
				resultArrayList.add(resultMap);
			}
            // 2011-02-25 Kang seon-jung : Hard coding... PR ���� �μ��� ���弳��3P �߰�. �λ�ȣ��(Bȣ��)�� ��� ���弳�� �ڵ�ȭ �� ����P�� ������ PR������ ���弳��3P���� �Ѵ�. 
            HashMap resultMap1 = new HashMap();
            resultMap1.put("DEPT_CODE", "457400");
            resultMap1.put("DEPT_NAME", "���弳��1-���弳��3P");
            resultMap1.put("UP_DEPT_NAME", "���弳��1��");
            resultArrayList.add(resultMap1);
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}

    private ArrayList getPoDeptOwner() throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT DEPT_NAME, EMP_NO, USER_NAME, POSITION_NAME                                 \n");
            queryStr.append("  FROM STX_COM_INSA_USER@STXERP                                                    \n");
            queryStr.append(" WHERE DEPT_CODE IN ( '278000', '280000') --278000 ������������, 280000 ��ö������ \n");
            queryStr.append("   AND DEL_DATE IS NULL                                                            \n");
            queryStr.append(" ORDER BY DEPT_NAME, EMP_NO                                                        \n");
  
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
                if ( rset.getString(2).startsWith("P") || rset.getString(2).startsWith("M")  ) continue;
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_NAME", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("EMP_NO", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("USER_NAME", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("POSITION_NAME", rset.getString(4) == null ? "" : rset.getString(4));
                resultArrayList.add(resultMap);
            }
		}
		finally {
            if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
    }
%>

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
    ArrayList poDeptOwnerList = null;        // PO Owner list

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

            projectList = getProgressSearchableProjectList(loginID, true, "PROGRESS");
            departmentList = getDepartmentList_1();            
            personsList = getPartPersons(insaDepartmentCode);
            poDeptOwnerList = getPoDeptOwner();

        }
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }

    boolean personListView = false;
    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
    {
        Map tMap = (Map)departmentList.get(i);
        String tStr = (String)tMap.get("DEPT_CODE");
        if (insaDepartmentCode.equals(tStr)) personListView=true;
    }

    //System.out.println("~~~~ personsList = "+personsList.toString());
    //System.out.println("~~~~ departmentList = "+departmentList.toString());




%>


<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<style type="text/css">
.labelRequired {color:#990000; font-weight : bold;}
.even {background-color:#eeeeee}
.odd {background-color:#ffffff}
.td_title_search
{
	background-color: #ba55d3;
	font-size: 11pt;
	font-weight: bold;
	color: #ffffff;
	text-align: center;
}
.button_simple_1
{
	font-size: 9pt;
	height: 26px;
	width: 50px;
}
</style>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUICalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="frmEquipItemPurchasingManagementHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />



    <table width="100%" cellSpacing="0" border="1" align="left">
    <tr height="30">
        <td class="td_title_search" colspan="2"> 
            Search : Equip. Item Purchasing & Schedule Management
        </td>
        <td colspan="2" align="center">
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
            <input type="button" class="button_simple" name="searchDate" value='��������'  onclick="searchEquipDate();">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" class="button_simple_1" name="registerMode" value="Mode" onclick="registerModePageLoad();">
        </td>
    </tr>
    <tr height="30">
        <td width="25%" class="labelRequired">&nbsp;Project&nbsp;
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
                %>
                    <option value="<%=projectNo%>"><%=projectNoStr%></option>
                <%
                }
                %>
            </select>
            </div>
        </td>
        <td>&nbsp;Review Request&nbsp;&nbsp;
            <select name="reviewRequest" style="width:80px">
                <option value="All">All</option>
                <option value="Y">Y</option>
                <option value="N">N</option>
            </select>
        </td>
        <td>&nbsp;PR Creator&nbsp;
            <select name="prCreator" style="width:160px;">
                <option value="">&nbsp;</option>
                <%
                if(personListView)
                {
                    for (int i = 0; personsList != null && i < personsList.size(); i++)
                    {
                        Map map = (Map)personsList.get(i);
                        String empNo = (String)map.get("EMPLOYEE_NO");
                        String empName = (String)map.get("EMPLOYEE_NAME");
                        String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                        //String selected = ""; if (loginID.equals(empNo)) selected = "selected";
                        %>
                        <option value="<%=empNo%>"><%=empStr%></option>
                        <%
                    }
                }
                %>
            </select>
        </td>
        <td>&nbsp;Deviation Check&nbsp;
            <input type="checkbox" name="deviationCheck" value="true">
        </td>

    </tr>
    <tr height="30">
        <td>&nbsp;Part&nbsp;
            <select name="departmentList" style="width:250px;" onchange="departmentSelChanged();">
                <option value="">&nbsp;</option>
                <%
                for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                {
                    Map map = (Map)departmentList.get(i);
                    String str1 = (String)map.get("DEPT_CODE");
                    String str2 = str1 + ":&nbsp;";
                    str2 += (String)map.get("DEPT_NAME");
                    String selected = ""; if (insaDepartmentCode.equals(str1)) selected = "selected";
                    %>
                    <option value="<%=str1%>" <%=selected%>><%=str2%></option>
                    <%
                }
                %>
            </select>
        </td>
        <td>&nbsp;Review Complete&nbsp;
            <select name="reviewComplete" style="width:80px">
                <option value="All">All</option>
                <option value="Y">Y</option>
                <option value="N">N</option>
            </select>
        </td>
        <td>&nbsp;PO Owner&nbsp;&nbsp;
            <select name="poOwner" style="width:160px;">
                <option value="">&nbsp;</option>
                <%
                for (int i = 0; poDeptOwnerList != null && i < poDeptOwnerList.size(); i++) {
                    Map map = (Map)poDeptOwnerList.get(i);
                    String empNo = (String)map.get("EMP_NO");
                    String empName = (String)map.get("USER_NAME");
                    String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                    %>
                    <option value="<%=empNo%>"><%=empStr%></option>
                    <%
                }
                %>
            </select>
        </td>
        <td align="center">
            <input type="button" name="buttonSearch" value='Search' class="button_simple" onclick="dataSearch();"/>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="buttonReport" value='Excel' class="button_simple" onclick="excelDownload();">
        </td>
    </tr>
    </table>
</form>
</body>




<script language="javascript">
    var firstLoading = true;
    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // ȣ�� ���� SELECT BOX SHOW
    function showProjectSel()
    {
        var str = frmEquipItemPurchasingManagementHeader.projectInput.value.trim();
        frmEquipItemPurchasingManagementHeader.projectList.options.selectedIndex = 0;
        for (var i = 0; i < frmEquipItemPurchasingManagementHeader.projectList.options.length; i++) {
            if (frmEquipItemPurchasingManagementHeader.projectList.options[i].value == str) {
                frmEquipItemPurchasingManagementHeader.projectList.options.selectedIndex = i;
                break;
            }
        }
        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // ȣ�� ���� SELECT BOX �� ���� �� Select Box�� Hidden, ���õ� ���� Input Box�� �ݿ�
    function projectListChanged()
    {
        frmEquipItemPurchasingManagementHeader.projectInput.value = frmEquipItemPurchasingManagementHeader.projectList.value;
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

    // �Է� ���� üũ
    function checkInputs()
    {
        var str = frmEquipItemPurchasingManagementHeader.projectInput.value.trim();
        frmEquipItemPurchasingManagementHeader.projectList.options.selectedIndex = 0;
        for (var i = 0; i < frmEquipItemPurchasingManagementHeader.projectList.options.length; i++) {
            if (frmEquipItemPurchasingManagementHeader.projectList.options[i].value == str) {
                frmEquipItemPurchasingManagementHeader.projectList.options.selectedIndex = i;
                break;
            }
        }

        if (frmEquipItemPurchasingManagementHeader.projectList.value == "") {
            alert("Please Input Project Name.");
            return false;
        }
        return true;
    }

    function dataSearch()
    {
        if (!checkInputs()) return;

        var urlStr = "stxPECEquipItemSearchMain_SP.jsp?projectNo=" + frmEquipItemPurchasingManagementHeader.projectList.value;
        urlStr += "&deptCode=" + frmEquipItemPurchasingManagementHeader.departmentList.value;
        urlStr += "&prCreator=" + frmEquipItemPurchasingManagementHeader.prCreator.value;
        urlStr += "&reviewRequest=" + frmEquipItemPurchasingManagementHeader.reviewRequest.value;
        urlStr += "&deviationCheck=" + frmEquipItemPurchasingManagementHeader.deviationCheck.checked;
        urlStr += "&poOwner=" + frmEquipItemPurchasingManagementHeader.poOwner.value;
        urlStr += "&reviewComplete=" + frmEquipItemPurchasingManagementHeader.reviewComplete.value;  
        
        firstLoading = false;
        
        parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;
        

    }

    // ���� �ٿ�ε�
    function excelDownload()
    {
       if (!checkInputs()) return;

       var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_HEADER.frmEquipItemPurchasingManagementHeader
       mainForm.action="stxPECEquipItemSearchExcelDownload_SP.jsp";
       mainForm.target="_self";
       mainForm.submit();

    }

    // �μ� ������ ����Ǹ� �ش� �μ��� ������(��Ʈ��)�� ����� �����Ͽ� ��� SELECT LIST�� ä��
    function departmentSelChanged()
    {
        for (var i = frmEquipItemPurchasingManagementHeader.prCreator.options.length - 1; i > 0; i--) {
            frmEquipItemPurchasingManagementHeader.prCreator.options[i] = null;
        }
        if (frmEquipItemPurchasingManagementHeader.departmentList.value == "") return;

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // GET ��� ����
        xmlHttp.open("GET", "stxPECEquipItemSearchPartPersons_SP.jsp?departCode=" + frmEquipItemPurchasingManagementHeader.departmentList.value , false);

        xmlHttp.send(null);

        if (xmlHttp.readyState == 4)
        {
            if (xmlHttp.status == 200 && xmlHttp.statusText == "OK")
            {
                var resultMsg = xmlHttp.responseText;
                    resultMsg = resultMsg.replace(/\s/g, "");    

                if (resultMsg == null || resultMsg.trim() == "ERROR") return;
                var strs = resultMsg.split("+");
                for (var i = 0; i < strs.length; i++)
                {
                    var strs2 = strs[i].split("|");
                    var newOption = new Option(strs2[0] + "    " + strs2[1], strs2[0]);
                    frmEquipItemPurchasingManagementHeader.prCreator.options[i + 1] = newOption;
                }
            }
        }
    }

    function registerModePageLoad()
    {
        var url = "stxPECEquipItemRegisterFS_SP.jsp";
        parent.document.location.href = url;
    }

    function searchEquipDate()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }        
        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementSearchMain;
        var projectNo = mainForm.elements['projectNo'].value;
        var deptCode = document.frmEquipItemPurchasingManagementHeader.departmentList.value;
        if(deptCode=="" || deptCode==null)
        {
            alert("�μ��� �������ּ��� !! ");
            return;
        }

        if(true)
        {
            var url = "stxPECEquipItemRegisterSearchEquipDate_SP.jsp?projectNo=" + projectNo;
                url += "&deptCode=" + deptCode;
                url += "&inputMakerListYN=";
                url += "&loginID=";
            //window.open(url,"","width=900px, height=500px");
            //window.open(url,"","width=1100px, height=500px");
            var nwidth = 1100;
            var nheight = 500;
            var LeftPosition = (screen.availWidth-nwidth)/2;
            var TopPosition = (screen.availHeight-nheight)/2;

            var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

            window.open(url,"",sProperties);
        }
    }

</script>