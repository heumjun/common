<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%@page import="java.util.Enumeration"%>

<HTML>
<HEAD>
	<TITLE>Project Design I/O Data Management</TITLE>
</HEAD>

<%

	String sParam = "";
	
	Enumeration enum1 =  request.getParameterNames();
	while(enum1.hasMoreElements())
	{
		String sParamName = enum1.nextElement().toString();
		String sValue = request.getParameter(sParamName);
		sParam = sParam + "&" +sParamName + "=" + sValue;
	}
  	
	String sHeaderURL 	= "stxPipingIOHeader.jsp?"+sParam;
	String sListURL 	= "stxPipingIOList.jsp?"+sParam;
%>

<FRAMESET ROWS="210,*,0" border="0">
	<FRAME SRC="<%=sHeaderURL%>" 	NAME="headerFrame" scrolling="no">
	<FRAME SRC="<%=sListURL%>" 		NAME="listFrame" scrolling="no">
	<FRAME SRC="" 					NAME="listHidden" noresize="noresize" marginheight="0" marginwidth="0" border="0" scrolling="no" />
</FRAMESET>

</HTML>

