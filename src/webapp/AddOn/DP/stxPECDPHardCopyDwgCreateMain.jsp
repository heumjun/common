<%--   
§DESCRIPTION: 도면 출도대장(Hard Copy) 항목 등록 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgCreateMain.jsp
§CHANGING HISTORY: 
§    2010-03-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// 2013-10-15 Kangseonjung : 부서(팀) 별 배포번호 영문코드 관리 하드코딩(상선) 부분을 파트로 세분화 (인사부서) 하고 TABLE로 관리
	private static String searchDEPLOY_NO_PREFIX(String insaDeptCode) throws Exception
	{
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		String returnStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT DEPLOY_NO_PREFIX                          \n");
			queryStr.append("  FROM PLM_HARDCOPY_DWG_DEPLOY_NO                \n");
			queryStr.append(" WHERE INSA_DEPT_CDOE='"+insaDeptCode+"'         \n");

			stmt = conn.createStatement();
			rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
			{
				returnStr = rset.getString(1) == null ? "" : rset.getString(1);
			}
		} catch( Exception e)
		{
			//DBConnect.rollbackJDBCTransaction(conn);
			throw e;			
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return returnStr;
	}
%>
<%
    //String loginID = context.getUser();
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");

    String errStr = "";             // DB Query 중 에러 발생 여부
    //String dwgDeptCode = "";        // 부서(파트) 코드 - 설계부서 코드
    String insaDeptCode = "";       // 부서(파트) 코드 - 인사정보의 코드
    String insaDeptName = "";       // 부서(파트) 이름 - 인사정보의 부서명
    String insaUpDeptName = "";     // 상위부서(팀) 이름 - 인사정보의 부서명
    String userName = "";           // 사용자 이름
    String deployNoPrefix = "";     // 배포 NO.의 Prefix 부분
    String currentDate = "";        // 오늘날짜

    ArrayList projectList = null;     // 호선목록
    ArrayList departmentList = null;  // (원인)부서목록

    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        // (FOR DALIAN) 대련중공 설계인원에게도 기능 부여 (* 임시기능)
        if (loginUserInfo == null) loginUserInfo = getEmployeeInfo_Dalian(loginID);

        //dwgDeptCode = (String)loginUserInfo.get("DWG_DEPTCODE");
        insaDeptCode = (String)loginUserInfo.get("DEPT_CODE");
        insaDeptName = (String)loginUserInfo.get("DEPT_NAME");
        insaUpDeptName = (String)loginUserInfo.get("UP_DEPT_NAME");
        userName = (String)loginUserInfo.get("NAME");

		String searchdeployNoPrefix = searchDEPLOY_NO_PREFIX(insaDeptCode);

        /* Hard Coding 부분: */ 
        /* 부서(팀) 별 영문코드 관리기능 구현(공문서관리시스템) 前 이어서 Hard Code 구현함 */
		/* 2013-10-15 Kangseonjung : 부서(팀) 별 배포번호 영문코드 관리 하드코딩(상선) 부분을 파트로 세분화 (인사부서) 하고 TABLE로 관리
        if (insaUpDeptName.equals("기본기술팀")) deployNoPrefix = "B";
        else if (insaUpDeptName.equals("설계기술연구팀")) deployNoPrefix = "V"; //진동소음연구팀 ->설계기술연구팀
        else if (insaUpDeptName.equals("구조기술팀")) deployNoPrefix = "V";
        else if (insaUpDeptName.equals("기술개발팀")) deployNoPrefix = "N"; //제품개발팀 ->기술개발팀
        else if (insaUpDeptName.equals("성능기술팀")) deployNoPrefix = "N";
        else if (insaUpDeptName.equals("방식기술팀")) deployNoPrefix = "M";
        else if (insaUpDeptName.equals("생산기술연구팀")) deployNoPrefix = "T";
        else if (insaUpDeptName.equals("기술기획팀")) deployNoPrefix = "A";
        else if (insaUpDeptName.equals("선체계획팀")) deployNoPrefix = "H";
        //else if (insaUpDeptName.equals("선체설계팀")) deployNoPrefix = "P"; // 부서명 변경 -> 선체설계1팀, 선체설계2팀
        else if (insaUpDeptName.equals("선체설계1팀")) deployNoPrefix = "P";
        else if (insaUpDeptName.equals("선체설계2팀")) deployNoPrefix = "P";
        else if (insaUpDeptName.equals("선장설계1팀")) deployNoPrefix = "J";
        else if (insaUpDeptName.equals("선장설계2팀")) deployNoPrefix = "Y";
        //else if (insaUpDeptName.equals("선장설계3팀")) deployNoPrefix = "Z"; // 부서명 변경 -> 선실설계팀
        else if (insaUpDeptName.equals("선실설계팀")) deployNoPrefix = "Z"; 
        else if (insaUpDeptName.equals("기장설계1팀")) deployNoPrefix = "O";
        else if (insaUpDeptName.equals("기장설계2팀")) deployNoPrefix = "O";
        else if (insaUpDeptName.equals("전장설계1팀")) deployNoPrefix = "E";
        else if (insaUpDeptName.equals("전장설계2팀")) deployNoPrefix = "F";
        else if (insaUpDeptName.equals("생산공법팀")) deployNoPrefix = "K";
        else if (insaUpDeptName.equals("기술영업팀")) deployNoPrefix = "D";
        else if (insaUpDeptName.equals("계약관리팀")) deployNoPrefix = "C";
        else if (insaUpDeptName.equals("제품개발연구실")) deployNoPrefix = "L";
		*/
		if(!"".equals(searchdeployNoPrefix)) deployNoPrefix = searchdeployNoPrefix;
        else if (insaDeptName.equals("해양설계관리팀")) deployNoPrefix = "DM";
        else if (insaDeptName.equals("해양의장설계팀-배관설계P")) deployNoPrefix = "PD"; //해양배관시스템설계팀 -> 해양의장설계팀-배관설계P
        else if (insaDeptName.equals("해양의장설계팀-기계설계P")) deployNoPrefix = "ME"; //해양기계설계팀 -> 해양의장설계팀-기계설계P
        else if (insaDeptName.equals("해양의장설계팀-선장설계P")) deployNoPrefix = "HO"; //해양선장설계팀 -> 해양의장설계팀-선장설계P
        else if (insaDeptName.equals("해양의장설계팀-전장설계P")) deployNoPrefix = "EL"; //해양전장설계팀 -> 해양의장설계팀-전장설계P
        else if (insaDeptName.equals("해양선체설계팀")) deployNoPrefix = "PH";
        else if (insaDeptName.equals("해양배관설계팀")) deployNoPrefix = "PP";
        else if (insaDeptName.equals("해양철의장설계팀")) deployNoPrefix = "PO";
        else if (insaDeptName.equals("해양전장선실설계팀")) deployNoPrefix = "PE";
        else if (insaDeptName.equals("해양의장설계팀-선실설계P")) deployNoPrefix = "AC"; //해양선실설계팀 -> 해양의장설계팀-선실설계P
        //else if (insaDeptName.equals("해양기본연구팀")) deployNoPrefix = "BA"; // 부서명 변경 -> 해양기본설계팀
        //else if (insaDeptName.equals("해양구조연구팀")) deployNoPrefix = "HU"; // 부서명 변경 -> 해양구조설계팀
        //else if (insaDeptName.equals("해양구조설계팀-기본설계P")) deployNoPrefix = "BA"; //해양기본설계팀 -> 해양구조설계팀-기본설계P
        //else if (insaDeptName.equals("해양구조설계팀-구조설계P")) deployNoPrefix = "HU"; //해양구조설계팀 -> 해양구조설계팀-구조설계P
        // (FOR DALIAN) 대련중공 설계인원에게도 기능 부여 (* 임시기능)
        else {
            String dwgDeptCode = (String)loginUserInfo.get("DWG_DEPTCODE");
            if (dwgDeptCode.equals("000073")) deployNoPrefix = "DP";
            else if (dwgDeptCode.equals("000074")) deployNoPrefix = "DA";
            else if (dwgDeptCode.equals("000075")) deployNoPrefix = "DH";
            else if (dwgDeptCode.equals("000076")) deployNoPrefix = "DE";
            else if (dwgDeptCode.equals("000077")) deployNoPrefix = "DO";
            else if (dwgDeptCode.equals("000106")) deployNoPrefix = "DI";
            else if (dwgDeptCode.equals("000060")) deployNoPrefix = "PP";
            else if (dwgDeptCode.equals("000061")) deployNoPrefix = "ME";
            else if (dwgDeptCode.equals("000062")) deployNoPrefix = "HO";
            else if (dwgDeptCode.equals("000138")) deployNoPrefix = "AC";
            else if (dwgDeptCode.equals("000063")) deployNoPrefix = "EL";
            else if (dwgDeptCode.equals("000058")) deployNoPrefix = "BA";
            else if (dwgDeptCode.equals("000059")) deployNoPrefix = "HU";
            else throw new Exception("Unknown Department(Team) Code! (Team Name: " + insaUpDeptName + ")");
        }

        Calendar c = Calendar.getInstance();
        String sYear = String.valueOf(c.get(Calendar.YEAR));
        deployNoPrefix += sYear.substring(2);

        currentDate = sYear + "-";
        String sTemp = String.valueOf(c.get(Calendar.MONTH) + 1);
        if (sTemp.length() < 2) sTemp = "0" + sTemp;
        currentDate += sTemp + "-";
        sTemp = String.valueOf(c.get(Calendar.DAY_OF_MONTH));
        if (sTemp.length() < 2) sTemp = "0" + sTemp;        
        currentDate += sTemp;

        // 호선목록
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
            projectList = getProgressSearchableProjectList_Dalian(loginID, true, "PROGRESS");
        else projectList = getAllProjectList("");

        // (원인)부서목록
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) 
            departmentList = getAllDepartmentOfSTXShipList_Dalian();
        else departmentList = getAllDepartmentOfSTXShipList();
    }
    catch (Exception e) {
        errStr = e.toString();
        e.printStackTrace();
    }    
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>Drawing Distribution History Resister</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPHardCopyDwgCreateMain">

    <input type="hidden" name="deployNoPrefix" value="<%=deployNoPrefix%>" />
    <input type="hidden" name="insaDeptCode" value="<%=insaDeptCode%>" />
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="requestDate" value="<%=currentDate%>" />
    <input type="hidden" name="deployDate" value="" />



<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                Error occurred!<br>
                ※Error Message: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>
    <!--<p style="font-size:12pt;font-weight:bold;color:darkblue;">도면 출도대장(Hard Copy) 등록</p>-->

	<table width="100%" border="0" cellspacing="2" cellpadding="2">
		<tr>
			<td class="td_labelRequired" width="30%">Division</td>
			<td class="inputField">
                <input type="radio" name="inputGubun" value="출도실" checked 
                 onclick="gubun_printFromCopyRoomChecked();" />Copy Center
                <input type="radio" name="inputGubun" value="자체" 
                 onclick="gubun_printFromDeptChecked();" />Itself
            </td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No.</td>
			<td class="inputField"><%=deployNoPrefix%>-<i>xxxxx</i></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Dept.</td>
			<td class="inputField"><%=insaDeptCode%>: <%=insaDeptName%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No. Requestor</td>
			<td class="inputField"><%=userName%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution No. Request Date</td>
			<td class="inputField"><%=currentDate%></td>
		</tr>
		<tr>
			<td class="td_labelRequired" width="30%">Distribution Date</td>
			<td class="inputField" id="deployDateTD"></td>
		</tr>
    </table>
    
    <hr><br>

    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#000000">
        <tr height="24" bgcolor="#dadada">
            <td class="td_smallLRMarginBlue" width="62">PROJECT</td>
            <td class="td_smallLRMarginBlue" width="24">REV.</td>
            <td class="td_smallLRMarginBlue" width="80">DwgNo.</td>
            <td class="td_smallLRMarginBlue" width="176">DESCRIPTION</td>
            <td class="td_smallLRMarginBlue" width="74">ECO No.</td>
            <td class="td_smallLRMarginBlue" width="50">Category of Change</td>
            <td class="td_smallLRMarginBlue" width="52">Change Request Dept.</td>
            <td class="td_smallLRMarginBlue" width="70">Distribution Time</td>
            <td class="td_smallLRMarginBlue">Note</td>
        </tr>

        <%
        for (int i = 0; i < 8; i++) 
        {
        %>
        <tr bgcolor="#ffffff">
            <!-- PROJECT -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="projectInput<%=i%>" value="" class="input_noBorder3" style="width:50px;height:20px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
                <input type="button" name="showprojectListBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showProjectSel('projectInput<%=i%>');">
            </td>
            <!-- REV. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="revInput<%=i%>" value="" maxlength="3" class="input_noBorder3" style="width:34px;height:20px;" 
                       onKeyUp="javascript:this.value=this.value.toUpperCase();" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <!-- DRAWING NO. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="drawingNo<%=i%>" value="" class="input_noBorder3" style="width:68px;height:20px;" maxlength="8"
                       onKeyUp="drawingNoValueChanged(this, 'projectInput<%=i%>', 'dwgDesc<%=i%>', 'revTiming<%=i%>', 'dwgCategory<%=i%>');" 
                       onkeydown="inputCtrlKeydownHandler();" onChange="drawingNoValueChanged(this);">
                <input type="button" name="showprojectListBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showDrawingNoSel('drawingNo<%=i%>', 'projectInput<%=i%>', 'dwgDesc<%=i%>', 'revTiming<%=i%>', 'dwgCategory<%=i%>');">
            </td>
            <!-- DESCRIPTION -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="dwgDesc<%=i%>" value="" class="input_noBorder3" readonly 
                       style="width:180px;height:20px;background-color:#ffffff;">
            </td>
            <!-- ECO NO. -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="ecoNo<%=i%>" value="" class="input_noBorder3" style="width:80px;height:20px;"
                       onKeyUp="checkECONo(this, '<%=i%>');" onkeydown="inputCtrlKeydownHandler();">
            </td>
            <!-- 출도원인 -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="reasonCode<%=i%>" value="" readonly class="input_noBorder3" style="width:40px;height:20px;">
                <input type="button" name="showReasonCodeBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showReasonCodeWin('reasonCode<%=i%>', 'ecoNo<%=i%>');">
            </td>
            <!-- 원인부서 -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="causeDept<%=i%>" value="" class="input_noBorder3" style="width:60px;height:20px;" 
                       readonly onclick="showCauseDeptSel('causeDept<%=i%>');">
            </td>
            <!-- 출도시기 -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <input type="text" name="revTiming<%=i%>" value="" class="input_noBorder3" readonly 
                       style="width:90px;height:20px;">
                <input type="hidden" name="dwgCategory<%=i%>" value="" />
                <input type="button" name="showRevTimingBtn<%=i%>" value="+" style="width:20px;height:20px;" 
                       onclick="showRevTimingWin('revTiming<%=i%>', 'dwgCategory<%=i%>');">
            </td>
            <!-- 비고 -->
            <td style="text-align:center; padding:0px,0px,0px,0px;">
                <textarea name="deployDesc<%=i%>" value="" rows="2" class="input_noBorder3" 
                          style="width:164px;text-align:left;" onkeydown="inputCtrlKeydownHandler();"></textarea>
            </td>
        </tr>
        <%
        }
        %>
    </table>

    
    <!-- 호선 SELECT BOX (DIV) -->
    <div id="projectListDiv" STYLE="position:absolute; display:none;">
        <select name="projectList" style="width:74px; background-color:#eeeeee;" onchange="projectListChanged();">
            <option value="">&nbsp;</option>
            <%
            for (int i = 0; projectList != null && i < projectList.size(); i++) 
            {
                Map map = (Map)projectList.get(i);
                String projectNo = (String)map.get("PROJECTNO");
                String projectNoStr = projectNo;
                //String dlEffective = (String)map.get("DL_EFFECTIVE");
                //if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNoStr = "Z" + projectNo;
                %>
                <option value="<%=projectNo%>"><%=projectNoStr%></option>
                <%
            }
            %>
        </select>
    </div>

    <!-- 도면번호 SELECT BOX (DIV) -->
    <div id="drawingNoListDiv" STYLE="position:absolute; display:none;">
        <select name="drawingNoList" style="width:310px; background-color:#eeeeee; font-size:9pt;" onchange="drawingNoListChanged();">
            <option value="">&nbsp;</option>
        </select>
    </div>

    <!-- 원인부서 SELECT BOX (DIV) -->
    <div id="causeDeptListDiv" STYLE="position:absolute; display:none;">
        <select name="causeDeptList" style="width:220px; background-color:#eeeeee;" onchange="causeDeptListChanged();">
            <option value="">&nbsp;</option>
            <%
            for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
            {
                Map map = (Map)departmentList.get(i);
                String deptCode = (String)map.get("DEPT_CODE");
                String deptName = (String)map.get("DEPT_NAME");
                String upDeptName = (String)map.get("UP_DEPT_NAME");
                String deptStr = deptCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + /*upDeptName + "-" +*/ deptName;
                %>
                <option value="<%=deptCode%>"><%=deptStr%></option>
                <%
            }
            %>
        </select>
    </div>
<%
}
%>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>

<script language="javascript">

	/** Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지 */
	document.onkeydown = keydownHandler;


    /** 구분(출도실|자체) 값 변경 시 배포일자 값 변경 ------------------------*/
    function gubun_printFromCopyRoomChecked()
    {
        DPHardCopyDwgCreateMain.deployDate.value = ""; 
        document.getElementById("deployDateTD").innerHTML = "";
    }
    function gubun_printFromDeptChecked()
    {
        DPHardCopyDwgCreateMain.deployDate.value = "<%=currentDate%>"; 
        document.getElementById("deployDateTD").innerHTML = "<%=currentDate%>";
    }


    /** 화면 클릭 시 선택되지 않은 SELECT BOX(DIV) 숨기기 --------------------*/
    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // 마우스 클릭 시 SELECT BOX 컨트롤을 숨긴다(해당 컨트롤에 대한 마우스 클릭이 아닌 경우)
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        // 호선 SELECT BOX 숨기기
        mouseClickHandlerSubProc(e, projectListDiv);

        // 도면번호 SELECT BOX 숨기기     
        mouseClickHandlerSubProc(e, drawingNoListDiv);

        // 원인부서 SELECT BOX 숨기기     
        mouseClickHandlerSubProc(e, causeDeptListDiv);
    }
    // Sub-Procedure
    function mouseClickHandlerSubProc(e, divObj)
    {
        var posX = event.clientX;
        var posY = event.clientY;

        // 호선 SELECT BOX        
        if (divObj.style.display != "none") {
            var objPos = getAbsolutePosition(divObj);
            if (posX < objPos.x || posX > objPos.x + divObj.offsetWidth ||
                posY < objPos.y  || posY > objPos.y + divObj.offsetHeight)
            {
                divObj.style.display = "none";
            }
        }
    }


    /** 호선선택 SELECT BOX(DIV) 보이고 숨기기 -------------------------------*/
    var activeProjectInputObj = null;

    // 호선 선택 SELECT BOX SHOW
    function showProjectSel(projectInputId)
    {
        activeProjectInputObj = document.getElementById(projectInputId);        
        
        var str = activeProjectInputObj.value.trim();
        DPHardCopyDwgCreateMain.projectList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgCreateMain.projectList.options.length; i++) {
            if (DPHardCopyDwgCreateMain.projectList.options[i].value == str) {
                DPHardCopyDwgCreateMain.projectList.options.selectedIndex = i;
                break;
            }
        }

        var objPos = getAbsolutePosition(activeProjectInputObj);
        projectListDiv.style.left = objPos.x;
        projectListDiv.style.top = objPos.y - 1;

        projectListDiv.style.display = "";
        isNewShow = true;
    }

    // 호선 선택 SELECT BOX 값 선택 시 Select Box는 Hidden, 선택된 값을 Input Box에 반영
    function projectListChanged()
    {
        activeProjectInputObj.value = DPHardCopyDwgCreateMain.projectList.value;
        projectListDiv.style.display = "none";
    }


    /** 도면번호 SELECT BOX(DIV) 보이고 숨기기 -------------------------------*/
    var activeDrawingNoInputObj = null;
    var activeDrawingDescInputObj = null;
    var activeRevTimingInputObj = null;
    var activeDwgCategoryInputObj = null;

    // 도면번호 선택 SELECT BOX SHOW
    function showDrawingNoSel(drawingNoInputId, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        activeDrawingNoInputObj = document.getElementById(drawingNoInputId);  
        activeDrawingDescInputObj = document.getElementById(dwgDescInputId);  
        activeRevTimingInputObj = document.getElementById(revTimingInputId);  
        activeDwgCategoryInputObj = document.getElementById(dwgCategoryInputId);  
        
        // Select Box 초기화 
        for (var i = DPHardCopyDwgCreateMain.drawingNoList.options.length - 1 ; i > 0; i--) 
        {   DPHardCopyDwgCreateMain.drawingNoList.options[i] = null;   }
        DPHardCopyDwgCreateMain.drawingNoList.selectedIndex = 0; 

        // 도면번호 목록 쿼리해 오기
        drawingNoQueryProc(projectInputId, activeDrawingNoInputObj.value, DPHardCopyDwgCreateMain.drawingNoList);

        var objPos = getAbsolutePosition(activeDrawingNoInputObj);
        drawingNoListDiv.style.left = objPos.x;
        drawingNoListDiv.style.top = objPos.y - 1;

        drawingNoListDiv.style.display = "";
        isNewShow = true;
    }

    // 도면번호 수기입력 시 처리
    function drawingNoValueChanged(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        // 대문자로 변환
        drawingNoInputObj.value = drawingNoInputObj.value.toUpperCase(); 

        // 도면 Desc., 출도시기 값을 초기화
        (document.getElementById(dwgDescInputId)).value = "";
        (document.getElementById(revTimingInputId)).value = "";
        (document.getElementById(dwgCategoryInputId)).value = "";

        // 도면코드 8 자리가 다 입력되었으면 해당 도면의 정보를 쿼리해서 도면 Desc., 출도시기 값도 결정
        if (drawingNoInputObj.value.trim().length == 8) {
            drawingNoQueryProc2(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId);
        }
    }

    // 도면번호 선택 SELECT BOX 값 선택 시 Select Box는 Hidden, 선택된 값을 Input Box에 반영
    function drawingNoListChanged()
    {
        var strs = DPHardCopyDwgCreateMain.drawingNoList.value.split("‥");
        activeDrawingNoInputObj.value = strs[0];
        activeDrawingDescInputObj.value = strs[1];
        //activeRevTimingInputObj.value = strs[2];
        activeDwgCategoryInputObj.value = strs[3];
        drawingNoListDiv.style.display = "none";
    }

    // 호선 + 부서에 대한 '도면코드' 값들을 DB에서 쿼리해오고 Select Box LOV를 채움
    function drawingNoQueryProc(projectInputId, selectedValue, selectObj)
    {
        var selectedProject = (document.getElementById(projectInputId)).value.trim();
        if (selectedProject == "") return;

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork2" + 
                            "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value + 
                            "&projectNo=" + selectedProject, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("∥");

                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split("‥");
                            var newOption = new Option(strs2[0] + " : " + strs2[1], strs[i]);
                            selectObj.options[i + 1] = newOption;
                            if (selectedValue != "" && strs[i].indexOf(selectedValue + "‥") >= 0) selectObj.selectedIndex = i + 1; 
                        }
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }

    // 호선 + 도면코드에 대한 도면정보를 DB에서 쿼리
    function drawingNoQueryProc2(drawingNoInputObj, projectInputId, dwgDescInputId, revTimingInputId, dwgCategoryInputId)
    {
        var selectedProject = (document.getElementById(projectInputId)).value.trim();
        if (selectedProject == "") {
            alert("Please select a PROJECT first!");
            //drawingNoInputObj.value = drawingNoInputObj.value.trim().substring(0, 6);
            return;
        }

        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork3" + 
                            "&projectNo=" + selectedProject + 
                            "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value + 
                            "&dwgNo=" + drawingNoInputObj.value.trim(), false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
               
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("‥");
                        if (strs.length == 4) {
                            (document.getElementById(dwgDescInputId)).value = strs[1];
                            //(document.getElementById(revTimingInputId)).value = strs[2];
                            (document.getElementById(dwgCategoryInputId)).value = strs[3];
                        }
                        else alert("Dwg No. '" + drawingNoInputObj.value.trim() + "' does not exist!");
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }


    /** 출도원인 코드 선택 창을 SHOW -----------------------------------------*/
    function showReasonCodeWin(reasonCodeInputId, ecoNoInputId)
    {
        if (document.getElementById(ecoNoInputId).value.trim() != '') {
            alert("You cannot change 'Category of Change' when 'ECO NO.' was inputted!");
            return;
        }

        var sProperties = 'dialogHeight:600px;dialogWidth:600px;scroll=auto;center:yes;resizable=no;status=no;';
        var selectedCode = parent.window.showModalDialog("stxPECDPHardCopyDwgCreate_CodeSelect.jsp", "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            document.getElementById(reasonCodeInputId).value = selectedCode;
        }
    }


    /** (원인)부서 선택 SELECT BOX(DIV) 보이고 숨기기 ------------------------*/
    var activeCauseDeptInputObj = null;

    // 원인부서 선택 SELECT BOX SHOW
    function showCauseDeptSel(causeDeptInputId)
    {
        activeCauseDeptInputObj = document.getElementById(causeDeptInputId);        
        
        var str = activeCauseDeptInputObj.value.trim();
        DPHardCopyDwgCreateMain.causeDeptList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgCreateMain.causeDeptList.options.length; i++) {
            if (DPHardCopyDwgCreateMain.causeDeptList.options[i].value == str) {
                DPHardCopyDwgCreateMain.causeDeptList.options.selectedIndex = i;
                break;
            }
        }

        var objPos = getAbsolutePosition(activeCauseDeptInputObj);
        causeDeptListDiv.style.left = objPos.x;
        causeDeptListDiv.style.top = objPos.y - 1;

        causeDeptListDiv.style.display = "";
        isNewShow = true;
    }

    // 원인부서 선택 SELECT BOX 값 선택 시 Select Box는 Hidden, 선택된 값을 Input Box에 반영
    function causeDeptListChanged()
    {
        activeCauseDeptInputObj.value = DPHardCopyDwgCreateMain.causeDeptList.value;
        causeDeptListDiv.style.display = "none";
    }


    /** 출도시기 선택 창을 SHOW -----------------------------------------*/
    function showRevTimingWin(revTimingInputId, dwgCategoryInputId)
    {
        var dwgCategory = document.getElementById(dwgCategoryInputId).value;
        if (dwgCategory == "") {
            alert("Please select 'Dwg No' first!");
            return;
        }

        var sProperties = 'dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var sUrl = "stxPECDPHardCopyDwgCreate_RevTimingSelect.jsp?dwgCategory=" + dwgCategory;
            sUrl = sUrl + "&departCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value;
        var selectedCode = parent.window.showModalDialog(sUrl, "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            document.getElementById(revTimingInputId).value = selectedCode;
        }
    }


    /* ECO NO. 입력 시 출도원인과 비고 값 자동입력 */

    // ECO No. 입력 시 존재하는 ECO인지 체크하고, 존재하면 ECO 정보로 출도원인과 비고 값을 자동 입력 
    function checkECONo(ecoNoInputObj, indexNo)
    {
        // ECO 코드 10 자리가 다 입력되었으면 해당 ECO의 정보를 쿼리해서 출도원인과 비고 값도 결정
        var ecoNo = ecoNoInputObj.value.trim();
        if (ecoNo.length == 10) {
            if (isStringNumber(ecoNo) == 0) {
                alert("Invalid 'ECO NO.'!");
                //ecoNoInputObj.value = "";
                return false;            
            }

            checkECONoSubProc(ecoNo, ecoNoInputObj, indexNo);
        }
    }

    // ECO 정보를 읽어와서 출도원인과 비고 값을 자동 입력 
    function checkECONoSubProc(ecoNo, ecoNoInputObj, indexNo)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetECOInfo" + 
                            "&ecoNo=" + ecoNo, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
               
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') {
                        alert(resultMsg);
                        //ecoNoInputObj.value = "";
                    }
                    else {
                        if (resultMsg != "") {
                            var str1 = resultMsg.substring(0, resultMsg.indexOf("|"));
                            var str2 = resultMsg.substring(resultMsg.indexOf("|") + 1);
                            (document.getElementById("reasonCode" + indexNo)).value = str1;
                            (document.getElementById("deployDesc" + indexNo)).value = str2;
                        }
                        else {
                            alert("The 'ECO No.' inputted is not exist! Please check the 'ECO No.'");
                            //ecoNoInputObj.value = "";
                        }
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }


    /** 도면 출도대장(Hard Copy) 등록 ----------------------------------------*/

    // 저장
    function createHardCopyData()
    {
        if (!checkInputs()) return;

        // 입력값 수집
        var params = "";
        params += "loginID=" + DPHardCopyDwgCreateMain.loginID.value;
        params += "&deployNoPrefix=" + DPHardCopyDwgCreateMain.deployNoPrefix.value;
        params += "&deptCode=" + DPHardCopyDwgCreateMain.insaDeptCode.value;
        params += "&requestDate=" + DPHardCopyDwgCreateMain.requestDate.value;
        params += "&deployDate=" + DPHardCopyDwgCreateMain.deployDate.value;
        if (DPHardCopyDwgCreateMain.inputGubun[0].checked) 
            params += "&gubun=" + DPHardCopyDwgCreateMain.inputGubun[0].value;
        else if (DPHardCopyDwgCreateMain.inputGubun[1].checked) 
            params += "&gubun=" + DPHardCopyDwgCreateMain.inputGubun[1].value;
   
        for (var i = 0; i < 8; i++)
        {
            var projectInput = (document.getElementById("projectInput" + i)).value.trim();
            if (projectInput == "") continue;

            params += "&project" + i + "=" + projectInput;
            params += "&rev" + i + "=" + (document.getElementById("revInput" + i)).value.trim();
            params += "&dwg" + i + "=" + (document.getElementById("drawingNo" + i)).value.trim();
            params += "&dwgDesc" + i + "=" + (document.getElementById("dwgDesc" + i)).value.trim().replaceAmpAll();
            params += "&ecoNo" + i + "=" + (document.getElementById("ecoNo" + i)).value.trim();
            params += "&reasonCode" + i + "=" + (document.getElementById("reasonCode" + i)).value.trim();
            params += "&causeDept" + i + "=" + (document.getElementById("causeDept" + i)).value.trim();
            params += "&revTiming" + i + "=" + (document.getElementById("revTiming" + i)).value.trim();
            params += "&deployDesc" + i + "=" + (document.getElementById("deployDesc" + i)).value.trim().replaceAmpAll();
        }
        params += "&maxCnt=8";

        //alert(params);

        // DB 저장
        var resultMsg = callDPCommonAjaxPostProc2("SaveHardCopyInputs", params);
        if (resultMsg.indexOf("Y|") == 0) {
            alert("Saved! (Distribution No.: " + resultMsg.substring(2) + ")");
            window.close();
        }
        else alert("Error occurred on saving to DB!");
    }

    // 입력값들이 유효한지 체크, 필수항목 입력 체크
    function checkInputs()
    {
        var inputExist = false;

        for (var i = 0; i < 8; i++)
        {
            // 호선입력 유효성(존재하는 호선인지) 체크
            var projectInput = (document.getElementById("projectInput" + i)).value.trim();
            if (projectInput != "") {
                DPHardCopyDwgCreateMain.projectList.options.selectedIndex = 0;
                for (var j = 0; j < DPHardCopyDwgCreateMain.projectList.options.length; j++) {
                    if (DPHardCopyDwgCreateMain.projectList.options[j].value == projectInput) {
                        DPHardCopyDwgCreateMain.projectList.options.selectedIndex = j;
                        break;
                    }
                }

                if (DPHardCopyDwgCreateMain.projectList.value == "") {
                    alert("Invalid or Unexisted Project No.!");
                    return false;
                }
            }

            // REV. 값 범위가 유효한지 체크
            var revInput = (document.getElementById("revInput" + i)).value.trim();
            if (revInput != "") {
                if (isStringNumber(revInput) == 0 && isStringAlphabet(revInput) == 0) {
                    if (isStringAlphabetPlusNumber(revInput) == 0) {
                        alert("Invalid REV.!");
                        return false;
                    }
                }
            }

            // 출도원인 값 범위가 유효한지 체크
            var reasonCode = (document.getElementById("reasonCode" + i)).value.trim();
            /*
            if (reasonCode != "") {
                if (reasonCode.length != 2 || isStringAlphabet(reasonCode.charAt(0)) == 0 || isStringNumber(reasonCode.charAt(1)) == 0) {
                    alert("올바른 출도원인 값을 입력하십시오!");
                    return false;
                }
            } 
            */

            // 필수항목 입력 여부 체크
            if (projectInput != "") 
            {
                if (revInput == "") {
                    alert("Please input the 'REV.'!");
                    return false;                
                } 
                if ((document.getElementById("drawingNo" + i)).value.trim() == "") {
                    alert("Please input the 'DwgNo.'!");
                    return false;                
                }                 
                if (reasonCode == "") {
                    alert("Please input the 'Category of Change'!");
                    return false;                
                }  
                if ((document.getElementById("revTiming" + i)).value.trim() == "") {
                    alert("Please input the 'Distribution Time'!");
                    return false;                
                }     

                inputExist = true;
            }
        }

        if (!inputExist) {
            alert("There is no item to save!");
            return false;                
        }

        return true;
    }

    // utility function
    function isStringNumber(str) 
    {
        var ref="0123456789";
        var sLength=str.length;
        var chr, idx, idx2;

        for(var i=0; i<sLength; i++) {
            chr=str.charAt(i);
            idx=ref.indexOf(chr);
            if(idx==-1) {
                return 0;
            }
        }
        
        return 1;
    }

    // utility function
    function isStringAlphabet(str) 
    {
        var ref="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var sLength=str.length;
        var chr, idx, idx2;

        for(var i=0; i<sLength; i++) {
            chr=str.charAt(i);
            idx=ref.indexOf(chr);
            if(idx==-1) {
                return 0;
            }
        }
        
        return 1;
    }

    // utility function
    function isStringAlphabetPlusNumber(str) 
    {
        var refAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var refNumber = "0123456789";
        
        var chr, idx, idx2;

        chr = str.charAt(0);
        idx = refAlphabet.indexOf(chr);
        if (idx == -1) return 0;
        
        for (var i = 1; i < str.length; i++) 
        {
            chr = str.charAt(i);
            idx = refNumber.indexOf(chr);
            if (idx == -1) return 0;
        }
        
        return 1;
    }

</script>


</html>
