<%--  
§DESCRIPTION: 설계 공정조회 - 도면 개정(배포) History 조회 화면
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPDwgRevisionHistoryView.jsp
§CHANGING HISTORY: 
§    2010-03-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

    private ArrayList getDwgDeployRevList(String projectNo, String dwgNo) throws Exception
    {
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
		if (StringUtil.isNullString(dwgNo)) throw new Exception("DwgNo. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT A.DEPLOY_REV,                                                                    ");
            queryStr.append("       TO_CHAR(A.REQUEST_DATE, 'YYYY-MM-DD') AS DEPLOY_DATE,                            ");
            queryStr.append("       A.EMPLOYEE_NO,                                                                   ");
            queryStr.append("       C.NAME AS USER_NAME,                                                             ");
            queryStr.append("       A.REASON_CODE,                                                                   ");
            queryStr.append("       B.DEPT_NAME,                                                                     ");
            queryStr.append("       A.DEPLOY_DESC,                                                                   ");
            queryStr.append("       A.ECO_NO,                                                                        ");
            queryStr.append("       A.REV_TIMING                                                                     ");
            queryStr.append("  FROM PLM_HARDCOPY_DWG A,                                                              ");
            queryStr.append("       STX_COM_INSA_DEPT@STXERP B,                                                      ");
            queryStr.append("       CCC_SAWON C                                                                      ");
            queryStr.append(" WHERE 1 = 1                                                                            ");
            queryStr.append("   AND A.PROJECT_NO = '" + projectNo + "'                                               ");
            queryStr.append("   AND A.DWG_CODE = '" + dwgNo + "'                                                     ");
            queryStr.append("   AND A.DEPT_CODE = B.DEPT_CODE                                                        ");
            queryStr.append("   AND A.EMPLOYEE_NO = C.EMPLOYEE_NUM                                                   ");
            queryStr.append("UNION ALL                                                                               ");
            queryStr.append("SELECT CASE WHEN SUBSTR(SDDALV.DWG_REV, 1, 1) = '0' THEN SUBSTR(SDDALV.DWG_REV, 2, 1)   ");
            queryStr.append("       ELSE SDDALV.DWG_REV                                                              ");
            queryStr.append("       END AS DEPLOY_REV                                                                ");
            queryStr.append("      ,SDDALV.DWG_INP_DATE AS DEPLOY_DATE                                               ");
            queryStr.append("      ,SDDALV.EMP_NO AS EMPLOYEE_NO                                                     ");
            queryStr.append("      ,SDDALV.USER_NAME                                                                 ");
            queryStr.append("      ,SDDALV.ECO_REASON_CODE AS REASON_CODE                                            ");
            queryStr.append("      ,NULL AS CAUSE_DEPART                                                             ");
            queryStr.append("      ,SDDALV.ECO_REASON_DESC AS DEPLOY_DESC                                            ");
            queryStr.append("      ,SDDALV.ECO_NO AS ECO_NO                                                          ");
            queryStr.append("      ,F_GET_PLM_ACTIVITY('" + projectNo + "', '" + dwgNo + "', SDDALV.DWG_INP_DATE)    ");
            queryStr.append("       AS REV_TIMING                                                                    ");
            queryStr.append("      /*,SDDALV.PROJECT_NO                                                              ");
            queryStr.append("      ,SDDALV.DWG_NO                                                                    ");
            queryStr.append("      ,SDDALV.ECO_NO                                                                    ");
            queryStr.append("      ,SDDALV.ECO_DESC                                                                  ");
            queryStr.append("      ,SDDALV.DWG_DESCRIPTION                                                           ");
            queryStr.append("      ,SDDALV.USER_NAME                                                                 ");
            queryStr.append("      ,SDDALV.ECO_ORDER_TYPE                                                            ");
            queryStr.append("      ,SDDALV.ECO_ORDER_TYPE_DESC                                                       ");
            queryStr.append("      ,SDDALV.MASTER_PROJECT_NO                                                         ");
            queryStr.append("      ,SDDALV.DWG_NO_CONCAT                                                             ");
            queryStr.append("      ,SDDALV.DWG_BLOCK*/                                                               ");
            queryStr.append("  FROM STX_DWG_DPS_ALL_LIST_V@STXERP SDDALV                                             ");
            queryStr.append(" WHERE SDDALV.MASTER_PROJECT_NO = '" + projectNo + "'                                   ");
            queryStr.append("   AND SDDALV.DWG_NO_CONCAT = '" + dwgNo.substring(0, 5) + "'                           ");
            queryStr.append("   AND SDDALV.DWG_BLOCK = '" + dwgNo.substring(5) + "'                                  ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				java.util.HashMap resultMap = new java.util.HashMap();
                resultMap.put("DEPLOY_REV", rset.getString(1));
                resultMap.put("DEPLOY_DATE", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("EMPLOYEE_NO", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("EMPLOYEE_NAME", rset.getString(4) == null ? "" : rset.getString(4));
                resultMap.put("REASON_CODE", rset.getString(5));
                resultMap.put("CAUSE_DEPART", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("DEPLOY_DESC", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("ECO_NO", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("REV_TIMING", rset.getString(9) == null ? "" : rset.getString(9));
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

    // isNumeric 
    private boolean isNumeric(String text)  
    {
        if (text == null || text.trim().length() == 0) return false;
        
        for (int i = 0; i < text.length(); i++) {
            if (!Character.isDigit(text.charAt(i))) return false;
        }
        return  true;
    }

%>


<%--========================== JSP =========================================--%>
<%
    request.setCharacterEncoding("euc-kr"); 

    String projectNo = emxGetParameter(request, "projectNo");
    String dwgNo = emxGetParameter(request, "dwgNo");
    String errStr = "";

    ArrayList deployRevList = null;
    try {
        deployRevList = getDwgDeployRevList(projectNo, dwgNo);
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>도면 개정 HISTORY</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPDwgRevHistoryForm">

<table width="100%" cellSpacing="0" cellpadding="6" border="0" align="center">
    <tr>
        <td><br><font color="darkblue"><b>도면: <%=dwgNo%> (호선: <%=projectNo%>)</b></font>
        <td>
    </tr>

    <tr>
    <td style="vertical-align:top;">
        <div id="dwgRevListDiv" STYLE="height:280; overflow:auto; position:relative;">
        <table width="100%" cellSpacing="0" cellpadding="0" border="1" align="center">
            <tr height="20">
                <td class="td_standardBold" style="background-color:#336699;" width="40"><font color="#ffffff">REV.</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="70"><font color="#ffffff">출도일자</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="70"><font color="#ffffff">ECO NO.</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="50"><font color="#ffffff">의뢰자</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="60"><font color="#ffffff">출도원인</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="130"><font color="#ffffff">원인부서</font></td>
                <td class="td_standardBold" style="background-color:#336699;" width="90"><font color="#ffffff">출도시기</font></td>
                <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">비고</font></td>
            </tr>
            
            <%
            ArrayList tempNumericList = new ArrayList();
            ArrayList tempAlphabetList = new ArrayList();
            for (int i = 0; deployRevList != null && i < deployRevList.size(); i++) {
                java.util.Map map = (java.util.Map)deployRevList.get(i);
                String dwgRev = (String)map.get("DEPLOY_REV");
                if (isNumeric(dwgRev)) tempNumericList.add(map);
                else tempAlphabetList.add(map);
            }
            //DIS-ERROR :sort 기능 대체 필요할 듯.
            //tempNumericList.sort("DEPLOY_REV", "ascending", "integer");
            //tempAlphabetList.sort("DEPLOY_REV", "ascending", "string");
            deployRevList.clear();
            for (int i = 0; i < tempAlphabetList.size(); i++) deployRevList.add(tempAlphabetList.get(i));
            for (int i = 0; i < tempNumericList.size(); i++) deployRevList.add(tempNumericList.get(i));
            //deployRevList.sort("DEPLOY_DATE", "descending", "string");


            for (int i = 0; deployRevList != null && i < deployRevList.size(); i++) 
            {
                java.util.Map map = (java.util.Map)deployRevList.get(i);

                String dwgRev = (String)map.get("DEPLOY_REV");
                String deployDate = (String)map.get("DEPLOY_DATE");
                String userID = (String)map.get("EMPLOYEE_NO");
                String userName = (String)map.get("EMPLOYEE_NAME");
                String reasonCode = (String)map.get("REASON_CODE");
                String causeDepart = (String)map.get("CAUSE_DEPART");
                String deployDesc = (String)map.get("DEPLOY_DESC");
                String ecoNo = (String)map.get("ECO_NO");
                String revTiming = (String)map.get("REV_TIMING");

                if (StringUtil.isNullString(deployDate)) deployDate = "&nbsp;";
                if (StringUtil.isNullString(userID)) userID = "&nbsp;";
                if (StringUtil.isNullString(causeDepart)) causeDepart = "&nbsp;";
                if (StringUtil.isNullString(deployDesc)) deployDesc = "&nbsp;";
                else {
                    deployDesc = deployDesc.replaceAll("\r\n", "<br>");
                    deployDesc = deployDesc.replaceAll(" ", "&nbsp;");
                }
                if (StringUtil.isNullString(ecoNo)) ecoNo = "&nbsp;";
                if (StringUtil.isNullString(revTiming)) revTiming = "&nbsp;";
                %>
                <tr height="20" style="background-color:#ffffff" 
                    onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                    <td class="td_standard" width="40"><%=dwgRev%></td>
                    <td class="td_standard" width="70"><%=deployDate%></td>
                    <td class="td_standard" width="70"><%=ecoNo%></td>
                    <td class="td_standard" width="50"><%=userName%></td>
                    <td class="td_standard" width="60"><%=reasonCode%></td>
                    <td class="td_standard" width="130"><%=causeDepart%></td>
                    <td class="td_standard" width="90"><%=revTiming%></td>
                    <td class="td_standard" style="text-align:left;"><%=deployDesc%></td>
                </tr>
                <%
            }
            %>
        </table>
        </div>
    </td>
    </tr>

    <tr height="45">
        <td style="text-align:right;">
            <hr>
            <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>

</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


</html>