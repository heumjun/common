<%--  
§DESCRIPTION: 설계시수결재 - 휴일체크 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_HolidayCheckFS.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<HTML>
<HEAD>
    <TITLE>휴 일 체 크</TITLE>
</HEAD>

<FRAMESET rows="33, *, 38" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPApproval_HolidayCheckHeader_SP.jsp" name="DP_HOLIDAY_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_HOLIDAY_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2"><!--stxPECDPApproval_HolidayCheckMain.jsp-->
    <FRAME src="stxPECDPApproval_HolidayCheckBottom_SP.jsp" name="DP_HOLIDAY_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
