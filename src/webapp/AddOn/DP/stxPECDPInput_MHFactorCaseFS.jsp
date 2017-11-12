<%--  
§TITLE: 설계시수관리 - 시수 적용율(FACTOR) CASE 관리 Frameset
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPInput_MHFactorCaseFS.jsp
§CHANGING HISTORY: 
§    2009-07-27: Initiative
§DESCRIPTION:
    시수 �용율(Factor) Case 관리 화면은 설계자의 경력 개월 수에 따라 시수 적용
    율을 달리 적용할 수 있는 기준을 Case 별로 정의, 관리할 수 있도록 한다. 
    0. 관련 DB Table: PLM_DESIGN_MH_FACTOR
    0. 조회와 추가 기능만 있고 삭제와 변경 기능은 필요 없음
    1. 화면 로드 시 PLM_DESIGN_MH_FACTOR 테이블에서 '시수 적용율 CASE' 목록을 Get. 
       이때 PLM_CODE_TBL에서 Active Case 항목이 무엇인지 Get하여 화면에 Active
       항목을 표시
    2. Case 선택(선택 변경) 시 
        2-1) 저장되지 않은 추가사항이 있으면 저장여부를 확인
        2-2) 해당 Case의 정의사항을 PLM_DESIGN_MH_FACTOR 테이블에서 Get하여 
             화면에 출력
    3. 추가 Btn. Click 시
        3-1) 저장되지 않은 추가사항이 있으면 저장여부를 확인
        3-2) 신규 Case No 추가. 입력화면 출력
    4. 적용 Btn. Click 시
        4-1) 추가사항 저장
    5. 닫기 Btn. Click 시
        5-1) 저장되지 않은 추가사항이 있으면 저장여부를 확인
        5-2) 화면 Close
    *. Validation Check 로직
        - 저장 시 항상 Validation을 체크
        - 설계경력은 자연수만 가능(1, 2, 3, ...). 시작값은 항상 1
        - 설계경력은 To가 From보다 크거나 같아야 하고, No가 올라갈 수록 더 커져
          야 함. 다음 No의 From은 항상 이전 To의 + 1
        - 설계경력의 끝 값은 Null(무한대) 이어야 함
        - Factor는 0~1 사이의 소수점 한자리 수
    *.추가 Case 시 동일한 정의가 존재하는지 체크
    *. Case No Naming Rule: A, B, C, ...
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
%>

<HTML>
<HEAD>
    <TITLE>시수 적용율(FACTOR) CASE 관리</TITLE>
</HEAD>

<FRAMESET rows="36, *, 60" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPInput_MHFactorCaseHeader.jsp" name="DP_MHFACTOR_HEADER" noresize scrolling="no" marginwidth="2" marginheight="2">
    <FRAME src="stxPECDPEmpty.htm" name="DP_MHFACTOR_MAIN" noresize scrolling="no" marginwidth="2" marginheight="10"><!--stxPECDPInput_MHFactorCaseMain.jsp-->
    <FRAME src="stxPECDPInput_MHFactorCaseBottom.jsp" name="DP_MHFACTOR_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
