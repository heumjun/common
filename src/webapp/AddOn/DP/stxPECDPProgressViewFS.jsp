<%--  
§DESCRIPTION: 공정 조회/입력 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-13: Initiative
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<HTML>
<HEAD>
    <TITLE>공정 조회/입력</TITLE>
</HEAD>
<FRAMESET rows="150, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPProgressViewHeader.jsp" name="PROGRESS_VIEW_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="PROGRESS_VIEW_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">
    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>
</HTML>
