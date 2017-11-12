<%--  
§DESCRIPTION: 설계시수결재 - 시수 입력율 조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_InputRateViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>시수입력율 조회</TITLE>
</HEAD>

<FRAMESET rows="60, *, 38" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPApproval_InputRateViewHeader.jsp" name="DP_RATE_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_RATE_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2"><!--stxPECDPApproval_InputRateViewMain.jsp-->
    <FRAME src="stxPECDPApproval_InputRateViewBottom.jsp" name="DP_RATE_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
