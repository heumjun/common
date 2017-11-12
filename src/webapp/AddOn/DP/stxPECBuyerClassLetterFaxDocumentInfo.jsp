<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%--========================== JSP =========================================--%>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	String project = request.getParameter("project");
	String document = request.getParameter("document");
	
	String returnString = "";
	
	String projectNo		= "";
	String documentNo		= "";
	String subject			= "";
	String docDate			= "";
	String sendReceiveDept 	= "";
	String refDept			= "";
	String sender			= "";
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	Statement stmt = conn.createStatement();
	
	StringBuffer selectDateSQL = new StringBuffer();
	selectDateSQL.append("SELECT PROJECT ");
	selectDateSQL.append("     , REF_NO ");
	selectDateSQL.append("     , SUBJECT ");
	selectDateSQL.append("     , TO_CHAR(SEND_RECEIVE_DATE , 'YYYY-MM-DD')");
	selectDateSQL.append("     , SEND_RECEIVE_DEPT ");
	selectDateSQL.append("     , REF_DEPT ");
	selectDateSQL.append("     , SENDER ");
	selectDateSQL.append("  FROM stx_oc_document_list ");
	selectDateSQL.append(" WHERE PROJECT = '"+project+"' ");
	selectDateSQL.append("   AND ref_no = '"+document+"' ");
	
	java.sql.ResultSet selectDateRset = stmt.executeQuery(selectDateSQL.toString());
	
	while(selectDateRset.next()){
		
		projectNo			= selectDateRset.getString(1)==null?"":selectDateRset.getString(1);
		documentNo			= selectDateRset.getString(2)==null?"":selectDateRset.getString(2);
		subject				= selectDateRset.getString(3)==null?"":selectDateRset.getString(3);
		docDate				= selectDateRset.getString(4)==null?"":selectDateRset.getString(4);
		sendReceiveDept 	= selectDateRset.getString(5)==null?"":selectDateRset.getString(5);
		refDept				= selectDateRset.getString(6)==null?"":selectDateRset.getString(6);
		sender				= selectDateRset.getString(7)==null?"":selectDateRset.getString(7);
	}
	
	returnString = projectNo 
			 +"|"+ documentNo 
			 +"|"+ subject 
			 +"|"+ docDate 
			 +"|"+ sendReceiveDept 
			 +"|"+ refDept 
			 +"|"+ sender;
	
	//System.out.println(returnString);
	%>
	
	<%=returnString %>
	
	