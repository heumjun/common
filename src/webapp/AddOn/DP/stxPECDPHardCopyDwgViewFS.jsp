<%--  
§DESCRIPTION: 도면 출도대장(Hard Copy) 조회 및 등록 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgViewFS.jsp
§CHANGING HISTORY: 
§    2010-03-17: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>Drawing Distribution History Search and Resister</TITLE>
</HEAD>

<FRAMESET rows="94, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPHardCopyDwgViewHeader.jsp" name="HARDCOPY_VIEW_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="HARDCOPY_VIEW_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
