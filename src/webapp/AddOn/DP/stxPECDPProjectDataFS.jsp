<%--  
§TITLE: 호선 별 시수조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProjectDataFS.jsp
§CHANGING HISTORY: 
§    2009-08-13: Initiative
§DESCRIPTION:
     ......
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>호선 별 시수조회</TITLE>
</HEAD>

<FRAMESET rows="68, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPProjectDataHeader.jsp" name="DP_PROJECTDATA_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_PROJECTDATA_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
