<%--  
§DESCRIPTION: 설계시수입력 화면 메인 부분
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPInputNewMain.jsp
§CHANGING HISTORY: 
§    2014-12-03: Initiative
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
    String invalidSelectedProjects = ""; // 해당 사번에 대해 선택된 작업호선 항목들 중에 호선명 변경 등으로 비-유효해진 항목들 목록

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
            // 시수조회 & 입력의 대상 설계자는 Login User를 초기값으로 한다
            // 일반 사용자인 경우 설계자와 Login User가 동일. Admin.인 경우 대상 설계자를 변경 가능함

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
                <%=dateSelected%>&nbsp;<%=deptName%>&nbsp;<%=designerName%>&nbsp;(결재: <%=MHConfirmYN%>)
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
                    작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                    ※에러 메시지: <%=errStr%>                
                    </b>
                </td>
            </tr>
        </table>
    <%
    }
    else if (!invalidSelectedProjects.equals("")) // 비-유효해진 호선명이 있는 경우 Warning 출력
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="4" border="0">
            <tr>
                <td class="td_standard" style="text-align:left;color:#ff0000;">
                    <b>
                    유효하지 않은 호선이름이 있습니다.<br><br>
                    호선추가 창을 실행하여 수정한 후 작업(조회)하시기 바랍니다!<br><br>
                    ※유효하지 않은 호선이름: <%=invalidSelectedProjects%>                
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
                <td width="55" class="td_standardBold">시각</td>
                <td width="150" class="td_standardBold">공사번호*</td>
                <td width="50" class="td_standardBold">OP*</td>   
                <td width="35" class="td_standardBold">구분</td>
                <td width="100" class="td_standardBold">도면번호*</td> 
                <td width="100" class="td_standardBold">원인부서</td>
                <td width="40" class="td_standardBold">근거</td>
                <td width="265" class="td_standardBold">업무내용</td>
                <td width="90" class="td_standardBold">Event1*</td>
                <td width="90" class="td_standardBold">Event2</td>
                <td width="90" class="td_standardBold">Event3</td>
                <td width="50" class="td_standardBold">선종</td>
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
                        basisData = replaceAmpAll((String)mhInputMap.get("BASIS"), "'", "＇");
                        workDescData = replaceAmpAll((String)mhInputMap.get("WORK_DESC"), "'", "＇");
                        event1Data = (String)mhInputMap.get("EVENT1");
                        event2Data = (String)mhInputMap.get("EVENT2");
                        event3Data = (String)mhInputMap.get("EVENT3");
						shipTypeData = (String)mhInputMap.get("SHIP_TYPE");

                        if (!projectNoData.equals("S000") && !projectNoData.equals("PS0000") && !projectNoData.equals("V0000") && !dwgCodeData.equals("*****") 
                            && !dwgCodeData.equals("#####") && !opCodeData.equals("B53") && !opCodeData.equals("D15") && event1Data.equals("")) 
                        {
                            event1Data = "(선택안함)";
                        }
                    }
                }

                %>
                    <tr id="time<%=timeKey%>" height="20" bgcolor="#ffffff" <%if (i != 0 && sTimeData.equals("")) {%>style="display:none;"<%}%> OnMouseOver="trOnMouseOver(this, '<%=timeKey%>');" OnMouseOut="trOnMouseOut(this, '<%=timeKey%>');"  onclick="updateDrawingInfo('<%=timeKey%>');">
                        <td width="4" class="td_standard" bgcolor="#eeeeee"></td>
                        <!-- 시각 -->
                        <td class="td_standard"><font color="blue"><%=timeStr%></font></td>
                        <!-- 공사번호(호선) -->
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
                            <input type="button" name="ProjectsButton" value="다중호선" style="height:18px;width:50px;font-size:8pt;" onclick="showProjectMultiSelect('<%=timeKey%>');"/>
                        </td>   
                        <!-- OP CODE -->
                        <td class="td_standard">
                            <input name="op<%=timeKey%>" value="<%=opCodeData%>" class="input_noBorder" style="width:25px;" readonly onClick="showOpBtn('<%=timeKey%>');" />
                            <input type="button" name="opSel<%=timeKey%>" value="…" style="height:18px;width:18px;display:none;background-color:#fff0f5;" onclick="showOpSelectWin('<%=timeKey%>');" />
                        </td>                                              
                        <!-- 도면 구분 -->
                        <td class="td_standard">
                            <input name="drwType<%=timeKey%>" value="<%=dwgTypeData%>" class="input_noBorder" style="width:35px;text-align:center;" readonly onClick="showDrwTypeSel('drwType', '<%=timeKey%>');" />
                            <select name="drwTypeSel<%=timeKey%>" class="input_small" style="width:35px;display:none;background-color:#fff0f5;" onChange="drwTypeSelChanged('drwType', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                            </select>
                        </td>
                        <!-- 도면번호 -->
                        <td class="td_standard">
                            <input name="drwNo<%=timeKey%>" value="<%=dwgCodeData%>" class="input_noBorder" style="width:100px;text-align:center;" readonly onClick="showDrwNoSel('drwNo', '<%=timeKey%>');" />
                            <select name="drwNoSel<%=timeKey%>" class="input_small" style="width:400px;display:none;background-color:#fff0f5;" onChange="drwNoSelChanged('drwNo', '<%=timeKey%>');">
                                <option value="" text="">&nbsp;</option>
                            </select>
                        </td>                       
                        <!-- 원인부서 -->
                        <td class="td_standard">
                            <input name="depart<%=timeKey%>" value="<%=causeDepartData%>" class="input_noBorder" style="width:100px;text-align:center;" readonly onClick="showDepartSel('depart', '<%=timeKey%>');" />
                            <select name="departSel<%=timeKey%>" class="input_small" style="width:200px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('depart', '<%=timeKey%>');">
                            </select>
                        </td>
                        <!-- 근거 -->
                        <td class="td_standard">
                            <input name="basis<%=timeKey%>" value="<%if(!basisData.equals("")){%>√<%}%>" class="input_noBorder" style="width:40px;text-align:center;" readonly onClick="showBasisSel('basis', '<%=timeKey%>');" />
                            <input name="basisSel<%=timeKey%>" value='<%=basisData%>' class="input_small" style="width:150px;height:18px;display:none;background-color:#fff0f5;" onChange="basisSelChanged('depart', '<%=timeKey%>');" onkeydown="inputCtrlKeydownHandler();" />
                        </td>
                        <!-- 업무내용 -->
                        <td class="td_standard">
                            <input name="workContent<%=timeKey%>" value='<%=workDescData%>' class="input_noBorder" style="width:265px;" readonly onClick="showWorkContentSel('workContent', '<%=timeKey%>');" />
                            <input name="workContentSel<%=timeKey%>" value='<%=workDescData%>' class="input_small" style="width:265px;height:18px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('workContent', '<%=timeKey%>');" onkeydown="inputCtrlKeydownHandler();" />
                        </td>
                        <!-- EVENT1 -->
                        <td class="td_standard">
                            <input name="event1<%=timeKey%>" value="<%=event1Data%>" class="input_noBorder" style="width:90px;text-align:center;" readonly onClick="showEventSel('event1', '<%=timeKey%>');" />
                            <select name="event1Sel<%=timeKey%>" class="input_small" style="width:90px;display:none;background-color:#fff0f5;" onChange="elementSelChanged('event1', '<%=timeKey%>');">
                                <option value="">&nbsp;</option>
                                <option value="(선택안함)" <%if (event1Data.equals("(선택안함)")){%>selected<%}%>>(선택안함)</option>
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
                        <!-- 선종 -->
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
		
		    // 조회 완료 메시지 
	    <% if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
	        alert("조회 완료");
	    <% } %>
		
	});
	
    var activeElement = null;
    var activeElementPair = null; 
    var isNewShow = false;
    var selectedProjectListStr = "<%=selectedProjectListStr%>";
    document.onclick = mouseClickHandler;

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;




    // 'OP' 필드 선택 시 입력 컨트롤(버튼) 표시
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

    // OP CODE 선택 창을 showModalDialog로 Popup 시키고, 선택결과를 OP 입력 칸에 반영한다
    function showOpSelectWin(timeKey) 
    {
        var projectNo = DPInputMain.all('pjt' + timeKey).value;
        var sProperties = 'dialogHeight:440px;dialogWidth:740px;scroll=no;center:yes;resizable=no;status=no;';       

        var opCode = window.showModalDialog("stxPECDPInputNew_OpSelect.jsp?projectNo=" + projectNo, "", sProperties);

        if (opCode != null && opCode != 'undefined') 
        {
            // 출도된 도면이면 OP CODE 선택에 제한을 둔다
            var drawingNo = DPInputMain.all('drwNo' + timeKey).value;
            if (projectNo != '' && projectNo != 'S000' && projectNo != 'PS0000' && drawingNo != '' && drawingNo != '*****' && drawingNo != '#####') 
            {
                var workingStartDate = getDrawingWorkStartDate(projectNo, drawingNo);
                if (workingStartDate != "" && workingStartDate != "ERROR") 
                {
                    // 개정에 해당하지 않는 도면작업(OP CODE 21 ~ 24)은 선택 불가
                    if (opCode == "21" || opCode == "22" || opCode == "23" || opCode == "24") 
                    {
                        var dateStr1 = DPInputMain.dateSelected.value;
                        var dateStrs1 = dateStr1.split("-");
                        var date1 = new Date(dateStrs1[0], dateStrs1[1] - 1, dateStrs1[2]); // 시수입력일
                        
                        var dateStrs2 = workingStartDate.split("-");
                        var date2 = new Date(dateStrs2[0], dateStrs2[1] - 1, dateStrs2[2]); // 도면 출도일

                        if (date1 - date2 > 0) {
                            var msg = drawingNo + " 도면은 " + workingStartDate + " 에 이미 출도가 되었습니다.\n\n";
                            msg += "출도날짜 입력 후 도면작업(OP CODE 21 ~ 24)은 모두 개정작업이므로\n\n";
                            msg += "OP CODE 가 5로 시작하는 코드만 입력할 수 있습니다!";
                            alert(msg);
                            return;
                        }
                    }
                }
            }
            
            var prevOpCode = DPInputMain.all('op' + timeKey).value;

            // OP CODE가 변경되면 기존 입력값 초기화
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
		
		        // 도면구분 값 초기화
		        drwTypeObj.value = ''; 
		        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
		        // 도면번호 값 초기화
		        drwNoObj.value = ''; 
		        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
		        // OP 값 초기화
		        opObj.value = ''; 
		        // 원인부서 값 초기화
		        departObj.value = '';
		        for (var i = departSelObj.options.length - 1 ; i >= 0; i--) departSelObj.options[i] = null;
		        // 근거 값 초기화
		        basisObj.value = ''; basisSelObj.value = '';
		        // 업무내용 값 초기화
		        workContentObj.value = ''; workContentSelObj.value = '';
		        // EVENT1, 2, 3 값 초기화
		        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
		        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
		        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;		        
		        // 선종 값 초기화
		        shipTypeObj.value = ''; shipTypeSelObj.options.selectedIndex = 0;        
		
		        // Bottom 의 DP 공정 정보 업데이트
		        updateDrawingInfo('');
		
		        // 수정사항 발생 여부 플래그 설정
		        DPInputMain.dataChanged.value = "true";
		
		        // 공사번호(호선)가 'S000' or 'PS0000' or Multi 공사번호(호선)일때 도면번호를 '*****'로 설정하고, 그 외의 경우에는 해당 호선에 대한 도면구분 목록을 DB에서 쿼리...
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
            
            // OP CODE가 도면시수(A TYPE)이 아니면 도면번호를 '*****'로 설정
	        if(opCode.substring(0, 1) != 'A'){		 
			    var drwNoObj = DPInputMain.all('drwNo' + timeKey);     
			    drwNoObj.value = '*****';
			}            
            

            // OP CODE가 'A2x'가 아닌 경우 '원인부서' 입력 값을 초기화한다
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
            // OP CODE가 '20' & 'A2x'가 아닌 경우 '근거' 입력 값을 초기화한다
            if (opCode.substring(0, 2) != 'A2' && opCode != '20') {
                DPInputMain.all('basis' + timeKey).value = '';
                DPInputMain.all('basisSel' + timeKey).value = '';
            }

            // 수정사항 발생 여부 플래그 설정
            DPInputMain.dataChanged.value = "true";
            
			// OP CODE 선택 후 도면구분 창 활성화
             isNewShow = true;
             showDrwTypeSel("drwType", timeKey);

            // Event1 선택항목 표시
            //isNewShow = true;
            //showEventSel("event1", timeKey);

            // 다음(Next) 입력 항목을 Show
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

    // 시수항목 추가 전에 항목 추가가 가능한 상태인지 체크
    function checkBeforeTimeAdding(timeKey)
    {
        var opCode = DPInputMain.all('op' + timeKeys[0]).value;
        if (opCode == "D17") {
            alert("'월차'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'월차' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        else if (opCode == "D14") {
            alert("'특별휴가'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'특별휴가' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
            return false;
        }
        else if (opCode == "D13") {
            alert("'예비군훈련(9H)'로 지정되어 있어 새 항목을 추가할 수 없습니다.\n\n'예비군훈련(9H)' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
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
                    alert("'퇴근코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'퇴근' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
                    return false;
                }
                else if (opCode == 'D16') {
                    alert("'조퇴코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'조퇴' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
                    return false;
                }
                else if (opCode == 'B53' && pjtNo != 'V0000') {
                    alert("'시운전 코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'시운전' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
                    return false;
                }
                else if (opCode == 'D15') { 
                    alert("'시운전 후 조기퇴근(평일) 코드'가 입력되어 새 항목을 추가할 수 없습니다.\n\n'시운전 후 조기퇴근' 지정을 취소하려면 'OP CODE'를 변경하십시오.");
                    return false;
                }

                break;
            }
        }

        return true;
    }

    // Time Select 창에서 특정 Time(시각) 항목이 선택되면, 해당 항목에 해당하는 Table Row(TR 개체)를 보이거나 숨긴다
    function timeSelected(timeKey)
    {
        // 결재완료된 경우에는 동작 X => 결재완료 여부는 TimeSelect 창에서 先 체크함
        
        toggleActiveElementDisplay();

        if (!checkBeforeTimeAdding(timeKey)) return;

        var ctrlId = "time" + timeKey;
        var editWinStyle = DPInputMain.all(ctrlId).style;
        if (editWinStyle.display == '') {
            editWinStyle.display = 'none';
            // 입력값 초기화 - 퇴근, 조퇴, ... 등이 입력되었다가 Hidden되는 경우 때문에 값 초기화가 필요함
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

    // 필드 선택 시 각 필드의 입력 컨트롤을 표시한다. 입력 컨트롤은 기본적으로 Hidden되어 있다가 해당 필드가 Click될 때만 보여진다.
    function showElementSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다
        
        var elemInput = DPInputMain.all(elemPrefix + timeKey);
        var elemSel = DPInputMain.all(elemPrefix + 'Sel' + timeKey);

        toggleActiveElementDisplay();

        elemInput.style.display = 'none';
        elemSel.style.display = '';


        activeElement = elemSel;
        activeElementPair = elemInput;
    }

    // '도면 구분' 필드 선택 시 입력 컨트롤 표시
    function showDrwTypeSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다

        var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (pjtObj.value == '' || pjtObj.value == 'S000' || pjtObj.value == 'PS0000') return; // 공사번호(호선) 값이 없거나 S000 or PS0000 이면 입력 컨트롤 표시하지 않는다
        if (pjtObj.value.indexOf(",") > -1) return; // Multi 공사번호(호선)이 선택된 경우 입력 컨트롤 표시하지 않는다
        
        var opCode = DPInputMain.all('op' + timeKey).value;

        if (opCode.substring(0, 1) != 'A') return;  // 공사번호(호선)이 1개이고, OP CODE가 'Axx' 일경우만 도면 구분 선택 가능

        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
        var drwTypeSelObj = DPInputMain.all('drwTypeSel' + timeKey);

        if (drwTypeObj.value != "" && drwTypeSelObj.options.length <= 1) {
            drawingTypesForWorkQueryProc(DPInputMain.all('pjtSel' + timeKey), drwTypeSelObj, drwTypeObj.value);
        }

        showElementSel(elemPrefix, timeKey);
    }

    // '도면번호' 필드 선택 시 입력 컨트롤 표시
    function showDrwNoSel(elemPrefix, timeKey)
    {
        // Bottom 의 DP 공정 정보 업데이트
        updateDrawingInfo(timeKey);

        if (DPInputMain.MHConfirmYN.value == 'Y') return; // 결재가 완료된 상태이면 입력관련 컨트롤은 출력하지 않는다

        var drwTypeObj = DPInputMain.all('drwType' + timeKey);
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        var drwNoSelObj = DPInputMain.all('drwNoSel' + timeKey);

        if (drwTypeObj.value == '') {
            var pjtObj = DPInputMain.all('pjt' + timeKey);
            // 공사번호(호선) 값이 없으면 입력 컨트롤 표시하지 않는다
            if (pjtObj.value == '' || pjtObj.value == 'S000' || pjtObj.value == 'PS0000') return; 
            if (pjtObj.value.indexOf(",") > -1) return; // Multi 공사번호(호선)이 선택된 경우 입력 컨트롤 표시하지 않는다
/*****
            // 해양호선의 경우에는 공사번호가 있는 경우(즉 공사시수인 경우) '*****' 를 표시하지 않는다 (Added on 2010-08-24)
            var pjtNoPrefixStr = pjtObj.value.substring(0, 1);
            if (pjtNoPrefixStr == 'H' || pjtNoPrefixStr == 'M' || pjtNoPrefixStr == 'F') {
                //if (pjtObj.value != 'M1101') return; // M1101은 해양호선이 아님 (Added on 2011-04-28)
            }
            
            // 공사번호는 있는데 도면구분이 없는 경우에는 '*****' 를 표시한다
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

    // '원인부서' 필드 선택 시 입력 컨트롤 표시
    function showDepartSel(elemPrefix, timeKey)
    {
        if (DPInputMain.MHConfirmYN.value == 'Y') return; 

        var opObj = DPInputMain.all('op' + timeKey);
        if (opObj.value.substring(0, 2) == 'A2') { // OP CODE가 도면수정(5A~5R) 인 경우에만 입력컨트롤을 표시한다
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
    

    // '근거' 필드 선택 시 입력 컨트롤 표시
    function showBasisSel(elemPrefix, timeKey)
    {
        var opObj = DPInputMain.all('op' + timeKey);  
        
        if (opObj.value == "20" || opObj.value.substring(0, 2) == 'A2') { // OP CODE가 선주 Extra(20) 또는 도면수정(5A~5R) 인 경우에만 입력컨트롤을 표시한다
        	isNewShow = true; ///////////////////////
            showElementSel(elemPrefix, timeKey);
        }
    }
    
    // '업무내용' 선택 시 입력 컨트롤 표시
    function showWorkContentSel(elemPrefix, timeKey)
    {
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        if (drwNoObj.value == '') return; // 도면번호의 값이 없으면 입력 컨트롤 표시하지 않는다

        showElementSel(elemPrefix, timeKey);
    }

    // Event1, Event2, Event3 선택 시 입력 컨트롤 표시
    function showEventSel(elemPrefix, timeKey)
    {
        var drwNoObj = DPInputMain.all('drwNo' + timeKey);
        if (drwNoObj.value == '' || drwNoObj.value == '*****' || drwNoObj.value == '#####') return; 
        // :도면번호의 값이 없거나 '*****'이면 입력 컨트롤 표시하지 않는다

        var elemName = elemPrefix + "Sel";
        // 초기화(기존 Option 항목들을 삭제)
        for (i = DPInputMain.all(elemName + timeKey).options.length - 1; i >= 1; i--) {
            if (elemName == "event1Sel" && i == 1) break;
            DPInputMain.all(elemName + timeKey).options[i] = null;
        }
        DPInputMain.all(elemName + timeKey).options.selectedIndex = 0;

        var drwTypeValue = DPInputMain.all('drwType' + timeKey).value;
        if (drwTypeValue == "V") {
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V1:P.O.S 발행", "V1");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V2:업체선정", "V2");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V3:구매오더", "V3");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V4:업체도면접수", "V4");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V5:선주승인발송", "V5");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V6:선주승인접수", "V6");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V7:업체출도일", "V7");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("V8:작업용출도일", "V8");
        }
        else {
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y1:착수일", "Y1");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y2:완료일", "Y2");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y3:선주승인발송", "Y3");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y4:선주승인접수", "Y4");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y5:선급승인발송", "Y5");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y6:선급승인접수", "Y6");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y7:참고용발송", "Y7");
            DPInputMain.all(elemName + timeKey).options[DPInputMain.all(elemName + timeKey).options.length] = new Option("Y8:작업용발송", "Y8");
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

    // 입력 컨트롤에서 값 입력(변경) 시 입력 컨트롤은 숨기고 해당 필드에 입력된 값을 표시한다
    function elementSelChanged(elemPrefix, timeKey)
    {
        var elemInput = DPInputMain.all(elemPrefix + timeKey);
        var elemSel = DPInputMain.all(elemPrefix + 'Sel' + timeKey);
        elemInput.value = elemSel.value;

        // 수정사항 발생 여부 플래그 설정
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

        // 도면구분 값 초기화
        drwTypeObj.value = ''; 
        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
        // 도면번호 값 초기화
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
        // OP 값 초기화
        opObj.value = ''; 
        // 원인부서 값 초기화
        departObj.value = '';
        for (var i = departSelObj.options.length - 1 ; i >= 0; i--) departSelObj.options[i] = null;
        // 근거 값 초기화
        basisObj.value = ''; basisSelObj.value = '';
        // 업무내용 값 초기화
        workContentObj.value = ''; workContentSelObj.value = '';
        // EVENT1, 2, 3 값 초기화
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;
		// 선종 값 초기화
		shipTypeObj.value = ''; shipTypeSelObj.options.selectedIndex = 0;

        // Bottom 의 DP 공정 정보 업데이트
        updateDrawingInfo('');

        // 수정사항 발생 여부 플래그 설정
        DPInputMain.dataChanged.value = "true";

        // 공사번호(호선)가 'S000' or 'PS0000' or Multi 공사번호(호선)이면 도면번호를 '*****'로 설정하고, 그 외의 경우에는 해당 호선에 대한 도면구분 목록을 DB에서 쿼리...
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
        
        // 선종 추출 및 LOV 채움
        shipTypeQueryProc(shipTypeSelObj, "");
        
        // 호선 선택 후 Action
        projectSelChangedAfter(timeKey);    
    	   
    }
    

    // 공사번호(호선) 변경 시 다른 입력 항목들을 초기화하고 해당 호선에 대한 '도면구분' 값들을 DB에서 쿼리해 온다
    function projectSelChanged(elemPrefix, timeKey)
    {
	    var pjtSelValue = DPInputMain.all('pjtSel' + timeKey).value;
	    var pjtValue = DPInputMain.all('pjt' + timeKey).value;

		var actionFlag = false;
	    if(pjtSelValue.substring(0, 1)=='Z' || pjtSelValue.indexOf(",Z") > -1)
	    {
	     	 var ConfirmMsg = "인도호선 ("+pjtSelValue+") 에 대한 시수입력 시\n반드시 업무내용란에 사유를 입력하여 주시길 바랍니다.\n\n";
	     	 ConfirmMsg += "인도시점 및 사유 관련 문의사항은\n기술기획팀 한경훈 과장 (T.3220) 으로 문의바랍니다.\n\n진행하시겠습니까?";
	     	 	
	     	 if(confirm(ConfirmMsg))
	     	 {
	     	 	projectSelChangedAction(elemPrefix, timeKey);	     	 	
	     	 } else {
	     	 	// selectbox의 value를 이전 input값으로 변경
	     	 	DPInputMain.all('pjtSel' + timeKey).value = DPInputMain.all('pjt' + timeKey).value;
	     	 }
	    } else {
	    	projectSelChangedAction(elemPrefix, timeKey);
	    }  
   }

    // projectSelChanged() 실행된 후 호선이 'S000' or Multi 공사번호(호선)이면 OP CODE 창을 띄우고, 기타 호선이면 도면타입 선택 컨트롤을 Show 시킨다 
    function projectSelChangedAfter(timeKey)
    {
        toggleActiveElementDisplay();

        var pjtObj = DPInputMain.all('pjt' + timeKey);
        showOpSelectWin(timeKey);
        /* 호선 선택 후 OP CODE 창 띄우도록 변경
        if (pjtObj.value == 'S000' || pjtObj.value.indexOf(",") > -1) showOpSelectWin(timeKey);
        else if (pjtObj.value != "") {
            isNewShow = true;
            showElementSel("drwType", timeKey);
            
        }*/
    }

    // 특정 호선 + 부서에 대한 '도면구분' 값들을 DB에서 쿼리해오고 '도면구분' LOV를 채우는 서브-프로시저
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

    // 도면구분 값 변경 시 다른 관련 입력 항목들을 초기화하고 '도면번호' 항목들을 DB에서 쿼리해 온다
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

        // 도면번호 값 초기화
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
        // 업무내용 값 초기화
        workContentObj.value = ''; workContentSelObj.value = '';
        // EVENT1, 2, 3 값 초기화
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;

        // 수정사항 발생 여부 플래그 설정
        DPInputMain.dataChanged.value = "true";

        // Bottom 의 DP 공정 정보 업데이트
        updateDrawingInfo('');

        // 도면구분 선택 값에 따라 해당 호선 & 부서의 작업 대상 도면 목록을 디비에서 쿼리
        if (drwTypeValue == '') {
            drwNoObj.value = '';
        }
        else {
            drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, "");

            // 도면번호 선택 컨트롤을 Show
            //toggleActiveElementDisplay();
            isNewShow = true;
            showDrwNoSel('drwNo', timeKey);
        }
    }

    // 특정 호선 + 부서 + 도면타입에 대한 '도면번호' 값들을 DB에서 쿼리해오고 '도면번호' LOV를 채우는 서브-프로시저
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
                        var strs = resultMsg.split("∥");
                        drwNoSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split("‥");
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

    // 도면번호 값 선택(변경) 시 선택된 도면의 정보로 '업무내용' 항목의 값을 설정한다
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

        // EVENT1, 2, 3 값 초기화
        var event1Obj = DPInputMain.all('event1' + timeKey);
        var event1SelObj = DPInputMain.all('event1Sel' + timeKey);
        var event2Obj = DPInputMain.all('event2' + timeKey);
        var event2SelObj = DPInputMain.all('event2Sel' + timeKey);
        var event3Obj = DPInputMain.all('event3' + timeKey);
        var event3SelObj = DPInputMain.all('event3Sel' + timeKey);
        event1Obj.value = ''; event1SelObj.options.selectedIndex = 0;
        event2Obj.value = ''; event2SelObj.options.selectedIndex = 0;
        event3Obj.value = ''; event3SelObj.options.selectedIndex = 0;
        
        
        // OP CODE가 'A2x'가 아닌 경우 '원인부서' 입력 값을 초기화한다      
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
        // OP CODE가 '20' & 'A2x'가 아닌 경우 '근거' 입력 값을 초기화한다
        if (opCode.substring(0, 2) != 'A2' && opCode != '20') {
            DPInputMain.all('basis' + timeKey).value = '';
            DPInputMain.all('basisSel' + timeKey).value = '';
        }        

        // 수정사항 발생 여부 플래그 설정
        DPInputMain.dataChanged.value = "true";

        // Bottom 의 DP 공정 정보 업데이트
        var drwNoSelValue = drwNoSelObj.options[drwNoSelObj.selectedIndex].value;
        parent.DP_BOTTOM.updateDrawingInfo(DPInputMain.all('pjt' + timeKey).value, drwNoSelValue);

        // OP CODE를 Show        
        if (drwNoSelValue != "") {
            toggleActiveElementDisplay();
            isNewShow = true;
            showDepartSel("depart", timeKey);
           // showOpSelectWin(timeKey);
        }
        
    }

    // 근거 값 입력(변경) 시 
    function basisSelChanged(elemPrefix, timeKey)
    {
        elementSelChanged(elemPrefix, timeKey);

        var basisSelObj = DPInputMain.all('basisSel' + timeKey);
        var basisObj = DPInputMain.all('basis' + timeKey);
        if (basisSelObj.value.trim() != "") basisObj.value = "√";
        else basisObj.value = "";
    }

    // 마우스 클릭 시 현재 활성화된 입력 컨트롤을 숨긴다(해당 컨트롤에 대한 마우스 클릭이 아닌 경우)
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

    // 입력 값 표시 필드와 입력 컨트롤의 Display(보여지는 것)를 상호 대치한다
    function toggleActiveElementDisplay()
    { 
        if (activeElement != null) {
            activeElement.style.display = 'none';
            if (activeElementPair != null) activeElementPair.style.display = '';
            activeElement = null;
            activeElementPair = null;
        }
    }

    // 시수입력 사항의 Validation Check...
    function checkInputs()
    {
        // 결재완료 여부 체크
        if (DPInputMain.MHConfirmYN.value == 'Y') {
            alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return false;
        }
        
        // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                
                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                alert(alertMsg);
               
                return false;
            }
            <%}%>
        }

        // 필수입력 항목 입력 여부 체크
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

            if (pjt == '') errKey = "공사번호";
            if (errKey == '' && drwNo == '')  errKey = "도면번호";
            if (errKey == '' && op == '') errKey = "OP 코드";
            if (errKey == '' && (op == '20' || op.substring(0, 2) == 'A2')) { 
                var depart = DPInputMain.all('depart' + timeKeys[i]).value;
                var basis = DPInputMain.all('basis' + timeKeys[i]).value;

                if (op != '20' && depart == '') errKey = "원인부서";
                if (errKey == '' && basis == '') errKey = "근거";
            }
            //if (errKey == '' && workContent == '') errKey = "업무내용";
            // Multi 공사번호(호선)이 선택된 경우도 EVENT1 체크안함
            if (errKey == '' && pjt != 'S000' && pjt != 'PS0000' && pjt != 'V0000' && drwNo != "*****" && drwNo != "#####" 
                && op != "B53" && op != "D15" && (!pjt.indexOf(",") > -1) && event1Value == "") errKey = "Event1";

            if (errKey != "") {
                alert("No." + idx + "번째 항의 " + errKey + "이(가) 입력되지 않았습니다.\n\n입력사항을 다시 한번 확인해 주시기 바랍니다.");
                return false;
            }

            if (event1Value == '(선택안함)') event1Value = '';
            if ((event1Value == "" && (event2Value != "" || event3Value != "")) || (event2Value == "" && event3Value != "")) {
                alert("No." + idx + "번째 항의 Event 입력 위치가 올바르지 않습니다!\n\nEvent1, 2, 3 순서로 입력해 주십시오.");
                return false;
            }

            if (event1Value != "" && (event1Value == event2Value || event1Value == event3Value || (event2Value != "" 
                                                                                                   && (event2Value == event3Value)))) {
                alert("No." + idx + "번째 항의 Event 입력 값이 중복되었습니다!\n\n입력사항을 다시 한번 확인해 주시기 바랍니다.");
                return false;
            }
            // op code가 도면시수(A type)인데 도면 번호가 없거나 '*****' 이면 에러            
            if(op.substring(0, 1) == 'A' && (drwNo == '' || drwNo == '*****') && pjt != 'S000' && pjt != 'PS0000')
            {
                alert("No." + idx + "번째 항의 도면 번호가 없습니다!\n\nOP CODE가 도면시수(A type)일 경우 도면번호가 필수입니다.");
                return false;            
            }
        }

        return true;
    }

    // 시수입력 저장 처리 서브-프로시저
    function saveDPInputsProc(inputDoneYN, showMessage)
    {
        var workingDayYN = DPInputMain.workingDayYN.value;
        if (workingDayYN == '평일') workingDayYN = 'Y'; 
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
            if (event1 == '(선택안함)') event1 = '';
    
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

            // 시수계산
            var normalTime = 0;
            var overtime = 0;
            var specialTime = 0;

            // 월차, 특별휴가, 예비군훈련(9H)
            var opCode = DPInputMain.all('op' + timeKeys[i]).value;
            if (i == 0 && (opCode == 'D17' || opCode == 'D13' || opCode == 'D14')) { 
                if (workingDayYN == '4H') normalTime = 4; 
                else normalTime = 9;
                inputDoneYN = 'Y'; // 월차 등이면 08:00 외 입력사항은 없으므로 시수입력 완료 (휴일에는 이 항목들 지정되는 경우 없음)
            }
            // 조퇴 : 정상근무 9 시간 기준으로 책정(4H일 때는 4 시간 기준)
            else if (opCode == 'D16') {
                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
                else normalTime = 9 - normalTimeTotal;
                inputDoneYN = 'Y'; // 조퇴 항목 후의 입력사항은 없으므로 시수입력 완료 (휴일에는 이 항목 지정되는 경우 없음)
            }
            // 시운전 후 조기퇴근(평일) : 정상근무 9시간(4H 는 4시간) 기준으로 책정 (시운전 후 조기퇴근은 18:00 후(4H 경우는 12:00 후) 입력되는 경우가 없음)
            else if (opCode == 'D15') {
                if (workingDayYN == '4H') normalTime = 4 - normalTimeTotal;
                else normalTime = 9 - normalTimeTotal;
                inputDoneYN = 'Y';
            }
            // 일반적인 케이스 (시운전 포함)
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
                        
                        if (timeKeys[j] == "1230" || timeKeys[j] == "1300") { // 12:00~13:00(점심시간)은 시수에 포함 X
                            if (toBeStop) break;
                            else continue;
                        }

                        if (workingDayYN == '4H') {
                            if (j <= 8) normalTime += 0.5; // 4H인 경우 12:00 이전까지는 일반근무
                            else overtime += 0.5; // 12:00 초과부터는 연장근무
                        }
                        else {
                            if (j <= 20) normalTime += 0.5; // 18:00 이전까지는 일반근무
                            else overtime += 0.5; // 18:00 초과부터는 연장근무
                        }

                        if (toBeStop) break;
                    }
                }
                else if (opCode == 'B53' && projectNo != 'V0000') { // 시운전은 뒤에 다른 항목이 있으면 위의 일반 케이스로 처리됨, 없으면 연장근무 3 시간 기준으로 처리(휴일은 특근 8시간)
                    if (workingDayYN == 'Y') { 
                        if (normalTime < 9) normalTime = 9 - normalTimeTotal;
                        if (overtime < 3) overtime = 3 - overtimeTotal;
                    }
                    else if (workingDayYN == '4H') { 
                        if (normalTime < 4) normalTime = 4 - normalTimeTotal;
                        if (overtime < 3) overtime = 3 - overtimeTotal;
                    }
                    else { // 휴일
                        if (normalTime < 8) normalTime = 8 - specialTimeTotal; 
                    }

                    inputDoneYN = 'Y'; // 시운전 뒤에 다른 항목이 없으므로 시수입력 완료
                }
                // 그 외에는 뒤에 다른 항목이 없으면 시수계산할 것이 없음

                if (opCode == 'D1Z') inputDoneYN = 'Y'; // 퇴근이면 시수입력 완료
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

        DPInputMain.ajaxCallingSuccessYN.value = "N"; // DB 저장 실행결과(성공 or 실패)를 담기 위한 공간. 

        var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
        if (resultMsg == "Y") {
            DPInputMain.ajaxCallingSuccessYN.value = "Y";

            // TODO 
            //if (showMessage && inputDoneYN == 'Y') alert("저장 & 확정 완료");
            //else if (showMessage) alert("저장 완료");

            // FOR TEST
            if (inputDoneYN == 'Y' && showMessage) {
                alert("저장 & 확정 완료\n\n\n- 정상근무: " + normalTimeTotal + "\n- 연장근무: " + overtimeTotal + "\n- 특근: " + specialTimeTotal);
            }
            else if (showMessage) {
                alert("저장 완료\n\n\n- 정상근무: " + normalTimeTotal + "\n- 연장근무: " + overtimeTotal + "\n- 특근: " + specialTimeTotal);
            }
            DPInputMain.dataChanged.value = "false";
        }
        else alert("에러 발생");
    }

    // 시수입력 사항을 저장한다
    function saveDPInputs()
    {
        if (checkInputs() == false) return;

        var msg = DPInputMain.dateSelected.value + "\n\n입력한 시수를 저장하시겠습니까?";        
        if (confirm(msg)) {
            saveDPInputsProc("N", true);
        }
    }

    // 1 일 이상(호선선택 없음) - 년차, 특별휴가, 예비군 훈련 등 처리 서브-프로시저
    function saveAsVacationProc(opCode)
    {
        var sProperties = 'dialogHeight:145px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
        var periodStr = window.showModalDialog("stxPECDPInputNew_VacationPeriodSelect.jsp?opCode=" + opCode, "", sProperties);

        if (periodStr == null || periodStr == 'undefined') return;

        // TODO 과거 또는 오늘 날짜인 경우 다른 입력항목과의 충돌 여부
        //      미래인 경우에도 시운전, 기 입력된 특별휴가 등 다른 입력항목과의 충돌 여부

        // 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = periodStr.split("~");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        
        var today = new Date();
        var dateStrs = fromDateStr.split("-");
        var fromDate = new Date(dateStrs[0], dateStrs[1] - 1, dateStrs[2] - 7); // 시작일에서 7을 뺀 날짜(7일 전)
        if (fromDate - today > 0) {
            alert(jobDescStr + " 시작일자는 오늘로부터 일주일 이내여야 합니다!");
            return;
        }

        // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                
                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // 결재완료된 일자가 포함되어 있으면 오류
            if (confirmExist == "Y") {
                alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return;
            }
        }

        var jobDescStr = "?????";
        if (opCode == "D13") jobDescStr = "예비군훈련";
        else if (opCode =="D14") jobDescStr = "특별휴가";
        else if (opCode == "D17") jobDescStr = "년차";

        // 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?";        
        if (confirm(msg)) 
        {
            var params = "designerID=" + DPInputMain.designerID.value + 
                         "&fromDateStr=" + fromDateStr + "&toDateStr=" + toDateStr + "&workContentStr=" + jobDescStr + 
                         "&opCode=" + opCode + "&loginID=" + DPInputMain.loginID.value;

            var resultMsg = callDPCommonAjaxPostProc("SaveAsOneDayOverJobDPInputs", params);

            if (resultMsg != null) {
                resultMsg = resultMsg.trim();
                
                if (resultMsg == "ERROR") alert("ERROR");
                else if (resultMsg == "0") alert("적용된 일자가 없습니다!");
                else alert("정상적으로 적용되었습니다!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // 1 일 이상(호선선택 없음) - 기술회의 및 교육, 일반출장
    function saveAsOneDayOverJob(opCode)
    {
        var sProperties = 'dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var returnVal = window.showModalDialog("stxPECDPInputNew_OneDayOverJobPeriodSelect.jsp?opCode=" + opCode, "", sProperties);

        if (returnVal == null || returnVal == 'undefined') return;

        // TODO 과거 또는 오늘 날짜인 경우 다른 입력항목과의 충돌 여부
        //      미래인 경우에도 시운전, 기 입력된 특별휴가 등 다른 입력항목과의 충돌 여부

        // 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = returnVal.split("¸");
        var fromDateStr = tempStrs[0];
        var toDateStr = tempStrs[1];
        var workContentStr = tempStrs[2];
        
        // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                
                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // 결재완료된 일자가 포함되어 있으면 오류
            if (confirmExist == "Y") {
                alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return;
            }
        }


        var jobDescStr = "?????";
        if (opCode == "C22") jobDescStr = "기술회의 및 교육(사내외)";
        else if (opCode == "C31") jobDescStr = "일반출장(기술소위원회, 세미나)";

        // 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?";        
        if (confirm(msg)) 
        {
            var params = "designerID=" + DPInputMain.designerID.value + 
                         "&fromDateStr=" + fromDateStr + "&toDateStr=" + toDateStr + "&workContentStr=" + workContentStr + 
                         "&opCode=" + opCode + "&loginID=" + DPInputMain.loginID.value;

            var resultMsg = callDPCommonAjaxPostProc("SaveAsOneDayOverJobDPInputs", params);

            if (resultMsg != null) {
                resultMsg = resultMsg.trim();
                
                if (resultMsg == "ERROR") alert("ERROR");
                else if (resultMsg == "0") alert("적용된 일자가 없습니다!");
                else alert("정상적으로 적용되었습니다!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // 1 일 이상(호선선택 포함) - 사외 협의 검토
    function saveAsOneDayOverJobWithProject(opCode)
    {
        var sProperties = 'dialogHeight:300px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "designerID=" + DPInputMain.designerID.value;
        paramStr += "&opCode=" + opCode;
        var returnVal = window.showModalDialog("stxPECDPInputNew_OneDayOverJobPeriodSelectPjt.jsp?" + paramStr, "", sProperties);

        if (returnVal == null || returnVal == 'undefined') return;

        // TODO 과거 또는 오늘 날짜인 경우 다른 입력항목과의 충돌 여부
        //      미래인 경우에도 시운전, 기 입력된 특별휴가 등 다른 입력항목과의 충돌 여부

        // 시작일이 일주일 이내에 해당하는지 체크
        var tempStrs = returnVal.split("¸");
        var projectNo = tempStrs[0];
        var fromDateStr = tempStrs[1];
        var toDateStr = tempStrs[2];
        var workContentStr = tempStrs[3];
        
        // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                
                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                alert(alertMsg);

                return;
            }
            <%}%>
        }

        // 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDateStr, toDateStr);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // 결재완료된 일자가 포함되어 있으면 오류
            if (confirmExist == "Y") {
                alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return;
            }
        }


        var jobDescStr = "?????";
        if (opCode == "B46") jobDescStr = "사외 협의 검토(공사관련 출장)";

        // 저장여부 확인 & 저장
        var msg = fromDateStr + " ~ " + toDateStr + "\n\n" + jobDescStr + "을(를) 적용하시겠습니까?";        
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
                else if (resultMsg == "0") alert("적용된 일자가 없습니다!");
                else alert("정상적으로 적용되었습니다!");
            }
            else {
                alert(resultMsg);
            }
        }
    }

    // 퇴근
    function finishWork()
    {
        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '평일' && i < 20) {
                    alert("18:00 전에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i < 8) {
                    alert("12:00 전에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (i == 0) {
                    alert("08:00 에는 퇴근코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D1Z") inputExist = true;
                if (inputExist) {
                    alert("퇴근 시각을 먼저 선택한 후 퇴근을 적용하십시오.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D1Z"; // 90 : 퇴근
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "퇴근"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "퇴근";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;                    

                    if (checkInputs() == false) return;

                    // 저장여부 확인 & 저장
                    var msg = DPInputMain.dateSelected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // 조퇴
    function finishWorkEarly()
    {
        // 확정된 시수는 수정 불가, 조퇴는 평일에만 적용 가능 => TimeSelect 창에서 先 체크함
        
        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '평일' && i >= 20) {
                    alert("18:00 이후에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i >= 8) {
                    alert("12:00 이후에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (i < 4) {
                    alert("10:00 전에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (i == 0) {
                    alert("08:00 에는 조퇴코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D16") inputExist = true;
                if (inputExist) {
                    alert("조퇴 시각을 먼저 선택한 후 조퇴를 적용하십시오.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D16"; // 96 : 조퇴
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "조퇴"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "조퇴";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

                    if (checkInputs() == false) return;

                    // 저장여부 확인 & 저장
                    var msg = DPInputMain.dateSelected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // 시운전
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
        
        // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                
                var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                alert(alertMsg);
               
                return;
            }
			<%}%>
        }


        // 결재완료된 일자가 포함되어 있는지 체크
        var confirmExist = getDesignMHConfirmExist(DPInputMain.designerID.value, fromDate, toDate);
        if (confirmExist == "ERROR") {
            alert("ERROR!");
            return;
        }
        else {
            // 결재완료된 일자가 포함되어 있으면 오류
            if (confirmExist == "Y") {
                alert("결재가 완료된 일자가 포함되어 있습니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return;
            }
        }
        
        // TODO 시운전 해당일(들)이 과거인 경우에 대한 처리를 추가(+ 특별휴가 부분의 to-do 리스트도 참고)
        //      시운전 해당일(들)의 유효한 범위 설정 필요: 예, 오늘 +/- 몇일 이내 


        // [시운전일 기준시수]
        // 평일 - 21:00 이전 종료: Overtime 3 시간으로 처리 
        // 평일 - 21:00 후 종료: 해당 시각까지 Overtime 처리
        // 휴일 - 17:00 이전 종료: Special-time 8 시간으로 처리
        // 휴일 - 17:00 후 종료: 해당 시각까지 Special-time 처리
        // 4H   - 16:00 이전 종료: Overtime 3 시간으로 처리
        // 4H   - 16:00 후 종료: 해당 시각까지 Overtime 처리


        // 시운전 시작일자가 화면 표시일자와 동일하면 화면에 입력된 사항과 충돌되는 것이 없는지 체크
        if (DPInputMain.dateSelected.value == fromDate) 
        {
            // 시운전 시작시간 이후 시간대에 입력항목이 있는지 체크... 있으면 오류 => TODO Warning 출력 후 사용자가 선택하도록 변경할 것
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
                var msg = "시운전 시작시간 이후 시간대에 입력사항이 있습니다.\n\n" + 
                          "해당 입력사항들을 제거한 후 시운전을 선택하십시오.";
                alert(msg);
                return;
            }

            // 시운전 시작일이 화면 표시일자와 동일하면 화면을 업데이트 후 화면입력사항을 기준으로 시수를 저장(시운전 시작시간에 시운전코드 적용)
            if (fromTime != "0800") DPInputMain.all("time" + fromTime).style.display = ''; // 시작시간 해당 Row를 보임

            DPInputMain.all('pjt' + fromTime).value = projectNo; 
            for (var i = 0; i < DPInputMain.all('pjtSel' + fromTime).options.length; i++) {
                if (DPInputMain.all('pjtSel' + fromTime).options[i].value = projectNo) {
                    DPInputMain.all('pjtSel' + fromTime).selectedIndex = i;
                    break;
                }
            }
            DPInputMain.all('drwType' + fromTime).value = ""; DPInputMain.all('drwTypeSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('drwNo' + fromTime).value = "*****"; DPInputMain.all('drwNoSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('op' + fromTime).value = "B53"; // 45 : 시운전
            DPInputMain.all('depart' + fromTime).value = ""; if (DPInputMain.all('departSel' + fromTime).options.length > 0) DPInputMain.all('departSel' + fromTime).selectedIndex = 0;
            DPInputMain.all('basis' + fromTime).value = ""; DPInputMain.all('basisSel' + fromTime).value = "";
            DPInputMain.all('workContent' + fromTime).value = "시운전"; DPInputMain.all('workContentSel' + fromTime).value = "시운전";
            DPInputMain.all('event1' + fromTime).value = ""; DPInputMain.all('event1Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('event2' + fromTime).value = ""; DPInputMain.all('event2Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('event3' + fromTime).value = ""; DPInputMain.all('event3Sel' + fromTime).selectedIndex = 0;
            DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

            // 시작일의 평일, 휴일, 4H 구분
            var workingDayYN = DPInputMain.workingDayYN.value; 
            if (workingDayYN == '평일') workingDayYN = 'Y'; 
            else if (workingDayYN == '4H') workingDayYN = '4H'; 
            else workingDayYN = 'N';

            // 시운전 시작일이 화면 표시일자와 동일하고, 시운전 시작일 == 종료일이면 종료관련 항목도 화면에 추가한다 
            //      - 종료시각이 시운전 기준시수 이내이면 '시운전'으로 시수 적용, 기준시수를 넘으면 종료시각에 퇴근코드 적용
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
                    DPInputMain.all('op' + toTime).value = "D1Z"; // 90 : 퇴근
                    DPInputMain.all('workContent' + toTime).value = "퇴근"; DPInputMain.all('workContentSel' + toTime).value = "퇴근";
                }
            }

            // 입력 누락사항 체크
            if (checkInputs() == false) return;

            // 저장여부 확인
            var msg = "[" + fromDate + "] " + fromTimeStr + " ~ [" + toDate + "] " + toTimeStr + "\n\n시운전을 저장 & 확정하시겠습니까?";        
            if (!confirm(msg)) return;

            saveDPInputsProc("Y", false);

            if (DPInputMain.ajaxCallingSuccessYN.value == "N") {
                alert("저장 실패!");
                return;
            }
        }
        // 시운전 시작일자가 화면 표시일자와 동일하지 않으면 해당일 시수를 무조건 Clear 후 시운전 시수를 저장
        else 
        {
            // 시운전 시작일자가 화면 표시일자와 동일하지 않으면 시작시간을 08:00로 제한
            if (fromTime != "0800") {
                var msg = "시운전 시작일자가 화면에 표시된 현재 일자와 다른 경우에는\n\n" + 
                          "시운전 시작시간을 08:00로 지정하시기 바랍니다.";
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
                        alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                        DPInputMain.ajaxCallingSuccessYN.value = "N";
                    }
                    else ; //alert("정상적으로 적용되었습니다!");
                }
                else {
                    alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                    DPInputMain.ajaxCallingSuccessYN.value = "N";
                }
            }
            else {
                alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                DPInputMain.ajaxCallingSuccessYN.value = "N";
            }
            // End of DB Insert

            if (DPInputMain.ajaxCallingSuccessYN.value == "N") return;
        }

        // 시운전 시작일 <> 종료일: 시작일과 종료일 사이의 일자들 - 시운전 기준시수의 '시운전 코드'로 처리
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
                            alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                            DPInputMain.ajaxCallingSuccessYN.value = "N";
                        }
                        else ; //alert("정상적으로 적용되었습니다!");
                    }
                    else {
                        alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                        DPInputMain.ajaxCallingSuccessYN.value = "N";
                    }
                }
                else {
                    alert(nextDate + " 이후 일자의 적용에 실패했습니다!");
                    DPInputMain.ajaxCallingSuccessYN.value = "N";
                }
                // End of DB Insert

                if (DPInputMain.ajaxCallingSuccessYN.value == "N") break;
                dateString = nextDate;
            }
        }
        if (DPInputMain.ajaxCallingSuccessYN.value == "N") return;

        // 시운전 시작일 <> 종료일: 종료일 
        //      - 평일: 종료시각이 18:00 이전이면 '시운전 후 조기퇴근'(9H)으로 처리
        //      - 평일: 종료시각이 18:00 후이면 시운전 + 퇴근으로 처리(해당 시각까지)
        //      - 4H: 종료시각이 12:00 이전이면 '시운전 후 조기퇴근'(4H)으로 처리
        //      - 4H: 종료시각이 12:00 후이면 시운전 + 퇴근으로 처리(해당 시각까지)
        //      - 휴일: 시운전 + 퇴근으로 처리(종료시각까지 특근 처리)
        if (fromDate != toDate) {
            workingDayYN = getWorkingDayYN(toDate); // 해당일(종료일)의 평일,휴일,4H 여부 쿼리

            var timeIndex;
            for (var i = 0; i < timeKeys.length; i++) { 
                if (timeKeys[i] == toTime) { timeIndex = i;  break; }
            }

            var finishEarlyYN = true;
            if (workingDayYN == "Y" && timeIndex > 20) finishEarlyYN = false; // 평일 18:00 후는 Overtime (시운전 후 조기퇴근 대상 X)
            else if (workingDayYN == "4H" && timeIndex > 8) finishEarlyYN = false; // 4H 12:00 후는 Overtime (시운전 후 조기퇴근 대상 X)
            else if (workingDayYN == "N") finishEarlyYN = false; // 휴일은 모든 경우에 시운전 후 조기퇴근 대상 X


            // 08:00 시각에 시운전 코드 적용
            var params = "";
            params = "designerID=" + DPInputMain.designerID.value + "&dateStr=" + toDate + "&loginID=" + DPInputMain.loginID.value;

            params += "&timeKey0800=0800&pjt0800=" + projectNo + "&drwType0800=&drwNo0800=*****&op0800=B53&depart0800=&basis0800=&workContent0800=시운전";
            params += "&event10800=&event20800=&event30800=";

            var worktimeTotal = 0;
            for (var i = 1; i <= timeIndex; i++) {
                if (timeKeys[i] == "1230" || timeKeys[i] == "1300") continue; 
                worktimeTotal += 0.5;
            }


            // 시운전 후 조기퇴근에 해당이 아니면 종료시각에 퇴근 코드 적용
            if (!finishEarlyYN) 
            {
                if (workingDayYN == "N" && timeIndex == 0) {  } // 휴일이고 08:00에 종료되었으면 Skip
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
                    params += "&op" + toTime + "=D1Z&depart" + toTime + "=&basis" + toTime + "=&workContent" + toTime + "=퇴근";
                    params += "&event1" + toTime + "=&event2" + toTime + "=&event3" + toTime + "=";
                    params += "&normalTime" + toTime + "=0&overtime" + toTime + "=0&specialTime" + toTime + "=0";
                    params += "&inputDoneYN=Y";

                    var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
                    if (resultMsg == "N") {
                        alert(toDate + " 일자의 적용에 실패했습니다!");
                        return;
                    }
                }
            }
            // 시운전 후 조기퇴근으로 적용
            else {
                var normalTime = 0;

                if (timeIndex != 0) {
                    if (workingDayYN == "Y") normalTime = worktimeTotal;
                    else if (workingDayYN == "4H") normalTime = worktimeTotal;

                    params += "&normalTime0800=" + normalTime + "&overtime0800=0&specialTime0800=0";

                    if (workingDayYN == "Y") normalTime = 9 - worktimeTotal;
                    else if (workingDayYN == "4H") normalTime = 4 - worktimeTotal;

                    params += "&timeKey" + toTime + "=" + toTime + "&pjt" + toTime + "=S000&drwType" + toTime + "=&drwNo" + toTime + "=*****";
                    params += "&op" + toTime + "=D15&depart" + toTime + "=&basis" + toTime + "=&workContent" + toTime + "=시운전 후 조기퇴근";
                    params += "&event1" + toTime + "=&event2" + toTime + "=&event3" + toTime + "=";
                    params += "&normalTime" + toTime + "=" + normalTime + "&overtime" + toTime + "=0&specialTime" + toTime + "=0";
                    params += "&inputDoneYN=Y";
                }
                else {
                    if (workingDayYN == "Y") normalTime = 9;
                    else if (workingDayYN == "4H") normalTime = 4;

                    params = "";
                    params = "designerID=" + DPInputMain.designerID.value + "&dateStr=" + toDate + "&loginID=" + DPInputMain.loginID.value;
                    params += "&timeKey0800=0800&pjt0800=S000&drwType0800=&drwNo0800=*****&op0800=D15&depart0800=&basis0800=&workContent0800=시운전 후 조기퇴근";
                    params += "&event10800=&event20800=&event30800=";
                    params += "&normalTime0800=" + normalTime + "&overtime0800=0&specialTime0800=0";
                    params += "&inputDoneYN=Y";
                }

                var resultMsg = callDPCommonAjaxPostProc("SaveDPInputs", params);
                if (resultMsg == "N") {
                    alert(toDate + " 일자의 적용에 실패했습니다!");
                    return;
                }
            }
        }

        if (DPInputMain.ajaxCallingSuccessYN.value == "N") {
            alert("저장 실패!");
            return;
        }
        else alert("적용 완료");
    }

    // 시운전 후 조기퇴근(평일)
    function finishWorkEarlyAfterSeaTrial()
    {
        // 확정된 시수는 수정 불가, 시운전 후 조기퇴근은 평일에만 적용 가능 => TimeSelect 창에서 先 체크함

        toggleActiveElementDisplay();

        for (var i = timeKeys.length - 1; i >= 0; i--) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') {
                if (DPInputMain.workingDayYN.value == '평일' && i >= 20) {
                    alert("18:00 이후에는 '시운전 후 조기퇴근' 코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }
                if (DPInputMain.workingDayYN.value == '4H' && i >= 8) {
                    alert("12:00 이후에는 '시운전 후 조기퇴근' 코드를 입력할 수 없습니다.\n\n입력 시각을 확인하여 주십시오.");
                    return;
                }

                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "" && DPInputMain.all('pjt' + timeKeys[i]).value != "S000") inputExist = true;
                if (!inputExist && DPInputMain.all('op' + timeKeys[i]).value != "" && DPInputMain.all('op' + timeKeys[i]).value != "D15") inputExist = true;
                if (inputExist) {
                    alert("적용할 시각을 먼저 선택한 후 '시운전 후 조기퇴근'을 적용하십시오.");
                    return;
                }
                else {
                    DPInputMain.all('pjt' + timeKeys[i]).value = "S000"; DPInputMain.all('pjtSel' + timeKeys[i]).selectedIndex = 1;
                    DPInputMain.all('drwType' + timeKeys[i]).value = ""; DPInputMain.all('drwTypeSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('drwNo' + timeKeys[i]).value = "*****"; DPInputMain.all('drwNoSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('op' + timeKeys[i]).value = "D15"; // 95 : 시운전 후 조기퇴근
                    DPInputMain.all('depart' + timeKeys[i]).value = ""; if (DPInputMain.all('departSel' + timeKeys[i]).options.length > 0) DPInputMain.all('departSel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('basis' + timeKeys[i]).value = ""; DPInputMain.all('basisSel' + timeKeys[i]).value = "";
                    if (DPInputMain.all('workContent' + timeKeys[i]).value.trim() == "") {
                        DPInputMain.all('workContent' + timeKeys[i]).value = "시운전 후 조기퇴근"; DPInputMain.all('workContentSel' + timeKeys[i]).value = "시운전 후 조기퇴근";
                    }
                    DPInputMain.all('event1' + timeKeys[i]).value = ""; DPInputMain.all('event1Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event2' + timeKeys[i]).value = ""; DPInputMain.all('event2Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('event3' + timeKeys[i]).value = ""; DPInputMain.all('event3Sel' + timeKeys[i]).selectedIndex = 0;
                    DPInputMain.all('shipType' + timeKeys[i]).value = ""; DPInputMain.all('shipType' + timeKeys[i]).selectedIndex = 0;  

                    if (checkInputs() == false) return;

                    // 저장여부 확인 & 저장
                    var msg = DPInputMain.dateSelected.value + "\n\n시수를 저장 & 확정하시겠습니까?";        
                    if (confirm(msg)) {
                        saveDPInputsProc("Y", true);
                    }
                }

                break;
            }
        }
    }

    // 전일시수 COPY
    function copyYesterdayMH()
    {
        // 확정된 시수는 수정 불가, '전일시수 COPY'는 평일에만 적용 가능 => TimeSelect 창에서 先 체크함

        toggleActiveElementDisplay();

        // 기 입력된 사항이 있는지 체크
        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "time" + timeKeys[i];
            var editWinStyle = DPInputMain.all(ctrlId).style;
            if (editWinStyle.display != 'none') 
            {
                var inputExist = false;
                if (DPInputMain.all('pjt' + timeKeys[i]).value != "") inputExist = true; // 다른 모든 입력항목은 '공사번호' 선택 후에만 입력가능하므로 
                                                                                         // '공사번호' 입력 값 존재여부만 체크하면 된다
                if (inputExist) {
                    var msg = "시수입력 사항이 있습니다.\n\n입력사항을 무시하고 '전일시수 COPY'를 실행하시겠습니까?";
                    if (confirm(msg) == false) return;
                    
                    break;
                }
            }
        }

        // 전일시수 데이터를 쿼리해 온다
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
                    else if (resultMsg != 'Y') alert("전일이 휴일이어서 '전일시수 COPY'를 적용할 수 없습니다.\n\n날짜를 확인하여 주십시오.");
                    else {
                        // 기존항목을 모두 초기화
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

                        // 전일시수 입력사항을 화면에 적용
                        var strs = resultMsg.split("∥");
                        for (var i = 0; i < strs.length; i++) 
                        {
                            if (strs[i] == "") continue;

                            var strs2 = strs[i].split("‥");
                            
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
                                DPInputMain.all('basis' + timeKey).value = "√"; 
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

    // 선택된 날짜의 입력시수를 전체삭제
    function deleteDPInputs()
    {
        toggleActiveElementDisplay();

        var msg = DPInputMain.dateSelected.value + "\n\n입력시수를 일괄 삭제하시겠습니까?";        
        if (confirm(msg)) {
            // 결재완료 여부 체크
            if (DPInputMain.MHConfirmYN.value == "Y") {
                alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
                return;
            }

            // 시작일자가 시수입력 LOCK 일자를 경과하였는지 체크
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
                    //alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
                    
                    var alertMsg = "입력 유효일자(기준: 당일 - 1 Working day)가 경과되었습니다.\n\n";
                    alertMsg += "시수 입력 제한 해제 요청서 (EP 전자결재 - 새기안 - 기술부문 - 시수입력제한해제요청서)\n\n";
                    alertMsg += "결재를 득한 후 관리자에게 Lock 해제를 요청하십시오.";
                    alert(alertMsg);
                   
                    return;
                }
                <%}%>
            }

            // 데이터 삭제 처리
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
                            // 기존항목을 모두 초기화
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
                            alert("삭제완료");
                        }
                    }
                    else alert("ERROR");
                }
                else alert("ERROR");
            }
            else alert("ERROR");
        }
    }

    // Header에서 호선선택 변경 시 Main 항목들에도 즉시 반영
    function changedSelectedProject(selectedProjects)
    {
        toggleActiveElementDisplay();

        var selectedProjectsList = selectedProjects.split("|");

        for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "pjtSel" + timeKeys[i];
            var pjtSelObj = DPInputMain.all(ctrlId);
            var currentSelectedValue = DPInputMain.all("pjt" + timeKeys[i]).value;
            
            // 먼저 현재의 호선목록을 모두 삭제
            for (var j = pjtSelObj.options.length - 1; j >= 2; j--)  pjtSelObj.options[j] = null; // 0 번째는 '', 1 번째는 'S000' 이므로 2 번째 부터 처리

            var isExist = false;

            // 변경된 호선목록으로 다시 채운다
            for (var j = 0; j < selectedProjectsList.length; j++) {
                var projectNoStr = selectedProjectsList[j];
                pjtSelObj.options[j + 2] = new Option(projectNoStr, projectNoStr);
                
                // selected 설정
                if (currentSelectedValue == projectNoStr) {
                    pjtSelObj.selectedIndex = j + 2;
                    isExist = true;
                }
            }

            // 선택된 호선이 삭제된 호선이면 이 항목에 대해서만 해당 호선을 추가
            if (!isExist && currentSelectedValue != "" && currentSelectedValue != "S000") {
                pjtSelObj.options[pjtSelObj.options.length] = new Option(currentSelectedValue, currentSelectedValue);
                pjtSelObj.selectedIndex = pjtSelObj.options.length - 1;
            }
        }
    }

    // Bottom 의 DP 공정 정보 업데이트
    function updateDrawingInfo(timeKey)
    {
        if (timeKey == '') parent.DP_BOTTOM.updateDrawingInfo('', '');
        else parent.DP_BOTTOM.updateDrawingInfo(DPInputMain.all('pjt' + timeKey).value, DPInputMain.all('drwNo' + timeKey).value);
    }

    // 프린트(리포트 출력)
    function printPage()
    {
    	// TEST는 STXDPDEV/WebReport.jsp로 잡아줘야할듯. 141219 KSJ
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput.mrd&param=" + "<%=designerID%>:::" + "<%=dateSelected%>" ;
        //var urlStr = "http://172.16.2.13:7777/j2ee/STXDPDEV/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDPDPDEV/mrd/stxPECDPInput.mrd&param=" + "<%=designerID%>:::" + "<%=dateSelected%>" ;
        window.open(urlStr, "", "");
    }

    // TR MouseOver 시 Color-Highlight
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

    // TR MouseOut 시 Color-Highlight 제거
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
    
    
    // 호선 복수 지정
    function showProjectMultiSelect(timeKey) 
    {
     	var pjtSelObj = DPInputMain.all('pjtSel' + timeKey);
     	var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (parent.DP_HEADER.DPInputHeader.dpDesignerIDSel.value == "") {
            alert("설계자를 먼저 선택하십시오.");
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
    
    
    // '선종' 선택 시 입력 컨트롤 표시
    function showShipTypeSel(elemPrefix, timeKey)
    {
        var pjtObj = DPInputMain.all('pjt' + timeKey);
        if (pjtObj.value == '') return; // 호선의 값이 없으면 입력 컨트롤 표시하지 않는다

        showElementSel(elemPrefix, timeKey);
    }
    
    
    // 선종 리스트 값들을 DB에서 쿼리해오고 '선종' LOV를 채우는 서브-프로시저
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
