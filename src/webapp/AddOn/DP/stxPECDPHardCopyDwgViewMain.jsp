<%--  
§DESCRIPTION: 도면 출도대장(Hard Copy) 조회 및 등록 메인 부분 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgViewMain.jsp
§CHANGING HISTORY: 
§    2010-03-20: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@page import="java.text.*"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%!
	// getHardCopyDwgList() : 도면 출도대장(Hard Copy) 조회
	private ArrayList getHardCopyDwgList(String projectNo, String deptCode, String designerID, String dateFrom, String dateTo, 
	                                   String revNo, String deployNo, String[] drawingNoArray) throws Exception
	{
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
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();

            queryStr.append("SELECT REPLACE(REPLACE(A.GUBUN, '자체', 'Itself'), '출도실', 'Copy Center') AS GUBUN,  ");
            queryStr.append("       A.DEPLOY_NO, A.DEPT_CODE, B.DEPT_NAME,                                          ");
            queryStr.append("       A.EMPLOYEE_NO, C.NAME, TO_CHAR(A.REQUEST_DATE, 'YYYY-MM-DD'),                   ");
            queryStr.append("       TO_CHAR(A.DEPLOY_DATE, 'YYYY-MM-DD'),                                           ");
            queryStr.append("       A.PROJECT_NO, A.DEPLOY_REV, A.DWG_CODE, A.DWG_TITLE,                            ");
            queryStr.append("       A.REASON_CODE, A.CAUSE_DEPART, D.DEPT_NAME,                                     ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(                                                                        ");
            queryStr.append("       REPLACE(A.REV_TIMING,                                                           ");
            queryStr.append("               '설계 전', 'Pre-Design'),                                               ");
            queryStr.append("               '설계 후', 'Post-Design'),                                              ");
            queryStr.append("               '생산 전', 'Pre-Production'),                                           ");
            queryStr.append("               '생산 후', 'Post-Production'),                                          ");
            queryStr.append("               '제작 전', 'Pre-Manufacture'),                                          ");
            queryStr.append("               '제작 후', 'Post-Manufacture'),                                         ");
            queryStr.append("               '설치 전', 'Pre-Installation'),                                         ");
            queryStr.append("               '설치 후', 'Post-Installation'),                                        ");
            queryStr.append("               '절단 전', 'Pre-Cutting'),                                              ");
            queryStr.append("               '절단 후', 'Post-Cutting'),                                             ");
            queryStr.append("               '시공 전', 'Pre-Production'),                                           ");
            queryStr.append("               '시공 후', 'Post-Production')                                           ");
            queryStr.append("       AS REV_TIMING,                                                                  ");
            queryStr.append("       A.DEPLOY_DESC, A.ECO_NO, E.DWGCATEGORY                                          ");
            queryStr.append("  FROM PLM_HARDCOPY_DWG A,                                                             ");


            /*
            queryStr.append("       STX_COM_INSA_DEPT@STXERP B,                                                     ");
            queryStr.append("       CCC_SAWON C,                                                                    ");
            queryStr.append("       STX_COM_INSA_DEPT@STXERP D,                                                     ");
            */
            queryStr.append("       (                                                                               ");
            queryStr.append("            SELECT A.DEPT_CODE, A.DEPT_NAME                                            ");
            queryStr.append("              FROM STX_COM_INSA_DEPT@STXERP A                                          ");
            queryStr.append("            UNION ALL                                                                  ");
            queryStr.append("            SELECT A.DEPTCODE AS DEPT_CODE,	A.DEPTNM AS DEPT_NAME                   ");
            queryStr.append("              FROM DCC_DEPTCODE A, Z_DALIAN_SAWON_TO111231 B                           ");
            queryStr.append("             WHERE A.DWGDEPTCODE = B.DWG_DEPTCODE                                      ");
            queryStr.append("             GROUP BY A.DEPTCODE, A.DEPTNM                                             ");
            queryStr.append("       ) B,                                                                            ");
            queryStr.append("       (                                                                               ");
            queryStr.append("            SELECT EMPLOYEE_NUM, NAME                                                  ");
            queryStr.append("              FROM CCC_SAWON                                                           ");
            queryStr.append("            UNION ALL                                                                  ");
            queryStr.append("            SELECT SAWON_ID AS EMPLOYEE_NUM, SAWON_NAME AS NAME                        ");
            queryStr.append("              FROM Z_DALIAN_SAWON_TO111231                                             ");
            queryStr.append("       ) C,                                                                            ");
            queryStr.append("       (                                                                               ");
            queryStr.append("            SELECT A.DEPT_CODE, A.DEPT_NAME                                            ");
            queryStr.append("              FROM STX_COM_INSA_DEPT@STXERP A                                          ");
            queryStr.append("            UNION ALL                                                                  ");
            queryStr.append("            SELECT A.DEPTCODE AS DEPT_CODE,	A.DEPTNM AS DEPT_NAME                   ");
            queryStr.append("              FROM DCC_DEPTCODE A, Z_DALIAN_SAWON_TO111231 B                           ");
            queryStr.append("             WHERE A.DWGDEPTCODE = B.DWG_DEPTCODE                                      ");
            queryStr.append("             GROUP BY A.DEPTCODE, A.DEPTNM                                             ");
            queryStr.append("       ) D,                                                                            ");


            queryStr.append("       PLM_ACTIVITY E                                                                  ");
            queryStr.append(" WHERE 1 = 1                                                                           ");
            if (!StringUtil.isNullString(projectNo))
            queryStr.append("   AND A.PROJECT_NO = '" + projectNo + "'                                              ");
            if (!StringUtil.isNullString(deptCode))
            queryStr.append("   AND A.DEPT_CODE = '" + deptCode + "'                                                ");
            if (!StringUtil.isNullString(designerID))
            queryStr.append("   AND A.EMPLOYEE_NO = '" + designerID + "'                                            ");
            if (!StringUtil.isNullString(dateFrom))
            queryStr.append("   AND A.REQUEST_DATE >= TO_DATE('" + dateFrom + "', 'YYYY-MM-DD')                     ");
            if (!StringUtil.isNullString(dateTo))
            queryStr.append("   AND A.REQUEST_DATE < TO_DATE('" + dateTo + "', 'YYYY-MM-DD') + 1                    ");
            if (hasDrawingNo)
            queryStr.append("   AND A.DWG_CODE LIKE '" + drawingNo + "'                                             ");
            if (!StringUtil.isNullString(revNo))
            queryStr.append("   AND A.DEPLOY_REV = '" + revNo + "'                                                  ");
            if (!StringUtil.isNullString(deployNo))
            queryStr.append("   AND A.DEPLOY_NO = '" + deployNo + "'                                                ");
            queryStr.append("   AND A.DEPT_CODE = B.DEPT_CODE                                                       ");
            queryStr.append("   AND A.EMPLOYEE_NO = C.EMPLOYEE_NUM                                                  ");
            queryStr.append("   AND A.CAUSE_DEPART = D.DEPT_CODE(+)                                                 ");
            queryStr.append("   AND A.PROJECT_NO = E.PROJECTNO                                                      ");
            queryStr.append("   AND E.WORKTYPE = 'DW'                                                               ");
            queryStr.append("   AND SUBSTR(E.ACTIVITYCODE, 1, 8) = A.DWG_CODE                                       ");
            queryStr.append(" ORDER BY A.DEPLOY_NO                                                                  ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("GUBUN", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("DEPLOY_NO", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("DEPT_CODE", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("DEPT_NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("EMPLOYEE_NO", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("NAME", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("REQUEST_DATE", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("DEPLOY_DATE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("PROJECT_NO", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("DEPLOY_REV", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("DWG_CODE", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("DWG_TITLE", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("REASON_CODE", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("CAUSE_DEPART", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("CAUSE_DEPT_NAME", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("REV_TIMING", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("DEPLOY_DESC", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("ECO_NO", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("DWG_CATEGORY", rset.getString(19));
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

    // 변경사항 저장
    private void saveHardCopyData(String userID, ArrayList paramsList) throws Exception
    {
		if (paramsList == null || paramsList.size() <= 0) throw new Exception("No data to update...");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer execQuery = new StringBuffer();
				execQuery.append("UPDATE PLM_HARDCOPY_DWG                         ");
				execQuery.append("   SET GUBUN = ?,                               ");
                execQuery.append("       DEPLOY_REV = ?,                          ");
                execQuery.append("       DEPLOY_DATE = TO_DATE(?, 'YYYY-MM-DD'),  ");
                execQuery.append("       REASON_CODE = ?,                         ");
                execQuery.append("       CAUSE_DEPART = ?,                        ");
                execQuery.append("       REV_TIMING = ?,                          ");
                execQuery.append("       DEPLOY_DESC = ?,                         ");
                execQuery.append("       UPDATE_DATE = SYSDATE,                   ");
                execQuery.append("       UPDATE_BY = '" + userID + "',            ");
                execQuery.append("       ECO_NO = ?                               ");
                execQuery.append(" WHERE DEPLOY_NO = ?                            ");
                execQuery.append("   AND DWG_CODE = ?                             ");

                ppStmt = conn.prepareStatement(execQuery.toString());

                for (int i = 0; i < paramsList.size(); i++) {
                    Map map = (Map)paramsList.get(i);

                    ppStmt.setString(1, (String)map.get("gubunInput"));
                    ppStmt.setString(2, (String)map.get("revInput"));
                    ppStmt.setString(3, (String)map.get("deployDateInput"));
                    ppStmt.setString(4, (String)map.get("reasonCodeInput"));
                    ppStmt.setString(5, (String)map.get("causeDepartInput"));
                    ppStmt.setString(6, (String)map.get("revTimingInput"));
                    ppStmt.setString(7, (String)map.get("deployDescInput"));
                    ppStmt.setString(8, (String)map.get("ecoNoInput"));
                    
                    String dbKey = (String)map.get("dbKey");
                    ppStmt.setString(9, dbKey.substring(0, dbKey.indexOf("|")));
                    ppStmt.setString(10, dbKey.substring(dbKey.indexOf("|") + 1));
                    
                    ppStmt.executeUpdate();
                }

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
    }

    // 선택된 항목들을 삭제
    private void deleteHardCopyData(String userID, ArrayList paramsList) throws Exception
    {
		if (paramsList == null || paramsList.size() <= 0) throw new Exception("No data to update...");

		java.sql.Connection conn = null;
		java.sql.PreparedStatement ppStmt = null;

		try {
			conn = DBConnect.getDBConnection("SDPS");
			
			try {
				StringBuffer execQuery = new StringBuffer();
				execQuery.append("DELETE PLM_HARDCOPY_DWG                         ");
                execQuery.append(" WHERE DEPLOY_NO = ?                            ");
                execQuery.append("   AND DWG_CODE = ?                             ");

                ppStmt = conn.prepareStatement(execQuery.toString());

                for (int i = 0; i < paramsList.size(); i++) {
                    Map map = (Map)paramsList.get(i);

                    String dbKey = (String)map.get("dbKey");
                    ppStmt.setString(1, dbKey.substring(0, dbKey.indexOf("|")));
                    ppStmt.setString(2, dbKey.substring(dbKey.indexOf("|") + 1));
                    
                    ppStmt.executeUpdate();
                }

				DBConnect.commitJDBCTransaction(conn);
			} 
			catch (Exception e) {
				DBConnect.rollbackJDBCTransaction(conn);
				throw new Exception(e.toString());
			}
		}
		finally {
			if (ppStmt != null) ppStmt.close();
			DBConnect.closeConnection(conn);
		}
    }

%>

<%--========================== JSP =========================================--%>
<%
    /** 변경사항 저장 모드 ---------------------------------------------------*/
    String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String updateMode = StringUtil.setEmptyExt(emxGetParameter(request, "updateMode"));
    if (updateMode.equalsIgnoreCase("modify")) 
    {
        ArrayList paramsList = new ArrayList();

        Enumeration paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) 
        {
            String paramName = (String)paramNames.nextElement();
            if (paramName != null && paramName.startsWith("checkBox_"))
            {
                String dbKey = paramName.substring(paramName.lastIndexOf("_") + 1);
                
                String gubunInput = emxGetParameter(request, "gubunInput_" + dbKey);
                String revInput = emxGetParameter(request, "revInput_" + dbKey);
                String deployDateInput = emxGetParameter(request, "deployDateInput_" + dbKey);
                String reasonCodeInput = emxGetParameter(request, "reasonCodeInput_" + dbKey);
                String causeDepartInput = emxGetParameter(request, "causeDepartInput1_" + dbKey);
                String revTimingInput = emxGetParameter(request, "revTimingInput_" + dbKey);
                String deployDescInput = emxGetParameter(request, "deployDescInput_" + dbKey);
                String ecoNoInput = emxGetParameter(request, "ecoNoInput_" + dbKey);

				gubunInput = StringUtil.replaceAll(gubunInput, "Itself", "자체");
				gubunInput = StringUtil.replaceAll(gubunInput, "Copy Center", "출도실");

				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Design", "설계 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Design", "설계 후");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Production", "생산 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Production", "생산 후");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Manufacture", "제작 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Manufacture", "제작 후");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Installation", "설치 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Installation", "설치 후");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Cutting", "절단 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Cutting", "절단 후");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Pre-Production", "시공 전");
				revTimingInput = StringUtil.replaceAll(revTimingInput, "Post-Production", "시공 후");

                HashMap map = new HashMap();
                map.put("dbKey", dbKey);
                map.put("gubunInput", gubunInput);
                map.put("revInput", revInput);
                map.put("deployDateInput", deployDateInput);
                map.put("reasonCodeInput", reasonCodeInput);
                map.put("causeDepartInput", causeDepartInput);
                map.put("revTimingInput", revTimingInput);
                map.put("deployDescInput", deployDescInput);
                map.put("ecoNoInput", ecoNoInput);
                paramsList.add(map);
            }
        }

        saveHardCopyData(designerID, paramsList);
    }
    else if (updateMode.equalsIgnoreCase("delete")) 
    {
        ArrayList paramsList = new ArrayList();

        Enumeration paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) 
        {
            String paramName = (String)paramNames.nextElement();
            if (paramName != null && paramName.startsWith("checkBox_"))
            {
                String dbKey = paramName.substring(paramName.lastIndexOf("_") + 1);

                HashMap map = new HashMap();
                map.put("dbKey", dbKey);
                paramsList.add(map);
            }
        }

        deleteHardCopyData(designerID, paramsList);
    }

    /** 조회 *----------------------------------------------------------------*/
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String revNo = StringUtil.setEmptyExt(emxGetParameter(request, "revNo"));
    String deployNo = StringUtil.setEmptyExt(emxGetParameter(request, "deployNo"));

    String drawingNo1 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo1"));
    String drawingNo2 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo2"));
    String drawingNo3 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo3"));
    String drawingNo4 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo4"));
    String drawingNo5 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo5"));
    String drawingNo6 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo6"));
    String drawingNo7 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo7"));
    String drawingNo8 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo8"));
    String[] drawingNoArray = {drawingNo1, drawingNo2, drawingNo3, drawingNo4, drawingNo5, drawingNo6, drawingNo7, drawingNo8};

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
    ArrayList hardCopyDwgList = null;
    ArrayList departmentList = null;  // (원인)부서목록

    try {
        if (!firstLoad.equalsIgnoreCase("true")) {
            hardCopyDwgList = getHardCopyDwgList(projectNo, deptCode, designerID, dateFrom, dateTo, revNo, deployNo, drawingNoArray);

            // (원인)부서목록
            departmentList = getAllDepartmentOfSTXShipList();
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
                    Error occurred!<br>
                    ※Error Message: <%=errStr%>                
                </td>
            </tr>
        </table>
    <%
    }
    else
    {
    %>
        <input type="hidden" name="projectNo" value="<%=projectNo%>" />
        
        <input type="hidden" name="deptCode" value="<%=deptCode%>" />
        <input type="hidden" name="designerID" value="<%=designerID%>" />
        <input type="hidden" name="dateFrom" value="<%=dateFrom%>" />
        <input type="hidden" name="dateTo" value="<%=dateTo%>" />
        <input type="hidden" name="revNo" value="<%=revNo%>" />
        <input type="hidden" name="deployNo" value="<%=deployNo%>" />
        <input type="hidden" name="drawingNo1" value="<%=drawingNo1%>" />
        <input type="hidden" name="drawingNo2" value="<%=drawingNo2%>" />
        <input type="hidden" name="drawingNo3" value="<%=drawingNo3%>" />
        <input type="hidden" name="drawingNo4" value="<%=drawingNo4%>" />
        <input type="hidden" name="drawingNo5" value="<%=drawingNo5%>" />
        <input type="hidden" name="drawingNo6" value="<%=drawingNo6%>" />
        <input type="hidden" name="drawingNo7" value="<%=drawingNo7%>" />
        <input type="hidden" name="drawingNo8" value="<%=drawingNo8%>" />
        <input type="hidden" name="showMsg" value="<%=showMsg%>" />
        <input type="hidden" name="firstLoad" value="false" />
        <input type="hidden" name="isAdmin" value="<%=isAdmin%>" />
        <input type="hidden" name="updateMode" value="" />
        

        <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
            <tr height="20" bgcolor="#e5e5e5">
                <td class="td_standardBold" width="20">
                    <% if (isAdmin.equals("Y")) { %>
                    <!--<input type="checkbox" name="checkAll" style="border:1px solid #D3D3D3" onClick="toggleCheckBoxes(this);">-->
                    &nbsp;
                    <% } %>
                </td>
                <td class="td_smallLRMarginBlue" width="20">No.</td>
                <td class="td_smallLRMarginBlue" width="40">Division</td>
                <td class="td_smallLRMarginBlue" width="60">Distribution No.</td>
                <td class="td_smallLRMarginBlue" width="40">Project</td>
                <td class="td_smallLRMarginBlue" width="30">Rev.</td>
                <td class="td_smallLRMarginBlue" width="60">DwgNo.</td>
                <td class="td_smallLRMarginBlue" width="190">DESCRIPTION</td>
                <td class="td_smallLRMarginBlue" width="130">Dept.</td>
                <td class="td_smallLRMarginBlue" width="40">Distribution No. Requestor</td>
                <td class="td_smallLRMarginBlue" width="60">Distribution No. Request Date</td>
                <td class="td_smallLRMarginBlue" width="60">Distribution Date</td>
                <td class="td_smallLRMarginBlue" width="60">ECO No.</td>
                <td class="td_smallLRMarginBlue" width="30">Category of Change</td>
                <td class="td_smallLRMarginBlue" width="130">Change Request Dept.</td>
                <td class="td_smallLRMarginBlue" width="90">Distribution Time</td>
                <td class="td_smallLRMarginBlue">Note</td>
            </tr>

            <%
            for (int i = 0; hardCopyDwgList != null && i < hardCopyDwgList.size(); i++)
            {
                Map map = (Map)hardCopyDwgList.get(i);
                String strDBKey = (String)map.get("DEPLOY_NO") + "|" + (String)map.get("DWG_CODE");
                boolean isEditable = false;
                if (isAdmin.equals("Y")) isEditable = true;
            %>
            <tr height="20" bgcolor="#ffffff">
                <!-- CHECK BOX -->
                <td class="td_standard" width="20">
                    <% if (isEditable) { %>
                    <input type="checkbox" name="checkBox_<%=strDBKey%>" value="">
                     <% } %>      
                </td>

                <!-- NO. -->
                <td class="td_standard" width="20"><%= i + 1 %></td>
                
                <!-- 구분 -->
                <% if (isEditable) { %>
                    <td id="gubunTD_<%=strDBKey%>" class="td_smallYellowBack" width="40">
                        <input type="text" name="gubunInput_<%=strDBKey%>" value="<%=(String)map.get("GUBUN")%>" 
                               class="input_noBorder4" style="width:46px;height:20px;cursor:hand;" readonly 
                               onclick="showGubunSel(this, '<%=strDBKey%>');">
                    </td> 
                <% } else { %>
                    <td class="td_standard" width="40"><%=(String)map.get("GUBUN")%></td>
                <% } %>                  

                <!-- 배포 NO. -->
                <td class="td_standard" width="60"><%= (String)map.get("DEPLOY_NO") %></td>

                <!-- PROJECT NO. -->
                <td class="td_standard" width="40"><%= (String)map.get("PROJECT_NO") %></td>

                <!-- Rev. -->
                <% if (isEditable) { %>
                    <td id="revTD_<%=strDBKey%>" class="td_smallYellowBack" width="30">
                        <input type="text" name="revInput_<%=strDBKey%>" value="<%=(String)map.get("DEPLOY_REV")%>" 
                               class="input_noBorder4" style="width:40px;height:20px;cursor:hand;" maxlength="3" 
                               onchange="revInputChanged(this, '<%=strDBKey%>');" onkeydown="inputCtrlKeydownHandler();">
                    </td> 
                <% } else { %>
                    <td class="td_standard" style="text-align:center;" width="30"><%=(String)map.get("DEPLOY_REV")%></td>
                <% } %>   
                
                <!-- DwgNo. -->
                <td class="td_standard" width="60"><%= (String)map.get("DWG_CODE") %></td>

                <!-- DESCRIPTION -->
                <td class="td_standard" width="190" style="text-align:left;word-break:break-all;"><%= (String)map.get("DWG_TITLE") %></td>

                <!-- 의뢰부서 -->
                <td class="td_standard" width="130"><%= (String)map.get("DEPT_NAME") %></td>

                <!-- 의뢰자 -->
                <td class="td_standard" width="40"><%= (String)map.get("NAME") %></td>

                <!-- 의뢰일자 -->
                <td class="td_standard" width="60"><%= (String)map.get("REQUEST_DATE") %></td>

                <!-- 배포일자 -->
                <% if (isEditable) { %>
                    <td id="deployDateTD_<%=strDBKey%>" class="td_smallYellowBack" width="60">
                        <input type="text" name="deployDateInput_<%=strDBKey%>" value="<%=(String)map.get("DEPLOY_DATE")%>" 
                               class="input_noBorder4" style="width:80px;height:20px;cursor:hand;" maxlength="10" 
                               onchange="deployDateInputChanged(this, '<%=strDBKey%>');" onkeydown="inputCtrlKeydownHandler();">
                    </td> 
                <% } else { %>
                    <td class="td_standard" width="60"><%=(String)map.get("DEPLOY_DATE")%></td>
                <% } %>

                <!-- ECO No. -->
                <% if (isEditable) { %>
                    <td id="ecoNoTD_<%=strDBKey%>" class="td_smallYellowBack" width="30">
                        <input type="text" name="ecoNoInput_<%=strDBKey%>" value="<%=(String)map.get("ECO_NO")%>" 
                               class="input_noBorder4" style="width:60px;height:20px;cursor:hand;"  
                               onKeyUp="checkECONo(this, '<%=strDBKey%>');" onkeydown="inputCtrlKeydownHandler();">
                    </td>                 
                <% } else { %>
                    <td class="td_standard" width="60"><%= (String)map.get("ECO_NO") %></td>
                <% } %>

                <!-- 출도원인 -->
                <% if (isEditable) { %>
                    <td id="reasonCodeTD_<%=strDBKey%>" class="td_smallYellowBack" width="30">
                        <input type="text" name="reasonCodeInput_<%=strDBKey%>" value="<%=(String)map.get("REASON_CODE")%>" 
                               class="input_noBorder4" style="width:60px;height:20px;cursor:hand;" readonly 
                               onchange="reasonCodeInputChanged(this, '<%=strDBKey%>');"
                               onclick="showReasonCodeWin(this, '<%=strDBKey%>');">
                    </td>                 
                <% } else { %>
                    <td class="td_standard" width="30"><%=(String)map.get("REASON_CODE")%></td>
                <% } %>

                <!-- 원인부서 -->
                <% if (isEditable) { %>
                    <td id="causeDepartTD_<%=strDBKey%>" class="td_smallYellowBack" width="130">
                        <input type="hidden" name="causeDepartInput1_<%=strDBKey%>" value="<%=(String)map.get("CAUSE_DEPART")%>"/>
                        <input type="text" name="causeDepartInput2_<%=strDBKey%>" value="<%=(String)map.get("CAUSE_DEPT_NAME")%>" 
                               class="input_noBorder4" style="width:130px;height:20px;cursor:hand;text-align:left;" readonly 
                               onclick="showCauseDepartSel(this, '<%=strDBKey%>');">
                    </td>                 
                <% } else { %>
                    <td class="td_standard" width="130"><%=(String)map.get("CAUSE_DEPT_NAME")%></td>
                <% } %>

                <!-- 개정시기 -->
                <% if (isEditable) { 
                    String dwgCategory = (String)map.get("DWG_CATEGORY");
                    %>
                    <td id="revTimingTD_<%=strDBKey%>" class="td_smallYellowBack" width="90">
                        <input type="text" name="revTimingInput_<%=strDBKey%>" value="<%=(String)map.get("REV_TIMING")%>" 
                               class="input_noBorder4" style="width:90px;height:20px;cursor:hand;text-align:center;" readonly 
                               onclick="showRevTimingSel(this, '<%=strDBKey%>', '<%=dwgCategory%>');">
                    </td> 
                <% } else { %>
                    <td class="td_standard" width="90"><%=(String)map.get("REV_TIMING")%></td>
                <% } %>

                <!-- 비고 -->
                <% if (isEditable) { %>
                    <td id="deployDescTD_<%=strDBKey%>" class="td_smallYellowBack" style="padding:0px 2px 0px 2px;">
                        <textarea name="deployDescInput_<%=strDBKey%>" value="<%=(String)map.get("DEPLOY_DESC")%>" 
                                  rows="2" class="input_noBorder3" 
                                  style="width:150px;text-align:left;" onkeydown="inputCtrlKeydownHandler();"
                                  onchange="deployDescInputChanged(this, '<%=strDBKey%>');" ><%=(String)map.get("DEPLOY_DESC")%></textarea>

                    </td>                   
                <% } else { 
                    String str = (String)map.get("DEPLOY_DESC");
                    str = str.replaceAll("\r\n", "<br>");
                    str = str.replaceAll(" ", "&nbsp;");
                    %>
                    <td class="td_standard" style="text-align:left;"><%=str%></td>
                <% } %>
            </tr>
            <%
            }
            %>
        </table>
    <%
    }
    %>

<!-- 구분선택 CHECK BOX (DIV) -->
<div id="gubunSelectDiv" STYLE="position:absolute; display:none;border:#000000 2px solid;">
    <table cellpadding="4" cellspacing="1" style="background-color:#ff9900;font-weight:bold;font-size:12pt;">
        <tr>
        <td>
            <input type="radio" name="inputGubun" value="출도실" 
                   onclick="gubunSelectChanged('출도실');" />출도실<br>
            <input type="radio" name="inputGubun" value="자체" 
                   onclick="gubunSelectChanged('자체');" />자체
        </td>
        </tr>
    </table>
</div> 

<!-- 개정시기 선택 CHECK BOX (DIV) --> <!-- 2010-05-13 부터 사용 X -->
<div id="revTimingSelectDiv" STYLE="position:absolute; display:none;border:#000000 2px solid;">
    <table cellpadding="4" cellspacing="1" style="background-color:#ff9900;font-weight:bold;font-size:12pt;">
        <tr>
        <td>
            <input type="radio" name="inputRevTiming" value="시공 전" 
                   onclick="revTimingSelectChanged('시공 전');" />시공 전<br>
            <input type="radio" name="inputRevTiming" value="시공 후" 
                   onclick="revTimingSelectChanged('시공 후');" />시공 후
        </td>
        </tr>
    </table>
</div> 

<!-- 원인부서 SELECT BOX (DIV) -->
<div id="causeDeptListDiv" STYLE="position:absolute; display:none;">
    <select name="causeDeptList" style="width:220px; background-color:#eeeeee;" onchange="causeDeptListChanged();">
        <option value=""></option>
        <%
        for (int i = 0; departmentList != null && i < departmentList.size(); i++) 
        {
            Map map = (Map)departmentList.get(i);
            String deptCode2 = (String)map.get("DEPT_CODE");
            String deptName = (String)map.get("DEPT_NAME");
            String upDeptName = (String)map.get("UP_DEPT_NAME");
            String deptStr = /*deptCode2 + "&nbsp;&nbsp;&nbsp;&nbsp;" + *//*upDeptName + "-" +*/ deptName;
            %>
            <option value="<%=deptCode2%>"><%=deptStr%></option>
            <%
        }
        %>
    </select>
</div>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script>

    // Docuemnt의 Keydown 핸들러 구현 - 백스페이스 클릭 시 History back 되는 것을 방지 등
    document.onkeydown = keydownHandler;

    // 조회 완료 메시지 
    <% if (updateMode.equalsIgnoreCase("modify")) { %>
        alert("변경 완료");
    <% } else if (updateMode.equalsIgnoreCase("delete")) { %>
        alert("삭제 완료");
    <% } else if (showMsg.equals("") || showMsg.equalsIgnoreCase("true")) { %>
        alert("Search completed!");
    <% } %>

    /*
    // 체크박스 체크/해제
    function toggleCheckBoxes(chkBox)
    {
        var checked = chkBox.checked;
        
        var idx = 0;
        while (true) {
            var chkBoxName = "checkBox_" + String(idx);
            var tempChkBox = document.DPHardCopyDwgViewMain.elements[chkBoxName];
            if (tempChkBox == null) break;

            tempChkBox.checked = checked;
            idx++;
        }
    }
    */

    /** 화면 클릭 시 선택되지 않은 SELECT BOM(DIV) 숨기기 --------------------*/
    var isNewShow = false;
    document.onclick = mouseClickHandler;

    // 마우스 클릭 시 SELECT BOX 컨트롤을 숨긴다(해당 컨트롤에 대한 마우스 클릭이 아닌 경우)
    function mouseClickHandler(e)
    {
        if (isNewShow) {
            isNewShow = false;
            return;
        }

        // 구분선택 CHECK BOX 숨기기
        mouseClickHandlerSubProc(e, gubunSelectDiv);

        // 개정시기 선택 CHECK BOX 숨기기
        mouseClickHandlerSubProc(e, revTimingSelectDiv);

        // 원인부서 선택 SELECT BOX 숨기기
        mouseClickHandlerSubProc(e, causeDeptListDiv);
    }
    // Sub-Procedure
    function mouseClickHandlerSubProc(e, divObj)
    {
        var posX = event.clientX;
        var posY = event.clientY;

        // 호선 SELECT BOM        
        if (divObj.style.display != "none") {
            var objPos = getAbsolutePosition(divObj);
            if (posX < objPos.x || posX > objPos.x + divObj.offsetWidth ||
                posY < objPos.y  || posY > objPos.y + divObj.offsetHeight)
            {
                divObj.style.display = "none";
            }
        }
    }

    /** 현재 선택된 항목 -----------------------------------------------------*/
    var activeRowDBKey = "";

    /** 구분 선택 CHECK BOX(DIV) 보이고 숨기기 -------------------------------*/
    var activeGubunInputObj = null;

    // 구분 선택 CHECK BOX SHOW
    function showGubunSel(inputObj, dbKey)
    {
        activeRowDBKey = dbKey;
        activeGubunInputObj = inputObj;

        var tdObj = document.getElementById("gubunTD_" + dbKey);
        var objPos = getAbsolutePosition(tdObj);
        gubunSelectDiv.style.left = objPos.x;
        gubunSelectDiv.style.top = objPos.y;

        var gubunInputObjs = document.getElementsByName("inputGubun");
        if (gubunInputObjs[0].value == activeGubunInputObj.value) gubunInputObjs[0].checked = true;
        if (gubunInputObjs[1].value == activeGubunInputObj.value) gubunInputObjs[1].checked = true;

        gubunSelectDiv.style.display = "";
        isNewShow = true;
    }

    // 구분선택 CHECK BOX 값 선택 시 DIV는 Hidden, 선택된 값을 Input Box에 반영
    function gubunSelectChanged(selectedVal)
    {
        if (activeGubunInputObj.value != selectedVal) {
            activeGubunInputObj.value = selectedVal;
            document.getElementById("checkBox_" + activeRowDBKey).checked = true;
            activeGubunInputObj.style.backgroundColor = "red";
            document.getElementById("gubunTD_" + activeRowDBKey).style.backgroundColor = "red";
        }

        gubunSelectDiv.style.display = "none";
    }

    /** REV. 값 변경 처리*/
    function revInputChanged(inputObj, dbKey)
    {
        inputObj.value = inputObj.value.toUpperCase();
        document.getElementById("checkBox_" + dbKey).checked = true;
        inputObj.style.backgroundColor = "red";
        document.getElementById("revTD_" + dbKey).style.backgroundColor = "red";
    }

    /** 배포일자 값 변경 처리*/
    function deployDateInputChanged(inputObj, dbKey)
    {
        document.getElementById("checkBox_" + dbKey).checked = true;
        inputObj.style.backgroundColor = "red";
        document.getElementById("deployDateTD_" + dbKey).style.backgroundColor = "red";
    }

    /* ECO NO. 변경 시 출도원인과 비고 값도 변경 처리 */

    // ECO No. 입력 시 존재하는 ECO인지 체크하고, 존재하면 ECO 정보로 출도원인과 비고 값을 자동 입력 
    function checkECONo(ecoNoInputObj, dbKey)
    {
        // ECO 코드 10 자리가 다 입력되었으면 해당 ECO의 정보를 쿼리해서 출도원인과 비고 값도 결정
        var ecoNo = ecoNoInputObj.value.trim();
        if (ecoNo.length == 10) {
            if (isStringNumber(ecoNo) == 0) {
                alert("올바른 ECO NO.를 입력하십시오!");
                //ecoNoInputObj.value = "";
                return false;            
            }

            checkECONoSubProc(ecoNo, ecoNoInputObj, dbKey);
        }
    }

    // ECO 정보를 읽어와서 출도원인과 비고 값을 자동 입력 
    function checkECONoSubProc(ecoNo, ecoNoInputObj, dbKey)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetECOInfo" + 
                            "&ecoNo=" + ecoNo, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
               
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.trim();
                    if (resultMsg == 'ERROR') {
                        alert(resultMsg);
                        //ecoNoInputObj.value = "";
                    }
                    else {
                        if (resultMsg != "") {
                            var str1 = resultMsg.substring(0, resultMsg.indexOf("|"));
                            var str2 = resultMsg.substring(resultMsg.indexOf("|") + 1);
                            document.getElementById("checkBox_" + dbKey).checked = true;
                            ecoNoInputObj.style.backgroundColor = "red";
                            document.getElementById("ecoNoTD_" + dbKey).style.backgroundColor = "red";
                            (document.getElementById("reasonCodeInput_" + dbKey)).value = str1;
                            (document.getElementById("reasonCodeInput_" + dbKey)).style.backgroundColor = "red";
                            document.getElementById("reasonCodeTD_" + dbKey).style.backgroundColor = "red";
                            (document.getElementById("deployDescInput_" + dbKey)).value = str2;
                            (document.getElementById("deployDescInput_" + dbKey)).style.backgroundColor = "red";
                            document.getElementById("deployDescTD_" + dbKey).style.backgroundColor = "red";
                        }
                        else {
                            alert("해당 ECO가 존재하지 않습니다! ECO No. 입력 값을 확인바랍니다.");
                            //ecoNoInputObj.value = "";
                        }
                    }
                }
            }
            else {  alert("ERROR"); }
        }
        else {  alert("ERROR"); }
    }

    /** 출도원인 값 변경 처리*/
    function reasonCodeInputChanged(inputObj, dbKey)
    {
        document.getElementById("checkBox_" + dbKey).checked = true;
        inputObj.style.backgroundColor = "red";
        document.getElementById("reasonCodeTD_" + dbKey).style.backgroundColor = "red";
    }

    /** 출도원인 코드 선택 창을 SHOW -----------------------------------------*/
    function showReasonCodeWin(inputObj, dbKey)
    {
        var sProperties = 'dialogHeight:600px;dialogWidth:600px;scroll=auto;center:yes;resizable=no;status=no;';
        var selectedCode = parent.window.showModalDialog("stxPECDPHardCopyDwgCreate_CodeSelect.jsp", "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            inputObj.value = selectedCode;
            reasonCodeInputChanged(inputObj, dbKey);
        }
    }

    /** (원인)부서 선택 SELECT BOX(DIV) 보이고 숨기기 ------------------------*/
    var activeCauseDeptInputObj = null;

    // 원인부서 선택 SELECT BOX SHOW
    function showCauseDepartSel(inputObj, dbKey)
    {
        activeRowDBKey = dbKey;
        activeCauseDeptInputObj = inputObj;        
        
        var objPos = getAbsolutePosition(activeCauseDeptInputObj);
        causeDeptListDiv.style.left = objPos.x;
        causeDeptListDiv.style.top = objPos.y;

        var str = (document.getElementById("causeDepartInput1_" + dbKey)).value.trim();
        DPHardCopyDwgViewMain.causeDeptList.options.selectedIndex = 0;
        for (var i = 0; i < DPHardCopyDwgViewMain.causeDeptList.options.length; i++) {
            if (DPHardCopyDwgViewMain.causeDeptList.options[i].value == str) {
                DPHardCopyDwgViewMain.causeDeptList.options.selectedIndex = i;
                break;
            }
        }

        causeDeptListDiv.style.display = "";
        isNewShow = true;
    }

    // 원인부서 선택 SELECT BOX 값 선택 시 Select Box는 Hidden, 선택된 값을 Input Box에 반영
    function causeDeptListChanged()
    {
        (document.getElementById("causeDepartInput1_" + activeRowDBKey)).value 
            = DPHardCopyDwgViewMain.causeDeptList.value;
        activeCauseDeptInputObj.value 
            = DPHardCopyDwgViewMain.causeDeptList.options[DPHardCopyDwgViewMain.causeDeptList.options.selectedIndex].text;
        document.getElementById("checkBox_" + activeRowDBKey).checked = true;
        activeCauseDeptInputObj.style.backgroundColor = "red";
        document.getElementById("causeDepartTD_" + activeRowDBKey).style.backgroundColor = "red";

        causeDeptListDiv.style.display = "none";
    }

    /** 개정시기 선택 CHECK BOX(DIV) 보이고 숨기기 ---------------------------*/
    var activeRevTimingInputObj = null;

    // 개정시기 선택 CHECK BOX SHOW
    function showRevTimingSel(inputObj, dbKey, dwgCategory)
    {
        activeRowDBKey = dbKey;
        activeRevTimingInputObj = inputObj;

        /*
        var tdObj = document.getElementById("revTimingTD_" + dbKey);
        var objPos = getAbsolutePosition(tdObj);
        revTimingSelectDiv.style.left = objPos.x;
        revTimingSelectDiv.style.top = objPos.y;

        var revTimingInputObjs = document.getElementsByName("inputRevTiming");
        if (revTimingInputObjs[0].value == activeRevTimingInputObj.value) revTimingInputObjs[0].checked = true;
        if (revTimingInputObjs[1].value == activeRevTimingInputObj.value) revTimingInputObjs[1].checked = true;

        revTimingSelectDiv.style.display = "";
        isNewShow = true;
        */

        var sProperties = 'dialogHeight:200px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var sUrl = "stxPECDPHardCopyDwgCreate_RevTimingSelect.jsp?dwgCategory=" + dwgCategory;
            sUrl = sUrl + "&departCode=" + DPHardCopyDwgViewMain.deptCode.value;
        var selectedCode = window.showModalDialog(sUrl, "", sProperties);
        if (selectedCode != null && selectedCode != 'undefined') {
            revTimingSelectChanged(selectedCode);
        }
    }

    // 개정시기 선택 CHECK BOX 값 선택 시 DIV는 Hidden, 선택된 값을 Input Box에 반영
    function revTimingSelectChanged(selectedVal)
    {
        if (activeRevTimingInputObj.value != selectedVal) {
            activeRevTimingInputObj.value = selectedVal;
            document.getElementById("checkBox_" + activeRowDBKey).checked = true;
            activeRevTimingInputObj.style.backgroundColor = "red";
            document.getElementById("revTimingTD_" + activeRowDBKey).style.backgroundColor = "red";
        }

        revTimingSelectDiv.style.display = "none";
    }

    /** 비고 값 변경 처리 ----------------------------------------------------*/
    function deployDescInputChanged(inputObj, dbKey)
    {
        document.getElementById("checkBox_" + dbKey).checked = true;
        inputObj.style.backgroundColor = "red";
        document.getElementById("deployDescCodeTD_" + dbKey).style.backgroundColor = "red";
    }

    /** 변경사항을 저장 ------------------------------------------------------*/
    function saveHardCopyData()
    {
        var anySelected = false;
        for (var i = 0; i < DPHardCopyDwgViewMain.elements.length; i++) {
            if (DPHardCopyDwgViewMain.elements[i].type == "checkbox") {
                if (DPHardCopyDwgViewMain.elements[i].checked == true && 
                    DPHardCopyDwgViewMain.elements[i].name.indexOf("checkAll") < 0) {
                    anySelected = true;
                    break;
                }
            }
        }

        if (!anySelected) {
            alert("선택된 항목이 하나도 없습니다!");
            return;
        } 

        //  변경없는 입력항목은 Clear... 전송되는 파라미터 길이를 줄이기 위해서.
        for (var i = DPHardCopyDwgViewMain.elements.length - 1; i >= 0; i--) {
            if (DPHardCopyDwgViewMain.elements[i].type == "checkbox" && 
                DPHardCopyDwgViewMain.elements[i].name.indexOf("checkBox_") == 0 &&
                DPHardCopyDwgViewMain.elements[i].checked != true) 
            {
                var dbKey = DPHardCopyDwgViewMain.elements[i].name;                    

                dbKey = dbKey.substring(dbKey.lastIndexOf("_") + 1);
                var aNodeObj = null; 

                aNodeObj = document.getElementById("checkBox_" + dbKey);          if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("gubunInput_" + dbKey);        if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("revInput_" + dbKey);          if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("deployDateInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("reasonCodeInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("causeDepartInput1_" + dbKey); if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("causeDepartInput2_" + dbKey); if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("revTimingInput_" + dbKey);    if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("deployDescInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("ecoNoInput_" + dbKey);        if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
            }
        }

        DPHardCopyDwgViewMain.updateMode.value = "modify";
        DPHardCopyDwgViewMain.action = "stxPECDPHardCopyDwgViewMain.jsp";
        DPHardCopyDwgViewMain.target = "_self";
        DPHardCopyDwgViewMain.submit();
    }

    /** 선택된 항목을 삭제 ---------------------------------------------------*/
    function deleteHardCopyData()
    {
        var anySelected = false;
        for (var i = 0; i < DPHardCopyDwgViewMain.elements.length; i++) {
            if (DPHardCopyDwgViewMain.elements[i].type == "checkbox") {
                if (DPHardCopyDwgViewMain.elements[i].checked == true && 
                    DPHardCopyDwgViewMain.elements[i].name.indexOf("checkAll") < 0) {
                    anySelected = true;
                    break;
                }
            }
        }

        if (!anySelected) {
            alert("선택된 항목이 하나도 없습니다!");
            return;
        } 

        if (!confirm("선택된 항목(들)을 삭제하시겠습니까?")) return;

        //  변경없는 입력항목은 Clear... 전송되는 파라미터 길이를 줄이기 위해서.
        for (var i = DPHardCopyDwgViewMain.elements.length - 1; i >= 0; i--) {
            if (DPHardCopyDwgViewMain.elements[i].type == "checkbox" && 
                DPHardCopyDwgViewMain.elements[i].name.indexOf("checkBox_") == 0) 
            {
                var dbKey = DPHardCopyDwgViewMain.elements[i].name;    
                
                dbKey = dbKey.substring(dbKey.lastIndexOf("_") + 1);
                var aNodeObj = null; 

                if (DPHardCopyDwgViewMain.elements[i].checked != true) {
                    aNodeObj = document.getElementById("checkBox_" + dbKey);          
                    aNodeObj.parentNode.removeChild(aNodeObj);
                }
                aNodeObj = document.getElementById("gubunInput_" + dbKey);        if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("revInput_" + dbKey);          if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("deployDateInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("reasonCodeInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("causeDepartInput1_" + dbKey); if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("causeDepartInput2_" + dbKey); if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("revTimingInput_" + dbKey);    if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
                aNodeObj = document.getElementById("deployDescInput_" + dbKey);   if (aNodeObj != null) aNodeObj.parentNode.removeChild(aNodeObj);
            }
        }

        DPHardCopyDwgViewMain.updateMode.value = "delete";
        DPHardCopyDwgViewMain.action = "stxPECDPHardCopyDwgViewMain.jsp";
        DPHardCopyDwgViewMain.target = "_self";
        DPHardCopyDwgViewMain.submit();
    }

    // utility function
    function isStringNumber(str) 
    {
        var ref="0123456789";
        var sLength=str.length;
        var chr, idx, idx2;

        for(var i=0; i<sLength; i++) {
            chr=str.charAt(i);
            idx=ref.indexOf(chr);
            if(idx==-1) {
                return 0;
            }
        }
        
        return 1;
    }

</script>


</html>