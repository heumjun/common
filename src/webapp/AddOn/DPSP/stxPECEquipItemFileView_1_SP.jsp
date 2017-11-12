<%--  
��DESCRIPTION: ������ ���� ���� �� DP���� ���հ��� ��������û/�Ϸ� ���� �ٿ�ε� ȭ��
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECEquipItemFileView_1_SP.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    
    String errMsg = "";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try
    {
        String project = request.getParameter("project");
        String drawingNo = request.getParameter("drawingNo");

        // DB Connection
        conn = DBConnect.getDBConnection("ERP_APPS");

        StringBuffer sSql = new StringBuffer();
        sSql.append("SELECT B.FILE_ID, B.FILE_NAME, B.FILE_DATA                               \n");
        sSql.append("  FROM ( SELECT FILE_ID                                                  \n");
        sSql.append("           FROM STX_PO_EQUIPMENT_REQUEST                                 \n");
        sSql.append("          WHERE PROJECT_NUMBER = '"+project+"'                           \n");
        sSql.append("            AND DRAWING_NO = '"+drawingNo+"'                             \n");
        sSql.append("            AND DRAW_REQUEST_FLAG = 'Y'                                  \n");
        sSql.append("            AND REVISION_NUM = ( SELECT MAX(REVISION_NUM)                \n");
        sSql.append("                                   FROM STX_PO_EQUIPMENT_REQUEST         \n");
        sSql.append("                                  WHERE PROJECT_NUMBER = '"+project+"'   \n");
        sSql.append("                                    AND DRAWING_NO = '"+drawingNo+"'     \n");
        sSql.append("                                    AND DRAW_REQUEST_FLAG = 'Y' )        \n");
        sSql.append("       )         A,                                                      \n");
        sSql.append("       FND_LOBS  B                                                       \n");
        sSql.append(" WHERE A.FILE_ID = B.FILE_ID                                             \n");
  
        stmt = conn.createStatement(); 
        rs = stmt.executeQuery(sSql.toString());

        String fileName = "";
        oracle.sql.BLOB blob = null;
        if (rs.next()) {
            fileName = (String)rs.getString(2);
            blob = (oracle.sql.BLOB)rs.getBlob(3);

            out.clear();
            out=pageContext.pushBody();
            InputStream in = blob.getBinaryStream();           

            BufferedOutputStream outBW = new BufferedOutputStream(response.getOutputStream());
            //String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
            String convName = new String(fileName.getBytes("euc-kr"), "8859_1");
           
            response.setHeader("Content-Type", "application/octet-stream;");
            response.setHeader("Content-Disposition", "attachment;filename=" + convName + ";");

            byte[] buffer = new byte[10*1024];
            int n = 0;

            while ((n = in.read(buffer)) != -1) {
                outBW.write(buffer, 0, n);
                outBW.flush();
            }

            outBW.close();
            in.close();
        } else {
            errMsg = "�ұ� Data�̰ų� �����û ������ ã�� �� �����ϴ�.";
        }
    } 
    catch (Exception e)
    {
        errMsg = e.toString();
        System.out.println(errMsg);
    } 
    finally 
    {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        DBConnect.closeConnection(conn);
    }
         
%>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
<%
    if(!"".equals(errMsg))
    {
%>
        alert("<%=errMsg%>");
<%
    }
%>
    window.close();
</script>