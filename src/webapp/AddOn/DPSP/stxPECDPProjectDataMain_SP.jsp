<%--  
§DESCRIPTION: 호선 별 시수조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProjectDataMain.jsp
§CHANGING HISTORY: 
§    2009-08-13: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// getDesignMHSummaryByProject(): 호선 별 설계시수 조회
	private ArrayList getDesignMHSummaryByProject(String dateFrom, String dateTo, String deptCodeList, String designerID, String factorCase) 
	throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");
		if (StringUtil.isNullString(factorCase)) throw new Exception("Factor Case is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT PROJECT_NO,                                                                                           ");
			queryStr.append("       OP1_WTIME,                                                                                            ");
			queryStr.append("       OP2_WTIME,                                                                                            ");
			queryStr.append("       OP3_WTIME,                                                                                            ");
			queryStr.append("       OP4_WTIME,                                                                                            ");
			queryStr.append("       OP5_WTIME,                                                                                            ");
			queryStr.append("       NVL(OP1_WTIME, 0) + NVL(OP2_WTIME, 0) + NVL(OP3_WTIME, 0) + NVL(OP4_WTIME, 0) + NVL(OP5_WTIME, 0)     ");
			queryStr.append("       AS PJT_WTIME,                                                                                         ");
			queryStr.append("       OP6_WTIME,                                                                                            ");
			queryStr.append("       OP7_WTIME,                                                                                            ");
			queryStr.append("       OP8_WTIME,                                                                                            ");
			queryStr.append("       NVL(OP6_WTIME, 0) + NVL(OP7_WTIME, 0) + NVL(OP8_WTIME, 0)                                             ");
			queryStr.append("       AS NON_PJT_WTIME,                                                                                     ");
			queryStr.append("       TOTAL_WTIME,                                                                                          ");
			queryStr.append("       OP9_WTIME,                                                                                            ");
			queryStr.append("       TOTAL_NTIME,                                                                                          ");
			queryStr.append("       TOTAL_OVERTIME,                                                                                       ");
			queryStr.append("       TOTAL_STIME                                                                                           ");
			queryStr.append("  FROM                                                                                                       ");
			queryStr.append("  (                                                                                                          ");
			queryStr.append("    SELECT PROJECT_NO,                                                                                       ");
			queryStr.append("           SUM(OP1_WTIME) AS OP1_WTIME,                                                                      ");
			queryStr.append("           SUM(OP2_WTIME) AS OP2_WTIME,                                                                      ");
			queryStr.append("           SUM(OP3_WTIME) AS OP3_WTIME,                                                                      ");
			queryStr.append("           SUM(OP4_WTIME) AS OP4_WTIME,                                                                      ");
			queryStr.append("           SUM(OP5_WTIME) AS OP5_WTIME,                                                                      ");
			queryStr.append("           SUM(OP6_WTIME) AS OP6_WTIME,                                                                      ");
			queryStr.append("           SUM(OP7_WTIME) AS OP7_WTIME,                                                                      ");
			queryStr.append("           SUM(OP8_WTIME) AS OP8_WTIME,                                                                      ");
			queryStr.append("           SUM(OP9_WTIME) AS OP9_WTIME,                                                                      ");
			queryStr.append("           SUM(WTIME) - NVL(SUM(OP9_WTIME), 0) AS TOTAL_WTIME,                                               ");
			queryStr.append("           SUM(TOTAL_NTIME) AS TOTAL_NTIME,                                                                  ");
			queryStr.append("           SUM(TOTAL_OVERTIME) AS TOTAL_OVERTIME,                                                            ");
			queryStr.append("           SUM(TOTAL_STIME) AS TOTAL_STIME                                                                   ");
			queryStr.append("      FROM                                                                                                   ");
			queryStr.append("      (                                                                                                      ");
			queryStr.append("        SELECT PROJECT_NO,                                                                                   ");
			queryStr.append("               OP_CODE,                                                                                      ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '1%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP1_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '2%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP2_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '3%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP3_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '4%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP4_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '5%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP5_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '6%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP6_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '7%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP7_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '8%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP8_WTIME,                                                                                 ");
			queryStr.append("               CASE WHEN OP_CODE LIKE '9%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END               ");
			queryStr.append("               AS OP9_WTIME,                                                                                 ");
			queryStr.append("               SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) AS WTIME,                                          ");
			queryStr.append("               SUM(NORMAL_TIME) AS TOTAL_NTIME,                                                              ");
			queryStr.append("               SUM(OVERTIME) AS TOTAL_OVERTIME,                                                              ");
			queryStr.append("               SUM(SPECIAL_TIME) AS TOTAL_STIME                                                              ");
			queryStr.append("          FROM                                                                                               ");
			queryStr.append("          (                                                                                                  ");
			queryStr.append("            SELECT PROJECT_NO,                                                                               ");
			queryStr.append("                   OP_CODE,                                                                                  ");
			queryStr.append("                   TO_CHAR(NORMAL_TIME * MH_FACTOR) AS NORMAL_TIME,                                          ");
			queryStr.append("                   TO_CHAR(OVERTIME * MH_FACTOR) AS OVERTIME,                                                ");
			queryStr.append("                   TO_CHAR(SPECIAL_TIME * MH_FACTOR) AS SPECIAL_TIME                                         ");
			queryStr.append("              FROM                                                                                           ");
			queryStr.append("              (                                                                                              ");
			queryStr.append("               SELECT PROJECT_NO,                                                                            ");
			queryStr.append("                      OP_CODE,                                                                               ");
			queryStr.append("                      NORMAL_TIME,                                                                           ");
			queryStr.append("                      OVERTIME,                                                                              ");
			queryStr.append("                      SPECIAL_TIME,                                                                          ");
			queryStr.append("                      CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                 ");
			queryStr.append("                           ELSE (                                                                            ");
			queryStr.append("                                    SELECT FACTOR_VALUE                                                      ");
			queryStr.append("                                      FROM (                                                                 ");
			queryStr.append("                                            SELECT CAREER_MONTH_FROM,                                        ");
			queryStr.append("                                                   CAREER_MONTH_TO,                                          ");
			queryStr.append("                                                   FACTOR_VALUE                                              ");
			queryStr.append("                                              FROM PLM_DESIGN_MH_FACTOR                                      ");
			queryStr.append("                                             WHERE 1 = 1                                                     ");
			queryStr.append("                                               AND CASE_NO = '" + factorCase + "'                            ");
			queryStr.append("                                           )                                                                 ");
			queryStr.append("                                     WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                ");
			queryStr.append("                                       AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                       ");
			queryStr.append("                                )                                                                            ");
			queryStr.append("                      END AS MH_FACTOR                                                                       ");
			queryStr.append("                 FROM                                                                                        ");
			queryStr.append("                 (                                                                                           ");
			queryStr.append("                    SELECT A.PROJECT_NO,                                                                     ");
			queryStr.append("                           A.OP_CODE,                                                                        ");
			queryStr.append("                           A.NORMAL_TIME,                                                                    ");
			queryStr.append("                           A.OVERTIME,                                                                       ");
			queryStr.append("                           A.SPECIAL_TIME,                                                                   ");
			queryStr.append("                           A.EMPLOYEE_NO,                                                                    ");
			//queryStr.append("                       CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                                ");
			//queryStr.append("                            ELSE (                                                                           ");
			queryStr.append("                                   ((TO_CHAR(A.WORK_DAY,'YYYY') - TO_CHAR(B.DESIGN_APPLY_DATE,'YYYY'))* 12 + ");
			queryStr.append("                                    (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +      ");
			queryStr.append("                                   CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                 ");
			queryStr.append("                                        WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                  ");
			queryStr.append("                                   END +                                                                     ");
			queryStr.append("                                   NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                           ");
			//queryStr.append("                                 )                                                                           ");
			//queryStr.append("                       END                                                                                   ");
			queryStr.append("                       AS CAREER_MONTHS                                                                      ");
			queryStr.append("                      FROM PLM_DESIGN_MH A,                                                                  ");
			queryStr.append("                           CCC_SAWON B                                                                       ");
			queryStr.append("                     WHERE 1 = 1                                                                             ");
			queryStr.append("                       AND B.EMPLOYEE_NUM = A.EMPLOYEE_NO                                                    ");
			queryStr.append("                       AND A.OP_CODE <> '90'                                                                 ");
			if (!StringUtil.isNullString(deptCodeList))
			queryStr.append("                       AND A.DEPT_CODE IN (" + deptCodeList + ")                                             ");
			if (!StringUtil.isNullString(designerID))  
			queryStr.append("                       AND A.EMPLOYEE_NO = '" + designerID + "'                                              ");
			queryStr.append("                       AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                      ");
			queryStr.append("                                          AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                        ");
			queryStr.append("                 )                                                                                           ");
			queryStr.append("              )                                                                                              ");
			queryStr.append("          )                                                                                                  ");
			queryStr.append("         GROUP BY PROJECT_NO, OP_CODE                                                                        ");
			queryStr.append("      )                                                                                                      ");
			queryStr.append("     GROUP BY PROJECT_NO                                                                                     ");
			queryStr.append("     ORDER BY PROJECT_NO                                                                                     ");
			queryStr.append("  )                                                                                                          ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());
			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1));
				resultMap.put("OP1_WTIME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("OP2_WTIME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("OP3_WTIME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("OP4_WTIME", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("OP5_WTIME", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("PJT_WTIME", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OP6_WTIME", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("OP7_WTIME", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("OP8_WTIME", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("NON_PJT_WTIME", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("TOTAL_WTIME", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("OP9_WTIME", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("TOTAL_NTIME", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("TOTAL_OVERTIME", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("TOTAL_STIME", rset.getString(16) == null ? "" : rset.getString(16));

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

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
    String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String firstCall = StringUtil.setEmptyExt(emxGetParameter(request, "firstCall"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));

    // From, To Date 순서가 반대이면 상호 교체한다 
    if (!dateFrom.equals("") && !dateTo.equals("")) {
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd"); 
        SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd"); 
        java.util.Date date1 = sdf1.parse(dateFrom); 
        java.util.Date date2 = sdf1.parse(dateTo); 
        if (date1.after(date2)) {
            String temp = dateFrom;
            dateFrom = dateTo;
            dateTo = temp;
        }
    }

    String errStr = "";

    String baseWorkTime = "";
    ArrayList dpInputsList = null;

    try {
        if (!firstCall.equals("Y")) {
            baseWorkTime = getBaseWorkTime(dateFrom, dateTo);
            dpInputsList = getDesignMHSummaryByProject(dateFrom, dateTo, deptCode, designerID, factorCase);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    float baseWorkTimeValue = (StringUtil.isNullString(baseWorkTime)) ? 0 : Float.parseFloat(baseWorkTime);
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>호선 별 설계시수 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>
<script language="javascript">

    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPProjectDataMain">

    <% if (!errStr.equals("")) { %>
        <%=errStr%>
    <% } %>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="2"><td></td></tr>
        <tr height="20" style="font-weight:bold;color:#0000ff;">
            <td width="300px">기간 당연투입시수: <%=baseWorkTime%></td>
        </tr>
        <tr height="5"><td colspan="3"></td></tr>
    </table>
   
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold" rowspan="2">NO</td>
            <td class="td_standardBold" rowspan="2">PROJECT</td>
            <td class="td_standardBold" colspan="7">공사시수</td>
            <td class="td_standardBold" colspan="5">비공사시수</td>
            <td class="td_standardBold" colspan="2">총투입실적</td>
            <td class="td_standardBold">근태</td>
            <td class="td_standardBold">인원</td>
            <td class="td_standardBold" colspan="3">설계 시수구분</td>
        </tr>
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standard">설계준비</td>
            <td class="td_standard">설계제도</td>
            <td class="td_standard">협의검토</td>
            <td class="td_standard">시험현장</td>
            <td class="td_standard">도면수정</td>
            <td class="td_standard">소계</td>
            <td class="td_standard">시수율</td>
            <td class="td_standard">보조지원</td>
            <td class="td_standard">생산향상</td>
            <td class="td_standard">기타</td>
            <td class="td_standard">소계</td>
            <td class="td_standard">시수율</td>
            <td class="td_standard">시수</td>
            <td class="td_standard">차지율</td>
            <td class="td_standard">근태시수</td>
            <td class="td_standard">실투입인원</td>
            <td class="td_standard">정상시수</td>
            <td class="td_standard">잔업시수</td>
            <td class="td_standard">특근시수</td>
        </tr>

        <%
        DecimalFormat df = new DecimalFormat("###,###.##");

        float wTimeTotal = 0;
        float op1WTimeSum = 0;
        float op2WTimeSum = 0;
        float op3WTimeSum = 0;
        float op4WTimeSum = 0;
        float op5WTimeSum = 0;
        float op6WTimeSum = 0;
        float op7WTimeSum = 0;
        float op8WTimeSum = 0;
        float op9WTimeSum = 0;
        float pjtWTimeSum = 0;
        float nonPjtWTimeSum = 0;
        float pjtWTimeRateSum = 0;
        float nonPjtWTimeRateSum = 0;
        float totalWTimeSum = 0;
        float totalWTimeRateSum = 0;
        float personRateSum = 0;
        float normalTimeSum = 0;
        float overtimeSum = 0;
        float specialTimeSum = 0;        
        
        float[] totalWTimeTop20 = new float[20];
        for (int i = 0; i < 20; i++) totalWTimeTop20[i] = 0;

        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++)
        {
            Map map = (Map)dpInputsList.get(i);

            String pjtWTimeStr = (String)map.get("PJT_WTIME");
            String nonPjtWTimeStr = (String)map.get("NON_PJT_WTIME");
            float pjtWTime = StringUtil.isNullString(pjtWTimeStr) ? 0 : Float.parseFloat(pjtWTimeStr);
            float nonPjtWTime = StringUtil.isNullString(nonPjtWTimeStr) ? 0 : Float.parseFloat(nonPjtWTimeStr);
            wTimeTotal += pjtWTime + nonPjtWTime;

            float op1WTime = StringUtil.isNullString((String)map.get("OP1_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP1_WTIME"));
            float op2WTime = StringUtil.isNullString((String)map.get("OP2_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP2_WTIME"));
            float op3WTime = StringUtil.isNullString((String)map.get("OP3_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP3_WTIME"));
            float op4WTime = StringUtil.isNullString((String)map.get("OP4_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP4_WTIME"));
            float op5WTime = StringUtil.isNullString((String)map.get("OP5_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP5_WTIME"));
            float op6WTime = StringUtil.isNullString((String)map.get("OP6_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP6_WTIME"));
            float op7WTime = StringUtil.isNullString((String)map.get("OP7_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP7_WTIME"));
            float op8WTime = StringUtil.isNullString((String)map.get("OP8_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP8_WTIME"));
            float op9WTime = StringUtil.isNullString((String)map.get("OP9_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP9_WTIME"));
            float totalNTime = StringUtil.isNullString((String)map.get("TOTAL_NTIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_NTIME"));
            float totalOTime = StringUtil.isNullString((String)map.get("TOTAL_OVERTIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_OVERTIME"));
            float totalSTime = StringUtil.isNullString((String)map.get("TOTAL_STIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_STIME"));
            float totalWTime = StringUtil.isNullString((String)map.get("TOTAL_WTIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_WTIME"));
            float personRate = (totalWTime == 0 || baseWorkTimeValue == 0) ? 0: totalWTime / baseWorkTimeValue;

            op1WTimeSum += op1WTime;
            op2WTimeSum += op2WTime;
            op3WTimeSum += op3WTime;
            op4WTimeSum += op4WTime;
            op5WTimeSum += op5WTime;
            op6WTimeSum += op6WTime;
            op7WTimeSum += op7WTime;
            op8WTimeSum += op8WTime;
            op9WTimeSum += op9WTime;
            pjtWTimeSum += pjtWTime;
            nonPjtWTimeSum += nonPjtWTime;
            totalWTimeSum += totalWTime;
            normalTimeSum += totalNTime;
            overtimeSum += totalOTime;
            specialTimeSum += totalSTime;
            //totalWTimeRateSum += wTimePortion;
            personRateSum += personRate;

            for (int j = 0; j < 20; j++) {
                if (totalWTime > totalWTimeTop20[j]) {
                    for (int k = 19; k > j; k--) {
                        totalWTimeTop20[k] = totalWTimeTop20[k - 1];
                    }
                    totalWTimeTop20[j] = totalWTime;
                    break;
                }
            }
        }

        //df = new DecimalFormat("###,###.0");

        pjtWTimeRateSum = pjtWTimeSum == 0 ? 0 : pjtWTimeSum / (pjtWTimeSum + nonPjtWTimeSum) * 100;
        nonPjtWTimeRateSum = nonPjtWTimeSum == 0 ? 0 : nonPjtWTimeSum / (pjtWTimeSum + nonPjtWTimeSum) * 100;
        totalWTimeRateSum = 100;

        if (!firstCall.equals("Y")) 
        {
        %>
            <tr height="20" style="background-color:#dddddd">
                <td colspan="2" class="td_standardRight" style="font-weight:bold;">TOTAL&nbsp;</td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op1WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op2WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op3WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op4WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op5WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(pjtWTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(pjtWTimeRateSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op6WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op7WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op8WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(nonPjtWTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(nonPjtWTimeRateSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(totalWTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(totalWTimeRateSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(op9WTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(personRateSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(normalTimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(overtimeSum * 100) / 100.0)%></font></td>
                <td class="td_standardRightBoldBorder"><font color="#ff0000"><%=df.format(Math.round(specialTimeSum * 100) / 100.0)%></font></td>
            </tr>
        <%
        }    



        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);

            String pjtWTimeStr = (String)map.get("PJT_WTIME");
            String nonPjtWTimeStr = (String)map.get("NON_PJT_WTIME");

            float pjtWTime = StringUtil.isNullString(pjtWTimeStr) ? 0 : Float.parseFloat(pjtWTimeStr);
            float nonPjtWTime = StringUtil.isNullString(nonPjtWTimeStr) ? 0 : Float.parseFloat(nonPjtWTimeStr);

            float pjtWTimeRate = (pjtWTime == 0) ? 0 : pjtWTime / (pjtWTime + nonPjtWTime) * 100;
            float nonPjtWTimeRate = (nonPjtWTime == 0) ? 0 : nonPjtWTime / (pjtWTime + nonPjtWTime) * 100;
            float wTimePortion = (wTimeTotal == 0) ? 0 : (pjtWTime + nonPjtWTime) / wTimeTotal * 100;
            
            String totalWTimeStr = (String)map.get("TOTAL_WTIME");
            float totalWTime = StringUtil.isNullString(totalWTimeStr) ? 0 : Float.parseFloat(totalWTimeStr);
            float personRate = (totalWTime == 0 || baseWorkTimeValue == 0) ? 0: totalWTime / baseWorkTimeValue;

            float op1WTime = StringUtil.isNullString((String)map.get("OP1_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP1_WTIME"));
            float op2WTime = StringUtil.isNullString((String)map.get("OP2_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP2_WTIME"));
            float op3WTime = StringUtil.isNullString((String)map.get("OP3_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP3_WTIME"));
            float op4WTime = StringUtil.isNullString((String)map.get("OP4_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP4_WTIME"));
            float op5WTime = StringUtil.isNullString((String)map.get("OP5_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP5_WTIME"));
            float op6WTime = StringUtil.isNullString((String)map.get("OP6_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP6_WTIME"));
            float op7WTime = StringUtil.isNullString((String)map.get("OP7_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP7_WTIME"));
            float op8WTime = StringUtil.isNullString((String)map.get("OP8_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP8_WTIME"));
            float op9WTime = StringUtil.isNullString((String)map.get("OP9_WTIME")) ? 0 : Float.parseFloat((String)map.get("OP9_WTIME"));
            float totalNTime = StringUtil.isNullString((String)map.get("TOTAL_NTIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_NTIME"));
            float totalOTime = StringUtil.isNullString((String)map.get("TOTAL_OVERTIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_OVERTIME"));
            float totalSTime = StringUtil.isNullString((String)map.get("TOTAL_STIME")) ? 0 : Float.parseFloat((String)map.get("TOTAL_STIME"));

            String op1WTimeStr = op1WTime == 0 ? "" : df.format(Math.round(op1WTime * 100) / 100.0);
            String op2WTimeStr = op2WTime == 0 ? "" : df.format(Math.round(op2WTime * 100) / 100.0);
            String op3WTimeStr = op3WTime == 0 ? "" : df.format(Math.round(op3WTime * 100) / 100.0);
            String op4WTimeStr = op4WTime == 0 ? "" : df.format(Math.round(op4WTime * 100) / 100.0);
            String op5WTimeStr = op5WTime == 0 ? "" : df.format(Math.round(op5WTime * 100) / 100.0);
            String op6WTimeStr = op6WTime == 0 ? "" : df.format(Math.round(op6WTime * 100) / 100.0);
            String op7WTimeStr = op7WTime == 0 ? "" : df.format(Math.round(op7WTime * 100) / 100.0);
            String op8WTimeStr = op8WTime == 0 ? "" : df.format(Math.round(op8WTime * 100) / 100.0);
            String op9WTimeStr = op9WTime == 0 ? "" : df.format(Math.round(op9WTime * 100) / 100.0);
            pjtWTimeStr = pjtWTime == 0 ? "" : df.format(Math.round(pjtWTime * 100) / 100.0);
            String pjtWTimeRateStr = pjtWTimeRate == 0 ? "" : df.format(Math.round(pjtWTimeRate * 100) / 100.0);
            nonPjtWTimeStr = nonPjtWTime == 0 ? "" : df.format(Math.round(nonPjtWTime * 100) / 100.0);
            String nonPjtWTimeRateStr = nonPjtWTimeRate == 0 ? "" : df.format(Math.round(nonPjtWTimeRate * 100) / 100.0);
            totalWTimeStr = totalWTime == 0 ? "" : df.format(Math.round(totalWTime * 100) / 100.0);
            String wTimePortionStr = wTimePortion == 0 ? "" : df.format(Math.round(wTimePortion * 100) / 100.0);
            String personRateStr = personRate == 0 ? "" : df.format(Math.round(personRate * 100) / 100.0);
            String totalNTimeStr = totalNTime == 0 ? "" : df.format(Math.round(totalNTime * 100) / 100.0);
            String totalOTimeStr = totalOTime == 0 ? "" : df.format(Math.round(totalOTime * 100) / 100.0);
            String totalSTimeStr = totalSTime == 0 ? "" : df.format(Math.round(totalSTime * 100) / 100.0);

            String trBgColor = totalWTime >= totalWTimeTop20[19] ? "#ffffa0" : "#ffffff";
            %>
                <tr height="20" bgcolor="<%= trBgColor %>">
                    <td class="td_standard"><%= i + 1 %></td>
                    <td class="td_standard" bgColor="#ffffd0"><%=(String)map.get("PROJECT_NO")%></td>
                    <td class="td_standardRight"><%=op1WTimeStr%></td>
                    <td class="td_standardRight"><%=op2WTimeStr%></td>
                    <td class="td_standardRight"><%=op3WTimeStr%></td>
                    <td class="td_standardRight"><%=op4WTimeStr%></td>
                    <td class="td_standardRight"><%=op5WTimeStr%></td>
                    <td class="td_standardRight"><%=pjtWTimeStr%></td>
                    <td class="td_standardRight"><%=pjtWTimeRateStr%></td>
                    <td class="td_standardRight"><%=op6WTimeStr%></td>
                    <td class="td_standardRight"><%=op7WTimeStr%></td>
                    <td class="td_standardRight"><%=op8WTimeStr%></td>
                    <td class="td_standardRight"><%=nonPjtWTimeStr%></td>
                    <td class="td_standardRight"><%=nonPjtWTimeRateStr%></td>
                    <td class="td_standardRight"><%=totalWTimeStr%></td>
                    <td class="td_standardRight"><%=wTimePortionStr%></td> 
                    <td class="td_standardRight"><%=op9WTimeStr%></td>
                    <td class="td_standardRight"><%=personRateStr%>
                    <td class="td_standardRight"><%=totalNTimeStr%></td>
                    <td class="td_standardRight"><%=totalOTimeStr%></td>
                    <td class="td_standardRight"><%=totalSTimeStr%></td>
                </tr>
            <%
        }
        %>
    </table>

</form>
</body>
</html>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // 조회 완료 메시지 
    <% if (!firstCall.equals("Y") && !showMsg.equals("N")) { %>
        alert("조회 완료");
    <% } %>

</script>