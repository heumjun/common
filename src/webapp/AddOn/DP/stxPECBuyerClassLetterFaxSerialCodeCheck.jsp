<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%--========================== JSP =========================================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
	
	String project = request.getParameter("project");
	String ownerClass = request.getParameter("ownerClass");
	
	String returnString = "";
	
	String docNum = "";
	
	Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");
	
	StringBuffer selectDocNumSQL = new StringBuffer();
	selectDocNumSQL.append("select to_char(nvl(max(to_number(substr(ref_no , instr(ref_no , '-' , 1 , 2)+1)))+1,1) , 'FM0000') ");
	selectDocNumSQL.append("  from stx_oc_document_list ");
	//selectDocNumSQL.append(" where project = (SELECT seriesprojectno ");
	//selectDocNumSQL.append("                    FROM LPM_NEWPROJECT a ");
	//selectDocNumSQL.append("                   WHERE a.CASENO = '1' ");
	//selectDocNumSQL.append("                     AND a.projectno = '"+project+"') ");
	//대표호선 기준 시리얼 넘버 부여
	//selectDocNumSQL.append(" where project in (select projectno ");
	//selectDocNumSQL.append("                 	 from lpm_newproject ");
	//selectDocNumSQL.append("                	where caseno = '1' ");
	//selectDocNumSQL.append("                  	  and DWGSERIESPROJECTNO = (SELECT DWGSERIESPROJECTNO ");
	//selectDocNumSQL.append("                      	                          FROM LPM_NEWPROJECT a ");
	//selectDocNumSQL.append("                          	                  	 WHERE a.CASENO = '1' ");
	//selectDocNumSQL.append("                              	                   AND a.projectno = '"+project+"')) ");
	//문서호선 기준 시리얼 넘버 부여
	selectDocNumSQL.append(" where project in (select project ");
	selectDocNumSQL.append("                 	 from stx_oc_project_send_number ");
	selectDocNumSQL.append("                 	where DOC_PROJECT = (SELECT DOC_PROJECT ");
	selectDocNumSQL.append("                 	                       FROM stx_oc_project_send_number a ");
	selectDocNumSQL.append("                 	                      WHERE a.project = '"+project+"')) ");
	selectDocNumSQL.append("   and send_receive_type = 'send' ");
	selectDocNumSQL.append("   and instr(ref_no , '-' , 1 , 2) > 0 ");
	selectDocNumSQL.append("   and owner_class_type = '"+ownerClass+"' ");
	
	java.sql.Statement stmt = conn.createStatement();
	java.sql.ResultSet selectDocNumRset = stmt.executeQuery(selectDocNumSQL.toString());
	
	while(selectDocNumRset.next()){
		docNum = selectDocNumRset.getString(1)==null?"":selectDocNumRset.getString(1);
	}
	
	returnString = docNum;
	//System.out.println(returnString);
	%>
	
	<%=returnString %>
	
	