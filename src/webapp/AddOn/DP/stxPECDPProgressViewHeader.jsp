<%--  
§DESCRIPTION: 공정 조회/입력 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressViewHeader.jsp
§CHANGING HISTORY: 
§    2009-04-13: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file = "stxPECDP_Include.inc" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%--========================== JSP =========================================--%>
<%
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id"); // 접속자 ID : 설계자(파트장 포함) or 관리자(Admin)
    String designerID = "";             // 설계자 ID 
    String isAdmin = "N";               // 관리자 여부
    String isManager = "N";             // 파트장 여부
    String mhInputYN = "";              // 시수입력 가능 여부(이 권한은 공정입력 권한을 포함함)
    String progressInputYN = "";        // 공정입력 가능 여부
    String terminationDate = "";        // 퇴사일(퇴사여부)
    String insaDepartmentCode = "";     // 부서(파트) 코드 - 인사정보의 코드
    String dwgDepartmentCode = "";      // 부서(파트) 코드 - 설계부서 코드

    String errStr = "";                 // DB Query 중 에러 발생 여부

    ArrayList projectList = null;
    ArrayList departmentList = null;
    ArrayList personsList = null;
    ArrayList partOutsidePersonsList = null;  // 2nd 담당자 : 포스텍 외주 인원 목록

    boolean isMaritimeBizTeam = false; // (FOR MARITIME) 해양사업관리팀/해양종합설계팀 인원의 공정조회 기능 부여 (* 임시기능)

    // DB에서 데이터 쿼리하여 항목들의 값 설정
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
            partOutsidePersonsList = getPartOutsidePersonsForDPProgress(insaDepartmentCode);

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            if ("파트장".equals(titleStr) || "팀장".equals(titleStr)) isManager = "Y";
        }
        else // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
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

        // (FOR MARITIME) 해양사업관리팀/해양종합설계팀 인원의 공정조회 기능 부여 (* 임시기능)
        //if (/*loginUserInfo != null &&*/ terminationDate.equals("") && !mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) 
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
<head><title>공정 조회/입력</title></head>
<link rel="styleSheet" HREF="stxPECDP.css" type="text/css" title="stxPECDP_css">
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // 시수입력 가능한 사용자가 아닌 경우 Exit
    <% if ((!mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
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
        <tr height="30">
            <td class="td_title" width="280">
                공 정 조 회 & 입 력
            </td>
            <td width="320">부서
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
            <td width="480">일자
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
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewDPProgress();"/>
                <input type="button" name="SavaButton" value='저 장' class="button_simple" onclick="saveDPProgress();"/>
            </td>
        </tr>

        <tr height="30">
            <td>호선
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
				&nbsp;&nbsp;&nbsp;
				사번
                <select name="designerList" style="width:140px;">
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


                <% if (isAdmin.equals("Y")) { %>
                &nbsp;&nbsp;<input type="text" name="" value="조회가능 호선관리" class="input_noBorder" style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" onclick="showSearchableProjects();" />
                <% } %>
            </td>
            <td>  
				<input type="checkbox" name="allempinput" onclick="fnCheckEmpAll(this)"/>1st담당자 일괄입력
                
                <select name="allempList" style="width:140px; display:none;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; personsList != null && i < personsList.size(); i++) {
                        Map map = (Map)personsList.get(i);
                        String empNo = (String)map.get("EMPLOYEE_NO");
                        String empName = (String)map.get("EMPLOYEE_NAME");
                        String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                        %>
                        <option value="<%=empNo%>" empName="<%=empName%>"><%=empStr%></option>
                        <%
                    }
                    %>
                </select>
                
                <input type="button" name="ApplyButton" value='적 용' class="button_simple2" style="width:50px; display:none;" onclick="fnApplyAllEmp()"/>       
                <br>
				<input type="checkbox" name="allempinput_sub" onclick="fnCheckEmpAll_sub(this)"/>2nd담당자 일괄입력
                
                <select name="allempList_sub" style="width:140px; display:none;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; partOutsidePersonsList != null && i < partOutsidePersonsList.size(); i++) {
                        Map map = (Map)partOutsidePersonsList.get(i);
                        String empNo = (String)map.get("EMPLOYEE_NO");
                        String empName = (String)map.get("EMPLOYEE_NAME");
                        String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                        %>
                        <option value="<%=empNo%>" empName="<%=empName%>"><%=empStr%></option>
                        <%
                    }
                    %>
                </select>
                
                <input type="button" name="ApplyButton_sub" value='적 용' class="button_simple2" style="width:50px; display:none;" onclick="fnApplyAllEmp_sub()"/>                             

                <% if (isAdmin.equals("Y")) { %>
                &nbsp;&nbsp;<input type="text" name="" value="실적입력관리" class="input_noBorder" style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" onclick="showDateChangePossible();" />
                <% } %>
            </td>
            <td>도면번호
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
                도면명
                <input type="text" name="drawingTitle" value="" style="width:140px;" onkeydown="inputCtrlKeydownHandler();" onKeyUp="javascript:this.value=this.value.toUpperCase();" />
            </td>
            <td>
                <input type="button" name="PrintButton" value='출 력' class="button_simple2" style="width:50px;" onclick="viewReport();"/>
				<% // 20140714 Kangseonjung : PM팀 인원(이재진 : 211363, 진승현 : 211047, 송동길 : 211269, 송우길 : 211856, 김태근:196039, 장현태:209495 )에 대하여 엑셀 출력기능 임시 추가%>
				<% // 20151028 Kangseonjung : 팀파트장에 엑셀 출력기능 추가%>				
                <% if (isAdmin.equals("Y") || isMaritimeBizTeam/*(FOR MARITIME)*/ || "Y".equals(isManager) || "211047".equals(loginID) || "211269".equals(loginID) || "211363".equals(loginID) || "211856".equals(loginID) || "196039".equals(loginID) || "209495".equals(loginID) || "206285".equals(loginID)) { %>
                    <input type="button" name="ExcelButton" value='엑 셀' class="button_simple2" style="width:50px;" onclick="viewReportExcel();"/>
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
                        <table width="380" cellspacing="0" cellpadding="0" border="0" align="left">
                            <tr height="15">
                                <td class="td_keyEvent" rowspan="2" width="80" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:80px;background-color:#D8D8D8;" name="keyeventCT" />
                                </td>
                                <td class="td_keyEvent" rowspan="2" colspan="3" width="80" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:80px;background-color:#D8D8D8;" name="keyeventSC" />
                                </td>
                                <td class="td_keyEvent" colspan="2" width="80" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:80px;background-color:#D8D8D8;" name="keyeventKL" />
                                </td>
                                <td class="td_keyEvent" colspan="2" width="80" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:80px;background-color:#D8D8D8;" name="keyeventLC" />
                                </td>
                                <td class="td_keyEvent" rowspan="2" width="80" style="color:#0000ff">
                                    <input class="input_noBorder" style="width:80px;background-color:#D8D8D8;" name="keyeventDL" />
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
                        <input type="checkbox" name="colShowCheck7" />담당자
                        <input type="checkbox" name="colShowCheck16" />2st담당자<br>
                        <input type="checkbox" name="colShowCheck8" />Drawing Start
                        <input type="checkbox" name="colShowCheck9" />Drawing Finish
                        <input type="checkbox" name="colShowCheck10" />Owner App. Submit
                        <input type="checkbox" name="colShowCheck11" />Owner App. Finish
                        <input type="checkbox" name="colShowCheck12" />Class App. Submit
                        <input type="checkbox" name="colShowCheck13" />Class App. Finish
                        <input type="checkbox" name="colShowCheck14" />Working
                        <input type="checkbox" name="colShowCheck15" />Construction
                    </td>
                    <td>
                    	Title자리수
                    	<select name="titleSize">
                    		<option value="">30자리</option>
                    		<option value="300">50자리</option>
                    		<option value="500">70자리</option>
                    	</select>
                    </td>

                    <% if (isAdmin.equals("Y")) { %>
                        <td style="border:#000000 2px solid;background-color: #f8f8f8;padding:0px, 4px, 0px, 4px;"
                            onmouseover="this.style.cursor='hand';" onclick="showProgressLockWin();">입 력<br>제 한
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

    parent.PROGRESS_VIEW_MAIN.location = "stxPECDPProgressViewMain.jsp?showMsg=true"; // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록.

	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    // 부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
    function departmentSelChanged() 
    {
        for (var i = DPProgressViewHeader.designerList.options.length - 1; i > 0; i--) {
            DPProgressViewHeader.designerList.options[i] = null;
        }
        if (DPProgressViewHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=getPartPersonsForDPProgress&departCode=" + DPProgressViewHeader.departmentList.value, false);
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

    // 날짜 출력 문자열을 형식화
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
    // 조회가능 호선관리 창을 Show
    function showDateChangePossible()
    {
        var sProperties = 'dialogHeight:550px;dialogWidth:550px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPProgressViewHeader.loginID.value;
        var selectedProjects = window.showModalDialog("stxPECDPProgress_ProjectDateChange.jsp?" + paramStr, "", sProperties);
    }

    // 조회가능 호선관리 창을 Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPProgressViewHeader.loginID.value;
        var selectedProjects = window.showModalDialog("stxPECDPProgress_ProjectSelect.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;

        var changedList = selectedProjects.split(",");
        var currentSelect = DPProgressViewHeader.projectList.value;
        // Opened -> Closed로 변경된 항목이 있으면 제거
        for (var i = 0; i < changedList.length; i++) {
            if (changedList[i].indexOf("CLOSED") > 0) {
                for (var j = DPProgressViewHeader.projectList.options.length - 1; j >= 1; j--) {
                    if (changedList[i].indexOf(DPProgressViewHeader.projectList.options[j].value) == 0) {
                        DPProgressViewHeader.projectList.options[j] = null;
                    }
                }
            }
        }
        // Closed -> Opened 로 변경된 항목이 있으면 추가
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

    // 입력제한 관리 창을 Show
    function showProgressLockWin()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:400px;scroll=no;center:yes;status=no;';
        var result = window.showModalDialog("stxPECDPProgress_LockControl.jsp", "", sProperties);
    }

    // 도면번호 입력 시 다음 칸으로 자동 이동
    function drawingNoKeyup(inputObject, next)
    {
        inputObject.value = inputObject.value.toUpperCase();

        //var e = window.event;
        //if (e.keyCode != 9) { // Tab key down이면 무시
        //    DPProgressViewHeader.all("drawingNo" + next).focus();
        //}
    }

    // 도면번호 입력을 모두 Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) {
            DPProgressViewHeader.all("drawingNo" + i).value = "";
        }
    }

    // 입력 조건 체크
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
            alert("올바른 호선이름을 선택하십시오.");
            return false;
        }
        //if (DPProgressViewHeader.departmentList.value == "") {
        //    alert("부서를 선택하십시오.");
        //    return false;
        //}

        if ((DPProgressViewHeader.dateSelectedFrom.value != "" || DPProgressViewHeader.dateSelectedTo.value != "") &&
            DPProgressViewHeader.dateCondition.value == "")
        {
            alert("검색일자에 대한 조건을 입력하십시오!");
            DPProgressViewHeader.dateCondition.focus();
            return false;
        }

        return true;
    }

    // 공정조회 실행
    function viewDPProgress()
    {
        if (!checkInputs()) return;
        
        //// 사용자 입력사항이 있으면 변경사항을 먼저 저장
        //if (parent.PROGRESS_VIEW_MAIN.DPProgressViewMain != null) {
        //    var dataChanged = parent.PROGRESS_VIEW_MAIN.DPProgressViewMain.dataChanged.value;
        //    if (dataChanged == "true") {
        //        var msg = "변경된 내용이 있습니다. 변경사항을 저장하시겠습니까?\n\n" + 
        //                  "[확인] : 변경사항 저장 , [취소] 변경사항 무시";
        //        if (confirm(msg)) saveDPInputs();
        //    }
        //}

        // 조회
        var urlStr = "stxPECDPProgressViewMain.jsp?projectNo=" + DPProgressViewHeader.projectList.value;
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
        urlStr += "&titleSize=" + DPProgressViewHeader.titleSize.value;

        parent.PROGRESS_VIEW_MAIN.location = urlStr;
    }

    // 공정 실제시수 입력사항 저장
    function saveDPProgress()
    {
        parent.PROGRESS_VIEW_MAIN.saveDPProgress();
    }

    // 프린트(리포트 출력) - VIEW & PRINT 양식
    function viewReport()
    {
        var rdFileName = "stxPECDPProgressView.mrd";
        if (DPProgressViewHeader.isAdmin.value == "Y") rdFileName = "stxPECDPProgressViewAdmin.mrd";
        viewReportProc(rdFileName);
    }
        
    // 프린트(리포트 출력) - EXCEL EXPORT 양식
    function viewReportExcel()
    {
        viewReportProc("stxPECDPProgressViewExcel.mrd");
    }

    // 프린트(리포트 출력) 서브 프로시저
    function viewReportProc(rdFileName)
    {
        if (!checkInputs()) return;

        var paramStr = DPProgressViewHeader.projectList.value + ":::" + 
                       DPProgressViewHeader.departmentList.value + ":::" + 
                       DPProgressViewHeader.designerList.value + ":::";

       var fromDate = DPProgressViewHeader.dateSelectedFrom.value;
       var toDate = DPProgressViewHeader.dateSelectedTo.value;
        
        if (fromDate != "" && toDate != "") { // 시작-종료 순서가 반대이면 조정
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
        if (rdFileName != "stxPECDPProgressViewExcel.mrd")
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

        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/" + rdFileName 
                     + "&param=" + paramStr;
        window.open(urlStr, "", "");
    }


    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // 호선 선택 SELECT BOX SHOW
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

    // 호선 선택 SELECT BOX 값 선택 시 Select Box는 Hidden, 선택된 값을 Input Box에 반영
    function projectListChanged()
    {
        DPProgressViewHeader.projectInput.value = DPProgressViewHeader.projectList.value;
        projectListDiv.style.display = "none";
    }

    // 마우스 클릭 시 SELECT BOX 컨트롤을 숨긴다(해당 컨트롤에 대한 마우스 클릭이 아닌 경우)
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
    
    function fnCheckEmpAll(AllEmpInput)
    {
		if(DPProgressViewHeader.departmentList.value != "<%=insaDepartmentCode%>")
		{
			var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
	                     "조회된 도면을 확인 바랍니다.";
			alert(msgStr);
			return;
		}

    	if(AllEmpInput.checked)
    	{
    		DPProgressViewHeader.allempList.style.display = "";
    	}
    	else DPProgressViewHeader.allempList.style.display = "none";
    		 
    	if(AllEmpInput.checked)
    	{
    		DPProgressViewHeader.ApplyButton.style.display = "";
    	}
    	else DPProgressViewHeader.ApplyButton.style.display = "none";
    	
    	AllEmpInput = null;
    }
    
	function fnApplyAllEmp()
	{
		if (DPProgressViewHeader.allempList.value == "")
		{
			var msgStr = "일괄 입력 할 담당자를 선택하시기 바랍니다.";
			alert(msgStr);
			return;
		}
		
		var confirmgubun = "";

		var objTbl = parent.PROGRESS_VIEW_MAIN.document.getElementById('table_data1');
		
		var selectedOption = DPProgressViewHeader.allempList.options[DPProgressViewHeader.allempList.selectedIndex];
		
		for(var i=0;i<objTbl.rows.length;i++)
		{
			/////if(objTbl.rows[i].cells.td_list_user.innerText != "")
			if(true)
			{
				var msg1 = "선택한 조건으로 담당자 일괄 입력하시겠습니까?\n\n" +
	                       "기 입력된 담당자는 덮어 씁니다!";                           
                if (confirm(msg1)){
                	var confirmgubun = "YES"
                }
                else
                {
                	var msg2 = "선택한 조건으로 담당자 일괄 입력하시겠습니까?\n\n" +
	                       	   "기 입력된 담당자는 제외 합니다!";            
                	if (confirm(msg2)){
                		var confirmgubun = "NO"
                	}
                	else
                	{
                		var confirmgubun = "CANCEL"
                	}
                }
                	
				break;
			}
		}
		
		for(var i=0;i<objTbl.rows.length;i++)
		{
			if(objTbl.rows[i].deptCodeData == "<%=dwgDepartmentCode%>")
			{
				if (confirmgubun == "YES")
				{
					objTbl.rows[i].cells.td_list_user.innerText = selectedOption.empName;
	                parent.PROGRESS_VIEW_MAIN.inputPersonsList[parent.PROGRESS_VIEW_MAIN.inputPersonsList.length] = objTbl.rows[i].dwgCode + "DW|" + DPProgressViewHeader.allempList.value;
                }
                else if (confirmgubun == "NO")
                {
                	if (objTbl.rows[i].cells.td_list_user.innerText == "")
                	{
	                	objTbl.rows[i].cells.td_list_user.innerText = selectedOption.empName;
		                parent.PROGRESS_VIEW_MAIN.inputPersonsList[parent.PROGRESS_VIEW_MAIN.inputPersonsList.length] = objTbl.rows[i].dwgCode + "DW|" + DPProgressViewHeader.allempList.value;
	                }
                }
			}
			else
			{
				var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
                             "조회된 도면을 확인 바랍니다.";                            
                alert(msgStr);
                return;
            }
		}
	}
	
	
	
	
    function fnCheckEmpAll_sub(AllEmpInput_sub)
    {
		if(DPProgressViewHeader.departmentList.value != "<%=insaDepartmentCode%>")
		{
			var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
	                     "조회된 도면을 확인 바랍니다.";
			alert(msgStr);
			return;
		}

    	if(AllEmpInput_sub.checked)
    	{
    		DPProgressViewHeader.allempList_sub.style.display = "";
    	}
    	else DPProgressViewHeader.allempList_sub.style.display = "none";
    		 
    	if(AllEmpInput_sub.checked)
    	{
    		DPProgressViewHeader.ApplyButton_sub.style.display = "";
    	}
    	else DPProgressViewHeader.ApplyButton_sub.style.display = "none";
    	
    	AllEmpInput_sub = null;
    }
    
	function fnApplyAllEmp_sub()
	{
		if (DPProgressViewHeader.allempList_sub.value == "")
		{
			var msgStr = "일괄 입력 할 담당자를 선택하시기 바랍니다.";
			alert(msgStr);
			return;
		}
		
		var confirmgubun = "";

		var objTbl = parent.PROGRESS_VIEW_MAIN.document.getElementById('table_data1');
		
		var selectedOption = DPProgressViewHeader.allempList_sub.options[DPProgressViewHeader.allempList_sub.selectedIndex];
		
		for(var i=0;i<objTbl.rows.length;i++)
		{

			////if(objTbl.rows[i].cells.td_list_subuser.innerText != "")
			if(true)
			{
				var msg1 = "선택한 조건으로 담당자 일괄 입력하시겠습니까?\n\n" +
	                       "기 입력된 담당자는 덮어 씁니다!";                           
                if (confirm(msg1)){
                	var confirmgubun = "YES"
                }
                else
                {
                	var msg2 = "선택한 조건으로 담당자 일괄 입력하시겠습니까?\n\n" +
	                       	   "기 입력된 담당자는 제외 합니다!";            
                	if (confirm(msg2)){
                		var confirmgubun = "NO"
                	}
                	else
                	{
                		var confirmgubun = "CANCEL"
                	}
                }
                	
				break;
			}
		}

		for(var i=0;i<objTbl.rows.length;i++)
		{
			if(objTbl.rows[i].deptCodeData == "<%=dwgDepartmentCode%>")
			{
				if (confirmgubun == "YES")
				{
					objTbl.rows[i].cells.td_list_subuser.innerText = selectedOption.empName;
	                parent.PROGRESS_VIEW_MAIN.inputOutsidePersonsList[parent.PROGRESS_VIEW_MAIN.inputOutsidePersonsList.length] = objTbl.rows[i].dwgCode + "DW|" + DPProgressViewHeader.allempList_sub.value;
                }
                else if (confirmgubun == "NO")
                {
                 	if (objTbl.rows[i].cells.td_list_subuser.innerText == "")
                	{
	                	objTbl.rows[i].cells.td_list_subuser.innerText = selectedOption.empName;
		                parent.PROGRESS_VIEW_MAIN.inputOutsidePersonsList[parent.PROGRESS_VIEW_MAIN.inputOutsidePersonsList.length] = objTbl.rows[i].dwgCode + "DW|" + DPProgressViewHeader.allempList_sub.value;
	                }
                }
			}
			else
			{
				var msgStr = "소속부서의 도면만 입력 가능합니다.\n\n" +
                             "조회된 도면을 확인 바랍니다.";                            
                alert(msgStr);
                return;
            }
		}		

	}	
</script>

</html>
