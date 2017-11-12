<%--  
§DESCRIPTION: 공정 조회/입력 화면 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-13: Initiative
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

	// getDesignProgressList() : 공정조회
	private ArrayList getDesignProgressList(String projectNo, String deptCode, String designerID, String dateFrom, String dateTo, 
	                                      String dateCondition, String[] drawingNoArray, String drawingTitle) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");

		deptCode = StringUtil.setEmptyExt(deptCode);
		designerID = StringUtil.setEmptyExt(designerID);
		dateFrom = StringUtil.setEmptyExt(dateFrom);
		dateTo = StringUtil.setEmptyExt(dateTo);
		dateCondition = StringUtil.setEmptyExt(dateCondition);

		String drawingNo = "";
		boolean hasDrawingNo = false;
		for (int i = 0; i < drawingNoArray.length; i++) {
			if (!"".equals(drawingNoArray[i])) {
				drawingNo +=  drawingNoArray[i];
				hasDrawingNo = true;
			}
			else drawingNo +=  "_";
		}

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPSP");
			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT DW.PROJECTNO,                                                                                       ");
			queryStr.append("       DW.SABUN,                                                                                           ");
			queryStr.append("       DEPT.DWGDEPTNM AS DEPTNAME,                                                                         ");
			queryStr.append("       DEPT.DWGDEPTCODE AS DEPTCODE,                                                                       ");
			queryStr.append("       SUBSTR(DW.ACTIVITYCODE, 1, 8) AS DWGCODE,                                                           ");
			queryStr.append("       DW.OUTSOURCINGYN,                                                                                   ");
			queryStr.append("       DW.OUTSOURCING1,                                                                                    ");
			queryStr.append("       DW.OUTSOURCING2,                                                                                    ");
			queryStr.append("       DW.DWGTITLE,                                                                                        ");
			queryStr.append("       TO_CHAR(DW.PLANSTARTDATE, 'YYYY-MM-DD') AS DW_PLAN_S,                                               ");
			queryStr.append("       TO_CHAR(DW.PLANFINISHDATE, 'YYYY-MM-DD') AS DW_PLAN_F,                                              ");
			queryStr.append("       TO_CHAR(DW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS DW_ACT_S,                                              ");
			queryStr.append("       TO_CHAR(DW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS DW_ACT_F,                                             ");
			queryStr.append("       TO_CHAR(OW.PLANSTARTDATE, 'YYYY-MM-DD') AS OW_PLAN_S,                                               ");
			queryStr.append("       TO_CHAR(OW.PLANFINISHDATE, 'YYYY-MM-DD') AS OW_PLAN_F,                                              ");
			queryStr.append("       TO_CHAR(OW.ACTUALSTARTDATE, 'YYYY-MM-DD') AS OW_ACT_S,                                              ");
			queryStr.append("       TO_CHAR(OW.ACTUALFINISHDATE, 'YYYY-MM-DD') AS OW_ACT_F,                                             ");
			queryStr.append("       TO_CHAR(CL.PLANSTARTDATE, 'YYYY-MM-DD') AS CL_PLAN_S,                                               ");
			queryStr.append("       TO_CHAR(CL.PLANFINISHDATE, 'YYYY-MM-DD') AS CL_PLAN_F,                                              ");
			queryStr.append("       TO_CHAR(CL.ACTUALSTARTDATE, 'YYYY-MM-DD') AS CL_ACT_S,                                              ");
			queryStr.append("       TO_CHAR(CL.ACTUALFINISHDATE, 'YYYY-MM-DD') AS CL_ACT_F,                                             ");
			queryStr.append("       TO_CHAR(RF.PLANSTARTDATE, 'YYYY-MM-DD') AS RF_PLAN_S,                                               ");
			queryStr.append("       TO_CHAR(RF.ACTUALSTARTDATE, 'YYYY-MM-DD') AS RF_ACT_S,                                              ");
			queryStr.append("       TO_CHAR(WK.PLANSTARTDATE, 'YYYY-MM-DD') AS WK_PLAN_S,                                               ");
			queryStr.append("       TO_CHAR(WK.ACTUALSTARTDATE, 'YYYY-MM-DD') AS WK_ACT_S,                                              ");
			queryStr.append("       DW.DWGZONE,                                                                                         ");
			queryStr.append("       DW.ACTUALSTDMH_OUT,                                                                                 ");
			queryStr.append("       DW.ACTUALFOLLOWMH_OUT,                                                                              ");
			queryStr.append("       DW.ACTUALSTDMH,                                                                                     ");
			queryStr.append("       DW.ACTUALFOLLOWMH,                                                                                  ");
			queryStr.append("       DW.PLANSTDMH,                                                                                       ");
			queryStr.append("       DW.PLANFOLLOWMH,                                                                                    ");
			queryStr.append("       (NVL(DW.ACTUALSTDMH, 0) + NVL(DW.ACTUALSTDMH_OUT, 0)) AS STD_TOTAL,                                 ");
			queryStr.append("       (NVL(DW.ACTUALFOLLOWMH, 0) + NVL(DW.ACTUALFOLLOWMH_OUT, 0)) AS FOLLOWUP_TOTAL,                      ");
			
            // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
            //queryStr.append("       (SELECT SAWON.NAME FROM CCC_SAWON SAWON WHERE SAWON.EMPLOYEE_NUM = DW.SABUN) AS NAME,               ");
			queryStr.append("       CASE WHEN (SELECT SAWON.NAME FROM CCC_SAWON SAWON WHERE SAWON.EMPLOYEE_NUM = DW.SABUN) IS NULL      ");
			queryStr.append("                  THEN (SELECT A.SAWON_NAME FROM Z_DALIAN_SAWON_TO111231 A WHERE A.SAWON_ID = DW.SABUN)    ");
			queryStr.append("            ELSE (SELECT SAWON.NAME FROM CCC_SAWON SAWON WHERE SAWON.EMPLOYEE_NUM = DW.SABUN)              ");
			queryStr.append("       END AS NAME,                                                                                        ");

            queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(DW.PLANSTARTDATE)), 1, 'Y', 'N') AS DW_PLAN_S_O,                 ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(DW.PLANFINISHDATE)), 1, 'Y', 'N') AS DW_PLAN_F_O,                ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(OW.PLANSTARTDATE)), 1, 'Y', 'N') AS OW_PLAN_S_O,                 ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(OW.PLANFINISHDATE)), 1, 'Y', 'N') AS OW_PLAN_F_O,                ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(CL.PLANSTARTDATE)), 1, 'Y', 'N') AS CL_PLAN_S_O,                 ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(CL.PLANFINISHDATE)), 1, 'Y', 'N') AS CL_PLAN_F_O,                ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(RF.PLANSTARTDATE)), 1, 'Y', 'N') AS RF_PLAN_S_O,                 ");
			queryStr.append("       DECODE(SIGN(TRUNC(SYSDATE) - TRUNC(WK.PLANSTARTDATE)), 1, 'Y', 'N') AS WK_PLAN_S_O,                 ");
            //queryStr.append("       HC.MAX_REVISION,                                                                                    "); 
			//queryStr.append("       TO_CHAR((CASE WHEN (HC.MAX_REVISION IS NULL) THEN NULL                                              ");
			//queryStr.append("               ELSE (SELECT HC2.REQUEST_DATE                                                               ");
			//queryStr.append("                       FROM PLM_HARDCOPY_DWG HC2                                                           ");
			//queryStr.append("                      WHERE HC2.PROJECT_NO = DW.PROJECTNO                                                  ");
			//queryStr.append("                        AND HC2.DWG_CODE = SUBSTR(DW.ACTIVITYCODE, 1, 8)                                   ");
			//queryStr.append("                        AND HC2.DEPLOY_REV = HC.MAX_REVISION)                                              ");
			//queryStr.append("                END), 'YYYY-MM-DD')                                                                        ");
			//queryStr.append("       AS DEPLOY_DATE,                                                                                     ");
			//queryStr.append("       CASE WHEN (HC.DEPLOY_DATE IS NULL) THEN NULL                                                        ");
			//queryStr.append("            ELSE (SELECT HC2.DEPLOY_REV                                                                    ");
			//queryStr.append("                    FROM PLM_HARDCOPY_DWG HC2                                                              ");
			//queryStr.append("                   WHERE HC2.PROJECT_NO = DW.PROJECTNO                                                     ");
			//queryStr.append("                     AND HC2.DWG_CODE = SUBSTR(DW.ACTIVITYCODE, 1, 8)                                      ");
			//queryStr.append("                     AND HC2.REQUEST_DATE = HC.DEPLOY_DATE                                                  ");
			//queryStr.append("                 )                                                                                         ");
			//queryStr.append("       END AS MAX_REVISION,                                                                                ");
            //queryStr.append("       HC.DEPLOY_REV AS MAX_REVISION,                                                                      ");
			queryStr.append("       CASE WHEN (HC.DEPLOY_DATE IS NULL) THEN NULL                                                        ");
			queryStr.append("            ELSE (F_GET_HARDCOPY_MAX_REV(DW.PROJECTNO, SUBSTR(DW.ACTIVITYCODE, 1, 8), HC.DEPLOY_DATE))     ");
			queryStr.append("       END AS MAX_REVISION,                                                                                ");
			queryStr.append("       TO_CHAR(HC.DEPLOY_DATE, 'YYYY-MM-DD') AS DEPLOY_DATE,                                               ");
            queryStr.append("       (                                                                                                   ");
			queryStr.append("       SELECT A.DWG_REV AS DWG_REV                                                                         ");
			queryStr.append("         FROM STX_DWG_DPS_REV_SELECT_V@STXERP A                                                            ");
			queryStr.append("        WHERE A.MASTER_PROJECT_NO = DW.PROJECTNO                                                           ");
			queryStr.append("          AND A.DWG_NO_CONCAT = SUBSTR(DW.ACTIVITYCODE, 1, 5)                                              ");
			queryStr.append("          AND A.DWG_BLOCK = SUBSTR(DW.ACTIVITYCODE, 6, 3)                                                  ");
			queryStr.append("       ) AS DTS_RESULT,                                                                                    ");
			queryStr.append("       F_GET_APS_ACTIVITY_CODE(WK.DWGCATEGORY, WK.REFEVENT2, DW.PROJECTNO) AS ACTIVITY_DESC,               ");
			queryStr.append("       DW.ATTRIBUTE4,                                                                                      ");
			queryStr.append("       DW.ATTRIBUTE5,                                                                                      ");
			queryStr.append("       OW.ATTRIBUTE4,                                                                                      ");
			queryStr.append("       OW.ATTRIBUTE5,                                                                                      ");
			queryStr.append("       CL.ATTRIBUTE4,                                                                                      ");
			queryStr.append("       CL.ATTRIBUTE5,                                                                                      ");
			queryStr.append("       RF.ATTRIBUTE4,                                                                                      ");
			queryStr.append("       RF.ATTRIBUTE5,                                                                                      ");
			queryStr.append("       WK.ATTRIBUTE4,                                                                                      ");
			queryStr.append("       WK.ATTRIBUTE5                                                                                       ");
			queryStr.append("  FROM PLM_ACTIVITY DW,                                                                                    ");
			queryStr.append("       DCC_DWGDEPTCODE DEPT,                                                                               ");
			queryStr.append("       (SELECT A.PROJECTNO, A.ACTIVITYCODE, A.PLANSTARTDATE, A.PLANFINISHDATE,                             ");
			queryStr.append("               A.ACTUALSTARTDATE, A.ACTUALFINISHDATE, A.DWGCATEGORY, A.ATTRIBUTE4, A.ATTRIBUTE5            ");
			queryStr.append("          FROM PLM_ACTIVITY A                                                                              ");
			queryStr.append("         WHERE A.WORKTYPE = 'OW'                                                                           ");
			queryStr.append("       ) OW,                                                                                               ");
			queryStr.append("       (SELECT B.PROJECTNO, B.ACTIVITYCODE, B.PLANSTARTDATE, B.PLANFINISHDATE,                             ");
			queryStr.append("               B.ACTUALSTARTDATE, B.ACTUALFINISHDATE, B.DWGCATEGORY, B.ATTRIBUTE4, B.ATTRIBUTE5            ");
			queryStr.append("          FROM PLM_ACTIVITY B                                                                              ");
			queryStr.append("         WHERE B.WORKTYPE = 'CL'                                                                           ");
			queryStr.append("       ) CL,                                                                                               ");
			queryStr.append("       (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.PLANFINISHDATE,                             ");
			queryStr.append("               C.ACTUALSTARTDATE, C.ACTUALFINISHDATE, C.DWGCATEGORY, C.ATTRIBUTE4, C.ATTRIBUTE5            ");
			queryStr.append("          FROM PLM_ACTIVITY C                                                                              ");
			queryStr.append("         WHERE C.WORKTYPE = 'RF'                                                                           ");
			queryStr.append("       ) RF,                                                                                               ");
			queryStr.append("       (SELECT D.PROJECTNO, D.ACTIVITYCODE, D.PLANSTARTDATE, D.PLANFINISHDATE,                             ");
			queryStr.append("               D.ACTUALSTARTDATE, D.ACTUALFINISHDATE, D.DWGCATEGORY, D.REFEVENT2,D.ATTRIBUTE4,D.ATTRIBUTE5 ");
			queryStr.append("          FROM PLM_ACTIVITY D                                                                              ");
			queryStr.append("         WHERE D.WORKTYPE = 'WK'                                                                           ");
			queryStr.append("       ) WK,                                                                                               ");
			//queryStr.append("       (SELECT PROJECT_NO, DWG_CODE, MIN(REVISION) AS MAX_REVISION                                         "); 
			//queryStr.append("          FROM (                                                                                           ");
			//queryStr.append("                SELECT PROJECT_NO, DWG_CODE, REQUEST_DATE, MAX(DEPLOY_REV) AS REVISION                     ");
			//queryStr.append("                  FROM PLM_HARDCOPY_DWG                                                                    ");
			//queryStr.append("                 WHERE DEPLOY_REV BETWEEN 'A' AND 'ZZZZ'                                                   ");
			////queryStr.append("                   AND DEPLOY_DATE IS NOT NULL                                                             ");
			//queryStr.append("                 GROUP BY PROJECT_NO, DWG_CODE, REQUEST_DATE                                               ");
			//queryStr.append("                UNION ALL                                                                                  ");
			//queryStr.append("                SELECT PROJECT_NO, DWG_CODE, REQUEST_DATE, MAX(DEPLOY_REV) AS REVISION                     ");
			//queryStr.append("                  FROM PLM_HARDCOPY_DWG                                                                    ");
			//queryStr.append("                 WHERE DEPLOY_REV BETWEEN '0' AND '9999'                                                   ");
			////queryStr.append("                   AND DEPLOY_DATE IS NOT NULL                                                             ");
			//queryStr.append("                 GROUP BY PROJECT_NO, DWG_CODE, REQUEST_DATE                                               ");
			//queryStr.append("               )                                                                                           ");
			//queryStr.append("         GROUP BY PROJECT_NO, DWG_CODE                                                                     ");
			//queryStr.append("       ) HC,                                                                                               ");
            queryStr.append("       (                                                                                                   ");
            queryStr.append("       SELECT PROJECT_NO, DWG_CODE, MAX(REQUEST_DATE) AS DEPLOY_DATE                                       ");
            queryStr.append("         FROM PLM_HARDCOPY_DWG                                                                             ");
            //queryStr.append("        WHERE DEPLOY_DATE IS NOT NULL                                                                      ");
            queryStr.append("        GROUP BY PROJECT_NO, DWG_CODE                                                                      ");
            queryStr.append("       ) HC,                                                                                               ");
            queryStr.append("       (SELECT STATE FROM PLM_SEARCHABLE_PROJECT                                                           ");
			queryStr.append("         WHERE CATEGORY = 'PROGRESS' AND PROJECTNO = '" + projectNo + "'                                   ");
			queryStr.append("       ) PP                                                                                                ");
			queryStr.append(" WHERE DW.PROJECTNO = '" + projectNo + "'                                                                  ");
			queryStr.append("   AND DW.PROJECTNO = OW.PROJECTNO(+)                                                                      ");
			queryStr.append("   AND DW.PROJECTNO = CL.PROJECTNO(+)                                                                      ");
			queryStr.append("   AND DW.PROJECTNO = RF.PROJECTNO(+)                                                                      ");
			queryStr.append("   AND DW.PROJECTNO = WK.PROJECTNO(+)                                                                      ");
			queryStr.append("   AND DW.DWGDEPTCODE = DEPT.DWGDEPTCODE(+)                                                                ");
			queryStr.append("   AND DW.WORKTYPE = 'DW'                                                                                  ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(OW.ACTIVITYCODE(+), 1, 8)                                    ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(CL.ACTIVITYCODE(+), 1, 8)                                    ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(RF.ACTIVITYCODE(+), 1, 8)                                    ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = SUBSTR(WK.ACTIVITYCODE(+), 1, 8)                                    ");
			if (!deptCode.equals(""))
				queryStr.append("   AND DW.DWGDEPTCODE = (SELECT E.DWGDEPTCODE FROM DCC_DEPTCODE E WHERE E.DEPTCODE='" + deptCode + "') ");
			if (!designerID.equals(""))
				queryStr.append("   AND DW.SABUN = '" + designerID + "'                                                                 ");
			if (!drawingTitle.equals(""))
				queryStr.append("   AND DW.DWGTITLE LIKE '%" + drawingTitle + "%'                                                       ");
			
			if (!dateCondition.equals("")) {
				String dateColumn = "";
				if (dateCondition.equals("DW_S")) dateColumn = "DW.PLANSTARTDATE";
				else if (dateCondition.equals("DW_F")) dateColumn = "DW.PLANFINISHDATE";
				else if (dateCondition.equals("OW_S")) dateColumn = "OW.PLANSTARTDATE";
				else if (dateCondition.equals("OW_F")) dateColumn = "OW.PLANFINISHDATE";
				else if (dateCondition.equals("CL_S")) dateColumn = "CL.PLANSTARTDATE";
				else if (dateCondition.equals("CL_F")) dateColumn = "CL.PLANFINISHDATE";
				else if (dateCondition.equals("RF")) dateColumn = "RF.PLANSTARTDATE";
				else if (dateCondition.equals("WK")) dateColumn = "WK.PLANSTARTDATE";

				if (!dateFrom.equals(""))
					queryStr.append("   AND " + dateColumn + " >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                             ");
				if (!dateTo.equals(""))
					queryStr.append("   AND " + dateColumn + " <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                               ");
			}
			
			if (hasDrawingNo)
				queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) like '" + drawingNo + "'                                          ");

			queryStr.append("   AND (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE DW.DWGCATEGORY END) =                                     ");
			queryStr.append("       (CASE WHEN PP.STATE = 'ALL' THEN ' ' ELSE PP.STATE END)                                             ");
			queryStr.append("   AND DW.PROJECTNO = HC.PROJECT_NO(+)                                                                     ");
			queryStr.append("   AND SUBSTR(DW.ACTIVITYCODE, 1, 8) = HC.DWG_CODE(+)                                                      ");

			queryStr.append(" ORDER BY DW.DWGDEPTCODE, DW.ACTIVITYCODE                                                                ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECTNO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("SABUN", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("DEPTNAME", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("DEPTCODE", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("DWGCODE", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("OUTSOURCINGYN", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("OUTSOURCING1", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OUTSOURCING2", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("DWGTITLE", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("DW_PLAN_S", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("DW_PLAN_F", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("DW_ACT_S", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("DW_ACT_F", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("OW_PLAN_S", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("OW_PLAN_F", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("OW_ACT_S", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("OW_ACT_F", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("CL_PLAN_S", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("CL_PLAN_F", rset.getString(19) == null ? "" : rset.getString(19));
				resultMap.put("CL_ACT_S", rset.getString(20) == null ? "" : rset.getString(20));
				resultMap.put("CL_ACT_F", rset.getString(21) == null ? "" : rset.getString(21));
				resultMap.put("RF_PLAN_S", rset.getString(22) == null ? "" : rset.getString(22));
				resultMap.put("RF_ACT_S", rset.getString(23) == null ? "" : rset.getString(23));
				resultMap.put("WK_PLAN_S", rset.getString(24) == null ? "" : rset.getString(24));
				resultMap.put("WK_ACT_S", rset.getString(25) == null ? "" : rset.getString(25));
				resultMap.put("DWGZONE", rset.getString(26) == null ? "" : rset.getString(26));
				resultMap.put("OUT_STD", rset.getString(27) == null ? "" : rset.getString(27));
				resultMap.put("OUT_FOLLOWUP", rset.getString(28) == null ? "" : rset.getString(28));
				resultMap.put("INTERNAL_STD", rset.getString(29) == null ? "" : rset.getString(29));
				resultMap.put("INTERNAL_FOLLOWUP", rset.getString(30) == null ? "" : rset.getString(30));
				resultMap.put("PLAN_STD", rset.getString(31) == null ? "" : rset.getString(31));
				resultMap.put("PLAN_FOLLOWUP", rset.getString(32) == null ? "" : rset.getString(32));
				resultMap.put("STD_TOTAL", rset.getString(33) == null ? "" : rset.getString(33));
				resultMap.put("FOLLOWUP_TOTAL", rset.getString(34) == null ? "" : rset.getString(34));
				resultMap.put("NAME", rset.getString(35) == null ? "" : rset.getString(35));
				resultMap.put("DW_PLAN_S_O", rset.getString(36));
				resultMap.put("DW_PLAN_F_O", rset.getString(37));
				resultMap.put("OW_PLAN_S_O", rset.getString(38));
				resultMap.put("OW_PLAN_F_O", rset.getString(39));
				resultMap.put("CL_PLAN_S_O", rset.getString(40));
				resultMap.put("CL_PLAN_F_O", rset.getString(41));
				resultMap.put("RF_PLAN_S_O", rset.getString(42));
				resultMap.put("WK_PLAN_S_O", rset.getString(43));
				resultMap.put("MAX_REV", rset.getString(44) == null ? "" : rset.getString(44));
				resultMap.put("DEPLOY_DATE", rset.getString(45) == null ? "" : rset.getString(45));
				resultMap.put("DTS_RESULT", rset.getString(46) == null ? "" : rset.getString(46));
				resultMap.put("ACTIVITY_DESC", rset.getString(47) == null ? "" : rset.getString(47));
                resultMap.put("DW_ATTRIBUTE4", rset.getString(48) == null ? "" : rset.getString(48));
                resultMap.put("DW_ATTRIBUTE5", rset.getString(49) == null ? "" : rset.getString(49));
                resultMap.put("OW_ATTRIBUTE4", rset.getString(50) == null ? "" : rset.getString(50));
                resultMap.put("OW_ATTRIBUTE5", rset.getString(51) == null ? "" : rset.getString(51));
                resultMap.put("CL_ATTRIBUTE4", rset.getString(52) == null ? "" : rset.getString(52));
                resultMap.put("CL_ATTRIBUTE5", rset.getString(53) == null ? "" : rset.getString(53));
                resultMap.put("RF_ATTRIBUTE4", rset.getString(54) == null ? "" : rset.getString(54));
                resultMap.put("RF_ATTRIBUTE5", rset.getString(55) == null ? "" : rset.getString(55));
                resultMap.put("WK_ATTRIBUTE4", rset.getString(56) == null ? "" : rset.getString(56));
                resultMap.put("WK_ATTRIBUTE5", rset.getString(57) == null ? "" : rset.getString(57));
                resultArrayList.add(resultMap);
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		} finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

    // isNumeric 
    private boolean isNumeric(String text)  
    {
        if (text == null || text.trim().length() == 0) return false;
        
        for (int i = 0; i < text.length(); i++) {
            if (!Character.isDigit(text.charAt(i))) return false;
        }
        return  true;
    }

    // isAlphabet
    private boolean isAlphabet(String text)  
    {
        if (text == null || text.trim().length() == 0) return false;
        
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122)) { ; /* skip */ } 
            else { return false; }
        }
        return true;
    }        

%>

<%--========================== JSP =========================================--%>
<%
    request.setCharacterEncoding("euc-kr"); 

    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String dateCondition = StringUtil.setEmptyExt(emxGetParameter(request, "dateCondition"));
    String drawingNo1 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo1"));
    String drawingNo2 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo2"));
    String drawingNo3 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo3"));
    String drawingNo4 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo4"));
    String drawingNo5 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo5"));
    String drawingNo6 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo6"));
    String drawingNo7 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo7"));
    String drawingNo8 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo8"));
    //String drawingNo9 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo9"));
    //String drawingNo10 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo10"));
    String drawingTitle = StringUtil.setEmptyExt(emxGetParameter(request, "drawingTitle"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));
    String isManager = StringUtil.setEmptyExt(emxGetParameter(request, "isManager"));
    String isAdmin = StringUtil.setEmptyExt(emxGetParameter(request, "isAdmin"));
    String userDept = StringUtil.setEmptyExt(emxGetParameter(request, "userDept"));

    //20101224 kuni start - Table Data Sort
    String sortValue = StringUtil.setEmptyExt(emxGetParameter(request, "sortValue"));
    String sortType = StringUtil.setEmptyExt(emxGetParameter(request, "sortType"));
    String sortImage = "";
    //20101224 kuni end
    
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

    ArrayList designProgressList = null;
    ArrayList partPersonsList = null;
    Map keyEventMap = null;
    String lockDate = "";
    try {
        if (!projectNo.equals("")) {
            String[] drawingNoArray = {drawingNo1, drawingNo2, drawingNo3, drawingNo4, drawingNo5, drawingNo6, drawingNo7, drawingNo8};
            designProgressList = getDesignProgressList(projectNo, deptCode, designerID, dateFrom, dateTo, dateCondition, drawingNoArray, drawingTitle);
            
            //20101224 kuni start - Table Data Sort
            if(sortType==null || "".equals(sortType) || "descending".equals(sortType)){
            	sortType = "ascending";
            	sortImage = "<img src=\"../common/images/utilSortArrowUp.gif\" align=\"absmiddle\" border=\"0\" />";
            }else if("ascending".equals(sortType)){
            	sortType = "descending";
            	sortImage = "<img src=\"../common/images/utilSortArrowDown.gif\" align=\"absmiddle\" border=\"0\" />";
            }
            /*** DIS-ERROR :
            if(sortValue!=null && !"".equals(sortValue))
	            designProgressList.sort(sortValue , sortType , "String");
	        ***/
			//20101224 kuni end

            keyEventMap = getKeyEventDates(projectNo);
            if (!userDept.equals("")) lockDate = getDPProgressLockDate(userDept);
        }
        if (/*(isManager.equals("Y") || isAdmin.equals("Y")) &&*/ !deptCode.equals("")) {
            // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
            if (deptCode.startsWith("Z")) partPersonsList = getPartPersons_Dalian(deptCode); 
            else partPersonsList = getPartPersonsForDPProgress(deptCode);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    String c1Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c1"));
    String c2Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c2"));
    String c3Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c3"));
    String c4Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c4"));
    String c5Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c5"));
    String c6Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c6"));
    String c7Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c7"));
    String c8Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c8"));
    String c9Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c9"));
    String c10Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c10"));
    String c11Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c11"));
    String c12Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c12"));
    String c13Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c13"));
    String c14Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c14"));
    String c15Checked = StringUtil.setEmptyExt(emxGetParameter(request, "c15"));

    String c1Display = c1Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c2Display = c2Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c3Display = c3Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c4Display = c4Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c5Display = c5Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c6Display = c6Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c7Display = c7Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c8Display = c8Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c9Display = c9Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c10Display = c10Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c11Display = c11Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c12Display = c12Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c13Display = c13Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c14Display = c14Checked.equalsIgnoreCase("True") ? "none" : "block";
    String c15Display = c15Checked.equalsIgnoreCase("True") ? "none" : "block";

    // 자기부서 도면이 아닌 타부서 도면의 실적일자도 입력할 수 있는 예외적인 호선(들)의 목록.
    // * 기본은 자기부서 도면만 실적입력이 가능함.
    // * 현재 이 기준에 해당하는 호선이 F1003 하나만 있고 향후 추가로 발생할 가능성이 낮으므로
    // * Hard-Code로 처리함. F1003 호선 D/L 후 이 코드를 삭제할 필요가 있음.
    // * F1003 호선은 도면작업은 대련에서, 도면검도는 한국(창원)에서 하기 때문에 이런 예외가 발생함.
    String allDepartEditableProjects = "F1003";
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
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
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="../common/scripts/emxUIModal.js"></script>

<script language="javascript">

    <% if(keyEventMap != null)
    { 
        %>
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.keyeventCT.value = '<%=(String)keyEventMap.get("CT")%>';
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.keyeventSC.value = '<%=(String)keyEventMap.get("SC")%>';
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.keyeventKL.value = '<%=(String)keyEventMap.get("KL")%>';
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.keyeventLC.value = '<%=(String)keyEventMap.get("LC")%>';
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.keyeventDL.value = '<%=(String)keyEventMap.get("DL")%>';
        <%
    } 
    %>

</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff" oncontextmenu="return false;" ondragstart="return false;" onselectstart="return false;">
<form name="DPProgressViewMain">

<%
if (!errStr.equals("")) 
{
%>
    <table width="100%" cellSpacing="1" cellpadding="4" border="0">
        <tr>
            <td class="td_standard" style="text-align:left;color:#ff0000;">
                작업 중에 에러가 발생하였습니다. IT 담당자에게 문의하시기 바랍니다.<br>
                ※에러 메시지: <%=errStr%>                
            </td>
        </tr>
    </table>
<%
}
else
{
%>

<!-- 데이터 ------------------------------------------------------------------->
<table id="data_table" border="0" cellpadding="0" cellspacing="0" width="1270" bgcolor="#ffffff" align="left">
    
    <tr valign="top">
        <td id="td_header_left" align="left">
            <div id="header_left" STYLE="width:670; overflow:hidden; position:absolute; left:1; top:10;">
                <table id="table_header1" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;" align="left">
                    <tr height="58" bgcolor="#e5e5e5">
                        <td id="td_header_no" 				rowspan="3" width="24" 	class="td_standardSmall" nowrap>No</td>
                        <td id="td_header_project" 			rowspan="3" width="50" 	class="td_standardSmall" nowrap style="display:<%=c1Display%>;cursor:hand;" onclick="viewDPProgress('PROJECTNO','<%="PROJECTNO".equals(sortValue)?sortType:""%>')">Project<%="PROJECTNO".equals(sortValue)?sortImage:""%> </td>
                        <td id="td_header_part" 			rowspan="3" width="90" 	class="td_standardSmall" nowrap style="display:<%=c2Display%>;cursor:hand;" onclick="viewDPProgress('DEPTNAME','<%="DEPTNAME".equals(sortValue)?sortType:""%>')">Part<%="DEPTNAME".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_drawingno" 		rowspan="3" width="70" 	class="td_standardSmall" nowrap style="display:<%=c3Display%>;cursor:hand;" onclick="viewDPProgress('DWGCODE','<%="DWGCODE".equals(sortValue)?sortType:""%>')">DrawingNo<%="DWGCODE".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_zone" 			rowspan="3" width="40" 	class="td_standardSmall" nowrap style="display:<%=c4Display%>;cursor:hand;" onclick="viewDPProgress('DWGZONE','<%="DWGZONE".equals(sortValue)?sortType:""%>')">Zone<%="DWGZONE".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_outsourcingplan" 	colspan="3" width="81" 	class="td_standardSmall" nowrap style="display:<%=c5Display%>;cursor:hand;">Outsourcing<br>Plan</td>
                        <td id="td_header_task" 			rowspan="3" width="256" class="td_standardSmall" nowrap style="display:<%=c6Display%>;cursor:hand;" onclick="viewDPProgress('DWGTITLE','<%="DWGTITLE".equals(sortValue)?sortType:""%>')">Task(Drawing Title)<%="DWGTITLE".equals(sortValue)?sortImage:""%></td>
                        <td id="td_header_user" 			rowspan="3" width="50" 	class="td_standardSmall" nowrap style="display:<%=c7Display%>;cursor:hand;" onclick="viewDPProgress('NAME','<%="NAME".equals(sortValue)?sortType:""%>')">담당자<%="NAME".equals(sortValue)?sortImage:""%></td>
                    </tr>
                </table>
            </div>
        </td>

        <td id="td_header_right" width="580" align="left">
            <div id="header_right" STYLE="width:583; overflow:hidden; position:absolute; left:671; top:10;">
                <table id="table_header2" border="0" cellpadding="1" cellspacing="1" bgcolor="#cccccc">
                    <tr height="20" bgcolor="#e5e5e5">
                        <td rowspan="3" class="td_standardSmall" width="40" nowrap style="cursor:hand;" onclick="viewDPProgress('MAX_REV','<%="MAX_REV".equals(sortValue)?sortType:""%>')">Rev.<%="MAX_REV".equals(sortValue)?sortImage:""%></td>
                        <td rowspan="3" class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="viewDPProgress('DEPLOY_DATE','<%="DEPLOY_DATE".equals(sortValue)?sortType:""%>')">출도일자<%="DEPLOY_DATE".equals(sortValue)?sortImage:""%></td>
                        <td id="yardDrawingHeader1" colspan="2" class="td_standardSmall" nowrap style="display:<%=c8Display%>;">DrawingStart</td>
                        <td id="yardDrawingHeader2" colspan="2" class="td_standardSmall" nowrap style="display:<%=c9Display%>;">DrawingFinish</td>
                        <td id="yardDrawingHeader3" colspan="2" class="td_standardSmall" nowrap style="display:<%=c10Display%>;">OwnerApp.Submit</td>
                        <td id="yardDrawingHeader4" colspan="2" class="td_standardSmall" nowrap style="display:<%=c11Display%>;">OwnerApp.Receive</td>
                        <td id="yardDrawingHeader5" colspan="2" class="td_standardSmall" nowrap style="display:<%=c12Display%>;">ClassApp.Submit</td>
                        <td id="yardDrawingHeader6" colspan="2" class="td_standardSmall" nowrap style="display:<%=c13Display%>;">ClassApp.Receive</td>
                        <td id="yardDrawingHeader7" colspan="2" class="td_standardSmall" nowrap style="display:<%=c14Display%>;">REFERENCE</td>
                        <td id="commonDrawingHeader1" rowspan="2" colspan="2" class="td_standardSmall" nowrap style="display:<%=c15Display%>;">Construction</td>
                        <td rowspan="3" class="td_standardSmall" width="100" nowrap>참조EVENT</td>
                        <td rowspan="3" class="td_standardSmall" width="70" nowrap>현재일자</td>
                        <td colspan="9" class="td_standardSmall" nowrap>MANHOUR</td>
                    </tr>
                    <tr height="20" bgcolor="#e5e5e5">
                        <td id="vendorDrawingHeader1" colspan="2" class="td_standardSmall" nowrap style="display:<%=c8Display%>;">PurchaseRequest</td>
                        <td id="vendorDrawingHeader2" colspan="2" class="td_standardSmall" nowrap style="display:<%=c9Display%>;">MakerSelection</td>
                        <td id="vendorDrawingHeader3" colspan="2" class="td_standardSmall" nowrap style="display:<%=c10Display%>;">PurchaseOrder</td>
                        <td id="vendorDrawingHeader4" colspan="2" class="td_standardSmall" nowrap style="display:<%=c11Display%>;">DrawingReceive</td>
                        <td id="vendorDrawingHeader5" colspan="2" class="td_standardSmall" nowrap style="display:<%=c12Display%>;">OwnerApp.Submit</td>
                        <td id="vendorDrawingHeader6" colspan="2" class="td_standardSmall" nowrap style="display:<%=c13Display%>;">OwnerApp.Receive</td>
                        <td id="vendorDrawingHeader7" colspan="2" class="td_standardSmall" nowrap style="display:<%=c14Display%>;">MakerWorking</td>
                        <td colspan="2" class="td_standardSmall" nowrap>Plan</td>
                        <td colspan="2" class="td_standardSmall" nowrap>Internal</td>
                        <td colspan="2" class="td_standardSmall" nowrap>Outsourcing</td>
                        <td colspan="2" class="td_standardSmall" nowrap>Total</td>
                    </tr>
                    <tr height="16" bgcolor="#e5e5e5">
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c8Display%>;cursor:hand;" onclick="viewDPProgress('DW_PLAN_S','<%="DW_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="DW_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c8Display%>;cursor:hand;" onclick="viewDPProgress('DW_ACT_S','<%="DW_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="DW_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c9Display%>;cursor:hand;" onclick="viewDPProgress('DW_PLAN_F','<%="DW_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="DW_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c9Display%>;cursor:hand;" onclick="viewDPProgress('DW_ACT_F','<%="DW_ACT_F".equals(sortValue)?sortType:""%>')">Action<%="DW_ACT_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c10Display%>;cursor:hand;" onclick="viewDPProgress('OW_PLAN_S','<%="OW_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="OW_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c10Display%>;cursor:hand;" onclick="viewDPProgress('OW_ACT_S','<%="OW_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="OW_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c11Display%>;cursor:hand;" onclick="viewDPProgress('OW_PLAN_F','<%="OW_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="OW_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c11Display%>;cursor:hand;" onclick="viewDPProgress('OW_ACT_S','<%="OW_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="OW_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c12Display%>;cursor:hand;" onclick="viewDPProgress('CL_PLAN_S','<%="CL_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="CL_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c12Display%>;cursor:hand;" onclick="viewDPProgress('CL_ACT_S','<%="CL_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="CL_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c13Display%>;cursor:hand;" onclick="viewDPProgress('CL_PLAN_F','<%="CL_PLAN_F".equals(sortValue)?sortType:""%>')">Plan<%="CL_PLAN_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c13Display%>;cursor:hand;" onclick="viewDPProgress('CL_ACT_F','<%="CL_ACT_F".equals(sortValue)?sortType:""%>')">Action<%="CL_ACT_F".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c14Display%>;cursor:hand;" onclick="viewDPProgress('RF_PLAN_S','<%="RF_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="RF_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c14Display%>;cursor:hand;" onclick="viewDPProgress('RF_ACT_S','<%="RF_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="RF_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c15Display%>;cursor:hand;" onclick="viewDPProgress('WK_PLAN_S','<%="WK_PLAN_S".equals(sortValue)?sortType:""%>')">Plan<%="WK_PLAN_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c15Display%>;cursor:hand;" onclick="viewDPProgress('WK_ACT_S','<%="WK_ACT_S".equals(sortValue)?sortType:""%>')">Action<%="WK_ACT_S".equals(sortValue)?sortImage:""%></td>
                        <td class="td_standardSmall" width="50" nowrap>STD</td>
                        <td class="td_standardSmall" width="55" nowrap>FollowUp</td>
                        <td class="td_standardSmall" width="50" nowrap>STD</td>
                        <td class="td_standardSmall" width="55" nowrap>FollowUp</td>
                        <td class="td_standardSmall" width="50" nowrap>STD</td>
                        <td class="td_standardSmall" width="55" nowrap>FollowUp</td>
                        <td class="td_standardSmall" width="50" nowrap>STD</td>
                        <td class="td_standardSmall" width="55" nowrap>FollowUp</td>
                    </tr>    
                </table>
            </div>	
        </td>
    </tr>

    <tr valign="top">
        <td align="left" style="vertical-align:top">
            <div id="list_left" STYLE="width:687; height:627; overflow:scroll; position:absolute; left:1; top:68;" onScroll="onScrollHandler2();"> 
                <table id="table_data1" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fiexed;" align="left">
                <%
                for (int i = 0; designProgressList != null && i < designProgressList.size(); i++)
                {
                    Map designProgressMap = (Map)designProgressList.get(i);
                    String projectNoData = (String)designProgressMap.get("PROJECTNO");
                    String deptName = (String)designProgressMap.get("DEPTNAME");
                    String deptCodeData = (String)designProgressMap.get("DEPTCODE");
                    String empNo = (String)designProgressMap.get("SABUN");
                    String empName = (String)designProgressMap.get("NAME");
                    String dwgCode = (String)designProgressMap.get("DWGCODE");
                    String dwgTitle = (String)designProgressMap.get("DWGTITLE");
                    String outsourcingYN = (String)designProgressMap.get("OUTSOURCINGYN");
                    String outsourcing1 = (String)designProgressMap.get("OUTSOURCING1");
                    String outsourcing2 = (String)designProgressMap.get("OUTSOURCING2");
                    String dwgZone = (String)designProgressMap.get("DWGZONE");
                    String dwgTitleHint = replaceAmpAll(dwgTitle, "'", "＇");
                    boolean isEditable = false;
                    //if (isAdmin.equals("Y") || (isManager.equals("Y") && userDept.equals(deptCodeData))) isEditable = true;
                    if (isAdmin.equals("Y") || userDept.equals((String)designProgressMap.get("DEPTCODE"))) isEditable = true;

                    %>
                    
                    <tr height="20" bgcolor="#ffffff" onMouseOver="trOnMouseOver('<%=dwgCode%>');">
                        <td id="td_list_no" 				class="td_standardSmall" width="24" nowrap bgcolor="#eeeeee"><%=i+1%></td>
                        <td id="td_list_project" 			class="td_standardSmall" width="50" nowrap style="display:<%=c1Display%>;"><%=projectNoData%></td>
                        <td id="td_list_part" 				class="td_standardSmall" width="90" nowrap style="display:<%=c2Display%>;">
                            <nobr id="list_part" style="display:block;width:80;overflow:hidden;text-overflow:ellipsis;"><%=deptName%></nobr>
                        </td>
                        <td id="td_list_drawingno" 			class="td_standardSmall" width="70" nowrap style="display:<%=c3Display%>;"><%=dwgCode%></td>
                        <td id="td_list_zone" 				class="td_standardSmall" width="40" nowrap style="display:<%=c4Display%>;"><%=dwgZone%></td>
                        <td id="td_list_outsourcingplan1" 	class="td_standardSmall" width="27" nowrap style="display:<%=c5Display%>;"><%=outsourcingYN%></td>
                        <td id="td_list_outsourcingplan2" 	class="td_standardSmall" width="26" nowrap style="display:<%=c5Display%>;"><%=outsourcing1%></td>
                        <td id="td_list_outsourcingplan3" 	class="td_standardSmall" width="26" nowrap style="display:<%=c5Display%>;"><%=outsourcing2%></td>
                        <td id="td_list_task" 				class="td_standardSmall" width="256" style="text-align:left;" nowrap  style="display:<%=c6Display%>;" onmouseover="showhint(this, '<%=dwgTitleHint%>');">
                            <nobr id="list_task" 			style="display:block;width:250;overflow:hidden;text-overflow:ellipsis;"><%=dwgTitle%></nobr>
                        </td>
                        <% if (isEditable) { %>
                            <td id="td_list_user" class="td_smallYellowBack" width="50" nowrap onclick="selectPartPerson(this, '<%=dwgCode%>DW', '<%=empNo%>');" style="display:<%=c7Display%>;"><%=empName%></td> 
                        <% } else { %>
                            <td id="td_list_user" class="td_standardSmall" width="50" nowrap style="display:<%=c7Display%>;"><%=empName%></td> 
                        <% } %>
                    </tr>
                    
                    <%
                }
                %>
                </table>
            </div>			
        </td>

        <td id="td_list_right" width="580" align="left">
            <div id="list_right" STYLE="width:600;height:627;overflow:scroll;position:absolute;left:671;top:68;background-color:#ffffff" 
             onScroll="onScrollHandler();"> 
                <table id="table_data2" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc">
                <%
                for (int i = 0; designProgressList != null && i < designProgressList.size(); i++)
                {
                    Map designProgressMap = (Map)designProgressList.get(i);
                    String dwgCode = (String)designProgressMap.get("DWGCODE");
                    String dwPlanStart = (String)designProgressMap.get("DW_PLAN_S");
                    String dwPlanFinish = (String)designProgressMap.get("DW_PLAN_F");
                    String dwActionStart = (String)designProgressMap.get("DW_ACT_S");
                    String dwActionFinish = (String)designProgressMap.get("DW_ACT_F");
                    String owPlanStart = (String)designProgressMap.get("OW_PLAN_S");
                    String owPlanFinish = (String)designProgressMap.get("OW_PLAN_F");
                    String owActionStart = (String)designProgressMap.get("OW_ACT_S");
                    String owActionFinish = (String)designProgressMap.get("OW_ACT_F");
                    String clPlanStart = (String)designProgressMap.get("CL_PLAN_S");
                    String clPlanFinish = (String)designProgressMap.get("CL_PLAN_F");
                    String clActionStart = (String)designProgressMap.get("CL_ACT_S");
                    String clActionFinish = (String)designProgressMap.get("CL_ACT_F");
                    String rfPlanStart = (String)designProgressMap.get("RF_PLAN_S");
                    String rfActionStart = (String)designProgressMap.get("RF_ACT_S");
                    String wkPlanStart = (String)designProgressMap.get("WK_PLAN_S");
                    String wkActionStart = (String)designProgressMap.get("WK_ACT_S");
                    String outSTD = (String)designProgressMap.get("OUT_STD");
                    String outFollowup = (String)designProgressMap.get("OUT_FOLLOWUP");
                    String internalSTD = (String)designProgressMap.get("INTERNAL_STD");
                    String internalFollowup = (String)designProgressMap.get("INTERNAL_FOLLOWUP");
                    String planSTD = (String)designProgressMap.get("PLAN_STD");
                    String planFollowup = (String)designProgressMap.get("PLAN_FOLLOWUP");
                    String stdTotal = (String)designProgressMap.get("STD_TOTAL");
                    String followupTotal = (String)designProgressMap.get("FOLLOWUP_TOTAL");
                    String dwPlanStartOver = (String)designProgressMap.get("DW_PLAN_S_O");
                    String dwPlanFinishOver = (String)designProgressMap.get("DW_PLAN_F_O");
                    String owPlanStartOver = (String)designProgressMap.get("OW_PLAN_S_O");
                    String owPlanFinishOver = (String)designProgressMap.get("OW_PLAN_F_O");
                    String clPlanStartOver = (String)designProgressMap.get("CL_PLAN_S_O");
                    String clPlanFinishOver = (String)designProgressMap.get("CL_PLAN_F_O");
                    String rfPlanStartOver = (String)designProgressMap.get("RF_PLAN_S_O");
                    String wkPlanStartOver = (String)designProgressMap.get("WK_PLAN_S_O");

                    String deployRev = (String)designProgressMap.get("MAX_REV");
                    String deployDate = (String)designProgressMap.get("DEPLOY_DATE");
                    String dtsResult = (String)designProgressMap.get("DTS_RESULT");
                    String dtsDeployRev = "";
                    String dtsDeployDate = "";
                    if (!StringUtil.isNullString(dtsResult)) {
                        dtsDeployRev = dtsResult.substring(0, dtsResult.indexOf(":"));
                        if (dtsDeployRev.startsWith("0")) dtsDeployRev = dtsDeployRev.substring(1);
                        dtsDeployDate = dtsResult.substring(dtsResult.indexOf(":") + 1);
                    }
                    boolean dtsSelectedCase = false;
                    if (StringUtil.isNullString(deployRev)) dtsSelectedCase = true; 
                    else if (!StringUtil.isNullString(dtsDeployRev)) {
                        if (isAlphabet(deployRev)) {
                            if (isNumeric(dtsDeployRev)) dtsSelectedCase = true;
                            else if (dtsDeployRev.charAt(0) >= deployRev.charAt(0)) dtsSelectedCase = true;
                        }
                        else if (isNumeric(deployRev)) {
                            if (isNumeric(dtsDeployRev) && (Integer.parseInt(dtsDeployRev) >= Integer.parseInt(deployRev)))
                                dtsSelectedCase = true;
                        }
                    }
                    if (dtsSelectedCase) { deployRev = dtsDeployRev; deployDate = dtsDeployDate; }

                    boolean isEditable = false;
                    if (isAdmin.equals("Y") || userDept.equals((String)designProgressMap.get("DEPTCODE"))) isEditable = true;

                    boolean isEditable2 = false;
                    if (allDepartEditableProjects.indexOf(projectNo) >= 0) isEditable2 = true;

                    boolean owStartFinishEqual = false;
                    boolean clStartFinishEqual = false;
                    if (!owPlanStart.equals("") && owPlanStart.equals(owPlanFinish)) owStartFinishEqual = true;
                    if (!clPlanStart.equals("") && clPlanStart.equals(clPlanFinish)) clStartFinishEqual = true;
                    

                    String dwActionStartBGColor = "#ffffe0";  if (!isEditable) dwActionStartBGColor = "#ffffff";
                    String dwActionFinishBGColor = "#ffffe0"; if (!isEditable) dwActionFinishBGColor = "#ffffff";
                    String owActionStartBGColor = "#ffffe0";  if (!isEditable) owActionStartBGColor = "#ffffff";
                    String owActionFinishBGColor = "#ffffe0"; if (!isEditable) owActionFinishBGColor = "#ffffff"; 
                    String clActionStartBGColor = "#ffffe0";  if (!isEditable && !isEditable2) clActionStartBGColor = "#ffffff";
                    String clActionFinishBGColor = "#ffffe0"; if (!isEditable && !isEditable2) clActionFinishBGColor = "#ffffff";
                    String rfActionStartBGColor = "#ffffe0";  if (!isEditable) rfActionStartBGColor = "#ffffff";
                    String wkActionStartBGColor = "#ffffe0";  if (!isEditable) wkActionStartBGColor = "#ffffff";
                    if (dwPlanStartOver.equals("Y") && dwActionStart.equals("")) dwActionStartBGColor = "#ff0000";
                    if (dwPlanFinishOver.equals("Y") && dwActionFinish.equals("")) dwActionFinishBGColor = "#ff0000";
                    if (owPlanStartOver.equals("Y") && owActionStart.equals("")) owActionStartBGColor = "#ff0000";
                    if (owPlanFinishOver.equals("Y") && owActionFinish.equals("")) owActionFinishBGColor = "#ff0000";
                    if (clPlanStartOver.equals("Y") && clActionStart.equals("")) clActionStartBGColor = "#ff0000";
                    if (clPlanFinishOver.equals("Y") && clActionFinish.equals("")) clActionFinishBGColor = "#ff0000";
                    if (rfPlanStartOver.equals("Y") && rfActionStart.equals("")) rfActionStartBGColor = "#ff0000";
                    if (wkPlanStartOver.equals("Y") && wkActionStart.equals("")) wkActionStartBGColor = "#ff0000";

                    String activityDesc = (String)designProgressMap.get("ACTIVITY_DESC");
                    String activityDesc1 = "";
                    String activityDesc2 = "";
                    if (!StringUtil.isNullString(activityDesc)) {
                        activityDesc1 = activityDesc.substring(0, activityDesc.indexOf("|"));
                        activityDesc2 = activityDesc.substring(activityDesc.indexOf("|") + 1);
                    }

                    String dwAttr4 = (String)designProgressMap.get("DW_ATTRIBUTE4"); // DW Start가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String dwAttr5 = (String)designProgressMap.get("DW_ATTRIBUTE5"); // DW Finish가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String owAttr4 = (String)designProgressMap.get("OW_ATTRIBUTE4"); // OW Start가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String owAttr5 = (String)designProgressMap.get("OW_ATTRIBUTE5"); // OW Finish가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String clAttr4 = (String)designProgressMap.get("CL_ATTRIBUTE4"); // CL Start가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String clAttr5 = (String)designProgressMap.get("CL_ATTRIBUTE5"); // CL Finish가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String rfAttr4 = (String)designProgressMap.get("RF_ATTRIBUTE4"); // RF Start가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String rfAttr5 = (String)designProgressMap.get("RF_ATTRIBUTE5"); // RF Finish가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String wkAttr4 = (String)designProgressMap.get("WK_ATTRIBUTE4"); // WK Start가 자동입력된 것인지 여부(Null이 아니면 자동입력)
                    String wkAttr5 = (String)designProgressMap.get("WK_ATTRIBUTE5"); // WK Finish가 자동입력된 것인지 여부(Null이 아니면 자동입력)

                    String dwAttr4Style = ""; if (!dwAttr4.equals("")) dwAttr4Style = "font-style:italic;";
                    String dwAttr5Style = ""; if (!dwAttr5.equals("")) dwAttr5Style = "font-style:italic;";
                    String owAttr4Style = ""; if (!owAttr4.equals("")) owAttr4Style = "font-style:italic;";
                    String owAttr5Style = ""; if (!owAttr5.equals("")) owAttr5Style = "font-style:italic;";
                    String clAttr4Style = ""; if (!clAttr4.equals("")) clAttr4Style = "font-style:italic;";
                    String clAttr5Style = ""; if (!clAttr5.equals("")) clAttr5Style = "font-style:italic;";
                    String rfAttr4Style = ""; if (!rfAttr4.equals("")) rfAttr4Style = "font-style:italic;";
                    String rfAttr5Style = ""; if (!rfAttr5.equals("")) rfAttr5Style = "font-style:italic;";
                    String wkAttr4Style = ""; if (!wkAttr4.equals("")) wkAttr4Style = "font-style:italic;";
                    String wkAttr5Style = ""; if (!wkAttr5.equals("")) wkAttr5Style = "font-style:italic;";
                    
                    
                    // 2014-05-28 Kang seonjung : Vendor 도면(V로 시작하는 도면) 이고, OW Start가 자동입력된 대상이면 PRInfo창 보기 가능
                    boolean viewPRInfo = false;
                    if (dwgCode.startsWith("V")&& !owAttr4.equals("")) viewPRInfo = true;                    
                    %>

                    <tr height="20" bgcolor="#ffffff"  onMouseOver="trOnMouseOver('<%=dwgCode%>');">
                        <td class="td_standardSmall" width="40" nowrap style="cursor:hand;" onclick="showDeployRevInfo('<%=dwgCode%>');">
                            <%=deployRev%>
                        </td> 
                        <td class="td_standardSmall" width="70" nowrap style="cursor:hand;" onclick="showDeployRevInfo('<%=dwgCode%>');">
                            <%=deployDate%>
                        </td> 

                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c8Display%>;"><%=dwPlanStart%></td>                        
                        <% if (isEditable && !StringUtil.isNullString(dwPlanStart)) { %>
                            <td class="td_standardSmall" width="70" nowrap 
                                onclick="selectActionDate(this, '<%=dwgCode%>DW', 'S', '<%=dwActionStart%>', false);"  
                                ondblclick="deleteActionDate(this, '<%=dwgCode%>DW', 'S', '<%=dwActionStart%>', false);" 
                                style="background-color:<%=dwActionStartBGColor%>;display:<%=c8Display%>;<%=dwAttr4Style%>">
                                <%=dwActionStart%>
                            </td>
                        <% } else { 
                            if (dwActionStartBGColor.equals("#ffffe0")) dwActionStartBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=dwActionStartBGColor%>;display:<%=c8Display%>;<%=dwAttr4Style%>">
                                <%=dwActionStart%>
                            </td>
                        <% } %>
                        
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c9Display%>;"><%=dwPlanFinish%></td>
                        <% if (isEditable && !StringUtil.isNullString(dwPlanFinish)) { %>
                            <td class="td_standardSmall" width="70" nowrap 
                                onclick="selectActionDate(this, '<%=dwgCode%>DW', 'F', '<%=dwActionFinish%>', false);" 
                                ondblclick="deleteActionDate(this, '<%=dwgCode%>DW', 'F', '<%=dwActionFinish%>', false);" 
                                style="background-color:<%=dwActionFinishBGColor%>;display:<%=c9Display%>;<%=dwAttr5Style%>"><%=dwActionFinish%></td>
                        <% } else { 
                            if (dwActionFinishBGColor.equals("#ffffe0")) dwActionFinishBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=dwActionFinishBGColor%>;display:<%=c9Display%>;<%=dwAttr5Style%>">
                                <%=dwActionFinish%>
                            </td>
                        <% } %>

                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c10Display%>;"><%=owPlanStart%></td>
                        <% if (isEditable && !StringUtil.isNullString(owPlanStart)) { %>
	                        <% if(viewPRInfo) { %>
	                            <td class="td_standardSmall" width="70" nowrap 
	                                onclick="searchPrPoInfo('<%=dwgCode%>');" 	                                
	                                style="cursor:hand;background-color:<%=owActionStartBGColor%>;display:<%=c10Display%>;<%=owAttr4Style%>"><%=owActionStart%></td>
	                        <% } else { %>        
	                            <td class="td_standardSmall" width="70" nowrap 
	                                onclick="selectActionDate(this, '<%=dwgCode%>OW', 'S', '<%=owActionStart%>', <%=owStartFinishEqual%>);" 
	                                ondblclick="deleteActionDate(this, '<%=dwgCode%>OW', 'S', '<%=owActionStart%>', <%=owStartFinishEqual%>);" 
	                                style="background-color:<%=owActionStartBGColor%>;display:<%=c10Display%>;<%=owAttr4Style%>"><%=owActionStart%></td>  
	                        <% } %>                              
                        <% } else { 
                            if (owActionStartBGColor.equals("#ffffe0")) owActionStartBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=owActionStartBGColor%>;display:<%=c10Display%>;<%=owAttr4Style%>">
                                <%=owActionStart%>
                            </td>                        
                        <% } %>
                        
                        <% if (!owStartFinishEqual) { %>
                            <td class="td_standardSmall" width="70" nowrap style="display:<%=c11Display%>;"><%=owPlanFinish%></td>
                            <% if (isEditable && !StringUtil.isNullString(owPlanFinish)) { %>
                                <td class="td_standardSmall" width="70" nowrap 
                                    onclick="selectActionDate(this, '<%=dwgCode%>OW', 'F', '<%=owActionFinish%>', <%=owStartFinishEqual%>);" 
                                    ondblclick="deleteActionDate(this, '<%=dwgCode%>OW', 'F', '<%=owActionFinish%>', <%=owStartFinishEqual%>);" 
                                    style="background-color:<%=owActionFinishBGColor%>;display:<%=c11Display%>;<%=owAttr5Style%>"><%=owActionFinish%></td>
                            <% } else { 
                                if (owActionFinishBGColor.equals("#ffffe0")) owActionFinishBGColor = "#ffffff";
                            %>
                                <td class="td_standardSmall" width="70" nowrap 
                                    style="background-color:<%=owActionFinishBGColor%>;display:<%=c11Display%>;<%=owAttr5Style%>">
                                    <%=owActionFinish%>
                                </td>
                            <% } %>

                        <% } else { %>
                            <td class="td_standardSmall" width="70" nowrap style="background-color:#dddddd;display:<%=c11Display%>;<%=owAttr5Style%>">&nbsp;</td>
                            <td class="td_standardSmall" width="70" nowrap style="background-color:#dddddd;display:<%=c11Display%>;<%=owAttr5Style%>">&nbsp;</td>
                        <% } %>
                        
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c12Display%>;"><%=clPlanStart%></td>
                        <% if ((isEditable || isEditable2) && !StringUtil.isNullString(clPlanStart)) { %>
                            <td class="td_standardSmall" width="70" nowrap 
                                onclick="selectActionDate(this, '<%=dwgCode%>CL', 'S', '<%=clActionStart%>', <%=clStartFinishEqual%>);" 
                                ondblclick="deleteActionDate(this, '<%=dwgCode%>CL', 'S', '<%=clActionStart%>', <%=clStartFinishEqual%>);" 
                                style="background-color:<%=clActionStartBGColor%>;display:<%=c12Display%>;<%=clAttr4Style%>"><%=clActionStart%></td>
                        <% } else { 
                            if (clActionStartBGColor.equals("#ffffe0")) clActionStartBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=clActionStartBGColor%>;display:<%=c12Display%>;<%=clAttr4Style%>">
                                <%=clActionStart%>
                            </td>
                        <% } %>
    
                        <% if (!clStartFinishEqual) { %>
                            <td class="td_standardSmall" width="70" nowrap style="display:<%=c13Display%>;"><%=clPlanFinish%></td>
                            <% if ((isEditable || isEditable2) && !StringUtil.isNullString(clPlanFinish)) { %>
                                <td class="td_standardSmall" width="70" nowrap 
                                    onclick="selectActionDate(this, '<%=dwgCode%>CL', 'F', '<%=clActionFinish%>', <%=clStartFinishEqual%>);" 
                                    ondblclick="deleteActionDate(this, '<%=dwgCode%>CL', 'F', '<%=clActionFinish%>', <%=clStartFinishEqual%>);" 
                                    style="background-color:<%=clActionFinishBGColor%>;display:<%=c13Display%>;<%=clAttr5Style%>"><%=clActionFinish%></td>
                            <% } else { 
                                if (clActionFinishBGColor.equals("#ffffe0")) clActionFinishBGColor = "#ffffff";
                            %>
                                <td class="td_standardSmall" width="70" nowrap 
                                    style="background-color:<%=clActionFinishBGColor%>;display:<%=c13Display%>;<%=clAttr5Style%>">
                                    <%=clActionFinish%>
                                </td>
                            <% } %>

                        <% } else { %>
                            <td class="td_standardSmall" width="70" style="background-color:#dddddd;display:<%=c13Display%>;<%=clAttr5Style%>">&nbsp;</td>
                            <td class="td_standardSmall" width="70" style="background-color:#dddddd;display:<%=c13Display%>;<%=clAttr5Style%>">&nbsp;</td>
                        <% } %>
                        
                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c14Display%>;"><%=rfPlanStart%></td>
                        <% if (isEditable && !StringUtil.isNullString(rfPlanStart)) { %>
                            <td class="td_standardSmall" width="70" nowrap 
                                onclick="selectActionDate(this, '<%=dwgCode%>RF', 'S', '<%=rfActionStart%>', false);" 
                                ondblclick="deleteActionDate(this, '<%=dwgCode%>RF', 'S', '<%=rfActionStart%>', false);" 
                                style="background-color:<%=rfActionStartBGColor%>;display:<%=c14Display%>;<%=rfAttr4Style%>"><%=rfActionStart%></td>
                        <% } else { 
                            if (rfActionStartBGColor.equals("#ffffe0")) rfActionStartBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=rfActionStartBGColor%>;display:<%=c14Display%>;<%=rfAttr4Style%>">
                                <%=rfActionStart%>
                            </td>
                        <% } %>

                        <td class="td_standardSmall" width="70" nowrap style="display:<%=c15Display%>;"><%=wkPlanStart%></td>
                        <% if (isEditable && !StringUtil.isNullString(wkPlanStart)) { %>
                            <td class="td_standardSmall" width="70" nowrap 
                                onclick="selectActionDate(this, '<%=dwgCode%>WK', 'S', '<%=wkActionStart%>', false);" 
                                ondblclick="deleteActionDate(this, '<%=dwgCode%>WK', 'S', '<%=wkActionStart%>', false);" 
                                style="background-color:<%=wkActionStartBGColor%>;display:<%=c15Display%>;<%=wkAttr4Style%>"><%=wkActionStart%></td>
                        <% } else { 
                            if (wkActionStartBGColor.equals("#ffffe0")) wkActionStartBGColor = "#ffffff";
                        %>
                            <td class="td_standardSmall" width="70" nowrap 
                                style="background-color:<%=wkActionStartBGColor%>;display:<%=c15Display%>;<%=wkAttr4Style%>">
                                <%=wkActionStart%>
                            </td>
                        <% } %>
                        
                        <td class="td_standardSmall" width="100" nowrap onmouseover="showhint(this, '<%=activityDesc1%>');">
                            <nobr style="display:block;width:94;overflow:hidden;text-overflow:ellipsis;"><%=activityDesc1%></nobr>
                        </td> 
                        <td class="td_standardSmall" width="70" nowrap><%=activityDesc2%></td> 

                        <td class="td_standardSmall" width="50" nowrap><%=planSTD%></td> 
                        <td class="td_standardSmall" width="55" nowrap><%=planFollowup%></td> 
                        <td class="td_standardSmall" width="50" nowrap><%=internalSTD%></td>
                        <td class="td_standardSmall" width="55" nowrap><%=internalFollowup%></td> 
                        <td class="td_standardSmall" width="50" nowrap><%=outSTD%></td> 
                        <td class="td_standardSmall" width="55" nowrap><%=outFollowup%></td> 
                        <td class="td_standardSmall" width="50" nowrap><%=stdTotal%></td>
                        <td class="td_standardSmall" width="55" nowrap><%=followupTotal%></td>
                    </tr>
                    
                    <%
                }
                %>
                </table>
            </div>	
        </td>
    </tr>

</table>
<%
}
%>

<input type="hidden" name="projectNo" value="<%=projectNo%>" />
<input type="hidden" name="deptCode" value="<%=deptCode%>" />
<input type="hidden" name="designerID" value="<%=designerID%>" />
<input type="hidden" name="dateFrom" value="<%=dateFrom%>" />
<input type="hidden" name="dateTo" value="<%=dateTo%>" />
<input type="hidden" name="dateCondition" value="<%=dateCondition%>" />
<input type="hidden" name="drawingNo1" value="<%=drawingNo1%>" />
<input type="hidden" name="drawingNo2" value="<%=drawingNo2%>" />
<input type="hidden" name="drawingNo3" value="<%=drawingNo3%>" />
<input type="hidden" name="drawingNo4" value="<%=drawingNo4%>" />
<input type="hidden" name="drawingNo5" value="<%=drawingNo5%>" />
<input type="hidden" name="drawingNo6" value="<%=drawingNo6%>" />
<input type="hidden" name="drawingNo7" value="<%=drawingNo7%>" />
<input type="hidden" name="drawingNo8" value="<%=drawingNo8%>" />
<input type="hidden" name="isManager" value="<%=isManager%>" />
<input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
<input type="hidden" name="userDept" value="<%=userDept%>" />
<input type="hidden" name="lockDate" value="<%=lockDate%>" />
<input type="hidden" name="sortValue" value="<%=sortValue%>" />
<input type="hidden" name="sortType" value="<%=sortType%>" />

<div id="dummyDiv" style="position:absolute;width=0px;height:0px;">
    <input type="text" name="dummyText" value="" style="width=0px;height:0px;" />
</div>
<!--
<div id="delBtnDiv" style="position:absolute;width=0px;height:0px;display:none;">
    <input type="button" name="deleteButton" value="X" style="width=23px;height:23px;" onclick="deleteActionDate();" />
</div>
-->
<div id="personsListDiv" style="position:absolute;display:none;">
    <table cellpadding="0" cellspacing="0" style="border-style:solid;border-width:1px;">
    <tr><td>
        <select name="personsList" style="width:235px;background-color:#fff0f5" onchange="personSelChanged();">
            <option value="">&nbsp;</option>
            <% 
            for (int i = 0; partPersonsList != null && i < partPersonsList.size(); i++) {
                Map map = (Map)partPersonsList.get(i);
                String personID = (String)map.get("EMPLOYEE_NO");
                String personName = (String)map.get("EMPLOYEE_NAME");
                String phoneNum = (String)map.get("PHONE");
                %>
                <option value="<%=personID%>"><%=personID%>&nbsp; &nbsp; &nbsp; &nbsp;<%=personName%> (<%=phoneNum%>)</option>
            <% } %>
        </select>
    </td></tr>
    </table>
</div>

</form>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

	// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지     
	document.onkeydown = keydownHandler;


    <% if (designProgressList == null) { %>
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.projectTotal.value = "";
    <% } else { %>
        parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.projectTotal.value = <%= designProgressList.size() %>;
    <% } %>

    // document click 이벤트 핸들러 지정
    document.onclick = mouseClickHandler;
    var isNewShow = false;

    // 스크롤 처리
    function onScrollHandler() 
    {
		header_right.scrollLeft = list_right.scrollLeft;
		list_left.scrollTop = list_right.scrollTop;
		return;
    }

    // 스크롤 처리
    function onScrollHandler2() 
    {
		list_right.scrollLeft = header_right.scrollLeft;
		list_right.scrollTop = list_left.scrollTop;
		return;
    }
    
    // Action Date 입력 관련 현재 선택된 TD 개체를 전역변수에 저장
    var activeTDObject = null;
    var activeActivityCode = "";
    var inputDatesList = new Array();
    var inputPersonsList = new Array();

    // Action Date 입력 처리 : 칼렌다 표시, 일자 선택 시 DB 반영
    function selectActionDate(tdObject, activityCode, startFinishCode, currentData, isStartEndEqual)
    {
        if (currentData != "" && DPProgressViewMain.isAdmin.value != "Y") return; // 값이 있는 경우 진행X

        if (isStartEndEqual) startFinishCode = "A"; // Start&Finish All

        var objPosition = getAbsolutePosition(tdObject);
        dummyDiv.style.left = objPosition.x - list_right.scrollLeft; // dummyDiv & dummyText 는 칼렌다 팝업 위치 및 칼렌다 선택 값을 얻기 위해 필요
        dummyDiv.style.top = (objPosition.y - list_right.scrollTop)>510?(objPosition.y - list_right.scrollTop - 210):(objPosition.y - list_right.scrollTop);
        activeTDObject = tdObject;
        activeActivityCode = activityCode + "|" + startFinishCode;

        showCalendar('DPProgressViewMain', 'dummyText', '', false, dateChanged);
    }

    // 선택된 Action Date를 삭제
    function deleteActionDate(tdObject, activityCode, startFinishCode, currentData, isStartEndEqual)
    {
        if (DPProgressViewMain.isAdmin.value != "Y") return; // Admin이 아니면 exit
        if (tdObject.innerHTML == "") return; // 값이 있는 경우만 해당

        if (isStartEndEqual) startFinishCode = "A"; // Start&Finish All

        // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
        var isExist = false;
        for (var i = 0; i < inputDatesList.length; i++) {
            var str = inputDatesList[i];
            if (str.indexOf(activityCode + "|" + startFinishCode + "|") >= 0) {
                inputDatesList[i] = activityCode + "|" + startFinishCode + "|";
                isExist = true;
                break;
            }
        }
        if (!isExist) 
            inputDatesList[inputDatesList.length] = activityCode + "|" + startFinishCode + "|";

        tdObject.innerHTML = "";
    }

    // 날짜 출력 문자열을 형식화 & 유효성 체크
    function dateChanged()
    {
        var tmpStr = DPProgressViewMain.dummyText.value;
        if (tmpStr != null || tmpStr.trim() != "") {
            DPProgressViewMain.dummyText.value = formatDateStr(tmpStr); // 2009.6.5 -> 2009-06-05 형식으로 변경

            // 오늘 기준 -(lockDate0 ~ +1 일 이내 날짜만 입력 가능(체크)
            if (DPProgressViewMain.isAdmin.value != "Y") {
                var today = new Date();
                var dateStrs = (DPProgressViewMain.dummyText.value).split("-");

                var lockDate = DPProgressViewMain.lockDate.value;
                if (lockDate != "") {
                    if (lockDate.indexOf("-") == 0) lockDate = lockDate.substring(1);
                    // 선택일에 +(lockDate)일 한 일자(오늘날짜보다 같거나 커야함) 
                    var targetDate = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "+" + lockDate)); 
                    if (targetDate < today) {
                        var msgStr = "입력 가능 일자가 아닙니다. 자세한 사항은\n\n\n" +
                                     "조선 -> 기술기획팀-기술계획P에 문의 바랍니다.\n\n" + 
                                     "해양 -> 해양설계관리팀으로 문의 바랍니다.";
                        alert(msgStr);
                        return;
                    }
                }

                // 선택일에 -1일 한 일자(오늘날짜보다 작거나 같아야함)
                var targetDate2 = new Date(dateStrs[0], eval(dateStrs[1] + "-1"), eval(dateStrs[2] + "-1")); 
                if (targetDate2 > today) {
                    alert("오늘날짜 기준 +1일 이내의 날짜만 입력할 수 있습니다!");
                    return;
                }
            }

            // 값당
            if (activeTDObject != null) activeTDObject.innerHTML = DPProgressViewMain.dummyText.value;
            if (activeActivityCode != "") {
                // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
                var isExist = false;
                for (var i = 0; i < inputDatesList.length; i++) {
                    var str = inputDatesList[i];
                    if (str.indexOf(activeActivityCode + "|") >= 0) {
                        inputDatesList[i] = activeActivityCode + "|" + DPProgressViewMain.dummyText.value;
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) 
                    inputDatesList[inputDatesList.length] = activeActivityCode + "|" + DPProgressViewMain.dummyText.value;
            }
        }
    }

    // 담당자 선택 화면 Show
    function selectPartPerson(tdObject, activityCode, currentData)
    {
        //if (DPProgressViewMain.isAdmin.value != "Y" && DPProgressViewMain.isManager.value != "Y") return; // Admin 또는 Manager(파트장)이 아니면 진행X
        //if (currentData != "" && DPProgressViewMain.isAdmin.value != "Y") return; // 값이 있는 경우 진행X
        if (personsListDiv == null) return;

        var objPosition = getAbsolutePosition(tdObject);
        personsListDiv.style.left = objPosition.x + tdObject.offsetWidth;
        personsListDiv.style.top = objPosition.y - list_right.scrollTop - 2;
        activeTDObject = tdObject;
        activeActivityCode = activityCode;

        // 변경된 항목 중에 지금 선택된 항목이 있으면 변경된 항목 값(inputPersonsList)을 사용하고, 없으면 초기 값을 사용
        // TD에 표현되는 값은 사원이름인데 키는 사원번호... 변경 없으면 초기 값 사용하면 되는데 변경된 경우 사원번호는 inputPersonsList에만 존재
        for (var i = 0; i < inputPersonsList.length; i++) {
            var str = inputPersonsList[i];
            if (str.indexOf(activeActivityCode + "|") >= 0) {
                currentData = (str.split("|"))[1];
                break;
            }
        }

        for (var i = 0; i < DPProgressViewMain.personsList.options.length; i++) {
            var str = DPProgressViewMain.personsList.options[i].value;
            if (str == currentData) {
                DPProgressViewMain.personsList.selectedIndex = i;
                break;
            }
        }

        personsListDiv.style.display = '';
        isNewShow = true;
    }
 
    // 담당자 선택 화면 Hidden
    function hidePartPersonSelect()
    {
        if (personsListDiv == null || personsListDiv.style.display == 'none') return;
        DPProgressViewMain.personsList.selectedIndex = 0;
        personsListDiv.style.display = 'none';
    }

    // 담당자 선택(입력) 처리
    function personSelChanged()
    {
        if (activeTDObject != null) {
            var str = DPProgressViewMain.personsList.options[DPProgressViewMain.personsList.selectedIndex].text;
            if (str != "") {
                var strs = str.split(" ");
                str = strs[3];
            }
            activeTDObject.innerHTML = str;
        }
        if (activeActivityCode != "") {
            // 추가 or 삭제 대상 목록에 이미 있으면 업데이트, 없으면 추가
            var isExist = false;
            for (var i = 0; i < inputPersonsList.length; i++) {
                var str = inputPersonsList[i];
                if (str.indexOf(activeActivityCode + "|") >= 0) {
                    inputPersonsList[i] = activeActivityCode + "|" + DPProgressViewMain.personsList.value;
                    isExist = true;
                    break;
                }
            }
            if (!isExist) 
                inputPersonsList[inputPersonsList.length] = activeActivityCode + "|" + DPProgressViewMain.personsList.value;
        }

        hidePartPersonSelect();
    }

    // 공정 실제시수 입력사항 저장
    function saveDPProgress()
    {
        if (inputDatesList.length <= 0 && inputPersonsList.length <= 0) {
            alert("변경사항이 없습니다");
            return;
        }

        var str = "";
        for (var i = 0; i < inputDatesList.length; i++) {
            if (i > 0) str += ",";
            str += inputDatesList[i];
        }
        var str2 = "";
        for (var i = 0; i < inputPersonsList.length; i++) {
            if (i > 0) str2 += ",";
            str2 += inputPersonsList[i];
        }

        var params = "projectNo=" + DPProgressViewMain.projectNo.value;
        params += "&inputDates=" + str;
        params += "&inputPersons=" + str2;
        params += "&loginID=" + parent.PROGRESS_VIEW_HEADER.DPProgressViewHeader.loginID.value;

        var resultMsg = callDPCommonAjaxPostProc("SaveDPProgress", params);
        if (resultMsg == "Y") {
            alert("저장 완료");

            var urlStr = "stxPECDPProgressViewMain_SP.jsp?projectNo=" + DPProgressViewMain.projectNo.value;
            urlStr += "&deptCode=" + DPProgressViewMain.deptCode.value;
            urlStr += "&designerID=" + DPProgressViewMain.designerID.value;
            urlStr += "&dateFrom=" + DPProgressViewMain.dateFrom.value;
            urlStr += "&dateTo=" + DPProgressViewMain.dateTo.value;
            urlStr += "&dateCondition=" + DPProgressViewMain.dateCondition.value;
            urlStr += "&drawingNo1=" + DPProgressViewMain.drawingNo1.value;
            urlStr += "&drawingNo2=" + DPProgressViewMain.drawingNo2.value;
            urlStr += "&drawingNo3=" + DPProgressViewMain.drawingNo3.value;
            urlStr += "&drawingNo4=" + DPProgressViewMain.drawingNo4.value;
            urlStr += "&drawingNo5=" + DPProgressViewMain.drawingNo5.value;
            urlStr += "&drawingNo6=" + DPProgressViewMain.drawingNo6.value;
            urlStr += "&drawingNo7=" + DPProgressViewMain.drawingNo7.value;
            urlStr += "&drawingNo8=" + DPProgressViewMain.drawingNo8.value;
            urlStr += "&isManager=" + DPProgressViewMain.isManager.value;
            urlStr += "&isAdmin=" + DPProgressViewMain.isAdmin.value;
            urlStr += "&userDept=" + DPProgressViewMain.userDept.value;
            urlStr += "&showMsg=false";
            parent.PROGRESS_VIEW_MAIN.location = urlStr;
        }
        else alert("에러 발생");
    }

    // 담당자 선택화면 외 다른 부분을 클릭 시 담당자 선택화면을 Hidden
    function mouseClickHandler(e)
    {
        if (personsListDiv == null) return;

        if (isNewShow) {
            isNewShow = false;
            return;
        }

        var posX = event.clientX + document.body.scrollLeft;
        var posY = event.clientY + document.body.scrollTop;
        var objPos = getAbsolutePosition(personsListDiv);
        if (posX < objPos.x || posX > objPos.x + personsListDiv.offsetWidth || posY < objPos.y  || posY > objPos.y + personsListDiv.offsetHeight)
        {
            hidePartPersonSelect();
        }
    }

    // 도면 Title 부분 MouseOver 시 도면 Title Full Text를 힌트 형태로 표시
    var hintcontainer = null;   
    function showhint(obj, txt) {   
       if (hintcontainer == null) {   
          hintcontainer = document.createElement("div");   
          hintcontainer.className = "hintstyle";   
          document.body.appendChild(hintcontainer);   
       }   
       obj.onmouseout = hidehint;   
       obj.onmousemove = movehint;   
       hintcontainer.innerHTML = txt;   
    }   
    function movehint(e) {   
        if (!e) e = event; // line for IE compatibility   
        hintcontainer.style.top =  (e.clientY + document.documentElement.scrollTop + 2) + "px";   
        hintcontainer.style.left = (e.clientX + document.documentElement.scrollLeft + 10) + "px";   
        hintcontainer.style.display = "";   
    }   
    function hidehint() {   
       hintcontainer.style.display = "none";   
    }   

    // 도면타입에 따라 Header 부분 선택 값을 변경(: Color-Highlight 로 표시)
    function trOnMouseOver(dwgCode)
    {
        if (dwgCode != null && dwgCode.indexOf("V") == 0) {
            document.getElementById('yardDrawingHeader1').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader2').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader3').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader4').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader5').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader6').style.backgroundColor = '#e5e5e5';
            document.getElementById('yardDrawingHeader7').style.backgroundColor = '#e5e5e5';

            document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#32cd32';
            document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#32cd32';

            document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
        }
        else {
            document.getElementById('vendorDrawingHeader1').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader2').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader3').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader4').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader5').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader6').style.backgroundColor = '#e5e5e5';
            document.getElementById('vendorDrawingHeader7').style.backgroundColor = '#e5e5e5';

            document.getElementById('yardDrawingHeader1').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader2').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader3').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader4').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader5').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader6').style.backgroundColor = '#32cd32';
            document.getElementById('yardDrawingHeader7').style.backgroundColor = '#32cd32';

            document.getElementById('commonDrawingHeader1').style.backgroundColor = '#32cd32';
        }
    }

    // 도면 개정정보화면 POPUP
    function showDeployRevInfo(dwgCode)
    {
    	return;
        var sProperties = 'dialogHeight:400px;dialogWidth:800px;scroll=no;center:yes;status=no;';
        var url = "stxPECDPDwgRevisionHistoryView_SP.jsp?projectNo=" + DPProgressViewMain.projectNo.value;
        url += "&dwgNo=" + dwgCode;
        //var result = window.showModalDialog(url, "", sProperties);
        showModalDialog(url, "800", "420", true); // url, width, height, scrollbars
    }

    // 컬럼 숨기고 보이기 1
    function setColumnVisibility1(checked, colIdx)
    {
        var headerTable = document.getElementById("table_header1");
        var dataTable = document.getElementById("table_data1");
        var headerDiv2 = document.getElementById("header_right");
        var dataDiv2 = document.getElementById("list_right");

        var colIdx2 = colIdx;
        if (colIdx  > 5) colIdx2 += 2;
        var colWidth = parseInt(headerTable.rows[0].cells[colIdx].width);

        //var displayStr = '';
        //if (checkboxObj.checked) displayStr = 'none';
        //headerTable.rows[0].cells[colIdx].style.display = displayStr;

        //for (var i = 0; dataTable != null && i < dataTable.rows.length; i++) {
        //    dataTable.rows[i].cells[colIdx2].style.display = displayStr;
        //    if (colIdx == 5) {
        //        dataTable.rows[i].cells[colIdx2 + 1].style.display = displayStr;
        //        dataTable.rows[i].cells[colIdx2 + 2].style.display = displayStr;
        //    }
        //}


        var fixConstant = 1;
        if (colIdx == 5) fixConstant = 2;

        if (checked) {
            headerDiv2.style.left = parseInt(headerDiv2.style.left) - colWidth - fixConstant;
            headerDiv2.style.width = parseInt(headerDiv2.style.width) + colWidth + fixConstant;
            if (dataDiv2 != null) {
                dataDiv2.style.left = parseInt(dataDiv2.style.left) - colWidth - fixConstant;
                dataDiv2.style.width = parseInt(dataDiv2.style.width) + colWidth + fixConstant;
            }
        }
        else {
            headerDiv2.style.left = parseInt(headerDiv2.style.left) + colWidth + fixConstant;
            headerDiv2.style.width = parseInt(headerDiv2.style.width) - colWidth - fixConstant;
            if (dataDiv2 != null) {
                dataDiv2.style.left = parseInt(dataDiv2.style.left) + colWidth + fixConstant;
                dataDiv2.style.width = parseInt(dataDiv2.style.width) - colWidth - fixConstant;
            }
        }
    }

    // 컬럼 숨기고 보이기 2
    function setColumnVisibility2(checkboxObj, colIdx)
    {
        var headerTable = document.getElementById("table_header2");
        var dataTable = document.getElementById("table_data2");

        //var displayStr = '';
        //if (checkboxObj.checked) displayStr = 'none';
        //headerTable.rows[0].cells[colIdx].style.display = displayStr;
        //if (colIdx != 8) headerTable.rows[1].cells[colIdx].style.display = displayStr;
        //headerTable.rows[2].cells[colIdx].style.display = displayStr;
        //headerTable.rows[2].cells[colIdx + 1].style.display = displayStr;
        //for (var i = 0; dataTable != null && i < dataTable.rows.length; i++) {
        //    dataTable.rows[i].cells[colIdx].style.display = displayStr;
        //    dataTable.rows[i].cells[colIdx + 1].style.display = displayStr;
        //}

        colIdx = colIdx * 2;

        var headerTableWidth = 0;
        for (var i = 0; i < headerTable.rows[2].cells.length; i++) {
            if (headerTable.rows[2].cells[i].style.display != 'none') 
                headerTableWidth += parseInt(headerTable.rows[2].cells[i].width);
        }
        headerTable.style.width = headerTableWidth;
    }

    // load 시 컬럼 표시/숨김 적용
    if ('<%=c1Display%>' == 'none') setColumnVisibility1(true, 1);
    if ('<%=c2Display%>' == 'none') setColumnVisibility1(true, 2);
    if ('<%=c3Display%>' == 'none') setColumnVisibility1(true, 3);
    if ('<%=c4Display%>' == 'none') setColumnVisibility1(true, 4);
    if ('<%=c5Display%>' == 'none') setColumnVisibility1(true, 5);
    if ('<%=c6Display%>' == 'none') setColumnVisibility1(true, 6);
    if ('<%=c7Display%>' == 'none') setColumnVisibility1(true, 7);
    if ('<%=c8Display%>' == 'none') setColumnVisibility2(null, 0);
    if ('<%=c9Display%>' == 'none') setColumnVisibility2(null, 1);
    if ('<%=c10Display%>' == 'none') setColumnVisibility2(null, 2);
    if ('<%=c11Display%>' == 'none') setColumnVisibility2(null, 3);
    if ('<%=c12Display%>' == 'none') setColumnVisibility2(null, 4);
    if ('<%=c13Display%>' == 'none') setColumnVisibility2(null, 5);
    if ('<%=c14Display%>' == 'none') setColumnVisibility2(null, 6);
    if ('<%=c15Display%>' == 'none') setColumnVisibility2(null, 7);

    //20101216 kuni start - 해상도 변경
	//var screenWidth = window.screen.width;
	//var screenHeight = window.screen.height;
	var screenWidth = window.document.body.clientWidth;
	var screenHeight = window.document.body.clientHeight;
	
	//alert("현재 해상도 : " + screenWidth + " X " + screenHeight);
	
	if(screenWidth>2375)
		screenWidth = 2375;
	
	//alert(window.document.body.clientWidth);
	//alert(window.document.body.clientHeight);
	
	//Table 해상도 변경
	document.getElementById("data_table").width 				= screenWidth - 40;

	//Header Left(TD) 해상도 변경
	//document.getElementById("td_header_no").width 				= screenWidth*0.52*0.04;
	//document.getElementById("td_header_project").width 			= screenWidth*0.52*0.08;
	//document.getElementById("td_header_part").width 			= screenWidth*0.52*0.14;
	//document.getElementById("td_header_drawingno").width 		= screenWidth*0.52*0.1;
	//document.getElementById("td_header_zone").width 			= screenWidth*0.52*0.06;
	//document.getElementById("td_header_outsourcingplan").width 	= screenWidth*0.52*0.12;
	//document.getElementById("td_header_task").width 			= screenWidth*0.52*0.38;
	//document.getElementById("td_header_user").width 			= screenWidth*0.52*0.08;
	
	var header_left_width = parseInt(document.getElementById("td_header_no").width);
	if(document.getElementById("td_header_project").style.display 			== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_project").width);}
	if(document.getElementById("td_header_part").style.display 				== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_part").width);}
	if(document.getElementById("td_header_drawingno").style.display 		== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_drawingno").width);}
	if(document.getElementById("td_header_zone").style.display 				== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_zone").width);}
	if(document.getElementById("td_header_outsourcingplan").style.display 	== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_outsourcingplan").width);}
	if(document.getElementById("td_header_task").style.display 				== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_task").width);}
	if(document.getElementById("td_header_user").style.display 				== "block"){header_left_width = parseInt(header_left_width) + parseInt(document.getElementById("td_header_user").width);}
	
	//Header Left(DIV) 해상도 변경
	//document.getElementById("header_left").style.width 			= (parseInt(header_left_width) + 10) + "px";
	
	//List Left(TD) 해상도 변경
	try{
		//document.getElementById("td_list_no").width 				= screenWidth*0.52*0.04;
		//document.getElementById("td_list_project").width 			= screenWidth*0.52*0.08;
		//document.getElementById("td_list_part").width 				= screenWidth*0.52*0.14;
		//document.getElementById("list_part").style.width 			= screenWidth*0.52*0.12 + "px";
		//document.getElementById("td_list_drawingno").width 			= screenWidth*0.52*0.1;
		//document.getElementById("td_list_zone").width 				= screenWidth*0.52*0.06;
		//document.getElementById("td_list_outsourcingplan1").width 	= screenWidth*0.52*0.04;
		//document.getElementById("td_list_outsourcingplan2").width 	= screenWidth*0.52*0.04;
		//document.getElementById("td_list_outsourcingplan3").width 	= screenWidth*0.52*0.04;
		//document.getElementById("td_list_task").width 				= screenWidth*0.52*0.38;
		//document.getElementById("list_task").style.width 			= screenWidth*0.52*0.37 + "px";
		//document.getElementById("td_list_user").width 				= screenWidth*0.52*0.08;
	}catch(e){
	
	}
	
	//List Left(DIV) 해상도 변경
	//document.getElementById("list_left").style.width 			= (parseInt(header_left_width) + 27) + "px";
	//document.getElementById("list_left").style.height 			= screenHeight*0.57 + "px";
	document.getElementById("list_left").style.height 			= screenHeight*0.88 + "px";
	
	//Header Right(TD) 해상도 변경
	document.getElementById("td_header_right").width 			= screenWidth - parseInt(header_left_width) - 40;
	
	//Header Right(DIV) 해상도 변경
	document.getElementById("header_right").style.width 		= (screenWidth - parseInt(header_left_width) - 37) + "px";
	document.getElementById("header_right").style.left 			= (parseInt(header_left_width)+1) + "px";
	
	//List Right(TD) 해상도 변경
	document.getElementById("td_list_right").width 				= screenWidth - parseInt(header_left_width) - 40;
	
	//List Right(DIV) 해상도 변경
	document.getElementById("list_right").style.width 			= (screenWidth - parseInt(header_left_width) - 23) + "px";
	//document.getElementById("list_right").style.height 			= screenHeight*0.57 + "px";
	document.getElementById("list_right").style.height 			= screenHeight*0.88 + "px";
	document.getElementById("list_right").style.left 			= (parseInt(header_left_width)+1) + "px";
	
	//alert("해상도 변경 완료");
	//20101216 kuni end

	// 조회 완료 메시지 
    <% if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
        alert("조회 완료");
    <% } %>

    /*
    // Admin 인 경우 삭제버튼을 보이고 버튼 클릭 시 Action Date 값을 삭제
    function showDeleteButton(tdObject, activityCode, startFinishCode, currentData)
    {
        if (DPProgressViewMain.isAdmin.value != "Y") return; // Admin이 아니면 exit
        if (tdObject.innerHTML == "") return; // 값이 있는 경우만 해당

        delBtnDiv.style.left = tdObject.offsetLeft; // dummyDiv & dummyText 는 칼렌다 팝업 위치 및 칼렌다 선택 값을 얻기 위해 필요
        delBtnDiv.style.top = tdObject.offsetTop;
        delBtnDiv.style.display = '';

        activeTDObject = tdObject;
        activeActivityCode = activityCode + "|" + startFinishCode;
    }

    // 삭제버튼 표시를 숨김
    function hiddenDeleteButton()
    {
        var posX = event.clientX;
        var posY = event.clientY;
        if (posX < activeTDObject.offsetLeft || posX > activeTDObject.offsetLeft + activeTDObject.offsetWidth ||
            posY < activeTDObject.offsetTop  || posY > activeTDObject.offsetTop + activeTDObject.offsetHeight)
        {
            delBtnDiv.style.display = 'none'
        }
    }

    // 선택된 Action Date를 삭제
    function deleteActionDate()
    {
        if (activeActivityCode != "") {
            if (DPProgressViewMain.TO_DELETE_LIST.value == "") DPProgressViewMain.TO_DELETE_LIST.value = activeActivityCode;
            else DPProgressViewMain.TO_DELETE_LIST.value += "," + activeActivityCode;
        }
        if (activeTDObject != null) activeTDObject.innerHTML = "";
    }
    */
    
    //20101228 kuni start - Column Sort
	function viewDPProgress(sortValue , sortType)
    {
        var urlStr = "stxPECDPProgressViewMain_SP.jsp?projectNo=" + parent.frames[0].DPProgressViewHeader.projectList.value;
        urlStr += "&deptCode=" + parent.frames[0].DPProgressViewHeader.departmentList.value;
        urlStr += "&designerID=" + parent.frames[0].DPProgressViewHeader.designerList.value;
        urlStr += "&dateFrom=" + parent.frames[0].DPProgressViewHeader.dateSelectedFrom.value;
        urlStr += "&dateTo=" + parent.frames[0].DPProgressViewHeader.dateSelectedTo.value;
        urlStr += "&dateCondition=" + parent.frames[0].DPProgressViewHeader.dateCondition.value;
        urlStr += "&drawingNo1=" + parent.frames[0].DPProgressViewHeader.drawingNo1.value;
        urlStr += "&drawingNo2=" + parent.frames[0].DPProgressViewHeader.drawingNo2.value;
        urlStr += "&drawingNo3=" + parent.frames[0].DPProgressViewHeader.drawingNo3.value;
        urlStr += "&drawingNo4=" + parent.frames[0].DPProgressViewHeader.drawingNo4.value;
        urlStr += "&drawingNo5=" + parent.frames[0].DPProgressViewHeader.drawingNo5.value;
        urlStr += "&drawingNo6=" + parent.frames[0].DPProgressViewHeader.drawingNo6.value;
        urlStr += "&drawingNo7=" + parent.frames[0].DPProgressViewHeader.drawingNo7.value;
        urlStr += "&drawingNo8=" + parent.frames[0].DPProgressViewHeader.drawingNo8.value;
        urlStr += "&drawingTitle=" + parent.frames[0].DPProgressViewHeader.drawingTitle.value;
        urlStr += "&isManager=" + parent.frames[0].DPProgressViewHeader.isManager.value;
        urlStr += "&isAdmin=" + parent.frames[0].DPProgressViewHeader.isAdmin.value;
        urlStr += "&userDept=" + parent.frames[0].DPProgressViewHeader.dwgDepartmentCode.value;
        
        urlStr += "&c1=" + parent.frames[0].DPProgressViewHeader.colShowCheck1.checked;
        urlStr += "&c2=" + parent.frames[0].DPProgressViewHeader.colShowCheck2.checked;
        urlStr += "&c3=" + parent.frames[0].DPProgressViewHeader.colShowCheck3.checked;
        urlStr += "&c4=" + parent.frames[0].DPProgressViewHeader.colShowCheck4.checked;
        urlStr += "&c5=" + parent.frames[0].DPProgressViewHeader.colShowCheck5.checked;
        urlStr += "&c6=" + parent.frames[0].DPProgressViewHeader.colShowCheck6.checked;
        urlStr += "&c7=" + parent.frames[0].DPProgressViewHeader.colShowCheck7.checked;
        urlStr += "&c8=" + parent.frames[0].DPProgressViewHeader.colShowCheck8.checked;
        urlStr += "&c9=" + parent.frames[0].DPProgressViewHeader.colShowCheck9.checked;
        urlStr += "&c10=" + parent.frames[0].DPProgressViewHeader.colShowCheck10.checked;
        urlStr += "&c11=" + parent.frames[0].DPProgressViewHeader.colShowCheck11.checked;
        urlStr += "&c12=" + parent.frames[0].DPProgressViewHeader.colShowCheck12.checked;
        urlStr += "&c13=" + parent.frames[0].DPProgressViewHeader.colShowCheck13.checked;
        urlStr += "&c14=" + parent.frames[0].DPProgressViewHeader.colShowCheck14.checked;
        urlStr += "&c15=" + parent.frames[0].DPProgressViewHeader.colShowCheck15.checked;

		urlStr += "&sortValue=" + sortValue;
		urlStr += "&sortType=" + sortType;

        parent.PROGRESS_VIEW_MAIN.location = urlStr;
    }
    //20101228 kuni end
   
   // 20140527 Kang seonjung : 기자재 발주 관리 및 DP일정 통합관리 등록 PR, PO 세부 정보 view
	function searchPrPoInfo(drawingNo)
	{
	    
	    var url = "stxPECDPProgressViewPrPoInfoFS_SP.jsp?projectNo=" + DPProgressViewMain.projectNo.value;
	        url += "&drawingNo="+drawingNo;

	    var nwidth = 1250;
	    var nheight = 500;
	    var LeftPosition = (screen.availWidth-nwidth)/2;
	    var TopPosition = (screen.availHeight-nheight)/2;
	
	    var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;
	
	    window.open(url,"",sProperties);
	}    
</script>

</body>

</html>