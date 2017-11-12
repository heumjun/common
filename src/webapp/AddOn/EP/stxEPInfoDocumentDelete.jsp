<%--  
��DESCRIPTION: EP ǰ�� �������� ��ȸ - �޴��� �� ����� ���� ����
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxEPInfoDocumentDelete.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    String loginID = request.getParameter("loginID");
    String select_value = request.getParameter("select_value");  // ������ file_id

    Connection conn = null;
    Statement stmt  = null;

    if(!"".equals(select_value))
    {
        try
        {

            conn = DBConnect.getDBConnection("ERP_APPS");
            StringBuffer queryStr = new StringBuffer();

            // �׸� ��ü�� �����ϴ� ���� �ƴ϶� disable ó����.
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
    var urlStr = "stxEPInfoDocuments.jsp?loginID=<%=loginID%>";     
    parent.DOCUMENT_FRAME_MAIN.location = urlStr; 
    window.close();

</script>