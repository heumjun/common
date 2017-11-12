<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 파일 삭제
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocumentDelete.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%
	/* String loginID = request.getParameter("loginID"); */
	Map loginUser = (Map) request.getSession().getAttribute("loginUser");
	// String loginID = SessionUtils.getUserId();
	String loginID = (String) loginUser.get("user_id");

    String select_value = request.getParameter("select_value");  // 삭제할 file_id

    Connection conn = null;
    Statement stmt  = null;

    if(!"".equals(select_value))
    {
        try
        {

            conn = DBConnect.getDBConnection("ERP_APPS");
            StringBuffer queryStr = new StringBuffer();

            // 항목 자체를 삭제하는 것이 아니라 disable 처리함.
            queryStr.append("UPDATE STX_PLM_EP_INFO_DOCUMENTS                 \n");
            queryStr.append("   SET DISABLE_DATE = SYSDATE                    \n");
            queryStr.append(" WHERE FILE_ID = "+select_value+"                \n");

            stmt = conn.createStatement();
            stmt.executeUpdate(queryStr.toString());

            DBConnect.commitJDBCTransaction(conn);
        }
        catch (Exception e) {
            DBConnect.rollbackJDBCTransaction(conn);
            e.printStackTrace();
        }
        finally{
            try {
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        } 

    }

%>

<script language="javascript">
    var urlStr = "documentView.do?loginID=<%=loginID%>";     
    self.location = urlStr; 
    window.close();

</script>