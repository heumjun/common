<%--  
§DESCRIPTION: 부서 별 개정시수 조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPRevisionDataMain.jsp
§CHANGING HISTORY: 
§    2009-08-18: Initiative
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
	// getDesignMHSummaryForRevision(): 부서 별 개정시수 조회
	private ArrayList getDesignMHSummaryForRevision(String dateFrom, String dateTo, String deptCodeList, String projectNoList, 
	String causeDeptCode, String factorCase) throws Exception
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

			queryStr.append("SELECT DEPT_CODE,                                                                                       ");
			queryStr.append("       DEPT_NAME,                                                                                       ");
			queryStr.append("       OP_CODE,                                                                                         ");
			queryStr.append("       OP_WTIME                                                                                         ");
			queryStr.append("  FROM (                                                                                                 ");
			queryStr.append("        SELECT A.DEPT_CODE,                                                                             ");
			queryStr.append("               B.DEPT_NAME,                                                                             ");
			queryStr.append("               D.DWGDEPTCODE AS DWG_DEPTCODE,                                                           ");
			queryStr.append("               A.OP_CODE,                                                                               ");
			queryStr.append("               A.OP_WTIME                                                                               ");
			queryStr.append("          FROM                                                                                          ");
			queryStr.append("          (                                                                                             ");
			queryStr.append("            SELECT DEPT_CODE,                                                                           ");
			queryStr.append("                   OP_CODE,                                                                             ");
			queryStr.append("                   SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) AS OP_WTIME                               ");
			queryStr.append("              FROM                                                                                      ");
			queryStr.append("              (                                                                                         ");
			queryStr.append("                SELECT DEPT_CODE,                                                                       ");
			queryStr.append("                       OP_CODE,                                                                         ");
			queryStr.append("                       TO_CHAR(NORMAL_TIME * MH_FACTOR) AS NORMAL_TIME,                                 ");
			queryStr.append("                       TO_CHAR(OVERTIME * MH_FACTOR) AS OVERTIME,                                       ");
			queryStr.append("                       TO_CHAR(SPECIAL_TIME * MH_FACTOR) AS SPECIAL_TIME                                ");
			queryStr.append("                  FROM                                                                                  ");
			queryStr.append("                  (                                                                                     ");
			queryStr.append("                   SELECT DEPT_CODE,                                                                    ");
			queryStr.append("                          OP_CODE,                                                                      ");
			queryStr.append("                          NORMAL_TIME,                                                                  ");
			queryStr.append("                          OVERTIME,                                                                     ");
			queryStr.append("                          SPECIAL_TIME,                                                                 ");
			queryStr.append("                          CASE WHEN CAREER_MONTHS IS NULL THEN 1                                        ");
			queryStr.append("                               ELSE (                                                                   ");
			queryStr.append("                                        SELECT FACTOR_VALUE                                             ");
			queryStr.append("                                          FROM (                                                        ");
			queryStr.append("                                                SELECT CAREER_MONTH_FROM,                               ");
			queryStr.append("                                                       CAREER_MONTH_TO,                                 ");
			queryStr.append("                                                       FACTOR_VALUE                                     ");
			queryStr.append("                                                  FROM PLM_DESIGN_MH_FACTOR                             ");
			queryStr.append("                                                 WHERE 1 = 1                                            ");
			queryStr.append("                                                   AND CASE_NO = '" + factorCase + "'                   ");
			queryStr.append("                                               )                                                        ");
			queryStr.append("                                         WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                       ");
			queryStr.append("                                           AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS              ");
			queryStr.append("                                    )                                                                   ");
			queryStr.append("                          END AS MH_FACTOR                                                              ");
			queryStr.append("                     FROM                                                                               ");
			queryStr.append("                     (                                                                                  ");
			queryStr.append("                        SELECT A.DEPT_CODE,                                                             ");
			queryStr.append("                               A.OP_CODE,                                                               ");
			queryStr.append("                               A.NORMAL_TIME,                                                           ");
			queryStr.append("                               A.OVERTIME,                                                              ");
			queryStr.append("                               A.SPECIAL_TIME,                                                          ");
			queryStr.append("                               A.EMPLOYEE_NO,                                                           ");
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
			queryStr.append("                          FROM PLM_DESIGN_MH A,                                                         ");
			queryStr.append("                               CCC_SAWON B                                                              ");
			queryStr.append("                         WHERE 1 = 1                                                                    ");
			queryStr.append("                           AND B.EMPLOYEE_NUM = A.EMPLOYEE_NO                                           ");
			queryStr.append("                           AND A.OP_CODE <> '90'                                                        ");
			queryStr.append("                           AND (A.OP_CODE LIKE '5%' OR A.OP_CODE = '20')                                ");
			if (!StringUtil.isNullString(deptCodeList))
			queryStr.append("                           AND A.DEPT_CODE IN (" + deptCodeList + ")                                    ");
			if (!StringUtil.isNullString(projectNoList))
			queryStr.append("                           AND A.PROJECT_NO IN (" + projectNoList + ")                                  ");
			if (!StringUtil.isNullString(causeDeptCode))
			queryStr.append("                           AND A.CAUSE_DEPART = '" + causeDeptCode + "'                                 ");
			queryStr.append("                           AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')             ");
			queryStr.append("                                              AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')               ");
			queryStr.append("                     )                                                                                  ");
			queryStr.append("                  )                                                                                     ");
			queryStr.append("              )                                                                                         ");
			queryStr.append("             GROUP BY DEPT_CODE, OP_CODE                                                                ");
			queryStr.append("             ORDER BY DEPT_CODE, OP_CODE                                                                ");
			queryStr.append("          ) A, STX_COM_INSA_DEPT@STXERP B, DCC_DEPTCODE D                                               ");
			queryStr.append("         WHERE B.DEPT_CODE = A.DEPT_CODE                                                                ");
			queryStr.append("           AND A.DEPT_CODE = D.DEPTCODE(+)                                                              ");
			queryStr.append("       ) A, DCC_DWGDEPTCODE B                                                                           ");
			queryStr.append(" WHERE A.DWG_DEPTCODE = B.DWGDEPTCODE(+)                                                                ");
			queryStr.append(" ORDER BY B.ORDERNO, DEPT_NAME                                                                          ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			String deptCode = "";
			HashMap resultMap = null;
			while (rset.next()) {
				if (!deptCode.equals(rset.getString(1))) {
					if (resultMap != null) resultArrayList.add(resultMap);
					resultMap = new HashMap();
					resultMap.put("DEPT_CODE", rset.getString(1));
					resultMap.put("DEPT_NAME", rset.getString(2));
					deptCode = rset.getString(1);
				}
				
				resultMap.put(rset.getString(3), rset.getString(4));
			}
			if (resultMap != null) resultArrayList.add(resultMap);
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
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String causeDeptCode = StringUtil.setEmptyExt(emxGetParameter(request, "causeDeptCode"));
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

    ArrayList opCodeList = null;
    ArrayList dpInputsList = null;

    try {
        opCodeList = getOPCodesForRevision();
        if (!firstCall.equals("Y")) {
            dpInputsList = getDesignMHSummaryForRevision(dateFrom, dateTo, deptCode, projectNo, causeDeptCode, factorCase);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>부서 별 개정시수 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript">

    // Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;

</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPDepartmentDataMain">

    <% if (!errStr.equals("")) { %>
        <%=errStr%>
    <% } %>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="5"><td></td></tr>
    </table>
   
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        
        <tr bgcolor="#e5e5e5">
            <td class="td_standardBold">NO</td>
            <td class="td_standardBold">부서<br>CODE</td>
            <td class="td_standardBold">부서</td>
            <%
            for (int i = 0; i < opCodeList.size(); i++) {
                Map map = (Map)opCodeList.get(i);
                String keyStr = (String)map.get("OP_KEY");
                String valueStr = (String)map.get("OP_VALUE");
                if (valueStr.length() > 10) valueStr = valueStr.substring(0, 10) + "...";
                %>
                <td class="td_standardBold" style="font-size:8pt;" width="4%"><%=keyStr%><br><%=valueStr%></td>
                <%
            }
            %>
            <td class="td_standardBold">TOTAL</td>
            <td class="td_standardBold">순수설계</td>
            <td class="td_standardBold" width="4%">20.<br>EXTRA</td>
        </tr>

        <%
        DecimalFormat df = new DecimalFormat("###,###.##");

        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);
            float opWTimeRowTotal = 0;
            float opWTimeRowTotal2 = 0;
            %>
            <tr height="20" bgColor="#ffffff">
                <td class="td_standard"><%= i + 1 %></td>
                <td class="td_standard" bgColor="#ffffd0"><%=(String)map.get("DEPT_CODE")%></td>
                <td class="td_standardLeft" bgColor="#ffffd0" style="padding-left:2px;"><%=(String)map.get("DEPT_NAME")%></td>
                <%
                for (int j = 0; j < opCodeList.size(); j++) {
                    Map map2 = (Map)opCodeList.get(j);
                    String keyStr = (String)map2.get("OP_KEY");
                    String valueStr = "";

                    if (map.containsKey(keyStr)) {
                        float opWTimeVal = Float.parseFloat((String)map.get(keyStr));

                        opWTimeRowTotal += opWTimeVal;
                        valueStr = df.format(opWTimeVal);

                        if ("5K,5L,5M,5R".indexOf(keyStr) < 0) opWTimeRowTotal2 += opWTimeVal;
                    }

                    String bgColor = "";
                    if ("5K,5L,5M,5R".indexOf(keyStr) >= 0) bgColor = "#AAEBAA";
                    %>
                    <td class="td_standardRight" width="4%" bgColor="<%=bgColor%>"><%= valueStr %></td>
                    <%
                }
                %>
                <%
                String valueStr = df.format(opWTimeRowTotal);
                %>
                <td class="td_standardRight"><%= valueStr %></td>
                <%
                valueStr = "";
                if (opWTimeRowTotal2 != 0) valueStr = df.format(opWTimeRowTotal2);
                %>
                <td class="td_standardRight"><%= valueStr %></td>
                <%
                valueStr = "";
                if (map.containsKey("20")) {
                    float opWTimeVal = Float.parseFloat((String)map.get("20"));
                    valueStr = df.format(opWTimeVal);
                }                
                %>
                <td class="td_standardRight" width="4%"><%= valueStr %></td>
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