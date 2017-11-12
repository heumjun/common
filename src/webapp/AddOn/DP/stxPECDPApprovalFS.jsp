<%--  
§DESCRIPTION: 설계시수결재 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApprovalFS.jsp
§CHANGING HISTORY: 
§    2009-04-08: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>WORLD BEST STX OFFSHORE & SHIPBUILDING</TITLE>
</HEAD>

<FRAMESET rows="91, *, 120" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPApprovalHeader.jsp" name="DP_APPR_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAMESET cols="297, *" frameborder="1" framespacing="1">
        <FRAME src="stxPECDPEmpty.htm" name="DP_APPR_PERSON" noresize scrolling="auto" marginwidth="1" marginheight="1""><!--stxPECDPApprovalPersonSelect.jsp-->
        <FRAME src="stxPECDPEmpty.htm" name="DP_APPR_MAIN" noresize scrolling="no" marginwidth="3" marginheight="1"><!--stxPECDPApprovalMain.jsp-->
    </FRAMESET>
    <FRAME src="stxPECDPInputBottom.jsp" name="DP_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="3">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>

