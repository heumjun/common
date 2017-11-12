 <%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 조회 - 부서(파트)의 구성원(파트원) 목록을 쿼리
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementSearchPartPersons.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!	// getPartPersons() : 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외
	private static synchronized ArrayList getPartPersons(String departCode) throws Exception
	{
		if (StringUtil.isNullString(departCode)) throw new Exception("Department Code is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");
			StringBuffer queryStr = new StringBuffer();
			queryStr.append("SELECT A.EMPLOYEE_NUM, A.NAME, A.WORK_TELEPHONE ");
			queryStr.append("  FROM CCC_SAWON A                              ");
			queryStr.append(" WHERE A.DEPT_CODE = '" + departCode + "'       ");
			queryStr.append("   AND TERMINATION_DATE IS NULL                 ");
			queryStr.append("   AND INPUT_MAN_HOUR_ENABLED = 'Y'             ");
			queryStr.append(" ORDER BY A.EMPLOYEE_NUM                        ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("EMPLOYEE_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("EMPLOYEE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("PHONE", rset.getString(3) == null ? "" : rset.getString(3));
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

<%
String resultMsg = "";
String departCode = request.getParameter("departCode");

try 
{ 
    ArrayList resultArrayList = getPartPersons(departCode); 
    for (int i = 0; i < resultArrayList.size(); i++)
    {
	Map map = (Map)resultArrayList.get(i);
	if (!resultMsg.equals("")) resultMsg += "+";
			resultMsg += (String)map.get("EMPLOYEE_NO") + "|" + (String)map.get("EMPLOYEE_NAME");
    }
}catch (Exception e) {
    resultMsg = "ERROR";
}
%>
<%=resultMsg%>