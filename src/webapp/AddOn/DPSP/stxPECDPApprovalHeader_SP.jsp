<%--  
§DESCRIPTION: 설계시수결재 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApprovalHeader.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // 접속자 ID
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    

    String employeeID = "";
    String userInfoStr = "";
    String deptInfoStr = "";
    String deptCode = "";
    String deptName = "";
    String userTitleStr = "";
    String userName = "";
    String isManager = "N";
    boolean isAdmin = false;       
    String terminationDate = "";
    ArrayList departmentList = null;

    String errStr = "";

    try {
        Map userInfoMap = getEmployeeInfo(loginID);
        if (userInfoMap != null) 
        {
            employeeID = loginID;

            deptCode = (String)userInfoMap.get("DEPT_CODE");
            deptName = (String)userInfoMap.get("DEPT_NAME");
            terminationDate = (String)userInfoMap.get("TERMINATION_DATE");

            deptInfoStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;";
            deptInfoStr += (String)userInfoMap.get("DEPT_NAME");
            
            userName = (String)userInfoMap.get("NAME");
            userInfoStr = employeeID + "&nbsp;&nbsp;&nbsp;&nbsp;" + userName;
            userTitleStr = (String)userInfoMap.get("TITLE");
            isManager = isDepartmentManagerYN(userTitleStr);

            if (((String)userInfoMap.get("IS_ADMIN")).equals("Y")) {
                isAdmin = true; 
                departmentList = getDepartmentList();
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
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (employeeID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed_SP.jsp";
    <% } %>

    // 매너저(파트장) 권한이 아니면 Exit
    <% if (!isManager.equals("Y") && !isAdmin) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

    // 퇴사자인 경우 Exit
    <% if (!terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2_SP.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalHeader">

    <input type="hidden" name="deptName" value="<%=deptName%>" />
    <input type="hidden" name="userName" value="<%=userName%>" />    
    <input type="hidden" name="userTitleStr" value="<%=userTitleStr%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />    

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="4" height="2"></td>
        </tr>
        <tr height="30">
            <td colspan="2" class="td_title">일일시수 결재관리</td>
            <td colspan="2" style="text-align: right">
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewPartPersons();"/>
                <input type="button" name="SavaButton" value='저 장' class="button_simple" onclick="saveApprovals();"/>
                <!--
                <input type="button" name="DeleteButton" value='삭 제' disabled class="button_simple" onclick="javascript:alert('삭제');"/>
                -->
            </td>
        </tr>
        <tr height="30">
            <td>부서
                <select name="departmentSel" style="width:250px;">
                    <% 
                    if (!isAdmin) { 
                    %>
                        <option value="<%=deptCode%>"><%=deptInfoStr%></option>
                    <% 
                    } else { 
                        for (int i = 0; i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCodeData = (String)map.get("DEPT_CODE");
                            String deptNameData = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCodeData + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptNameData;
                            String selected = ""; if (deptCode.equals(deptCodeData)) selected = "selected";
                            %>
                            <option value="<%=deptCodeData%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            
            </td>
            <td>&nbsp;<!--사번
                <select name="employeeIDSel" style="width:200px;" disabled>
                    <option value="<%=employeeID%>"><%=userInfoStr%></option>
                </select>
                -->
            </td>
            <td>일자
                <input type="text" name="dateSelected" value="" style="width:100px;" readonly="readonly">
                <a href="javascript:showCalendar('DPApprovalHeader', 'dateSelected', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;&nbsp;<input type="text" name="workingDayYN" value="" readonly style="width=80px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td>
                <input type="button" name="ApprovalsViewButton" value='결재조회' class="button_simple3" onclick="showApprovalsViewWin();"/>
                <input type="button" name="InputRateViewButton" value='입력율조회' class="button_simple3" onclick="showInputRateViewWin();"/>
                <input type="button" name="HolidayCheckButton" value='휴일체크' class="button_simple3" onclick="showHolidayCheckWin();"/>
            </td>
        </tr>
        <tr height="24">
            <td><b>[전체결재]</b>&nbsp;
                <input type="radio" name="ApprovalAllSelect" value="APPROVE_ALL" onClick="checkAll();" />선택&nbsp;
                <input type="radio" name="ApprovalAllSelect" value="APPROVE_NONE" onClick="unCheckAll();" />해제&nbsp;
            </td>
            <td><b>[부서정보]</b>&nbsp;
                총시수: <input name="workTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                정상: <input name="normalTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                연장: <input name="overtimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                특근: <input name="specialTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
            <td colspan="2"><b>[개인정보]</b>&nbsp;
                사번: <input name="personInfo" value="" readonly style="background-color:#D8D8D8;width:100px;border:0;color:#000000;;font-weight:bold;" />
                총시수: <input name="personWorkTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                정상: <input name="personNormalTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                연장: <input name="personOvertime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                특근: <input name="personSpecialTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
        </tr>
    </table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>
<script language="javascript">

    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지 
    document.onkeydown = keydownHandler;

    // 결재조회 화면 Show
    function showApprovalsViewWin() 
    {
        var sProperties = 'dialogHeight:300px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.callerObject = self;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_ApprovalListViewFS_SP.jsp", paramObj, sProperties);
    }

    // 입력율조회 화면 Show
    function showInputRateViewWin() 
    {
        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        var sProperties = 'dialogHeight:400px;dialogWidth:450px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.deptName = deptName;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_InputRateViewFS_SP.jsp", paramObj, sProperties);
    }

    // 휴일체크 화면 Show
    function showHolidayCheckWin() 
    {
        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        var sProperties = 'dialogHeight:300px;dialogWidth:440px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.deptName = deptName;
        }
        var dhHolidayCheckResult = window.showModalDialog("stxPECDPApproval_HolidayCheckFS_SP.jsp", paramObj, sProperties);
    }

    // 선택 일자 변경 시 처리, 특히 해당 일자의 평일/휴일 여부를 쿼리
    function dateChanged()
    {
        var tmpStr = DPApprovalHeader.dateSelected.value;
        if (tmpStr == null || tmpStr.trim() == "") return;

        // 저장버튼의 상태를 disabled로 초기화
        //DPApprovalHeader.SavaButton.disabled = true;

        // 날짜 출력 문자열을 형식화
        var dateStr = formatDateStr(tmpStr);
        DPApprovalHeader.dateSelected.value = dateStr;

        // 해당 날짜의 평일/휴일 여부와 시수결재 여부를 쿼리하여 표시
        DPApprovalHeader.workingDayYN.value = getWorkingDayYNString(DPApprovalHeader.dateSelected.value);

        viewPartPersons();
    }

    // 파트 구성원 목록을 조회
    function viewPartPersons()
    {
        // 화면의 관련 항목 초기화
        DPApprovalHeader.all('ApprovalAllSelect')[0].checked = false;
        DPApprovalHeader.all('ApprovalAllSelect')[1].checked = false;

        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        // 파트 구성원 목록을 쿼리
        var urlStr = "stxPECDPApprovalPersonSelect_SP.jsp?deptCode=" + DPApprovalHeader.departmentSel.value;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&dateSelected=" + DPApprovalHeader.dateSelected.value;
        urlStr += "&loginID=<%=loginID%>";
        parent.DP_APPR_PERSON.location = urlStr;

        parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain_SP.jsp"; 
    }

    // 시수결재 사항을 저장
    function saveApprovals()
    {
        parent.DP_APPR_PERSON.saveApprovals();
    }

    // 파트 구성원 목록의 모든 항목을 체크
    function checkAll()
    {
        parent.DP_APPR_PERSON.checkAll();
    }

    // 파트 구성원 목록의 모든 항목을 Un-check
    function unCheckAll()
    {
        parent.DP_APPR_PERSON.unCheckAll();
    }

    // 결재조회창에서 선택된 일자의 시수결재 사항을 조회
    function callViewDPApprovals(dateStr)
    {
        DPApprovalHeader.dateSelected.value = dateStr;
        dateChanged();
        viewPartPersons();
    }

    /* 화면(기능)이 실행되면 초기 상태를 오늘 날짜를 기준으로 설정하고 하위 창들을 로드 */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;
    DPApprovalHeader.dateSelected.value = ymd;
    dateChanged();
    // Header 페이지가 먼저 로드된 후 하위 창이 로드되도록
    //parent.DP_APPR_PERSON.location = "stxPECDPApprovalPersonSelect_SP.jsp"; 
    //parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain_SP.jsp"; 
    viewPartPersons();


</script>


</html>