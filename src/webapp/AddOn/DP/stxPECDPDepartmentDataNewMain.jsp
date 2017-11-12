<%--  
§DESCRIPTION: 부서 별 시수조회 화면 메인 부분 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPDepartmentDataNewMain.jsp
§CHANGING HISTORY: 
§    2014-12-29: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// getDesignMHSummaryByDepartment(): 부서 별 설계시수 조회
	private ArrayList getDesignMHSummaryByDepartment(String dateFrom, String dateTo, String deptCodeList, String factorCase) throws Exception
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

			queryStr.append("   SELECT '1'                              AS ORDER_BY              --정렬순서                                                                                       \n");
			queryStr.append("          ,'TOTAL'                         AS DWGDEPTNM             --부서명                                                                                       \n");
			queryStr.append("          ,SUM(OP.MH_A12)                  AS MH_A12                --제도                                                                                          \n");
			queryStr.append("          ,SUM(OP.MH_A11)                  AS MH_A11                --계산                                                                                          \n");
			queryStr.append("          ,SUM(OP.MH_A15)                  AS MH_A15                --도면출도                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_A16)                  AS MH_A16                --V/D검토                                                                                       \n");
			queryStr.append("          ,SUM(OP.MH_A19)                  AS MH_A19                --ECR/ECO처리                                                                                   \n");
			queryStr.append("          ,SUM(OP.MH_A14)                  AS MH_A14                --외주도면 F/UP                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_A2)                   AS MH_A2                 --도면개정                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_IN)                   AS MH_IN                 --직영시수                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_OUT)                  AS MH_OUT                --외주도면시수                                                                                  \n");
			queryStr.append("          ,SUM(OP.MH_IN) + SUM(OP.MH_OUT)  AS MH_DWG_SUM            --도면시수 소계                                                                                 \n");
			queryStr.append("          ,SUM(OP.MH_B1)                   AS MH_B1                 --설계준비                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_B2)                   AS MH_B2                 --도면검토                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_B3)                   AS MH_B3                 --PR/BOM                                                                            \n");
			queryStr.append("          ,SUM(OP.MH_B4)                   AS MH_B4                 --협의 및 검토                                                                                  \n");
			queryStr.append("          ,SUM(OP.MH_B5)                   AS MH_B5                 --호선관리                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_B6)                   AS MH_B6                 --기타                                                                                          \n");
			queryStr.append("          ,SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6)                                           \n");
			queryStr.append("                                           AS MH_DEDWG_SUM          --비도면시수 소계                                                                               \n");
			queryStr.append("          ,SUM(OP.MH_IN) + SUM(OP.MH_OUT) + SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6)          \n");
			queryStr.append("                                           AS MH_CON_TOT            --공사시수 합계                                                                                 \n");
			queryStr.append("          ,SUM(OP.MH_C1)                   AS MH_C1                 --보조업무지원                                                                                  \n");
			queryStr.append("          ,SUM(OP.MH_C2)                   AS MH_C2                 --생산성향상                                                                                    \n");
			queryStr.append("          ,SUM(OP.MH_C3)                   AS MH_C3                 --기타                                                                                          \n");
			queryStr.append("          ,SUM(OP.MH_C1)  + SUM(OP.MH_C2)  + SUM(OP.MH_C3)                                                                                              \n");
			queryStr.append("                                           AS MH_DECON_SUM                                                                                              \n");
			queryStr.append("          ,SUM(OP.MH_IN)  + SUM(OP.MH_OUT) +                                                                                                            \n");
			queryStr.append("           SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6) +                                         \n");
			queryStr.append("           SUM(OP.MH_C1)  + SUM(OP.MH_C2)  + SUM(OP.MH_C3)                                                                                              \n");
			queryStr.append("                                           AS MH_TAKE               --총소요시수                                                                                    \n");
			queryStr.append("          ,SUM(OP.MH_D1)                   AS MH_D1                 --근태시수                                                                                      \n");
			queryStr.append("    FROM (                                                                                                                                                          \n");
			queryStr.append("          SELECT DEPT_CODE                                                                                                                                          \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A12' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A12                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A11' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A11                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A15' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A15                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A16' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A16                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A19' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A19                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A14' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A14                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'A2' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A2                                                                                                                                       \n");			
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'A' THEN                                                                                                           \n");
			queryStr.append("                           CASE WHEN OP_CODE <> 'A13' THEN                                                                                                          \n");
			queryStr.append("                                     ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                     \n");
			queryStr.append("                           END                                                                                                                                      \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_IN                                                                                                                                       \n");
			queryStr.append("                ,0   AS MH_OUT                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B1                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B2' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B2                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B3' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B3                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B4' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B4                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B5' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B5                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B6' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B6                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C1                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C2' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C2                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C3' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C3                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'D1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                               \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_D1                                                                                                                                       \n");
			queryStr.append("            FROM                                                                                                                                                    \n");
			queryStr.append("                 (                                                                                                                                                  \n");
			queryStr.append("                 SELECT EMPLOYEE_NO                                                                                                                                 \n");
			queryStr.append("                       ,DEPT_CODE                                                                                                                                   \n");
			queryStr.append("                       ,OP_CODE                                                                                                                                     \n");
			queryStr.append("                       ,NORMAL_TIME * MH_FACTOR AS NORMAL_TIME                                                                                                      \n");
			queryStr.append("                       ,OVERTIME * MH_FACTOR AS OVERTIME                                                                                                            \n");
			queryStr.append("                       ,SPECIAL_TIME * MH_FACTOR AS SPECIAL_TIME                                                                                                    \n");
			queryStr.append("                   FROM (                                                                                                                                           \n");
			queryStr.append("                         SELECT EMPLOYEE_NO                                                                                                                         \n");
			queryStr.append("                               ,DEPT_CODE                                                                                                                           \n");
			queryStr.append("                               ,OP_CODE                                                                                                                             \n");
			queryStr.append("                               ,NORMAL_TIME                                                                                                                         \n");
			queryStr.append("                               ,OVERTIME                                                                                                                            \n");
			queryStr.append("                               ,SPECIAL_TIME                                                                                                                        \n");
			queryStr.append("                               ,CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                                                              \n");
			queryStr.append("                                ELSE (                                                                                                                              \n");
			queryStr.append("                                       SELECT FACTOR_VALUE                                                                                                          \n");
			queryStr.append("                                         FROM (                                                                                                                     \n");
			queryStr.append("                                               SELECT CAREER_MONTH_FROM,                                                                                            \n");
			queryStr.append("                                                      CAREER_MONTH_TO,                                                                                              \n");
			queryStr.append("                                                      FACTOR_VALUE                                                                                                  \n");
			queryStr.append("                                                 FROM PLM_DESIGN_MH_FACTOR                                                                                          \n");
			queryStr.append("                                                WHERE 1 = 1                                                                                                         \n");
			queryStr.append("                                                  AND CASE_NO = '" + factorCase + "'                                                                                \n");
			queryStr.append("                                              )                                                                                                                     \n");
			queryStr.append("                                        WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                                                                    \n");
			queryStr.append("                                          AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                                                           \n");
			queryStr.append("                                     )                                                                                                                              \n");
			queryStr.append("                                END AS MH_FACTOR                                                                                                                    \n");
			queryStr.append("                           FROM                                                                                                                                     \n");
			queryStr.append("                                (                                                                                                                                   \n");
			queryStr.append("                                 SELECT DM.EMPLOYEE_NO                                                                                                              \n");
			queryStr.append("                                       ,DM.DEPT_CODE                                                                                                                \n");
			queryStr.append("                                       ,DM.OP_CODE                                                                                                                  \n");
			queryStr.append("                                       ,SUM(DM.NORMAL_TIME)  AS NORMAL_TIME                                                                                         \n");
			queryStr.append("                                       ,SUM(DM.OVERTIME)     AS OVERTIME                                                                                            \n");
			queryStr.append("                                       ,SUM(DM.SPECIAL_TIME) AS SPECIAL_TIME                                                                                        \n");
			queryStr.append("                                      ,((TO_CHAR(DM.WORK_DAY, 'YYYY') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'YYYY'))* 12 +                                                \n");
			queryStr.append("                                        (TO_CHAR(DM.WORK_DAY, 'MM') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'MM'))) +                                                       \n");
			queryStr.append("                                       CASE WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                                                                   \n");
			queryStr.append("                                            WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                                                                    \n");
			queryStr.append("                                       END + NVL(ROUND(CS.BEFORE_ENTRANCE_CAREER * 12, 0), 0) AS CAREER_MONTHS                                                      \n");
			queryStr.append("                                  FROM PLM_DESIGN_MH  DM                                                                                                            \n");
			queryStr.append("                                      ,CCC_SAWON      CS                                                                                                            \n");
			queryStr.append("                                 WHERE DM.EMPLOYEE_NO = CS.EMPLOYEE_NUM                                                                                             \n");
			queryStr.append("                                   AND DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                      \n");
			queryStr.append("                                   AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                        \n");
			queryStr.append("                                 GROUP BY DM.EMPLOYEE_NO, DM.DEPT_CODE, DM.OP_CODE, DM.WORK_DAY, CS.DESIGN_APPLY_DATE, CS.BEFORE_ENTRANCE_CAREER                    \n");
			queryStr.append("                                )                                                                                                                                   \n");
			queryStr.append("                         )                                                                                                                                          \n");
			queryStr.append("                  )                                                                                                                                                 \n");
			queryStr.append("           GROUP BY DEPT_CODE, OP_CODE                                                                                                                              \n");
			queryStr.append("           UNION ALL                                                                                                                                                \n");
			queryStr.append("          SELECT B.DEPT_CODE                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A12                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A11                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A15                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A16                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A19                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A14                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A2                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_IN                                                                                                                                         \n");
			queryStr.append("                ,ROUND(NVL(SUM(A.MH_OUT),0),1) AS MH_OUT                                                                                                              \n");
			queryStr.append("                ,0 AS MH_B1                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B2                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B3                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B4                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B5                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B6                                                                                                                                         \n");
			queryStr.append("                                                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_C1                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_C2                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_C3                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_D1                                                                                                                                         \n");
			queryStr.append("            FROM                                                                                                                                                    \n");
			queryStr.append("                (                                                                                                                                                   \n");
			queryStr.append("                SELECT RD.PROJECT_NO                                                                                                                                \n");
			queryStr.append("                      ,RH.REQUEST_DEPT                                                                                                                              \n");
			queryStr.append("                      ,RD.DRAWING_NUM                                                                                                                               \n");
			queryStr.append("                      ,(MAX(DA.PLANMH) * (SUM(RD.MANAGER_ENTRY_RATE)/100)) AS MH_OUT                                                                                \n");
			queryStr.append("                  FROM OUT_REQUEST_HEADERS       RH                                                                                                                 \n");
			queryStr.append("                      ,OUT_REQUEST_DISTRIBUTIONS RD                                                                                                                 \n");
			queryStr.append("                      ,DPM_ACTIVITY              DA                                                                                                                 \n");
			queryStr.append("                 WHERE RH.REQUEST_NUM  = RD.REQUEST_NUM                                                                                                             \n");
			queryStr.append("                   AND RH.PROJECT_NO   = RD.PROJECT_NO                                                                                                              \n");
			queryStr.append("                   AND RD.PROJECT_NO   = DA.PROJECTNO                                                                                                               \n");
			queryStr.append("                   AND RD.DRAWING_NUM  = SUBSTR(DA.ACTIVITYCODE,1,8)                                                                                                \n");
			queryStr.append("                   AND DA.CASENO       = '1'                                                                                                                        \n");
			queryStr.append("                   AND DA.WORKTYPE     = 'DW'                                                                                                                       \n");
			queryStr.append("                   AND (DA.PLANMH IS NOT NULL OR DA.PLANMH > 0)                                                                                                     \n");
			queryStr.append("                   AND RD.CONFIRM_FLAG = 'Y'                                                                                                                        \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                  \n");
			queryStr.append("                 GROUP BY RD.PROJECT_NO,RH.REQUEST_DEPT , RD.DRAWING_NUM                                                                                            \n");
			queryStr.append("                 ) A,                                                                                                                                               \n");
			queryStr.append("                 (                                                                                                                                                  \n");
			queryStr.append("                 SELECT DM.PROJECT_NO                                                                                                                               \n");
			queryStr.append("                       ,DM.DEPT_CODE                                                                                                                                \n");
			queryStr.append("                       ,DM.DWG_CODE                                                                                                                                 \n");
			queryStr.append("                   FROM PLM_DESIGN_MH DM                                                                                                                            \n");
			queryStr.append("                  WHERE DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                     \n");
			queryStr.append("                    AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                       \n");
			queryStr.append("                    AND DM.DWG_CODE <> '*****'                                                                                                                      \n");
			queryStr.append("                  GROUP BY DM.PROJECT_NO,DM.DEPT_CODE, DM.DWG_CODE                                                                                                  \n");
			queryStr.append("                 ) B                                                                                                                                                \n");
			queryStr.append("           WHERE A.PROJECT_NO   = B.PROJECT_NO                                                                                                                      \n");
			queryStr.append("             AND A.REQUEST_DEPT = B.DEPT_CODE                                                                                                                       \n");
			queryStr.append("             AND A.DRAWING_NUM  = B.DWG_CODE                                                                                                                        \n");
			queryStr.append("           GROUP BY B.DEPT_CODE                                                                                                                                     \n");
			queryStr.append("          ) OP                                                                                                                                                      \n");
			queryStr.append("         ,DCC_DEPTCODE    DP                                                                                                                                        \n");
			queryStr.append("         ,DCC_DWGDEPTCODE DW                                                                                                                                        \n");
			queryStr.append("     WHERE OP.DEPT_CODE    = DP.DEPTCODE                                                                                                                            \n");
			queryStr.append("       AND DP.DWGDEPTCODE  = DW.DWGDEPTCODE                                                                                                                         \n");
			queryStr.append("       AND DW.DWGDEPTCODE LIKE '" + deptCodeList + "' || '%'                                                                                                                      \n");
			////queryStr.append("       AND CASE WHEN NVL('" + deptCodeList + "', ' ') = ' '    THEN ' ' ELSE DW.DWGDEPTCODE END LIKE NVL('" + deptCodeList + "', ' ') || '%'                        \n");
			queryStr.append("     UNION ALL                                                                                                                                                      \n");
			queryStr.append("    SELECT '2'                             AS ORDER_BY              --정렬순서                                                                                                    \n");
			queryStr.append("          ,DW.DWGDEPTNM                    AS DWGDEPTNM             --부서명                                                                                                      \n");
			queryStr.append("          ,SUM(OP.MH_A12)                  AS MH_A12                --제도                                                                                                        \n");
			queryStr.append("          ,SUM(OP.MH_A11)                  AS MH_A11                --계산                                                                                                        \n");
			queryStr.append("          ,SUM(OP.MH_A15)                  AS MH_A15                --도면출도                                                                                                    \n");
			queryStr.append("          ,SUM(OP.MH_A16)                  AS MH_A16                --V/D검토                                                                                                     \n");
			queryStr.append("          ,SUM(OP.MH_A19)                  AS MH_A19                --ECR/ECO처리                                                                                                \n");
			queryStr.append("          ,SUM(OP.MH_A14)                  AS MH_A14                --외주도면 F/UP                                                                                   \n");
			queryStr.append("          ,SUM(OP.MH_A2)                   AS MH_A2                 --도면개정                                                                                                   \n");
			queryStr.append("          ,SUM(OP.MH_IN)                   AS MH_IN                 --직영시수                                                                                                    \n");
			queryStr.append("          ,SUM(OP.MH_OUT)                  AS MH_OUT                --외주도면시수                                                                                               \n");
			queryStr.append("          ,SUM(OP.MH_IN) + SUM(OP.MH_OUT)  AS MH_DWG_SUM            --도면시수 소계                                                                                              \n");
			queryStr.append("          ,SUM(OP.MH_B1)                   AS MH_B1                 --설계준비                                                                                                   \n");
			queryStr.append("          ,SUM(OP.MH_B2)                   AS MH_B2                 --도면검토                                                                                                   \n");
			queryStr.append("          ,SUM(OP.MH_B3)                   AS MH_B3                 --PR/BOM                                                                                        \n");
			queryStr.append("          ,SUM(OP.MH_B4)                   AS MH_B4                 --협의 및 검토                                                                                                \n");
			queryStr.append("          ,SUM(OP.MH_B5)                   AS MH_B5                 --호선관리                                                                                                    \n");
			queryStr.append("          ,SUM(OP.MH_B6)                   AS MH_B6                 --기타                                                                                                        \n");
			queryStr.append("          ,SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6)                                                       \n");
			queryStr.append("                                           AS MH_DEDWG_SUM          --비도면시수 소계                                                                                             \n");
    		queryStr.append("          ,SUM(OP.MH_IN) + SUM(OP.MH_OUT) +                                                                                                                         \n");
			queryStr.append("           SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6)                                                       \n");
			queryStr.append("                                           AS MH_CON_TOT            --공사시수 합계                                                                                              \n");
			queryStr.append("          ,SUM(OP.MH_C1)                   AS MH_C1                 --보조업무지원                                                                                                \n");
			queryStr.append("          ,SUM(OP.MH_C2)                   AS MH_C2                 --생산성향상                                                                                                  \n");
			queryStr.append("          ,SUM(OP.MH_C3)                   AS MH_C3                 --기타                                                                                                        \n");
			queryStr.append("          ,SUM(OP.MH_C1)  + SUM(OP.MH_C2)  + SUM(OP.MH_C3)                                                                                                          \n");
			queryStr.append("                                           AS MH_DECON_SUM                                                                                                          \n");
			queryStr.append("          ,SUM(OP.MH_IN) + SUM(OP.MH_OUT) +                                                                                                                         \n");
			queryStr.append("           SUM(OP.MH_B1)  + SUM(OP.MH_B2)  + SUM(OP.MH_B3)  + SUM(OP.MH_B4)  + SUM(OP.MH_B5)  + SUM(OP.MH_B6) +                                                     \n");
			queryStr.append("           SUM(OP.MH_C1)  + SUM(OP.MH_C2)  + SUM(OP.MH_C3) AS MH_TAKE               --총소요시수                                                                               \n");
			queryStr.append("          ,SUM(OP.MH_D1)                   AS MH_D1                 --근태시수                                                                                                   \n");
			queryStr.append("    FROM (                                                                                                                                                          \n");
			queryStr.append("          SELECT DEPT_CODE                                                                                                                                          \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A12' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A12                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A11' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A11                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A15' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A15                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A16' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A16                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A19' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A19                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A14' THEN                                                                                                                     \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A14                                                                                                                                      \n");			
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'A2' THEN                                                                                                                   \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_A2                                                                                                                                      \n");			
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'A' THEN                                                                                                           \n");
			queryStr.append("                           CASE WHEN OP_CODE <> 'A13' THEN                                                                                                          \n");
			queryStr.append("                                     ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                       \n");
			queryStr.append("                           END                                                                                                                                      \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_IN                                                                                                                                       \n");
			queryStr.append("                ,0   AS MH_OUT                                                                                                                                      \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B1                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B2' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B2                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B3' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B3                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B4' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B4                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B5' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B5                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B6' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_B6                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C1                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C2' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C2                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'C3' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_C3                                                                                                                                       \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'D1' THEN                                                                                                          \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                                 \n");
			queryStr.append("                 ELSE 0                                                                                                                                             \n");
			queryStr.append("                 END AS MH_D1                                                                                                                                       \n");
			queryStr.append("            FROM                                                                                                                                                    \n");
			queryStr.append("                 (                                                                                                                                                  \n");
			queryStr.append("                 SELECT EMPLOYEE_NO                                                                                                                                 \n");
			queryStr.append("                       ,DEPT_CODE                                                                                                                                   \n");
			queryStr.append("                       ,OP_CODE                                                                                                                                     \n");
			queryStr.append("                       ,NORMAL_TIME * MH_FACTOR AS NORMAL_TIME                                                                                                      \n");
			queryStr.append("                       ,OVERTIME * MH_FACTOR AS OVERTIME                                                                                                            \n");
			queryStr.append("                       ,SPECIAL_TIME * MH_FACTOR AS SPECIAL_TIME                                                                                                    \n");
			queryStr.append("                   FROM (                                                                                                                                           \n");
			queryStr.append("                         SELECT EMPLOYEE_NO                                                                                                                         \n");
			queryStr.append("                               ,DEPT_CODE                                                                                                                           \n");
			queryStr.append("                               ,OP_CODE                                                                                                                             \n");
			queryStr.append("                               ,NORMAL_TIME                                                                                                                         \n");
			queryStr.append("                               ,OVERTIME                                                                                                                            \n");
			queryStr.append("                               ,SPECIAL_TIME                                                                                                                        \n");
			queryStr.append("                               ,CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                                                              \n");
			queryStr.append("                                ELSE (                                                                                                                              \n");
			queryStr.append("                                       SELECT FACTOR_VALUE                                                                                                          \n");
			queryStr.append("                                         FROM (                                                                                                                     \n");
			queryStr.append("                                               SELECT CAREER_MONTH_FROM,                                                                                            \n");
			queryStr.append("                                                      CAREER_MONTH_TO,                                                                                              \n");
			queryStr.append("                                                      FACTOR_VALUE                                                                                                  \n");
			queryStr.append("                                                 FROM PLM_DESIGN_MH_FACTOR                                                                                          \n");
			queryStr.append("                                                WHERE 1 = 1                                                                                                         \n");
			queryStr.append("                                                  AND CASE_NO = '" + factorCase + "'                                                                                \n");
			queryStr.append("                                              )                                                                                                                     \n");
			queryStr.append("                                        WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                                                                    \n");
			queryStr.append("                                          AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                                                           \n");
			queryStr.append("                                     )                                                                                                                              \n");
			queryStr.append("                                END AS MH_FACTOR                                                                                                                    \n");
			queryStr.append("                           FROM                                                                                                                                     \n");
			queryStr.append("                                (                                                                                                                                   \n");
			queryStr.append("                                 SELECT DM.EMPLOYEE_NO                                                                                                              \n");
			queryStr.append("                                       ,DM.DEPT_CODE                                                                                                                \n");
			queryStr.append("                                       ,DM.OP_CODE                                                                                                                  \n");
			queryStr.append("                                       ,SUM(DM.NORMAL_TIME)  AS NORMAL_TIME                                                                                         \n");
			queryStr.append("                                       ,SUM(DM.OVERTIME)     AS OVERTIME                                                                                            \n");
			queryStr.append("                                       ,SUM(DM.SPECIAL_TIME) AS SPECIAL_TIME                                                                                        \n");
			queryStr.append("                                      ,((TO_CHAR(DM.WORK_DAY, 'YYYY') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'YYYY'))* 12 +                                                \n");
			queryStr.append("                                        (TO_CHAR(DM.WORK_DAY, 'MM') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'MM'))) +                                                       \n");
			queryStr.append("                                       CASE WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                                                                   \n");
			queryStr.append("                                            WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                                                                    \n");
			queryStr.append("                                       END + NVL(ROUND(CS.BEFORE_ENTRANCE_CAREER * 12, 0), 0) AS CAREER_MONTHS                                                      \n");
			queryStr.append("                                  FROM PLM_DESIGN_MH  DM                                                                                                            \n");
			queryStr.append("                                      ,CCC_SAWON      CS                                                                                                            \n");
			queryStr.append("                                 WHERE DM.EMPLOYEE_NO = CS.EMPLOYEE_NUM                                                                                             \n");
			queryStr.append("                                   AND DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                      \n");
			queryStr.append("                                   AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                        \n");
			queryStr.append("                                 GROUP BY DM.EMPLOYEE_NO, DM.DEPT_CODE, DM.OP_CODE, DM.WORK_DAY, CS.DESIGN_APPLY_DATE, CS.BEFORE_ENTRANCE_CAREER                    \n");
			queryStr.append("                                )                                                                                                                                   \n");
			queryStr.append("                         )                                                                                                                                          \n");
			queryStr.append("                  )                                                                                                                                                 \n");
			queryStr.append("           GROUP BY DEPT_CODE, OP_CODE                                                                                                                              \n");
			queryStr.append("           UNION ALL                                                                                                                                                \n");
			queryStr.append("          SELECT B.DEPT_CODE                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A12                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A11                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A15                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A16                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A19                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A14                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_A2                                                                                                                                        \n");
			queryStr.append("                ,0 AS MH_IN                                                                                                                                         \n");
			queryStr.append("                ,ROUND(NVL(SUM(A.MH_OUT),0),1) AS MH_OUT                                                                                                              \n");
			queryStr.append("                ,0 AS MH_B1                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B2                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B3                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B4                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B5                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_B6                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_C1                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_C2                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_C3                                                                                                                                         \n");
			queryStr.append("                ,0 AS MH_D1                                                                                                                                         \n");
			queryStr.append("            FROM                                                                                                                                                    \n");
			queryStr.append("                (                                                                                                                                                   \n");
			queryStr.append("                SELECT RD.PROJECT_NO                                                                                                                                \n");
			queryStr.append("                      ,RH.REQUEST_DEPT                                                                                                                              \n");
			queryStr.append("                      ,RD.DRAWING_NUM                                                                                                                               \n");
			queryStr.append("                      ,(MAX(DA.PLANMH) * (SUM(RD.MANAGER_ENTRY_RATE)/100)) AS MH_OUT                                                                                \n");
			queryStr.append("                  FROM OUT_REQUEST_HEADERS       RH                                                                                                                 \n");
			queryStr.append("                      ,OUT_REQUEST_DISTRIBUTIONS RD                                                                                                                 \n");
			queryStr.append("                      ,DPM_ACTIVITY              DA                                                                                                                 \n");
			queryStr.append("                 WHERE RH.REQUEST_NUM  = RD.REQUEST_NUM                                                                                                             \n");
			queryStr.append("                   AND RH.PROJECT_NO   = RD.PROJECT_NO                                                                                                              \n");
			queryStr.append("                   AND RD.PROJECT_NO   = DA.PROJECTNO                                                                                                               \n");
			queryStr.append("                   AND RD.DRAWING_NUM  = SUBSTR(DA.ACTIVITYCODE,1,8)                                                                                                \n");
			queryStr.append("                   AND DA.CASENO       = '1'                                                                                                                        \n");
			queryStr.append("                   AND DA.WORKTYPE     = 'DW'                                                                                                                       \n");
			queryStr.append("                   AND (DA.PLANMH IS NOT NULL OR DA.PLANMH > 0)                                                                                                     \n");
			queryStr.append("                   AND RD.CONFIRM_FLAG = 'Y'                                                                                                                        \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                  \n");
			queryStr.append("                 GROUP BY RD.PROJECT_NO,RH.REQUEST_DEPT , RD.DRAWING_NUM                                                                                            \n");
			queryStr.append("                 ) A,                                                                                                                                               \n");
			queryStr.append("                 (                                                                                                                                                  \n");
			queryStr.append("                 SELECT DM.PROJECT_NO                                                                                                                               \n");
			queryStr.append("                       ,DM.DEPT_CODE                                                                                                                                \n");
			queryStr.append("                       ,DM.DWG_CODE                                                                                                                                 \n");
			queryStr.append("                   FROM PLM_DESIGN_MH DM                                                                                                                            \n");
			queryStr.append("                  WHERE DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                     \n");
			queryStr.append("                    AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                       \n");
			queryStr.append("                    AND DM.DWG_CODE <> '*****'                                                                                                                      \n");
			queryStr.append("                  GROUP BY DM.PROJECT_NO,DM.DEPT_CODE, DM.DWG_CODE                                                                                                  \n");
			queryStr.append("                 ) B                                                                                                                                                \n");
			queryStr.append("           WHERE A.PROJECT_NO   = B.PROJECT_NO                                                                                                                      \n");
			queryStr.append("             AND A.REQUEST_DEPT = B.DEPT_CODE                                                                                                                       \n");
			queryStr.append("             AND A.DRAWING_NUM  = B.DWG_CODE                                                                                                                        \n");
			queryStr.append("           GROUP BY B.DEPT_CODE                                                                                                                                     \n");
			queryStr.append("          ) OP                                                                                                                                                      \n");
			queryStr.append("         ,DCC_DEPTCODE    DP                                                                                                                                        \n");
			queryStr.append("         ,DCC_DWGDEPTCODE DW                                                                                                                                        \n");
			queryStr.append("     WHERE OP.DEPT_CODE    = DP.DEPTCODE                                                                                                                            \n");
			queryStr.append("       AND DP.DWGDEPTCODE  = DW.DWGDEPTCODE                                                                                                                         \n");
			queryStr.append("       AND DW.DWGDEPTCODE LIKE '" + deptCodeList + "' || '%'                                                                                                        \n");
			////queryStr.append("       AND CASE WHEN NVL('" + deptCodeList + "', ' ') = ' '    THEN ' ' ELSE DW.DWGDEPTCODE END LIKE NVL('" + deptCodeList + "', ' ') || '%'                        \n");
			queryStr.append("     GROUP BY DW.DWGDEPTNM                                                                                                                                          \n");
			queryStr.append("     ORDER BY ORDER_BY, DWGDEPTNM                                                                                                                                   \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("ORDER_BY", rset.getString("ORDER_BY") == null ? "" : rset.getString("ORDER_BY"));
				resultMap.put("DWGDEPTNM", rset.getString("DWGDEPTNM") == null ? "" : rset.getString("DWGDEPTNM"));
				resultMap.put("MH_A12", rset.getString("MH_A12") == null ? "" : rset.getString("MH_A12"));
				resultMap.put("MH_A11", rset.getString("MH_A11") == null ? "" : rset.getString("MH_A11"));
				resultMap.put("MH_A15", rset.getString("MH_A15") == null ? "" : rset.getString("MH_A15"));
				resultMap.put("MH_A16", rset.getString("MH_A16") == null ? "" : rset.getString("MH_A16"));
				resultMap.put("MH_A19", rset.getString("MH_A19") == null ? "" : rset.getString("MH_A19"));
				resultMap.put("MH_A14", rset.getString("MH_A14") == null ? "" : rset.getString("MH_A14"));
				resultMap.put("MH_A2", rset.getString("MH_A2") == null ? "" : rset.getString("MH_A2"));
				resultMap.put("MH_IN", rset.getString("MH_IN") == null ? "" : rset.getString("MH_IN"));
				resultMap.put("MH_OUT", rset.getString("MH_OUT") == null ? "" : rset.getString("MH_OUT"));
				resultMap.put("MH_DWG_SUM", rset.getString("MH_DWG_SUM") == null ? "" : rset.getString("MH_DWG_SUM"));
				resultMap.put("MH_B1", rset.getString("MH_B1") == null ? "" : rset.getString("MH_B1"));
				resultMap.put("MH_B2", rset.getString("MH_B2") == null ? "" : rset.getString("MH_B2"));
				resultMap.put("MH_B3", rset.getString("MH_B3") == null ? "" : rset.getString("MH_B3"));
				resultMap.put("MH_B4", rset.getString("MH_B4") == null ? "" : rset.getString("MH_B4"));
				resultMap.put("MH_B5", rset.getString("MH_B5") == null ? "" : rset.getString("MH_B5"));
				resultMap.put("MH_B6", rset.getString("MH_B6") == null ? "" : rset.getString("MH_B6"));
				resultMap.put("MH_DEDWG_SUM", rset.getString("MH_DEDWG_SUM") == null ? "" : rset.getString("MH_DEDWG_SUM"));
				resultMap.put("MH_CON_TOT", rset.getString("MH_CON_TOT") == null ? "" : rset.getString("MH_CON_TOT"));
				resultMap.put("MH_C1", rset.getString("MH_C1") == null ? "" : rset.getString("MH_C1"));
				resultMap.put("MH_C2", rset.getString("MH_C2") == null ? "" : rset.getString("MH_C2"));
				resultMap.put("MH_C3", rset.getString("MH_C3") == null ? "" : rset.getString("MH_C3"));
				resultMap.put("MH_DECON_SUM", rset.getString("MH_DECON_SUM") == null ? "" : rset.getString("MH_DECON_SUM"));
				resultMap.put("MH_TAKE", rset.getString("MH_TAKE") == null ? "" : rset.getString("MH_TAKE"));
				resultMap.put("MH_D1", rset.getString("MH_D1") == null ? "" : rset.getString("MH_D1"));

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
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
    //String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
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
            dpInputsList = getDesignMHSummaryByDepartment(dateFrom, dateTo, deptCode, factorCase);
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
    <title>부서 별 설계시수 조회</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
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
        <tr height="2"><td></td></tr>
        <tr height="20" style="font-weight:bold;color:#0000ff;">
            <td width="300px">기간 당연투입시수: <%=baseWorkTime%></td>
        </tr>
        <tr height="5"><td colspan="3"></td></tr>
    </table>
   
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold" rowspan="3">부서</td>
            <td class="td_standardBold" colspan="18">공사시수</td>
            <td class="td_standardBold" colspan="4">비공사시수</td>
            <td class="td_standardBold" rowspan="3">총소요<BR>시수</td>
            <td class="td_standardBold" rowspan="3">근태<BR>시수</td>
        </tr>
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold" colspan="10">도면시수</td>
            <td class="td_standardBold" colspan="7">비도면시수</td>
            <td class="td_standardBold" rowspan="2">합계</td>
            <td class="td_standardBold" rowspan="2">보조업무<BR>지원</td>
            <td class="td_standardBold" rowspan="2">생산성<BR>향상</td>
            <td class="td_standardBold" rowspan="2">기타</td>
            <td class="td_standardBold" rowspan="2">소계</td>
        </tr>        
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standard">제도</td>
            <td class="td_standard">계산</td>
            <td class="td_standard">도면출도</td>
            <td class="td_standard">V/D검토</td>
            <td class="td_standard">ECO/ECR처리</td>
            <td class="td_standard">외주도면F/up</td>
            <td class="td_standard">도면개정</td>
            <td class="td_standard">직영계</td>
            <td class="td_standard">외주도면시수</td>
            <td class="td_standard">소계</td>
            <td class="td_standard">설계준비</td>
            <td class="td_standard">도면검토</td>
            <td class="td_standard">PR/BOM</td>
            <td class="td_standard">협의및검토</td>
            <td class="td_standard">호선관리</td>
            <td class="td_standard">기타</td>
            <td class="td_standard">소계</td>
        </tr>

        <%

        DecimalFormat df = new DecimalFormat("###,###.##");
        
        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);

            String ORDER_BY = (String)map.get("ORDER_BY");
            String DWGDEPTNM = (String)map.get("DWGDEPTNM");
            String MH_A12 = (String)map.get("MH_A12");
            String MH_A11 = (String)map.get("MH_A11");
            String MH_A15 = (String)map.get("MH_A15");
            String MH_A16 = (String)map.get("MH_A16");
            String MH_A19 = (String)map.get("MH_A19");
            String MH_A14 = (String)map.get("MH_A14");
            String MH_A2 = (String)map.get("MH_A2");
            String MH_IN = (String)map.get("MH_IN");
            String MH_OUT = (String)map.get("MH_OUT");
            String MH_DWG_SUM = (String)map.get("MH_DWG_SUM");
            String MH_B1 = (String)map.get("MH_B1");
            String MH_B2 = (String)map.get("MH_B2");
            String MH_B3 = (String)map.get("MH_B3");
            String MH_B4 = (String)map.get("MH_B4");
            String MH_B5 = (String)map.get("MH_B5");
            String MH_B6 = (String)map.get("MH_B6");
            String MH_DEDWG_SUM = (String)map.get("MH_DEDWG_SUM");
            String MH_CON_TOT = (String)map.get("MH_CON_TOT");
            String MH_C1 = (String)map.get("MH_C1");
            String MH_C2 = (String)map.get("MH_C2");
            String MH_C3 = (String)map.get("MH_C3");
            String MH_DECON_SUM = (String)map.get("MH_DECON_SUM");
            String MH_TAKE = (String)map.get("MH_TAKE");
            String MH_D1 = (String)map.get("MH_D1");

            //String trBgColor = totalWTime >= totalWTimeTop20[19] ? "#ffffa0" : "#ffffff";
            String trBgColor = "#ffffff";
            String trProjectBgColor = "#ffffff";
            if(i==0)
            {
            	trBgColor = "#dddddd";   
            	trProjectBgColor = "#dddddd";
            } else {
            	trBgColor = "#ffffff";  
            	trProjectBgColor = "#ffffd0";
            }
            %>
                <tr height="20" bgcolor="<%= trBgColor %>">
                    <td class="td_standard" bgColor="<%= trProjectBgColor %>"><%=(String)map.get("DWGDEPTNM")%></td>
                    <td class="td_standardRight"><%=MH_A12%></td>
                    <td class="td_standardRight"><%=MH_A11%></td>
                    <td class="td_standardRight"><%=MH_A15%></td>
                    <td class="td_standardRight"><%=MH_A16%></td>
                    <td class="td_standardRight"><%=MH_A19%></td>
                    <td class="td_standardRight"><%=MH_A14%></td>
                    <td class="td_standardRight"><%=MH_A2%></td>
                    <td class="td_standardRight"><%=MH_IN%></td>
                    <td class="td_standardRight"><%=MH_OUT%></td>
                    <td class="td_standardRight"><%=MH_DWG_SUM%></td>
                    <td class="td_standardRight"><%=MH_B1%></td>
                    <td class="td_standardRight"><%=MH_B2%></td>
                    <td class="td_standardRight"><%=MH_B3%></td>
                    <td class="td_standardRight"><%=MH_B4%></td>
                    <td class="td_standardRight"><%=MH_B5%></td>
                    <td class="td_standardRight"><%=MH_B6%></td> 
                    <td class="td_standardRight"><%=MH_DEDWG_SUM%></td>
                    <td class="td_standardRight"><%=MH_CON_TOT%>
                    <td class="td_standardRight"><%=MH_C1%></td>
                    <td class="td_standardRight"><%=MH_C2%></td>
                    <td class="td_standardRight"><%=MH_C3%></td>
                    <td class="td_standardRight"><%=MH_DECON_SUM%></td>
                    <td class="td_standardRight"><%=MH_TAKE%></td>
                    <td class="td_standardRight"><%=MH_D1%></td>
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