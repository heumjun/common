<%--  
��DESCRIPTION: ȣ�� �� �ü� ERP I/F ȭ�� Frameset
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPProjectDataERPIFFS.jsp
��CHANGING HISTORY: 
��    2009-08-18: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
%>

<HTML>
<HEAD>
    <TITLE>ȣ�� �� �ü���ȸ - ERP I/F</TITLE>
</HEAD>

<FRAMESET rows="64, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPProjectDataERPIFHeader.jsp?loginID=<%=loginID%>" name="DP_ERPIF_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_ERPIF_MAIN2" noresize scrolling="auto" marginwidth="2" marginheight="0"><!--stxPECDPProjectDataERPIFMain.jsp-->

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
