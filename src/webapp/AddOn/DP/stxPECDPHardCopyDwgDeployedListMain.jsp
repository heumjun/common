<%--  
§DESCRIPTION: 도면 출도내역 조회 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgDeployedListMain.jsp
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

	// getHardCopyDwgDeployedList() : 도면 출도내역 조회
	private ArrayList getHardCopyDwgDeployedList(String projectInput, String deptCode, String dateFrom, String dateTo, 
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
            queryStr.append("      ,ECO_NO                                                                                             ");
            queryStr.append("      ,REV_TIMING2                                                                                        ");
            queryStr.append("  FROM (                                                                                                  ");
            queryStr.append("        SELECT A.PROJECT_NO        AS PROJECT_NO                                                          ");
            queryStr.append("              ,A.DEPT_NAME         AS DEPT_NAME                                                           ");
            queryStr.append("              ,A.DWG_NO            AS DWG_NO                                                              ");
            queryStr.append("              ,A.DWG_DESCRIPTION   AS DWG_TITLE                                                           ");
            queryStr.append("              ,A.USER_NAME         AS USER_NAME                                                           ");
            queryStr.append("              ,A.DWG_REV           AS DEPLOY_REV                                                          ");
            queryStr.append("              ,A.ECO_NO            AS ECO_NO                                                              ");
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
            queryStr.append("               AS REV_TIMING                                                                              ");
            queryStr.append("              ,NULL AS REV_TIMING2                                                                        ");
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
            queryStr.append("              ,A.ECO_NO             AS ECO_NO                                                             ");
            queryStr.append("              ,A.REQUEST_DATE       AS REQUEST_DATE                                                       ");
            queryStr.append("              ,A.DEPLOY_DATE        AS DEPLOY_DATE                                                        ");
            queryStr.append("              ,A.REASON_CODE        AS REASON_CODE                                                        ");
            queryStr.append("              ,F.DEPT_NAME          AS CAUSE_DEPART                                                       ");
            queryStr.append("              ,A.DEPLOY_DESC        AS DEPLOY_DESC                                                        ");
            queryStr.append("              ,C.DWGSERIESSERIALNO  AS SERIAL                                                             ");
            queryStr.append("              ,DW.ACTUALFINISHDATE  AS ACTUALFINISHDATE                                                   ");
            queryStr.append("              ,A.REV_TIMING         AS REV_TIMING                                                         ");
            queryStr.append("              ,F_GET_PLM_ACTIVITY(A.PROJECT_NO, A.DWG_CODE, A.REQUEST_DATE) AS REV_TIMING2                ");
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
            queryStr.append(" ORDER BY PROJECT_NO, DEPT_NAME, DWG_NO, DEPLOY_DATE                                                      ");

            stmt4 = conn.createStatement();
            rset2 = stmt4.executeQuery(queryStr.toString());

			while (rset2.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset2.getString(1));
				resultMap.put("DEPT_NAME", rset2.getString(2) == null ? "" : rset2.getString(2));
				resultMap.put("DWG_NO", rset2.getString(3));
				resultMap.put("DWG_TITLE", rset2.getString(4) == null ? "" : rset2.getString(4));
				resultMap.put("USER_NAME", rset2.getString(5) == null ? "" : rset2.getString(5));
				resultMap.put("DEPLOY_REV", rset2.getString(6) == null ? "" : rset2.getString(6));
				resultMap.put("REQUEST_DATE", rset2.getString(7) == null ? "" : rset2.getString(7));
				resultMap.put("DEPLOY_DATE", rset2.getString(8) == null ? "" : rset2.getString(8));
				resultMap.put("REASON_CODE", rset2.getString(9) == null ? "" : rset2.getString(9));
				resultMap.put("CAUSE_DEPART", rset2.getString(10) == null ? "" : rset2.getString(10));
				resultMap.put("DEPLOY_DESC", rset2.getString(11) == null ? "" : rset2.getString(11));
				resultMap.put("SERIAL", rset2.getString(12) == null ? "" : rset2.getString(12));
				resultMap.put("ACTUALFINISHDATE", rset2.getString(13) == null ? "" : rset2.getString(13));
				resultMap.put("REV_TIMING", rset2.getString(14) == null ? "" : rset2.getString(14));
				resultMap.put("SOURCE", rset2.getString(15));
				resultMap.put("ECO_NO", rset2.getString(16) == null ? "" : rset2.getString(16));
				resultMap.put("REV_TIMING2", rset2.getString(17) == null ? "" : rset2.getString(17));
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
    ArrayList hardCopyDwgDeployedList = null;

    try {
        if (!firstLoad.equalsIgnoreCase("true")) {
            hardCopyDwgDeployedList = getHardCopyDwgDeployedList(projectList, 
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
        * [D/H] D: DTS / H: Hard Copy
        <table width="100%" cellSpacing="1" cellpadding="1" border="0" bgcolor="#cccccc">
            <tr height="20" bgcolor="#e5e5e5">
                <td class="td_smallLRMarginBlue" width="20">No.</td>
                <td class="td_smallLRMarginBlue" width="20">D/H</td>
                <td class="td_smallLRMarginBlue" width="30">구분</td>
                <td class="td_smallLRMarginBlue" width="50">Project</td>
                <td class="td_smallLRMarginBlue" width="120">Part</td>
                <td class="td_smallLRMarginBlue" width="10">DWG.NO.</td>
                <td class="td_smallLRMarginBlue" width="180">Drawing Title</td>
                <td class="td_smallLRMarginBlue" width="40">담당자</td>
                <td class="td_smallLRMarginBlue" width="30">Rev.</td>
                <td class="td_smallLRMarginBlue" width="60">의뢰일</td>
                <td class="td_smallLRMarginBlue" width="60">도면<br>완료일</td>
                <td class="td_smallLRMarginBlue" width="60">도면<br>출도일</td>
                <td class="td_smallLRMarginBlue" width="50">개정시기</td>
                <td class="td_smallLRMarginBlue" width="50">출도시기</td>
                <td class="td_smallLRMarginBlue" width="60">ECO No.</td>
                <td class="td_smallLRMarginBlue" width="50">조치CODE</td>
                <td class="td_smallLRMarginBlue" width="50">원인부서</td>
                <td class="td_smallLRMarginBlue">비고</td>
            </tr>

            <%
            for (int i = 0; hardCopyDwgDeployedList != null && i < hardCopyDwgDeployedList.size(); i++)
            {
                java.util.Map map = (java.util.Map)hardCopyDwgDeployedList.get(i);
                String sGubun = "Series";
                if ("0".equals((String)map.get("SERIAL"))) sGubun = "대표";
                String sRev = (String)map.get("DEPLOY_REV");
                if (!sRev.equals("0") && sRev.indexOf("0") == 0) sRev = sRev.substring(1);

                String deployDesc = (String)map.get("DEPLOY_DESC");
                deployDesc = deployDesc.replaceAll("\r\n", "<br>");
                deployDesc = deployDesc.replaceAll(" ", "&nbsp;");

                String revTimingStr = (String)map.get("REV_TIMING2");
                if ("계획 전".equals(revTimingStr)) revTimingStr = "시공 전";
                else if ("계획 후".equals(revTimingStr)) revTimingStr = "시공 후";
                %>
                <tr style="background-color:#ffffff" 
                    onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                    <td class="td_standardSmall" width="20"><%= i + 1 %></td>
                    <td class="td_standardSmall" width="20"><%= (String)map.get("SOURCE") %></td>
                    <td class="td_standardSmall" width="30"><%= sGubun %></td>
                    <td class="td_standardSmall" width="50"><%= (String)map.get("PROJECT_NO") %></td>
                    <td class="td_standardSmall" width="120"><%= (String)map.get("DEPT_NAME") %></td>
                    <td class="td_standardSmall" width="10"><%= (String)map.get("DWG_NO") %></td>
                    <td class="td_standardSmall" width="180"><%= (String)map.get("DWG_TITLE") %></td>
                    <td class="td_standardSmall" width="40"><%= (String)map.get("USER_NAME") %></td>
                    <td class="td_standardSmall" width="30"><%= sRev %></td>
                    <td class="td_standardSmall" width="60"><%= (String)map.get("REQUEST_DATE") %></td>
                    <td class="td_standardSmall" width="60"><%= (String)map.get("ACTUALFINISHDATE") %></td>
                    <td class="td_standardSmall" width="60"><%= (String)map.get("DEPLOY_DATE") %></td>
                    <td class="td_standardSmall" width="50"><%= revTimingStr %></td>
                    <td class="td_standardSmall" width="50"><%= (String)map.get("REV_TIMING") %></td>
                    <td class="td_standardSmall" width="60"><%= (String)map.get("ECO_NO") %></td>
                    <td class="td_standardSmall" width="50"><%= (String)map.get("REASON_CODE") %></td>
                    <td class="td_standardSmall" width="50"><%= (String)map.get("CAUSE_DEPART") %></td>
                    <td class="td_standardSmall" style="text-align:left;word-break:break-all;"><%= deployDesc %></td>
                </tr>
                <%
            }
            %>
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