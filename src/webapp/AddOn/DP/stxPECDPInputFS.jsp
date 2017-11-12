<%--  
§DESCRIPTION: 설계시수입력 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInputFS.jsp
§CHANGING HISTORY: 
§    2009-04-06: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>WORLD BEST STX OFFSHORE & SHIPBUILDING</TITLE>
</HEAD>

<FRAMESET rows="88, *, 120" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPInputHeader.jsp" name="DP_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAMESET cols="190, *" frameborder="1" framespacing="1">
        <FRAME src="stxPECDPEmpty.htm" name="DP_TIMESELECT" noresize scrolling="no" marginwidth="1" marginheight="1""><!--stxPECDPInputTimeSelect.jsp-->
        <FRAME src="stxPECDPEmpty.htm" name="DP_MAIN" noresize scrolling="no" marginwidth="3" marginheight="20"><!--stxPECDPInputMain.jsp-->
    </FRAMESET>
    <FRAME src="stxPECDPInputBottom.jsp" name="DP_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="5">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
