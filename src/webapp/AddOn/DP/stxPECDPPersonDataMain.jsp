<%--  
§DESCRIPTION: 개인 별 시수조회 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPPersonDataMain.jsp
§CHANGING HISTORY: 
§    2009-08-12: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%!

    // getDesignMHSummaryByPerson(): 개인 별 설계시수 조회
	private ArrayList getDesignMHSummaryByPerson(String dateFrom, String dateTo, String deptCodeList, String factorCase) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");
		if (StringUtil.isNullString(factorCase)) throw new Exception("Factor Case is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT A.DEPT_CODE,                                                                                                 ");
			queryStr.append("       D.DEPT_NAME,                                                                                                 ");
			queryStr.append("       A.EMPLOYEE_NO,                                                                                               ");
			queryStr.append("       NVL(A.EMP_NAME, (SELECT B.USER_NAME FROM STX_COM_INSA_USER@STXERP B WHERE B.EMP_NO = EMPLOYEE_NO)) AS EMP_NAME,         ");
			queryStr.append("       NVL(A.POSITION,  (SELECT B.POSITION_NAME FROM STX_COM_INSA_USER@STXERP B WHERE B.EMP_NO = EMPLOYEE_NO)) AS POSITION,    ");
			queryStr.append("       A.OP1_WTIME,                                                                                                 ");
			queryStr.append("       A.OP2_WTIME,                                                                                                 ");
			queryStr.append("       A.OP3_WTIME,                                                                                                 ");
			queryStr.append("       A.OP4_WTIME,                                                                                                 ");
			queryStr.append("       A.OP5_WTIME,                                                                                                 ");
			queryStr.append("       DECODE(ROUND(NVL(A.OP5_WTIME, 0) / DECODE(A.PJT_WTIME, 0, 1, A.PJT_WTIME) * 100, 2), 0, '',                  ");
			queryStr.append("              ROUND(NVL(A.OP5_WTIME, 0) / DECODE(A.PJT_WTIME, 0, 1, A.PJT_WTIME) * 100, 2)) AS OP5_RATE,            ");
			queryStr.append("       A.PJT_WTIME,                                                                                                 ");
			queryStr.append("       ROUND(A.PJT_WTIME / DECODE(A.TOTAL_WTIME, 0, 1, A.TOTAL_WTIME) * 100, 2) AS PJT_RATE,                        ");
			queryStr.append("       A.OP6_WTIME,                                                                                                 ");
			queryStr.append("       A.OP7_WTIME,                                                                                                 ");
			queryStr.append("       A.OP8_WTIME,                                                                                                 ");
			queryStr.append("       A.NON_PJT_WTIME,                                                                                             ");
			queryStr.append("       ROUND(A.NON_PJT_WTIME / DECODE(A.TOTAL_WTIME, 0, 1, A.TOTAL_WTIME) * 100, 2) AS NON_PJT_RATE,                ");
			queryStr.append("       OP9_WTIME,                                                                                                   ");
			queryStr.append("       ROUND(A.OP9_WTIME / DECODE(A.TOTAL_WTIME + NVL(A.OP9_WTIME, 0), 0, 1, A.TOTAL_WTIME + NVL(A.OP9_WTIME, 0))   ");
			queryStr.append("             * 100, 2)                                                                                              ");
			queryStr.append("       AS OP9_RATE,                                                                                                 ");
			queryStr.append("       A.TOTAL_OVERTIME,                                                                                            ");
			queryStr.append("       A.TOTAL_STIME,                                                                                               ");
			queryStr.append("       NVL(A.TOTAL_OVERTIME, 0) + NVL(A.TOTAL_STIME, 0) AS TOTAL_OVERTIME2,                                         ");
			queryStr.append("       ROUND((NVL(A.TOTAL_OVERTIME, 0) + NVL(A.TOTAL_STIME, 0)) / DECODE(A.TOTAL_WTIME, 0, 1, A.TOTAL_WTIME)        ");
			queryStr.append("              * 100, 2)                                                                                             ");
			queryStr.append("       AS OVERTIME_RATE,                                                                                            ");
			queryStr.append("       A.TOTAL_NORMALTIME,                                                                                          ");
			queryStr.append("       A.MH_FACTOR                                                                                                  ");
			queryStr.append("  FROM (                                                                                                            ");
			queryStr.append("        SELECT A.DEPT_CODE,                                                                                         ");
			queryStr.append("               A.EMPLOYEE_NO AS EMPLOYEE_NO,                                                                        ");
			queryStr.append("               B.NAME AS EMP_NAME,                                                                                  ");
			queryStr.append("               B.POSITION,                                                                                          ");
			queryStr.append("               A.OP1_WTIME,                                                                                         ");
			queryStr.append("               A.OP2_WTIME,                                                                                         ");
			queryStr.append("               A.OP3_WTIME,                                                                                         ");
			queryStr.append("               A.OP4_WTIME,                                                                                         ");
			queryStr.append("               A.OP5_WTIME,                                                                                         ");
			queryStr.append("               NVL(A.OP1_WTIME, 0) + NVL(A.OP2_WTIME, 0) + NVL(A.OP3_WTIME, 0) + NVL(A.OP4_WTIME, 0)                ");
			queryStr.append("               + NVL(A.OP5_WTIME, 0) AS PJT_WTIME,                                                                  ");
			queryStr.append("               A.OP6_WTIME,                                                                                         ");
			queryStr.append("               A.OP7_WTIME,                                                                                         ");
			queryStr.append("               A.OP8_WTIME,                                                                                         ");
			queryStr.append("               NVL(A.OP6_WTIME, 0) + NVL(A.OP7_WTIME, 0) + NVL(A.OP8_WTIME, 0)                                      ");
			queryStr.append("               AS NON_PJT_WTIME,                                                                                    ");
			queryStr.append("               A.OP9_WTIME,                                                                                         ");
			queryStr.append("               A.TOTAL_WTIME,                                                                                       ");
			queryStr.append("               A.TOTAL_NORMALTIME,                                                                                  ");
			queryStr.append("               A.TOTAL_OVERTIME,                                                                                    ");
			queryStr.append("               A.TOTAL_STIME,                                                                                       ");
			queryStr.append("               A.MH_FACTOR                                                                                          ");
			queryStr.append("          FROM (                                                                                                    ");
			queryStr.append("                SELECT DEPT_CODE,                                                                                   ");
			queryStr.append("                       EMPLOYEE_NO,                                                                                 ");
			queryStr.append("                       SUM(OP1_WTIME) AS OP1_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP2_WTIME) AS OP2_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP3_WTIME) AS OP3_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP4_WTIME) AS OP4_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP5_WTIME) AS OP5_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP6_WTIME) AS OP6_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP7_WTIME) AS OP7_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP8_WTIME) AS OP8_WTIME,                                                                 ");
			queryStr.append("                       SUM(OP9_WTIME) AS OP9_WTIME,                                                                 ");
			queryStr.append("                       SUM(WTIME) - NVL(SUM(OP9_WTIME), 0) AS TOTAL_WTIME,                                          ");
			queryStr.append("                       SUM(TOTAL_NORMALTIME) AS TOTAL_NORMALTIME,                                                   ");
			queryStr.append("                       SUM(TOTAL_OVERTIME) AS TOTAL_OVERTIME,                                                       ");
			queryStr.append("                       SUM(TOTAL_STIME) AS TOTAL_STIME,                                                             ");
			queryStr.append("                       MAX(MH_FACTOR) AS MH_FACTOR                                                                  ");
			queryStr.append("                  FROM                                                                                              ");
			queryStr.append("                  (                                                                                                 ");
			queryStr.append("                    SELECT DEPT_CODE,                                                                               ");
			queryStr.append("                           EMPLOYEE_NO,                                                                             ");
			queryStr.append("                           OP_CODE,                                                                                 ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '1%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP1_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '2%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP2_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '3%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP3_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '4%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP4_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '5%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP5_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '6%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP6_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '7%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP7_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '8%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP8_WTIME,                                                                            ");
			queryStr.append("                           CASE WHEN OP_CODE LIKE '9%' THEN SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) END          ");
			queryStr.append("                           AS OP9_WTIME,                                                                            ");
			queryStr.append("                           SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME) AS WTIME,                                     ");
			queryStr.append("                           SUM(NORMAL_TIME) AS TOTAL_NORMALTIME,                                                    ");
			queryStr.append("                           SUM(OVERTIME) AS TOTAL_OVERTIME,                                                         ");
			queryStr.append("                           SUM(SPECIAL_TIME) AS TOTAL_STIME,                                                        ");
			queryStr.append("                           MAX(MH_FACTOR) AS MH_FACTOR                                                              ");
			queryStr.append("                      FROM (                                                                                        ");
			queryStr.append("                            SELECT WORKDAY,                                                                         ");
			queryStr.append("                                   DEPT_CODE,                                                                       ");
			queryStr.append("                                   EMPLOYEE_NO,                                                                     ");
			queryStr.append("                                   OP_CODE,                                                                         ");
			queryStr.append("                                   TO_CHAR(NORMAL_TIME * MH_FACTOR) AS NORMAL_TIME,                                 ");
			queryStr.append("                                   TO_CHAR(OVERTIME * MH_FACTOR) AS OVERTIME,                                       ");
			queryStr.append("                                   TO_CHAR(SPECIAL_TIME * MH_FACTOR) AS SPECIAL_TIME,                               ");
			queryStr.append("                                   MH_FACTOR                                                                        ");
			queryStr.append("                              FROM (                                                                                ");
			queryStr.append("                                     SELECT WORKDAY,                                                                ");
			queryStr.append("                                           DEPT_CODE,                                                               ");
			queryStr.append("                                           EMPLOYEE_NO,                                                             ");
			queryStr.append("                                           OP_CODE,                                                                 ");
			queryStr.append("                                           NORMAL_TIME,                                                             ");
			queryStr.append("                                           OVERTIME,                                                                ");
			queryStr.append("                                           SPECIAL_TIME,                                                            ");
			queryStr.append("                                           CASE WHEN CAREER_MONTHS IS NULL THEN 1                                   ");
			queryStr.append("                                                ELSE (                                                              ");
			queryStr.append("                                                         SELECT FACTOR_VALUE                                        ");
			queryStr.append("                                                           FROM (                                                   ");
			queryStr.append("                                                                 SELECT CAREER_MONTH_FROM,                          ");
			queryStr.append("                                                                        CAREER_MONTH_TO,                            ");
			queryStr.append("                                                                        FACTOR_VALUE                                ");
			queryStr.append("                                                                   FROM PLM_DESIGN_MH_FACTOR                        ");
			queryStr.append("                                                                  WHERE 1 = 1                                       ");
			queryStr.append("                                                                    AND CASE_NO = '" + factorCase + "'              ");
			queryStr.append("                                                                )                                                   ");
			queryStr.append("                                                          WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                  ");
			queryStr.append("                                                            AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS         ");
			queryStr.append("                                                     )                                                              ");
			queryStr.append("                                           END AS MH_FACTOR                                                         ");
			queryStr.append("                                      FROM (                                                                        ");
			queryStr.append("                                            SELECT TO_CHAR(A.WORK_DAY, 'YYYY-MM-DD') AS WORKDAY,                    ");
			queryStr.append("                                                   A.DEPT_CODE,                                                     ");
			queryStr.append("                                                   A.EMPLOYEE_NO,                                                   ");
			queryStr.append("                                                   A.OP_CODE,                                                       ");
			queryStr.append("                                                   A.NORMAL_TIME,                                                   ");
			queryStr.append("                                                   A.OVERTIME,                                                      ");
			queryStr.append("                                                   A.SPECIAL_TIME,                                                  ");
			queryStr.append("                                                   ((TO_CHAR(A.WORK_DAY, 'YYYY')                                    ");
			queryStr.append("                                                     - TO_CHAR(B.DESIGN_APPLY_DATE, 'YYYY'))* 12 +                  ");
			queryStr.append("                                                    (TO_CHAR(A.WORK_DAY, 'MM')                                      ");
			queryStr.append("                                                     - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +                       ");
			queryStr.append("                                                   CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1        ");
			queryStr.append("                                                        WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0         ");
			queryStr.append("                                                   END +                                                            ");
			queryStr.append("                                                   NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                  ");
			queryStr.append("                                                   AS CAREER_MONTHS                                                 ");
			queryStr.append("                                              FROM PLM_DESIGN_MH A,                                                 ");
			queryStr.append("                                                   CCC_SAWON B                                                      ");
			queryStr.append("                                             WHERE 1 = 1                                                            ");
			queryStr.append("                                               AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM(+)                                ");
			queryStr.append("                                               AND A.OP_CODE <> '90'                                                ");
			if (!StringUtil.isNullString(deptCodeList))
			queryStr.append("                                               AND A.DEPT_CODE IN (" + deptCodeList + ")                            ");
			queryStr.append("                                               AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')     ");
			queryStr.append("                                                                  AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')       ");
			queryStr.append("                                              ORDER BY A.DEPT_CODE                                                  ");
			queryStr.append("                                           ) A                                                                      ");
			queryStr.append("                                   )                                                                                ");
			queryStr.append("                           )                                                                                        ");
			queryStr.append("                     GROUP BY DEPT_CODE, EMPLOYEE_NO, OP_CODE                                                       ");
			queryStr.append("                  )                                                                                                 ");
			queryStr.append("                  GROUP BY DEPT_CODE, EMPLOYEE_NO                                                                   ");
			queryStr.append("               ) A,                                                                                                 ");
			queryStr.append("               (                                                                                                    ");
			queryStr.append("                SELECT DEPT_CODE, EMPLOYEE_NUM, NAME, POSITION                                                      ");
			queryStr.append("                  FROM CCC_SAWON                                                                                    ");
			queryStr.append("                 WHERE 1 = 1                                                                                        ");
			if (!StringUtil.isNullString(deptCodeList))
			queryStr.append("                   AND DEPT_CODE IN (" + deptCodeList + ")                                                          ");
			//queryStr.append("                   AND INPUT_MAN_HOUR_ENABLED = 'Y'                                                                 ");
			//queryStr.append("                   AND TERMINATION_DATE IS NULL                                                                     ");
			queryStr.append("               ) B                                                                                                  ");
			queryStr.append("         WHERE 1 = 1                                                                                                ");
			queryStr.append("           AND A.DEPT_CODE = B.DEPT_CODE(+)                                                                         ");
			queryStr.append("           AND A.EMPLOYEE_NO = B.EMPLOYEE_NUM(+)                                                                    ");
			queryStr.append("       ) A,                                                                                                         ");
			queryStr.append("       DCC_DEPTCODE B,                                                                                              ");
			queryStr.append("       DCC_DWGDEPTCODE C,                                                                                           ");
			queryStr.append("       STX_COM_INSA_DEPT@STXERP D                                                                                   ");
			queryStr.append(" WHERE 1 = 1                                                                                                        ");
			queryStr.append("   AND A.DEPT_CODE = B.DEPTCODE                                                                                     ");
			queryStr.append("   AND B.DWGDEPTCODE = C.DWGDEPTCODE                                                                                ");
			queryStr.append("   AND A.DEPT_CODE = D.DEPT_CODE                                                                                    ");
			queryStr.append("  ORDER BY C.ORDERNO, A.DEPT_CODE,                                                                                  ");
			queryStr.append("           DECODE(A.POSITION, '실장', 1, '부장', 2, '차장', 3, '과장', 4, '대리', 5,                                ");
			queryStr.append("                              '주임(J3)', 6, '주임(J2)', 7, '주임', 8, '사원A', 9),                                 ");
			queryStr.append("           A.EMPLOYEE_NO, A.EMP_NAME                                                                                ");


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_CODE", rset.getString(1));
				resultMap.put("DEPT_NAME", rset.getString(2));
				resultMap.put("EMPLOYEE_NO", rset.getString(3));
				resultMap.put("EMP_NAME", rset.getString(4));
				resultMap.put("POSITION", rset.getString(5));
				resultMap.put("OP1_WTIME", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("OP2_WTIME", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OP3_WTIME", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("OP4_WTIME", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("OP5_WTIME", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("OP5_RATE", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("PJT_WTIME", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("PJT_RATE", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("OP6_WTIME", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("OP7_WTIME", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("OP8_WTIME", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("NON_PJT_WTIME", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("NON_PJT_RATE", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("OP9_WTIME", rset.getString(19) == null ? "" : rset.getString(19));
				resultMap.put("OP9_RATE", rset.getString(20) == null ? "" : rset.getString(20));
				resultMap.put("TOTAL_OVERTIME", rset.getString(21) == null ? "" : rset.getString(21));
				resultMap.put("TOTAL_STIME", rset.getString(22) == null ? "" : rset.getString(22));
				resultMap.put("TOTAL_OVERTIME2", rset.getString(23) == null ? "" : rset.getString(23));
				resultMap.put("OVERTIME_RATE", rset.getString(24) == null ? "" : rset.getString(24));
				resultMap.put("TOTAL_NORMALTIME", rset.getString(25) == null ? "" : rset.getString(25));
				resultMap.put("MH_FACTOR", rset.getString(26) == null ? "" : rset.getString(26));

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

	// getAverageOvertimeOfAll() : 해당 기간의 전체(기술부문) 잔업 평균
	private String getAverageOvertimeOfAll(String dateFrom, String dateTo, String factorCase) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			/*
			queryStr.append("WITH EMP_CNT_TBL AS                                                                   ");
			queryStr.append("    (                                                                                 ");
			queryStr.append("     SELECT COUNT(DISTINCT(EMPLOYEE_NO)) AS EMP_CNT                                   ");
			queryStr.append("       FROM PLM_DESIGN_MH                                                             ");
			queryStr.append("      WHERE WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                ");
			queryStr.append("                         AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                  ");
			queryStr.append("    )                                                                                 ");
			queryStr.append("SELECT TRUNC(TOTAL_OVERTIME / (SELECT EMP_CNT FROM EMP_CNT_TBL)) AS OVERTIME_AVG      ");
			queryStr.append("  FROM (                                                                              ");
			queryStr.append("        SELECT (SUM(OVERTIME) + SUM(SPECIAL_TIME)) AS TOTAL_OVERTIME                  ");
			queryStr.append("          FROM PLM_DESIGN_MH                                                          ");
			queryStr.append("         WHERE WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')             ");
			queryStr.append("                            AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')               ");
			queryStr.append("       )                                                                              ");
			*/

			queryStr.append("WITH EMP_CNT_TBL AS                                                                                         ");
			queryStr.append("    (                                                                                                       ");
			queryStr.append("     SELECT COUNT(DISTINCT(EMPLOYEE_NO)) AS EMP_CNT                                                         ");
			queryStr.append("       FROM PLM_DESIGN_MH                                                                                   ");
			queryStr.append("      WHERE WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                                      ");
			queryStr.append("                         AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                                        ");
			queryStr.append("    )                                                                                                       ");
			queryStr.append("SELECT ROUND(TOTAL_OVERTIME / (SELECT DECODE(EMP_CNT, 0, 1, EMP_CNT) FROM EMP_CNT_TBL), 2) AS OVERTIME_AVG  ");
			queryStr.append("  FROM (                                                                                                    ");
			queryStr.append("        SELECT NVL(SUM((OVERTIME + SPECIAL_TIME) * MH_FACTOR), 0) AS TOTAL_OVERTIME                         ");
			queryStr.append("          from (                                                                                            ");
			queryStr.append("                 SELECT OVERTIME,                                                                           ");
			queryStr.append("                        SPECIAL_TIME,                                                                       ");
			queryStr.append("                        (                                                                                   ");
			queryStr.append("                          SELECT FACTOR_VALUE                                                               ");
			queryStr.append("                            FROM (                                                                          ");
			queryStr.append("                                  SELECT CAREER_MONTH_FROM,                                                 ");
			queryStr.append("                                         CAREER_MONTH_TO,                                                   ");
			queryStr.append("                                         FACTOR_VALUE                                                       ");
			queryStr.append("                                    FROM PLM_DESIGN_MH_FACTOR                                               ");
			queryStr.append("                                   WHERE 1 = 1                                                              ");
			queryStr.append("                                     AND CASE_NO = '" + factorCase + "'                                     ");
			queryStr.append("                                 )                                                                          ");
			queryStr.append("                           WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                         ");
			queryStr.append("                             AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                ");
			queryStr.append("                        ) AS MH_FACTOR                                                                      ");
			queryStr.append("                  FROM (                                                                                    ");
			queryStr.append("                        SELECT A.OVERTIME,                                                                  ");
			queryStr.append("                               A.SPECIAL_TIME,                                                              ");
			queryStr.append("                               NVL(                                                                         ");
			queryStr.append("                                    (                                                                        ");
			//queryStr.append("                                    CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                  ");
			//queryStr.append("                                    ELSE (                                                                  ");
			queryStr.append("                                     ((TO_CHAR(A.WORK_DAY,'YYYY')-TO_CHAR(B.DESIGN_APPLY_DATE,'YYYY'))*12 + ");
			queryStr.append("                                      (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +   ");
			queryStr.append("                                     CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1              ");
			queryStr.append("                                          WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0               ");
			queryStr.append("                                     END +                                                                  ");
			queryStr.append("                                     NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                        ");
			//queryStr.append("                                    )END                                                                     ");
			queryStr.append("                                   )                                                                        ");
			queryStr.append("                               , 9999) AS CAREER_MONTHS                                                     ");
			queryStr.append("                          FROM PLM_DESIGN_MH A,                                                             ");
			queryStr.append("                               CCC_SAWON B                                                                  ");
			queryStr.append("                         WHERE 1 = 1                                                                        ");
			queryStr.append("                           AND B.EMPLOYEE_NUM(+) = A.EMPLOYEE_NO                                            ");
			queryStr.append("                           AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                 ");
			queryStr.append("                                              AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                   ");
			queryStr.append("                       )                                                                                    ");
			queryStr.append("               )                                                                                            ");
			queryStr.append("       )                                                                                                    ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) resultStr = rset.getString(1);
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

	// getAverageOvertimeOfSelectedDepts() : 해당 기간의 선택된 부서(들)의 잔업 평균
	private String getAverageOvertimeOfSelectedDepts(String dateFrom, String dateTo, String deptCodeList, String factorCase) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		String resultStr = "";

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("WITH EMP_CNT_TBL AS                                                                                         "); 
			queryStr.append("    (                                                                                                       ");
			queryStr.append("     SELECT COUNT(DISTINCT(EMPLOYEE_NO)) AS EMP_CNT                                                         ");
			queryStr.append("       FROM PLM_DESIGN_MH                                                                                   ");
			queryStr.append("      WHERE WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                                      ");
			queryStr.append("                         AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                                        ");
			
			if (!deptCodeList.equals(""))
			queryStr.append("        AND DEPT_CODE IN (" + deptCodeList + ")                                                             ");
			
			queryStr.append("    )                                                                                                       ");
			queryStr.append("SELECT ROUND(TOTAL_OVERTIME / (SELECT DECODE(EMP_CNT, 0, 1, EMP_CNT) FROM EMP_CNT_TBL), 2) AS OVERTIME_AVG  ");
			queryStr.append("  FROM (                                                                                                    ");
			queryStr.append("        SELECT NVL(SUM((OVERTIME + SPECIAL_TIME) * MH_FACTOR), 0) AS TOTAL_OVERTIME                         ");
			queryStr.append("          from (                                                                                            ");
			queryStr.append("                 SELECT OVERTIME,                                                                           ");
			queryStr.append("                        SPECIAL_TIME,                                                                       ");
			queryStr.append("                        (                                                                                   ");
			queryStr.append("                          SELECT FACTOR_VALUE                                                               ");
			queryStr.append("                            FROM (                                                                          ");
			queryStr.append("                                  SELECT CAREER_MONTH_FROM,                                                 ");
			queryStr.append("                                         CAREER_MONTH_TO,                                                   ");
			queryStr.append("                                         FACTOR_VALUE                                                       ");
			queryStr.append("                                    FROM PLM_DESIGN_MH_FACTOR                                               ");
			queryStr.append("                                   WHERE 1 = 1                                                              ");
			queryStr.append("                                     AND CASE_NO = '" + factorCase + "'                                     ");
			queryStr.append("                                 )                                                                          ");
			queryStr.append("                           WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                         ");
			queryStr.append("                             AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                ");
			queryStr.append("                        ) AS MH_FACTOR                                                                      ");
			queryStr.append("                  FROM (                                                                                    ");
			queryStr.append("                        SELECT A.OVERTIME,                                                                  ");
			queryStr.append("                               A.SPECIAL_TIME,                                                              ");
			queryStr.append("                               NVL(                                                                         ");
			queryStr.append("                                   (                                                                        ");
			//queryStr.append("                                    CASE WHEN SUBSTR(B.POSITION, 1, 2) <> '주임' THEN NULL                  ");
			//queryStr.append("                                    ELSE (                                                                  ");
			queryStr.append("                                     ((TO_CHAR(A.WORK_DAY,'YYYY')-TO_CHAR(B.DESIGN_APPLY_DATE,'YYYY'))*12 + ");
			queryStr.append("                                      (TO_CHAR(A.WORK_DAY, 'MM') - TO_CHAR(B.DESIGN_APPLY_DATE, 'MM'))) +   ");
			queryStr.append("                                     CASE WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1              ");
			queryStr.append("                                          WHEN TO_CHAR(B.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0               ");
			queryStr.append("                                     END +                                                                  ");
			queryStr.append("                                     NVL(ROUND(B.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                        ");
			//queryStr.append("                                    )END                                                                     ");
			queryStr.append("                                   )                                                                        ");
			queryStr.append("                               , 9999) AS CAREER_MONTHS                                                     ");
			queryStr.append("                          FROM PLM_DESIGN_MH A,                                                             ");
			queryStr.append("                               CCC_SAWON B                                                                  ");
			queryStr.append("                         WHERE 1 = 1                                                                        ");
			queryStr.append("                           AND B.EMPLOYEE_NUM(+) = A.EMPLOYEE_NO                                            ");

			if (!deptCodeList.equals(""))
			queryStr.append("                           AND A.DEPT_CODE IN (" + deptCodeList + ")                                        ");
			
			queryStr.append("                           AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                 ");
			queryStr.append("                                              AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                   ");
			queryStr.append("                       )                                                                                    ");
			queryStr.append("               )                                                                                            ");
			queryStr.append("       )                                                                                                    ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			if (rset.next()) resultStr = rset.getString(1);
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultStr;
	}

%>








<%--========================== JSP =========================================--%>
<%
    request.setCharacterEncoding("euc-kr"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
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
    String averageOvertimeOfAll = "";
    String averageOvertimeOfSelectedDepts = "";

    try {
        if (!firstCall.equals("Y")) {
            baseWorkTime = getBaseWorkTime(dateFrom, dateTo);
            averageOvertimeOfAll = getAverageOvertimeOfAll(dateFrom, dateTo, factorCase);
            averageOvertimeOfSelectedDepts = getAverageOvertimeOfSelectedDepts(dateFrom, dateTo, deptCode, factorCase);
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
    <title>개인 별 설계시수 조회</title>
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
<form name="DPDataMgmtMain">

    <% if (!errStr.equals("")) { %>
        <%=errStr%>
    <% } %>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="2"><td colspan="3"></td></tr>
        <tr height="20" style="font-weight:bold;color:#0000ff;">
            <td width="300px">기간 당연투입시수: <%=baseWorkTime%></td>
            <td width="300px">기술부문 잔업평균: <%=averageOvertimeOfAll%></td>
            <td>파트 잔업평균: <%=averageOvertimeOfSelectedDepts%></td>
        </tr>
        <tr height="5"><td colspan="3"></td></tr>
    </table>
   
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold" rowspan="2">NO</td>
            <td class="td_standardBold" rowspan="2">부서<br>CODE</td>
            <td class="td_standardBold" rowspan="2">부서</td>
            <td class="td_standardBold" rowspan="2">사번</td>
            <td class="td_standardBold" rowspan="2">성명</td>
            <td class="td_standardBold" rowspan="2">Fact.</td>
            <td class="td_standardBold" colspan="8">공사시수</td>
            <td class="td_standardBold" colspan="5">비공사시수</td>
            <td class="td_standardBold" colspan="2">총투입실적</td>
            <td class="td_standardBold" colspan="2">당연투입</td>
            <td class="td_standardBold" colspan="2">근태</td>
            <td class="td_standardBold" colspan="4">잔업 및 특근</td>
        </tr>
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standard">설계준비</td>
            <td class="td_standard">설계제도</td>
            <td class="td_standard">협의검토</td>
            <td class="td_standard">시험현장</td>
            <td class="td_standard">도면수정</td>
            <td class="td_standard">자체개정율</td>
            <td class="td_standard">소계</td>
            <td class="td_standard">시수율</td>

            <td class="td_standard">보조지원</td>
            <td class="td_standard">생산향상</td>
            <td class="td_standard">기타</td>
            <td class="td_standard">소계</td>
            <td class="td_standard">시수율</td>

            <td class="td_standard">시수</td>
            <td class="td_standard">차지율</td>

            <td class="td_standard">시수</td>
            <td class="td_standard">사용율</td>

            <td class="td_standard">시수</td>
            <td class="td_standard">율</td>

            <td class="td_standard">연장</td>
            <td class="td_standard">특근</td>
            <td class="td_standard">총계</td>
            <td class="td_standard">잔업율</td>
        </tr>

        <%
        if (!firstCall.equals("Y")) 
        {
            /*
            String deptCodeStrs = "";
            if (!deptCode.equals("")) {
                deptCodeStrs = deptCode;
            }
            else {
                ArrayList dpDeptList = getMHInputDepartmentList();
                for (int i = 0; i < dpDeptList.size(); i++) {
                    Map map = (Map)dpDeptList.get(i);
                    if (i > 0) deptCodeStrs += ",";
                    deptCodeStrs += "'" + (String)map.get("DEPT_CODE") + "'";
                }
            }
            */

            DecimalFormat df = new DecimalFormat("###,###.##");
            float averageOvertimeOfAllVal = Float.parseFloat(averageOvertimeOfAll);

            //if (!deptCodeStrs.equals(""))
            //{
                ArrayList dpInputsList = getDesignMHSummaryByPerson(dateFrom, dateTo, deptCode, factorCase);

                float op1WTimeTotal = 0;
                float op2WTimeTotal = 0;
                float op3WTimeTotal = 0;
                float op4WTimeTotal = 0;
                float op5WTimeTotal = 0;
                float op6WTimeTotal = 0;
                float op7WTimeTotal = 0;
                float op8WTimeTotal = 0;
                float op9WTimeTotal = 0;
                
                float pjtWTimeTotal = 0; // 공사시수 합: OP1~OP5 시수의 합
                float nonPjtWTimeTotal = 0; // 비공사시수 합: OP6~OP8 시수의 합
                float wTimeTotal = 0; // 작업시수 합: 공사시수 + 비공사시수 합 (총 시수에서 근태(OP9) 시수를 제외한 것)
                float normalTimeTotal = 0; // 정상근무 시수 합
                float overtimeTotal = 0; // 연장근무 시수 합
                float specialTimeTotal = 0; // 특근 시수 합
                float overtimeTotal2 = 0; // 연장근무 + 특근 시수 합

                float op5RateTotal = 0; // 자체개정율: 공사시수 중에서 개정(OP5) 시수가 차지하는 비율
                float pjtWTimeRateTotal = 0; // 공사시수율: 작업시수 합에서 공사시수가 차지하는 비율
                float nonPjtWTimeRateTotal = 0; // 비공사시수율: 작업시수 합에서 비공사시수가 차지하는 비율
                float normalWTimeRate = 0; // 시수 사용율: 당연투입시수 대비 정상근무시수 합의 비율
                float op9RateTotal = 0; // 근태시수율: 전체시수 중에서 근태(OP9) 시수가 차지하는 비율
                float overtimeRate = 0; // 잔업율: 작업시수 합에서 연장근무 + 특근 시수 합이 차지하는 비율

                for (int j = 0; j < dpInputsList.size(); j++)
                {
                    Map map = (Map)dpInputsList.get(j);
                    String op1WTimeStr = (String)map.get("OP1_WTIME");
                    String op2WTimeStr = (String)map.get("OP2_WTIME");
                    String op3WTimeStr = (String)map.get("OP3_WTIME");
                    String op4WTimeStr = (String)map.get("OP4_WTIME");
                    String op5WTimeStr = (String)map.get("OP5_WTIME");
                    String op6WTimeStr = (String)map.get("OP6_WTIME");
                    String op7WTimeStr = (String)map.get("OP7_WTIME");
                    String op8WTimeStr = (String)map.get("OP8_WTIME");
                    String op9WTimeStr = (String)map.get("OP9_WTIME");
                    String pjtWTimeStr = (String)map.get("PJT_WTIME");
                    String nonPjtWTimeStr = (String)map.get("NON_PJT_WTIME");
                    String op5Rate = (String)map.get("OP5_RATE");
                    String op9Rate = (String)map.get("OP9_RATE");
                    String pjtRate = (String)map.get("PJT_RATE");
                    String nonPjtRate = (String)map.get("NON_PJT_RATE");
                    String totalNormalTime = (String)map.get("TOTAL_NORMALTIME");
                    String totalOvertime = (String)map.get("TOTAL_OVERTIME");
                    String totalSpecialTime = (String)map.get("TOTAL_STIME");
                    String totalOvertime2 = (String)map.get("TOTAL_OVERTIME2");

                    op1WTimeTotal += StringUtil.isNullString(op1WTimeStr) ? 0 : Float.parseFloat(op1WTimeStr);
                    op2WTimeTotal += StringUtil.isNullString(op2WTimeStr) ? 0 : Float.parseFloat(op2WTimeStr);
                    op3WTimeTotal += StringUtil.isNullString(op3WTimeStr) ? 0 : Float.parseFloat(op3WTimeStr);
                    op4WTimeTotal += StringUtil.isNullString(op4WTimeStr) ? 0 : Float.parseFloat(op4WTimeStr);
                    op5WTimeTotal += StringUtil.isNullString(op5WTimeStr) ? 0 : Float.parseFloat(op5WTimeStr);
                    op6WTimeTotal += StringUtil.isNullString(op6WTimeStr) ? 0 : Float.parseFloat(op6WTimeStr);
                    op7WTimeTotal += StringUtil.isNullString(op7WTimeStr) ? 0 : Float.parseFloat(op7WTimeStr);
                    op8WTimeTotal += StringUtil.isNullString(op8WTimeStr) ? 0 : Float.parseFloat(op8WTimeStr);
                    op9WTimeTotal += StringUtil.isNullString(op9WTimeStr) ? 0 : Float.parseFloat(op9WTimeStr);

                    pjtWTimeTotal += StringUtil.isNullString(pjtWTimeStr) ? 0 : Float.parseFloat(pjtWTimeStr);
                    nonPjtWTimeTotal += StringUtil.isNullString(nonPjtWTimeStr) ? 0 : Float.parseFloat(nonPjtWTimeStr);

                    normalTimeTotal += StringUtil.isNullString(totalNormalTime) ? 0 : Float.parseFloat(totalNormalTime);
                    overtimeTotal += StringUtil.isNullString(totalOvertime) ? 0 : Float.parseFloat(totalOvertime);
                    specialTimeTotal += StringUtil.isNullString(totalSpecialTime) ? 0 : Float.parseFloat(totalSpecialTime);
                    overtimeTotal2 += StringUtil.isNullString(totalOvertime2) ? 0 : Float.parseFloat(totalOvertime2);
                }
                wTimeTotal = pjtWTimeTotal + nonPjtWTimeTotal;
                op5RateTotal = (op5WTimeTotal == 0 || wTimeTotal == 0) ? 0 : op5WTimeTotal / wTimeTotal * 100;
                pjtWTimeRateTotal = (pjtWTimeTotal == 0 || wTimeTotal == 0) ? 0 : pjtWTimeTotal / wTimeTotal * 100;
                nonPjtWTimeRateTotal = (nonPjtWTimeTotal == 0 || wTimeTotal == 0) ? 0 : nonPjtWTimeTotal / wTimeTotal * 100;
                normalWTimeRate = (wTimeTotal == 0 || normalTimeTotal == 0) ? 0 : wTimeTotal / normalTimeTotal * 100;
                op9RateTotal = (op9WTimeTotal == 0 || wTimeTotal + op9WTimeTotal == 0) ? 0 : op9WTimeTotal / (wTimeTotal + op9WTimeTotal) * 100;
                overtimeRate = (overtimeTotal2 == 0 || wTimeTotal == 0) ? 0 : overtimeTotal2 / wTimeTotal * 100;

                String op1WTimeTotalStr = (op1WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op1WTimeTotal*100)/100.0);
                String op2WTimeTotalStr = (op2WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op2WTimeTotal*100)/100.0);
                String op3WTimeTotalStr = (op3WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op3WTimeTotal*100)/100.0);
                String op4WTimeTotalStr = (op4WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op4WTimeTotal*100)/100.0);
                String op5WTimeTotalStr = (op5WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op5WTimeTotal*100)/100.0);
                String op6WTimeTotalStr = (op6WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op6WTimeTotal*100)/100.0);
                String op7WTimeTotalStr = (op7WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op7WTimeTotal*100)/100.0);
                String op8WTimeTotalStr = (op8WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op8WTimeTotal*100)/100.0);
                String op9WTimeTotalStr = (op9WTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(op9WTimeTotal*100)/100.0);
                String op5RateTotalStr = (op5RateTotal == 0) ? "&nbsp;" : df.format(Math.round(op5RateTotal*100)/100.0);
                String pjtWTimeTotalStr = (pjtWTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(pjtWTimeTotal*100)/100.0);
                String pjtWTimeRateTotalStr = (pjtWTimeRateTotal == 0) ? "&nbsp;" : df.format(Math.round(pjtWTimeRateTotal*100)/100.0);
                String nonPjtWTimeTotalStr = (nonPjtWTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(nonPjtWTimeTotal*100)/100.0);
                String nonPjtWTimeRateTotalStr = (nonPjtWTimeRateTotal == 0) ? "&nbsp;" : df.format(Math.round(nonPjtWTimeRateTotal*100)/100.0);
                String wTimeTotalStr = (wTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(wTimeTotal*100)/100.0);
                String wTimeTotalPortionStr = (wTimeTotal == 0) ? "&nbsp;" : "100";
                String normalTimeTotalStr = (normalTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(normalTimeTotal*100)/100.0);
                String normalWTimeRateStr = (normalWTimeRate == 0) ? "&nbsp;" : df.format(Math.round(normalWTimeRate*100)/100.0);
                String op9RateTotalStr = (op9RateTotal == 0) ? "&nbsp;" : df.format(Math.round(op9RateTotal*100)/100.0);
                String overtimeTotalStr = (overtimeTotal == 0) ? "&nbsp;" : df.format(Math.round(overtimeTotal*100)/100.0);
                String specialTimeTotalStr = (specialTimeTotal == 0) ? "&nbsp;" : df.format(Math.round(specialTimeTotal*100)/100.0);
                String overtimeTotal2Str = (overtimeTotal2 == 0) ? "&nbsp;" : df.format(Math.round(overtimeTotal2*100)/100.0);
                String overtimeRateStr = (overtimeRate == 0) ? "&nbsp;" : df.format(Math.round(overtimeRate*100)/100.0);

                %>
                <tr height="20" style="background-color:#dddddd">
                    <td class="td_standardRight" colspan="6" style="font-weight:bold;">TOTAL&nbsp;</td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op1WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op2WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op3WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op4WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op5WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op5RateTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=pjtWTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=pjtWTimeRateTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op6WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op7WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op8WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=nonPjtWTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=nonPjtWTimeRateTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=wTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=wTimeTotalPortionStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=normalTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=normalWTimeRateStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op9WTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=op9RateTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=overtimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=specialTimeTotalStr%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=overtimeTotal2Str%></td>
                    <td class="td_standardRightBoldBorder" style="color:#ff0000;"><%=overtimeRateStr%></td>
                </tr>
                <%

                float deptWTimeTotal = wTimeTotal;

                for (int j = 0; j < dpInputsList.size(); j++)
                {
                    Map map = (Map)dpInputsList.get(j);

                    String op1WTimeStr = (String)map.get("OP1_WTIME");
                    String op2WTimeStr = (String)map.get("OP2_WTIME");
                    String op3WTimeStr = (String)map.get("OP3_WTIME");
                    String op4WTimeStr = (String)map.get("OP4_WTIME");
                    String op5WTimeStr = (String)map.get("OP5_WTIME");
                    String op6WTimeStr = (String)map.get("OP6_WTIME");
                    String op7WTimeStr = (String)map.get("OP7_WTIME");
                    String op8WTimeStr = (String)map.get("OP8_WTIME");
                    String op9WTimeStr = (String)map.get("OP9_WTIME");
                    String pjtWTimeStr = (String)map.get("PJT_WTIME");
                    String nonPjtWTimeStr = (String)map.get("NON_PJT_WTIME");
                    String op5RateStr = (String)map.get("OP5_RATE");
                    String op9RateStr = (String)map.get("OP9_RATE");
                    String pjtWTimeRateStr = (String)map.get("PJT_RATE");
                    String nonPjtWTimeRateStr = (String)map.get("NON_PJT_RATE");
                    String totalNormalTimeStr = (String)map.get("TOTAL_NORMALTIME");
                    String totalOvertimeStr = (String)map.get("TOTAL_OVERTIME");
                    String totalSpecialTimeStr = (String)map.get("TOTAL_STIME");
                    String totalOvertime2Str = (String)map.get("TOTAL_OVERTIME2");
                    overtimeRateStr = (String)map.get("OVERTIME_RATE");
                    String mhFactorStr = (String)map.get("MH_FACTOR");

                    float op1WTime = StringUtil.isNullString(op1WTimeStr) ? 0 : Float.parseFloat(op1WTimeStr);
                    float op2WTime = StringUtil.isNullString(op2WTimeStr) ? 0 : Float.parseFloat(op2WTimeStr);
                    float op3WTime = StringUtil.isNullString(op3WTimeStr) ? 0 : Float.parseFloat(op3WTimeStr);
                    float op4WTime = StringUtil.isNullString(op4WTimeStr) ? 0 : Float.parseFloat(op4WTimeStr);
                    float op5WTime = StringUtil.isNullString(op5WTimeStr) ? 0 : Float.parseFloat(op5WTimeStr);
                    float op6WTime = StringUtil.isNullString(op6WTimeStr) ? 0 : Float.parseFloat(op6WTimeStr);
                    float op7WTime = StringUtil.isNullString(op7WTimeStr) ? 0 : Float.parseFloat(op7WTimeStr);
                    float op8WTime = StringUtil.isNullString(op8WTimeStr) ? 0 : Float.parseFloat(op8WTimeStr);
                    float op9WTime = StringUtil.isNullString(op9WTimeStr) ? 0 : Float.parseFloat(op9WTimeStr);

                    float pjtWTime = StringUtil.isNullString(pjtWTimeStr) ? 0 : Float.parseFloat(pjtWTimeStr);
                    float nonPjtWTime = StringUtil.isNullString(nonPjtWTimeStr) ? 0 : Float.parseFloat(nonPjtWTimeStr);
                    float wTime = pjtWTime + nonPjtWTime;
                    float wTimePortion = (wTime == 0 || wTimeTotal == 0) ? 0 : wTime / wTimeTotal * 100;

                    float op5Rate = StringUtil.isNullString(op5RateStr) ? 0 : Float.parseFloat(op5RateStr);
                    float pjtWTimeRate = StringUtil.isNullString(pjtWTimeRateStr) ? 0 : Float.parseFloat(pjtWTimeRateStr);
                    float nonPjtWTimeRate = StringUtil.isNullString(nonPjtWTimeRateStr) ? 0 : Float.parseFloat(nonPjtWTimeRateStr);
                    float op9Rate = StringUtil.isNullString(op9RateStr) ? 0 : Float.parseFloat(op9RateStr);

                    float normalTime = StringUtil.isNullString(totalNormalTimeStr) ? 0 : Float.parseFloat(totalNormalTimeStr);
                    float overtime = StringUtil.isNullString(totalOvertimeStr) ? 0 : Float.parseFloat(totalOvertimeStr);
                    float specialTime = StringUtil.isNullString(totalSpecialTimeStr) ? 0 : Float.parseFloat(totalSpecialTimeStr);
                    float overtime2 = StringUtil.isNullString(totalOvertime2Str) ? 0 : Float.parseFloat(totalOvertime2Str);

                    float normalTimeRate = (normalTime == 0 || wTime == 0) ? 0 : wTime / normalTime * 100;
                    float overtimeRate2 = StringUtil.isNullString(overtimeRateStr) ? 0 : Float.parseFloat(overtimeRateStr);

                    float mhFactor = StringUtil.isNullString(mhFactorStr) ? 0 : Float.parseFloat(mhFactorStr);

                    op1WTimeStr = (op1WTime == 0) ? "&nbsp;" : df.format(Math.round(op1WTime*100)/100.0);
                    op2WTimeStr = (op2WTime == 0) ? "&nbsp;" : df.format(Math.round(op2WTime*100)/100.0);
                    op3WTimeStr = (op3WTime == 0) ? "&nbsp;" : df.format(Math.round(op3WTime*100)/100.0);
                    op4WTimeStr = (op4WTime == 0) ? "&nbsp;" : df.format(Math.round(op4WTime*100)/100.0);
                    op5WTimeStr = (op5WTime == 0) ? "&nbsp;" : df.format(Math.round(op5WTime*100)/100.0);
                    op6WTimeStr = (op6WTime == 0) ? "&nbsp;" : df.format(Math.round(op6WTime*100)/100.0);
                    op7WTimeStr = (op7WTime == 0) ? "&nbsp;" : df.format(Math.round(op7WTime*100)/100.0);
                    op8WTimeStr = (op8WTime == 0) ? "&nbsp;" : df.format(Math.round(op8WTime*100)/100.0);
                    op9WTimeStr = (op9WTime == 0) ? "&nbsp;" : df.format(Math.round(op9WTime*100)/100.0);
                    op5RateStr = (op5Rate == 0) ? "&nbsp;" : df.format(Math.round(op5Rate*100)/100.0);
                    pjtWTimeStr = (pjtWTime == 0) ? "&nbsp;" : df.format(Math.round(pjtWTime*100)/100.0);
                    pjtWTimeRateStr = (pjtWTimeRate == 0) ? "&nbsp;" : df.format(Math.round(pjtWTimeRate*100)/100.0);
                    nonPjtWTimeStr = (nonPjtWTime == 0) ? "&nbsp;" : df.format(Math.round(nonPjtWTime*100)/100.0);
                    nonPjtWTimeRateStr = (nonPjtWTimeRate == 0) ? "&nbsp;" : df.format(Math.round(nonPjtWTimeRate*100)/100.0);
                    String wTimeStr = (wTime == 0) ? "&nbsp;" : df.format(Math.round(wTime*100)/100.0);
                    String wTimePortionStr = (wTimePortion == 0) ? "&nbsp;" : df.format(Math.round(wTimePortion*100)/100.0);
                    String normalTimeStr = (normalTime == 0) ? "&nbsp;" : df.format(Math.round(normalTime*100)/100.0);
                    String normalTimeRateStr = (normalTimeRate == 0) ? "&nbsp;" : df.format(Math.round(normalTimeRate*100)/100.0);
                    op9RateStr = (op9Rate == 0) ? "&nbsp;" : df.format(Math.round(op9Rate*100)/100.0);
                    String overtimeStr = (overtime == 0) ? "&nbsp;" : df.format(Math.round(overtime*100)/100.0);
                    String specialTimeStr = (specialTime == 0) ? "&nbsp;" : df.format(Math.round(specialTime*100)/100.0);
                    String overtime2Str = (overtime2 == 0) ? "&nbsp;" : df.format(Math.round(overtime2*100)/100.0);
                    overtimeRateStr = (overtimeRate2 == 0) ? "&nbsp;" : df.format(Math.round(overtimeRate2*100)/100.0);
                    mhFactorStr = (mhFactor == 0) ? "&nbsp;" : df.format(Math.round(mhFactor*100)/100.0);

                    String trBgColor = overtime2 >= averageOvertimeOfAllVal ? "#ffffa0" : "#ffffff";
                    String tdBgColor = normalTime < (baseWorkTimeValue * mhFactor) ? "#ff0000" : trBgColor;
                    %>
                        <tr height="20" bgcolor="<%= trBgColor %>">
                            <td class="td_standard"><%= j + 1 %></td>
                            <td class="td_standard"><%=(String)map.get("DEPT_CODE")%></td>
                            <td class="td_standard"><%=(String)map.get("DEPT_NAME")%></td>
                            <td class="td_standard"><%=(String)map.get("EMPLOYEE_NO")%></td>
                            <td class="td_standard"><%=(String)map.get("POSITION") + " " + (String)map.get("EMP_NAME")%></td>
                            <td class="td_standard"><%=mhFactorStr%></td>
                            <td class="td_standardRight"><%= op1WTimeStr %></td>
                            <td class="td_standardRight"><%= op2WTimeStr %></td>
                            <td class="td_standardRight"><%= op3WTimeStr %></td>
                            <td class="td_standardRight"><%= op4WTimeStr %></td>
                            <td class="td_standardRight"><%= op5WTimeStr %></td>
                            <td class="td_standardRight"><%= op5RateStr %></td>
                            <td class="td_standardRight"><%= pjtWTimeStr %></td>
                            <td class="td_standardRight"><%= pjtWTimeRateStr %></td>
                            <td class="td_standardRight"><%= op6WTimeStr %></td>
                            <td class="td_standardRight"><%= op7WTimeStr %></td>
                            <td class="td_standardRight"><%= op8WTimeStr %></td>
                            <td class="td_standardRight"><%= nonPjtWTimeStr %></td>
                            <td class="td_standardRight"><%= nonPjtWTimeRateStr %></td>
                            <td class="td_standardRight"><%= wTimeStr %></td>
                            <td class="td_standardRight"><%= wTimePortionStr %></td>
                            <td class="td_standardRight" bgcolor="<%=tdBgColor%>"><%= normalTimeStr %></td>
                            <td class="td_standardRight"><%= normalTimeRateStr %></td>
                            <td class="td_standardRight"><%= op9WTimeStr %></td>
                            <td class="td_standardRight"><%= op9RateStr %></td>
                            <td class="td_standardRight"><%= overtimeStr %></td>
                            <td class="td_standardRight"><%= specialTimeStr %></td>
                            <td class="td_standardRight"><%= overtime2Str %></td>
                            <td class="td_standardRight"><%= overtimeRateStr %></td>
                        </tr>
                    <%
                }
            //}
        }
        %>
    </table>

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="20"><td>&nbsp;</td></tr>
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