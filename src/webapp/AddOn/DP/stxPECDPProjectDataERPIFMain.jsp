<%--  
§DESCRIPTION: 호선 별 시수 ERP I/F 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProjectDataERPIFMain.jsp
§CHANGING HISTORY: 
§    2009-08-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP (GLOBAL) ================================--%>
<%!
	// getDesignMHSummaryByProjectForERPIF(): 호선 별 시수조회(For ERP I/F)
	private ArrayList getDesignMHSummaryByProjectForERPIF(String dateFrom, String dateTo, String projectNoList, 
    String departmentNoList, String factorCase, String target) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");
		if (StringUtil.isNullString(factorCase)) throw new Exception("Factor Case is null");
		String currentMonth = dateFrom.substring(0, 6);

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.PROJECT_NO,                                                                                               ");
			queryStr.append("       A.WTIME,                                                                                                    ");
			queryStr.append("       NVL(A.WTIME_F, 0),                                                                                          ");
			queryStr.append("       B.QTY2 AS ERP_WTIME_F,                                                                                      ");
			queryStr.append("       TO_CHAR(B.CREATION_DATE, 'YYYY/MM/DD') AS ERP_CREATE_DATE                                                   ");
			queryStr.append("  FROM                                                                                                             ");
			queryStr.append("  (                                                                                                                ");
			queryStr.append("    SELECT PROJECT_NO,                                                                                             ");
			queryStr.append("           SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) AS WTIME,                                                    ");
			queryStr.append("           SUM(NORMAL_TIME_F + OVERTIME_F + SPECIAL_TIME_F) AS WTIME_F                                             ");
			queryStr.append("      FROM                                                                                                         ");
			queryStr.append("      (                                                                                                            ");
			queryStr.append("        SELECT PROJECT_NO,                                                                                         ");
			queryStr.append("               NORMAL_TIME,                                                                                        ");
			queryStr.append("               OVERTIME,                                                                                           ");
			queryStr.append("               SPECIAL_TIME,                                                                                       ");
			queryStr.append("               TO_CHAR(NORMAL_TIME * MH_FACTOR) AS NORMAL_TIME_F,                                                  ");
			queryStr.append("               TO_CHAR(OVERTIME * MH_FACTOR) AS OVERTIME_F,                                                        ");
			queryStr.append("               TO_CHAR(SPECIAL_TIME * MH_FACTOR) AS SPECIAL_TIME_F                                                 ");
			queryStr.append("          FROM                                                                                                     ");
			queryStr.append("          (                                                                                                        ");
			queryStr.append("           SELECT PROJECT_NO,                                                                                      ");
			queryStr.append("                  NORMAL_TIME,                                                                                     ");
			queryStr.append("                  OVERTIME,                                                                                        ");
			queryStr.append("                  SPECIAL_TIME,                                                                                    ");
			queryStr.append("                  CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                           ");
			queryStr.append("                       ELSE (                                                                                      ");
			queryStr.append("                                SELECT FACTOR_VALUE                                                                ");
			queryStr.append("                                  FROM (                                                                           ");
			queryStr.append("                                        SELECT CAREER_MONTH_FROM,                                                  ");
			queryStr.append("                                               CAREER_MONTH_TO,                                                    ");
			queryStr.append("                                               FACTOR_VALUE                                                        ");
			queryStr.append("                                          FROM PLM_DESIGN_MH_FACTOR                                                ");
			queryStr.append("                                         WHERE 1 = 1                                                               ");
			queryStr.append("                                           AND CASE_NO = '" + factorCase + "'                                      ");
			queryStr.append("                                       )                                                                           ");
			queryStr.append("                                 WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                          ");
			queryStr.append("                                   AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                 ");
			queryStr.append("                            )                                                                                      ");
			queryStr.append("                  END AS MH_FACTOR                                                                                 ");
			queryStr.append("             FROM                                                                                                  ");
			queryStr.append("             (                                                                                                     ");
			queryStr.append("                SELECT A.PROJECT_NO,                                                                               ");
			queryStr.append("                       A.NORMAL_TIME,                                                                              ");
			queryStr.append("                       A.OVERTIME,                                                                                 ");
			queryStr.append("                       A.SPECIAL_TIME,                                                                             ");
			//queryStr.append("                       CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                                      ");
			//queryStr.append("                            ELSE (                                                                                 ");
			queryStr.append("                                   ((TO_CHAR(A.WORK_DAY, 'YYYY') - TO_CHAR(B.DESIGN_APPLY_DATE, 'YYYY'))* 12 +     ");
			queryStr.append("                                    (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +            ");
			queryStr.append("                                   CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                       ");
			queryStr.append("                                        WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                        ");
			queryStr.append("                                   END +                                                                           ");
			queryStr.append("                                   NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                                 ");
			//queryStr.append("                                 )                                                                                 ");
			//queryStr.append("                       END                                                                                         ");
			queryStr.append("                       AS CAREER_MONTHS                                                                            ");
			queryStr.append("                  FROM PLM_DESIGN_MH A,                                                                            ");
			queryStr.append("                       CCC_SAWON B                                                                                 ");
			queryStr.append("                 WHERE 1 = 1                                                                                       ");
			queryStr.append("                   AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM(+)                                                           ");
			queryStr.append("                   AND A.OP_CODE NOT LIKE '9%'                                                                     ");
			if (!StringUtil.isNullString(projectNoList))
			queryStr.append("                   AND A.PROJECT_NO IN (" + projectNoList + ")                                                     ");
			if (!StringUtil.isNullString(departmentNoList))
			queryStr.append("                   AND A.DEPT_CODE IN (" + departmentNoList + ")                                                     ");
			queryStr.append("                   AND A.WORK_DAY >= TO_DATE('" + dateFrom + "', 'YYYYMMDD')                                       ");
			queryStr.append("                   AND A.WORK_DAY < TO_DATE('" + dateTo + "', 'YYYYMMDD')                                          ");
			queryStr.append("             )                                                                                                     ");
			queryStr.append("          )                                                                                                        ");
			queryStr.append("      )                                                                                                            ");
			queryStr.append("     GROUP BY PROJECT_NO                                                                                           ");
			queryStr.append("     ORDER BY PROJECT_NO                                                                                           ");
			queryStr.append("  ) A, STX_PA_CST_MASTER_INFO@STXERP B                                                                             ");
			queryStr.append(" WHERE A.PROJECT_NO = B.PROJECT_NAME_S(+)                                                                          ");
			queryStr.append("   AND B.COLLECTION_CODE(+) = 'PLM_J_01'                                                                           ");
			queryStr.append("   AND B.UNIT_SEGMENT(+) = '" + target + "'                                                                        ");
			queryStr.append("   AND B.CURRENT_MONTH(+) = '" + currentMonth + "'                                                                 ");
			queryStr.append("  ORDER BY A.PROJECT_NO                                                                                            ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1));
				resultMap.put("WTIME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("WTIME_F", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("ERP_WTIME_F", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("ERP_CREATE_DATE", rset.getString(5) == null ? "" : rset.getString(5));

				resultArrayList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultArrayList;
	}
%>


<%--========================== JSP =========================================--%>
<%
    request.setCharacterEncoding("euc-kr"); 

    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFromVal"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateToVal"));
    String projectList = StringUtil.setEmptyExt(emxGetParameter(request, "projectListVal"));
    String targetStr = StringUtil.setEmptyExt(emxGetParameter(request, "targetVal"));
    String departmentList = StringUtil.setEmptyExt(emxGetParameter(request, "departmentListVal"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCaseVal"));
    String firstCall = StringUtil.setEmptyExt(emxGetParameter(request, "firstCall"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));

    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ dateFrom = " + dateFrom);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ dateTo = " + dateTo);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ projectList = " + projectList);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ targetStr = " + targetStr);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ departmentList = " + departmentList);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ factorCase = " + factorCase);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ firstCall = " + firstCall);
    //System.out.println("stxPECDPProjectDataERPIFMain.jsp ~~~ showMsg = " + showMsg);

    String errStr = "";

    ArrayList dpInputsList = null;

    try {
        if (!firstCall.equals("Y")) {
            dpInputsList = getDesignMHSummaryByProjectForERPIF(dateFrom, dateTo, projectList, departmentList, factorCase, targetStr);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    ArrayList erpIFTargetDataList = new ArrayList();
    String yearMonthStr = "";
    if (!StringUtil.isNullString(dateFrom)) yearMonthStr = dateFrom.substring(0, 6);
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>호선 별 시수조회 - ERP I/F</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
<script language="javascript">

    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPProjectDataERPIFMain" action="stxPECDPProjectDataERPIFMain.jsp" method="post" >

    <% if (!errStr.equals("")) { %>
        <%=errStr%>
    <% } %>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="10"><td></td></tr>
    </table>
   
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        <tr height="35" bgcolor="#e5e5e5">
            <td class="td_standardBold">NO</td>
            <td class="td_standardBold">PROJECT</td>
            <td class="td_standardBold" width="15%">시수 소계<br>(Factor 미적용)</td>
            <td class="td_standardBold" width="15%">전송시수<br>(Factor 적용)</td>
            <td class="td_standardBold" width="15%">전송시수<br>(ERP I/F 결과)</td>
            <td class="td_standardBold">전송일자</td>
            <td class="td_standardBold" width="15%">전송여부 (ERP<br> 데이터 존재여부)</td>
        </tr>

        <%
        DecimalFormat df = new DecimalFormat("###,###.##");

        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);
            String projectNo = (String)map.get("PROJECT_NO");
            String wTime = (String)map.get("WTIME");
            String wTimeFactored = (String)map.get("WTIME_F");
            String wTimeOfERP = (String)map.get("ERP_WTIME_F");
            String erpCreateDate = (String)map.get("ERP_CREATE_DATE");
            String erpIFYN = "N"; 
            String bgColorValue = "#ff0000";
            if (!StringUtil.isNullString(erpCreateDate)) {
                erpIFYN = "Y";
                bgColorValue = "#66ff66";
            } 
            else {
                String erpIFTargetDataStr = yearMonthStr + "," + projectNo + "," + wTimeFactored;
                erpIFTargetDataList.add(erpIFTargetDataStr);                
            }

            String wTimeOfERPStr = "";
            if (!StringUtil.isNullString(wTimeOfERP)) {
                wTimeOfERPStr = df.format(Math.round(Float.parseFloat(wTimeOfERP) * 100) / 100.0);
            }
            %>
            <tr height="20" bgColor="#ffffff">
                <td class="td_standard"><%= i + 1 %></td>
                <td class="td_standard" bgColor="#ffffd0"><%= projectNo %></td>
                <td class="td_standardRight"><%= df.format(Float.parseFloat(wTime)) %></td>
                <td class="td_standardRight"><%= df.format(Math.round(Float.parseFloat(wTimeFactored) * 100) / 100.0) %></td>
                <td class="td_standardRight"><%= wTimeOfERPStr %></td>
                <td class="td_standard"><%= erpCreateDate %></td>
                <td class="td_standard" bgColor="<%= bgColorValue %>" style="font-weight:bold;"><%= erpIFYN %></td>
            </tr>
            <%
        }
        %>

    </table>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="10"><td></td></tr>
    </table>

    <input type="hidden" name="dateFromVal" value="<%=dateFrom%>" />
    <input type="hidden" name="dateToVal" value="<%=dateTo%>" />
    <input type="hidden" name="projectListVal" value="<%=projectList%>" />
    <input type="hidden" name="targetVal" value="<%=targetStr%>" />
    <input type="hidden" name="departmentListVal" value="<%=departmentList%>" />
    <input type="hidden" name="factorCaseVal" value="<%=factorCase%>" />
    <input type="hidden" name="firstCall" value="" />
    <input type="hidden" name="showMsg" value="" />

</form>
</body>
</html>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 조회 완료 메시지 
    <% if (!firstCall.equals("Y") && !showMsg.equals("N")) { %>
        alert("조회 완료");
    <% } %>

    var erpIFTargetDataList = new Array();
    <% for (int i = 0; i < erpIFTargetDataList.size(); i++) { %>
        erpIFTargetDataList[<%= i %>] = "<%= (String)erpIFTargetDataList.get(i) %>";
    <% } %>

    // ERP I/F 실행여부 확인
    function confirmERPIFExecute()
    {
        if (erpIFTargetDataList.length <= 0) return 0;

        var msg = "ERP 미전송(ERP에 데이터 미존재) 호선 " + erpIFTargetDataList.length + " 건의 시수정보를\n\nERP로 전송합니다! ";
        msg    += "계속 진행하시겠습니까?";

        if (confirm(msg)) return 1;
        else return -1;
    }

    // ERP I/F 실행
    function executeERPIF()
    {
        if (erpIFTargetDataList.length <= 0) return 0;

        var str = "";
        for (var i = 0; i < erpIFTargetDataList.length; i++) {
            if (i > 0) str += "|";
            str += erpIFTargetDataList[i];
        }

        var today = new Date();
        var y = today.getFullYear().toString();
        var m = (today.getMonth()+1).toString();
        if (m.length == 1) m = 0 + m;
        var d = today.getDate().toString();
        if (d.length == 1) d = 0 + d;
        var ymd = y + "-" + m + "-" + d;

        var params = "dataList=" + str;
        params += "&createDate=" + ymd;
        params += "&targetStr=" + DPProjectDataERPIFMain.targetVal.value;

        var resultMsg = callDPCommonAjaxPostProc("ProjectDataERPIF", params);
        if (resultMsg == "Y") {
            alert("ERP 전송 완료!\n\n화면이 다시 로드됩니다. 잠시만 기다리십시오.");

            DPProjectDataERPIFMain.firstCall.value = "N";
            DPProjectDataERPIFMain.showMsg.value = "N";
            DPProjectDataERPIFMain.submit();
        }
        else alert("에러 발생");
    }

</script>