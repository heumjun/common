<%--  
§DESCRIPTION: 설계시수결재 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApprovalMain.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
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
    String empNo = StringUtil.setEmptyExt(emxGetParameter(request, "empNo"));
    String empName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "empName")),"UTF-8");
    String dateSelected = StringUtil.setEmptyExt(emxGetParameter(request, "dateSelected"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));

    int deptGubun = 0;

    String errStr = "";

    ArrayList dpInputList = new ArrayList();
    ArrayList dwgOvertimeList = null;
    try {
        if (!empNo.equals("")) {
            dpInputList = getDesignMHInputs(empNo, dateSelected);
            
            deptGubun = getDwgDeptGubun(deptCode);
            if (deptGubun == 2) // 해양부서인 경우, 계획시수 초과된 시수내역을 조회하여 화면에 표시
            {
                dwgOvertimeList = getDwgMH_Overtime(empNo, dateSelected);
            }
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
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPApprovalMain">

    <table width="100%" cellSpacing="1" cellpadding="0" border="0">
        <tr height="15">
            <td class="td_standard" style="text-align:left;color:#A4AAA7;font-size:8pt;">
                <%=empNo%>&nbsp;<%=empName%>&nbsp;:&nbsp;<%=dateSelected%>
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
        <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
            <tr height="20" bgcolor="#e5e5e5">
                <td width="8" class="td_standardBold">&nbsp;</td>
                <td width="20" class="td_standardBold">No</td>
                <td width="40" class="td_standardBold">시각</td>
                <td width="60" class="td_standardBold">공사번호</td>
                <td width="80" class="td_standardBold">도면번호</td>
                <td class="td_standardBold">OP</td>
                <td width="70" class="td_standardBold">원인부서</td>
                <td class="td_standardBold">관련근거</td>
                <td class="td_standardBold">업무내용</td>
                <td width="80" class="td_standardBold">Event1</td>
                <td width="80" class="td_standardBold">Event2</td>
                <td width="80" class="td_standardBold">Event3</td>
                <td width="40" class="td_standardBold">선종</td>
                <td width="30" class="td_standardBold">시수</td>
            </tr>

            <%
            for (int i = 0; i < dpInputList.size(); i++) 
            {
                Map map = (Map)dpInputList.get(i);
                String sTimeData = (String)map.get("START_TIME");
                String projectNoData = (String)map.get("PROJECT_NO");
                String dwgCodeData = (String)map.get("DWG_CODE");
                String opCodeData = (String)map.get("OP_CODE") + ":" + (String)map.get("OP_STR");
                String causeDepartData = (String)map.get("CAUSE_DEPART");
                String basisData = (String)map.get("BASIS");
                String workDescData = (String)map.get("WORK_DESC");
                String normalTime = (String)map.get("NORMAL");
                String overtime = (String)map.get("OVERTIME");
                String specialTime = (String)map.get("SPECIAL");
                String event1 = (String)map.get("EVENT1");
                String event2 = (String)map.get("EVENT2");
                String event3 = (String)map.get("EVENT3");
                String shipType = (String)map.get("SHIP_TYPE");
                if (!event1.equals("")) event1 += ":" + (String)map.get("EVENT1_STR");
                if (!event2.equals("")) event2 += ":" + (String)map.get("EVENT2_STR");
                if (!event3.equals("")) event3 += ":" + (String)map.get("EVENT3_STR");

                float workTime = Float.parseFloat(normalTime) + Float.parseFloat(overtime) + Float.parseFloat(specialTime);
                String workTimeStr = "";
                if (workTime > 0) workTimeStr = Float.toString(workTime);

                if (!normalTime.equals("")) normalTimeSum += Float.parseFloat(normalTime);
                if (!overtime.equals("")) overtimeSum += Float.parseFloat(overtime);
                if (!specialTime.equals("")) specialTimeSum += Float.parseFloat(specialTime);

                %>
                <tr height="20" bgcolor="#ffffff" onclick="updateDrawingInfo('<%=projectNoData%>', '<%=dwgCodeData%>');">
                    <td width="5" class="td_standard" bgcolor="#eeeeee">&nbsp;</td>
                    <td class="td_standard"><%=i + 1%></td>
                    <td class="td_standard"><font color="blue"><%=sTimeData%></font></td>
                    <td class="td_standard"><%=projectNoData%></td>
                    <td class="td_standard"><%=dwgCodeData%></td>
                    <td class="td_standard" style="padding-left:4px;text-align:left;"><%=opCodeData%></td>
                    <td class="td_standard"><%=causeDepartData%></td>
                    <td class="td_standardLeft" style="padding-left:4px;"><%=basisData%></td>
                    <td class="td_standardLeft" style="padding-left:4px;"><%=workDescData%></td>
                    <td class="td_standardLeft" style="padding-left:4px;"><%=event1%></td>
                    <td class="td_standardLeft" style="padding-left:4px;"><%=event2%></td>
                    <td class="td_standardLeft" style="padding-left:4px;"><%=event3%></td>
                    <td class="td_standard"><%=shipType%></td>
                    <td class="td_standard"><%=workTimeStr%></td>
                </tr>
                <%
            }
            workTimeSum = normalTimeSum + overtimeSum + specialTimeSum;
            %>
        </table>


        <%

        /* 해양부서인 경우, 계획시수 초과된 시수내역을 조회하여 화면에 표시 */

        if (deptGubun == 2 && dwgOvertimeList != null && dwgOvertimeList.size() > 0) 
        {
            boolean isOvertimeExist = false;
            for (int i = 0; i < dwgOvertimeList.size(); i++)
            {
                Map map = (Map)dwgOvertimeList.get(i);
                String diffMH = (String)map.get("DIFF_MH");
                if (!StringUtil.isNullString(diffMH)) {
                    isOvertimeExist = true;
                    break;
                }
            }

            if (isOvertimeExist)
            {
                %>
                <br><br><br>
                <hr align="left" style="width:394px; height: 3px; color:#ff0000; border-style:dotted">
                <font color="#ff0000"><b>계획시수 대비 초과 내역: </b></font>
                <span style="width:100%;align:center;">
                <table cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
                    <tr height="20" bgcolor="#e5e5e5">
                        <td width="8" class="td_standardBold">&nbsp;</td>
                        <td width="60" class="td_standardBold">공사번호</td>
                        <td width="80" class="td_standardBold">도면번호</td>
                        <td width="80" class="td_standardBold">계획시수</td>
                        <td width="80" class="td_standardBold">실적시수</td>
                        <td width="80" class="td_standardBold">초과시수</td>
                    </tr>

                    <%
                    for (int i = 0; i < dwgOvertimeList.size(); i++)
                    {
                        Map map = (Map)dwgOvertimeList.get(i);
                        String projectNo = (String)map.get("PROJECT_NO");
                        String dwgCode = (String)map.get("DWG_CODE");
                        String planMH = (String)map.get("PLAN_MH");
                        String actualMH = (String)map.get("ACTUAL_MH");
                        String diffMH = (String)map.get("DIFF_MH");

                        String tdBgColor = "#ffffff";
                        if (!StringUtil.isNullString(diffMH)) tdBgColor = "#ff0000";
                        
                        %>
                        <tr height="20" bgcolor="#ffffff">
                            <td class="td_standard" bgcolor="#eeeeee">&nbsp;</td>
                            <td class="td_standard"><%=projectNo%></td>
                            <td class="td_standard"><%=dwgCode%></td>
                            <td class="td_standard"><%=planMH%></td>
                            <td class="td_standard"><%=actualMH%></td>
                            <td class="td_standard" bgcolor="<%=tdBgColor%>"><%=diffMH%></td>
                        </tr>
                        <%
                    }
                    %>
                </table>
                </span>
                <hr align="left" style="width:394px; height: 3px; color:#ff0000; border-style:dotted">
                <%
            }
        }

        %>

    <%
    }
    %>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // TODO alert("조회 완료");

	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    // Header의 개인정보를 업데이트
    <% if (!empNo.equals("")) { %>
        parent.DP_APPR_HEADER.DPApprovalHeader.personInfo.value = '<%=empNo%> <%=empName%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.personWorkTime.value = '<%=workTimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.personNormalTime.value = '<%=normalTimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.personOvertime.value = '<%=overtimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.personSpecialTime.value = '<%=specialTimeSum%>';
    <% } else { %>
        parent.DP_APPR_HEADER.DPApprovalHeader.personInfo.value = '';
        parent.DP_APPR_HEADER.DPApprovalHeader.personWorkTime.value = '';
        parent.DP_APPR_HEADER.DPApprovalHeader.personNormalTime.value = '';
        parent.DP_APPR_HEADER.DPApprovalHeader.personOvertime.value = '';
        parent.DP_APPR_HEADER.DPApprovalHeader.personSpecialTime.value = '';
    <% } %>

    // Bottom 의 DP 공정 정보 업데이트
    function updateDrawingInfo(projectNo, drawingNo)
    {
        parent.DP_BOTTOM.updateDrawingInfo(projectNo, drawingNo);
    }

</script>


</html>