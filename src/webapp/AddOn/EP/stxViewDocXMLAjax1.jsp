<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="java.net.*" %>
<%@page import="org.jdom.Element"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%request.setCharacterEncoding("utf-8"); %>
<%! 
public String getManualDown(
		String downloadPath,
		String downloadname,
		String loginID
		) throws Exception
{
	StringBuffer sbXml = new StringBuffer();
	java.sql.Connection conn = null;
	CallableStatement cs1 = null;
	CallableStatement cs2 = null;
	PreparedStatement ps = null;
	String sResult = "";
	try
	{
		conn = DBConnect.getDBConnection("ERP_APPS");			
		conn.setAutoCommit(false);
		
		cs2 = conn.prepareCall("{call  stx_dwg_dims_vi_proc (?, ?, ?, ?, ?)}");
		
		cs2.setString(1, downloadPath); 
		cs2.setString(2, downloadname);  
		cs2.setString(3, loginID);  
		cs2.registerOutParameter(4, java.sql.Types.VARCHAR);
		cs2.registerOutParameter(5, java.sql.Types.VARCHAR);
		
		cs2.execute();
		
		String sResult2 = cs2.getString(4);
		if(sResult2!= null && sResult2.equals("S"))
		{
			sbXml.append(cs2.getString(5) + "\n");
		}
		conn.commit();
	}
	catch(Exception e)
	{
		if(conn != null)conn.rollback();
		e.printStackTrace();
	}finally{
		if(cs1 != null)cs1.close();
		if(cs2 != null)cs2.close();
		if(ps != null)ps.close();
		if(conn != null)conn.close();
	}
	return sbXml.toString();
}
%>
<%
 
	String sOutPut = "";
	String downloadPath = request.getParameter("downloadPath");
	String downloadname = request.getParameter("downloadname");
	String loginID = request.getParameter("loginID");
	sOutPut = getManualDown(downloadPath, downloadname, loginID);
%>
<%=sOutPut%>