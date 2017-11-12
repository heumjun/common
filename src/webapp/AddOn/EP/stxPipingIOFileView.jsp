<%--  
��DESCRIPTION: ������ ���� ���� �� DP���� ���հ��� ��������û/�Ϸ� ���� �ٿ�ε� ȭ��
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECEquipItemPurchasingScheduleManagementFileView_1.jsp
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@include file="include/stx_jdbc_util.jspf"%>
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
        String FILEID = request.getParameter("FILEID");
        conn = DBConnect.getDBConnection("PLM");

        StringBuffer sbSql = new StringBuffer();
        sbSql.append("SELECT     						\n");
        sbSql.append(" ATTACHMENT,FILENAME    						\n");
        sbSql.append("from STX_PIPING_IO_FILE                             \n");
        sbSql.append("WHERE FILEID = '"+FILEID+"'       			\n");
  
        stmt = conn.createStatement(); 
        rs = stmt.executeQuery(sbSql.toString());
        
        String FILENAME = "";
        if (rs.next()) {
        	FILENAME = rs.getString(2);
        	oracle.sql.BLOB blob = (oracle.sql.BLOB)rs.getBlob(1);

            out.clear();
            out=pageContext.pushBody();
            InputStream in = blob.getBinaryStream();           

            BufferedOutputStream outBW = new BufferedOutputStream(response.getOutputStream());
            //String convName =  java.net.URLEncoder.encode(new String(fileName.getBytes("8859_1"), "euc-kr"),"UTF-8"); 
            String convName = new String(FILENAME.getBytes("euc-kr"), "8859_1");
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
        errMsg = "Download Error!";
        System.out.println(errMsg);
    } 
    finally 
    {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        DBConnect.closeConnection(conn);
    }
         
%>
File Down
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