<%--  
§DESCRIPTION: 설계시수입력 - 입력시수 조회 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_InputListViewFS.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
%>

<HTML>
<HEAD>
    <TITLE>시 수 체 크</TITLE>
</HEAD>

<FRAMESET rows="60, *, 60" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPInput_InputListViewHeader.jsp?loginID=<%=loginID%>" name="DP_VIEW_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_VIEW_MAIN" noresize scrolling="no" marginwidth="2" marginheight="0"><!--stxPECDPInput_InputListViewMain.jsp-->
    <FRAME src="stxPECDPInput_InputListViewBottom.jsp" name="DP_VIEW_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
