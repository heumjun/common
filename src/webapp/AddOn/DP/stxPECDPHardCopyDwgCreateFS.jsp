<%--  
§DESCRIPTION: 도면 출도대장(Hard Copy) 항목 등록 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgCreateFS.jsp
§CHANGING HISTORY: 
§    2010-03-18: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>Drawing Distribution History Resister</TITLE>
</HEAD>

<FRAMESET rows="*, 46" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPHardCopyDwgCreateMain.jsp" name="HARDCOPY_CREATE_MAIN" noresize scrolling="no" marginwidth="10" marginheight="10">
    <FRAME src="stxPECDPHardCopyDwgCreateBottom.jsp" name="HARDCOPY_CREATE_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
