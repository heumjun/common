<%--  
§DESCRIPTION: 공정 지연현황 조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviationViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-14: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>공정 지연현황 조회</TITLE>
</HEAD>

<FRAMESET rows="100, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPProgressDeviationViewHeader.jsp" name="PROGRESS_DEV_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="PROGRESS_DEV_MAIN" noresize scrolling="no" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
