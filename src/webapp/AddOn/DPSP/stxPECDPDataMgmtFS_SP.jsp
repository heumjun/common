<%--  
§TITLE: 설계시수 DATA 관리 화면 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPDataMgmtFS.jsp
§CHANGING HISTORY: 
§    2009-07-29: Initiative
§DESCRIPTION:
        설계시수 DATA 관리는 설계자들의 시수입력 결과를 조회할 수 있는 화면으로
    시수입력 화면의 시수체크 기능(화면)과 유사한 출력 구조를 가진다. 시수체크 기
    능이 설계자 1 인에 대한 시수입력 사항을 조회하는데 비해, 설계시수 DATA 관리
    는 (관리자에 한해) 다수의 설계자들의 시수입력 사항을 조회할 수 있다. 그리고 
    관리자가 부서, 도면번호, OP CODE, 원인부서 등 항목을 수정할 수 있는 기능이
    제공되고, 시수 적용율 CASE를 선택하여 다른 FACTOR 가 적용된 결과를 확인할 수
    도 있다. 
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>설계시수 DATA 관리</TITLE>
</HEAD>

<FRAMESET rows="98, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPDataMgmtHeader_SP.jsp" name="DP_DATAMGMT_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_DATAMGMT_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
