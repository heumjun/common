<%--  
��DESCRIPTION: ����ü��Է� ȭ�� ���� �κ�
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECDPInputNewMain.jsp
��CHANGING HISTORY: 
��    2014-12-03: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String deptCode = emxGetParameter(request, "deptCode");
    String deptName = URLDecoder.decode(emxGetParameter(request, "deptName"),"UTF-8");
    String designerID = emxGetParameter(request, "designerID");
    String designerName = URLDecoder.decode(emxGetParameter(request, "designerName"),"UTF-8");
    String dateSelected = emxGetParameter(request, "dateSelected");
    String workingDayYN = URLDecoder.decode(emxGetParameter(request, "workingDayYN"),"UTF-8");
    String workdaysGap = emxGetParameter(request, "workdaysGap");
    String MHConfirmYN = emxGetParameter(request, "MHConfirmYN");
    String loginID = emxGetParameter(request, "loginID");
    String showMsg = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "showMsg")),"UTF-8");
    
    String errStr = "";
    String invalidSelectedProjects = ""; // �ش� ����� ���� ���õ� �۾�ȣ�� �׸�� �߿� ȣ���� ���� ������ ��-��ȿ���� �׸�� ���

    ArrayList selectedProjectList = null;
    ArrayList mhInputList = null;
    ArrayList departmentList = null;
    try {
        mhInputList = getDesignMHInputs(designerID, dateSelected);
        if (!MHConfirmYN.equals("Y")) {
            selectedProjectList = getSelectedProjectList(designerID);
            departmentList = getAllDepartmentOfSTXShipList();

            ArrayList invalidSelectedProjectList = getInvalidSelectedProjectList(designerID);
            for (int i = 0; i < invalidSelectedProjectList.size(); i++) {
                Map map = (Map)invalidSelectedProjectList.get(i);
                invalidSelectedProjects += (i != 0 ? ", " + (String)map.get("PROJECT_NO") : (String)map.get("PROJECT_NO"));
            }
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
    
    boolean isAdmin = false;
    
    try {
	    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	    String contextUser = (String)loginUser.get("user_id");   
        Map loginUserInfo = getEmployeeInfo(contextUser);
        if (loginUserInfo != null) 
        {
            // �ü���ȸ & �Է��� ��� �����ڴ� Login User�� �ʱⰪ���� �Ѵ�
            // �Ϲ� ������� ��� �����ڿ� Login User�� ����. Admin.�� ��� ��� �����ڸ� ���� ������

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    String selectedProjectListStr = "";
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<script type="text/javascript" src="scripts/jquery-1.10.1.js"></script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff; " >
<input type="hidden" id = "scrollHeight" value="0"/>
<div id="mainBody" style="overflow:auto; width:100%;">
<form name="DPInputMain">

    <input type="hidden" name="dataChanged" value="false" /> 
    <input type="hidden" name="deptCode" value="<%=deptCode%>" />
    <input type="hidden" name="deptName" value="<%=deptName%>" />
    <input type="hidden" name="designerID" value="<%=designerID%>" />
    <input type="hidden" name="designerName" value="<%=designerName%>" />
    <input type="hidden" name="dateSelected" value="<%=dateSelected%>" />
    <input type="hidden" name="MHConfirmYN" value="<%=MHConfirmYN%>" />
    <input type="hidden" name="workingDayYN" value="<%=workingDayYN%>" />    
    <input type="hidden" name="workdaysGap" value="<%=workdaysGap%>" />    
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="ajaxCallingSuccessYN" value="" />
	


    <select name="departmentList" style="display:none;">
        <%
        for (int i = 0; departmentList != null && i < departmentList.size(); i++) {
            Map map = (Map)departmentList.get(i);
            String str1 = (String)map.get("DEPT_CODE");
            String str2 = str1 + "&nbsp;" + /*(String)map.get("UP_DEPT_NAME") + "-" +*/ (String)map.get("DEPT_NAME");
            %>
            <option value="<%=str1%>"><%=str2%></option>
            <%
        }
        %>
    </select>

    <table width="100%" cellSpacing="1" cellpadding="4" border="0">
        <tr height="20">
            <td class="td_standard" style="text-align:left;color:#A4AAA7;font-size:8pt;">
                <%=dateSelected%>&nbsp;<%=deptName%>&nbsp;<%=designerName%>&nbsp;(����: <%=MHConfirmYN%>)
            </td>
        </tr>
    </table>
   
    <%
    if (!errStr.equals("")) 
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="4" border="0">
            <tr>
                <td class="td_standard" style="text-align:left;color:#ff0000;">
                    <b>
                    �۾� �߿� ������ �߻��Ͽ����ϴ�. IT ����ڿ��� �����Ͻñ� �ٶ��ϴ�.<br>
                    �ؿ��� �޽���: <%=errStr%>                
                    </b>
                </td>
            </tr>
        </table>
    <%
    }
    else if (!invalidSelectedProjects.equals("")) // ��-��ȿ���� ȣ������ �ִ� ��� Warning ���
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="4" border="0">
            <tr>
                <td class="td_standard" style="text-align:left;color:#ff0000;">
                    <b>
                    ��ȿ���� ���� ȣ���̸��� �ֽ��ϴ�.<br><br>
                    ȣ���߰� â�� �����Ͽ� ������ �� �۾�(��ȸ)�Ͻñ� �ٶ��ϴ�!<br><br>
                    ����ȿ���� ���� ȣ���̸�: <%=invalidSelectedProjects%>                
                    </b>
                </td>
            </tr>
        </table>
    <%
    }
    else
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
            <tr height="20" bgcolor="#e5e5e5">
                <td width="4" class="td_standardBold"></td>
                <!--<td width="20" class="td_standardBold">No</td>-->
                <td width="55" class="td_standardBold">�ð�</td>
                <td width="150" class="td_standardBold">�����ȣ*</td>
                <td width="50" class="td_standardBold">OP*</td>   
                <td width="35" class="td_standardBold">����</td>
                <td width="100" class="td_standardBold">�����ȣ*</td> 
                <td width="100" class="td_standardBold">���κμ�</td>
                <td width="40" class="td_standardBold">�ٰ�</td>
                <td width="265" class="td_standardBold">��������</td>
                <td width="90" class="td_standardBold">Event1*</td>
                <td width="90" class="td_standardBold">Event2</td>
                <td width="90" class="td_standardBold">Event3</td>
                <td width="50" class="td_standardBold">����</td>
            </tr>

            <%
            for (int i = 0; i < timeKeys.length; i++)
            {
                String timeKey = timeKeys[i];
                String timeStr = timeKey.substring(0, 2) + ":" + timeKey.substring(2);
                
                String sTimeData = "";
                String projectNoData = "";
                String dwgTypeData = "";
                String dwgCodeData = "";
                String opCodeData = "";
                String causeDepartData = "";
                String basisData = "";
                String workDescData = "";
                String event1Data = "";
                String event2Data = "";
                String event3Data = "";
				String shipTypeData = "";

                for (int j = 0; j < mhInputList.size(); j++) {
                    Map mhInputMap = (Map)mhInputList.get(j);
                    if (timeStr.equals((String)mhInputMap.get("START_TIME"))) {
                        sTimeData = (String)mhInputMap.get("START_TIME");
                        projectNoData = (String)mhInputMap.get("PROJECT_NO");
                        dwgTypeData = (String)mhInputMap.get("DWG_TYPE");
                        dwgCodeData = (String)mhInputMap.get("DWG_CODE");
                        opCodeData = (String)mhInputMap.get("OP_CODE");
                        causeDepartData = (String)mhInputMap.get("CAUSE_DEPART");
                        basisData = replaceAmpAll((String)mhInputMap.get("BASIS"), "'", "��");
                        workDescData = replaceAmpAll((String)mhInputMap.get("WORK_DESC"), "'", "��");
                        event1Data = (String)mhInputMap.get("EVENT1");
                        event2Data = (String)mhInputMap.get("EVENT2");
                        event3Data = (String)mhInputMap.get("EVENT3");
						shipTypeData = (String)mhInputMap.get("SHIP_TYPE");

                        if (!projectNoData.equals("S000") && !projectNoData.equals("PS0000") && !projectNoData.equals("V0000") && !dwgCodeData.equals("*****") 
                            && !dwgCodeData.equals("#####") && !opCodeData.equals("B53") && !opCodeData.equals("D15") && event1Data.equals("")) 
                        {
                            event1Data = "(���þ���)";
                        }
                    }
                }

                %>
                    <tr id="time<%=timeKey%>" height="20" bgcolor="#ffffff" <%if (i != 0 && sTimeData.equals("")) {%>style="display:none;"<%}%> OnMouseOver="trOnMouseOver(this, '<%=timeKey%>');" OnMouseOut="trOnMouseOut(this, '<%=timeKey%>');"  onclick="updateDrawingInfo('<%=timeKey%>');">
                        <td width="4" class="td_standard" bgcolor="#eeeeee"></td>
                        <!-- �ð� -->
                        <td class="td_standard"><font color="blue"><%=timeStr%></font></td>
                        <!-- �����ȣ(ȣ��) -->
                        <td class="td_standard" width="150">
                            <input name="pjt<%=timeKey%>" value="<%=projectNoData%>" class="input_small" style="width:80px;text-align:center;" readonly onClick="showElementSel('pjt', '<%=timeKey%>');" />
                            <select name="pjtSel<%=timeKey%>" class="input_small" style="width:80px;display:none;background-color:#fff0f5;" onChange="projectSelChanged('pjt', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                                <option value="S000" <%if(projectNoData.equals("S000")){%>selected<%}%>>S000</option>
                                <%
                                for (int j = 0; selectedProjectList != null && j < selectedProjectList.size(); j++) {
                                    Map map = (Map)selectedProjectList.get(j);
                                    String projectNo = (String)map.get("PROJECTNO");
                                    String dlEffective = (String)map.get("DL_EFFECTIVE");
                                    String selected = "";
                                    if (projectNoData.equals(projectNo) || projectNoData.equals("Z" + projectNo)) selected = "selected";
                                    if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNo = "Z" + projectNo;
                                %>
                                    <option value="<%=projectNo%>" <%=selected%>><%=projectNo%></option>
                                <%
                                    if (i == 0) selectedProjectListStr += selectedProjectListStr.equals("") ? projectNo : "," + projectNo;
                                }
                                %>
                            </select>
                            <input type="button" name="ProjectsButton" value="����ȣ��" style="height:18px;width:50px;font-size:8pt;" onclick="showProjectMultiSelect('<%=timeKey%>');"/>
                        </td>   
                        <!-- OP CODE -->
                        <td class="td_standard">
                            <input name="op<%=timeKey%>" value="<%=opCodeData%>" class="input_noBorder" style="width:25px;" readonly onClick="showOpBtn('<%=timeKey%>');" />
                            <input type="button" name="opSel<%=timeKey%>" value="��" style="height:18px;width:18px;display:none;background-color:#fff0f5;" onclick="showOpSelectWin('<%=timeKey%>');" />
                        </td>                                              
                        <!-- ���� ���� -->
                        <td class="td_standard">
                            <input name="drwType<%=timeKey%>" value="<%=dwgTypeData%>" class="input_noBorder" style="width:35px;text-align:center;" readonly onClick="showDrwTypeSel('drwType', '<%=timeKey%>');" />
                            <select name="drwTypeSel<%=timeKey%>" class="input_small" style="width:35px;display:none;background-color:#fff0f5;" onChange="drwTypeSelChanged('drwType', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                            </select>
                        </td>
                        <!-- �����ȣ -->
                        <td class="td_standard">
                            <input name="drwNo<%=timeKey%>" value="<%=dwgCodeData%>" class="input_noBorder" style="width:100px;text-align:center;" readonly onClick="showDrwNoSel('drwNo', '<%=timeKey%>');" />
                            <select name="drwNoSel<%=timeKey%>" class="input_small" style="width:400px;display:none;background-color:#fff0f5;" onChange="drwNoSelChanged('drwNo', '<%=timeKey%>');">
                                <option value="" text="">&nbsp;</option>
                            </select>
                        </td>                       
                        <!-- ���κμ� -->
                        <td class="td_standard">
                            <input name="depart<%=timeKey%>" value="<%=causeDepartData%>" class="input_noBorder" style="width:100px;text-align:center;" readonly onClick="showDepartSel('depart', '<%=timeKey%>');" />
                            <select name="departSel<%=timeKey%>" class="input_small" style="width:200px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('depart', '<%=timeKey%>');">
                            </select>
                        </td>
                        <!-- �ٰ� -->
                        <td class="td_standard">
                            <input name="basis<%=timeKey%>" value="<%if(!basisData.equals("")){%>��<%}%>" class="input_noBorder" style="width:40px;text-align:center;" readonly onClick="showBasisSel('basis', '<%=timeKey%>');" />
                            <input name="basisSel<%=timeKey%>" value='<%=basisData%>' class="input_small" style="width:150px;height:18px;display:none;background-color:#fff0f5;" onChange="basisSelChanged('depart', '<%=timeKey%>');" onkeydown="inputCtrlKeydownHandler();" />
                        </td>
                        <!-- �������� -->
                        <td class="td_standard">
                            <input name="workContent<%=timeKey%>" value='<%=workDescData%>' class="input_noBorder" style="width:265px;" readonly onClick="showWorkContentSel('workContent', '<%=timeKey%>');" />
                            <input name="workContentSel<%=timeKey%>" value='<%=workDescData%>' class="input_small" style="width:265px;height:18px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('workContent', '<%=timeKey%>');" onkeydown="inputCtrlKeydownHandler();" />
                        </td>
                        <!-- EVENT1 -->
                        <td class="td_standard">
                            <input name="event1<%=timeKey%>" value="<%=event1Data%>" class="input_noBorder" style="width:90px;text-align:center;" readonly onClick="showEventSel('event1', '<%=timeKey%>');" />
                            <select name="event1Sel<%=timeKey%>" class="input_small" style="width:90px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('event1', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                                <option value="(���þ���)" <%if (event1Data.equals("(���þ���)")){%>selected<%}%>>(���þ���)</option>
                            </select>
                        </td>
                        <!-- EVENT2 -->
                        <td class="td_standard">
                            <input name="event2<%=timeKey%>" value="<%=event2Data%>" class="input_noBorder" style="width:90px;text-align:center;" readonly onClick="showEventSel('event2', '<%=timeKey%>');" />
                            <select name="event2Sel<%=timeKey%>" class="input_small" style="width:90px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('event2', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                            </select>
                        </td>
                        <!-- EVENT3 -->
                        <td class="td_standard">
                            <input name="event3<%=timeKey%>" value="<%=event3Data%>" class="input_noBorder" style="width:90px;text-align:center;" readonly onClick="showEventSel('event3', '<%=timeKey%>');" />
                            <select name="event3Sel<%=timeKey%>" class="input_small" style="width:90px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('event3', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                            </select>
                        </td>
                        <!-- ���� -->
                        <td class="td_standard">
                            <input name="shipType<%=timeKey%>" value="<%=shipTypeData%>" class="input_noBorder" style="width:50px;text-align:center;" readonly onClick="showShipTypeSel('shipType', '<%=timeKey%>');" />
                            <select name="shipTypeSel<%=timeKey%>" class="input_small" style="width:50px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('shipType', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                            </select>
                        </td>                        
                    </tr>
                <%
            }
            %>

            <!--
            <tr height="10" bgcolor="#ffffff" >
                <td width="5" class="td_standard" bgcolor="#eeeeee"></td>
                <td class="td_standard" colspan="11"></td>
            </tr>
            -->
        </table>
    <%
    }
    %>


<div id="printDiv" style="position:absolute;display:none;">
</div>

</form>

</div>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>

<script language="javascript">

	$(document).ready(function(){
	
		$("#mainBody").height($("body").height()-70);
		$("#mainBody").scroll(function(){
			$("#scrollHeight").val($("#mainBody").scrollTop());
		});
		
		    // ��ȸ �Ϸ� �޽��� 
	    <% if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
	        alert("��ȸ �Ϸ�");
	    <% } %>
		
	});
	
    var activeElement = null;
    var activeElementPair = null; 
    var isNewShow = false;
    var selectedProjectListStr = "<%=selectedProjectListStr%>";
    document.onclick = mouseClickHandler;

    // Docuemnt�� Keydown �ڵ鷯 ���� - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ���� ��
    document.onkeydown = keydownHandler;




    // 'OP' �ʵ� ���� �� �Է� ��Ʈ��(��ư) ǥ��
    function showOpBtn(timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return;
        
        var pjtInput = DPInputMain.all('pjt' + timeKey);
        if (pjtInput.value == '') return;

        //if (pjtInput.value != "S000" && DPInputMain.all('drwNo' + timeKey).value == "") return;

        var opInput = DPInputMain.all('op' + timeKey);
        var opSel = DPInputMain.all('opSel' + timeKey);

        isNewShow = true;
        toggleActiveElementDisplay();
        opSel.style.display = '';

        activeElement = opSel;
    }

    // OP CODE ���� â�� showModalDialog�� Popup ��Ű��, ���ð���� OP �Է� ĭ�� �ݿ��Ѵ�
    function showOpSelectWin(timeKey) 
    {
        var projectNo = DPInputMain.all('pjt' + timeKey).value;
        var sProperties = 'dialogHeight:440px;dialogWidth:740px;scroll=no;center:yes;resizable=no;status=no;';       

        var opCode = window.showModalDialog("stxPECDPInputNew_OpSelect.jsp?projectNo=" + projectNo, "", sProperties);

        if (opCode != null && opCode != 'undefined') 
        {
            // �⵵�� �����̸� OP CODE ���ÿ� ������ �д�
            var drawingNo = DPInputMain.all('drwNo' + timeKey).value;
            if (projectNo != '' && projectNo != 'S000' && projectNo != 'PS0000' && drawingNo != '' && drawingNo != '*****' && drawingNo != '#####') 
            {
                var workingStartDate = getDrawingWorkStartDate(projectNo, drawingNo);
                if (workingStartDate != "" && workingStartDate != "ERROR") 
                {
                    // ������ �ش����� �ʴ� �����۾�(OP CODE 21 ~ 24)�� ���� �Ұ�
                    if (opCode == "21" || opCode == "22" || opCode == "23" || opCode == "24") 
                    {
                        var dateStr1 = DPInputMain.dateSelected.value;
                        var dateStrs1 = dateStr1.split("-");
                        var date1 = new Date(dateStrs1[0], dateStrs1[1] - 1, dateStrs1[2]); // �ü��Է���
                        
                        var dateStrs2 = workingStartDate.split("-");
                        var date2 = new Date(dateStrs2[0], dateStrs2[1] - 1, dateStrs2[2]); // ���� �⵵��

                        if (date1 - date2 > 0) {
                            var msg = drawingNo + " ������ " + workingStartDate + " �� �̹� �⵵�� �Ǿ����ϴ�.\n\n";
                            msg += "�⵵��¥ �Է� �� �����۾�(OP CODE 21 ~ 24)�� ��� �����۾��̹Ƿ�\n\n";
                            msg += "OP CODE �� 5�� �����ϴ� �ڵ常 �Է��� �� �ֽ��ϴ�!";
                            alert(msg);
                            return;
                        }
                    }
                }
            }
            
            var prevOpCode = DPInputMain.all('op' + timeKey).value;

            // OP CODE�� ����Ǹ� ���� �Է°� �ʱ�ȭ
            if(prevOpCode != null && prevOpCode != "")
            {
		        var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
		        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
		        var drwTypeSelObj = DPInputMain.all('drwTypeSel' + timeKey);
		        var drwNoObj = DPInputMain.all('drwNo' + timeKey);        
		        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);
		        var opObj = DPInputMain.all('op' + timeKey);
		        var departObj = DPInputMain.all('depart' + timeKey);
		        var departSelObj = DPInputMain.all('departSel' + timeKey);
		        var basisObj = DPInputMain.all('basis' + timeKey);
		        var basisSelObj = DPInputMain.all('basisSel' + timeKey);
		        var workContentObj = DPInputMain.all('workContent' + timeKey);
		        var workContentSelObj = DPInputMain.all('workContentSel' + timeKey);
		        var event1Obj = DPInputMain.all('event1' + timeKey);
		        var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
		        var event2Obj = DPInputMain.all('event2' + timeKey);
		        var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
		        var event3Obj = DPInputMain.all('event3' + timeKey);
		        var event3SelObj = DPInputMain.all('event3Sel' + timeKey);		        
		        var shipTypeObj = DPInputMain.all('shipType' + timeKey);
		        var shipTypeSelObj = DPInputMain.all('shipTypeSel' + timeKey);		        
		
		        // ���鱸�� �� �ʱ�ȭ
		        drwTypeObj.value = ''; 
		        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
		        // �����ȣ �� �ʱ�ȭ
		        drwNoObj.value = ''; 
		        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
		        // OP �� �ʱ�ȭ
		        opObj.value = ''; 
		        // ���κμ� �� �ʱ�ȭ
		        departObj.value = '';
		        for (var i = departSelObj.options.length - 1 ; i >= 0; i--) departSelObj.options[i] = null;
		        // �ٰ� �� �ʱ�ȭ
		        basisObj.value = ''; basisSelObj.value = '';
		        // �������� �� �ʱ�ȭ
		        workContentObj.value = ''; workContentSelObj.value = '';
		        // EVENT1, 2, 3 �� �ʱ�ȭ
		        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
		        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
		        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;		        
		        // ���� �� �ʱ�ȭ
		        shipTypeObj.value = ''; shipTypeSelObj.options.selectedIndex = 0;        
		
		        // Bottom �� DP ���� ���� ������Ʈ
		        updateDrawingInfo('');
		
		        // �������� �߻� ���� �÷��� ����
		        DPInputMain.dataChanged.value = "true";
		
		        // �����ȣ(ȣ��)�� 'S000' or 'PS0000' or Multi �����ȣ(ȣ��)�϶� �����ȣ�� '*****'�� �����ϰ�, �� ���� ��쿡�� �ش� ȣ���� ���� ���鱸�� ����� DB���� ����...
		        if (pjtSelObj.value == "") {
		            return;
		        }
		        else if (pjtSelObj.value == 'S000' || pjtSelObj.value == 'PS0000') {
		            drwNoObj.value = '*****';
		        }
		        else if (pjtSelObj.value.indexOf(",") > -1) {
		            drwNoObj.value = '*****';
		        }		        
		        else {
		            drawingTypesForWorkQueryProc(pjtSelObj, drwTypeSelObj, "");
		        }
            }

            DPInputMain.all('op' + timeKey).value = opCode;
            
            // OP CODE�� ����ü�(A TYPE)�� �ƴϸ� �����ȣ�� '*****'�� ����
	        if(opCode.substring(0, 1) != 'A'){		 
			    var drwNoObj = DPInputMain.all('drwNo' + timeKey);     
			    drwNoObj.value = '*****';
			}            
            

            // OP CODE�� 'A2x'�� �ƴ� ��� '���κμ�' �Է� ���� �ʱ�ȭ�Ѵ�
            if (opCode.substring(0, 2) != 'A2') {
                var departObj = DPInputMain.all('depart' + timeKey);
                departObj.value = '';

                var departSelObj = DPInputMain.all('departSel' + timeKey);
                if (departSelObj.options.length > 0) {
                    for (var i = departSelObj.options.length - 1; i >= 0; i--) {
                        departSelObj.options[i] = null;
                    }
                }
            }
            // OP CODE�� '20' & 'A2x'�� �ƴ� ��� '�ٰ�' �Է� ���� �ʱ�ȭ�Ѵ�
            if (opCode.substring(0, 2) != 'A2' && opCode != '20') {
                DPInputMain.all('basis' + timeKey).value = '';
                DPInputMain.all('basisSel' + timeKey).value = '';
            }

            // �������� �߻� ���� �÷��� ����
            DPInputMain.dataChanged.value = "true";
            
			// OP CODE ���� �� ���鱸�� â Ȱ��ȭ
             isNewShow = true;
             showDrwTypeSel("drwType", timeKey);

            // Event1 �����׸� ǥ��
            //isNewShow = true;
            //showEventSel("event1", timeKey);

            // ����(Next) �Է� �׸��� Show
            /* 
            if (opCode.substring(0, 1) == '5') {
                isNewShow = true;
                showDepartSel('depart', timeKey);
            }
            else if (opCode == '20') {
                isNewShow = true;
                showBasisSel('basis', timeKey);
            }
            */
        }
    }

    // �ü��׸� �߰� ���� �׸� �߰��� ������ �������� üũ
    function checkBeforeTimeAdding(timeKey)
    {
        var opCode = DPInputMain.all('op' + timeKeys[0]).value;
        if (opCode == "D17") {
            alert("'����'�� �����Ǿ� �־� �� �׸��� �߰��� �� �����ϴ�.\n\n'����' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
            return false;
        }
        else if (opCode == "D14") {
            alert("'Ư���ް�'�� �����Ǿ� �־� �� �׸��� �߰��� �� �����ϴ�.\n\n'Ư���ް�' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
            return false;
        }
        else if (opCode == "D13") {
            alert("'�����Ʒ�(9H)'�� �����Ǿ� �־� �� �׸��� �߰��� �� �����ϴ�.\n\n'�����Ʒ�(9H)' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
            return false;
        }

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            if (timeKeys[i] == timeKey) continue;

            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                opCode = DPInputMain.all('op' + timeKeys[i]).value;
                var pjtNo = DPInputMain.all('pjt' + timeKeys[i]).value;

                if (opCode == 'D1Z') {
                    alert("'����ڵ�'�� �ԷµǾ� �� �׸��� �߰��� �� �����ϴ�.\n\n'���' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
                    return false;
                }
                else if (opCode == 'D16') {
                    alert("'�����ڵ�'�� �ԷµǾ� �� �׸��� �߰��� �� �����ϴ�.\n\n'����' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
                    return false;
                }
                else if (opCode == 'B53' && pjtNo != 'V0000') {
                    alert("'�ÿ��� �ڵ�'�� �ԷµǾ� �� �׸��� �߰��� �� �����ϴ�.\n\n'�ÿ���' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
                    return false;
                }
                else if (opCode == 'D15') { 
                    alert("'�ÿ��� �� �������(����) �ڵ�'�� �ԷµǾ� �� �׸��� �߰��� �� �����ϴ�.\n\n'�ÿ��� �� �������' ������ ����Ϸ��� 'OP CODE'�� �����Ͻʽÿ�.");
                    return false;
                }

                break;
            }
        }

        return true;
    }

    // Time Select â���� Ư�� Time(�ð�) �׸��� ���õǸ�, �ش� �׸� �ش��ϴ� Table Row(TR ��ü)�� ���̰ų� �����
    function timeSelected(timeKey)
    {
        // ����Ϸ�� ��쿡�� ���� X => ����Ϸ� ���δ� TimeSelect â���� � üũ��
        
        toggleActiveElementDisplay();

        if (!checkBeforeTimeAdding(timeKey)) return;

        var ctrlId = "time" + timeKey;
        var editWinStyle = DPInputMain.all(ctrlId).style;
        if (editWinStyle.display == '') {
            editWinStyle.display = 'none';
            // �Է°� �ʱ�ȭ - ���, ����, ... ���� �ԷµǾ��ٰ� Hidden�Ǵ� ��� ������ �� �ʱ�ȭ�� �ʿ���
            DPInputMain.all('pjt' + timeKey).value = ""; DPInputMain.all('pjtSel' + timeKey).selectedIndex = 0;
            DPInputMain.all('drwType' + timeKey).value = ""; DPInputMain.all('drwTypeSel' + timeKey).selectedIndex = 0;
            DPInputMain.all('drwNo' + timeKey).value = ""; DPInputMain.all('drwNoSel' + timeKey).selectedIndex = 0;
            DPInputMain.all('op' + timeKey).value = "";
            DPInputMain.all('depart' + timeKey).value = ""; if (DPInputMain.all('departSel' + timeKey).options.length > 0) DPInputMain.all('departSel' + timeKey).selectedIndex = 0;
            DPInputMain.all('basis' + timeKey).value = ""; DPInputMain.all('basisSel' + timeKey).value = "";
            DPInputMain.all('workContent' + timeKey).value = ""; DPInputMain.all('workContentSel' + timeKey).value = "";
            DPInputMain.all('event1' + timeKey).value = ""; DPInputMain.all('event1Sel' + timeKey).selectedIndex = 0;
            DPInputMain.all('event2' + timeKey).value = ""; DPInputMain.all('event2Sel' + timeKey).selectedIndex = 0;
            DPInputMain.all('event3' + timeKey).value = ""; DPInputMain.all('event3Sel' + timeKey).selectedIndex = 0;
        }
        else editWinStyle.display = '';
    }

    // �ʵ� ���� �� �� �ʵ��� �Է� ��Ʈ���� ǥ���Ѵ�. �Է� ��Ʈ���� �⺻������ Hidden�Ǿ� �ִٰ� �ش� �ʵ尡 Click�� ���� ��������.
    function showElementSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; // ���簡 �Ϸ�� �����̸� �Է°��� ��Ʈ���� ������� �ʴ´�
        
        var elemInput = DPInputMain.all(elemPrefix + timeKey);
        var elemSel = DPInputMain.all(elemPrefix + 'Sel' + timeKey);

        toggleActiveElementDisplay();

        elemInput.style.display = 'none';
        elemSel.style.display = '';


        activeElement = elemSel;
        activeElementPair = elemInput;
    }

    // '���� ����' �ʵ� ���� �� �Է� ��Ʈ�� ǥ��
    function showDrwTypeSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; // ���簡 �Ϸ�� �����̸� �Է°��� ��Ʈ���� ������� �ʴ´�

        var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (pjtObj.value == '' || pjtObj.value == 'S000' || pjtObj.value == 'PS0000') return; // �����ȣ(ȣ��) ���� ���ų� S000 or PS0000 �̸� �Է� ��Ʈ�� ǥ������ �ʴ´�
        if (pjtObj.value.indexOf(",") > -1) return; // Multi �����ȣ(ȣ��)�� ���õ� ��� �Է� ��Ʈ�� ǥ������ �ʴ´�
        
        var opCode = DPInputMain.all('op' + timeKey).value;

        if (opCode.substring(0, 1) != 'A') return;  // �����ȣ(ȣ��)�� 1���̰�, OP CODE�� 'Axx' �ϰ�츸 ���� ���� ���� ����

        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
        var drwTypeSelObj = DPInputMain.all('drwTypeSel' + timeKey);

        if (drwTypeObj.value != "" && drwTypeSelObj.options.length <= 1) {
            drawingTypesForWorkQueryProc(DPInputMain.all('pjtSel' + timeKey), drwTypeSelObj, drwTypeObj.value);
        }

        showElementSel(elemPrefix, timeKey);
    }

    // '�����ȣ' �ʵ� ���� �� �Է� ��Ʈ�� ǥ��
    function showDrwNoSel(elemPrefix, timeKey)
    {
        // Bottom �� DP ���� ���� ������Ʈ
        updateDrawingInfo(timeKey);

        if (DPInputMain.MHConfirmYN.value == 'Y') return; // ���簡 �Ϸ�� �����̸� �Է°��� ��Ʈ���� ������� �ʴ´�

        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);

        if (drwTypeObj.value == '') {
            var pjtObj = DPInputMain.all('pjt' + timeKey);
            // �����ȣ(ȣ��) ���� ������ �Է� ��Ʈ�� ǥ������ �ʴ´�
            if (pjtObj.value == '' || pjtObj.value == 'S000' || pjtObj.value == 'PS0000') return; 
            if (pjtObj.value.indexOf(",") > -1) return; // Multi �����ȣ(ȣ��)�� ���õ� ��� �Է� ��Ʈ�� ǥ������ �ʴ´�
/*****
            // �ؾ�ȣ���� ��쿡�� �����ȣ�� �ִ� ���(�� ����ü��� ���) '*****' �� ǥ������ �ʴ´� (Added on 2010-08-24)
            var pjtNoPrefixStr = pjtObj.value.substring(0, 1);
            if (pjtNoPrefixStr == 'H' || pjtNoPrefixStr == 'M' || pjtNoPrefixStr == 'F') {
                //if (pjtObj.value != 'M1101') return; // M1101�� �ؾ�ȣ���� �ƴ� (Added on 2011-04-28)
            }
            
            // �����ȣ�� �ִµ� ���鱸���� ���� ��쿡�� '*****' �� ǥ���Ѵ�
            for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
            //drwNoSelObj.options[1] = new Option("#####", "#####");       
            //if (drwNoObj.value == "#####") drwNoSelObj.selectedIndex = 1;
            drwNoSelObj.options[1] = new Option("*****", "*****");       
            if (drwNoObj.value == "*****") drwNoSelObj.selectedIndex = 1;
            ******/
        }
        else if (drwNoObj.value != "" && drwNoSelObj.options.length <= 1) {
            drawingListForWorkQueryProc(DPInputMain.all('pjtSel' + timeKey), drwTypeObj.value, drwNoSelObj, drwNoObj.value);
        }
		isNewShow = true; ///////////////////////
        showElementSel(elemPrefix, timeKey);
    }

    // '���κμ�' �ʵ� ���� �� �Է� ��Ʈ�� ǥ��
    function showDepartSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; 

        var opObj = DPInputMain.all('op' + timeKey);
        if (opObj.value.substring(0, 2) == 'A2') { // OP CODE�� �������(5A~5R) �� ��쿡�� �Է���Ʈ���� ǥ���Ѵ�
            var departSelObj = DPInputMain.all('departSel' + timeKey);
            var departVal = DPInputMain.all('depart' + timeKey).value;
            if (departSelObj.options.length <= 0) {
                for (var i = 0; i < DPInputMain.departmentList.options.length; i++) {
                    var newOption= new Option(DPInputMain.departmentList.options[i].text, DPInputMain.departmentList.options[i].value);
                    departSelObj.options[i + 1] = newOption;
                    if (departVal != "" && departVal == DPInputMain.departmentList.options[i].value) departSelObj.selectedIndex = i + 1;
                }
            }
			isNewShow = true; ///////////////////////
            showElementSel(elemPrefix, timeKey);
        }
    }
    

    // '�ٰ�' �ʵ� ���� �� �Է� ��Ʈ�� ǥ��
    function showBasisSel(elemPrefix, timeKey)
    {
        var opObj = DPInputMain.all('op' + timeKey);  
        
        if (opObj.value == "20" || opObj.value.substring(0, 2) == 'A2') { // OP CODE�� ���� Extra(20) �Ǵ� �������(5A~5R) �� ��쿡�� �Է���Ʈ���� ǥ���Ѵ�
        	isNewShow = true; ///////////////////////
            showElementSel(elemPrefix, timeKey);
        }
    }
    
    // '��������' ���� �� �Է� ��Ʈ�� ǥ��
    function showWorkContentSel(elemPrefix, timeKey)
    {
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        if (drwNoObj.value == '') return; // �����ȣ�� ���� ������ �Է� ��Ʈ�� ǥ������ �ʴ´�

        showElementSel(elemPrefix, timeKey);
    }

    // Event1, Event2, Event3 ���� �� �Է� ��Ʈ�� ǥ��
    function showEventSel(elemPrefix, timeKey)
    {
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        if (drwNoObj.value == '' || drwNoObj.value == '*****' || drwNoObj.value == '#####') return; 
        // :�����ȣ�� ���� ���ų� '*****'�̸� �Է� ��Ʈ�� ǥ������ �ʴ´�

        var elemName = elemPrefix + "Sel";
        // �ʱ�ȭ(���� Option �׸���� ����)
        for (i = DPInputMain.all(elemName + timeKey).options.length - 1; i >= 1; i--) {
            if (elemName == "event1Sel" && i == 1) break;
            DPInputMain.all(elemName + timeKey).options[i] = null;
        }
        DPInputMain.all(elemName + timeKey).options.selectedIndex = 0;

        var drwTypeValue = DPInputMain.all('drwType' + timeKey).value;
        if (drwTypeValue == "V") {
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V1:P.O.S ����", "V1");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V2:��ü����", "V2");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V3:���ſ���", "V3");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V4:��ü��������", "V4");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V5:���ֽ��ι߼�", "V5");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V6:���ֽ�������", "V6");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V7:��ü�⵵��", "V7");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V8:�۾����⵵��", "V8");
        }
        else {
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y1:������", "Y1");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y2:�Ϸ���", "Y2");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y3:���ֽ��ι߼�", "Y3");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y4:���ֽ�������", "Y4");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y5:���޽��ι߼�", "Y5");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y6:���޽�������", "Y6");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y7:�����߼�", "Y7");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y8:�۾���߼�", "Y8");
        }
        var eventValue = DPInputMain.all(elemPrefix + timeKey).value;
        if (eventValue != "") {
            for (i = 1; i < DPInputMain.all(elemName + timeKey).options.length; i++) {
                if (eventValue == DPInputMain.all(elemName + timeKey).options[i].value) {
                    DPInputMain.all(elemName + timeKey).options.selectedIndex = i;
                    break;
                }
            }
        }

        showElementSel(elemPrefix, timeKey);
    }

    // �Է� ��Ʈ�ѿ��� �� �Է�(����) �� �Է� ��Ʈ���� ����� �ش� �ʵ忡 �Էµ� ���� ǥ���Ѵ�
    function elementSelChanged(elemPrefix, timeKey)
    {
        var elemInput = DPInputMain.all(elemPrefix + timeKey);
        var elemSel = DPInputMain.all(elemPrefix + 'Sel' + timeKey);
        elemInput.value = elemSel.value;

        // �������� �߻� ���� �÷��� ����
        DPInputMain.dataChanged.value = "true";
    }
    
    function projectSelChangedAction(elemPrefix, timeKey)
    {
        elementSelChanged(elemPrefix, timeKey);

        var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
        var drwTypeSelObj = DPInputMain.all('drwTypeSel' + timeKey);
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);        
        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);
        var opObj = DPInputMain.all('op' + timeKey);
        var departObj = DPInputMain.all('depart' + timeKey);
        var departSelObj = DPInputMain.all('departSel' + timeKey);
        var basisObj = DPInputMain.all('basis' + timeKey);
        var basisSelObj = DPInputMain.all('basisSel' + timeKey);
        var workContentObj = DPInputMain.all('workContent' + timeKey);
        var workContentSelObj = DPInputMain.all('workContentSel' + timeKey);
        var event1Obj = DPInputMain.all('event1' + timeKey);
        var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
        var event2Obj = DPInputMain.all('event2' + timeKey);
        var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
        var event3Obj = DPInputMain.all('event3' + timeKey);
        var event3SelObj = DPInputMain.all('event3Sel' + timeKey);
		var shipTypeObj = DPInputMain.all('shipType' + timeKey);
		var shipTypeSelObj = DPInputMain.all('shipTypeSel' + timeKey);		        

        // ���鱸�� �� �ʱ�ȭ
        drwTypeObj.value = ''; 
        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
        // �����ȣ �� �ʱ�ȭ
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
        // OP �� �ʱ�ȭ
        opObj.value = ''; 
        // ���κμ� �� �ʱ�ȭ
        departObj.value = '';
        for (var i = departSelObj.options.length - 1 ; i >= 0; i--) departSelObj.options[i] = null;
        // �ٰ� �� �ʱ�ȭ
        basisObj.value = ''; basisSelObj.value = '';
        // �������� �� �ʱ�ȭ
        workContentObj.value = ''; workContentSelObj.value = '';
        // EVENT1, 2, 3 �� �ʱ�ȭ
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;
		// ���� �� �ʱ�ȭ
		shipTypeObj.value = ''; shipTypeSelObj.options.selectedIndex = 0;

        // Bottom �� DP ���� ���� ������Ʈ
        updateDrawingInfo('');

        // �������� �߻� ���� �÷��� ����
        DPInputMain.dataChanged.value = "true";

        // �����ȣ(ȣ��)�� 'S000' or 'PS0000' or Multi �����ȣ(ȣ��)�̸� �����ȣ�� '*****'�� �����ϰ�, �� ���� ��쿡�� �ش� ȣ���� ���� ���鱸�� ����� DB���� ����...
        if (pjtSelObj.value == "") {
            return;
        }
        else if (pjtSelObj.value == 'S000' || pjtSelObj.value == 'PS0000') {
            drwNoObj.value = '*****';
        }
        else if (pjtSelObj.value.indexOf(",") > -1) {
            drwNoObj.value = '*****';
        }
        else {
            drawingTypesForWorkQueryProc(pjtSelObj, drwTypeSelObj, "");
        }
        
        // ���� ���� �� LOV ä��
        shipTypeQueryProc(shipTypeSelObj, "");
        
        // ȣ�� ���� �� Action
        projectSelChangedAfter(timeKey);    
    	   
    }
    

    // �����ȣ(ȣ��) ���� �� �ٸ� �Է� �׸���� �ʱ�ȭ�ϰ� �ش� ȣ���� ���� '���鱸��' ������ DB���� ������ �´�
    function projectSelChanged(elemPrefix, timeKey)
    {
	    var pjtSelValue = DPInputMain.all('pjtSel' + timeKey).value;
	    var pjtValue = DPInputMain.all('pjt' + timeKey).value;

		var actionFlag = false;
	    if(pjtSelValue.substring(0, 1)=='Z' || pjtSelValue.indexOf(",Z") > -1)
	    {
	     	 var ConfirmMsg = "�ε�ȣ�� ("+pjtSelValue+") �� ���� �ü��Է� ��\n�ݵ�� ����������� ������ �Է��Ͽ� �ֽñ� �ٶ��ϴ�.\n\n";
	     	 ConfirmMsg += "�ε����� �� ���� ���� ���ǻ�����\n�����ȹ�� �Ѱ��� ���� (T.3220) ���� ���ǹٶ��ϴ�.\n\n�����Ͻðڽ��ϱ�?";
	     	 	
	     	 if(confirm(ConfirmMsg))
	     	 {
	     	 	projectSelChangedAction(elemPrefix, timeKey);	     	 	
	     	 } else {
	     	 	// selectbox�� value�� ���� input������ ����
	     	 	DPInputMain.all('pjtSel' + timeKey).value = DPInputMain.all('pjt' + timeKey).value;
	     	 }
	    } else {
	    	projectSelChangedAction(elemPrefix, timeKey);
	    }  
   }

    // projectSelChanged() ����� �� ȣ���� 'S000' or Multi �����ȣ(ȣ��)�̸� OP CODE â�� ����, ��Ÿ ȣ���̸� ����Ÿ�� ���� ��Ʈ���� Show ��Ų�� 
    function projectSelChangedAfter(timeKey)
    {
        toggleActiveElementDisplay();

        var pjtObj = DPInputMain.all('pjt' + timeKey);
        showOpSelectWin(timeKey);
        /* ȣ�� ���� �� OP CODE â ��쵵�� ����
        if (pjtObj.value == 'S000' || pjtObj.value.indexOf(",") > -1) showOpSelectWin(timeKey);
        else if (pjtObj.value != "") {
            isNewShow = true;
            showElementSel("drwType", timeKey);
            
        }*/
    }

    // Ư�� ȣ�� + �μ��� ���� '���鱸��' ������ DB���� �����ؿ��� '���鱸��' LOV�� ä��� ����-���ν���
    function drawingTypesForWorkQueryProc(pjtSelObj, drwTypeSelObj, selectedValue)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingTypesForWork&departCode=" + 
                            DPInputMain.deptCode.value + "&projectNo=" + pjtSelObj.value, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("|");
                        drwTypeSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var newOption = new Option(strs[i], strs[i]);
                            drwTypeSelObj.options[i + 1] = newOption;
                            if (selectedValue != "" && selectedValue == strs[i]) drwTypeSelObj.selectedIndex = i + 1;  
                        }
                    }
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

    // ���鱸�� �� ���� �� �ٸ� ���� �Է� �׸���� �ʱ�ȭ�ϰ� '�����ȣ' �׸���� DB���� ������ �´�
    function drwTypeSelChanged(elemPrefix, timeKey)
    {
        elementSelChanged(elemPrefix, timeKey);

        var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
        var drwTypeValue = DPInputMain.all('drwTypeSel' + timeKey).value;
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);
        var workContentObj = DPInputMain.all('workContent' + timeKey);
        var workContentSelObj = DPInputMain.all('workContentSel' + timeKey);
        var event1Obj = DPInputMain.all('event1' + timeKey);
        var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
        var event2Obj = DPInputMain.all('event2' + timeKey);
        var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
        var event3Obj = DPInputMain.all('event3' + timeKey);
        var event3SelObj = DPInputMain.all('event3Sel' + timeKey);
		var shipTypeObj = DPInputMain.all('shipType' + timeKey);
		var shipTypeSelObj = DPInputMain.all('shipTypeSel' + timeKey);        

        // �����ȣ �� �ʱ�ȭ
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
        // �������� �� �ʱ�ȭ
        workContentObj.value = ''; workContentSelObj.value = '';
        // EVENT1, 2, 3 �� �ʱ�ȭ
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;

        // �������� �߻� ���� �÷��� ����
        DPInputMain.dataChanged.value = "true";

        // Bottom �� DP ���� ���� ������Ʈ
        updateDrawingInfo('');

        // ���鱸�� ���� ���� ���� �ش� ȣ�� & �μ��� �۾� ��� ���� ����� ��񿡼� ����
        if (drwTypeValue == '') {
            drwNoObj.value = '';
        }
        else {
            drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, "");

            // �����ȣ ���� ��Ʈ���� Show
            //toggleActiveElementDisplay();
            isNewShow = true;
            showDrwNoSel('drwNo', timeKey);
        }
    }

    // Ư�� ȣ�� + �μ� + ����Ÿ�Կ� ���� '�����ȣ' ������ DB���� �����ؿ��� '�����ȣ' LOV�� ä��� ����-���ν���
    function drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, selectedValue)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork&departCode=" + 
                            DPInputMain.deptCode.value + "&projectNo=" + pjtSelObj.value + "&drawingType=" + drwTypeValue, false);
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
                        drwNoSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split("��");
                            var newOption = new Option(strs2[0] + " : " + strs2[1], strs2[0]);
                            drwNoSelObj.options[i + 1] = newOption;
                            if (selectedValue != "" && selectedValue == strs2[0]) drwNoSelObj.selectedIndex = i + 1; 
                        }
                    }
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

    // �����ȣ �� ����(����) �� ���õ� ������ ������ '��������' �׸��� ���� �����Ѵ�
    function drwNoSelChanged(elemPrefix, timeKey)
    {
        elementSelChanged(elemPrefix, timeKey);
    
        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);
        var workContentObj = DPInputMain.all('workContent' + timeKey);
        var workContentSelObj = DPInputMain.all('workContentSel' + timeKey);

        var drwNoStr = drwNoSelObj.options[drwNoSelObj.selectedIndex].text;
        if (drwNoStr.indexOf(" : ") > 0) {
            var tempStrs = drwNoStr.split(" : ");
            drwNoStr = tempStrs[1];
        }
        if (drwNoStr != "*****" && drwNoStr != "#####") {
            workContentObj.value = drwNoStr;
            workContentSelObj.value = workContentObj.value;
        }

        // EVENT1, 2, 3 �� �ʱ�ȭ
        var event1Obj = DPInputMain.all('event1' + timeKey);
        var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
        var event2Obj = DPInputMain.all('event2' + timeKey);
        var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
        var event3Obj = DPInputMain.all('event3' + timeKey);
        var event3SelObj = DPInputMain.all('event3Sel' + timeKey);
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;
        
        
        // OP CODE�� 'A2x'�� �ƴ� ��� '���κμ�' �Է� ���� �ʱ�ȭ�Ѵ�      
        var opCode = DPInputMain.all('op' + timeKey).value;
        if (opCode.substring(0, 2) != 'A2') {
            var departObj = DPInputMain.all('depart' + timeKey);
            departObj.value = '';

            var departSelObj = DPInputMain.all('departSel' + timeKey);
            if (departSelObj.options.length > 0) {
                for (var i = departSelObj.options.length - 1; i >= 0; i--) {
                    departSelObj.options[i] = null;
                }
            }
        }
        // OP CODE�� '20' & 'A2x'�� �ƴ� ��� '�ٰ�' �Է� ���� �ʱ�ȭ�Ѵ�
        if (opCode.substring(0, 2) != 'A2' && opCode != '20') {
            DPInputMain.all('basis' + timeKey).value = '';
            DPInputMain.all('basisSel' + timeKey).value = '';
        }        

        // �������� �߻� ���� �÷��� ����
        DPInputMain.dataChanged.value = "true";

        // Bottom �� DP ���� ���� ������Ʈ
        var drwNoSelValue = drwNoSelObj.options[drwNoSelObj.selectedIndex].value;
        parent.DP_BOTTOM.updateDrawingInfo(DPInputMain.all('pjt' + timeKey).value, drwNoSelValue);

        // OP CODE�� Show        
        if (drwNoSelValue != "") {
            toggleActiveElementDisplay();
            isNewShow = true;
            showDepartSel("depart", timeKey);
           // showOpSelectWin(timeKey);
        }
        
    }

    // �ٰ� �� �Է�(����) �� 
    function basisSelChanged(elemPrefix, timeKey)
    {
        elementSelChanged(elemPrefix, timeKey);

        var basisSelObj = DPInputMain.all('basisSel' + timeKey);
        var basisObj = DPInputMain.all('basis' + timeKey);
        if (basisSelObj.value.trim() != "") basisObj.value = "��";
        else basisObj.value = "";
    }

    // ���콺 Ŭ�� �� ���� Ȱ��ȭ�� �Է� ��Ʈ���� �����(�ش� ��Ʈ�ѿ� ���� ���콺 Ŭ���� �ƴ� ���)
    function mouseClickHandler(e)
    {
        if (activeElement == null) return;
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        var posX = event.clientX;
        var posY = Number(event.clientY) + Number($("#scrollHeight").val());
        var objPos = getAbsolutePosition(activeElement);
        if (posX < objPos.x || posX > objPos.x + activeElement.offsetWidth || posY < objPos.y  || posY > objPos.y + activeElement.offsetHeight)
        {
            toggleActiveElementDisplay();
        }
    }

    // �Է� �� ǥ�� �ʵ�� �Է� ��Ʈ���� Display(�������� ��)�� ��ȣ ��ġ�Ѵ�
    function toggleActiveElementDisplay()
    { 
        if (activeElement != null) {
            activeElement.style.display = 'none';
            if (activeElementPair != null) activeElementPair.style.display = '';
            activeElement = null;
            activeElementPair = null;
        }
    }

    // �ü��Է� ������ Validation Check...
    function checkInputs()
    {
        // ����Ϸ� ���� üũ
        if (DPInputMain.MHConfirmYN.value == 'Y') {
            alert("���簡 �Ϸ�� �����Դϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
            return false;
        }
        
        // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
        var dateStr = DPInputMain.dateSelected.value;
        var dateStrs = dateStr.split("-");
        var selectedDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
        if (dpInputLockDateStr == "ERROR") {
            alert("ERROR!");
            return false;
        }
        else {
            var strs = dpInputLockDateStr.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);

			<%if(!isAdmin){%>
            if (selectedDate - dpInputLockDate < 0) {
                //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                
                var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                alert(alertMsg);
               
                return false;
            }
            <%}%>
        }

        // �ʼ��Է� �׸� �Է� ���� üũ
        var idx = 0;
        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display == 'none') continue;

            idx++;
   
            var pjt = DPInputMain.all('pjt' + timeKeys[i]).value;
            var drwNo = DPInputMain.all('drwNo' + timeKeys[i]).value;
            var op = DPInputMain.all('op' + timeKeys[i]).value;
            var workContent = DPInputMain.all('workContent' + timeKeys[i]).value;
            var event1Value = DPInputMain.all('event1' + timeKeys[i]).value;
            var event2Value = DPInputMain.all('event2' + timeKeys[i]).value;
            var event3Value = DPInputMain.all('event3' + timeKeys[i]).value;

            var errKey = "";

            if (pjt == '') errKey = "�����ȣ";
            if (errKey == '' && drwNo == '')  errKey = "�����ȣ";
            if (errKey == '' && op == '') errKey = "OP �ڵ�";
            if (errKey == '' && (op == '20' || op.substring(0, 2) == 'A2')) { 
                var depart = DPInputMain.all('depart' + timeKeys[i]).value;
                var basis = DPInputMain.all('basis' + timeKeys[i]).value;

                if (op != '20' && depart == '') errKey = "���κμ�";
                if (errKey == '' && basis == '') errKey = "�ٰ�";
            }
            //if (errKey == '' && workContent == '') errKey = "��������";
            // Multi �����ȣ(ȣ��)�� ���õ� ��쵵 EVENT1 üũ����
            if (errKey == '' && pjt != 'S000' && pjt != 'PS0000' && pjt != 'V0000' && drwNo != "*****" && drwNo != "#####" 
                && op != "B53" && op != "D15" && (!pjt.indexOf(",") > -1) && event1Value == "") errKey = "Event1";

            if (errKey != "") {
                alert("No." + idx + "��° ���� " + errKey + "��(��) �Էµ��� �ʾҽ��ϴ�.\n\n�Է»����� �ٽ� �ѹ� Ȯ���� �ֽñ� �ٶ��ϴ�.");
                return false;
            }

            if (event1Value == '(���þ���)') event1Value = '';
            if ((event1Value == "" && (event2Value != "" || event3Value != "")) || (event2Value == "" && event3Value != "")) {
                alert("No." + idx + "��° ���� Event �Է� ��ġ�� �ùٸ��� �ʽ��ϴ�!\n\nEvent1, 2, 3 ������ �Է��� �ֽʽÿ�.");
                return false;
            }

            if (event1Value != "" && (event1Value == event2Value || event1Value == event3Value || (event2Value != "" 
                                                                                                   && (event2Value == event3Value)))) {
                alert("No." + idx + "��° ���� Event �Է� ���� �ߺ��Ǿ����ϴ�!\n\n�Է»����� �ٽ� �ѹ� Ȯ���� �ֽñ� �ٶ��ϴ�.");
                return false;
            }
            // op code�� ����ü�(A type)�ε� ���� ��ȣ�� ���ų� '*****' �̸� ����            
            if(op.substring(0, 1) == 'A' && (drwNo == '' || drwNo == '*****') && pjt != 'S000' && pjt != 'PS0000')
            {
                alert("No." + idx + "��° ���� ���� ��ȣ�� �����ϴ�!\n\nOP CODE�� ����ü�(A type)�� ��� �����ȣ�� �ʼ��Դϴ�.");
                return false;            
            }
        }

        return true;
    }

    // �ü��Է� ���� ó�� ����-���ν���
    function saveDPInputsProc(inputDoneYN, showMessage)
    {
        var workingDayYN = DPInputMain.workingDayYN.value;
        if (workingDayYN == '����') workingDayYN = 'Y'; 
        else if (workingDayYN == '4H') workingDayYN = '4H'; 
        else workingDayYN = 'N';

        var normalTimeTotal = 0;
        var overtimeTotal = 0;
        var specialTimeTotal = 0;

        var params = "";
        params = "designerID=" + DPInputMain.designerID.value;
        params += "&dateStr=" + DPInputMain.dateSelected.value;
        params += "&loginID=" + DPInputMain.loginID.value;

        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display == 'none') continue;

            var projectNo = DPInputMain.all('pjt' + timeKeys[i]).value;
            var event1 = DPInputMain.all('event1' + timeKeys[i]).value;
            if (event1 == '(���þ���)') event1 = '';
    
            params += "&timeKey"     + timeKeys[i] + "=" +  timeKeys[i] + "&";
            params += "&pjt"         + timeKeys[i] + "=" + projectNo;
            params += "&drwType"     + timeKeys[i] + "=" + DPInputMain.all('drwType' + timeKeys[i]).value;
            params += "&drwNo"       + timeKeys[i] + "=" + DPInputMain.all('drwNo' + timeKeys[i]).value;
            params += "&op"          + timeKeys[i] + "=" + DPInputMain.all('op' + timeKeys[i]).value;
            params += "&depart"      + timeKeys[i] + "=" + DPInputMain.all('depart' + timeKeys[i]).value;
            params += "&basis"       + timeKeys[i] + "=" + DPInputMain.all('basisSel' + timeKeys[i]).value.replaceAmpAll();
            params += "&workContent" + timeKeys[i] + "=" + DPInputMain.all('workContent' + timeKeys[i]).value.replaceAmpAll();
            params += "&event1"      + timeKeys[i] + "=" + event1;
            params += "&event2"      + timeKeys[i] + "=" + DPInputMain.all('event2' + timeKeys[i]).value;
            params += "&event3"      + timeKeys[i] + "=" + DPInputMain.all('event3' + timeKeys[i]).value;
            params += "&shipType"    + timeKeys[i] + "=" + DPInputMain.all('shipType' + timeKeys[i]).value;

            // �ü����
            var normalTime = 0;
            var overtime = 0;
            var specialTime = 0;

            // ����, Ư���ް�, �����Ʒ�(9H)
            var opCode = DPInputMain.all('op' + timeKeys[i]).value;
            if (i == 0 && (opCode == 'D17' || opCode == 'D13' || opCode == 'D14')) { 
                if (workingDayYN == '4H') normalTime = 4; 
                else normalTime = 9;
                inputDoneYN = 'Y'; // ���� ���̸� 08:00 �� �Է»����� �����Ƿ� �ü��Է� �Ϸ� (���Ͽ��� �� �׸�� �����Ǵ� ��� ����)
            }
            // ���� : ����ٹ� 9 �ð� �������� å��(4H�� ���� 4 �ð� ����)
            else if (opCode == 'D16') {
                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
                else normalTime = 9 - normalTimeTotal;
                inputDoneYN = 'Y'; // ���� �׸� ���� �Է»����� �����Ƿ� �ü��Է� �Ϸ� (���Ͽ��� �� �׸� �����Ǵ� ��� ����)
            }
            // �ÿ��� �� �������(����) : ����ٹ� 9�ð�(4H �� 4�ð�) �������� å�� (�ÿ��� �� ��������� 18:00 ��(4H ���� 12:00 ��) �ԷµǴ� ��찡 ����)
            else if (opCode == 'D15') {
                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
                else normalTime = 9 - normalTimeTotal;
                inputDoneYN = 'Y';
            }
            // �Ϲ����� ���̽� (�ÿ��� ����)
            else { 
                var hasNext = false;
                for (var j = i + 1; j < timeKeys.length; j++) {
                    if (DPInputMain.all("time" + timeKeys[j]).style.display != 'none') {
                        hasNext = true;
                        break;
                    }
                }
                if (hasNext) {
                    for (var j = i + 1; j < timeKeys.length; j++) {
                        var toBeStop = false;
                        if (DPInputMain.all("time" + timeKeys[j]).style.display != 'none') toBeStop = true;
                        
                        if (timeKeys[j] == "1230" || timeKeys[j] == "1300") { // 12:00~13:00(���ɽð�)�� �ü��� ���� X
                            if (toBeStop) break;
                            else continue;
                        }

                        if (workingDayYN == '4H') {
                            if (j <= 8) normalTime += 0.5; // 4H�� ��� 12:00 ���������� �Ϲݱٹ�
                            else overtime += 0.5; // 12:00 �ʰ����ʹ� ����ٹ�
                        }
                        else {
                            if (j <= 20) normalTime += 0.5; // 18:00 ���������� �Ϲݱٹ�
                            else overtime += 0.5; // 18:00 �ʰ����ʹ� ����ٹ�
                        }

                        if (toBeStop) break;
                    }
                }
                else if (opCode == 'B53' && projectNo != 'V0000') { // �ÿ����� �ڿ� �ٸ� �׸��� ������ ���� �Ϲ� ���̽��� ó����, ������ ����ٹ� 3 �ð� �������� ó��(������ Ư�� 8�ð�)
                    if (workingDayYN == 'Y') { 
                        if (normalTime < 9) normalTime = 9 - normalTimeTotal;
                        if (overtime < 3) overtime = 3 - overtimeTotal;
                    }
                    else if (workingDayYN == '4H') { 
                        if (normalTime < 4) normalTime = 4 - normalTimeTotal;
                        if (overtime < 3) overtime = 3 - overtimeTotal;
                    }
                    else { // ����
                        if (normalTime < 8) normalTime = 8 - specialTimeTotal; 
                    }

                    inputDoneYN = 'Y'; // �ÿ��� �ڿ� �ٸ� �׸��� �����Ƿ� �ü��Է� �Ϸ�
                }
                // �� �ܿ��� �ڿ� �ٸ� �׸��� ������ �ü������ ���� ����

                if (opCode == 'D1Z') inputDoneYN = 'Y'; // ����̸� �ü��Է� �Ϸ�
            }

            if (workingDayYN == 'N') {
                specialTime = normalTime + overtime;
                normalTime = 0;
                overtime = 0;
            }

            params += "&normalTime" + timeKeys[i] + "=" + normalTime;
            params += "&overtime" + timeKeys[i] + "=" + overtime;
            params += "&specialTime" + timeKeys[i] + "=" + specialTime;
    
            normalTimeTotal += normalTime;
            overtimeTotal += overtime;
            specialTimeTotal += specialTime;
        }

        params += "&inputDoneYN=" + inputDoneYN;

        DPInputMain.ajaxCallingSuccessYN.value = "N"; // DB ���� ������(���� or ����)�� ��� ���� ����. 

        var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
        if (resultMsg == "Y") {
            DPInputMain.ajaxCallingSuccessYN.value = "Y";

            // TODO 
            //if (showMessage && inputDoneYN == 'Y') alert("���� & Ȯ�� �Ϸ�");
            //else if (showMessage) alert("���� �Ϸ�");

            // FOR TEST
            if (inputDoneYN == 'Y' && showMessage) {
                alert("���� & Ȯ�� �Ϸ�\n\n\n- ����ٹ�: " + normalTimeTotal + "\n- ����ٹ�: " + overtimeTotal + "\n- Ư��: " + specialTimeTotal);
            }
            else if (showMessage) {
                alert("���� �Ϸ�\n\n\n- ����ٹ�: " + normalTimeTotal + "\n- ����ٹ�: " + overtimeTotal + "\n- Ư��: " + specialTimeTotal);
            }
            DPInputMain.dataChanged.value = "false";
        }
        else alert("���� �߻�");
    }

    // �ü��Է� ������ �����Ѵ�
    function saveDPInputs()
    {
        if (checkInputs() == false) return;

        var msg = DPInputMain.dateSelected.value + "\n\n�Է��� �ü��� �����Ͻðڽ��ϱ�?";        
        if (confirm(msg)) {
            saveDPInputsProc("N", true);
        }
    }

    // 1 �� �̻�(ȣ������ ����) - ����, Ư���ް�, ���� �Ʒ� �� ó�� ����-���ν���
    function saveAsVacationProc(opCode)
    {
        var sProperties = 'dialogHeight:145px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
        var periodStr = window.showModalDialog("stxPECDPInputNew_VacationPeriodSelect.jsp?opCode=" + opCode, "", sProperties);

        if (periodStr == null || periodStr == 'undefined') return;

        // TODO ���� �Ǵ� ���� ��¥�� ��� �ٸ� �Է��׸���� �浹 ����
        //      �̷��� ��쿡�� �ÿ���, �� �Էµ� Ư���ް� �� �ٸ� �Է��׸���� �浹 ����

        // �������� ������ �̳��� �ش��ϴ��� üũ
        var tempStrs = periodStr.split("~");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        
        var today = new Date();
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2] - 7); // �����Ͽ��� 7�� �� ��¥(7�� ��)
        if (fromDate - today > 0) {
            alert(jobDescStr + " �������ڴ� ���÷κ��� ������ �̳����� �մϴ�!");
            return;
        }

        // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
        fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
        if (dpInputLockDateStr == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            var strs = dpInputLockDateStr.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);

			<%if(!isAdmin){%>
            if ((fromDate - dpInputLockDate < 0)) {
                //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                
                var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // ����Ϸ�� ���ڰ� ���ԵǾ� �ִ��� üũ
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // ����Ϸ�� ���ڰ� ���ԵǾ� ������ ����
            if (confirmExist == "Y") {
                alert("���簡 �Ϸ�� ���ڰ� ���ԵǾ� �ֽ��ϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
                return;
            }
        }

        var jobDescStr = "?????";
        if (opCode == "D13") jobDescStr = "�����Ʒ�";
        else if (opCode =="D14") jobDescStr = "Ư���ް�";
        else if (opCode == "D17") jobDescStr = "����";

        // ���忩�� Ȯ�� & ����
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "��(��) �����Ͻðڽ��ϱ�?";        
        if (confirm(msg)) 
        {
            var params = "designerID=" + DPInputMain.designerID.value + 
                         "&fromDateStr=" + fromDateStr + "&toDateStr=" + toDateStr + "&workContentStr=" + jobDescStr + 
                         "&opCode=" + opCode + "&loginID=" + DPInputMain.loginID.value;

            var resultMsg = callDPCommonAjaxPostProc("SaveAsOneDayOverJobDPInputs", params);

            if (resultMsg != null) {
                resultMsg = resultMsg.trim();
                
                if (resultMsg == "ERROR") alert("ERROR");
                else if (resultMsg == "0") alert("����� ���ڰ� �����ϴ�!");
                else alert("���������� ����Ǿ����ϴ�!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // 1 �� �̻�(ȣ������ ����) - ���ȸ�� �� ����, �Ϲ�����
    function saveAsOneDayOverJob(opCode)
    {
        var sProperties = 'dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var returnVal = window.showModalDialog("stxPECDPInputNew_OneDayOverJobPeriodSelect.jsp?opCode=" + opCode, "", sProperties);

        if (returnVal == null || returnVal == 'undefined') return;

        // TODO ���� �Ǵ� ���� ��¥�� ��� �ٸ� �Է��׸���� �浹 ����
        //      �̷��� ��쿡�� �ÿ���, �� �Էµ� Ư���ް� �� �ٸ� �Է��׸���� �浹 ����

        // �������� ������ �̳��� �ش��ϴ��� üũ
        var tempStrs = returnVal.split("��");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        var workContentStr = tempStrs[2];
        
        // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
        if (dpInputLockDateStr == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            var strs = dpInputLockDateStr.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
			
			<%if(!isAdmin){%>
            if ((fromDate - dpInputLockDate < 0)) {
                //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                
                var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // ����Ϸ�� ���ڰ� ���ԵǾ� �ִ��� üũ
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // ����Ϸ�� ���ڰ� ���ԵǾ� ������ ����
            if (confirmExist == "Y") {
                alert("���簡 �Ϸ�� ���ڰ� ���ԵǾ� �ֽ��ϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
                return;
            }
        }


        var jobDescStr = "?????";
        if (opCode == "C22") jobDescStr = "���ȸ�� �� ����(�系��)";
        else if (opCode == "C31") jobDescStr = "�Ϲ�����(���������ȸ, ���̳�)";

        // ���忩�� Ȯ�� & ����
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "��(��) �����Ͻðڽ��ϱ�?";        
        if (confirm(msg)) 
        {
            var params = "designerID=" + DPInputMain.designerID.value + 
                         "&fromDateStr=" + fromDateStr + "&toDateStr=" + toDateStr + "&workContentStr=" + workContentStr + 
                         "&opCode=" + opCode + "&loginID=" + DPInputMain.loginID.value;

            var resultMsg = callDPCommonAjaxPostProc("SaveAsOneDayOverJobDPInputs", params);

            if (resultMsg != null) {
                resultMsg = resultMsg.trim();
                
                if (resultMsg == "ERROR") alert("ERROR");
                else if (resultMsg == "0") alert("����� ���ڰ� �����ϴ�!");
                else alert("���������� ����Ǿ����ϴ�!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // 1 �� �̻�(ȣ������ ����) - ��� ���� ����
    function saveAsOneDayOverJobWithProject(opCode)
    {
        var sProperties = 'dialogHeight:300px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "designerID=" + DPInputMain.designerID.value;
        paramStr += "&opCode=" + opCode;
        var returnVal = window.showModalDialog("stxPECDPInputNew_OneDayOverJobPeriodSelectPjt.jsp?" + paramStr, "", sProperties);

        if (returnVal == null || returnVal == 'undefined') return;

        // TODO ���� �Ǵ� ���� ��¥�� ��� �ٸ� �Է��׸���� �浹 ����
        //      �̷��� ��쿡�� �ÿ���, �� �Էµ� Ư���ް� �� �ٸ� �Է��׸���� �浹 ����

        // �������� ������ �̳��� �ش��ϴ��� üũ
        var tempStrs = returnVal.split("��");
        var projectNo = tempStrs[0];
        var fromDateStr = tempStrs[1];
        var toDateStr = tempStrs[2];
        var workContentStr = tempStrs[3];
        
        // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
        var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
        if (dpInputLockDateStr == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            var strs = dpInputLockDateStr.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
			
			<%if(!isAdmin){%>
            if ((fromDate - dpInputLockDate < 0)) {
                //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                
                var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // ����Ϸ�� ���ڰ� ���ԵǾ� �ִ��� üũ
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // ����Ϸ�� ���ڰ� ���ԵǾ� ������ ����
            if (confirmExist == "Y") {
                alert("���簡 �Ϸ�� ���ڰ� ���ԵǾ� �ֽ��ϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
                return;
            }
        }


        var jobDescStr = "?????";
        if (opCode == "B46") jobDescStr = "��� ���� ����(������� ����)";

        // ���忩�� Ȯ�� & ����
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "��(��) �����Ͻðڽ��ϱ�?";        
        if (confirm(msg)) 
        {
            var params = "designerID=" + DPInputMain.designerID.value + 
                         "&projectNo=" + projectNo + 
                         "&fromDateStr=" + fromDateStr + "&toDateStr=" + toDateStr + "&workContentStr=" + workContentStr + 
                         "&opCode=" + opCode + "&loginID=" + DPInputMain.loginID.value;

            var resultMsg = callDPCommonAjaxPostProc("SaveAsOneDayOverJobWithProjectDPInputs", params);

            if (resultMsg != null) {
                resultMsg = resultMsg.trim();
                
                if (resultMsg == "ERROR") alert("ERROR");
                else if (resultMsg == "0") alert("����� ���ڰ� �����ϴ�!");
                else alert("���������� ����Ǿ����ϴ�!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // ���
    function finishWork()
    {
        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '����' && i < 20) {
                    alert("18:00 ������ ����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i < 8) {
                    alert("12:00 ������ ����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (i == 0) {
                    alert("08:00 ���� ����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D1Z") inputExist = true;
                if (inputExist) {
                    alert("��� �ð��� ���� ������ �� ����� �����Ͻʽÿ�.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D1Z"; // 90 : ���
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "���"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "���";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;                    

                    if (checkInputs() == false) return;

                    // ���忩�� Ȯ�� & ����
                    var msg = DPInputMain.dateSelected.value + "\n\n�ü��� ���� & Ȯ���Ͻðڽ��ϱ�?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // ����
    function finishWorkEarly()
    {
        // Ȯ���� �ü��� ���� �Ұ�, ����� ���Ͽ��� ���� ���� => TimeSelect â���� � üũ��
        
        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '����' && i >= 20) {
                    alert("18:00 ���Ŀ��� �����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i >= 8) {
                    alert("12:00 ���Ŀ��� �����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (i < 4) {
                    alert("10:00 ������ �����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (i == 0) {
                    alert("08:00 ���� �����ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D16") inputExist = true;
                if (inputExist) {
                    alert("���� �ð��� ���� ������ �� ���� �����Ͻʽÿ�.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D16"; // 96 : ����
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "����"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "����";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

                    if (checkInputs() == false) return;

                    // ���忩�� Ȯ�� & ����
                    var msg = DPInputMain.dateSelected.value + "\n\n�ü��� ���� & Ȯ���Ͻðڽ��ϱ�?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // �ÿ���
    function saveAsSeaTrial()
    {
        toggleActiveElementDisplay();

        //if (!checkBeforeTimeAdding("")) return;

        var sProperties = 'dialogHeight:220px;dialogWidth:350px;scroll=no;center:yes;resizable=yes;status=no;';
        var paramStr = "designerID=" + DPInputMain.designerID.value;
        var periodStr = window.showModalDialog("stxPECDPInput_SeaTrialPeriodSelect.jsp?" + paramStr, "", sProperties);

        if (periodStr == null || periodStr == 'undefined') return;

        var tempStrs = periodStr.split("~");
        var projectNo = tempStrs[0];
        var tempStrs2 = tempStrs[1].split("|");
        var fromDate = tempStrs2[0];
        var fromTime = tempStrs2[1];
        tempStrs2 = tempStrs[2].split("|");
        var toDate = tempStrs2[0];
        var toTime = tempStrs2[1];
        var fromTimeStr = fromTime.substring(0, 2) + ":" + fromTime.substring(2, 4);
        var toTimeStr = toTime.substring(0, 2) + ":" + toTime.substring(2, 4);
        
        // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
        var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
        if (dpInputLockDateStr == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            var strs = dpInputLockDateStr.split("-");
            var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
            strs = fromDate.split("-");
            var seaTrialFromDate = new Date(strs[0], strs[1] - 1, strs[2]);
			
			<%if(!isAdmin){%>
            if ((seaTrialFromDate - dpInputLockDate < 0)) {
                //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                
                var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                alert(alertMsg);
               
                return;
            }
			<%}%>
        }


        // ����Ϸ�� ���ڰ� ���ԵǾ� �ִ��� üũ
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDate, toDate);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // ����Ϸ�� ���ڰ� ���ԵǾ� ������ ����
            if (confirmExist == "Y") {
                alert("���簡 �Ϸ�� ���ڰ� ���ԵǾ� �ֽ��ϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
                return;
            }
        }
        
        // TODO �ÿ��� �ش���(��)�� ������ ��쿡 ���� ó���� �߰�(+ Ư���ް� �κ��� to-do ����Ʈ�� ����)
        //      �ÿ��� �ش���(��)�� ��ȿ�� ���� ���� �ʿ�: ��, ���� +/- ���� �̳� 


        // [�ÿ����� ���ؽü�]
        // ���� - 21:00 ���� ����: Overtime 3 �ð����� ó�� 
        // ���� - 21:00 �� ����: �ش� �ð����� Overtime ó��
        // ���� - 17:00 ���� ����: Special-time 8 �ð����� ó��
        // ���� - 17:00 �� ����: �ش� �ð����� Special-time ó��
        // 4H   - 16:00 ���� ����: Overtime 3 �ð����� ó��
        // 4H   - 16:00 �� ����: �ش� �ð����� Overtime ó��


        // �ÿ��� �������ڰ� ȭ�� ǥ�����ڿ� �����ϸ� ȭ�鿡 �Էµ� ���װ� �浹�Ǵ� ���� ������ üũ
        if (DPInputMain.dateSelected.value == fromDate) 
        {
            // �ÿ��� ���۽ð� ���� �ð��뿡 �Է��׸��� �ִ��� üũ... ������ ���� => TODO Warning ��� �� ����ڰ� �����ϵ��� ������ ��
            var b = true;
            for (var i = timeKeys.length - 1; i > 0 && timeKeys[i] != fromTime; i--) {
                var ctrlId = "time" + timeKeys[i];
                var editWinStyle = DPInputMain.all(ctrlId).style;
                if (editWinStyle.display != 'none') {
                    b = false;
                    break;
                }
            }
            if (!b) {
                var msg = "�ÿ��� ���۽ð� ���� �ð��뿡 �Է»����� �ֽ��ϴ�.\n\n" + 
                          "�ش� �Է»��׵��� ������ �� �ÿ����� �����Ͻʽÿ�.";
                alert(msg);
                return;
            }

            // �ÿ��� �������� ȭ�� ǥ�����ڿ� �����ϸ� ȭ���� ������Ʈ �� ȭ���Է»����� �������� �ü��� ����(�ÿ��� ���۽ð��� �ÿ����ڵ� ����)
            if (fromTime != "0800") DPInputMain.all("time" + fromTime).style.display = ''; // ���۽ð� �ش� Row�� ����

            DPInputMain.all('pjt' + fromTime).value = projectNo; 
            for (var i = 0; i < DPInputMain.all('pjtSel' + fromTime).options.length; i++) {
                if (DPInputMain.all('pjtSel' + fromTime).options[i].value = projectNo) {
                    DPInputMain.all('pjtSel' + fromTime).selectedIndex = i;
                    break;
                }
            }
            DPInputMain.all('drwType' + fromTime).value = ""; DPInputMain.all('drwTypeSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('drwNo' + fromTime).value = "*****"; DPInputMain.all('drwNoSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('op' + fromTime).value = "B53"; // 45 : �ÿ���
            DPInputMain.all('depart' + fromTime).value = ""; if (DPInputMain.all('departSel' + fromTime).options.length > 0) DPInputMain.all('departSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('basis' + fromTime).value = ""; DPInputMain.all('basisSel' + fromTime).value = "";
            DPInputMain.all('workContent' + fromTime).value = "�ÿ���"; DPInputMain.all('workContentSel' + fromTime).value = "�ÿ���";
            DPInputMain.all('event1' + fromTime).value = ""; DPInputMain.all('event1Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('event2' + fromTime).value = ""; DPInputMain.all('event2Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('event3' + fromTime).value = ""; DPInputMain.all('event3Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

            // �������� ����, ����, 4H ����
            var workingDayYN = DPInputMain.workingDayYN.value; 
            if (workingDayYN == '����') workingDayYN = 'Y'; 
            else if (workingDayYN == '4H') workingDayYN = '4H'; 
            else workingDayYN = 'N';

            // �ÿ��� �������� ȭ�� ǥ�����ڿ� �����ϰ�, �ÿ��� ������ == �������̸� ������� �׸� ȭ�鿡 �߰��Ѵ� 
            //      - ����ð��� �ÿ��� ���ؽü� �̳��̸� '�ÿ���'���� �ü� ����, ���ؽü��� ������ ����ð��� ����ڵ� ����
            if (fromDate == toDate) {
                var index;
                for (var i = 0; i < timeKeys.length; i++) {
                    if (timeKeys[i] == toTime) {
                        index = i; 
                        break;
                    }
                }

                if ((workingDayYN == "Y" && index > 26) || (workingDayYN == "N" && index > 18) || (workingDayYN == "4H" && index > 16)) {
                    DPInputMain.all("time" + toTime).style.display = ''; 
                    DPInputMain.all('pjt' + toTime).value = "S000"; DPInputMain.all('pjtSel' + toTime).selectedIndex = 1;
                    DPInputMain.all('drwNo' + toTime).value = "*****"; DPInputMain.all('drwNoSel' + toTime).selectedIndex = 0;
                    DPInputMain.all('op' + toTime).value = "D1Z"; // 90 : ���
                    DPInputMain.all('workContent' + toTime).value = "���"; DPInputMain.all('workContentSel' + toTime).value = "���";
                }
            }

            // �Է� �������� üũ
            if (checkInputs() == false) return;

            // ���忩�� Ȯ��
            var msg = "[" + fromDate + "] " + fromTimeStr + " ~ [" + toDate + "] " + toTimeStr + "\n\n�ÿ����� ���� & Ȯ���Ͻðڽ��ϱ�?";        
            if (!confirm(msg)) return;

            saveDPInputsProc("Y", false);

            if (DPInputMain.ajaxCallingSuccessYN.value == "N") {
                alert("���� ����!");
                return;
            }
        }
        // �ÿ��� �������ڰ� ȭ�� ǥ�����ڿ� �������� ������ �ش��� �ü��� ������ Clear �� �ÿ��� �ü��� ����
        else 
        {
            // �ÿ��� �������ڰ� ȭ�� ǥ�����ڿ� �������� ������ ���۽ð��� 08:00�� ����
            if (fromTime != "0800") {
                var msg = "�ÿ��� �������ڰ� ȭ�鿡 ǥ�õ� ���� ���ڿ� �ٸ� ��쿡��\n\n" + 
                          "�ÿ��� ���۽ð��� 08:00�� �����Ͻñ� �ٶ��ϴ�.";
                alert(msg);
                return;
            }

            // DB Insert
            var xmlHttp;
            if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
            xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=SaveSeaTrialDPInputs&designerID=" + DPInputMain.designerID.value + 
                                "&dateStr=" + fromDate + "&loginID=" + DPInputMain.loginID.value + "&projectNo=" + projectNo, false);
            xmlHttp.send(null);
            if (xmlHttp.status == 200) {
                var resultMsg = xmlHttp.responseText;                    
                if (resultMsg != null) {
                    resultMsg = resultMsg.trim();                        
                    if (resultMsg == "ERROR") {
                        alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                        DPInputMain.ajaxCallingSuccessYN.value = "N";
                    }
                    else ; //alert("���������� ����Ǿ����ϴ�!");
                }
                else {
                    alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                    DPInputMain.ajaxCallingSuccessYN.value = "N";
                }
            }
            else {
                alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                DPInputMain.ajaxCallingSuccessYN.value = "N";
            }
            // End of DB Insert

            if (DPInputMain.ajaxCallingSuccessYN.value == "N") return;
        }

        // �ÿ��� ������ <> ������: �����ϰ� ������ ������ ���ڵ� - �ÿ��� ���ؽü��� '�ÿ��� �ڵ�'�� ó��
        if (fromDate != toDate) {
            var dateString = fromDate;

            while (true) {
                var strs = dateString.split("-");
                var dateObject = new Date(strs[0], eval(strs[1] + "-1"), eval(strs[2] + " +1"));

                var y = dateObject.getFullYear().toString();
                var m = (dateObject.getMonth() + 1).toString();
                if (m.length == 1) m = 0 + m;
                var d = dateObject.getDate().toString();
                if (d.length == 1) d = 0 + d;
                
                var nextDate = y + "-" + m + "-" + d;
                if (nextDate == toDate) break;

                // DB Insert
                var xmlHttp;
                if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
                xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=SaveSeaTrialDPInputs&designerID=" + DPInputMain.designerID.value + 
                                    "&dateStr=" + nextDate + "&loginID=" + DPInputMain.loginID.value + "&projectNo=" + projectNo, false);
                xmlHttp.send(null);
                if (xmlHttp.status == 200) {
                    var resultMsg = xmlHttp.responseText;                    
                    if (resultMsg != null) {
                        resultMsg = resultMsg.trim();                        
                        if (resultMsg == "ERROR") {
                            alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                            DPInputMain.ajaxCallingSuccessYN.value = "N";
                        }
                        else ; //alert("���������� ����Ǿ����ϴ�!");
                    }
                    else {
                        alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                        DPInputMain.ajaxCallingSuccessYN.value = "N";
                    }
                }
                else {
                    alert(nextDate + " ���� ������ ���뿡 �����߽��ϴ�!");
                    DPInputMain.ajaxCallingSuccessYN.value = "N";
                }
                // End of DB Insert

                if (DPInputMain.ajaxCallingSuccessYN.value == "N") break;
                dateString = nextDate;
            }
        }
        if (DPInputMain.ajaxCallingSuccessYN.value == "N") return;

        // �ÿ��� ������ <> ������: ������ 
        //      - ����: ����ð��� 18:00 �����̸� '�ÿ��� �� �������'(9H)���� ó��
        //      - ����: ����ð��� 18:00 ���̸� �ÿ��� + ������� ó��(�ش� �ð�����)
        //      - 4H: ����ð��� 12:00 �����̸� '�ÿ��� �� �������'(4H)���� ó��
        //      - 4H: ����ð��� 12:00 ���̸� �ÿ��� + ������� ó��(�ش� �ð�����)
        //      - ����: �ÿ��� + ������� ó��(����ð����� Ư�� ó��)
        if (fromDate != toDate) {
            workingDayYN = getWorkingDayYN(toDate); // �ش���(������)�� ����,����,4H ���� ����

            var timeIndex;
            for (var i = 0; i < timeKeys.length; i++) { 
                if (timeKeys[i] == toTime) { timeIndex = i;  break; }
            }

            var finishEarlyYN = true;
            if (workingDayYN == "Y" && timeIndex > 20) finishEarlyYN = false; // ���� 18:00 �Ĵ� Overtime (�ÿ��� �� ������� ��� X)
            else if (workingDayYN == "4H" && timeIndex > 8) finishEarlyYN = false; // 4H 12:00 �Ĵ� Overtime (�ÿ��� �� ������� ��� X)
            else if (workingDayYN == "N") finishEarlyYN = false; // ������ ��� ��쿡 �ÿ��� �� ������� ��� X


            // 08:00 �ð��� �ÿ��� �ڵ� ����
            var params = "";
            params = "designerID=" + DPInputMain.designerID.value + "&dateStr=" + toDate + "&loginID=" + DPInputMain.loginID.value;

            params += "&timeKey0800=0800&pjt0800=" + projectNo + "&drwType0800=&drwNo0800=*****&op0800=B53&depart0800=&basis0800=&workContent0800=�ÿ���";
            params += "&event10800=&event20800=&event30800=";

            var worktimeTotal = 0;
            for (var i = 1; i <= timeIndex; i++) {
                if (timeKeys[i] == "1230" || timeKeys[i] == "1300") continue; 
                worktimeTotal += 0.5;
            }


            // �ÿ��� �� ������ٿ� �ش��� �ƴϸ� ����ð��� ��� �ڵ� ����
            if (!finishEarlyYN) 
            {
                if (workingDayYN == "N" && timeIndex == 0) {  } // �����̰� 08:00�� ����Ǿ����� Skip
                else 
                {
                    var normalTime = 0;
                    var overtime = 0;
                    var specialTime = 0;

                    if (workingDayYN == "Y") {
                        normalTime = 9;
                        overtime = worktimeTotal - 9;
                    }
                    else if (workingDayYN == "4H") {
                        normalTime = 4;
                        overtime = worktimeTotal - 4;
                    }
                    else specialTime = worktimeTotal;

                    params += "&normalTime0800=" + normalTime + "&overtime0800=" + overtime + "&specialTime0800=" + specialTime;
                    
                    params += "&timeKey" + toTime + "=" + toTime + "&pjt" + toTime + "=S000&drwType" + toTime + "=&drwNo" + toTime + "=*****";
                    params += "&op" + toTime + "=D1Z&depart" + toTime + "=&basis" + toTime + "=&workContent" + toTime + "=���";
                    params += "&event1" + toTime + "=&event2" + toTime + "=&event3" + toTime + "=";
                    params += "&normalTime" + toTime + "=0&overtime" + toTime + "=0&specialTime" + toTime + "=0";
                    params += "&inputDoneYN=Y";

                    var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
                    if (resultMsg == "N") {
                        alert(toDate + " ������ ���뿡 �����߽��ϴ�!");
                        return;
                    }
                }
            }
            // �ÿ��� �� ����������� ����
            else {
                var normalTime = 0;

                if (timeIndex != 0) {
                    if (workingDayYN == "Y") normalTime = worktimeTotal;
                    else if (workingDayYN == "4H") normalTime = worktimeTotal;

                    params += "&normalTime0800=" + normalTime + "&overtime0800=0&specialTime0800=0";

                    if (workingDayYN == "Y") normalTime = 9 - worktimeTotal;
                    else if (workingDayYN == "4H") normalTime = 4 - worktimeTotal;

                    params += "&timeKey" + toTime + "=" + toTime + "&pjt" + toTime + "=S000&drwType" + toTime + "=&drwNo" + toTime + "=*****";
                    params += "&op" + toTime + "=D15&depart" + toTime + "=&basis" + toTime + "=&workContent" + toTime + "=�ÿ��� �� �������";
                    params += "&event1" + toTime + "=&event2" + toTime + "=&event3" + toTime + "=";
                    params += "&normalTime" + toTime + "=" + normalTime + "&overtime" + toTime + "=0&specialTime" + toTime + "=0";
                    params += "&inputDoneYN=Y";
                }
                else {
                    if (workingDayYN == "Y") normalTime = 9;
                    else if (workingDayYN == "4H") normalTime = 4;

                    params = "";
                    params = "designerID=" + DPInputMain.designerID.value + "&dateStr=" + toDate + "&loginID=" + DPInputMain.loginID.value;
                    params += "&timeKey0800=0800&pjt0800=S000&drwType0800=&drwNo0800=*****&op0800=D15&depart0800=&basis0800=&workContent0800=�ÿ��� �� �������";
                    params += "&event10800=&event20800=&event30800=";
                    params += "&normalTime0800=" + normalTime + "&overtime0800=0&specialTime0800=0";
                    params += "&inputDoneYN=Y";
                }

                var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
                if (resultMsg == "N") {
                    alert(toDate + " ������ ���뿡 �����߽��ϴ�!");
                    return;
                }
            }
        }

        if (DPInputMain.ajaxCallingSuccessYN.value == "N") {
            alert("���� ����!");
            return;
        }
        else alert("���� �Ϸ�");
    }

    // �ÿ��� �� �������(����)
    function finishWorkEarlyAfterSeaTrial()
    {
        // Ȯ���� �ü��� ���� �Ұ�, �ÿ��� �� ��������� ���Ͽ��� ���� ���� => TimeSelect â���� � üũ��

        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '����' && i >= 20) {
                    alert("18:00 ���Ŀ��� '�ÿ��� �� �������' �ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i >= 8) {
                    alert("12:00 ���Ŀ��� '�ÿ��� �� �������' �ڵ带 �Է��� �� �����ϴ�.\n\n�Է� �ð��� Ȯ���Ͽ� �ֽʽÿ�.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D15") inputExist = true;
                if (inputExist) {
                    alert("������ �ð��� ���� ������ �� '�ÿ��� �� �������'�� �����Ͻʽÿ�.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D15"; // 95 : �ÿ��� �� �������
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "�ÿ��� �� �������"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "�ÿ��� �� �������";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

                    if (checkInputs() == false) return;

                    // ���忩�� Ȯ�� & ����
                    var msg = DPInputMain.dateSelected.value + "\n\n�ü��� ���� & Ȯ���Ͻðڽ��ϱ�?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // ���Ͻü� COPY
    function copyYesterdayMH()
    {
        // Ȯ���� �ü��� ���� �Ұ�, '���Ͻü� COPY'�� ���Ͽ��� ���� ���� => TimeSelect â���� � üũ��

        toggleActiveElementDisplay();

        // �� �Էµ� ������ �ִ��� üũ
        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') 
            {
                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "") inputExist = true; // �ٸ� ��� �Է��׸��� '�����ȣ' ���� �Ŀ��� �Է°����ϹǷ� 
                                                                                         // '�����ȣ' �Է� �� ���翩�θ� üũ�ϸ� �ȴ�
                if (inputExist) {
                    var msg = "�ü��Է� ������ �ֽ��ϴ�.\n\n�Է»����� �����ϰ� '���Ͻü� COPY'�� �����Ͻðڽ��ϱ�?";
                    if (confirm(msg) == false) return;
                    
                    break;
                }
            }
        }

        // ���Ͻü� �����͸� ������ �´�
        var strs = DPInputMain.dateSelected.value.split("-");
        var selectedDate = new Date(strs[0], strs[1] - 1, strs[2] - 1);
        var yesterdayDate = selectedDate.getFullYear() + "-" + (selectedDate.getMonth() + 1) + "-" + selectedDate.getDate();

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetWorkingDayDesignMHInputs" + 
                            "&designerID=" + DPInputMain.designerID.value + "&dateSelected=" + yesterdayDate, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else if (resultMsg != 'Y') alert("������ �����̾ '���Ͻü� COPY'�� ������ �� �����ϴ�.\n\n��¥�� Ȯ���Ͽ� �ֽʽÿ�.");
                    else {
                        // �����׸��� ��� �ʱ�ȭ
                        for (var i = timeKeys.length - 1; i >= 0; i--) 
                        {
                            var ctrlId = "time" + timeKeys[i];
                            var editWinStyle = DPInputMain.all(ctrlId).style;
                            if (editWinStyle.display != 'none') {
                                editWinStyle.display = 'none';
                                DPInputMain.all('pjt' + timeKeys[i]).value = ""; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 0; 
                                projectSelChanged('pjt', timeKeys[i]);
                                DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('drwNo' + timeKeys[i]).value = ""; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('op' + timeKeys[i]).value = "";
                                DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                                DPInputMain.all('workContent' + timeKeys[i]).value = ""; DPInputMain.all('workContentSel' + timeKeys[i]).value = "";
                                DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                                DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  
                            }
                        }

                        // ���Ͻü� �Է»����� ȭ�鿡 ����
                        var strs = resultMsg.split("��");
                        for (var i = 0; i < strs.length; i++) 
                        {
                            if (strs[i] == "") continue;

                            var strs2 = strs[i].split("��");
                            
                            var startTimeData = strs2[0];
                            var projectNoData = strs2[1];
                            var dwgTypeData = strs2[2];
                            var dwgCodeData = strs2[3];
                            var opCodeData = strs2[4];
                            var causeDepartData = strs2[5];
                            var basisData = strs2[6];
                            var workDescData = strs2[7];
                            var event1Data = strs2[8];
                            var event2Data = strs2[9];
                            var event3Data = strs2[10];

                            var strs3 = startTimeData.split(":");
                            var timeKey = strs3[0] + strs3[1];

                            DPInputMain.all("time" + timeKey).style.display = '';
                            
                            DPInputMain.all('pjt' + timeKey).value = projectNoData;
                            var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
                            for (var j = 0; j < pjtSelObj.options.length; j++) {
                                if (projectNoData == pjtSelObj.options[j].value) {
                                    pjtSelObj.selectedIndex = j;
                                    break;
                                }
                            }
                            DPInputMain.all('drwType' + timeKey).value = dwgTypeData;
                            DPInputMain.all('drwNo' + timeKey).value = dwgCodeData;
                            DPInputMain.all('op' + timeKey).value = opCodeData;
                            DPInputMain.all('depart' + timeKey).value = causeDepartData;
                            if (basisData != "") {
                                DPInputMain.all('basis' + timeKey).value = "��"; 
                                DPInputMain.all('basisSel' + timeKey).value = basisData; 
                            }
                            DPInputMain.all('workContent' + timeKey).value = workDescData;
                            DPInputMain.all('workContentSel' + timeKey).value = workDescData;
                            if (event1Data != "") {
                                DPInputMain.all('event1' + timeKey).value = event1Data;
                                var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
                                for (var j = 0; j < event1SelObj.options.length; j++) {
                                    if (event1Data == event1SelObj.options[j].value) {
                                        event1SelObj.selectedIndex = j;
                                        break;
                                    }
                                }
                            }
                            if (event2Data != "") {
                                DPInputMain.all('event2' + timeKey).value = event2Data;
                                var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
                                for (var j = 0; j < event2SelObj.options.length; j++) {
                                    if (event2Data == event2SelObj.options[j].value) {
                                        event2SelObj.selectedIndex = j;
                                        break;
                                    }
                                }
                            }
                            if (event3Data != "") {
                                DPInputMain.all('event3' + timeKey).value = event3Data;
                                var event3SelObj = DPInputMain.all('event3Sel' + timeKey);
                                for (var j = 0; j < event3SelObj.options.length; j++) {
                                    if (event3Data == event3SelObj.options[j].value) {
                                        event3SelObj.selectedIndex = j;
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                else {alert("ERROR"); }
            }
            else {alert("ERROR"); }
        }
        else {alert("ERROR");}
    }

    // ���õ� ��¥�� �Է½ü��� ��ü����
    function deleteDPInputs()
    {
        toggleActiveElementDisplay();

        var msg = DPInputMain.dateSelected.value + "\n\n�Է½ü��� �ϰ� �����Ͻðڽ��ϱ�?";        
        if (confirm(msg)) {
            // ����Ϸ� ���� üũ
            if (DPInputMain.MHConfirmYN.value == "Y") {
                alert("���簡 �Ϸ�� �����Դϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
                return;
            }

            // �������ڰ� �ü��Է� LOCK ���ڸ� ����Ͽ����� üũ
            var dateStr = DPInputMain.dateSelected.value;
            var dateStrs = dateStr.split("-");
            var selectedDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2]);
            var dpInputLockDateStr = callDPCommonAjaxProc("GetDPInputLockDate", "empNo", DPInputMain.designerID.value);
            if (dpInputLockDateStr == "ERROR") {
                alert("ERROR!");
                return;
            }
            else {
                var strs = dpInputLockDateStr.split("-");
                var dpInputLockDate = new Date(strs[0], strs[1] - 1, strs[2]);
				
				<%if(!isAdmin){%>
                if ((selectedDate - dpInputLockDate < 0)) {
                    //alert("�Է� ��ȿ����(�⺻: �ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n���� �����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
                    
                    var alertMsg = "�Է� ��ȿ����(����: ���� - 1 Working day)�� ����Ǿ����ϴ�.\n\n";
                    alertMsg += "�ü� �Է� ���� ���� ��û�� (EP ���ڰ��� - ����� - ����ι� - �ü��Է�����������û��)\n\n";
                    alertMsg += "���縦 ���� �� �����ڿ��� Lock ������ ��û�Ͻʽÿ�.";
                    alert(alertMsg);
                   
                    return;
                }
                <%}%>
            }

            // ������ ���� ó��
            var xmlHttp;
            if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

            xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=DeleteDPInputs&designerID=" + DPInputMain.designerID.value + 
                                "&dateStr=" + DPInputMain.dateSelected.value, false);
            xmlHttp.send(null);

            if (xmlHttp.status == 200) {
                if (xmlHttp.statusText == "OK") {
                    var resultMsg = xmlHttp.responseText;
                    
                    if (resultMsg != null)
                    {
                        resultMsg = resultMsg.trim();
                        if (resultMsg == 'ERROR') alert(resultMsg);
                        else {
                            // �����׸��� ��� �ʱ�ȭ
                            for (var i = timeKeys.length - 1; i >= 0; i--) 
                            {
                                var ctrlId = "time" + timeKeys[i];
                                var editWinStyle = DPInputMain.all(ctrlId).style;
                                if (editWinStyle.display != 'none') {
                                    if (i != 0) editWinStyle.display = 'none';
                                    DPInputMain.all('pjt' + timeKeys[i]).value = ""; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 0; 
                                    projectSelChanged('pjt', timeKeys[i]);
                                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('drwNo' + timeKeys[i]).value = ""; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('op' + timeKeys[i]).value = "";
                                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                                    DPInputMain.all('workContent' + timeKeys[i]).value = ""; DPInputMain.all('workContentSel' + timeKeys[i]).value = "";
                                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0; 
                                }
                            }
                            DPInputMain.dataChanged.value = "false";
                            alert("�����Ϸ�");
                        }
                    }
                    else alert("ERROR");
                }
                else alert("ERROR");
            }
            else alert("ERROR");
        }
    }

    // Header���� ȣ������ ���� �� Main �׸�鿡�� ��� �ݿ�
    function changedSelectedProject(selectedProjects)
    {
        toggleActiveElementDisplay();

        var selectedProjectsList = selectedProjects.split("|");

        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "pjtSel" + timeKeys[i];
            var pjtSelObj = DPInputMain.all(ctrlId);
            var currentSelectedValue = DPInputMain.all("pjt" + timeKeys[i]).value;
            
            // ���� ������ ȣ������� ��� ����
            for (var j = pjtSelObj.options.length - 1; j >= 2; j--)  pjtSelObj.options[j] = null; // 0 ��°�� '', 1 ��°�� 'S000' �̹Ƿ� 2 ��° ���� ó��

            var isExist = false;

            // ����� ȣ��������� �ٽ� ä���
            for (var j = 0; j < selectedProjectsList.length; j++) {
                var projectNoStr = selectedProjectsList[j];
                pjtSelObj.options[j + 2] = new Option(projectNoStr, projectNoStr);
                
                // selected ����
                if (currentSelectedValue == projectNoStr) {
                    pjtSelObj.selectedIndex = j + 2;
                    isExist = true;
                }
            }

            // ���õ� ȣ���� ������ ȣ���̸� �� �׸� ���ؼ��� �ش� ȣ���� �߰�
            if (!isExist && currentSelectedValue != "" && currentSelectedValue != "S000") {
                pjtSelObj.options[pjtSelObj.options.length] = new Option(currentSelectedValue, currentSelectedValue);
                pjtSelObj.selectedIndex = pjtSelObj.options.length - 1;
            }
        }
    }

    // Bottom �� DP ���� ���� ������Ʈ
    function updateDrawingInfo(timeKey)
    {
        if (timeKey == '') parent.DP_BOTTOM.updateDrawingInfo('', '');
        else parent.DP_BOTTOM.updateDrawingInfo(DPInputMain.all('pjt' + timeKey).value, DPInputMain.all('drwNo' + timeKey).value);
    }

    // ����Ʈ(����Ʈ ���)
    function printPage()
    {
    	// TEST�� STXDPDEV/WebReport.jsp�� �������ҵ�. 141219 KSJ
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput.mrd&param=" + "<%=designerID%>:::" + "<%=dateSelected%>" ;
        //var urlStr = "http://172.16.2.13:7777/j2ee/STXDPDEV/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDPDPDEV/mrd/stxPECDPInput.mrd&param=" + "<%=designerID%>:::" + "<%=dateSelected%>" ;
        window.open(urlStr, "", "");
    }

    // TR MouseOver �� Color-Highlight
    function trOnMouseOver(trObject, timeKey)
    {
        trObject.style.backgroundColor = '#ffffa0';
        DPInputMain.all('pjt' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('drwType' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('drwNo' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('op' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('depart' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('basis' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('workContent' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('event1' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('event2' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('event3' + timeKey).style.backgroundColor = '#ffffa0';
        DPInputMain.all('shipType' + timeKey).style.backgroundColor = '#ffffa0';
    }

    // TR MouseOut �� Color-Highlight ����
    function trOnMouseOut(trObject, timeKey)
    {
        trObject.style.backgroundColor = '#ffffff';
        DPInputMain.all('pjt' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('drwType' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('drwNo' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('op' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('depart' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('basis' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('workContent' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('event1' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('event2' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('event3' + timeKey).style.backgroundColor = '#ffffff';
        DPInputMain.all('shipType' + timeKey).style.backgroundColor = '#ffffff';
    }
    
    
    // ȣ�� ���� ����
    function showProjectMultiSelect(timeKey) 
    {
     	var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
     	var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (parent.DP_HEADER.DPInputHeader.dpDesignerIDSel.value == "") {
            alert("�����ڸ� ���� �����Ͻʽÿ�.");
            return;
        }
	   // var sProperties = 'dialogHeight:340px;dialogWidth:400px';
        var sProperties = 'dialogHeight:400px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "designerID=" + ((parent.DP_HEADER.DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
        var selectedProjects = window.showModalDialog("stxPECDPInputNew_ProjectMultiSelect.jsp?" + paramStr, "", sProperties);
       // var selectedProjects = window.open("stxPECDPInputNew_ProjectMultiSelect.jsp?" + paramStr, "", sProperties);

        if (selectedProjects != null && selectedProjects != 'undefined')
        {
        	 pjtSelObj.add(new Option(selectedProjects,selectedProjects));
        	 pjtObj.value = selectedProjects;        	

        	 for(var i=0; i < pjtSelObj.length; i++)
        	 {
        	 	if(pjtSelObj.options[i].value == selectedProjects)
        	 	{        	 		
        	 		pjtSelObj.options[i].selected = true;
        	 		projectSelChangedAction('pjt', timeKey);
        	 		break;
        	 	}
        	 }
        }       

    } 
    
    
    // '����' ���� �� �Է� ��Ʈ�� ǥ��
    function showShipTypeSel(elemPrefix, timeKey)
    {
        var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (pjtObj.value == '') return; // ȣ���� ���� ������ �Է� ��Ʈ�� ǥ������ �ʴ´�

        showElementSel(elemPrefix, timeKey);
    }
    
    
    // ���� ����Ʈ ������ DB���� �����ؿ��� '����' LOV�� ä��� ����-���ν���
    function shipTypeQueryProc(shipTypeSelObj, selectedValue)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetShipType", false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("|");
                        shipTypeSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var newOption = new Option(strs[i], strs[i]);
                            shipTypeSelObj.options[i + 1] = newOption;
                            if (selectedValue != "" && selectedValue == strs[i]) shipTypeSelObj.selectedIndex = i + 1;  
                        }
                    }
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


</script>


</html>
