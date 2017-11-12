<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>

<%--========================== JSP =========================================--%>
<%!
	public static String isNullString(String checkString){
		if(checkString==null || "null".equalsIgnoreCase(checkString) || "".equals(checkString) || "undefined".equals(checkString)){
			return "";
		}else{
			return checkString;
		}
	}
%>
<%
	request.setCharacterEncoding("euc-kr");
	//projectNo , docProjectNo , sendYN , ownerSendCount , ownerReturnCount , classSendCount , classReturnCount
	String projectNo 		= isNullString(request.getParameter("projectNo"));
	String docProjectNo 	= isNullString(request.getParameter("docProjectNo"));
	String sendYN 			= isNullString(request.getParameter("sendYN"));
	String ownerSendCount 	= isNullString(request.getParameter("ownerSendCount"));
	String ownerReturnCount = isNullString(request.getParameter("ownerReturnCount"));
	String classSendCount 	= isNullString(request.getParameter("classSendCount"));
	String classReturnCount	= isNullString(request.getParameter("classReturnCount"));
	
	//System.out.println("projectNo === "+projectNo);
	//System.out.println("docProjectNo === "+docProjectNo);
	//System.out.println("sendYN === "+sendYN);
	//System.out.println("ownerSendCount === "+ownerSendCount);
	//System.out.println("ownerReturnCount === "+ownerReturnCount);
	//System.out.println("classSendCount === "+classSendCount);
	//System.out.println("classReturnCount === "+classReturnCount);
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	conn.setAutoCommit(false);
	
	StringBuffer deleteSQL = new StringBuffer();
	deleteSQL.append("delete ");
	deleteSQL.append("  from stx_oc_project_send_number ");
	deleteSQL.append(" where project = '"+projectNo+"'");
	
	Statement stmt = conn.createStatement();
	stmt.executeQuery(deleteSQL.toString());
	
	conn.commit();
	
	StringBuffer insertSQL = new StringBuffer();
	insertSQL.append("insert into stx_oc_project_send_number( ");
	insertSQL.append("       project , ");
	insertSQL.append("       doc_project , ");
	insertSQL.append("       send_flag , ");
	insertSQL.append("       owner_send_number , ");
	insertSQL.append("       owner_return_number , ");
	insertSQL.append("       class_send_number , ");
	insertSQL.append("       class_return_number )");
	insertSQL.append("values( ");
	insertSQL.append("       '"+projectNo+"', ");
	insertSQL.append("       '"+docProjectNo+"', ");
	insertSQL.append("       '"+sendYN+"', ");
	insertSQL.append("       '"+ownerSendCount+"', ");
	insertSQL.append("       '"+ownerReturnCount+"', ");
	insertSQL.append("       '"+classSendCount+"', ");
	insertSQL.append("       '"+classReturnCount+"') ");
	
	Statement stmt2 = conn.createStatement();
	stmt2.executeQuery(insertSQL.toString());
	
	conn.commit();
	
	if(stmt!=null)
		stmt.close();
	if(stmt2!=null)
		stmt2.close();
	if(conn!=null)
		conn.close();
	
%>
	<%="Success"%>
	
	