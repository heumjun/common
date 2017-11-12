<%--  
§DESCRIPTION: 설계시수결재 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApprovalHeader.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<style type="text/css">
aaa {color:#990000; font-weight : bold;}
</style>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (employeeID.equals("")) { %>
    self.location = "/AddOn/DP/stxPECDP_LoginFailed.jsp";
    <% } %>

    // 매너저(파트장) 권한이 아니면 Exit
    <% if (!isManager.equals("Y") && !isAdmin) { %>
    //self.location = "/AddOn/DP/stxPECDP_LoginFailed2.jsp";
    <% } %>

    // 퇴사자인 경우 Exit
    <% if (!terminationDate.equals("")) { %>
    self.location = "/AddOn/DP/stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>

<%--========================== HTML BODY ===================================--%>
<body>
<div class="mainDiv" id="mainDiv">
	<div class="subtitle">
		일일시수 결재관리 <span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
	</div>
	
<form name="DPApprovalHeader">
    <input type="hidden" name="deptName" value="<%=deptName%>" />
    <input type="hidden" name="userName" value="<%=userName%>" />    
    <input type="hidden" name="userTitleStr" value="<%=userTitleStr%>" />
    <input type="hidden" name="isManager" value="<%=isManager%>" />    

    <table class="searchArea conSearch">
        <tr>
            <th width="50px">부서</th>
            <td width="270px"><select name="departmentSel" style="width:250px;">
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
            <th width="50px">일자</th>
            <td width="210px">
                <input type="text" name="dateSelected" id="dateSelected" value="" style="width:100px;" onchange="dateChanged();" readonly="readonly">
                <input type="text" name="workingDayYN" value="" readonly style="width=80px;background:#c8c8c4;font-weight:bold;" />
            </td>
            <td style="border-right: none">
                <input type="button" name="ApprovalsViewButton" value='결재 조회' class="btn_blue" onclick="showApprovalsViewWin();"/>
                <input type="button" name="InputRateViewButton" value='입력율 조회' class="btn_blue" onclick="showInputRateViewWin();"/>
                <input type="button" name="HolidayCheckButton" value='휴일 체크' class="btn_blue" onclick="showHolidayCheckWin();"/>
            </td>
            <td class="end" style="border-left: none">
					<div class="button endbox">
						<input type="button" name="ViewButton" value='조 회' class="btn_blue" onclick="viewPartPersons();"/>
		                <input type="button" name="SavaButton" value='저 장' class="btn_blue" onclick="saveApprovals();"/>
		                <!--
		                <input type="button" name="DeleteButton" value='삭 제' disabled class="button_simple" onclick="javascript:alert('삭제');"/>
		                -->
					</div>
			</td>
        </tr>
	</table>
	<iframe name="ApprovalBoardFrame" src="" width="100%" height="112" marginwidth="0" marginheight="0" frameborder="0" scrolling=no></iframe>
	<table class="searchArea2">
        <tr>
        	<th>[전체결재]</th>
            <td><input type="checkBox" name="ApprovalAllSelect" id="ApprovalAllSelect" value="APPROVE_ALL" onClick="checkAll();" />선택&nbsp;
                <!-- <input type="radio" name="ApprovalAllSelect2" id="ApprovalAllSelect2" value="APPROVE_NONE" onClick="unCheckAll();" />해제&nbsp; -->
            </td>
            <th>[부서정보]</th>
            <td>
                총시수: <input type="text" name="workTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                정상: <input type="text" name="normalTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                연장: <input type="text" name="overtimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                특근: <input type="text" name="specialTimeTotal" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
            <th>[개인정보]</th>
            <td>
                사번: <input type="text" name="personInfo" value="" readonly style="background-color:#D8D8D8;width:100px;border:0;color:#000000;;font-weight:bold;" />
                총시수: <input type="text" name="personWorkTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#ff0000;;font-weight:bold;" />
                정상: <input type="text" name="personNormalTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                연장: <input type="text" name="personOvertime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
                특근: <input type="text" name="personSpecialTime" value="" readonly style="background-color:#D8D8D8;width:40px;border:0;color:#0000ff;;font-weight:bold;" />
            </td>
        </tr>
    </table>
</form>
	<table height="100%">
		<tr>
			<td width=250px>
				<iframe id="DP_APPR_PERSON" src="" frameborder=0 marginwidth=0 marginheight=0 width=100% 
					style="margin-top: 5px;background-color:#fcffff;border:1px solid #c3c3c3;"></iframe>			
			</td>
			<td>
				<iframe id="DP_APPR_MAIN" name="DP_APPR_MAIN" src="" frameborder=0 marginwidth=0 marginheight=0 width=100%
		style="margin-top: 5px; float: right;background-color:#fcffff;border:1px solid #c3c3c3;"></iframe>
			</td>
		</tr>
	</table>
</div>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript">
	$(function() {
		$("#dateSelected").datepicker({
			dateFormat : 'yy-mm-dd',
			monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
			dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],
	
			changeMonth : true, //월변경가능
			changeYear : true, //년변경가능
			showMonthAfterYear : true, //년 뒤에 월 표시
		});
		
		$(window).bind('resize', function() {
			 $('#DP_APPR_PERSON').css('height', $(window).height()-300);
	         $('#DP_APPR_MAIN').css('height', $(window).height()-300);
	     }).trigger('resize');
		
	});
    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지 
    document.onkeydown = keydownHandler;

    // 결재조회 화면 Show
    function showApprovalsViewWin() 
    {
        var sProperties = 'dialogHeight:310px;dialogWidth:350px;scroll=no;center:yes;resizable=no;status=no;';
        var paramObj = new function() {
            this.deptCode = DPApprovalHeader.departmentSel.value;
            this.callerObject = self;
        }
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_ApprovalListViewFS.do", paramObj, sProperties);
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
        var dhApprCheckResult = window.showModalDialog("stxPECDPApproval_InputRateViewFS.do", paramObj, sProperties);
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
        var dhHolidayCheckResult = window.showModalDialog("stxPECDPApproval_HolidayCheckFS.do", paramObj, sProperties);
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
        document.getElementById('ApprovalAllSelect').checked = false;
        /* document.getElementById('ApprovalAllSelect2').checked = false; */

        var deptName = DPApprovalHeader.departmentSel.options[DPApprovalHeader.departmentSel.selectedIndex].text;
        deptName = deptName.substring(10, deptName.length);

        // 파트 구성원 목록을 쿼리
        var urlStr = "stxPECDPApprovalPersonSelect.do?deptCode=" + DPApprovalHeader.departmentSel.value;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&dateSelected=" + DPApprovalHeader.dateSelected.value;
        urlStr += "&loginID=<%=loginID%>";
        //parent.DP_APPR_PERSON.location = urlStr;
        $("#DP_APPR_PERSON").attr("src", urlStr);
        //parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain.jsp"; 
        $("#DP_APPR_MAIN").attr("src", "stxPECDPApprovalMain.do");
        // 결재 현황판 목록을 재조회
        viewApprovalBoard();
    }
    
    // 결재 현황판 목록을 조회
    function viewApprovalBoard()
    {
    
    	var tmpStr = DPApprovalHeader.dateSelected.value;
    	
        var urlStr = "stxPECDPApprovalBoard.do?deptCode=" + DPApprovalHeader.departmentSel.value;
        urlStr += "&dateSelected=" + DPApprovalHeader.dateSelected.value;    	
        urlStr += "&loginID=<%=loginID%>";
        ApprovalBoardFrame.location = urlStr;
        
    }    

    // 시수결재 사항을 저장
    function saveApprovals()
    {
    	frames['DP_APPR_PERSON'].saveApprovals();
    }

    // 파트 구성원 목록의 모든 항목을 체크
    function checkAll()
    {
    	if(document.getElementById('ApprovalAllSelect').checked){
    		frames['DP_APPR_PERSON'].checkAll();
    	} else {
    		frames['DP_APPR_PERSON'].unCheckAll();
    		
    	}
    }

    // 파트 구성원 목록의 모든 항목을 Un-check
    function unCheckAll()
    {
        frames['DP_APPR_PERSON'].unCheckAll();
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
    //parent.DP_APPR_PERSON.location = "stxPECDPApprovalPersonSelect.jsp"; 
    //parent.DP_APPR_MAIN.location = "stxPECDPApprovalMain.jsp"; 
    viewPartPersons();


</script>


</html>