<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 파일 열기 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocumentView.jsp
--%>

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
        String file_id = request.getParameter("file_id");

        // DB Connection
        conn = DBConnect.getDBConnection("ERP_APPS");

        StringBuffer sSql = new StringBuffer();
        sSql.append("SELECT L.FILE_ID, L.FILE_NAME, L.FILE_DATA         \n");
        sSql.append("  FROM FND_LOBS               L                    \n");
        sSql.append("      ,FND_DOCUMENTS_TL       TL                   \n");
        sSql.append("      ,FND_ATTACHED_DOCUMENTS A                    \n");
        sSql.append(" WHERE A.DOCUMENT_ID = TL.DOCUMENT_ID              \n");
        sSql.append("   AND TL.MEDIA_ID   = L.FILE_ID                   \n");
        sSql.append("   AND TL.LANGUAGE   = USERENV('LANG')             \n");
        sSql.append("   AND A.ENTITY_NAME = 'STX_PLM_EP_INFO_DOCUMENTS' \n");
        sSql.append("   AND A.PK1_VALUE = '"+ file_id+"'                \n");

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
           // String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
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
            errMsg = "관련 문서를 찾을 수 없습니다.";
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
