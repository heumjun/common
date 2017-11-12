<%--  
§DESCRIPTION: 설계시수입력 화면 메뉴 부분((시각/항목 선택)
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInputTimeSelect.jsp
§CHANGING HISTORY: 
§    2009-04-07: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
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
<body style="background-color: #E8E8E8;">
<form name="DPInputTimeSelect">

<table width="100%" height="100%" cellSpacing="2" cellpadding="1" border="1" align="center">
    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="3" border="0" align="center">
                <tr height="12">
                    <td></td>
                </tr>
                <tr height="20">
                    <td class="td_timeselect"><font color="gray">A.M</font></td>
                    <td class="td_timeselect"><font color="gray">P.M</font></td>
                    <td class="td_timeselect"><font color="gray">연장</font></td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" style="cursor:default;">08:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1300');">13:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1800');">18:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0830');">08:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1330');">13:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1830');">18:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0900');">09:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1400');">14:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1900');">19:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0930');">09:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1430');">14:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1930');">19:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1000');">10:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1500');">15:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2000');">20:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1030');">10:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1530');">15:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2030');">20:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1100');">11:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1600');">16:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2100');">21:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1130');">11:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1630');">16:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2130');">21:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1200');">12:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1700');">17:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2200');">22:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" style="cursor:default;"><!--12:30--></td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1730');">17:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2230');">22:30</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2300');">23:00</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2330');">23:30</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2400');">24:00</td>
                </tr>
            </table>
        </td>
    </tr>

    <!--
    <tr height="8" valign="top">
        <td></td>
    </tr>
    -->

    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="2" border="1" align="center">
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWork();">퇴근</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarly();">조퇴</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarlyAfterSeaTrial();">시운전 후 조기퇴근(평일)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarlyAfterSeaTrial('숙직 후 조기퇴근(평일)');">숙직 후 조기퇴근(평일)</td>
                </tr>
            </table>
        </td>
    </tr>

    <!--
    <tr height="4" valign="top">
        <td></td>
    </tr>
    -->

    <tr height="16">
        <td class="td_timeselect" style="font-size:10pt;border:#D8D8D8 0px solid;vertical-align:bottom;font-weight:bold;">
        1 일 이상<br><font style="font-size:8pt;">[미래 일자 입력 가능]</font>
        </td>
    </tr>

    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="2" border="1" align="center">
                <!--
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'">숙직 후 조기퇴근</td>
                </tr>
                -->
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('97');">년차</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('94');">특별휴가</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJobWithProject('36');">사외 협의 검토<br>(공사관련 출장)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJob('72');">기술회의 및 교육<br>(사내외)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJob('81');">일반출장<br>(기술소위원회, 세미나)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsSeaTrial();">시운전</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('93');">예비군 훈련(9H)</td>
                </tr>
                <!--
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="copyYesterdayMH();">전일시수 COPY</td>
                </tr>
                -->
            </table>
        </td>
    </tr>

    <tr height="4" valign="top">
        <td></td>
    </tr>

    <tr valign="top">
        <td width="100%" style="font-family:맑은 고딕,돋움체;font-size:8pt;">
            <table width="100%" cellSpacing="0" cellpadding="1" style="border:#000000 1px solid;background-color:#cccccc;">
                <tr>
                    <td colspan="3" style="text-align:center;">담당자</td>
                </tr>
                <tr>
                    <td>조선&nbsp;</td>
                    <td>한경훈 대리</td>
                    <td>T.#62+3220</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>김지수 주임</td>
                    <td>T.#62+5780</td>
                </tr>
                <tr>
                    <td>해양&nbsp;</td>
                    <td>김현주 과장</td>
                    <td>T.#60+2163</td>
                </tr>
            </table>
        </td>
    </tr>

    <tr height="100%" valign="top">
        <td ></td>
    </tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;

    // 시수 저장 전에 결재여부 체크
    function checkMHConfirmYN()
    {
        if (parent.DP_HEADER.DPInputHeader.isAdmin.value != "true" && parent.DP_MAIN.DPInputMain.MHConfirmYN.value == "Y") {
            alert("결재가 완료된 상태입니다!\n\n시수입력 사항을 변경하려면 먼저 결재자에게 결재취소를 요청하십시오.");
            return true;
        }
        return false;
    }

    //// 해당 일자 + Work Day 2일이 경과되었는지 체크 => 이 체크는 Header에서 날짜 선택 시 체크되므로 제거
    //function checkWorkdaysGap()
    //{
    //    if (parent.DP_HEADER.DPInputHeader.isAdmin.value != "true" && 
    //        (parent.DP_MAIN.DPInputMain.workdaysGap.value == -1 || parent.DP_MAIN.DPInputMain.workdaysGap.value >= 3)) {
    //        alert("입력 유효일자(해당일자 + Workday 2일)가 경과되었습니다.\n\n관리자에게 LOCK 해제를 요청하십시오.");
    //        return true;
    //    }
    //    return false;
    //}
    
    // 시수입력이 가능한 상태인지 체크
    function isInvalidConditions()
    {
        var b;
        b = checkMHConfirmYN();
        //if (!b) b = checkWorkdaysGap();

        return b;
    }

    // 시각 선택(클릭) 시 시수입력 창에 반영
    function timeSelected(timeKey)
    {
        if (!isInvalidConditions()) parent.DP_MAIN.timeSelected(timeKey);
    }

    // 1 일 이상(호선선택 없음) - 년차, 특별휴가, 예비군훈련
    function saveAsVacationOrMilitaryTraining(opCode)
    {
        parent.DP_MAIN.saveAsVacationProc(opCode);
    }

    // 1 일 이상(호선선택 없음) - 기술회의 및 교육, 일반출장 
    function saveAsOneDayOverJob(opCode)
    {
        parent.DP_MAIN.saveAsOneDayOverJob(opCode); // DP_MAIN 부분 코드에서 제약조건 체크함
    }

    // 1 일 이상(호선선택 포함) - 사외 협의 검토
    function saveAsOneDayOverJobWithProject(opCode)
    {
        parent.DP_MAIN.saveAsOneDayOverJobWithProject(opCode); // DP_MAIN 부분 코드에서 제약조건 체크함
    }

    // 퇴근
    function finishWork()
    {
        if (!isInvalidConditions()) {
            parent.DP_MAIN.finishWork();
        }
    }

    // 조퇴
    function finishWorkEarly()
    {
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value == "휴일") {
                alert("조퇴 등록은 평일인 경우에만 가능합니다.");
                return;
            }
            parent.DP_MAIN.finishWorkEarly();
        }
    }

    // 시운전
    function saveAsSeaTrial()
    {
        parent.DP_MAIN.saveAsSeaTrial(); // 시운전은 DP_MAIN 부분 코드에서 제약조건 체크함
    }

    // 시운전 후 조기퇴근(평일)
    function finishWorkEarlyAfterSeaTrial(comments)
    {
    	if(!comments)comments = '시운전 후 조기퇴근';
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value == "휴일") {
                alert("'"+comments+"' 등록은 평일인 경우에만 가능합니다.");
                return;
            }
            parent.DP_MAIN.finishWorkEarlyAfterSeaTrial(comments);
        }
    }

    // 전일시수 COPY
    function copyYesterdayMH()
    {
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value != "평일") {
                alert("'전일시수 COPY'는 평일인 경우에만 가능합니다.");
                return;
            }
            parent.DP_MAIN.copyYesterdayMH();
        }
    }

</script>


</html>