<%--  
§TITLE: 설계시수 DATA 관리 화면 Header 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPDataMgmtHeader.jsp
§CHANGING HISTORY: 
§    2009-07-29: Initiative
§DESCRIPTION:
        설계시수 DATA 관리 화면의 Header 부분으로 이 기능을 실행할 수 있는 권한
    이 있는지 체크하고, DATA 조회에 사용할 OPTION 항목들을 제공한다. 
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // 접속자 ID : 설계자(파트장 포함) or 관리자(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
    
    String designerID = "";             // 설계자 ID 
    String isAdmin = "N";               // 관리자 여부
    String isManager = "N";             // 파트장 여부
    String mhInputYN = "";              // 시수입력 가능 여부
    String terminationDate = "";        // 퇴사일(퇴사여부)
    String insaDepartmentCode = "";     // 부서(파트) 코드 - 인사정보의 코드

    String errStr = "";                 // DB Query 중 에러 발생 여부

    ArrayList departmentList = null;
    ArrayList factorCaseList = null;

    // DB에서 데이터 쿼리하여 항목들의 값 설정
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
<head><title>설계시수 DATA 관리</title></head>
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

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // 시수입력 가능한 사용자가 아닌 경우 Exit
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
                설계시수 DATA 관리
            </td>
            <td id="departmentTD" width="360">부서
                <input type="text" name="departmentList" value="" readonly style="width:260px;" onmouseover="showDeptHint(this);" />
                <input type="button" name="departmentButton" value="…" style="width=22px;" onclick="showDepartmentSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDepartmentList();" />
            </td>
            <td width="280">일자
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDataMgmtHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDataMgmtHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewDPInputsList();"/>
                <input type="button" name="SavaButton" value='저 장' class="button_simple" onclick="saveDPInputChange();"/>
            </td>
        </tr>

        <tr height="30">
            <td>호선
                <input type="text" name="projectList" value="" style="width:260px;" />
                <input type="button" name="projectButton" value="…" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="projectList.value=''" />
            </td>
            <td>사번
                <select name="designerList" style="width:160px;">
                    <option value="">&nbsp;</option>
                </select>
                <input type="text" name="designerInput" value="" style="width:80px;background-color:#e8e8e8;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <td>도면번호
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
                &nbsp;<!--<input type="button" name="reportButton" value='리포트' class="button_simple2" onclick="viewReport();"/>-->
            </td>
        </tr>

        <tr height="30">
            <td>적용 CASE
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
            <td>원인부서
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

    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    var deptCodeHintStr = "";

    // 부서 선택 창을 Show
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

    // 부서코드 부분 MouseOver 시 부서명을 힌트 형태로 표시
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

    // 부서코드 선택사항을 Clear
    function clearDepartmentList()
    {
        DPDataMgmtHeader.departmentList.value = "";
        deptCodeHintStr = "";
        departmentSelChanged();
    }

    // 날짜 출력 문자열을 형식화
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

    // From 날짜 변경 시 To 날짜는 해당 월 말일로 자동 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPDataMgmtHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPDataMgmtHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPDataMgmtHeader.projectList.value;
        var selectedProjects = window.showModalDialog("stxPECDPDataMgmt_SelectProject_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPDataMgmtHeader.projectList.value = selectedProjects;
    }

    // 부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
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

    // 도면번호 입력 시 다음 칸으로 자동 이동
    function drawingNoKeyup(inputObject, next)
    {
        inputObject.value = inputObject.value.toUpperCase();

        //var e = window.event;
        //if (e.keyCode != 9) { // Tab key down이면 무시
        //    DPDataMgmtHeader.all("drawingNo" + next).focus();
        //}
    }

    // 도면번호 입력을 모두 Clear
    function clearDrawingNo()
    {
        for (var i = 1; i <= 8; i++) {
            DPDataMgmtHeader.all("drawingNo" + i).value = "";
        }
    }

    // 조회 실행
    function viewDPInputsList()
    {
        //if (!checkInputs()) return;
        
        // 사용자 입력사항이 있으면 변경사항을 먼저 저장
        if (parent.DP_DATAMGMT_MAIN.DPDataMgmtMain != null) {
            var dataChangedCnt = parent.DP_DATAMGMT_MAIN.departmentChangedList.length;
            if (dataChangedCnt > 0) {
                var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 조회를 실행하시겠습니까?";
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

    // 부서 수정사항을 저장
    function saveDPInputChange()
    {
        parent.DP_DATAMGMT_MAIN.saveDepartmentChange();
    }

    //// 프린트(리포트 출력)
    //function viewReport()
    //{
    //    alert("구현(개발) 중...");
    //}

    // 검색일자를 기본 오늘날짜로 설정
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
    
    // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록
    parent.DP_DATAMGMT_MAIN.location = "stxPECDPDataMgmtMain_SP.jsp?firstCall=Y"; 

</script>

</html>