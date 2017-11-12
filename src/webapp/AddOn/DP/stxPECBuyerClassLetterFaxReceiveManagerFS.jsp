<html>
<%@ page import = "java.util.*" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
    String loginID = (String)loginUser.get("user_id");
	//String languageStr 		= request.getHeader("Accept-Language");
	String buyerClassLetterFaxInputHead = "";
	String buyerClassLetterFaxInputBody	= "";

	buyerClassLetterFaxInputHead = "stxPECBuyerClassLetterFaxReceiveManagerHead.jsp";
	buyerClassLetterFaxInputBody = "stxPECBuyerClassLetterFaxReceiveManagerBody.jsp";
	
	String framesetRows = "50%,50%,0";
	
	String adminYN = "N";
	
	java.sql.Connection conn = com.stx.common.interfaces.DBConnect.getDBConnection("SDPS");

	StringBuffer queryStr = new StringBuffer();
	queryStr.append("SELECT A.DEPT_CODE AS DEPT_CODE,								     ");
	queryStr.append("       A.DEPT_NAME AS DEPT_NAME,								     ");
	queryStr.append("       (SELECT C.DEPT_NAME										     ");
	queryStr.append("          FROM STX_COM_INSA_DEPT@STXERP C						     ");
	queryStr.append("         WHERE C.DEPT_CODE = A.PARENT_CODE) AS UP_DEPT_NAME,	     ");
	queryStr.append("       B.NAME AS NAME,											     ");
	queryStr.append("	    B.JOB AS TITLE, 											 ");
	queryStr.append("	    B.INPUT_MAN_HOUR_ENABLED AS MH_YN,        				     ");
	queryStr.append("       (SELECT GROUPNO										         ");
	queryStr.append("          FROM CCC_USER D						                     ");
	queryStr.append("         WHERE D.USERID = B.EMPLOYEE_NUM) AS GROUPNO,	             ");
	queryStr.append("	    TO_CHAR(TERMINATION_DATE, 'YYYY-MM-DD') AS TERMINATION_DATE, ");
	queryStr.append("	    (SELECT DWGDEPTCODE                                          ");
	queryStr.append("	       FROM DCC_DEPTCODE E                                       ");
	queryStr.append("	      WHERE E.DEPTCODE = B.DEPT_CODE) AS DWG_DEPTCODE,           ");
	queryStr.append("	    B.INPUT_PROGRESS_ENABLED AS PROGRESS_YN        				 ");
	queryStr.append("  FROM STX_COM_INSA_DEPT@STXERP A,								     ");
	queryStr.append("       CCC_SAWON B												     ");
	queryStr.append(" WHERE A.DEPT_CODE = B.DEPT_CODE								     ");
	queryStr.append("   AND B.EMPLOYEE_NUM = '" + loginID + "'				 ");

    java.sql.Statement stmt = conn.createStatement();
    java.sql.ResultSet rset = stmt.executeQuery(queryStr.toString());

	if (rset.next()) {
		if (rset.getString(7) != null && 
			 (rset.getString(7).equals("Administrators") || 
			  rset.getString(7).equals("PLM관리자") ||
              rset.getString(7).equals("해양공정관리자"))
		   ){
			adminYN = "Y";
			}
		
	}
	%>
	<script language="JavaScript">
		<% if (!"Y".equals(adminYN)) { %>
			alert("Admin Only Menu.");
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
		<frame name="listHead" src="<%=buyerClassLetterFaxInputHead %>" marginheight="10" marginwidth="10" border="0" scrolling="no"/>
		<frame name="listBody" src="<%=buyerClassLetterFaxInputBody%>" marginheight="10" marginwidth="10" border="0" scrolling="no"/>
		<frame name="listBottom" src="emxBlank.jsp" marginheight="10" marginwidth="10"  />
	</frameset>
</html>
