<%--  
§DESCRIPTION: 설계시수결재 - 결재조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_ApprovalListViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<HTML>
<HEAD>
    <TITLE>결 재 조 회</TITLE>
</HEAD>

<FRAMESET rows="33, *, 38" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPApproval_ApprovalListViewHeader.jsp" name="DP_APPRLIST_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_APPRLIST_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2"><!--stxPECDPApproval_ApprovalListViewMain.jsp-->
    <FRAME src="stxPECDPApproval_ApprovalListViewBottom.jsp" name="DP_APPRLIST_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
