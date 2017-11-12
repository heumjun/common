<%--  
§DESCRIPTION: 설계시수입력 - 입력시수 조회 메인 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_InputListViewMain.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
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

	// getDesignMHInputsList() : 선택 조건에 따라 해당 조건에 맞는 시수입력 사항들을 조회
	private ArrayList getDesignMHInputsList(String deptCode, String designerID, String dateFrom, String dateTo, String projectNo, 
	        String causeDeptCode, String[] drawingNoArray, String opCode, String e1, String e2, String e3) throws Exception
	{
		//if (StringUtil.isNullString(deptCode)) throw new Exception("Department Code is null");
		//if (StringUtil.isNullString(designerID)) throw new Exception("Designer ID is null");

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
			queryStr.append("SELECT A.PROJECT_NO,                                                                                                            ");
			queryStr.append("       TO_CHAR(A.WORK_DAY, 'YYYY-MM-DD') AS WORKDAY,                                                                            ");
			queryStr.append("       DECODE(TO_CHAR(A.WORK_DAY, 'D'), '1','일', '2','월', '3','화', '4','수', '5','목', '6','금', '7','토')  AS WEEKDAY,      ");
			queryStr.append("       (SELECT DECODE(B.ISWORKDAY, 'Y', '평일', 'N', '휴일') FROM CCC_CALENDAR B WHERE B.WORKINGDAY = A.WORK_DAY) AS HOLIDAYYN, ");
			queryStr.append("       A.EMPLOYEE_NO,                                                                                                           ");
			queryStr.append("       (SELECT C.NAME FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS EMP_NAME,                                       ");
			queryStr.append("       A.DWG_CODE,                                                                                                              ");
			queryStr.append("       A.OP_CODE,                                                                                                               ");
			queryStr.append("       (SELECT C.DEPT_CODE FROM CCC_SAWON C WHERE C.EMPLOYEE_NUM = A.EMPLOYEE_NO) AS EMP_DEPT,                                  ");
			queryStr.append("       A.CAUSE_DEPART, A.BASIS, A.NORMAL_TIME, A.OVERTIME, A.SPECIAL_TIME, A.EVENT1, A.EVENT2, A.EVENT3,                        ");
			queryStr.append("       (SELECT B.VALUE FROM PLM_CODE_TBL B WHERE B.CATEGORY='OP_CODE' AND B.KEY=A.OP_CODE) AS OP_STR,                           ");
            queryStr.append("       WORK_DESC                                                                                                                ");
			queryStr.append("  FROM PLM_DESIGN_MH A                                                                                                          ");
			queryStr.append(" WHERE 1 = 1                                                                                                                    ");
			queryStr.append("   AND A.OP_CODE<>'90'                                                                                                          ");
			if (designerID.equals("") && !deptCode.equals(""))
				queryStr.append("   AND A.DEPT_CODE='" + deptCode + "'                                                                                       ");
			if (!designerID.equals(""))
				queryStr.append("   AND A.EMPLOYEE_NO='" + designerID + "'                                                                                   ");
			if (!dateFrom.equals("") && !dateTo.equals(""))
				queryStr.append("   AND A.WORK_DAY BETWEEN TO_DATE('" + dateFrom + "', 'YYYY-MM-DD') AND TO_DATE('" + dateTo + "', 'YYYY-MM-DD')             ");
			if (!projectNo.equals(""))
				queryStr.append("   AND A.PROJECT_NO = '" + projectNo + "'                                                                                   ");
			if (!causeDeptCode.equals(""))
				queryStr.append("   AND A.CAUSE_DEPART = '" + causeDeptCode + "'                                                                             ");
			if (hasDrawingNo)
				queryStr.append("   AND A.DWG_CODE LIKE '" + drawingNo + "'                                                                                  ");
			if (!opCode.equals(""))
				queryStr.append("   AND A.OP_CODE LIKE '" + opCode + "%'                                                                                     ");
			if (e1.equalsIgnoreCase("true"))
				queryStr.append("   AND A.EVENT1 IS NOT NULL                                                                                                 ");
			if (e2.equalsIgnoreCase("true"))
				queryStr.append("   AND A.EVENT2 IS NOT NULL                                                                                                 ");
			if (e3.equalsIgnoreCase("true"))
				queryStr.append("   AND A.EVENT3 IS NOT NULL                                                                                                 ");
			queryStr.append(" ORDER BY A.WORK_DAY ASC, A.PROJECT_NO, A.START_TIME                                                                            ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PROJECT_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("WORKDAY", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("WEEKDAY", rset.getString(3) == null ? "" : rset.getString(3));
				resultMap.put("HOLIDAYYN", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("EMPLOYEE_NO", rset.getString(5) == null ? "" : rset.getString(5));
				resultMap.put("EMP_NAME", rset.getString(6) == null ? "" : rset.getString(6));
				resultMap.put("DWG_CODE", rset.getString(7) == null ? "" : rset.getString(7));
				resultMap.put("OP_CODE", rset.getString(8) == null ? "" : rset.getString(8));
				resultMap.put("EMP_DEPT", rset.getString(9) == null ? "" : rset.getString(9));
				resultMap.put("CAUSE_DEPART", rset.getString(10) == null ? "" : rset.getString(10));
				resultMap.put("BASIS", rset.getString(11) == null ? "" : rset.getString(11));
				resultMap.put("NORMAL", rset.getString(12) == null ? "" : rset.getString(12));
				resultMap.put("OVERTIME", rset.getString(13) == null ? "" : rset.getString(13));
				resultMap.put("SPECIAL", rset.getString(14) == null ? "" : rset.getString(14));
				resultMap.put("EVENT1", rset.getString(15) == null ? "" : rset.getString(15));
				resultMap.put("EVENT2", rset.getString(16) == null ? "" : rset.getString(16));
				resultMap.put("EVENT3", rset.getString(17) == null ? "" : rset.getString(17));
				resultMap.put("OP_STR", rset.getString(18) == null ? "" : rset.getString(18));
				resultMap.put("WORK_DESC", rset.getString(19) == null ? "" : rset.getString(19));
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
    String designerID = StringUtil.setEmptyExt(emxGetParameter(request, "designerID"));
    String dateFrom = StringUtil.setEmptyExt(emxGetParameter(request, "dateFrom"));
    String dateTo = StringUtil.setEmptyExt(emxGetParameter(request, "dateTo"));
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String causeDeptCode = StringUtil.setEmptyExt(emxGetParameter(request, "causeDeptCode"));
    String drawingNo1 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo1"));
    String drawingNo2 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo2"));
    String drawingNo3 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo3"));
    String drawingNo4 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo4"));
    String drawingNo5 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo5"));
    String drawingNo6 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo6"));
    String drawingNo7 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo7"));
    String drawingNo8 = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo8"));
    String opCode = StringUtil.setEmptyExt(emxGetParameter(request, "opCode"));
    String e1 = StringUtil.setEmptyExt(emxGetParameter(request, "e1"));
    String e2 = StringUtil.setEmptyExt(emxGetParameter(request, "e2"));
    String e3 = StringUtil.setEmptyExt(emxGetParameter(request, "e3"));

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

    ArrayList dpInputsList = null;
    try {
        String[] drawingNoArray = {drawingNo1, drawingNo2, drawingNo3, drawingNo4, drawingNo5, drawingNo6, drawingNo7, drawingNo8};
        dpInputsList = getDesignMHInputsList(deptCode, designerID, dateFrom, dateTo, projectNo, causeDeptCode, drawingNoArray, opCode, e1, e2, e3);
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    float normalTimeSum = 0;
    float overtimeSum = 0;
    float specialTimeSum = 0;
%>


<%--========================== HTML HEAD ===================================--%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.util.StringUtil"%>
<html>
<head>
    <title>시 수 체 크</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#ffffff">
<form name="DPInputListViewMain">

    <table width="100%" cellSpacing="0" cellpadding="0" border="0">
        <tr height="2"><td></td></tr>
    </table>
    
    <div id="designHoursCheckTable" STYLE="width:100%; height:94%; overflow:auto; position:relative;">
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standardSmall">공사번호</td>
            <td class="td_standardSmall">작업일자</td>
            <td class="td_standardSmall">요일</td>
            <td class="td_standardSmall">휴일</td>
            <td class="td_standardSmall">사번</td>
            <td class="td_standardSmall">성명</td>
            <td class="td_standardSmall">부서</td>
            <td class="td_standardSmall">도면번호</td>
            <td class="td_standardSmall">OP코드</td>
            <td class="td_standardSmall">원인파트</td>
            <td class="td_standardSmall">근거</td>
            <td class="td_standardSmall">업무내용</td>
            <td class="td_standardSmall">상근</td>
            <td class="td_standardSmall">연근</td>
            <td class="td_standardSmall">특근</td>
            <td class="td_standardSmall">E1</td>
            <td class="td_standardSmall">E2</td>
            <td class="td_standardSmall">E3</td>
        </tr>

        <%
        for (int i = 0; dpInputsList != null && i < dpInputsList.size(); i++) 
        {
            Map map = (Map)dpInputsList.get(i);

            String normalTime = (String)map.get("NORMAL");
            String overtime = (String)map.get("OVERTIME");
            String specialTime = (String)map.get("SPECIAL");
            if (!normalTime.equals("")) normalTimeSum += Float.parseFloat(normalTime);
            if (!overtime.equals("")) overtimeSum += Float.parseFloat(overtime);
            if (!specialTime.equals("")) specialTimeSum += Float.parseFloat(specialTime);
            %>
            <tr height="15" bgcolor="#ffffff" >
                <td class="td_standardSmall"><%=(String)map.get("PROJECT_NO")%></td>
                <td class="td_standardSmall"><%=(String)map.get("WORKDAY")%></td>
                <td class="td_standardSmall"><%=(String)map.get("WEEKDAY")%></td>
                <td class="td_standardSmall"><%=(String)map.get("HOLIDAYYN")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EMPLOYEE_NO")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EMP_NAME")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EMP_DEPT")%></td>
                <td class="td_standardSmall"><%=(String)map.get("DWG_CODE")%></td>
                <td class="td_standardSmall" style="text-align:left;">&nbsp;<%=(String)map.get("OP_CODE") + ":" + (String)map.get("OP_STR")%></td>
                <td class="td_standardSmall"><%=(String)map.get("CAUSE_DEPART")%></td>
                <td class="td_standardSmall"><%=(String)map.get("BASIS")%></td>
                <td class="td_standardSmall" style="text-align:left;">&nbsp;<%=(String)map.get("WORK_DESC")%></td>
                <td class="td_standardSmall"><%=(String)map.get("NORMAL")%></td>
                <td class="td_standardSmall"><%=(String)map.get("OVERTIME")%></td>
                <td class="td_standardSmall"><%=(String)map.get("SPECIAL")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EVENT1")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EVENT2")%></td>
                <td class="td_standardSmall"><%=(String)map.get("EVENT3")%></td>
            </tr>
            <%
        }
        %>
    </table>
    </div>

    <div id="designHoursCheckSum" STYLE="width:100%; overflow:hidden; position:relative;">
    <table width="100%" cellSpacing="1" cellpadding="0" border="0" align="right" bgcolor="#cccccc">
        <tr>
            <td width="70%">&nbsp;</td>
            <td class="td_standardBold"><font color="#ff0000">상근: <%=Float.toString(normalTimeSum)%></font></td>
            <td class="td_standardBold"><font color="#ff0000">연근: <%=Float.toString(overtimeSum)%></font></td>
            <td class="td_standardBold"><font color="#ff0000">특근: <%=Float.toString(specialTimeSum)%></font></td>
            <td width="30">&nbsp;</td>
        </tr>
    </table>
    </div>

</form>
</body>
</html>