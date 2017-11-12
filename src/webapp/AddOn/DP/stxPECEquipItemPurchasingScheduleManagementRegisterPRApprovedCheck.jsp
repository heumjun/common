<%--  
§DESCRIPTION: 자재 발주 관리 및 DP일정 통합관리 등록 - 기자재 도면의 PR이 승인되어 있는지 체크
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterPRApprovedCheck.jsp
--%>

<%@ page import = "com.stx.common.util.*"%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%

String projectNo = emxGetParameter(request, "projectNo");
String drawingNo = emxGetParameter(request, "drawingNo");
String resultMsg = "YES";
try
{
    Connection conn = null;
    Statement stmt = null;
    ResultSet rset = null;
    try
    {
        conn = DBConnect.getDBConnection("ERP_APPS");

        StringBuffer prCheckQuery = new StringBuffer();
        prCheckQuery.append("SELECT AUTHORIZATION_STATUS                                     \n");
        prCheckQuery.append("  FROM STX_PO_EQUIPMENT_DP SPED,                                \n");
        prCheckQuery.append("       PO_REQUISITION_HEADERS_ALL PRHA                          \n");
        prCheckQuery.append(" WHERE SPED.REQUISITION_HEADER_ID = PRHA.REQUISITION_HEADER_ID  \n");
        prCheckQuery.append("   AND PROJECT_NUMBER = '"+projectNo+"'                         \n"); 
        prCheckQuery.append("   AND DRAWING_NO = '"+drawingNo+"'                             \n");

        stmt = conn.createStatement();
        rset = stmt.executeQuery(prCheckQuery.toString());

        while (rset.next())
        {
            if(!"APPROVED".equals(rset.getString(1)))
            {
                resultMsg = "NO";
                break;
            }
        }
       
    } catch (Exception ex) {
        System.out.println("exception   :  stxPECEquipItemPurchasingScheduleManagementRegisterPRApprovedCheck");
        ex.printStackTrace();
        throw ex;
    }
    finally {
        if (rset != null) rset.close();
        if (stmt != null) stmt.close();
        DBConnect.closeConnection(conn);
    }

}catch(Exception e) {
	resultMsg = "ERROR";
    e.printStackTrace();
}

%>

<%=resultMsg%>
