<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 취소된 PR 삭제
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterDeletePR.jsp
§CHANGING HISTORY: 
§    2011-04-22: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

	// deletePR() : PR 항목 삭제
	private void deletePR(String projectNo, String prNo, String drawingNo) throws Exception
	{
        if (StringUtil.isNullString(projectNo)) throw new Exception("projectNo. is null");
        if (StringUtil.isNullString(prNo)) throw new Exception("Pr No. is null");
        if (StringUtil.isNullString(drawingNo)) throw new Exception("drawingNo is null");
	
		java.sql.Connection conn = DBConnect.getDBConnection("ERP_APPS");

        java.sql.Statement stmt = null;
        java.sql.ResultSet rset = null;


		try
		{
            StringBuffer selectQuery = new StringBuffer();
            selectQuery.append("SELECT *                                         \n");
            selectQuery.append("  FROM STX_PO_EQUIPMENT_DP                       \n");
            selectQuery.append(" WHERE PROJECT_NUMBER = '"+projectNo+"'          \n");
            selectQuery.append("   AND DRAWING_NO = '"+drawingNo+"'              \n");
            selectQuery.append("   AND PR_NO = '"+prNo+"'                        \n");
			
            stmt = conn.createStatement();
            rset = stmt.executeQuery(selectQuery.toString());
			if (rset.next()) {
                StringBuffer deleteQuery = new StringBuffer();
                deleteQuery.append("DELETE STX_PO_EQUIPMENT_DP                   \n");
                deleteQuery.append(" WHERE PROJECT_NUMBER = '"+projectNo+"'      \n");
                deleteQuery.append("   AND DRAWING_NO = '"+drawingNo+"'            \n");
                deleteQuery.append("   AND PR_NO = '"+prNo+"'                    \n");

                stmt.executeUpdate(deleteQuery.toString());
                DBConnect.commitJDBCTransaction(conn);

			} else {
                throw new Exception("PR Data is not exist!");
            }
		}
		catch (Exception e)
		{
			DBConnect.rollbackJDBCTransaction(conn);
			e.printStackTrace();
			throw e;
		}
		finally
		{
            if (rset != null) rset.close();
            if (stmt != null) stmt.close();        
			DBConnect.closeConnection(conn);
		}
	}

%>


<%--========================== JSP =========================================--%>
<%
    String resultMsg = "PR Delete !";
    String projectNo = emxGetParameter(request, "projectNo");
    String prNo = emxGetParameter(request, "prNo");  
    String drawingNo = emxGetParameter(request, "drawingNo"); 

    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String inputMakerListYN = StringUtil.setEmptyExt(emxGetParameter(request, "inputMakerListYN"));
    String loginID = StringUtil.setEmptyExt(emxGetParameter(request, "loginID"));

    String errStr = "";
    try {
        deletePR(projectNo, prNo, drawingNo);
    }
    catch (Exception e) {
        resultMsg = e.toString();
    }

%>

<script language="javascript">

    var urlStr = "stxPECEquipItemPurchasingScheduleManagementRegisterMain.jsp?projectNo=<%=projectNo%>";
    urlStr += "&deptCode=<%=deptCode%>";
    urlStr += "&inputMakerListYN=<%=inputMakerListYN%>";
    urlStr += "&loginID=<%=loginID%>";

    alert("<%=resultMsg%>");
    window.close();
    opener.parent.EQUIP_ITEM_PURCHASING_MANAGEMENT_MAIN.location = urlStr;

</script>