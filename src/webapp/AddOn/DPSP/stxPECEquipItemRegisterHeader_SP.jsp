<%--  
��DESCRIPTION: ������ ���� ���� �� DP���� ���հ��� ��� header
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECEquipItemRegisterHeader_SP.jsp
��CHANGING HISTORY: 
��    2010-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
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
            System.out.println(queryStr.toString());

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
%>

<%
    //������� : ������ȹP=416100, �������1��(�⺻����P=428100, ���念��P=428200, ���念��P=428150, ���念��P=428250), �������2��(�⺻����P=380100, �����念��P=380300, ���念��P=380200)


    //String loginID = context.getUser(); // ������ ID : ������ or ������(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");         
    String designerID = "";             // ������ ID 
    String isAdmin = "N";               // ������ ����
    //String mhInputYN = "";              // �ü��Է� ���� ����(�� ������ �����Է� ������ ������)
    //String progressInputYN = "";        // �����Է� ���� ����
    //String terminationDate = "";        // �����(��翩��)
    String insaDepartmentCode = "";     // �μ�(��Ʈ) �ڵ� - �λ������� �ڵ�
    String insaDepartmentName = "";     // �μ�(��Ʈ) �̸� - �λ������� �̸�
    String dwgDepartmentCode = "";      // �μ�(��Ʈ) �ڵ� - ����μ� �ڵ�

    String errStr = "";                 // DB Query �� ���� �߻� ����
    boolean inputMakerList = false;     // MakerList �Է� ���� �μ� ���� = ��������� ����
    String inputMakerListYN = "N";
    //String buttonMakerListSaveView = "none";

    ArrayList projectList = null;
    ArrayList departmentList = null;
    ArrayList personsList = null;

    // DB���� ������ �����Ͽ� �׸���� �� ����
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            insaDepartmentName = (String)loginUserInfo.get("DEPT_NAME");
            dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

            projectList = getProgressSearchableProjectList(loginID, true, "PROGRESS");
            departmentList = getDepartmentList_1();       // getDepartmentList
            personsList = getPartPersons(insaDepartmentCode);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }

    // Ư���� �����ȹ�����(211123 �ۿ���, 208427 ������, 208368 ��â��, 203043 ��α�, 212645 ��ȫ��, 203056 ����� , 204016 ������,201002 ���ϼ�, 203026 �����, 213356 �̽���) ��ü�μ� ��ȸ ����
    if("202077".equals(loginID) ||"211123".equals(loginID) ||"208427".equals(loginID) ||"208368".equals(loginID) ||"203043".equals(loginID) ||"212645".equals(loginID) ||"203056".equals(loginID) ||"204016".equals(loginID) ||"201002".equals(loginID) ||"203026".equals(loginID) ||"213356".equals(loginID))
    {
        inputMakerList = true;
        inputMakerListYN = "Y";
        //buttonMakerListSaveView = "";

    }


%>


<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<style type="text/css">
.labelRequired {color:#990000; font-weight : bold;}
.even {background-color:#eeeeee}
.odd {background-color:#ffffff}
.button_simple
{
	font-size: 9pt;
	font-weight: bold;
	height: 26px;
	width: 90px;
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
<form name="frmEquipItemPurchasingManagementHeader" method="post">
    <input type="hidden" name="loginID" value="<%=loginID%>">
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>">
    <input type="hidden" name="inputMakerListYN" value="<%=inputMakerListYN%>">
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>">
    <input type="hidden" name="createPRrunning" value="FALSE">

    <table width="100%" cellSpacing="0" border="1" align="center">
    <tr height="30">
        <td class="td_title" width="50%"> 
            Register&nbsp;&nbsp; : &nbsp;Equip. Item Purchasing & Schedule Management
        </td>
        <td width="50%" align="center">
            <table width="100%">
                <tr>
                    <td width="320">
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
                    <td align="right">
                        <input type="button" class="button_simple" name="searchDate" value='��������'  onclick="searchEquipDate();">
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="button" class="button_simple_1" name="searchMode" value="Mode" onclick="searchModePageLoad();">
                    </td>
                </tr>
            </table>            
        </td>        
    </tr>
    </table>
    <table width="100%" cellSpacing="0" border="1">
    <tr height="30">
        <td width="20%" class="labelRequired">&nbsp;Project&nbsp;
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
 
        <td width="30%">&nbsp;Part&nbsp;
            <select name="departmentList" style="width:250px;">                
                <%
                //������� �ο��� ��� �μ� �� �� ������, �������� �ڱ� �μ��� ���� ����
                if(inputMakerList)
                {
                %>
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String str1 = (String)map.get("DEPT_CODE");
                        String str2 = str1 + ":&nbsp;";
                        str2 += (String)map.get("DEPT_NAME");
                        //String selected = ""; if (insaDepartmentCode.equals(str1)) selected = "selected";
                    %>
                        <option value="<%=str1%>"><%=str2%></option>
                    <%
                    }
                } else {                        
                        String str3 = insaDepartmentCode + ":&nbsp;"+insaDepartmentName;
                    %>
                    <option value="<%=insaDepartmentCode%>"><%=str3%></option>


                <%   
                }
                %>
            </select>
        </td>

        <td width="50%" align="center">
            <input type="button" name="buttonSearch" value='Search' class="button_simple" onclick="dataSearch();">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <%
            if(inputMakerList)
            {
            %>
                <input type="button" name="buttonMakerListSave" value='Maker����' class="button_simple" onclick="makerListSave();">
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <%
            }
            %>
            <input type="button" name="buttonPRCreate" value='PR ����' class="button_simple" onclick="createPR();">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="buttonPRCreate" value='����Ϸ�' class="button_simple" onclick="requestComplete();">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="button" name="buttonPRCreate" value='PR �߰�' class="button_simple" onclick="createPR_Addition();">
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
        //if (frmEquipItemPurchasingManagementHeader.departmentList.value == "") {
        //    alert("�μ��� �����Ͻʽÿ�.");
        //    return false;
        //}
        return true;
    }

    function dataSearch()
    {
        if (!checkInputs()) return;

        // PR ���� �� �ٸ� ��� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }
        
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
        var urlStr = "stxPECEquipItemRegisterMain_SP.jsp?projectNo=" + frmEquipItemPurchasingManagementHeader.projectList.value;
        urlStr += "&deptCode=" + frmEquipItemPurchasingManagementHeader.departmentList.value;
        urlStr += "&inputMakerListYN=" + frmEquipItemPurchasingManagementHeader.inputMakerListYN.value;
        urlStr += "&loginID=" + frmEquipItemPurchasingManagementHeader.loginID.value;

        firstLoading = false; 
        
        parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;

        return;
    }

   
    function createPR()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }

        // PR �ߺ� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }
        
        var restrictedChars = "\"&";
        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementMain;
        var someSelected = false;
        for(var i = 1; i < mainForm.elements.length; i++)
        {
            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkboxIndex = mainForm.elements[i].value;

                // �̹� PR�� ���� ��� ���� ����
                prNo = mainForm.elements['prNo'+checkboxIndex].value;
                if(!(prNo == "" || prNo==null))
                {
                    alert(prNo+" �� �̹� PR�� ����Ǿ� �ֽ��ϴ�.");
                    return;
                }

                // ÷��SPEC�� ������ PR ���� ����
                fileName = mainForm.elements['fileName'+checkboxIndex].value;
                if(fileName == "" || fileName==null)
                {
                    alert("÷�� Spec�� ������ PR�� ������ �� �����ϴ�.");
                    return;
                }

                for(var index=0; index < fileName.length; index++)
                {
                    if(restrictedChars.indexOf(fileName.charAt(index)) != -1)
                    {
                        alert("÷�� ���ϸ� &(Shift+7) �� \" �� ����� �� �����ϴ�.");
                        return;
                    }
                }
                
                // ITEM CODE, ���� �ʼ�
                itemCode = mainForm.elements['itemCode'+checkboxIndex].value;
                if(itemCode == "" || itemCode==null)
                {
                    alert("���õ� Item Code �� ������ �����ϴ�.");
                    return;
                }

                pr_dept_changeable_yn = mainForm.elements['pr_dept_changeable_yn'+checkboxIndex].value;
                if(pr_dept_changeable_yn=="Y")
                {
                    pr_dept_changeable_owner = mainForm.elements['pr_dept_changeable_owner'+checkboxIndex].value;
                    if(pr_dept_changeable_owner == "" || pr_dept_changeable_owner ==null)
                    {
                        alert("���� PR ���� ���鿡 ���� ����μ� ����ڰ� �������� �ʾҽ��ϴ�.");
                        return;
                    }
                }                
            }
        }

        if(!someSelected)
        {
            var msg = "Please Make A Selection";
            alert(msg);
            return;
        }

        if(confirm("PR 1�� �� 30�� ������ �ð��� �ҿ�ǿ���, ����� ���ö����� ��ٷ��ֽʽÿ�. �����Ͻðڽ��ϱ�?"))
        {
            mainForm.encoding = "multipart/form-data";
            mainForm.action = "stxPECEquipItemRegisterCreatePR_SP.jsp";
            frmEquipItemPurchasingManagementHeader.createPRrunning.value = "TRUE";
            mainForm.submit();    
        }
    }


    function requestComplete()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }

        // PR ���� �� �ٸ� ��� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }

        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementMain;
        var someSelected = false;
        for(var i = 1; i < mainForm.elements.length; i++)
        {
            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkboxIndex = mainForm.elements[i].value;

                // PR�� ���� ��� ���� ����
                prNo = mainForm.elements['prNo'+checkboxIndex].value;
                if(prNo == "" || prNo==null)
                {
                    alert("������� �ϷḦ �� �� �����ϴ�.");
                    return;
                }

                // ÷��SPEC�� ������ PR ���� ����
                completeFile = mainForm.elements['completeFile'+checkboxIndex].value;
                if(completeFile == "" || completeFile==null)
                {
                    alert("�������Ϸ� ������ �����ϴ�.");
                    return;
                }
            }
        }
        if(!someSelected)
        {
            var msg = "Please Make A Selection";
            alert(msg);
            return;
        }

        mainForm.encoding = "multipart/form-data";
        mainForm.action = "stxPECEquipItemRegisterRequestComplete_SP.jsp";
        mainForm.submit();     

    }

    
    function makerListSave()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }

        // PR ���� �� �ٸ� ��� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }

        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementMain;

        // checkbox üũ�� �ϳ��� ������ ����Ұ�
        
        var selDrawingNo="";
        var selMakerList="";
        var someSelected = false;
        var makerListNull = false;

        for(var i = 1; i < mainForm.elements.length; i++)
        {
            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;

                checkboxIndex = mainForm.elements[i].value;
                //checkboxNo = checkboxName.substring(8,checkboxName.length);

                tempDrawingNo = mainForm.elements['drawingNo'+checkboxIndex].value;
                tempMakerList = mainForm.elements['makerList'+checkboxIndex].value;

                if(tempMakerList=="" || tempMakerList==null)
                {
                    makerListNull = true;
                    break;
                }
                
                if(selDrawingNo=="" || selDrawingNo==null)
                {
                    selDrawingNo = tempDrawingNo;
                } else {
                    selDrawingNo += "|"+tempDrawingNo;
                }

                if(selMakerList=="" || selMakerList==null)
                {
                    selMakerList = tempMakerList;
                } else {
                    selMakerList += "|"+tempMakerList;
                }
            }
        }
        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }

        if(makerListNull)
        {
            alert("���õ� �׸��� Maker List ���� �����ϴ�.");
            return;
        }           

        //alert( "selDrawingNo = "+selDrawingNo);
        //alert( "selMakerList = "+selMakerList);

        var params = "projectNo=" + mainForm.projectNo.value;
        params += "&drawingNo=" + selDrawingNo;
        params += "&makerList=" + selMakerList;
        params += "&loginID=" + document.frmEquipItemPurchasingManagementHeader.loginID.value;


        var resultMsg = callMakerListSaveAjaxPostProc(params);
        if (resultMsg == "Y") {
            alert("Save Complete !!");            

            var urlStr = "stxPECEquipItemRegisterMain_SP.jsp?projectNo=" + document.frmEquipItemPurchasingManagementHeader.projectList.value;
            urlStr += "&deptCode=" + document.frmEquipItemPurchasingManagementHeader.departmentList.value;
            urlStr += "&inputMakerListYN=" + document.frmEquipItemPurchasingManagementHeader.inputMakerListYN.value;
            urlStr += "&loginID=" + document.frmEquipItemPurchasingManagementHeader.loginID.value;

            parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;
        }
        else alert(resultMsg);            

    }

    function callMakerListSaveAjaxPostProc(params)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // POST ��� ����
        xmlHttp.open("POST", "stxPECEquipItemRegisterMakerListSave_SP.jsp?" , false);
        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=euc-kr");
        xmlHttp.send(params);

        if (xmlHttp.readyState == 4) {
            if (xmlHttp.status == 200 && xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                    resultMsg = resultMsg.replace(/\s/g, "");

                if (resultMsg != null && resultMsg.trim() == "SUCCESS") return "Y";
            }
            return resultMsg;
        }
    }

    function searchModePageLoad()
    {
        // PR ���� �� �ٸ� ��� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }
        var url = "stxPECEquipItemSearchFS_SP.jsp";
        parent.document.location.href = url;
    }


    function createPR_Addition()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }

        // PR �ߺ� ���� ����
        var isDone = frmEquipItemPurchasingManagementHeader.createPRrunning.value;
        if (isDone == "TRUE")
        {
            alert("The process is currently running. Please wait for the process results before continuing.");
            return;
        }
        
        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementMain;
        var someSelected = false;
        var checkCount = 0;
        var projectNo = "";
        var drawingNo = "";
        for(var i = 1; i < mainForm.elements.length; i++)
        {
            if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
            {
                someSelected = true;
                checkCount++;
                checkboxIndex = mainForm.elements[i].value;

                // PR�� ���� ��쿡�� �߰� PR ���� ����.
                prNo = mainForm.elements['prNo'+checkboxIndex].value;
                if(prNo == "" || prNo==null)
                {
                    alert("�ش� ���鿡 ���� �� PR�� ���� �߰� PR�� ������ �� �����ϴ�.");
                    return;
                }
                /*
                pr_authorization_status = mainForm.elements['pr_authorization_status'+checkboxIndex].value;
                if(pr_authorization_status != "APPROVED")
                {
                    alert("���ε� PR�� ������ ��츸 �߰� PR ������ �� �� �ֽ��ϴ�.");
                    return;
                }
                
                original_pr_flag = mainForm.elements['original_pr_flag'+checkboxIndex].value;
                if(original_pr_flag != "Y")
                {
                    alert("������ �׸��� �ߺ� ���� �Ǿ����ϴ�.\n�߰�/���� �Ǵ� �����縸 ���� ���ּ���!");
                    return;
                }
                */
                if(checkCount != 1)
                {
                    alert("�߰�PR�� �ϳ����� ������ �� �ֽ��ϴ�.");
                    return;
                }

                projectNo = mainForm.elements['projectNo'].value;
                drawingNo = mainForm.elements['drawingNo'+checkboxIndex].value;

            }
        }  

        if(!someSelected)
        {
            var msg = "Please make a selection.";
            alert(msg);
            return;
        }

        // ajax : pr�� ���ο��� Ȯ��.
        if(true)
        {            
            var xmlHttp;
            if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

            // GET ��� ����
            xmlHttp.open("GET", "stxPECEquipItemRegisterPRApprovedCheck_SP.jsp?projectNo="+ projectNo+"&drawingNo="+drawingNo , false);
            xmlHttp.send(null);

            if (xmlHttp.readyState == 4)
            {
                if (xmlHttp.status == 200 && xmlHttp.statusText == "OK")
                {
                    var resultMsg = xmlHttp.responseText;
                    resultMsg = resultMsg.replace(/\s/g, "");   

                    if (resultMsg == "ERROR")
                    {
                        alert("PR Check Error !!!")
                        return;
                    }

                    if (resultMsg != "YES")
                    {
                        alert("PR�� ���ε� ��츸 �߰� PR ������ �� �� �ֽ��ϴ�!!!");
                        return;                       
                    }
                }
            }
        }

        if(true)
        {
            var url = "stxPECEquipItemRegisterPRAddition_SP.jsp?projectNo=" + projectNo;
                url += "&drawingNo="+drawingNo;
                url += "&deptCode=" + document.frmEquipItemPurchasingManagementHeader.departmentList.value;
                url += "&inputMakerListYN=" + document.frmEquipItemPurchasingManagementHeader.inputMakerListYN.value;
                url += "&loginID=" + document.frmEquipItemPurchasingManagementHeader.loginID.value;

            //window.open(url,"","width=900px, height=500px");
            //window.open(url,"","width=1100px, height=500px");
            var nwidth = 1100;
            var nheight = 400;
            var LeftPosition = (screen.availWidth-nwidth)/2;
            var TopPosition = (screen.availHeight-nheight)/2;

            var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

            window.open(url,"",sProperties);
        }

    }


    function searchEquipDate()
    {
        if(firstLoading)
        {
            alert("�ش� ����� ������ �� �����ϴ�. Search ���� �������ּ���. ");
            return;
        }
     
        var mainForm = parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.frmEquipItemPurchasingManagementMain;
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
                url += "&inputMakerListYN=" + document.frmEquipItemPurchasingManagementHeader.inputMakerListYN.value;
                url += "&loginID=" + document.frmEquipItemPurchasingManagementHeader.loginID.value;
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