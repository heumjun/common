<%--  
��TITLE: ����ü� DATA ���� ȭ�� Frameset
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPDataMgmtFS.jsp
��CHANGING HISTORY: 
��    2009-07-29: Initiative
��DESCRIPTION:
        ����ü� DATA ������ �����ڵ��� �ü��Է� ����� ��ȸ�� �� �ִ� ȭ������
    �ü��Է� ȭ���� �ü�üũ ���(ȭ��)�� ������ ��� ������ ������. �ü�üũ ��
    ���� ������ 1 �ο� ���� �ü��Է� ������ ��ȸ�ϴµ� ����, ����ü� DATA ����
    �� (�����ڿ� ����) �ټ��� �����ڵ��� �ü��Է� ������ ��ȸ�� �� �ִ�. �׸��� 
    �����ڰ� �μ�, �����ȣ, OP CODE, ���κμ� �� �׸��� ������ �� �ִ� �����
    �����ǰ�, �ü� ������ CASE�� �����Ͽ� �ٸ� FACTOR �� ����� ����� Ȯ���� ��
    �� �ִ�. 
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<HTML>
<HEAD>
    <TITLE>����ü� DATA ����</TITLE>
</HEAD>

<FRAMESET rows="98, *" frameborder="0" framespacing="0">
    <FRAME src="stxPECDPDataMgmtHeader_SP.jsp" name="DP_DATAMGMT_HEADER" noresize scrolling="no" marginwidth="1" marginheight="1">
    <FRAME src="stxPECDPEmpty.htm" name="DP_DATAMGMT_MAIN" noresize scrolling="auto" marginwidth="2" marginheight="2">

    <NOFRAMES>
        <P>You must use a browser that can display frames to see this page.</P>
    </NOFRAMES>
</FRAMESET>

</HTML>
