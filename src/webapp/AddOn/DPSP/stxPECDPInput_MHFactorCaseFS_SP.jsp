<%--  
��TITLE: ����ü����� - �ü� ������(FACTOR) CASE ���� Frameset
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_MHFactorCaseFS.jsp
��CHANGING HISTORY: 
��    2009-07-27: Initiative
��DESCRIPTION:
    �ü� ������(Factor) Case ���� ȭ���� �������� ��� ���� ���� ���� �ü� ����
    ���� �޸� ������ �� �ִ� ������ Case ���� ����, ������ �� �ֵ��� �Ѵ�. 
    0. ���� DB Table: PLM_DESIGN_MH_FACTOR
    0. ��ȸ�� �߰� ��ɸ� �ְ� ������ ���� ����� �ʿ� ����
    1. ȭ�� �ε� �� PLM_DESIGN_MH_FACTOR ���̺��� '�ü� ������ CASE' ����� Get. 
       �̶� PLM_CODE_TBL���� Active Case �׸��� �������� Get�Ͽ� ȭ�鿡 Active
       �׸��� ǥ��
    2. Case ����(���� ����) �� 
        2-1) ������� ���� �߰������� ������ ���忩�θ� Ȯ��
        2-2) �ش� Case�� ���ǻ����� PLM_DESIGN_MH_FACTOR ���̺��� Get�Ͽ� 
             ȭ�鿡 ���
    3. �߰� Btn. Click ��
        3-1) ������� ���� �߰������� ������ ���忩�θ� Ȯ��
        3-2) �ű� Case No �߰�. �Է�ȭ�� ���
    4. ���� Btn. Click ��
        4-1) �߰����� ����
    5. �ݱ� Btn. Click ��
        5-1) ������� ���� �߰������� ������ ���忩�θ� Ȯ��
        5-2) ȭ�� Close
    *. Validation Check ����
        - ���� �� �׻� Validation�� üũ
        - �������� �ڿ����� ����(1, 2, 3, ...). ���۰��� �׻� 1
        - �������� To�� From���� ũ�ų� ���ƾ� �ϰ�, No�� �ö� ���� �� Ŀ��
          �� ��. ���� No�� From�� �׻� ���� To�� + 1
        - �������� �� ���� Null(���Ѵ�) �̾�� ��
        - Factor�� 0~1 ������ �Ҽ��� ���ڸ� ��
    *.�߰� Case �� ������ ���ǰ� �����ϴ��� üũ
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
    <TITLE>�ü� ������(FACTOR) CASE ����</TITLE>
</HEAD>

<FRAMESET rows="36, *, 60" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPInput_MHFactorCaseHeader_SP.jsp" name="DP_MHFACTOR_HEADER" noresize scrolling="no" marginwidth="2" marginheight="2">
    <FRAME src="stxPECDPEmpty.htm" name="DP_MHFACTOR_MAIN" noresize scrolling="no" marginwidth="2" marginheight="10"><!--stxPECDPInput_MHFactorCaseMain.jsp-->
    <FRAME src="stxPECDPInput_MHFactorCaseBottom_SP.jsp" name="DP_MHFACTOR_BOTTOM" noresize scrolling="no" marginwidth="10" marginheight="4">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
