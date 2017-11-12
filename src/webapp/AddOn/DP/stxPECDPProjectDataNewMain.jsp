<%--  
§DESCRIPTION: 호선 별 시수조회 화면 메인 부분 (New)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPProjectDataNewMain.jsp
§CHANGING HISTORY: 
§    2014-11-11: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ page import = "java.text.*" %> 

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// getDesignMHSummaryByProject(): 호선 별 설계시수 조회
	private ArrayList getDesignMHSummaryByProject(String dateFrom, String dateTo, String factorCase, String projectNO) 
	throws Exception
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
			
			
			queryStr.append("   SELECT '1'                       AS ORDER_BY              --정렬순서                                                                                         \n");          
			queryStr.append("          ,'TOTAL'                   AS PROJECT_NO            --호선                                                                                             \n");
			queryStr.append("          ,SUM(MH_IN)               AS MH_IN                 --직영시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_OUT)              AS MH_OUT                --외주시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) AS MH_DWG_SUM            --도면시수 소계                                                                                    \n");
			queryStr.append("          ,ROUND((SUM(MH_IN) + SUM(MH_OUT))/(SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) * 100)  AS MH_DWG_RATE           --도면시수 비율(%)                      \n");
			queryStr.append("          ,SUM(MH_DEDWG)            AS MH_DEDWG              --비도면시수                                                                                       \n");
			queryStr.append("          ,ROUND(SUM(MH_DEDWG)/(SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) * 100)               AS MH_DEDWG_RATE         --비도면시수 비율(%)                    \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)                                            AS MH_DWG_TOT            --도면시수 합계                         \n");        
			queryStr.append("          ,SUM(MH_A12)              AS MH_A12                --제도                                                                                             \n");
			queryStr.append("          ,SUM(MH_A11)              AS MH_A11                --계산                                                                                             \n");
			queryStr.append("          ,SUM(MH_A15)              AS MH_A15                --도면출도                                                                                         \n");
			queryStr.append("          ,SUM(MH_A16)              AS MH_A16                --V/D검토                                                                                          \n");
			queryStr.append("          ,SUM(MH_A19)              AS MH_A19                --ECR/ECO처리                                                                                      \n");
			queryStr.append("          ,SUM(MH_A14)              AS MH_A14                --외주도면F/UP                                                                                     \n");
			queryStr.append("          ,SUM(MH_A2)               AS MH_A2                 --도면개정                                                                                         \n");
			queryStr.append("          ,SUM(MH_IN)               AS MH_IN                 --직영계                                                                                           \n");
			queryStr.append("          ,SUM(MH_OUT)              AS MH_OUT                --외주도면시수                                                                                     \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) AS MH_CONDWG_TOT         --도면시수 소계                                                                                    \n");
			queryStr.append("          ,SUM(MH_B1)               AS MH_B1                 --설계준비                                                                                         \n");
			queryStr.append("          ,SUM(MH_B2)               AS MH_B2                 --도면검토                                                                                         \n");
			queryStr.append("          ,SUM(MH_B3)               AS MH_B3                 --PR/BOM                                                                                           \n");
			queryStr.append("          ,SUM(MH_B4)               AS MH_B4                 --협의및검토                                                                                       \n");
			queryStr.append("          ,SUM(MH_B5)               AS MH_B5                 --호선관리                                                                                         \n");
			queryStr.append("          ,SUM(MH_B6)               AS MH_B6                 --기타                                                                                             \n");
			queryStr.append("          ,SUM(MH_B1) + SUM(MH_B2)  + SUM(MH_B3) + SUM(MH_B4) + SUM(MH_B5) + SUM(MH_B6)        AS MH_CONDEDWG_TOT       --비도면시수 소계                       \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)                                            AS MH_CON_TOT            --공사시수 합계                         \n");
			queryStr.append("    FROM (                                                                                                                                                      \n");
			queryStr.append("          SELECT PROJECT_NO                                                                                                                                     \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'A' THEN                                                                                                       \n");
			queryStr.append("                           CASE WHEN OP_CODE <> 'A13' THEN                                                                                                      \n");
			queryStr.append("                                     ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                   \n");
			queryStr.append("                           END                                                                                                                                  \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_IN                                                                                                                                   \n");
			queryStr.append("                ,0   AS MH_OUT                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'B' THEN                                                                                                       \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_DEDWG                                                                                                                                \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A12' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A12                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A11' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A11                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A15' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A15                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A16' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A16                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A19' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A19                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A14' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A14                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'A2' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A2                                                                                                                                   \n");
			queryStr.append("                                                                                                                                                                \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B1' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B1                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B2' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B2                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B3' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B3                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B4' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B4                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B5' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B5                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B6' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B6                                                                                                                                   \n");
			queryStr.append("            FROM                                                                                                                                                \n");
			queryStr.append("                 (                                                                                                                                              \n");
			queryStr.append("                 SELECT EMPLOYEE_NO                                                                                                                             \n");
			queryStr.append("                       ,PROJECT_NO                                                                                                                              \n");
			queryStr.append("                       ,OP_CODE                                                                                                                                 \n");
			queryStr.append("                       ,NORMAL_TIME * MH_FACTOR AS NORMAL_TIME                                                                                                  \n");
			queryStr.append("                       ,OVERTIME * MH_FACTOR AS OVERTIME                                                                                                        \n");
			queryStr.append("                       ,SPECIAL_TIME * MH_FACTOR AS SPECIAL_TIME                                                                                                \n");
			queryStr.append("                   FROM (                                                                                                                                       \n");
			queryStr.append("                         SELECT EMPLOYEE_NO                                                                                                                     \n");
			queryStr.append("                               ,PROJECT_NO                                                                                                                      \n");
			queryStr.append("                               ,OP_CODE                                                                                                                         \n");
			queryStr.append("                               ,NORMAL_TIME                                                                                                                     \n");
			queryStr.append("                               ,OVERTIME                                                                                                                        \n");
			queryStr.append("                               ,SPECIAL_TIME                                                                                                                    \n");
			queryStr.append("                               ,CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                                                          \n");
			queryStr.append("                                ELSE (                                                                                                                          \n");
			queryStr.append("                                       SELECT FACTOR_VALUE                                                                                                      \n");
			queryStr.append("                                         FROM (                                                                                                                 \n");
			queryStr.append("                                               SELECT CAREER_MONTH_FROM,                                                                                        \n");
			queryStr.append("                                                      CAREER_MONTH_TO,                                                                                          \n");
			queryStr.append("                                                      FACTOR_VALUE                                                                                              \n");
			queryStr.append("                                                 FROM PLM_DESIGN_MH_FACTOR                                                                                      \n");
			queryStr.append("                                                WHERE 1 = 1                                                                                                     \n");
			queryStr.append("                                                  AND CASE_NO = '" + factorCase + "'                                                                            \n");
			queryStr.append("                                              )                                                                                                                 \n");
			queryStr.append("                                        WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                                                                \n");
			queryStr.append("                                          AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                                                       \n");
			queryStr.append("                                     )                                                                                                                          \n");
			queryStr.append("                                END AS MH_FACTOR                                                                                                                \n");
			queryStr.append("                           FROM                                                                                                                                 \n");
			queryStr.append("                                (                                                                                                                               \n");
			queryStr.append("                                 SELECT DM.EMPLOYEE_NO                                                                                                          \n");
			queryStr.append("                                       ,DM.PROJECT_NO                                                                                                           \n");
			queryStr.append("                                       ,DM.OP_CODE                                                                                                              \n");
			queryStr.append("                                       ,SUM(DM.NORMAL_TIME)  AS NORMAL_TIME                                                                                     \n");
			queryStr.append("                                       ,SUM(DM.OVERTIME)     AS OVERTIME                                                                                        \n");
			queryStr.append("                                       ,SUM(DM.SPECIAL_TIME) AS SPECIAL_TIME                                                                                    \n");
			queryStr.append("                                      ,((TO_CHAR(DM.WORK_DAY, 'YYYY') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'YYYY'))* 12 +                                            \n");
			queryStr.append("                                        (TO_CHAR(DM.WORK_DAY, 'MM') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'MM'))) +                                                   \n");
			queryStr.append("                                       CASE WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                                                               \n");
			queryStr.append("                                            WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                                                                \n");
			queryStr.append("                                       END + NVL(ROUND(CS.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                                                                   \n");
			queryStr.append("                                                                          AS CAREER_MONTHS                                                                      \n");
			queryStr.append("                                  FROM PLM_DESIGN_MH  DM                                                                                                        \n");
			queryStr.append("                                      ,CCC_SAWON      CS                                                                                                        \n");
			queryStr.append("                                 WHERE DM.EMPLOYEE_NO = CS.EMPLOYEE_NUM                                                                                         \n");
			queryStr.append("                                   AND DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                  \n");
			queryStr.append("                                   AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                    \n");
			queryStr.append("                                   AND DM.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                   \n");
			/////queryStr.append("                                   AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE DM.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'  \n");
			queryStr.append("                                 GROUP BY DM.EMPLOYEE_NO, DM.PROJECT_NO, DM.OP_CODE, DM.WORK_DAY,CS.DESIGN_APPLY_DATE, CS.BEFORE_ENTRANCE_CAREER                \n");
			queryStr.append("                                )                                                                                                                               \n");
			queryStr.append("                         )                                                                                                                                      \n");
			queryStr.append("                  )                                                                                                                                             \n");
			queryStr.append("           GROUP BY PROJECT_NO,OP_CODE                                                                                                                          \n");
			queryStr.append("           UNION ALL                                                                                                                                            \n");
			queryStr.append("          SELECT A.PROJECT_NO                                                                                                                                   \n");
			queryStr.append("                ,0 AS MH_IN                                                                                                                                     \n");
			queryStr.append("                ,ROUND(NVL(SUM(A.MH_OUT),0),1) AS MH_OUT                                                                                                          \n");
			queryStr.append("                ,0 AS MH_DEDWG                                                                                                                                  \n");
			queryStr.append("                ,0 AS MH_A12                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A11                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A15                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A16                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A19                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A14                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A2                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B1                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B2                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B3                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B4                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B5                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B6                                                                                                                                     \n");
			queryStr.append("            FROM                                                                                                                                                \n");
			queryStr.append("                (                                                                                                                                               \n");
			queryStr.append("                SELECT RD.PROJECT_NO                                                                                                                            \n");
			queryStr.append("                      ,RD.DRAWING_NUM                                                                                                                           \n");
			queryStr.append("                      ,(MAX(DA.PLANMH) * (SUM(RD.MANAGER_ENTRY_RATE)/100)) AS MH_OUT                                                                            \n");
			queryStr.append("                  FROM OUT_REQUEST_DISTRIBUTIONS RD                                                                                                             \n");
			queryStr.append("                      ,DPM_ACTIVITY              DA                                                                                                             \n");
			queryStr.append("                 WHERE RD.PROJECT_NO   = DA.PROJECTNO                                                                                                           \n");
			queryStr.append("                   AND RD.DRAWING_NUM  = SUBSTR(DA.ACTIVITYCODE,1,8)                                                                                            \n");
			queryStr.append("                   AND DA.CASENO       = '1'                                                                                                                    \n");
			queryStr.append("                   AND DA.WORKTYPE     = 'DW'                                                                                                                   \n");
			queryStr.append("                   AND RD.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                                                                \n");
			/////queryStr.append("                   AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE RD.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'                           \n");
			queryStr.append("                   AND (DA.PLANMH IS NOT NULL OR DA.PLANMH > 0)                                                                                                 \n");
			queryStr.append("                   AND RD.CONFIRM_FLAG = 'Y'                                                                                                                    \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                 \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                   \n");
			queryStr.append("                 GROUP BY RD.PROJECT_NO, RD.DRAWING_NUM                                                                                                         \n");
			queryStr.append("                 ) A,                                                                                                                                           \n");
			queryStr.append("                 (                                                                                                                                              \n");
			queryStr.append("                 SELECT DM.PROJECT_NO                                                                                                                           \n");
			queryStr.append("                       ,DM.DWG_CODE                                                                                                                             \n");
			queryStr.append("                   FROM PLM_DESIGN_MH DM                                                                                                                        \n");
			queryStr.append("                  WHERE DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                      \n");
			queryStr.append("                    AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                        \n");
			queryStr.append("                    AND DM.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                                        \n");
			/////queryStr.append("                    AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE DM.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'                          \n");
			queryStr.append("                    AND DM.DWG_CODE <> '*****'                                                                                                                  \n");
			queryStr.append("                  GROUP BY DM.PROJECT_NO, DM.DWG_CODE                                                                                                           \n");
			queryStr.append("                 ) B                                                                                                                                            \n");
			queryStr.append("           WHERE A.PROJECT_NO  = B.PROJECT_NO                                                                                                                   \n");
			queryStr.append("             AND A.DRAWING_NUM = B.DWG_CODE                                                                                                                     \n");
			queryStr.append("           GROUP BY A.PROJECT_NO                                                                                                                                \n");
			queryStr.append("          )                                                                                                                                                     \n");
			queryStr.append("     UNION ALL                                                                                                                                                  \n");
			queryStr.append("    SELECT '2'                      AS ORDER_BY              --정렬순서                                                                                         \n");
			queryStr.append("          ,PROJECT_NO               AS PROJECT_NO            --호선                                                                                             \n");
			queryStr.append("          ,SUM(MH_IN)               AS MH_IN                 --직영시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_OUT)              AS MH_OUT                --외주시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) AS MH_DWG_SUM            --도면시수 소계                                                                                    \n");
			queryStr.append("          ,CASE WHEN (SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) > 0 THEN                                                                                        \n");
			queryStr.append("                     ROUND((SUM(MH_IN) + SUM(MH_OUT))/(SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) * 100)                                                         \n");
			queryStr.append("           ELSE 0 END               AS MH_DWG_RATE           --도면시수 비율(%)                                                                                 \n");
			queryStr.append("          ,SUM(MH_DEDWG)            AS MH_DEDWG              --비도면시수                                                                                       \n");
			queryStr.append("          ,CASE WHEN (SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) > 0 THEN                                                                                        \n");
			queryStr.append("                     ROUND(SUM(MH_DEDWG)/(SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)) * 100)                                                                      \n");
			queryStr.append("           ELSE 0 END               AS MH_DEDWG_RATE         --비도면시수 비율(%)                                                                               \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)      AS MH_DWG_TOT            --도면시수 합계                                                               \n");
			queryStr.append("          ,SUM(MH_A12)              AS MH_A12                --제도                                                                                             \n");
			queryStr.append("          ,SUM(MH_A11)              AS MH_A11                --계산                                                                                             \n");
			queryStr.append("          ,SUM(MH_A15)              AS MH_A15                --도면출도                                                                                         \n");
			queryStr.append("          ,SUM(MH_A16)              AS MH_A16                --V/D검토                                                                                          \n");
			queryStr.append("          ,SUM(MH_A19)              AS MH_A19                --ECR/ECO처리                                                                                      \n");
			queryStr.append("          ,SUM(MH_A14)              AS MH_A14                --외주도면F/UP                                                                                     \n");
			queryStr.append("          ,SUM(MH_A2)               AS MH_A2                 --도면개정                                                                                         \n");
			queryStr.append("          ,SUM(MH_IN)               AS MH_IN                 --직영시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_OUT)              AS MH_OUT                --외주시수                                                                                         \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) AS MH_CONDWG_TOT         --도면시수 소계                                                                                    \n");
			queryStr.append("          ,SUM(MH_B1)               AS MH_B1                 --설계준비                                                                                         \n");
			queryStr.append("          ,SUM(MH_B2)               AS MH_B2                 --도면검토                                                                                         \n");
			queryStr.append("          ,SUM(MH_B3)               AS MH_B3                 --PR/BOM                                                                                           \n");
			queryStr.append("          ,SUM(MH_B4)               AS MH_B4                 --협의및검토                                                                                       \n");
			queryStr.append("          ,SUM(MH_B5)               AS MH_B5                 --호선관리                                                                                         \n");
			queryStr.append("          ,SUM(MH_B6)               AS MH_B6                 --기타                                                                                             \n");
			queryStr.append("          ,SUM(MH_B1) + SUM(MH_B2)  + SUM(MH_B3) + SUM(MH_B4) + SUM(MH_B5) + SUM(MH_B6)   AS MH_CONDEDWG_TOT       --비도면시수 소계                            \n");
			queryStr.append("          ,SUM(MH_IN) + SUM(MH_OUT) + SUM(MH_DEDWG)                                       AS MH_CON_TOT            --공사시수 합계                              \n");
			queryStr.append("    FROM (                                                                                                                                                      \n");
			queryStr.append("          SELECT PROJECT_NO                                                                                                                                     \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'A' THEN                                                                                                       \n");
			queryStr.append("                           CASE WHEN OP_CODE <> 'A13' THEN                                                                                                      \n");
			queryStr.append("                                     ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                   \n");
			queryStr.append("                           END                                                                                                                                  \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_IN                                                                                                                                   \n");
			queryStr.append("                ,0   AS MH_OUT                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,1) = 'B' THEN                                                                                                       \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_DEDWG                                                                                                                                \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A12' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A12                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A11' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A11                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A15' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A15                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A16' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A16                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A19' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A19                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN OP_CODE = 'A14' THEN                                                                                                                 \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A14                                                                                                                                  \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'A2' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_A2                                                                                                                                   \n");
			queryStr.append("                                                                                                                                                                \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B1' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B1                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B2' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B2                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B3' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B3                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B4' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B4                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B5' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B5                                                                                                                                   \n");
			queryStr.append("                ,CASE WHEN SUBSTR(OP_CODE,1,2) = 'B6' THEN                                                                                                      \n");
			queryStr.append("                           ROUND(NVL(SUM(NORMAL_TIME + OVERTIME + SPECIAL_TIME),0),1)                                                                             \n");
			queryStr.append("                 ELSE 0                                                                                                                                         \n");
			queryStr.append("                 END AS MH_B6                                                                                                                                   \n");
			queryStr.append("            FROM                                                                                                                                                \n");
			queryStr.append("                 (                                                                                                                                              \n");
			queryStr.append("                 SELECT EMPLOYEE_NO                                                                                                                             \n");
			queryStr.append("                       ,PROJECT_NO                                                                                                                              \n");
			queryStr.append("                       ,OP_CODE                                                                                                                                 \n");
			queryStr.append("                       ,NORMAL_TIME * MH_FACTOR AS NORMAL_TIME                                                                                                  \n");
			queryStr.append("                       ,OVERTIME * MH_FACTOR AS OVERTIME                                                                                                        \n");
			queryStr.append("                       ,SPECIAL_TIME * MH_FACTOR AS SPECIAL_TIME                                                                                                \n");
			queryStr.append("                   FROM (                                                                                                                                       \n");
			queryStr.append("                         SELECT EMPLOYEE_NO                                                                                                                     \n");
			queryStr.append("                               ,PROJECT_NO                                                                                                                      \n");
			queryStr.append("                               ,OP_CODE                                                                                                                         \n");
			queryStr.append("                               ,NORMAL_TIME                                                                                                                     \n");
			queryStr.append("                               ,OVERTIME                                                                                                                        \n");
			queryStr.append("                               ,SPECIAL_TIME                                                                                                                    \n");
			queryStr.append("                               ,CASE WHEN CAREER_MONTHS IS NULL THEN 1                                                                                          \n");
			queryStr.append("                                ELSE (                                                                                                                          \n");
			queryStr.append("                                       SELECT FACTOR_VALUE                                                                                                      \n");
			queryStr.append("                                         FROM (                                                                                                                 \n");
			queryStr.append("                                               SELECT CAREER_MONTH_FROM,                                                                                        \n");
			queryStr.append("                                                      CAREER_MONTH_TO,                                                                                          \n");
			queryStr.append("                                                      FACTOR_VALUE                                                                                              \n");
			queryStr.append("                                                 FROM PLM_DESIGN_MH_FACTOR                                                                                      \n");
			queryStr.append("                                                WHERE 1 = 1                                                                                                     \n");
			queryStr.append("                                                  AND CASE_NO = '" + factorCase + "'                                                                            \n");
			queryStr.append("                                              )                                                                                                                 \n");
			queryStr.append("                                        WHERE CAREER_MONTH_FROM <= CAREER_MONTHS                                                                                \n");
			queryStr.append("                                          AND NVL(CAREER_MONTH_TO, 9999) >= CAREER_MONTHS                                                                       \n");
			queryStr.append("                                     )                                                                                                                          \n");
			queryStr.append("                                END AS MH_FACTOR                                                                                                                \n");
			queryStr.append("                           FROM                                                                                                                                 \n");
			queryStr.append("                                (                                                                                                                               \n");
			queryStr.append("                                 SELECT DM.EMPLOYEE_NO                                                                                                          \n");
			queryStr.append("                                       ,DM.PROJECT_NO                                                                                                           \n");
			queryStr.append("                                       ,DM.OP_CODE                                                                                                              \n");
			queryStr.append("                                       ,SUM(DM.NORMAL_TIME)  AS NORMAL_TIME                                                                                     \n");
			queryStr.append("                                       ,SUM(DM.OVERTIME)     AS OVERTIME                                                                                        \n");
			queryStr.append("                                       ,SUM(DM.SPECIAL_TIME) AS SPECIAL_TIME                                                                                    \n");
			queryStr.append("                                      ,((TO_CHAR(DM.WORK_DAY, 'YYYY') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'YYYY'))* 12 +                                            \n");
			queryStr.append("                                        (TO_CHAR(DM.WORK_DAY, 'MM') - TO_CHAR(CS.DESIGN_APPLY_DATE, 'MM'))) +                                                   \n");
			queryStr.append("                                       CASE WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') <= 15 THEN 1                                                               \n");
			queryStr.append("                                            WHEN TO_CHAR(CS.DESIGN_APPLY_DATE, 'DD') > 15 THEN 0                                                                \n");
			queryStr.append("                                       END + NVL(ROUND(CS.BEFORE_ENTRANCE_CAREER * 12, 0), 0)                                                                   \n");
			queryStr.append("                                                                          AS CAREER_MONTHS                                                                      \n");
			queryStr.append("                                  FROM PLM_DESIGN_MH  DM                                                                                                        \n");
			queryStr.append("                                      ,CCC_SAWON      CS                                                                                                        \n");
			queryStr.append("                                 WHERE DM.EMPLOYEE_NO = CS.EMPLOYEE_NUM                                                                                         \n");
			queryStr.append("                                   AND DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                  \n");
			queryStr.append("                                   AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                    \n");
			queryStr.append("                                   AND DM.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                     \n");
			////queryStr.append("                                   AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE DM.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'           \n");
			queryStr.append("                                 GROUP BY DM.EMPLOYEE_NO, DM.PROJECT_NO, DM.OP_CODE, DM.WORK_DAY,CS.DESIGN_APPLY_DATE, CS.BEFORE_ENTRANCE_CAREER                \n");
			queryStr.append("                                )                                                                                                                               \n");
			queryStr.append("                         )                                                                                                                                      \n");
			queryStr.append("                  )                                                                                                                                             \n");
			queryStr.append("           GROUP BY PROJECT_NO,OP_CODE                                                                                                                          \n");
			queryStr.append("           UNION ALL                                                                                                                                            \n");
			queryStr.append("          SELECT A.PROJECT_NO                                                                                                                                   \n");
			queryStr.append("                ,0 AS MH_IN                                                                                                                                     \n");
			queryStr.append("                ,ROUND(NVL(SUM(A.MH_OUT),0),1) AS MH_OUT                                                                                                          \n");
			queryStr.append("                ,0 AS MH_DEDWG                                                                                                                                  \n");
			queryStr.append("                ,0 AS MH_A12                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A11                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A15                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A16                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A19                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A14                                                                                                                                    \n");
			queryStr.append("                ,0 AS MH_A2                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B1                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B2                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B3                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B4                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B5                                                                                                                                     \n");
			queryStr.append("                ,0 AS MH_B6                                                                                                                                     \n");
			queryStr.append("            FROM                                                                                                                                                \n");
			queryStr.append("                (                                                                                                                                               \n");
			queryStr.append("                SELECT RD.PROJECT_NO                                                                                                                            \n");
			queryStr.append("                      ,RD.DRAWING_NUM                                                                                                                           \n");
			queryStr.append("                      ,(MAX(DA.PLANMH) * (SUM(RD.MANAGER_ENTRY_RATE)/100)) AS MH_OUT                                                                            \n");
			queryStr.append("                  FROM OUT_REQUEST_DISTRIBUTIONS RD                                                                                                             \n");
			queryStr.append("                      ,DPM_ACTIVITY              DA                                                                                                             \n");
			queryStr.append("                 WHERE RD.PROJECT_NO   = DA.PROJECTNO                                                                                                           \n");
			queryStr.append("                   AND RD.DRAWING_NUM  = SUBSTR(DA.ACTIVITYCODE,1,8)                                                                                            \n");
			queryStr.append("                   AND DA.CASENO       = '1'                                                                                                                    \n");
			queryStr.append("                   AND DA.WORKTYPE     = 'DW'                                                                                                                   \n");
			queryStr.append("                   AND RD.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                                     \n");
			/////queryStr.append("                   AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE RD.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'                           \n");
			queryStr.append("                   AND (DA.PLANMH IS NOT NULL OR DA.PLANMH > 0)                                                                                                 \n");
			queryStr.append("                   AND RD.CONFIRM_FLAG = 'Y'                                                                                                                    \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                 \n");
			queryStr.append("                   AND RD.CONFIRM_DATE   <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                   \n");
			queryStr.append("                 GROUP BY RD.PROJECT_NO, RD.DRAWING_NUM                                                                                                         \n");
			queryStr.append("                 ) A,                                                                                                                                           \n");
			queryStr.append("                (                                                                                                                                               \n");
			queryStr.append("                SELECT DM.PROJECT_NO                                                                                                                            \n");
			queryStr.append("                      ,DM.DWG_CODE                                                                                                                              \n");
			queryStr.append("                  FROM PLM_DESIGN_MH DM                                                                                                                         \n");
			queryStr.append("                 WHERE DM.WORK_DAY >= TO_DATE('" + dateFrom + "','YYYY-MM-DD')                                                                                       \n");
			queryStr.append("                   AND DM.WORK_DAY <= TO_DATE('" + dateTo + "','YYYY-MM-DD')                                                                                         \n");
			queryStr.append("                   AND DM.PROJECT_NO LIKE '%' || '" + projectNO + "' || '%'                                                                                         \n");
			/////queryStr.append("                   AND CASE WHEN NVL('" + projectNO + "', ' ') = ' ' THEN ' ' ELSE DM.PROJECT_NO END LIKE '%' || NVL('" + projectNO + "', ' ') || '%'                           \n");
			queryStr.append("                   AND DM.DWG_CODE <> '*****'                                                                                                                   \n");
			queryStr.append("                 GROUP BY DM.PROJECT_NO, DM.DWG_CODE                                                                                                            \n");
			queryStr.append("                 ) B                                                                                                                                            \n");
			queryStr.append("           WHERE A.PROJECT_NO  = B.PROJECT_NO                                                                                                                   \n");
			queryStr.append("             AND A.DRAWING_NUM = B.DWG_CODE                                                                                                                     \n");
			queryStr.append("           GROUP BY A.PROJECT_NO                                                                                                                                \n");
			queryStr.append("          )                                                                                                                                                     \n");
			queryStr.append("     GROUP BY PROJECT_NO                                                                                                                                        \n");
			queryStr.append("     ORDER BY ORDER_BY, PROJECT_NO                                                                                                                             \n");
			
			
		System.out.println("newProjectData Query = "+queryStr);


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());
			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("ORDER_BY", rset.getString("ORDER_BY") == null ? "" : rset.getString("ORDER_BY"));
				resultMap.put("PROJECT_NO", rset.getString("PROJECT_NO") == null ? "" : rset.getString("PROJECT_NO"));
				resultMap.put("MH_IN", rset.getString("MH_IN") == null ? "" : rset.getString("MH_IN"));
				resultMap.put("MH_OUT", rset.getString("MH_OUT") == null ? "" : rset.getString("MH_OUT"));
				resultMap.put("MH_DWG_SUM", rset.getString("MH_DWG_SUM") == null ? "" : rset.getString("MH_DWG_SUM"));
				resultMap.put("MH_DWG_RATE", rset.getString("MH_DWG_RATE") == null ? "" : rset.getString("MH_DWG_RATE"));
				resultMap.put("MH_DEDWG", rset.getString("MH_DEDWG") == null ? "" : rset.getString("MH_DEDWG"));
				resultMap.put("MH_DEDWG_RATE", rset.getString("MH_DEDWG_RATE") == null ? "" : rset.getString("MH_DEDWG_RATE"));
				resultMap.put("MH_DWG_TOT", rset.getString("MH_DWG_TOT") == null ? "" : rset.getString("MH_DWG_TOT"));
				resultMap.put("MH_A12", rset.getString("MH_A12") == null ? "" : rset.getString("MH_A12"));
				resultMap.put("MH_A11", rset.getString("MH_A11") == null ? "" : rset.getString("MH_A11"));
				resultMap.put("MH_A15", rset.getString("MH_A15") == null ? "" : rset.getString("MH_A15"));
				resultMap.put("MH_A16", rset.getString("MH_A16") == null ? "" : rset.getString("MH_A16"));
				resultMap.put("MH_A19", rset.getString("MH_A19") == null ? "" : rset.getString("MH_A19"));
				resultMap.put("MH_A14", rset.getString("MH_A14") == null ? "" : rset.getString("MH_A14"));
				resultMap.put("MH_A2", rset.getString("MH_A2") == null ? "" : rset.getString("MH_A2"));
				resultMap.put("MH_CONDWG_TOT", rset.getString("MH_CONDWG_TOT") == null ? "" : rset.getString("MH_CONDWG_TOT"));
				resultMap.put("MH_B1", rset.getString("MH_B1") == null ? "" : rset.getString("MH_B1"));
				resultMap.put("MH_B2", rset.getString("MH_B2") == null ? "" : rset.getString("MH_B2"));
				resultMap.put("MH_B3", rset.getString("MH_B3") == null ? "" : rset.getString("MH_B3"));
				resultMap.put("MH_B4", rset.getString("MH_B4") == null ? "" : rset.getString("MH_B4"));
				resultMap.put("MH_B5", rset.getString("MH_B5") == null ? "" : rset.getString("MH_B5"));
				resultMap.put("MH_B6", rset.getString("MH_B6") == null ? "" : rset.getString("MH_B6"));
				resultMap.put("MH_CONDEDWG_TOT", rset.getString("MH_CONDEDWG_TOT") == null ? "" : rset.getString("MH_CONDEDWG_TOT"));
				resultMap.put("MH_CON_TOT", rset.getString("MH_CON_TOT") == null ? "" : rset.getString("MH_CON_TOT"));

				resultArrayList.add(resultMap);
			}
			System.out.println("resultArrayList = "+resultArrayList.toString());			
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

   // String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String factorCase = StringUtil.setEmptyExt(emxGetParameter(request, "factorCase"));
    //String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String firstCall = StringUtil.setEmptyExt(emxGetParameter(request, "firstCall"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));
    String projectNO = StringUtil.setEmptyExt(emxGetParameter(request, "projectNO"));
    System.out.println("dateFrom = "+dateFrom);
    System.out.println("dateTo = "+dateTo);
    System.out.println("factorCase = "+factorCase);
    System.out.println("projectNO = "+projectNO);

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
            dpInputsList = getDesignMHSummaryByProject(dateFrom, dateTo, factorCase, projectNO);
        }
    }
    catch (Exception e) {
    	e.printStackTrace();
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
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>
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
            <td class="td_standardBold" rowspan="3">호선</td>
            <td class="td_standardBold" colspan="7">TOTAL</td>
            <td class="td_standardBold" colspan="18">공사시수</td>
        </tr>
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standardBold" colspan="4">도면시수</td>
            <td class="td_standardBold" colspan="2">비도면시수</td>
            <td class="td_standardBold" rowspan="2">합계</td>
            <td class="td_standardBold" colspan="10">도면시수</td>
            <td class="td_standardBold" colspan="7">비도면시수</td>
            <td class="td_standardBold" rowspan="2">합계</td>
        </tr>        
        <tr height="20" bgcolor="#e5e5e5">
            <td class="td_standard">직영</td>
            <td class="td_standard">외주</td>
            <td class="td_standard">계</td>
            <td class="td_standard">%</td>
            <td class="td_standard">시수</td>
            <td class="td_standard">%</td>
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
            String PROJECT_NO = (String)map.get("PROJECT_NO");
            String MH_IN = (String)map.get("MH_IN");
            String MH_OUT = (String)map.get("MH_OUT");
            String MH_DWG_SUM = (String)map.get("MH_DWG_SUM");
            String MH_DWG_RATE = (String)map.get("MH_DWG_RATE");
            String MH_DEDWG = (String)map.get("MH_DEDWG");
            String MH_DEDWG_RATE = (String)map.get("MH_DEDWG_RATE");
            String MH_DWG_TOT = (String)map.get("MH_DWG_TOT");
            String MH_A12 = (String)map.get("MH_A12");
            String MH_A11 = (String)map.get("MH_A11");
            String MH_A15 = (String)map.get("MH_A15");
            String MH_A16 = (String)map.get("MH_A16");
            String MH_A19 = (String)map.get("MH_A19");
            String MH_A14 = (String)map.get("MH_A14");
            String MH_A2 = (String)map.get("MH_A2");
            String MH_CONDWG_TOT = (String)map.get("MH_CONDWG_TOT");
            String MH_B1 = (String)map.get("MH_B1");
            String MH_B2 = (String)map.get("MH_B2");
            String MH_B3 = (String)map.get("MH_B3");
            String MH_B4 = (String)map.get("MH_B4");
            String MH_B5 = (String)map.get("MH_B5");
            String MH_B6 = (String)map.get("MH_B6");
            String MH_CONDEDWG_TOT = (String)map.get("MH_CONDEDWG_TOT");
            String MH_CON_TOT = (String)map.get("MH_CON_TOT");

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
                    <td class="td_standard" bgColor="<%= trProjectBgColor %>"><%=(String)map.get("PROJECT_NO")%></td>
                    <td class="td_standardRight"><%=MH_IN%></td>
                    <td class="td_standardRight"><%=MH_OUT%></td>
                    <td class="td_standardRight"><%=MH_DWG_SUM%></td>
                    <td class="td_standardRight"><%=MH_DWG_RATE%></td>
                    <td class="td_standardRight"><%=MH_DEDWG%></td>
                    <td class="td_standardRight"><%=MH_DEDWG_RATE%></td>
                    <td class="td_standardRight"><%=MH_DWG_TOT%></td>
                    <td class="td_standardRight"><%=MH_A12%></td>
                    <td class="td_standardRight"><%=MH_A11%></td>
                    <td class="td_standardRight"><%=MH_A15%></td>
                    <td class="td_standardRight"><%=MH_A16%></td>
                    <td class="td_standardRight"><%=MH_A19%></td>
                    <td class="td_standardRight"><%=MH_A14%></td>
                    <td class="td_standardRight"><%=MH_A2%></td>
                    <td class="td_standardRight"><%=MH_IN%></td> 
                    <td class="td_standardRight"><%=MH_OUT%></td>
                    <td class="td_standardRight"><%=MH_CONDWG_TOT%>
                    <td class="td_standardRight"><%=MH_B1%></td>
                    <td class="td_standardRight"><%=MH_B2%></td>
                    <td class="td_standardRight"><%=MH_B3%></td>
                    <td class="td_standardRight"><%=MH_B4%></td>
                    <td class="td_standardRight"><%=MH_B5%></td>
                    <td class="td_standardRight"><%=MH_B6%></td>
                    <td class="td_standardRight"><%=MH_CONDEDWG_TOT%></td>
                    <td class="td_standardRight"><%=MH_CON_TOT%></td>
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