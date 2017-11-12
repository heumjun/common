<%--  
§DESCRIPTION: 도면 출도 건 수 조회 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgDeployedCountMain.jsp
§CHANGING HISTORY: 
§    2010-03-26: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@page import="java.text.*"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%!

    // getReasonCodeList() : ECO CODE 목록을 조회
    private ArrayList getReasonCodeList() throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
        java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
            
            StringBuffer queryStr = new StringBuffer();

            queryStr.append("SELECT ECO_GROUP,                                                ");
            queryStr.append("       (SELECT COUNT(1)                                          ");
            queryStr.append("          FROM PLM_CODE_TBL C                                    ");
            queryStr.append("         WHERE C.CATEGORY = 'ECO_CODE'                           ");
            queryStr.append("           AND SUBSTR(C.KEY, 1, 1) = SUBSTR(ECO_CODE, 1, 1)      ");
            queryStr.append("       ) AS CODE_CNT,                                            ");
            queryStr.append("       ECO_CODE                                                  ");
            queryStr.append("  FROM (                                                         ");
            queryStr.append("        SELECT (SELECT B.VALUE                                   ");
            queryStr.append("                  FROM PLM_CODE_TBL B                            ");
            queryStr.append("                 WHERE B.CATEGORY = 'ECO_GROUP'                  ");
            queryStr.append("                   AND B.KEY = SUBSTR(A.KEY, 1, 1)               ");
            queryStr.append("               ) AS ECO_GROUP,                                   ");
            queryStr.append("               A.KEY AS ECO_CODE                                 ");
            queryStr.append("          FROM PLM_CODE_TBL A                                    ");
            queryStr.append("         WHERE A.CATEGORY = 'ECO_CODE'                           ");
            queryStr.append("         ORDER BY A.CATEGORY                                     ");
            queryStr.append("       )                                                         ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("ECO_GROUP", rset.getString(1));
				resultMap.put("CODE_CNT", rset.getString(2));
				resultMap.put("ECO_CODE", rset.getString(3));
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

	// getHardCopyDwgDeployedCntList() : 도면 출도 건 수 조회
	private ArrayList getHardCopyDwgDeployedCntList(String projectInput, String deptCode, String dateFrom, String dateTo, 
	                                              String includeSeries, String includeEarlyRev) throws Exception
	{
		if (StringUtil.isNullString(dateFrom) || StringUtil.isNullString(dateTo)) throw new Exception("Date String is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt1 = null;
		java.sql.Statement stmt2 = null;
        java.sql.Statement stmt3 = null;
        java.sql.Statement stmt4 = null;
		java.sql.ResultSet rset1 = null;
		java.sql.ResultSet rset2 = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

            ArrayList projectList = FrameworkUtil.split(projectInput, ",");
            String sProjects = "";
            for (int i = 0; i < projectList.size(); i++) {
                String sTemp = (String)projectList.get(i);
                sTemp = sTemp.trim();
                if (i > 0) sProjects += ",";
                sProjects += "'" + sTemp + "'";
            }

            // 1. GET SESSION ID
            stmt1 = conn.createStatement();
            rset1 = stmt1.executeQuery("SELECT USERENV('SESSIONID') FROM DUAL@STXERP");
            rset1.next();
            String sSessionId = rset1.getString(1);

            // 2. CLEAR TEMPORARY TABLE
            stmt2 = conn.createStatement();
            stmt2.executeUpdate("DELETE FROM STX_DWG_DPS_TEMPORARY@STXERP WHERE SESSION_ID = '" + sSessionId + "'");

            // 3. INSERT INTO TEMPORARY TABLE
            String sQueryStr = "INSERT INTO STX_DWG_DPS_TEMPORARY@STXERP(SESSION_ID, DWG_DATE_FROM, DWG_DATE_TO, PROJECT_NO, DEPT_CODE) " + 
                               "VALUES ('" + sSessionId + "',                                                                           " + 
                               "        TO_DATE('" + dateFrom + "', 'YYYY-MM-DD'),                                                      " + 
                               "        TO_DATE('" + dateTo + "', 'YYYY-MM-DD'),                                                        ";
            if (projectList.size() == 1)
                sQueryStr +=   "        '" + ((String)projectList.get(0)).trim() + "',                                                  ";
            else 
                sQueryStr +=   "        NULL,                                                                                           ";
            if (!deptCode.equals(""))
                sQueryStr +=   "        '" + deptCode + "')                                                                             ";
            else 
                sQueryStr +=   "        NULL)                                                                                           ";
            
            stmt3 = conn.createStatement();
            stmt3.executeUpdate(sQueryStr);

            // 4. MAIN QUERY
			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT (SELECT C.DEPT_NAME                                                                                ");
            queryStr.append("         FROM STX_COM_INSA_DEPT@STXERP C	                                                               ");
            queryStr.append("        WHERE C.DEPT_CODE = B.PARENT_CODE) AS UP_DEPT_NAME,                                               ");
            queryStr.append("       A.DEPT_NAME,                                                                                       ");
            queryStr.append("       A.REASON_CODE,                                                                                     ");
            queryStr.append("       A.CNT                                                                                              ");
            queryStr.append("  FROM (                                                                                                  ");
            queryStr.append("        SELECT DEPT_NAME,                                                                                 ");
            queryStr.append("               REASON_CODE,                                                                               ");
            queryStr.append("               COUNT(1) AS CNT                                                                            ");
            queryStr.append("          FROM (                                                                                          ");
            /* 아래 부분은 도면출도내역 조회와 동일한 쿼리 */
            queryStr.append("SELECT PROJECT_NO                                                                                         ");
            queryStr.append("      ,DEPT_NAME                                                                                          ");
            queryStr.append("      ,DWG_NO                                                                                             ");
            queryStr.append("      ,DWG_TITLE                                                                                          ");
            queryStr.append("      ,USER_NAME                                                                                          ");
            queryStr.append("      ,DEPLOY_REV                                                                                         ");
            queryStr.append("      ,TO_CHAR(REQUEST_DATE, 'YYYY-MM-DD')                                                                ");
            queryStr.append("      ,TO_CHAR(DEPLOY_DATE, 'YYYY-MM-DD')                                                                 ");
            queryStr.append("      ,REASON_CODE                                                                                        ");
            queryStr.append("      ,CAUSE_DEPART                                                                                       ");
            queryStr.append("      ,DEPLOY_DESC                                                                                        ");
            queryStr.append("      ,SERIAL                                                                                             ");
            queryStr.append("      ,TO_CHAR(ACTUALFINISHDATE, 'YYYY-MM-DD')                                                            ");
            queryStr.append("      ,REV_TIMING                                                                                         ");
            queryStr.append("      ,SOURCE                                                                                             ");
            queryStr.append("  FROM (                                                                                                  ");
            queryStr.append("        SELECT A.PROJECT_NO        AS PROJECT_NO                                                          ");
            queryStr.append("              ,A.DEPT_NAME         AS DEPT_NAME                                                           ");
            queryStr.append("              ,A.DWG_NO            AS DWG_NO                                                              ");
            queryStr.append("              ,A.DWG_DESCRIPTION   AS DWG_TITLE                                                           ");
            queryStr.append("              ,A.USER_NAME         AS USER_NAME                                                           ");
            queryStr.append("              ,A.DWG_REV           AS DEPLOY_REV                                                          ");
            queryStr.append("              ,NULL                AS REQUEST_DATE                                                        ");
            queryStr.append("              ,A.DWG_INP_DATE      AS DEPLOY_DATE                                                         ");
            queryStr.append("              ,A.ECO_REASON        AS REASON_CODE                                                         ");
            queryStr.append("              ,NULL                AS CAUSE_DEPART                                                        ");
            queryStr.append("              ,A.ECO_DESC          AS DEPLOY_DESC                                                         ");
            queryStr.append("              ,C.DWGSERIESSERIALNO AS SERIAL                                                              ");
            queryStr.append("              ,(SELECT C.ACTUALFINISHDATE                                                                 ");
            queryStr.append("                  FROM PLM_ACTIVITY C                                                                     ");
            queryStr.append("                 WHERE C.WORKTYPE = 'DW'                                                                  ");
            queryStr.append("                   AND C.PROJECTNO = A.PROJECT_NO                                                         ");
            queryStr.append("                   AND C.ACTIVITYCODE LIKE A.DWG_NO || '%'                                                ");
            queryStr.append("                )                  AS ACTUALFINISHDATE                                                    ");
            queryStr.append("              ,F_GET_PLM_ACTIVITY(A.PROJECT_NO, A.DWG_NO, A.DWG_INP_DATE)                                 ");
            queryStr.append("                                   AS REV_TIMING                                                          ");
            queryStr.append("              ,'D' AS SOURCE                                                                              ");
            queryStr.append("          FROM STX_DWG_DPS_ECO_LIST_V@STXERP A                                                            ");
            queryStr.append("              ,PLM_SEARCHABLE_PROJECT        B                                                            ");
            queryStr.append("              ,LPM_NEWPROJECT                C                                                            ");
            queryStr.append("         WHERE 1 = 1                                                                                      ");
            queryStr.append("           AND A.SESSION_ID        = '" + sSessionId + "'                                                 ");
            queryStr.append("           AND A.PROJECT_NO        = B.PROJECTNO                                                          ");
            queryStr.append("           AND B.CATEGORY          = 'DEPLOY'                                                             ");
            queryStr.append("           AND B.STATE             <> 'CLOSED'                                                            ");
            queryStr.append("           AND B.PROJECTNO         = C.PROJECTNO                                                          ");
            queryStr.append("           AND C.CASENO            = '1'                                                                  ");
            if (!sProjects.equals("")) 
            queryStr.append("           AND A.PROJECT_NO IN (" + sProjects + ")                                                        ");
            if (sProjects.equals("") && includeSeries.equalsIgnoreCase("false"))
            queryStr.append("           AND C.DWGSERIESSERIALNO = '0'                                                                  ");
            queryStr.append("        UNION ALL                                                                                         ");
            queryStr.append("        SELECT A.PROJECT_NO         AS PROJECT_NO                                                         ");
            queryStr.append("              ,E.DEPT_NAME          AS DEPT_NAME                                                          ");
            queryStr.append("              ,A.DWG_CODE           AS DWG_NO                                                             ");
            queryStr.append("              ,A.DWG_TITLE          AS DWG_TITLE                                                          ");
            queryStr.append("              ,D.NAME               AS USER_NAME                                                          ");
            queryStr.append("              ,A.DEPLOY_REV         AS DEPLOY_REV                                                         ");
            queryStr.append("              ,A.REQUEST_DATE       AS REQUEST_DATE                                                       ");
            queryStr.append("              ,A.DEPLOY_DATE        AS DEPLOY_DATE                                                        ");
            queryStr.append("              ,A.REASON_CODE        AS REASON_CODE                                                        ");
            queryStr.append("              ,F.DEPT_NAME          AS CAUSE_DEPART                                                       ");
            queryStr.append("              ,A.DEPLOY_DESC        AS DEPLOY_DESC                                                        ");
            queryStr.append("              ,C.DWGSERIESSERIALNO  AS SERIAL                                                             ");
            queryStr.append("              ,DW.ACTUALFINISHDATE  AS ACTUALFINISHDATE                                                   ");
            queryStr.append("              ,A.REV_TIMING         AS REV_TIMING                                                         ");
            queryStr.append("              ,'H' AS SOURCE                                                                              ");
            queryStr.append("          FROM PLM_HARDCOPY_DWG A,                                                                        ");
            queryStr.append("               PLM_SEARCHABLE_PROJECT B,                                                                  ");
            queryStr.append("               LPM_NEWPROJECT C,                                                                          ");
            queryStr.append("               CCC_SAWON D,                                                                               ");
            queryStr.append("               STX_COM_INSA_DEPT@STXERP E,                                                                ");
            queryStr.append("               STX_COM_INSA_DEPT@STXERP F,                                                                ");
            queryStr.append("               (SELECT C.PROJECTNO, C.ACTIVITYCODE, C.PLANSTARTDATE, C.DWGCATEGORY, C.ACTUALFINISHDATE    ");
            queryStr.append("                  FROM PLM_ACTIVITY C                                                                     ");
            queryStr.append("                 WHERE C.WORKTYPE = 'DW'                                                                  ");
            queryStr.append("               ) DW                                                                                       ");
            queryStr.append("         WHERE 1 = 1                                                                                      ");
            queryStr.append("           AND A.PROJECT_NO        = B.PROJECTNO                                                          ");
            queryStr.append("           AND B.PROJECTNO         = C.PROJECTNO                                                          ");
            queryStr.append("           AND B.CATEGORY          = 'DEPLOY'                                                             ");
            queryStr.append("           AND B.STATE             <> 'CLOSED'                                                            ");
            queryStr.append("           AND C.CASENO            = '1'                                                                  ");
            queryStr.append("           AND A.EMPLOYEE_NO       = D.EMPLOYEE_NUM                                                       ");
            queryStr.append("           AND A.DEPT_CODE         = E.DEPT_CODE                                                          ");
            queryStr.append("           AND A.CAUSE_DEPART      = F.DEPT_CODE(+)                                                       ");
            queryStr.append("           AND A.PROJECT_NO        = DW.PROJECTNO(+)                                                      ");
            queryStr.append("           AND A.DWG_CODE          = SUBSTR(DW.ACTIVITYCODE(+), 1, 8)                                     ");
            if (sProjects.equals("") && includeSeries.equalsIgnoreCase("false")) 
            queryStr.append("           AND C.DWGSERIESSERIALNO = '0'                                                                  ");
            if (!sProjects.equals("")) 
            queryStr.append("           AND A.PROJECT_NO IN (" + sProjects + ")                                                        ");
            if (!deptCode.equals(""))
            queryStr.append("           AND A.DEPT_CODE = '" + deptCode + "'                                                           ");
            queryStr.append("           AND A.REQUEST_DATE      >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                           ");
            queryStr.append("           AND A.REQUEST_DATE      <= TO_DATE('" + dateTo + "', 'YYYY-MM-DD')                             ");
            if (includeEarlyRev.equalsIgnoreCase("false")) {
            queryStr.append("           AND (A.REV_TIMING = '시공 후' OR A.REV_TIMING LIKE '설계 후%' OR A.REV_TIMING LIKE '제작 후%'  ");
            queryStr.append("                OR A.REV_TIMING LIKE '절단 후%')                                                          ");
            }
            queryStr.append("       )                                                                                                  ");
            if (includeEarlyRev.equalsIgnoreCase("false")) {
            queryStr.append(" WHERE (REV_TIMING = '시공 후' OR REV_TIMING LIKE '설계 후%' OR REV_TIMING LIKE '제작 후%'                ");
            queryStr.append("        OR REV_TIMING LIKE '절단 후%' OR REV_TIMING IS NULL)                                              ");
            }
            //queryStr.append(" ORDER BY PROJECT_NO, DEPT_NAME, DWG_NO, DEPLOY_DATE                                                      ");
            /* 여기까지 도면출도내역 조회와 동일한 쿼리 */
            queryStr.append("               )                                                                                          ");
            queryStr.append("         GROUP BY DEPT_NAME, REASON_CODE                                                                  ");
            queryStr.append("         ORDER BY DEPT_NAME                                                                               ");
            queryStr.append("       ) A,                                                                                               ");
            queryStr.append("       STX_COM_INSA_DEPT@STXERP B                                                                         ");
            queryStr.append(" WHERE 1 = 1                                                                                              ");
            queryStr.append("   AND A.DEPT_NAME = B.DEPT_NAME                                                                          ");

            stmt4 = conn.createStatement();
            rset2 = stmt4.executeQuery(queryStr.toString());

			while (rset2.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("UP_DEPT_NAME", rset2.getString(1) == null ? "" : rset2.getString(1).trim());
				resultMap.put("DEPT_NAME", rset2.getString(2) == null ? "" : rset2.getString(2).trim());
				resultMap.put("REASON_CODE", rset2.getString(3).trim());
				resultMap.put("CNT", rset2.getString(4).trim());
				resultArrayList.add(resultMap);
			}

            // 5. CLEAR TEMPORARY TABLE
            stmt2.executeUpdate("DELETE FROM STX_DWG_DPS_TEMPORARY@STXERP WHERE SESSION_ID = '" + sSessionId + "'");
		}
		finally {
			if (rset1 != null) rset1.close();
			if (rset2 != null) rset2.close();
			if (stmt1 != null) stmt1.close();
			if (stmt2 != null) stmt2.close();
			if (stmt3 != null) stmt3.close();
			if (stmt4 != null) stmt4.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
	}

%>

<%--========================== JSP =========================================--%>
<%
    String projectList = StringUtil.setEmptyExt(emxGetParameter(request, "projectList"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String includeSeries = StringUtil.setEmptyExt(emxGetParameter(request, "includeSeries"));
    String includeEarlyRev = StringUtil.setEmptyExt(emxGetParameter(request, "includeEarlyRev"));
    String showMsg = StringUtil.setEmptyExt(emxGetParameter(request, "showMsg"));
    String firstLoad = StringUtil.setEmptyExt(emxGetParameter(request, "firstLoad"));
    String isAdmin = StringUtil.setEmptyExt(emxGetParameter(request, "isAdmin"));

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
    ArrayList reasonCodeList = null;
    ArrayList hardCopyDwgDeployedCntList = null;

    try {
        reasonCodeList = getReasonCodeList();

        if (!firstLoad.equalsIgnoreCase("true")) {
            hardCopyDwgDeployedCntList = getHardCopyDwgDeployedCntList(projectList, 
                                                                       deptCode, 
                                                                       dateFrom, 
                                                                       dateTo, 
                                                                       includeSeries, 
                                                                       includeEarlyRev);
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPHardCopyDwgViewMain" action="post">
    
    <br>

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
        <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
            <tr height="20" bgcolor="#e5e5e5">
                <td class="td_smallLRMarginBlue" rowspan="2">팀</td>
                <td class="td_smallLRMarginBlue" rowspan="2">파트</td>
                <%
                String sCurrentECOGroup = "";

                for (int i = 0; i < reasonCodeList.size(); i++)
                {
                    java.util.Map map = (Map)reasonCodeList.get(i);

                    String sCodeGroup = (String)map.get("ECO_GROUP");
                    String sCodeCnt = (String)map.get("CODE_CNT");
                    if (!sCurrentECOGroup.equals(sCodeGroup)) 
                    {
                        sCurrentECOGroup = sCodeGroup;
                        %>
                        <td class="td_smallLRMarginBlue" colspan="<%=sCodeCnt%>"><%=sCurrentECOGroup%></td>
                        <%
                    }
                }
                %>
                <td class="td_smallLRMarginBlue" rowspan="2">계</td>
            </tr>
            <tr height="20" bgcolor="#e5e5e5">
                <%
                for (int i = 0; i < reasonCodeList.size(); i++)
                {
                    java.util.Map map = (Map)reasonCodeList.get(i);

                    String sCode = (String)map.get("ECO_CODE");
                    %>
                    <td class="td_smallLRMarginBlue"><%=sCode%></td>
                    <%
                }
                %>
            </tr>
            
            <%
            // 부서(파트) 별로 도면출도 건 수를 수집
            ArrayList hardCopyDwgDeployedCntList2 = new ArrayList();

            for (int i = 0; hardCopyDwgDeployedCntList != null && i < hardCopyDwgDeployedCntList.size(); i++)
            {
                java.util.Map map = (java.util.Map)hardCopyDwgDeployedCntList.get(i);
                String sTeamName = (String)map.get("UP_DEPT_NAME");
                String sDeptName = (String)map.get("DEPT_NAME");
                String sReasonCode = (String)map.get("REASON_CODE");
                String sCount = (String)map.get("CNT");

                java.util.Map map2 = null;
                for (int j = 0; j < hardCopyDwgDeployedCntList2.size(); j++) {
                    java.util.Map map3 = (java.util.Map)hardCopyDwgDeployedCntList2.get(j);
                    String sTeamName2 = (String)map3.get("UP_DEPT_NAME");
                    String sDeptName2 = (String)map3.get("DEPT_NAME");
                    if (sTeamName.equals(sTeamName2) && sDeptName.equals(sDeptName2)) {
                        map2 = map3;
                        break;
                    }
                }
                if (map2 == null) {
                    map2 = new HashMap();
                    map2.put("UP_DEPT_NAME", sTeamName);
                    map2.put("DEPT_NAME", sDeptName);
                    hardCopyDwgDeployedCntList2.add(map2);
                }

                map2.put(sReasonCode, sCount);
            }
			// DIS-ERROR :sort 기능 대체 필요할 듯.
            //hardCopyDwgDeployedCntList2.sort("UP_DEPT_NAME", "ascending", "string");

            // HTML로 출력
            String sCurrentTeamName = "";

            for (int i = 0; i < hardCopyDwgDeployedCntList2.size(); i++)
            {
                %>
                <tr height="20" style="background-color:#ffffff">
                <%

                java.util.Map map = (java.util.Map)hardCopyDwgDeployedCntList2.get(i);

                String sTeamName = (String)map.get("UP_DEPT_NAME");
                String sDeptName = (String)map.get("DEPT_NAME");

                if (!sCurrentTeamName.equals(sTeamName)) 
                {
                    sCurrentTeamName = sTeamName;

                    int iDeptCount = 0;
                    String sCurrentDeptName = "";

                    for (int j = 0; j < hardCopyDwgDeployedCntList2.size(); j++)
                    {
                        java.util.Map map2 = (java.util.Map)hardCopyDwgDeployedCntList2.get(j);
                        String sTeamName2 = (String)map2.get("UP_DEPT_NAME");
                        String sDeptName2 = (String)map2.get("DEPT_NAME");
                        if (sCurrentTeamName.equals(sTeamName2) && !sCurrentDeptName.equals(sDeptName2)) {
                            sCurrentDeptName = sDeptName2;
                            iDeptCount++;
                        }
                    }
                    
                    %>
                    <td class="td_standardSmall" rowspan="<%=iDeptCount%>" style="text-align:left;"><%=sCurrentTeamName%></td>
                    <%
                }

                %>
                <td class="td_standardSmall" style="text-align:left;"><%=sDeptName%></td>
                <%
                int iCountSum = 0;
                
                for (int j = 0; j < reasonCodeList.size(); j++)
                {
                    java.util.Map map2 = (java.util.Map)reasonCodeList.get(j);
                    String sCode = (String)map2.get("ECO_CODE");

                    String sCount = (String)map.get(sCode);
                    int iCount = StringUtil.isNullString(sCount) ? 0 : Integer.parseInt(sCount);
                    iCountSum += iCount;
                    
                    %>
                    <td class="td_standardSmall"><%=StringUtil.setEmptyExt(sCount)%></td>
                    <%                  

                    String sCountSumPerCode = (String)map2.get("COUNT_SUM");
                    int iCountSumPerCode = StringUtil.isNullString(sCountSumPerCode) ? 0 : Integer.parseInt(sCountSumPerCode);
                    iCountSumPerCode += iCount;
                    map2.put("COUNT_SUM", Integer.toString(iCountSumPerCode));
                }
                %>
                <td class="td_standardSmall"><%=iCountSum%></td>
                <%                  

                %>
                </tr>
                <%
            }
            %>

            <tr height="20" style="background-color:#ffffff">
                <td class="td_standardSmall" colspan="2">합계</td>                
                <%
                int iCountSumPerCodeTotal = 0;
                for (int i = 0; i < reasonCodeList.size(); i++)
                {
                    java.util.Map map = (java.util.Map)reasonCodeList.get(i);
                    String sCountSumPerCode = (String)map.get("COUNT_SUM");
                    int iCountSumPerCode = StringUtil.isNullString(sCountSumPerCode) ? 0 : Integer.parseInt(sCountSumPerCode);
                    iCountSumPerCodeTotal += iCountSumPerCode;
                    %>
                    <td class="td_standardSmall"><%=StringUtil.setEmptyExt(sCountSumPerCode)%></td>
                    <%                  
                }
                %>
                <td class="td_standardSmall"><%=iCountSumPerCodeTotal%></td>
            </tr>

        </table>
    <%
    }
    %>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script>

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;

    // 조회 완료 메시지 
    <% if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
        alert("조회 완료");
    <% } %>

</script>


</html>