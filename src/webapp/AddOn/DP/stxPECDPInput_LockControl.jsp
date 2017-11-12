<%--  
§DESCRIPTION: 시수입력 - 시수입력 LOCK 관리 화면
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_LockControl.jsp
§CHANGING HISTORY: 
§    2009-06-29: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
    String errStr = "";

    ArrayList dpInputLockList = null;
    try {
        dpInputLockList = getDPInputLockList();
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>시수입력 LOCK 관리</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPInputLockList">

<table width="100%" cellSpacing="0" cellpadding="6" border="0" align="center">
    <tr>
    <td style="vertical-align:top;">
        <div id="lockListDiv" STYLE="height:280; overflow:auto; position:relative;">
        <table width="100%" cellSpacing="0" cellpadding="0" border="1" align="center">
            <tr height="20">
                <td class="td_standardBold" style="background-color:#336699;" width="30"><font color="#ffffff">NO</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="60"><font color="#ffffff">부서코드</font></td>
                <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">부서명</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="90"><font color="#ffffff">입력유효일자</font></td>
            </tr>
            
            <%
            for (int i = 0; dpInputLockList != null && i < dpInputLockList.size(); i++) 
            {
                Map map = (Map)dpInputLockList.get(i);
                String deptCode = (String)map.get("DEPT_CODE");
                String deptName = (String)map.get("DEPT_NAME");
                String lockDate = (String)map.get("LOCK_DATE");
                //String todayDate = (String)map.get("DEFAULT_DATE");
                String colorStr = "#ffffff";
                //if (!todayDate.equals(lockDate)) colorStr = "#fff0f5";
                %>
                <tr height="20" style="background-color:<%=colorStr%>">
                    <td class="td_standard"><%=i + 1%></td>
                    <td class="td_standard"><%=deptCode%></td>
                    <td class="td_standard" style="text-align:left;"><%=deptName%></td>
                    <td class="td_standard" onclick="selectDate(this, '<%=deptCode%>');"><%=lockDate%></td>
                </tr>
                <%
            }
            %>
        </table>
        </div>
    </td>
    </tr>

    <tr height="45">
        <td style="text-align:right;">
            <hr>
            <input type="button" value="저장" class="button_simple" onclick="updateDPInputLockList();">&nbsp;&nbsp;
            <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>

</table>

<div id="dummyDiv" style="position:absolute;width=0px;height:0px;">
    <input type="text" name="dummyText" value="" style="width=0px;height:0px;" />
</div>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    var activeTDObject = null;
    var activeFieldKey = "";
    var currentDateStr = "";
    var changedList = new Array();

    // 시수입력 LOCK 일자 선택 : 칼렌다 표시
    function selectDate(tdObject, dwgCode)
    {
        currentDateStr = tdObject.innerHTML;
        var objPosition = getAbsolutePosition(tdObject);
        dummyDiv.style.left = objPosition.x - lockListDiv.scrollLeft; // dummyDiv & dummyText는 칼렌다 팝업 위치 및 칼렌다 선택 값을 얻기 위해 필요
        dummyDiv.style.top = objPosition.y - lockListDiv.scrollTop;
        activeTDObject = tdObject;
        activeFieldKey = dwgCode;

        showCalendar('DPInputLockList', 'dummyText', '', false, dateChanged);
    }

    // 날짜 출력 문자열을 형식화 & 유효성 체크
    function dateChanged()
    {
        var tmpStr = DPInputLockList.dummyText.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            DPInputLockList.dummyText.value = formatDateStr(tmpStr); // 2009.6.5 -> 2009-06-05 형식으로 변경

            if (currentDateStr == DPInputLockList.dummyText.value) return;

            // 값 할당
            if (activeTDObject != null) {
                activeTDObject.innerHTML = DPInputLockList.dummyText.value;
                activeTDObject.style.backgroundColor = "#fff0f5";
            }

            if (activeFieldKey != "") {
                // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
                var isExist = false;
                for (var i = 0; i < changedList.length; i++) {
                    var str = changedList[i];
                    if (str.indexOf(activeFieldKey + "|") >= 0) {
                        changedList[i] = activeFieldKey + "|" + DPInputLockList.dummyText.value;
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) 
                    changedList[changedList.length] = activeFieldKey + "|" + DPInputLockList.dummyText.value;
            }
        }
    }

    // 변경사항을 저장(DB에 적용)
    function updateDPInputLockList()
    {
        if (changedList.length <= 0) {
            alert("변경사항이 하나도 없습니다!");
            return;
        }
        
        var params = "";
        for (var i = 0; i < changedList.length; i++) {
            if (i > 0) params += ",";
            params += changedList[i];
        }

        var resultMsg = callDPCommonAjaxProc("UpdateDPInputLockList", "params", params);
        if (resultMsg == "ERROR") alert("에러가 발생하여 저장에 실패했습니다!");
        else alert("저장완료!");
    }

</script>


</html>