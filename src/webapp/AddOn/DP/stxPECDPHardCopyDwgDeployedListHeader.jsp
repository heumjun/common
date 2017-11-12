<%--  
§DESCRIPTION: 도면 출도내역 조회 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgDeployedListHeader.jsp
§CHANGING HISTORY: 
§    2010-03-26: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    //String loginID = context.getUser(); // 접속자 ID : 설계자 or 관리자(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    
    
    String designerID = "";             // 설계자 ID 
    String isAdmin = "N";               // 관리자 여부
    String mhInputYN = "";              // 시수입력 가능 여부(이 권한은 공정입력 권한을 포함함)
    String progressInputYN = "";        // 공정입력 가능 여부
    String terminationDate = "";        // 퇴사일(퇴사여부)
    String insaDepartmentCode = "";     // 부서(파트) 코드 - 인사정보의 코드
    String insaDepartmentName = "";     // 부서(파트) 이름 - 인사정보의 이름
    String dwgDepartmentCode = "";      // 부서(파트) 코드 - 설계부서 코드

    String errStr = "";                 // DB Query 중 에러 발생 여부

    ArrayList departmentList = null;

    // DB에서 데이터 쿼리하여 항목들의 값 설정
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

            departmentList = getDepartmentList();

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 
            else if (designerID.equals("200043")) isAdmin = "Y"; // 조선해양연구소 이광일 과장
                                                                 // 연구소 Hard Copy 출도정보 조회가 필요하여 예외적으로 적용
        }
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }    

%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head><title>도면 출도내역 조회</title></head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // 관리자가 아닌 경우 Exit
    <% if (!isAdmin.equalsIgnoreCase("Y") || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPHardCopyDwgDeployedHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="6" height="2"></td>
        </tr>


        <tr height="30">
            <td class="td_title" width="110" rowspan="2">
                도면 출도내역<br>조 회
            </td>


            <td width="500">호선
                <input type="text" name="projectList" value="" style="width:220px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();"/>
                <input type="button" name="ProjectsButton" value="…" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="(입력 시 ',' 로 구분)" class="input_noBorder" 
                       style="width:110px;background-color: #D8D8D8;" />
                <% if (isAdmin.equals("Y")) { %>
                <input type="text" name="" value="[조회가능 호선관리]" class="input_noBorder" 
                                   style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" 
                                   onclick="showSearchableProjects();" />
                <% } %>
            </td>


            <td width="280">부서
                <select name="departmentList" style="width:220px;">
                    <% 
                    if (!isAdmin.equals("Y")) { 
                        String insaDepartmentStr = insaDepartmentCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + insaDepartmentName;
                    %>
                        <option value="<%=insaDepartmentCode%>"><%=insaDepartmentStr%></option>
                    <% 
                    } else { 
                        %>
                        <option value="">&nbsp;</option>
                        <%
                        for (int i = 0; departmentList != null && i < departmentList.size(); i++) {
                            Map map = (Map)departmentList.get(i);
                            String deptCode = (String)map.get("DEPT_CODE");
                            String deptName = (String)map.get("DEPT_NAME");
                            String upDeptName = (String)map.get("UP_DEPT_NAME");
                            String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                            String selected = ""; if (insaDepartmentCode.equals(deptCode)) selected = "selected";
                            %>
                            <option value="<%=deptCode%>" <%=selected%>><%=deptStr%></option>
                            <%
                        }
                     } 
                     %>
                </select>
            </td>


            <td width="320">기간                
                <input type="text" name="dateSelectedFrom" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgDeployedHeader', 'dateSelectedFrom', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" value="" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPHardCopyDwgDeployedHeader', 'dateSelectedTo', '', false, dateChanged);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                <!--
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" 
                       onclick="dateSelectedFrom.value='';dateSelectedTo.value='';" />
                -->
            </td>


            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewHardCopyDeployedData();"/>
            </td>
        </tr>


        <tr height="30">
            <td colspan="3">
                <input type="checkbox" name="chkboxIncludeSeries" value="">Series 포함&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="chkboxIncludeEarlyRev" value="">시공 전 개정도 포함
            </td>
        
            <td>
                <!--
                <input type="button" name="PrintButton" value='출 력' class="button_simple" onclick="viewReport();"/>
                -->
                &nbsp;
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록.
    parent.HARDCOPY_DEPLOYED_MAIN.location = "stxPECDPHardCopyDwgDeployedListMain.jsp?showMsg=false&firstLoad=true"; 

	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPHardCopyDwgDeployedHeader.projectList.value;
        paramStr += "&loginID=" + DPHardCopyDwgDeployedHeader.loginID.value;
        paramStr += "&category=DEPLOY";
        var selectedProjects = window.showModalDialog("stxPECDPProgressDeviationView_ProjectSelect.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPHardCopyDwgDeployedHeader.projectList.value = selectedProjects;
    }

    // 조회가능 호선관리 창을 Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPHardCopyDwgDeployedHeader.loginID.value;
        paramStr += "&category=DEPLOY";
        window.showModalDialog("stxPECDPProgressDeviation_ProjectSelect.jsp?" + paramStr, "", sProperties);
    }

    // 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr = DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgDeployedHeader.dateSelectedFrom.value = dateStr;
        }
        tmpStr = DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPHardCopyDwgDeployedHeader.dateSelectedTo.value = dateStr;
        }
    }

    // 조회
    function viewHardCopyDeployedData()
    {
        // 조회기간이 한 달 이내(Series 포함인 경우 1주일 이내)인지 체크
        var sDateFrom = DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        var sDateTo = DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        var tempArray = sDateFrom.split("-");
        var dateFromObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
        tempArray = sDateTo.split("-");
        var dateToObj = new Date(tempArray[0], tempArray[1] - 1, tempArray[2]);
        if (dateToObj - dateFromObj < 0) {
            var tempObj = dateFromObj;
            dateFromObj = dateToObj;
            dateToObj = tempObj;
        }
        var iDayDiff = (dateToObj - dateFromObj) / 86400000;
        if (!DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked && iDayDiff >= 31) {
            alert("조회기간은 한 달(31일)을 초과할 수 없습니다!");
            return;
        }
        else if (DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked && iDayDiff >= 7) {
            alert("Series 포함인 경우, 조회기간은 일주일(7일)을 초과할 수 없습니다!");
            return;
        }

        // 조회
        var urlStr = "stxPECDPHardCopyDwgDeployedListMain.jsp?projectList=" + DPHardCopyDwgDeployedHeader.projectList.value;
        urlStr += "&deptCode=" + DPHardCopyDwgDeployedHeader.departmentList.value;
        urlStr += "&dateFrom=" + DPHardCopyDwgDeployedHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + DPHardCopyDwgDeployedHeader.dateSelectedTo.value;
        urlStr += "&includeSeries=" + (DPHardCopyDwgDeployedHeader.chkboxIncludeSeries.checked ? "true" : "false");
        urlStr += "&includeEarlyRev=" + (DPHardCopyDwgDeployedHeader.chkboxIncludeEarlyRev.checked ? "true" : "false");
        urlStr += "&isAdmin=" + DPHardCopyDwgDeployedHeader.isAdmin.value;
        urlStr += "&showMsg=true&firstLoad=false";

        parent.HARDCOPY_DEPLOYED_MAIN.location = urlStr;
    }

    // 프린트(리포트 출력)
    function viewReport()
    {
        //
    }

    /* 화면(기능)이 실행되면 기본 조회기간을 1주 전 ~ 오늘날짜로 설정 */   
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    var d1 = today.getDate().toString();
    var oneWeekBefore = new Date(Date.parse(today) - 6 * 1000 * 60 * 60 * 24);
    var y2 = oneWeekBefore.getFullYear().toString();
    var m2 = (oneWeekBefore.getMonth() + 1).toString();
    var d2 = oneWeekBefore.getDate().toString();

    var toYMD = y1 + ". " + m1 + ". " + d1 + ".";
    var fromYMD = y2 + ". " + m2 + ". " + d2 + ".";    

    DPHardCopyDwgDeployedHeader.dateSelectedFrom.value = formatDateStr(fromYMD);
    DPHardCopyDwgDeployedHeader.dateSelectedTo.value = formatDateStr(toYMD);

</script>

</html>