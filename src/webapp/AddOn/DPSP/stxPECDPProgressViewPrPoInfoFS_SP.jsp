<%--  
§DESCRIPTION: 공정 조회 Maker(Vendor) 도면의  PR, PO 세부 정보 View Frameset
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPProgressViewPrPoInfoFS_SP.jsp
§CHANGING HISTORY: 
§    2014-05-29: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    
    String projectNo = request.getParameter("projectNo");
    String drawingNo = request.getParameter("drawingNo");

	String frameHeader	= "stxPECDPProgressViewPrPoInfoHeader_SP.jsp?projectNo="+projectNo+"&drawingNo="+drawingNo;
	String frameMain	= "stxPECDPProgressViewPrPoInfo_SP.jsp?projectNo="+projectNo+"&drawingNo="+drawingNo;
%>

<HTML>
<HEAD>
    <TITLE>PR/PO Info.</TITLE>
</HEAD>

<FRAMESET cols="105, *" border="10">
    <FRAME src="<%=frameHeader%>" name="FRAME_HEADER" frameborder="1" noresize scrolling="auto" marginwidth="10" marginheight="10">
    <FRAME src="<%=frameMain%>" name="FRAME_MAIN" noresize scrolling="auto" marginwidth="20" marginheight="10">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
