<%--  
§DESCRIPTION: 도면 출도내역 조회 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgDeployedListFS.jsp
§CHANGING HISTORY: 
§    2010-03-26: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>도면 출도내역 조회</TITLE>
</HEAD>

<FRAMESET rows="75, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPHardCopyDwgDeployedListHeader.jsp" name="HARDCOPY_DEPLOYED_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="HARDCOPY_DEPLOYED_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
