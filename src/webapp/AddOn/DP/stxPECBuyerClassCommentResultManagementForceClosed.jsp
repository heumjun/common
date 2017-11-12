<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 강제 Closed
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementForceClosed.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>

<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%
	String sSelect_seq_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_seq_no"));

	String resultMsg = "";

    java.sql.Connection conn = null;
    java.sql.PreparedStatement pstmt  = null;

    try 
	{
		conn = DBConnect.getDBConnection("SDPS");

		StringBuffer queryStr = new StringBuffer();
		queryStr.append("UPDATE STX_OC_RECEIVE_DOCUMENT                                              \n");
		queryStr.append("   SET DESIGN_CLOSE_DATE = SYSDATE                                          \n");      //Closed 일자
		queryStr.append("      ,STATUS = 'Closed(F)'                                                 \n");      //STATUS : Closed(F)
		queryStr.append(" WHERE SEQ_NO = ?                                                          \n");   

		pstmt = conn.prepareStatement(queryStr.toString());
		

		StringTokenizer st = new StringTokenizer(sSelect_seq_no,",");
        while(st.hasMoreTokens())
        {
			String seq_no = st.nextToken();
			pstmt.setString(1, seq_no);
			pstmt.executeUpdate();
		}	

		DBConnect.commitJDBCTransaction(conn);

		resultMsg = "SUCCESS";


	}
    catch (Exception e) {
		DBConnect.rollbackJDBCTransaction(conn);
        resultMsg = "ERROR  :  "+e.toString();    
    }

    finally{
        try {
            if ( pstmt != null ) pstmt.close();
            DBConnect.closeConnection( conn );
        } catch( Exception ex ) { }
    } 
	
//System.out.println("##  resultMsg  =  "+resultMsg);
%>

<%=resultMsg%>