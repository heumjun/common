<%--  
§DESCRIPTION: 설계시수입력 화면 Header Toolbar 부분 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInputHeader.jsp
§CHANGING HISTORY: 
§    2009-04-06: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    // FOR TEST
    // stx    TEST계정 : DPS 등록안된 사용자
    // PD0169 윤동철JI : 권한 없는 사용자
    // 206294 박대철GJ : 일반설계자(선장철의2P - 부서코드: 445200)
    // 206143 이창근GJ : 파트장(선장철의2P)
    // 196235 정병철CJ : 팀장(선장설계1팀)
    // 207027 한경훈JI : Admin.

    //String loginID = context.getUser(); // 접속자 ID : 설계자(파트장 포함) or 관리자(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");     

    String dpDesignerID = "";           // 설계자 ID : 시수조회 & 입력의 대상
    String dpDesignerName = "";         // 설계자 이름

    String insaDepartmentCode = "";     // 부서(파트) 코드 - 인사정보의 코드
    String insaDepartmentName = "";     // 부서(파트) 이름 - 인사정보의 이름
    String insaUpDepartmentName = "";   // 상위부서 이름

    boolean isAdmin = false;            // 관리자 여부
    boolean isManager = false;          // 파트장 여부
    String mhInputYN = "";              // 시수입력 가능 여부
    String terminationDate = "";        // 퇴사일(퇴사여부)

    ArrayList departmentList = null;      // 설계부서 목록 : 인사 DB 상의 부서목록 중 SDPS에 등록된 부서들의 정보를 추출한 정보 (Admin. Mode에서 사용)
    ArrayList personList = null;          // 지정된 부서 소속의 설계자 목록 (Admin. Mode에서 사용)
    String errStr = "";                 // DB Query 중 에러 발생 여부

    // DB에서 데이터 쿼리하여 항목들의 값 설정
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);
        if (loginUserInfo != null) 
        {
            // 시수조회 & 입력의 대상 설계자는 Login User를 초기값으로 한다
            // 일반 사용자인 경우 설계자와 Login User가 동일. Admin.인 경우 대상 설계자를 변경 가능함

            dpDesignerID = loginID;     
            dpDesignerName = (String)loginUserInfo.get("NAME");

            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            insaDepartmentName = (String)loginUserInfo.get("DEPT_NAME");
            insaUpDepartmentName = (String)loginUserInfo.get("UP_DEPT_NAME");

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = true; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            if ("Y".equals(isDepartmentManagerYN(titleStr))) isManager = true;

            if (isAdmin) 
            {
                departmentList = getDepartmentList();
                personList = getPartPersons(insaDepartmentCode);
            }            
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (dpDesignerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // 시수입력 가능한 사용자가 아닌 경우 Exit
    <% if (!mhInputYN.equalsIgnoreCase("Y") || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputHeader">
    
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />
    <input type="hidden" name="workdaysGap" value="" />


    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="5" height="2"></td>
        </tr>
        <tr height="40">
            <td colspan="2" class="td_title">시 수 입 력</td>
            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewDPInputs('');"/>
                <input type="button" name="SavaButton" value='저 장' class="button_simple" onclick="saveDPInputs();"/>
                <input type="button" name="DeleteButton" value='전체삭제' class="button_simple" onclick="deleteDPInputs();"/>
            </td>
            <td>&nbsp;
                <% if (isAdmin) { %>
                <input type="button" name="LockButton" value='시수입력 LOCK' class="button_simple" style="width:120px;" onclick="showDPInputLockWin();"/>
                <% } %>
            </td>
            <td>
                <input type="button" name="PrintButton" value='출력 & 엑셀' class="button_simple" style="width:100px;" onclick="printPage();"/>
                <!--<input type="button" name="ExcelButton" value='엑 셀' style="background-color:#ee4400" class="button_simple" onclick="javascript:alert('엑셀');"/>-->
            </td>
        </tr>
        <tr height="40">
            <td width="310">부서
                <select name="departmentSel" style="width:280px;" onchange="departmentSelChanged();">
                    <% 
                    if (!isAdmin) { 
                        String insaDepartmentStr = insaDepartmentCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*insaUpDepartmentName + "-" +*/ insaDepartmentName;
                    %>
                        <option value="<%=insaDepartmentCode%>|<%=insaDepartmentName%>"><%=insaDepartmentStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCode = (String)map.get("DEPT_CODE");
                            String deptName = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                            String selected = ""; if (insaDepartmentCode.equals(deptCode)) selected = "selected";
                            %>
                            <option value="<%=deptCode%>|<%=deptName%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td width="240">사번
                <select name="dpDesignerIDSel" style="width:200px;" onchange="dpDesignerSelChanged();">
                    <% 
                    if (!isAdmin) { 
                        String dpDesignerStr = dpDesignerID + "&nbsp;&nbsp;&nbsp;&nbsp;" + dpDesignerName;
                    %>
                        <option value="<%=dpDesignerID%>|<%=dpDesignerName%>"><%=dpDesignerStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < personList.size(); i++) {
                            Map map = (Map)personList.get(i);
                            String designerID = (String)map.get("EMPLOYEE_NO");
                            String designerName = (String)map.get("EMPLOYEE_NAME");
                            String designerStr = designerID + "&nbsp;&nbsp;&nbsp;&nbsp;" + designerName;
                            String selected = ""; if (dpDesignerID.equals(designerID)) selected = "selected";
                            %>
                            <option value="<%=designerID%>|<%=designerName%>" <%=selected%>><%=designerStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>
            <td>일자
                <input type="text" name="dateSelected" value="" style="width:100px;" readonly="readonly" />
                <a href="javascript:showCalendarWin();">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;&nbsp;<input type="text" name="workingDayYN" value="" readonly style="width=80px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>호선추가
                <input type="button" name="ProjectsButton" value="…" style="height:22px;width=22px;" onclick="showProjectSelectWin();"/>&nbsp;
                &nbsp;&nbsp;&nbsp;결재유무
                <input type="text" name="MHConfirmYN" value="" readonly style="width=20px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>
                <input type="button" name="DHViewButton" value='시수체크' class="button_simple2" onclick="showDesignHoursViewWin();"/>
                <input type="button" name="ApprovalViewButton" value='결재체크' class="button_simple2" onclick="showDesignHoursApprViewWin();"/>
            </td>
        </tr>
    </table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;

    // 메인화면 프린트
    function printPage()
    {
        parent.DP_MAIN.printPage();
    }

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("설계자를 먼저 선택하십시오.");
            return;
        }

        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "designerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
        var selectedProjects = window.showModalDialog("stxPECDPInput_ProjectSelect_SP.jsp?" + paramStr, "", sProperties);
        if (selectedProjects != null && selectedProjects != 'undefined') parent.DP_MAIN.changedSelectedProject(selectedProjects);
    }

    // 시수체크 화면 팝업
    function showDesignHoursViewWin() 
    {
        if (DPInputHeader.departmentSel.value == "" || DPInputHeader.dpDesignerIDSel.value == "") {
            alert("조회할 부서와 설계자를 먼저 선택하십시오.");
            return;
        }
    
        var urlStr = "stxPECDPInput_InputListViewFS_SP.jsp?loginID=" + DPInputHeader.loginID.value;
        var sProperties = 'dialogHeight:600px;dialogWidth:1200px;scroll=no;center:yes;resizable=no;status=no;';
        var dhCheckResult = window.showModalDialog(urlStr, "", sProperties);
    }

    // 결재체크 화면 팝업
    function showDesignHoursApprViewWin() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("조회할 설계자를 먼저 선택하십시오.");
            return;
        }

        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.userID = ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
            this.userName = ((DPInputHeader.dpDesignerIDSel.value).split("|"))[1];
            this.callerObject = self;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPInput_ApprovalsViewFS_SP.jsp", paramObj, sProperties);
    }

    var currentDate = "";
    var currentWorkingDayYN = "";
    var currentMHConfirmYN = "";
    var currentWorkdaysGap = "";

    // 달력창 Show
    function showCalendarWin()
    {
        currentDate = DPInputHeader.dateSelected.value;
        currentWorkingDayYN = DPInputHeader.workingDayYN.value;
        currentMHConfirmYN = DPInputHeader.MHConfirmYN.value;
        currentWorkdaysGap = DPInputHeader.workdaysGap.value;

        showCalendar('DPInputHeader', 'dateSelected', '', false, dateChanged);
    }

    // 선택 일자 변경 시 처리, 특히 해당 일자의 평일/휴일 여부와 결재여부를 쿼리
    function dateChanged()
    {
        var tmpStr = DPInputHeader.dateSelected.value;
        if (tmpStr == null || tmpStr.trim() == "") return;

        //// 저장버튼의 상태를 disabled로 초기화
        //DPInputHeader.SavaButton.disabled = true;

        // 날짜 출력 문자열을 형식화
        var dateStr = formatDateStr(tmpStr);
        DPInputHeader.dateSelected.value = dateStr;

        // 미래(오늘 후) 날짜 선택 시 메시지
        var today = new Date();
        var strs = dateStr.split("-");
        var selectedDate = new Date(strs[0], strs[1] - 1, strs[2]);
        if (today - selectedDate < 0) {
            DPInputHeader.dateSelected.value = currentDate;
            alert("오늘 날짜 또는 이전 날짜를 선택하십시오.");
            return;
        }
        var resultMsg = getDateDPInfo(((DPInputHeader.dpDesignerIDSel.value).split("|"))[0], DPInputHeader.dateSelected.value);
        if (resultMsg == "ERROR") {
            DPInputHeader.workingDayYN.value = "ERROR";
            DPInputHeader.MHConfirmYN.value = "ERROR";
        }
        else {
            strs = resultMsg.split("|");

            // 해당 일자 + Work Day 2일이 경과되었으면 오류, 일자를 Rollback
            var strs2 = strs[1].split("-");
            var dpInputLockDate = new Date(strs2[0], strs2[1] - 1, strs2[2]);
            //if (DPInputHeader.isAdmin.value != "true" && (selectedDate - dpInputLockDate < 0)) {
            //    DPInputHeader.dateSelected.value = currentDate;
            //    alert("입력 유효일자(기본: 해당일자 + Workday 2일)가 경과되었습니다.\n\n먼저 관리자에게 LOCK 해제를 요청하십시오.");
            //    return;
            //}

            if (strs[0] == 'Y') DPInputHeader.workingDayYN.value = "평일";
            else if (strs[0] == 'N') DPInputHeader.workingDayYN.value = "휴일";
            else DPInputHeader.workingDayYN.value = strs[0];
            DPInputHeader.workdaysGap.value = strs[1];
            DPInputHeader.MHConfirmYN.value = strs[2];
            //if (strs[1] != "Y") DPInputHeader.SavaButton.disabled = false;

            if (viewDPInputs("true") == false) {
                DPInputHeader.dateSelected.value = currentDate;
                DPInputHeader.workingDayYN.value = currentWorkingDayYN;
                DPInputHeader.MHConfirmYN.value = currentMHConfirmYN;
                DPInputHeader.workdaysGap.value = currentWorkdaysGap;
            }
        }
    }

    // 시수입력 사항을 저장
    function saveDPInputs()
    {
        parent.DP_MAIN.saveDPInputs();
    }

    // 선택된 날짜의 입력시수를 일괄 삭제
    function deleteDPInputs()
    {
        parent.DP_MAIN.deleteDPInputs();
    }

    // 결재체크창에서 선택된 일자의 시수입력 사항을 조회
    function callViewDPInputs(dateStr)
    {
        // TODO 선택된 일자가 LOCK 일자 내인지 검사

        var resultMsg = getDateDPInfo(((DPInputHeader.dpDesignerIDSel.value).split("|"))[0], dateStr);

        if (resultMsg == "ERROR") alert("ERROR!");
        else {
            var strs = resultMsg.split("|");

            var workingDayYN = strs[0];
            if (workingDayYN == 'Y') workingDayYN = "평일";
            else if (workingDayYN == 'N') workingDayYN = "휴일";

            viewDPInputs("false", dateStr, workingDayYN, strs[2], strs[1]);
        }
    }

    // 선택된 날짜의 시수입력 사항을 조회
    function viewDPInputs(showMsg, dateSelected, workingDayYN, MHConfirmYN, workdaysGap)
    {
        if (dateSelected == null || dateSelected == "") dateSelected = DPInputHeader.dateSelected.value;
        if (workingDayYN == null || workingDayYN == "") workingDayYN = DPInputHeader.workingDayYN.value;
        if (MHConfirmYN == null || MHConfirmYN == "") MHConfirmYN = DPInputHeader.MHConfirmYN.value;
        if (workdaysGap == null || workdaysGap == "") workdaysGap = DPInputHeader.workdaysGap.value;


        if (DPInputHeader.dpDesignerIDSel.value == "") {
            alert("조회할 설계자를 먼저 선택하십시오.");
            return false;
        }

        // 사용자 입력사항이 있으면 변경사항을 먼저 저장
        if (parent.DP_MAIN.DPInputMain != null) {
            var dataChanged = parent.DP_MAIN.DPInputMain.dataChanged.value;
            if (dataChanged == "true") {
                var msg = "변경된 내용이 있습니다!\n\n변경사항을 무시하고 조회를 실행하시겠습니까?";
                if (!confirm(msg)) return false;
            }
        }

        // 선택된 날짜의 시수입력 사항을 조회
        var urlStr = "stxPECDPInputMain_SP.jsp?deptCode=" + ((DPInputHeader.departmentSel.value).split("|"))[0];
        urlStr += "&deptName=" + escape(encodeURIComponent(((DPInputHeader.departmentSel.value).split("|"))[1]));
        urlStr += "&designerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0];
        urlStr += "&designerName=" + escape(encodeURIComponent(((DPInputHeader.dpDesignerIDSel.value).split("|"))[1]));
        urlStr += "&dateSelected=" + dateSelected;
        urlStr += "&workingDayYN=" + escape(encodeURIComponent(workingDayYN));
        urlStr += "&MHConfirmYN=" + MHConfirmYN;
        urlStr += "&workdaysGap=" + workdaysGap;
        urlStr += "&loginID=" + DPInputHeader.loginID.value;
        urlStr += "&showMsg=" + escape(encodeURIComponent(showMsg));
        parent.DP_MAIN.location = urlStr;

        return true;
    }

    // 관리자 모드에서 부서가 변경되면 사번과 관련된 항목들을 모두 초기화
    function departmentSelChanged() 
    {
        for (var i = DPInputHeader.dpDesignerIDSel.options.length - 1; i >= 0; i--) {
            DPInputHeader.dpDesignerIDSel.options[i] = null;
        }
        DPInputHeader.MHConfirmYN.value = "";

        // 선택된 부서(파트)의 구성원(파트원) 목록을 쿼리
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=GetPartPersons&departCode=" + ((DPInputHeader.departmentSel.value).split("|"))[0], false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    var strs = resultMsg.split("+");

                    var newOption = new Option("", "");
                    DPInputHeader.dpDesignerIDSel.options[0] = newOption;

                    for (var i = 0; i < strs.length; i++) {
                        var strs2 = strs[i].split("|");
                        newOption = new Option(strs2[0] + "    " + strs2[1], strs2[0] + "|" + strs2[1]);
                        DPInputHeader.dpDesignerIDSel.options[i + 1] = newOption;
                    }
                }
            }
            else {
                alert(resultMsg);
            }
        }
        else {
            alert(resultMsg);
        }
    }

    // 관리자 모드에서, 사번(설계자) 선택이 변경된 경우 변경된 사번의 데이터를 쿼리
    function dpDesignerSelChanged() 
    {
        if (DPInputHeader.dpDesignerIDSel.value == "") {
            DPInputHeader.MHConfirmYN.value = "";
        }
        else {
            // 해당 사번 + 날짜의 시수결재 여부를 쿼리하여 표시
            var xmlHttp;
            if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

            xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess_SP.jsp?requestProc=GetConfirmYN&dpDesignerID=" + ((DPInputHeader.dpDesignerIDSel.value).split("|"))[0] + 
                                "&dateStr=" + DPInputHeader.dateSelected.value, false);
            xmlHttp.send(null);

            if (xmlHttp.status == 200) {
                if (xmlHttp.statusText == "OK") {
                    var resultMsg = xmlHttp.responseText;
                    
                    if (resultMsg != null)
                    {
                        resultMsg = resultMsg.trim();
                        DPInputHeader.MHConfirmYN.value = resultMsg;
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
    }

    // 시수입력 LOCk 관리화면 팝업
    function showDPInputLockWin()
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;status=no;';
        var result = window.showModalDialog("stxPECDPInput_LockControl_SP.jsp", "", sProperties);
    }


    /* 화면(기능)이 실행되면 초기 상태를 오늘 날짜를 기준으로 설정하고 시수입력 창을 로드 */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;

    DPInputHeader.dateSelected.value = ymd;
    dateChanged();
    parent.DP_TIMESELECT.location = "stxPECDPInputTimeSelect_SP.jsp"; // Header 페이지가 먼저 로드된 후 Time Select 창이 로드되도록.
    viewDPInputs("false");

    showDesignHoursApprViewWin();

</script>

</html>