<%--  
§DESCRIPTION: 호선 별 시수 ERP I/F 화면 Header 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProjectDataERPIFHeader.jsp
§CHANGING HISTORY: 
§    2009-08-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");

    String errStr = "";
    ArrayList factorCaseList = null;

    // DB에서 데이터 쿼리하여 항목들의 값 설정
    try {
        factorCaseList = getMHFactorCaseAndValueList();
    }
    catch (Exception e) {
        errStr = e.toString();
    }    

    Calendar c = Calendar.getInstance(); 
    int currentYear = c.get(Calendar.YEAR); 
    int currentMonth = c.get(Calendar.MONTH) + 1; 
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>호선 별 시수조회 - ERP I/F</title>
</head>
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


<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPProjectDataERPIFHeader">

    <table width="100%" cellSpacing="0" border="1" align="left">
        <tr height="30">
            <td width="210">전송년월
                <select name="yearSelect" style="width:70px;" onchange="yearSelectChanged();">
                    <option value="">&nbsp;</option>
                    <% for (int i = currentYear; i >= 1996; i--) { %>
                        <option value="<%= i %>"><%= i %> 년</option>
                    <% } %>
                </select>
                <select name="monthSelect" style="width:60px;">
                    <option value="">&nbsp;</option>
                </select>
            </td>
            <td width="390">적용 CASE
                <select name="factorCaseList" style="width:280px;">
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
            <td>
                <input type="button" name="ViewButton" value='조 회' class="button_simple" onclick="viewDPInputsList();"/>
            </td>
            <td>
                <input type="button" name="reportButton" value='리포트' class="button_simple" onclick="viewReport();"/>
            </td>
        </tr>

        <tr height="30">
            <td>호선
                <input type="text" name="projectList" value="" style="width:180px;" />
                <input type="button" name="projectButton" value="…" style="width=22px;" onclick="showProjectSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="projectList.value=''" />
            </td>
            <td>전송대상
                <select name="targetSelect" style="width:115px;">
                    <option value="기술기획팀">기술기획팀</option>
                    <option value="해양설계관리팀">해양설계관리팀</option>
                </select>
                &nbsp;
                부서
                <input type="text" name="departmentList" value="" readonly style="width:180px;" />
                <input type="button" name="departmentButton" value="…" style="width=22px;" onclick="showDepartmentSelectWin();"/>
                <input type="text" name="" value="clear" class="input_noBorder" 
                       style="text-decoration:underline;width:40px;background-color: #D8D8D8;cursor: hand;" onclick="departmentList.value=''" />
            </td>
            <td colspan="2">
                <input type="button" name="erpIFButton" value='ERP 전송실행' class="button_simple" style="width:130px" onclick="executeERPIF();"/>
            </td>
        </tr>
    </table>

    <input type="hidden" name="loginID" value="<%=loginID%>" />
    <input type="hidden" name="currentYear" value="<%=currentYear%>" />
    <input type="hidden" name="currentMonth" value="<%=currentMonth%>" />

    <input type="hidden" name="dateFromVal" value="" />
    <input type="hidden" name="dateToVal" value="" />
    <input type="hidden" name="projectListVal" value="" />
    <input type="hidden" name="targetVal" value="" />
    <input type="hidden" name="departmentListVal" value="" />
    <input type="hidden" name="factorCaseVal" value="" />
    <input type="hidden" name="firstCall" value="" />

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">    

    // 년도 선택 변경 시 월 선택 값 초기화
    function yearSelectChanged()
    {
        for (var i = DPProjectDataERPIFHeader.monthSelect.options.length - 1; i > 0; i--) {
            DPProjectDataERPIFHeader.monthSelect.options[i] = null;
        }

        var yearSelected = DPProjectDataERPIFHeader.yearSelect.value;
        if (yearSelected == "") return;

        if (yearSelected == DPProjectDataERPIFHeader.currentYear.value) {
            for (var i = DPProjectDataERPIFHeader.currentMonth.value - 1; i >= 1; i--) {
                DPProjectDataERPIFHeader.monthSelect.options[DPProjectDataERPIFHeader.monthSelect.options.length] = new Option(i + " 월", i);
            }
        }
        else {
            for (var i = 12; i >= 1; i--) {
                DPProjectDataERPIFHeader.monthSelect.options[DPProjectDataERPIFHeader.monthSelect.options.length] = new Option(i + " 월", i);
            }
        }
    }

    // 호선지정 화면 팝업
    function showProjectSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedProjects=" + DPProjectDataERPIFHeader.projectList.value;
        var selectedProjects = window.showModalDialog("stxPECDPDataMgmt_SelectProject.jsp?" + paramStr, "", sProperties);
        if (selectedProjects == null || selectedProjects.toLowerCase() == "null" || selectedProjects.toLowerCase() == "undefined") return;
        DPProjectDataERPIFHeader.projectList.value = selectedProjects;
    }

    // 부서지정 화면 팝업
    function showDepartmentSelectWin() 
    {
        var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
        var paramStr = "selectedDepartments=" + DPProjectDataERPIFHeader.departmentList.value;
        var selectedDepartmentsStr = window.showModalDialog("stxPECDPDataMgmt_SelectDepartment.jsp?" + paramStr, "", sProperties);

        if (selectedDepartmentsStr != null && selectedDepartmentsStr != 'undefined') 
        {
            var strs = selectedDepartmentsStr.split("|");
            DPProjectDataERPIFHeader.departmentList.value = strs[0];

            // Hint 표시 관련 코드 추가 가능 (현재는 사용 X)
        }
    }

    // 시수입력 현황을 조회
    function viewDPInputsList() 
    {
        var yearStr = DPProjectDataERPIFHeader.yearSelect.value;
        var monthStr = DPProjectDataERPIFHeader.monthSelect.value;
        if (yearStr == "" || monthStr == "") {
            alert("전송년월을 선택하십시오!");
            return;
        }

        var fromYear = eval(yearStr);
        var fromMonth = eval(monthStr);
        
        var toYear = fromMonth == 12 ? fromYear + 1 : fromYear;
        var toMonth = fromMonth == 12 ? 1 : fromMonth + 1;

        var fromYearStr = fromYear;
        var fromMonthStr = fromMonth <= 9 ? "0" + fromMonth : fromMonth;
        var toYearStr = toYear;
        var toMonthStr = toMonth <= 9 ? "0" + toMonth : toMonth;
        
        var projectStr = DPProjectDataERPIFHeader.projectList.value.trim();
        if (projectStr != "") {
            var strs = projectStr.split(",");
            projectStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectStr += ",";
                projectStr += "'" + strs[i].trim() + "'";
            }
        }

        var targetStr = DPProjectDataERPIFHeader.targetSelect.value.trim();

        var departmentStr = DPProjectDataERPIFHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }

        /*
        var urlStr = "stxPECDPProjectDataERPIFMain.jsp?";
        urlStr += "dateFrom=" + fromYearStr + "" + fromMonthStr + "01";
        urlStr += "&dateTo=" + toYearStr + "" + toMonthStr + "01";
        urlStr += "&projectList=" + projectStr;
        urlStr += "&targetStr=" + targetStr;
        urlStr += "&departmentStr=" + departmentStr;
        urlStr += "&factorCase=" + DPProjectDataERPIFHeader.factorCaseList.value;
        urlStr += "&firstCall=N";
        parent.DP_ERPIF_MAIN2.location = urlStr;
        */

        DPProjectDataERPIFHeader.dateFromVal.value = fromYearStr + "" + fromMonthStr + "01";
        DPProjectDataERPIFHeader.dateToVal.value = toYearStr + "" + toMonthStr + "01";
        DPProjectDataERPIFHeader.projectListVal.value = projectStr;
        DPProjectDataERPIFHeader.targetVal.value = targetStr;
        DPProjectDataERPIFHeader.departmentListVal.value = departmentStr;
        DPProjectDataERPIFHeader.factorCaseVal.value = DPProjectDataERPIFHeader.factorCaseList.value;
        DPProjectDataERPIFHeader.firstCall.value = "N";

        DPProjectDataERPIFHeader.action = "stxPECDPProjectDataERPIFMain.jsp";
        DPProjectDataERPIFHeader.method = "post";
        DPProjectDataERPIFHeader.target = "DP_ERPIF_MAIN2";
        DPProjectDataERPIFHeader.submit();
    }

    // 프린트(리포트 출력)
    function viewReport()
    {
        var yearStr = DPProjectDataERPIFHeader.yearSelect.value;
        var monthStr = DPProjectDataERPIFHeader.monthSelect.value;
        if (yearStr == "" || monthStr == "") {
            alert("전송년월을 선택하십시오!");
            return;
        }

        var fromYear = eval(yearStr);
        var fromMonth = eval(monthStr);
        
        var toYear = fromMonth == 12 ? fromYear + 1 : fromYear;
        var toMonth = fromMonth == 12 ? 1 : fromMonth + 1;

        var fromYearStr = fromYear;
        var fromMonthStr = fromMonth <= 9 ? "0" + fromMonth : fromMonth;
        var toYearStr = toYear;
        var toMonthStr = toMonth <= 9 ? "0" + toMonth : toMonth;
        
        var projectStr = DPProjectDataERPIFHeader.projectList.value.trim();
        if (projectStr != "") {
            var strs = projectStr.split(",");
            projectStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) projectStr += ",";
                projectStr += "'" + strs[i].trim() + "'";
            }
        }        

        var targetStr = DPProjectDataERPIFHeader.targetSelect.value.trim();

        var departmentStr = DPProjectDataERPIFHeader.departmentList.value.trim();
        if (departmentStr != "") {
            var strs = departmentStr.split(",");
            departmentStr = "";
            for (var i = 0; i < strs.length; i++) {
                if (i > 0) departmentStr += ",";
                departmentStr += "'" + strs[i].trim() + "'";
            }
        }

        var urlStr = "";
        /*
        urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/";
        urlStr += "stxPECDPProjectDataERPIFView.mrd&param=";
        */
        urlStr += fromYearStr + "" + fromMonthStr + "01" + ":::";
        urlStr += toYearStr + "" + toMonthStr + "01" + ":::";
        urlStr += fromYearStr + "" + fromMonthStr + ":::";
        urlStr += DPProjectDataERPIFHeader.factorCaseList.value + ":::";
        urlStr += fromYearStr + "." + fromMonthStr + ":::";      
        urlStr += (projectStr == "" ? "ALL" : "SELECTED") + ":::";      
        urlStr += projectStr + ":::";
        urlStr += targetStr + ":::";
        urlStr += departmentStr;
        /*
        window.open(urlStr, "", "");
        */

        var thisForm = document.forms[0];
        thisForm.insertBefore(createHidden("src", "http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPProjectDataERPIFView.mrd"));
        thisForm.insertBefore(createHidden("param", urlStr));
        var reportWin = window.open("", "reportWindow", "");
        thisForm.action = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp";
        thisForm.method = "post";
        thisForm.target = "reportWindow";
        thisForm.submit();
    }
    // Utility Function: Hidden Element 생성
    function createHidden(nameStr, valueStr) 
    {
        var obj = document.createElement("input");
        obj.type = "hidden";
        obj.name = nameStr;
        obj.value = valueStr;
        return obj;
    }

    // ERP I/F 실행
    function executeERPIF()
    {
        var confirmResult = parent.DP_ERPIF_MAIN2.confirmERPIFExecute();
        if (confirmResult == -1) return;
        if (confirmResult == 0) {
            alert("전송할 대상이 없습니다!");
            return;
        }
        else {
            parent.DP_ERPIF_MAIN2.executeERPIF();
        }
    }

    // Header 페이지가 먼저 로드된 후 Main 페이지가 로드되도록
    parent.DP_ERPIF_MAIN2.location = "stxPECDPProjectDataERPIFMain.jsp?firstCall=Y"; 

/*
    // 프린트(리포트 출력)
    function printPage()
    {
        var designerIDSel = DPInputListViewHeader.dpDesignerIDSel.value;
        var dateSelectedFrom = DPInputListViewHeader.dateSelectedFrom.value;
        var dateSelectedTo = DPInputListViewHeader.dateSelectedTo.value;
        var projectSel = DPInputListViewHeader.projectSel.value;
        var causeDeptCode = DPInputListViewHeader.causeDepartmentSel.value;
        
		var drawingNo = "";
        drawingNo += DPInputListViewHeader.drawingNo1.value == "" ? "_" : DPInputListViewHeader.drawingNo1.value;
        drawingNo += DPInputListViewHeader.drawingNo2.value == "" ? "_" : DPInputListViewHeader.drawingNo2.value;
        drawingNo += DPInputListViewHeader.drawingNo3.value == "" ? "_" : DPInputListViewHeader.drawingNo3.value;
        drawingNo += DPInputListViewHeader.drawingNo4.value == "" ? "_" : DPInputListViewHeader.drawingNo4.value;
        drawingNo += DPInputListViewHeader.drawingNo5.value == "" ? "_" : DPInputListViewHeader.drawingNo5.value;
        drawingNo += DPInputListViewHeader.drawingNo6.value == "" ? "_" : DPInputListViewHeader.drawingNo6.value;
        drawingNo += DPInputListViewHeader.drawingNo7.value == "" ? "_" : DPInputListViewHeader.drawingNo7.value;
        drawingNo += DPInputListViewHeader.drawingNo8.value == "" ? "_" : DPInputListViewHeader.drawingNo8.value;
        if (drawingNo == "________") drawingNo = "";
        else drawingNo = "%" + drawingNo + "%";

        var opCode = DPInputListViewHeader.opCode.value;
        var e1 = DPInputListViewHeader.checkE1.checked ? "Y" : "N";
        var e2 = DPInputListViewHeader.checkE2.checked ? "Y" : "N";
        var e3 = DPInputListViewHeader.checkE3.checked ? "Y" : "N";

        var paramStr = designerIDSel + ":::" + 
                       dateSelectedFrom + ":::" + 
                       dateSelectedTo + ":::" + 
                       projectSel + ":::" + 
                       causeDeptCode + ":::" + 
                       drawingNo + ":::" +  
                       opCode + ":::" +  
                       e1 + ":::" +  
                       e2 + ":::" +  
                       e3; 
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPInput_InputListView.mrd&param=" + paramStr;
        window.open(urlStr, "", "");
    }
*/
    
</script>

</html>