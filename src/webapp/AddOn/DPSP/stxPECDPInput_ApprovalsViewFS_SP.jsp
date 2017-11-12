<%--  
§DESCRIPTION: 설계시수입력 - 결재조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_ApprovalsViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>결 재 체 크</TITLE>
</HEAD>

<FRAMESET rows="33, *, 38" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPInput_ApprovalsViewHeader_SP.jsp" name="DP_APPRVIEW_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_APPRVIEW_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">
    <FRAME src="stxPECDPInput_ApprovalsViewBottom_SP.jsp" name="DP_APPRVIEW_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
