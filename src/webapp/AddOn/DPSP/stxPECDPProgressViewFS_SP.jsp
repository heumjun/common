<%--  
��DESCRIPTION: ���� ��ȸ/�Է� ȭ�� Frameset
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPProgressViewFS.jsp
��CHANGING HISTORY: 
��    2009-04-13: Initiative
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>���� ��ȸ/�Է�</TITLE>
</HEAD>

<FRAMESET rows="115, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPProgressViewHeader_SP.jsp" name="PROGRESS_VIEW_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="PROGRESS_VIEW_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
