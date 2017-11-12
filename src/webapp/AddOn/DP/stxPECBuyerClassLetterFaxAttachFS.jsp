<html>
<%@ page import = "java.util.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>

<%
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");	
	//String languageStr 		= request.getHeader("Accept-Language");
	String buyerClassLetterFaxAttachHead = "";
	String buyerClassLetterFaxAttachBody	= "";

	buyerClassLetterFaxAttachHead = "stxPECBuyerClassLetterFaxAttachHead.jsp";
	buyerClassLetterFaxAttachBody = "stxPECBuyerClassLetterFaxAttachBody.jsp";
	
	String framesetRows = "*,0,0";
	
	String adminYN = "N";
	
	java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");

	StringBuffer queryStr = new StringBuffer();
	queryStr.append("select 'X' 								     ");
	queryStr.append("  from CCC_SAWON A 							 ");
	queryStr.append("     , DCC_DEPTCODE B  						 ");
	queryStr.append("     , DCC_DWGDEPTCODE C						 ");
	queryStr.append(" where A.EMPLOYEE_NUM = '"+loginID+"' ");
	queryStr.append("   and A.DEPT_CODE = B.DEPTCODE				 ");
	queryStr.append("	and B.DWGDEPTCODE = C.DWGDEPTCODE 			 ");
	queryStr.append("	and C.DOCUMENTSECURITYYN in ('Y' , 'N')      ");

    java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet rset = stmt.executeQuery(queryStr.toString());

	if (rset.next()) {
		adminYN = "Y";
	}
	
	%>
	<script language="JavaScript">
	
		<% if (!"Y".equals(adminYN)) { %>
			alert("Article only with permission of the department are available.");
	        parent.window.close();
	    <% } %>
	    
		function doneMethod() {		
			parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
			parent.window.close();
		}
	
		function cancelMethod(){
			parent.window.opener.parent.location.href = parent.window.opener.parent.location.href;
			parent.window.close();
		}		
	</script>
	<frameset rows="<%=framesetRows%>" framespacing="0" frameborder="no" border="0">
		<frame name="listHead" src="<%=buyerClassLetterFaxAttachHead %>" marginheight="10" marginwidth="10" border="0" scrolling="no"/>
		<frame name="listBody" src="<%=buyerClassLetterFaxAttachBody%>" marginheight="10" marginwidth="10" />
		<frame name="listBottom" src="emxBlank.jsp" marginheight="10" marginwidth="10"  />
	</frameset>
</html>
