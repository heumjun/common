<%--  
§DESCRIPTION: 공정 지연현황 조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviationViewHeader.jsp
§CHANGING HISTORY: 
§    2009-04-14: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
	
	String reportFileUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+"/DIS/report/";
    //String loginID = context.getUser(); // 접속자 ID : 설계자(파트장 포함) or 관리자(Admin)
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");    
    String designerID = "";             // 설계자 ID 
    String mhInputYN = "";              // 시수입력 가능 여부(이 권한은 공정입력 권한을 포함함)
    String progressInputYN = "";        // 공정입력 가능 여부
    String terminationDate = "";        // 퇴사일(퇴사여부)
    String insaDepartmentCode = "";     // 부서(파트) 코드 - 인사정보의 코드
    String dwgDepartmentCode = "";      // 부서(파트) 코드 - 설계부서 코드
    String isAdmin = "N"; 

    String errStr = "";                 // DB Query 중 에러 발생 여부

    ArrayList departmentList = null;
    ArrayList personsList = null;

    // DB에서 데이터 쿼리하여 항목들의 값 설정
    try {
        Map loginUserInfo = getEmployeeInfo(loginID);

        if (loginUserInfo != null) {
            designerID = loginID;

            if (((String)loginUserInfo.get("IS_ADMIN")).equals("Y")) isAdmin = "Y"; 

            mhInputYN = (String)loginUserInfo.get("MH_YN");
            progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
            terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
            insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
            dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

            departmentList = getProgressDepartmentList();
            personsList = getPartPersonsForDPProgress(insaDepartmentCode);
        }
        // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
        else {
            loginUserInfo = getEmployeeInfo_Dalian(loginID);

            if (loginUserInfo != null) 
            {
                designerID = loginID;

                mhInputYN = (String)loginUserInfo.get("MH_YN");
                progressInputYN = (String)loginUserInfo.get("PROGRESS_YN");
                terminationDate = (String)loginUserInfo.get("TERMINATION_DATE");
                insaDepartmentCode = (String)loginUserInfo.get("DEPT_CODE");
                dwgDepartmentCode = (String)loginUserInfo.get("DWG_DEPTCODE");

                departmentList = getProgressDepartmentList();
                personsList = getPartPersons_Dalian(insaDepartmentCode);
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
    <title>공정 지연현황 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    // SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
    <% if (designerID.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed.jsp";
    <% } %>

    // 시수입력 가능한 사용자가 아닌 경우 Exit
    <% if ((!mhInputYN.equalsIgnoreCase("Y") && !progressInputYN.equalsIgnoreCase("Y")) || !terminationDate.equals("")) { %>
        parent.location = "stxPECDP_LoginFailed2.jsp";
    <% } %>

</script>


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPProgressDeviationHeader">
    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
    <input type="hidden" name="dwgDepartmentCode" value="<%=dwgDepartmentCode%>" />

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr>
            <td colspan="4" height="2"></td>
        </tr>
        <tr height="30">
            <td class="td_title">
                공정 지연현황 조회
            </td>
            <td width="360">호선
                <input type="text" name="projectList" value="" readonly style="width:180px;" />
                <input type="button" name="ProjectsButton" value="…" style="width=22px;" onclick="showProjectSelectWin();"/>
                <% if (isAdmin.equals("Y")) { %>
                &nbsp;&nbsp;<input type="text" name="" value="조회가능 호선관리" class="input_noBorder" 
                                   style="text-decoration:underline;width:100px;background-color: #D8D8D8;cursor: hand;align: right;" 
                                   onclick="showSearchableProjects();" />
                <% } %>
            </td>
            <td>부서
                <select name="departmentList" style="width:220px;" onchange="departmentSelChanged();">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
                    {
                        Map map = (Map)departmentList.get(i);
                        String str1 = (String)map.get("DEPT_CODE");
                        String str2 = str1 + ":&nbsp;";
                        //if (!((String)map.get("UP_DEPT_NAME")).equals((String)map.get("DEPT_NAME"))) 
                        //    str2 += (String)map.get("UP_DEPT_NAME") + "-" + (String)map.get("DEPT_NAME");
                        //else 
                        str2 += (String)map.get("DEPT_NAME");
                        String selected = ""; if (insaDepartmentCode.equals(str1)) selected = "selected";
                        %>
                        <option value="<%=str1%>" <%=selected%>><%=str2%></option>
                        <%
                    }
                    %>
                </select>
                사번
                <select name="designerList" style="width:120px;">
                    <option value="">&nbsp;</option>
                    <%
                    for (int i = 0; personsList != null && i < personsList.size(); i++) {
                        Map map = (Map)personsList.get(i);
                        String empNo = (String)map.get("EMPLOYEE_NO");
                        String empName = (String)map.get("EMPLOYEE_NAME");
                        String empStr = empNo + "&nbsp;&nbsp;&nbsp;&nbsp;" + empName;
                        %>
                        <option value="<%=empNo%>"><%=empStr%></option>
                        <%
                    }
                    %>
                </select>
                	완료List포함<input type="checkbox" name="searchComplete" value="true">
                	<%if(isAdmin.equals("Y")){ %>전체List포함<input type="checkbox" name="searchAll" value="true"><%} else {%><input type="hidden" name="searchAll" value="false"><%} %>
            </td>
            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple2" style="width:40px;" onclick="viewDPProgressDeviation();"/>
                <input type="button" name="SavaButton" value='저 장' class="button_simple2" style="width:40px;" onclick="saveDPProgressDeviation();"/>
                <input type="button" name="PrintButton" value='출 력' class="button_simple2" style="width:40px;" onclick="viewReport();"/>
                <input type="button" name="ExcelButton" value='엑 셀' class="button_simple2" style="width:40px;" onclick="viewReportExcel();"/>
            </td>
        </tr>
        <tr height="28">
            <td style="width:300px;" style="border-right-style:none;">관리기준일 
                <input type="text" name="dateSelected_from" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressDeviationHeader', 'dateSelected_from', '', false, dateChanged_from);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
                    ~
                <input type="text" name="dateSelected_to" value="" class="input_small" style="width:80px;" readonly="readonly">
                <a href="javascript:showCalendar('DPProgressDeviationHeader', 'dateSelected_to', '', false, dateChanged_to);">
                    <img src="../common/images/iconSmallCalendar.gif" border="0" valign="absmiddle"></a>
            </td>
            <td colspan="3" rowspan="2" style="background-color:#dddddd;border-left:none;">
                <table width="100%" cellSpacing="0" cellpadding="0" border="0" align="left">
                <tr>
                    <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        B<br>A<br>S<br>I<br>C<br>
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="bAll" style="width:9pt;" checked onclick="toggleBasicChecks();" />ALL
                        <input type="checkbox" name="bDS" value="bDS" style="width:9pt;" checked />Design Start
                        <input type="checkbox" name="bDF" value="bDF" style="width:9pt;" checked />Design Finish
                        <input type="checkbox" name="bOS" value="bOS" style="width:9pt;" checked />OwnerApp.Submit<br>
                        <input type="checkbox" name="bOF" value="bOF" style="width:9pt;" checked />OwnerApp.Receive
                        <input type="checkbox" name="bCS" value="bCS" style="width:9pt;" checked />ClassApp.Submit
                        <input type="checkbox" name="bCF" value="bCF" style="width:9pt;" checked />ClassApp.Receive<br>
                        <input type="checkbox" name="bRF" value="bRF" style="width:9pt;" checked />Issued for Working
                        <input type="checkbox" name="bWK" value="bWK" style="width:9pt;" checked />Issued for Const
                    </td>
                    <td style="font-size:8pt;font-weight:bold;line-height:10px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        M<br>A<br>K<br>E<br>R<br>
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="mAll" style="width:9pt;" onclick="toggleMakerChecks();" />ALL
                        <input type="checkbox" name="mDS" value="mDS" style="width:9pt;" checked />P.R.
                        <input type="checkbox" name="mDF" value="mDF" style="width:9pt;" />Vender Selection
                        <input type="checkbox" name="mOS" value="mOS" style="width:9pt;" />P.O.<br>
                        <input type="checkbox" name="mOF" value="mOF" style="width:9pt;" checked />VenderDwg.Receive
                        <input type="checkbox" name="mCS" value="mCS" style="width:9pt;" checked />OwnerApp.Submit
                        <input type="checkbox" name="mCF" value="mCF" style="width:9pt;" checked />OwnerApp.Receive<br>
                        <input type="checkbox" name="mRF" value="mRF" style="width:9pt;" checked />Issued for Working
                        <input type="checkbox" name="mWK" value="mWK" style="width:9pt;" checked />Issued for Const
                    </td>
                    <td style="font-size:7pt;font-weight:bold;line-height:8px;background-color:#bbbbbb;padding-left:1px;width:8px;">
                        P<br>R<br>O<br>D<br>U<br>C<br>T
                    </td>
                    <td style="font-family:Arial;font-size:9pt;padding:0px;padding-left:2px;letter-spacing:0px;">
                        <input type="checkbox" name="pAll" style="width:9pt;" onclick="toggleProductionChecks();" />ALL
                        <input type="checkbox" name="pDS" value="pDS" style="width:9pt;" />Design Start
                        <input type="checkbox" name="pDF" value="pDF" style="width:9pt;" />Design Finish
                        <input type="checkbox" name="pOS" value="pOS" style="width:9pt;" />OwnerApp.Submit<br>
                        <input type="checkbox" name="pOF" value="pOF" style="width:9pt;" />OwnerApp.Receive
                        <input type="checkbox" name="pCS" value="pCS" style="width:9pt;" />ClassApp.Submit
                        <input type="checkbox" name="pCF" value="pCF" style="width:9pt;" />ClassApp.Receive<br>
                        <input type="checkbox" name="pRF" value="pRF" style="width:9pt;" />Issued for Working
                        <input type="checkbox" name="pWK" value="pWK" style="width:9pt;" checked />Issued for Const
                    </td>
                </tr>
                </table>
                <!--
                <input type="checkbox" name="DW_S" value="DW_S" style="width:10pt;" checked />&nbsp;DW(S)
                <input type="checkbox" name="OW_S" value="OW_S" style="width:10pt;" checked />&nbsp;OW(S)
                <input type="checkbox" name="CL_S" value="CL_S" style="width:10pt;" checked />&nbsp;CL(S)
                <input type="checkbox" name="RF" value="RF" style="width:10pt;" checked />&nbsp;RF
                <input type="checkbox" name="WK" value="WK" style="width:10pt;" checked />&nbsp;WK<br>
                <input type="checkbox" name="DW_F" value="DW_F" style="width:10pt;" checked />&nbsp;DW(F)
                <input type="checkbox" name="OW_F" value="OW_F" style="width:10pt;" checked />&nbsp;OW(F)
                <input type="checkbox" name="CL_F" value="CL_F" style="width:10pt;" checked />&nbsp;CL(F)
                -->
            </td>
        </tr>
        <tr height="30">
            <td bgcolor="#00ffff">
                <b>Total Deviation:</b>&nbsp;
                <input type="text" name="totalDeviation" value="" style="width:50px;background-color:#ffffcc" readonly="readonly" />
            </td>
        </tr>
    </table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    parent.PROGRESS_DEV_MAIN.location = "stxPECDPProgressDeviationViewMain.jsp"; // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록.

	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

    // 날짜 출력 문자열을 형식화
    function dateChanged_from()
    {
        var tmpStr = DPProgressDeviationHeader.dateSelected_from.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressDeviationHeader.dateSelected_from.value = dateStr;
        }
    }
    
    function dateChanged_to()
    {
        var tmpStr = DPProgressDeviationHeader.dateSelected_to.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            var dateStr = formatDateStr(tmpStr);
            DPProgressDeviationHeader.dateSelected_to.value = dateStr;
        }
    }

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPProgressDeviationHeader.projectList.value;
        paramStr += "&loginID=" + DPProgressDeviationHeader.loginID.value;
        paramStr += "&category=DEVIATION";
        var selectedProjects = window.showModalDialog("stxPECDPProgressDeviationView_ProjectSelect.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPProgressDeviationHeader.projectList.value = selectedProjects;
    }

    // 조회가능 호선관리 창을 Show
    function showSearchableProjects()
    {
        var sProperties = 'dialogHeight:350px;dialogWidth:300px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "loginID=" + DPProgressDeviationHeader.loginID.value;
        paramStr += "&category=DEVIATION";
        window.showModalDialog("stxPECDPProgressDeviation_ProjectSelect.jsp?" + paramStr, "", sProperties);
    }

    // 부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
    function departmentSelChanged() 
    {
        for (var i = DPProgressDeviationHeader.designerList.options.length - 1; i > 0; i--) {
            DPProgressDeviationHeader.designerList.options[i] = null;
        }
        if (DPProgressDeviationHeader.departmentList.value == "") return;

        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=getPartPersonsForDPProgress&departCode=" + 
                            DPProgressDeviationHeader.departmentList.value, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;

                if (resultMsg != null) 
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == "") return;

                    var strs = resultMsg.split("+");
                    for (var i = 0; i < strs.length; i++) {
                        var strs2 = strs[i].split("|");
                        var newOption = new Option(strs2[0] + "    " + strs2[1], strs2[0]);
                        DPProgressDeviationHeader.designerList.options[i + 1] = newOption;
                    }
                } else alert(resultMsg);
            } else alert(resultMsg);
        } else alert(resultMsg);
    }

    // BASIC 도면 관리기준일 체크항목을 모두 체크 or 모두 체크 해제
    function toggleBasicChecks()
    {
        var checked = DPProgressDeviationHeader.bAll.checked;

        DPProgressDeviationHeader.bDS.checked = checked;
        DPProgressDeviationHeader.bDF.checked = checked;
        DPProgressDeviationHeader.bOS.checked = checked;
        DPProgressDeviationHeader.bOF.checked = checked;
        DPProgressDeviationHeader.bCS.checked = checked;
        DPProgressDeviationHeader.bCF.checked = checked;
        DPProgressDeviationHeader.bRF.checked = checked;
        DPProgressDeviationHeader.bWK.checked = checked;
    }

    // MAKER 도면 관리기준일 체크항목을 모두 체크 or 모두 체크 해제
    function toggleMakerChecks()
    {
        var checked = DPProgressDeviationHeader.mAll.checked;

        DPProgressDeviationHeader.mDS.checked = checked;
        DPProgressDeviationHeader.mDF.checked = checked;
        DPProgressDeviationHeader.mOS.checked = checked;
        DPProgressDeviationHeader.mOF.checked = checked;
        DPProgressDeviationHeader.mCS.checked = checked;
        DPProgressDeviationHeader.mCF.checked = checked;
        DPProgressDeviationHeader.mRF.checked = checked;
        DPProgressDeviationHeader.mWK.checked = checked;
    }

    // PRODUCTION 도면 관리기준일 체크항목을 모두 체크 or 모두 체크 해제
    function toggleProductionChecks()
    {
        var checked = DPProgressDeviationHeader.pAll.checked;

        DPProgressDeviationHeader.pDS.checked = checked;
        DPProgressDeviationHeader.pDF.checked = checked;
        DPProgressDeviationHeader.pOS.checked = checked;
        DPProgressDeviationHeader.pOF.checked = checked;
        DPProgressDeviationHeader.pCS.checked = checked;
        DPProgressDeviationHeader.pCF.checked = checked;
        DPProgressDeviationHeader.pRF.checked = checked;
        DPProgressDeviationHeader.pWK.checked = checked;
    }

    // 입력 조건 체크
    function checkInputs()
    {
        if (DPProgressDeviationHeader.projectList.value == "") {
            alert("호선을 선택하십시오.");
            return false;
        }

        //if (DPProgressDeviationHeader.departmentList.value == "") {
        //    alert("부서를 선택하십시오.");
        //    return false;
        //}
        if (DPProgressDeviationHeader.dateSelected_to.value == "") {
            alert("관리기준일을 입력하십시오.");
            return false;
        }

        if (DPProgressDeviationHeader.bDS.checked == false && 
            DPProgressDeviationHeader.bDF.checked == false && 
            DPProgressDeviationHeader.bOS.checked == false && 
            DPProgressDeviationHeader.bOF.checked == false && 
            DPProgressDeviationHeader.bCS.checked == false && 
            DPProgressDeviationHeader.bCF.checked == false && 
            DPProgressDeviationHeader.bRF.checked == false && 
            DPProgressDeviationHeader.bWK.checked == false && 
            DPProgressDeviationHeader.mDS.checked == false && 
            DPProgressDeviationHeader.mDF.checked == false && 
            DPProgressDeviationHeader.mOS.checked == false && 
            DPProgressDeviationHeader.mOF.checked == false && 
            DPProgressDeviationHeader.mCS.checked == false && 
            DPProgressDeviationHeader.mCF.checked == false && 
            DPProgressDeviationHeader.mRF.checked == false && 
            DPProgressDeviationHeader.mWK.checked == false && 
            DPProgressDeviationHeader.pDS.checked == false && 
            DPProgressDeviationHeader.pDF.checked == false && 
            DPProgressDeviationHeader.pOS.checked == false && 
            DPProgressDeviationHeader.pOF.checked == false && 
            DPProgressDeviationHeader.pCS.checked == false && 
            DPProgressDeviationHeader.pCF.checked == false && 
            DPProgressDeviationHeader.pRF.checked == false && 
            DPProgressDeviationHeader.pWK.checked == false
           )
        {
            alert("관리기준일 조건을 하나 이상 체크하십시오.");
            return false;
        }

        return true;
    }

    // 공정 지연현황 조회 실행
    function viewDPProgressDeviation()
    {
        if (!checkInputs()) return;

        //// 사용자 입력사항이 있으면 변경사항을 먼저 저장
        //if (parent.PROGRESS_DEV_MAIN.DPProgressDeviationMain != null) {
        //    var dataChanged = parent.PROGRESS_DEV_MAIN.DPProgressDeviationMain.dataChanged.value;
        //    if (dataChanged == "true") {
        //        var msg = "변경된 내용이 있습니다. 변경사항을 저장하시겠습니까?\n\n" + 
        //                  "[확인] : 변경사항 저장 , [취소] 변경사항 무시";
        //        if (confirm(msg)) saveDPProgressDeviation();
        //    }
        //}

        // 조회
        var urlStr = "stxPECDPProgressDeviationViewMain.jsp?projectNo=" + DPProgressDeviationHeader.projectList.value;
        urlStr += "&deptCode=" + DPProgressDeviationHeader.departmentList.value;
        urlStr += "&designerId=" + DPProgressDeviationHeader.designerList.value;
        urlStr += "&dateSelected_to=" + DPProgressDeviationHeader.dateSelected_to.value;
        urlStr += "&dateSelected_from=" + DPProgressDeviationHeader.dateSelected_from.value;
        urlStr += "&searchComplete=" + DPProgressDeviationHeader.searchComplete.checked;
        urlStr += "&searchAll=" + DPProgressDeviationHeader.searchAll.checked;
        urlStr += "&userDept=" + DPProgressDeviationHeader.dwgDepartmentCode.value;
        urlStr += "&isAdmin=" + DPProgressDeviationHeader.isAdmin.value;

        urlStr += "&bDS=" + (DPProgressDeviationHeader.bDS.checked ? "Y" : "N");
        urlStr += "&bDF=" + (DPProgressDeviationHeader.bDF.checked ? "Y" : "N");
        urlStr += "&bOS=" + (DPProgressDeviationHeader.bOS.checked ? "Y" : "N");
        urlStr += "&bOF=" + (DPProgressDeviationHeader.bOF.checked ? "Y" : "N");
        urlStr += "&bCS=" + (DPProgressDeviationHeader.bCS.checked ? "Y" : "N");
        urlStr += "&bCF=" + (DPProgressDeviationHeader.bCF.checked ? "Y" : "N");
        urlStr += "&bRF=" + (DPProgressDeviationHeader.bRF.checked ? "Y" : "N");
        urlStr += "&bWK=" + (DPProgressDeviationHeader.bWK.checked ? "Y" : "N");
        urlStr += "&mDS=" + (DPProgressDeviationHeader.mDS.checked ? "Y" : "N");
        urlStr += "&mDF=" + (DPProgressDeviationHeader.mDF.checked ? "Y" : "N");
        urlStr += "&mOS=" + (DPProgressDeviationHeader.mOS.checked ? "Y" : "N");
        urlStr += "&mOF=" + (DPProgressDeviationHeader.mOF.checked ? "Y" : "N");
        urlStr += "&mCS=" + (DPProgressDeviationHeader.mCS.checked ? "Y" : "N");
        urlStr += "&mCF=" + (DPProgressDeviationHeader.mCF.checked ? "Y" : "N");
        urlStr += "&mRF=" + (DPProgressDeviationHeader.mRF.checked ? "Y" : "N");
        urlStr += "&mWK=" + (DPProgressDeviationHeader.mWK.checked ? "Y" : "N");
        urlStr += "&pDS=" + (DPProgressDeviationHeader.pDS.checked ? "Y" : "N");
        urlStr += "&pDF=" + (DPProgressDeviationHeader.pDF.checked ? "Y" : "N");
        urlStr += "&pOS=" + (DPProgressDeviationHeader.pOS.checked ? "Y" : "N");
        urlStr += "&pOF=" + (DPProgressDeviationHeader.pOF.checked ? "Y" : "N");
        urlStr += "&pCS=" + (DPProgressDeviationHeader.pCS.checked ? "Y" : "N");
        urlStr += "&pCF=" + (DPProgressDeviationHeader.pCF.checked ? "Y" : "N");
        urlStr += "&pRF=" + (DPProgressDeviationHeader.pRF.checked ? "Y" : "N");
        urlStr += "&pWK=" + (DPProgressDeviationHeader.pWK.checked ? "Y" : "N");

        parent.PROGRESS_DEV_MAIN.location = urlStr;
    }

    // 입력사항 저장
    function saveDPProgressDeviation()
    {
        parent.PROGRESS_DEV_MAIN.saveDPProgressDev();
    }

    // 프린트(리포트 출력) - VIEW & PRINT 양식
    function viewReport()
    {
        var rdFileName = "stxPECDPProgressDeviationViewAdmin.mrd";
        //if (DPProgressDeviationHeader.isAdmin.value != "Y") rdFileName = "stxPECDPProgressDeviationView.mrd";
        viewReportProc(rdFileName);
    }

    // 프린트(리포트 출력) - EXCEL EXPORT 양식
    function viewReportExcel()
    {
        viewReportProc("stxPECDPProgressDeviationViewExcel.mrd");
    }

    // 프린트(리포트 출력) 서브 프로시저
    function viewReportProc(rdFileName)
    {
        if (!checkInputs()) return;

        var projectNoStrs = DPProgressDeviationHeader.projectList.value;

		var strs = projectNoStrs.split(",");
        projectNoStrs = "";
		for (var i = 0; i < strs.length; i++) {
			var tempStr = strs[i];
			if (i > 0) projectNoStrs += ",";
			projectNoStrs += "'" + tempStr.trim() + "'";
		}

        var paramStr = projectNoStrs + ":::" + 
                       DPProgressDeviationHeader.departmentList.value + ":::" + 
                       DPProgressDeviationHeader.dateSelected_to.value + ":::";

        paramStr += (DPProgressDeviationHeader.bDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.bWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.mWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pDS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pDF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pOS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pOF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pCS.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pCF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pRF.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.pWK.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.dateSelected_from.value == '' ? 'N' : DPProgressDeviationHeader.dateSelected_from.value) + ":::";
        paramStr += (DPProgressDeviationHeader.searchComplete.checked ? "Y" : "N") + ":::";
        paramStr += (DPProgressDeviationHeader.searchAll.checked ? "Y" : "N");
        //paramStr = encodeURIComponent(paramStr);
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=<%=reportFileUrl%>" + rdFileName 
                      + "&param=" + paramStr;
        window.open(urlStr, "", "");
    }

    /* 화면(기능)이 실행되면 초기 상태를 오늘 날짜를 기준으로 설정 */
    var today = new Date();
    var y = today.getFullYear().toString();
    var m = (today.getMonth()+1).toString();
    if (m.length == 1) m = 0 + m;
    var d = today.getDate().toString();
    if (d.length == 1) d = 0 + d;
    var ymd = y + "-" + m + "-" + d;

    DPProgressDeviationHeader.dateSelected_to.value = ymd;


</script>


</html>