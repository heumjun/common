<%--  
§TITLE: 부서 별 시수조회 화면 Header 부분
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPDepartmentDataNewHeader.jsp
§CHANGING HISTORY: 
§    2014-12-29: Initiative
§DESCRIPTION:
    ......
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include.inc" %>

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

    ArrayList factorCaseList = null;

    // DB에서 데이터 쿼리하여 항목들의 값 설정
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");

            factorCaseList = getMHFactorCaseAndValueList();

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            String titleStr = (String)loginUserInfo.get("TITLE");
            isManager = isDepartmentManagerYN(titleStr);
            if (isTeamManager(titleStr)) insaDepartmentCode = getPartListUnderTeamStr(insaDepartmentCode);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }    
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>부서 별 설계시수 조회</title></head>
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
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // 시수입력 가능한 사용자가 아닌 경우 Exit
    <% if ((!isManager.equalsIgnoreCase("Y") && !isAdmin.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPDepartmentDataHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">

        <tr>
            <td colspan="5" height="2"></td>
        </tr>

        <tr height="30">
            <td class="td_title" width="300">
                부서 별 시수조회
            </td>
            <td id="departmentTD" width="400">부서
                <% if (isAdmin.equals("Y")) { %>
                    <input type="text" name="departmentList" value="" readonly style="width:260px;" onmouseover="showDeptHint(this);" />
                    <input type="button" name="departmentButton" value="…" style="width=22px;" onclick="showDepartmentSelectWin();"/>
                    <input type="text" name="" value="clear" class="input_noBorder" 
                           style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="clearDepartmentList();" />
                <% } else { %>
                    <input type="text" name="departmentList" value="<%=insaDepartmentCode%>" readonly style="width:260px;" />
                <% } %>
            </td>
            <td width="360">일자
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDepartmentDataHeader', 'dateSelectedFrom', '', false, dateChangedFrom);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPDepartmentDataHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewDPInputsList();"/>
            </td>
        </tr>

        <tr height="30">
            <td>
                &nbsp;
            </td>
            <td>적용 CASE
                <%
                String disableStr = "disabled";
                if (isAdmin.equals("Y") || isManager.equals("Y")) disableStr = "";
                %>
                <select name="factorCaseList" style="width:280px;" <%= disableStr %>>
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
            <td>&nbsp;
            </td>
            <td>
                <input type="button" name="reportButton" value='리포트' class="button_simple2" onclick="viewReport();"/>
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
        var paramStr = "selectedDepartments=" + DPDepartmentDataHeader.departmentList.value;
        var selectedDepartmentsStr = window.showModalDialog("stxPECDPDataMgmt_SelectDepartment.jsp?" + paramStr, "", sProperties);

        if (selectedDepartmentsStr != null && selectedDepartmentsStr != 'undefined') 
        {
            var strs = selectedDepartmentsStr.split("|");
            DPDepartmentDataHeader.departmentList.value = strs[0];
            deptCodeHintStr = "";
            if (strs[1] != "") {
                var strs2 = strs[1].split(",");
                for (var i = 0; i < strs2.length; i++) {
                    deptCodeHintStr += strs2[i];
                    deptCodeHintStr += ";&nbsp;&nbsp;";
                }
            }
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
        DPDepartmentDataHeader.departmentList.value = "";
        deptCodeHintStr = "";
    }

    // 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr = DPDepartmentDataHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPDepartmentDataHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPDepartmentDataHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPDepartmentDataHeader.dateSelectedTo.value = dateStr;
        }
    }

    // From 날짜 변경 시 To 날짜는 해당 월 말일로 자동 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPDepartmentDataHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPDepartmentDataHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPDepartmentDataHeader.projectList.value;
        var selectedProjects = window.showModalDialog("stxPECDPDataMgmt_SelectProject.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPDepartmentDataHeader.projectList.value = selectedProjects;
    }

    // 조회 실행
    function viewDPInputsList()
    {
        var departmentStr = DPDepartmentDataHeader.departmentList.value.trim();
        /*
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }
        */


        var urlStr = "stxPECDPDepartmentDataNewMain.jsp?";
        urlStr += "&deptCode=" + departmentStr;
        urlStr += "&dateFrom=" + DPDepartmentDataHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPDepartmentDataHeader.dateSelectedTo.value;
        urlStr += "&factorCase=" + DPDepartmentDataHeader.factorCaseList.value;
        urlStr += "&firstCall=N";
        parent.DP_DPTDATA_MAIN.location = urlStr;
    }

    // 프린트(리포트 출력)
    function viewReport()
    {
    /**********
        var departmentStr = DPDepartmentDataHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }
        var projectStr = DPDepartmentDataHeader.projectList.value.trim();
        if (projectStr != "") {
            var strs = projectStr.split(",");
            projectStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectStr += ",";
                projectStr += "'" + strs[i].trim() + "'";
            }
        }

        var yearMonthStr = DPDepartmentDataHeader.dateSelectedFrom.value;
        var tempStrs = yearMonthStr.split("-");
        yearMonthStr = tempStrs[0] + "." + tempStrs[1];

        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/";
        urlStr += "stxPECDPDepartmentDataView.mrd&param=";
        urlStr += DPDepartmentDataHeader.dateSelectedFrom.value + ":::";
        urlStr += DPDepartmentDataHeader.dateSelectedTo.value + ":::";
        urlStr += departmentStr + ":::";
        urlStr += projectStr + ":::";
        urlStr += DPDepartmentDataHeader.factorCaseList.value + ":::";
        urlStr += yearMonthStr + ":::";
        urlStr += projectStr == "" ? "ALL" : "SELECTED";
        window.open(urlStr, "", "");
        *********/
        
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDPDEV/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDPDEV/mrd/";
        urlStr += "LoadDeptMhRpt.mrd&param=";
        urlStr += DPDepartmentDataHeader.dateSelectedFrom.value + ":::";
        urlStr += DPDepartmentDataHeader.dateSelectedTo.value + ":::";
        urlStr += DPDepartmentDataHeader.departmentList.value + ":::";
        urlStr += DPDepartmentDataHeader.factorCaseList.value + ":::";
        window.open(urlStr, "", "");        
    }

    /* 화면(기능)이 실행되면 초기 상태를 해당 월 1일 ~ 해당 월 말일 기준으로 설정 */   
    // 해당 월 1일(오늘이 1 ~ 10일 이면 전월 적용)
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    var d1 = today.getDate().toString();
    if (eval(d1) <= 10) {
        if (eval(m1) == 1) {
            m1 = "12";
            y1 = (today.getFullYear() - 1).toString();
        }
    }
    if (m1.length == 1) m1 = 0 + m1;
    if (d1.length == 1) d1 = 0 + d1;

    var fromYMD = y1 + "-" + m1 + "-01";    
    var maxDay = getMonthMaxDay(fromYMD);
    var toYMD = y1 + "-" + m1 + "-" + maxDay;

    DPDepartmentDataHeader.dateSelectedFrom.value = fromYMD;
    DPDepartmentDataHeader.dateSelectedTo.value = toYMD;
    
    // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록
    parent.DP_DPTDATA_MAIN.location = "stxPECDPDepartmentDataNewMain.jsp?firstCall=Y"; 

</script>

</html>