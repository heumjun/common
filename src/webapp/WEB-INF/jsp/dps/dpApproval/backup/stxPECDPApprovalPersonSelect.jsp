<%--  
§DESCRIPTION: 설계시수결재 화면 메뉴 부분 (설계자 선택 및 설계자 별 요약 정보 출력 부분)
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApprovalPersonSelect.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(request.getParameter("deptCode"));
    String deptName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("deptName")),"UTF-8");
    String dateSelected = StringUtil.setEmptyExt(request.getParameter("dateSelected"));
    String loginID = request.getParameter("loginID");

    String errStr = "";
    int listCount = 0;

    ArrayList personList = new ArrayList();
    try {
        if (!deptCode.equals("")) {
            personList = getPartPersonDPConfirms(deptCode, dateSelected);
            listCount = personList.size();
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    float workTimeSum = 0;
    float normalTimeSum = 0;
    float overtimeSum = 0;
    float specialTimeSum = 0;
%>


<%--========================== HTML HEAD ===================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPApprovalPersonSelect">

    <input type="hidden" name="listCount" value="<%=listCount%>" />
    <!-- <input type="hidden" name="dataChanged" value="false" /> -->


    <table width="100%" cellSpacing="1" cellpadding="0" border="0">
        <tr height="15">
            <td style="background-color:#ffffff;text-align:left;color:#A4AAA7;font-size:8pt;">
                <%=deptName%>&nbsp;:&nbsp;<%=dateSelected%>
            </td>
        </tr>
    </table>


    <%
    if (!errStr.equals("")) 
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="4" border="0">
            <tr>
                <td style="text-align:left;color:#ff0000;">
                    작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                    ※에러 메시지: <%=errStr%>                
                </td>
            </tr>
        </table>
    <%
    }
    else
    {
    %>
        <table class="insertArea">
            <tr>
                <!--<td width="8">&nbsp;</td>-->
                <th width="20">No</th>
                <th width="60">사번</th>
                <th width="60">성명</th>
                <th width="40">시수</th>
                <th width="30">FCT.</th>
                <th width="38">완료</th>
                <th width="30">결재</th>
            </tr>

            <%
            for (int i = 0; i < personList.size(); i++) 
            {
                Map map = (Map)personList.get(i);
                String empNo = (String)map.get("EMPLOYEE_NO");
                String empName = (String)map.get("EMPLOYEE_NAME");
                String workTime = (String)map.get("WORKTIME");
                String normalTime = (String)map.get("NORMAL");
                String overtime = (String)map.get("OVERTIME");
                String specialTime = (String)map.get("SPECIAL");
                String inputDoneYN = (String)map.get("INPUTDONE_YN");
                String confirmYN = (String)map.get("CONFIRM_YN");
                String mhFactor = (String)map.get("MH_FACTOR");
                if (mhFactor.equals("1.0")) mhFactor = "1";
                else if (mhFactor.equals("0.0")) mhFactor = "0";

                if (!workTime.equals("")) workTimeSum += Float.parseFloat(workTime);
                if (!normalTime.equals("")) normalTimeSum += Float.parseFloat(normalTime);
                if (!overtime.equals("")) overtimeSum += Float.parseFloat(overtime);
                if (!specialTime.equals("")) specialTimeSum += Float.parseFloat(specialTime);

                String disabled = "";
                String bgColor="";
                String checked = "";

                if (!inputDoneYN.equals("Y")) {
                    disabled = "disabled";
                    bgColor = "#BFFFEF";
                }
                if (confirmYN.equals("Y")) checked = "checked";  
                %>
                <tr style="background-color:#ffffff" OnMouseOver="this.style.backgroundColor='#ffff00'" OnMouseOut="this.style.backgroundColor='#ffffff'" 
                    onclick="viewDPInputs('<%=empNo%>', '<%=empName%>');">
                    <!--<td width="8" class="td_standard" bgcolor="#e5e5e5">&nbsp;</td>-->
                    <td><%=i + 1%></td>
                    <td><font color="blue"><%=empNo%></font></td>
                    <td><%=empName%></td>
                    <td><%=workTime%></td>
                    <td style="color:silver;"><%=mhFactor%></td>
                    <td style="background-color='<%=bgColor%>'"><%=inputDoneYN%></td>
                    <td><input type="checkbox" name="check<%=i%>" id="check<%=i%>" value="<%=empNo%>" <%=disabled%> <%=checked%> 
                                                   style="cursor:default;" onClick="releaseHeaderCheck();"/></td>
                </tr>    
                <%
            }
            %>
        </table>
    <%
    }
    %>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    // Header의 부서정보(부서의 시수 합게)를 업데이트
    if (DPApprovalPersonSelect.listCount.value > 0) {
        parent.DPApprovalHeader.workTimeTotal.value = '<%=workTimeSum%>';
        parent.DPApprovalHeader.normalTimeTotal.value = '<%=normalTimeSum%>';
        parent.DPApprovalHeader.overtimeTotal.value = '<%=overtimeSum%>';
        parent.DPApprovalHeader.specialTimeTotal.value = '<%=specialTimeSum%>';
    }

    // 체크박스 모두 선택
    function checkAll()
    {
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = document.getElementById("check" + i);
            if (ctrlObj.disabled != true) ctrlObj.checked = true;
        }
    }

    // 체크박스 모두 선택 해제
    function unCheckAll()
    {
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = document.getElementById("check" + i);
            if (ctrlObj.disabled != true) ctrlObj.checked = false;
        }
    }

    // 헤더의 전체결재 '선택', '해제' 체크박스의 체크를 해제... Unused
    function releaseHeaderCheck()
    {
        /*
        parent.DPApprovalHeader.all('ApprovalAllSelect')[0].checked = false;
        parent.DPApprovalHeader.all('ApprovalAllSelect')[1].checked = false;
        */
    }

    // 선택된 설계자의 시수입력 사항을 메인화면에 표시한다
    function viewDPInputs(empNo, empName)
    {
        // 화면의 관련 항목 초기화
        parent.DPApprovalHeader.personInfo.value = "";
        parent.DPApprovalHeader.personWorkTime.value = "";
        parent.DPApprovalHeader.personNormalTime.value = "";
        parent.DPApprovalHeader.personOvertime.value = "";
        parent.DPApprovalHeader.personSpecialTime.value = "";

        // 설계자의 시수입력 사항을 쿼리
        var urlStr = "stxPECDPApprovalMain.do?empNo=" + empNo + "&empName=" + escape(encodeURIComponent(empName)) + "&dateSelected=<%=dateSelected%>";
        urlStr += "&deptCode=<%=deptCode%>";
        parent.DP_APPR_MAIN.location = urlStr;
    }

    // 시수결재 사항을 저장
    function saveApprovals()
    {
        var toApplyStrs = "";
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = document.getElementById("check" + i);
            if (ctrlObj.disabled != true) { 
                if (toApplyStrs != "") toApplyStrs += ",";
                toApplyStrs += ctrlObj.value + "|" + (ctrlObj.checked ? "Y" : "N");
            }
        }

        if (toApplyStrs == "") {
            alert("적용할 대상이 하나도 없습니다!\n\n작업이 취소되었습니다.");
            return;
        }

        var allChecked = parent.document.getElementById('ApprovalAllSelect').checked ? "Y" : "N";
        
        // 저장 실행을 요청
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=SaveApprovals&applyStrs=" + toApplyStrs + 
                            "&dateStr=<%=dateSelected%>&loginID=<%=loginID%>&deptCode=<%=deptCode%>&allChecked=" + allChecked, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;

                if (resultMsg != null && resultMsg.trim() == "") {
                    alert("시수결재 저장 완료");
                }
                else if (resultMsg != null && resultMsg.trim() != "") {
                    alert("시수결재 저장 완료\n\n" + resultMsg.trim());
                    parent.viewPartPersons();
                }
                else alert("ERROR");
            }
            else alert("ERROR"); 
        }
        else alert("ERROR"); 
    }


</script>

</html>