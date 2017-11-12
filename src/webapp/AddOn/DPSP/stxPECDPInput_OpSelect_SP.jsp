<%--  
��DESCRIPTION: ����ü��Է� - OP CODE ���� â
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInput_OpSelect.jsp
��CHANGING HISTORY: 
��    2009-04-10: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String projectNo = request.getParameter("projectNo");
    boolean isNonProject = false;
    boolean isResearchProject = false;
    boolean isRealProject = false;

    if (projectNo.equals("S000")) isNonProject = true;
    else if (projectNo.equals("V0000")) isResearchProject = true;
    else isRealProject = true;
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>OP CODE ����</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    var selectedOpCode = '';
    var selectedTR = null;

</script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPOpCodeSelect">

<table width="100%" cellSpacing="1" cellPadding="3" border="1" align="center">
    <tr height="6"><td colspan="5"></td></tr>
    <tr height="16">
        <% if (isResearchProject) { %>
            <td id="opSelectGroup_1R" class="td_opselect" style="background-color:#00ffff" onclick="changeSelectedOpGroup(this, 'opGroup_1R');">�����غ�</td>
            <td id="opSelectGroup_2R" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_2R');">��������</td>
            <td id="opSelectGroup_3R" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_3R');">�������� �� ���İ���</td>
            <td id="opSelectGroup_4R" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_4R');">��� ���� ����</td>
            <td id="opSelectGroup_5R" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_5R');">��������</td>
        <% } else if (isRealProject) { %>
            <td id="opSelectGroup_1" class="td_opselect" style="background-color:#00ffff" onclick="changeSelectedOpGroup(this, 'opGroup_1');">�����غ�</td>
            <td id="opSelectGroup_2" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_2');">��������</td>
            <td id="opSelectGroup_3" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_3');">���� �� ����</td>
            <td id="opSelectGroup_4" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_4');">������ �� ��������</td>
            <td id="opSelectGroup_5" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_5');">�������</td>
            <td id="opSelectGroup_5B" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_5B');">BOM����</td>
        <% } else { %>
            <td id="opSelectGroup_6" class="td_opselect" style="background-color:#00ffff" onclick="changeSelectedOpGroup(this, 'opGroup_6');">�������� �� ��������</td>
            <td id="opSelectGroup_7" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_7');">���꼺 ���</td>
            <td id="opSelectGroup_8" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_8');">��Ÿ</td>
            <td id="opSelectGroup_9" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_9');">����</td>
        <% } %>
    </tr>
    <tr height="6"><td colspan="5"></td></tr>
</table>





<div id="opGroup_1R" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; <%if(!isResearchProject){%>display:none;<%}%>">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '11');" onclick="selectOpCode(this, '11');">
            <td class="td_standardSmall" width="25%">11</td>
            <td class="td_standardSmall" style="text-align:left;">����������ȹ</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '13');" onclick="selectOpCode(this, '13');">
            <td class="td_standardSmall" width="25%">13</td>
            <td class="td_standardSmall" style="text-align:left;">�������� ��ȹ �� ǰ��</td>
        </tr>
    </table>
</div>

<div id="opGroup_2R" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '21');" onclick="selectOpCode(this, '21');">
            <td class="td_standardSmall" width="25%">21</td>
            <td class="td_standardSmall" style="text-align:left;">����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '23');" onclick="selectOpCode(this, '23');">
            <td class="td_standardSmall" width="25%">23</td>
            <td class="td_standardSmall" style="text-align:left;">�ؼ� �� ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '25');" onclick="selectOpCode(this, '25');">
            <td class="td_standardSmall" width="25%">25</td>
            <td class="td_standardSmall" style="text-align:left;">���� / �˼�</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '27');" onclick="selectOpCode(this, '27');">
            <td class="td_standardSmall" width="25%">27</td>
            <td class="td_standardSmall" style="text-align:left;">�׽�Ʈ</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '29');" onclick="selectOpCode(this, '29');">
            <td class="td_standardSmall" width="25%">29</td>
            <td class="td_standardSmall" style="text-align:left;">�߰�����</td>
        </tr>
    </table>
</div>

<div id="opGroup_3R" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '31');" onclick="selectOpCode(this, '31');">
            <td class="td_standardSmall" width="25%">31</td>
            <td class="td_standardSmall" style="text-align:left;">��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '33');" onclick="selectOpCode(this, '33');">
            <td class="td_standardSmall" width="25%">33</td>
            <td class="td_standardSmall" style="text-align:left;">���Ẹ��</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '35');" onclick="selectOpCode(this, '35');">
            <td class="td_standardSmall" width="25%">35</td>
            <td class="td_standardSmall" style="text-align:left;">���İ���</td>
        </tr>
    </table>
</div>

<div id="opGroup_4R" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '41');" onclick="selectOpCode(this, '41');">
            <td class="td_standardSmall" width="25%">41</td>
            <td class="td_standardSmall" style="text-align:left;">WPS ���� (�系)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '43');" onclick="selectOpCode(this, '43');">
            <td class="td_standardSmall" width="25%">43</td>
            <td class="td_standardSmall" style="text-align:left;">WPS ���� (���)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '45');" onclick="selectOpCode(this, '45');">
            <td class="td_standardSmall" width="25%">45</td>
            <td class="td_standardSmall" style="text-align:left;">���������� �׽�Ʈ</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '47');" onclick="selectOpCode(this, '47');">
            <td class="td_standardSmall" width="25%">47</td>
            <td class="td_standardSmall" style="text-align:left;">���� �� ��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '49');" onclick="selectOpCode(this, '49');">
            <td class="td_standardSmall" width="25%">49</td>
            <td class="td_standardSmall" style="text-align:left;">��������</td>
        </tr>
    </table>
</div>

<div id="opGroup_5R" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>
    </table>
</div>





<div id="opGroup_1" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; <%if(!isRealProject){%>display:none;<%}%>">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '10');" onclick="selectOpCode(this, '10');">
            <td class="td_standardSmall" width="25%">10</td>
            <td class="td_standardSmall" style="text-align:left;">ECO/ECR ó��</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '11');" onclick="selectOpCode(this, '11');">
            <td class="td_standardSmall" width="25%">11</td>
            <td class="td_standardSmall" style="text-align:left;">SPEC. �ۼ� �� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '13');" onclick="selectOpCode(this, '13');">
            <td class="td_standardSmall" width="25%">13</td>
            <td class="td_standardSmall" style="text-align:left;">STUDY</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '15');" onclick="selectOpCode(this, '15');">
            <td class="td_standardSmall" width="25%">15</td>
            <td class="td_standardSmall" style="text-align:left;">�ڷ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '16');" onclick="selectOpCode(this, '16');">
            <td class="td_standardSmall" width="25%">16</td>
            <td class="td_standardSmall" style="text-align:left;">PR ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '17');" onclick="selectOpCode(this, '17');">
            <td class="td_standardSmall" width="25%">17</td>
            <td class="td_standardSmall" style="text-align:left;">MASTER BOM ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '18');" onclick="selectOpCode(this, '18');">
            <td class="td_standardSmall" width="25%">18</td>
            <td class="td_standardSmall" style="text-align:left;">PROJECT BOM ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '19');" onclick="selectOpCode(this, '19');">
            <td class="td_standardSmall" width="25%">19</td>
            <td class="td_standardSmall" style="text-align:left;">ITEM ���</td>
        </tr>
    </table>
</div>

<div id="opGroup_2" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '20');" onclick="selectOpCode(this, '20');">
            <td class="td_standardSmall" width="25%">20</td>
            <td class="td_standardSmall" style="text-align:left;">���� CHANGE ORDER</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '21');" onclick="selectOpCode(this, '21');">
            <td class="td_standardSmall" width="25%">21</td>
            <td class="td_standardSmall" style="text-align:left;">���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '22');" onclick="selectOpCode(this, '22');">
            <td class="td_standardSmall" width="25%">22</td>
            <td class="td_standardSmall" style="text-align:left;">�����ۼ�</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '23');" onclick="selectOpCode(this, '23');">
            <td class="td_standardSmall" width="25%">23</td>
            <td class="td_standardSmall" style="text-align:left;">WEIGHT ���� �� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '24');" onclick="selectOpCode(this, '24');">
            <td class="td_standardSmall" width="25%">24</td>
            <td class="td_standardSmall" style="text-align:left;">�������� �� P.O.S �ۼ�</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '25');" onclick="selectOpCode(this, '25');">
            <td class="td_standardSmall" width="25%">25</td>
            <td class="td_standardSmall" style="text-align:left;">�ϼ��� �� �ڷ�����, ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '26');" onclick="selectOpCode(this, '26');">
            <td class="td_standardSmall" width="25%">26</td>
            <td class="td_standardSmall" style="text-align:left;">�����⵵</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '27');" onclick="selectOpCode(this, '27');">
            <td class="td_standardSmall" width="25%">27</td>
            <td class="td_standardSmall" style="text-align:left;">PML �ۼ�</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '28');" onclick="selectOpCode(this, '28');">
            <td class="td_standardSmall" width="25%">28</td>
            <td class="td_standardSmall" style="text-align:left;">��������ȭ (CAD��)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '29');" onclick="selectOpCode(this, '29');">
            <td class="td_standardSmall" width="25%">29</td>
            <td class="td_standardSmall" style="text-align:left;">������� (��������)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '2A');" onclick="selectOpCode(this, '2A');">
            <td class="td_standardSmall" width="25%">2A</td>
            <td class="td_standardSmall" style="text-align:left;">���� ���� FOLLOW UP</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '2B');" onclick="selectOpCode(this, '2B');">
            <td class="td_standardSmall" width="25%">2B</td>
            <td class="td_standardSmall" style="text-align:left;">���� ���� FOLLOW UP</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '2C');" onclick="selectOpCode(this, '2C');">
            <td class="td_standardSmall" width="25%">2C</td>
            <td class="td_standardSmall" style="text-align:left;">Maker ���� FOLLOW UP</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '2D');" onclick="selectOpCode(this, '2D');">
            <td class="td_standardSmall" width="25%">2D</td>
            <td class="td_standardSmall" style="text-align:left;">TEST MEMO �ۼ�</td>
        </tr>
    </table>
</div>

<div id="opGroup_3" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '31');" onclick="selectOpCode(this, '31');">
            <td class="td_standardSmall" width="25%">31</td>
            <td class="td_standardSmall" style="text-align:left;">���� (���� �� ����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '32');" onclick="selectOpCode(this, '32');">
            <td class="td_standardSmall" width="25%">32</td>
            <td class="td_standardSmall" style="text-align:left;">���� (���� �� ����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '33');" onclick="selectOpCode(this, '33');">
            <td class="td_standardSmall" width="25%">33</td>
            <td class="td_standardSmall" style="text-align:left;">MAKER (���� �� ����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '34');" onclick="selectOpCode(this, '34');">
            <td class="td_standardSmall" width="25%">34</td>
            <td class="td_standardSmall" style="text-align:left;">Ÿ�μ� ���� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '35');" onclick="selectOpCode(this, '35');">
            <td class="td_standardSmall" width="25%">35</td>
            <td class="td_standardSmall" style="text-align:left;">�μ� �� ���� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '36');" onclick="selectOpCode(this, '36');">
            <td class="td_standardSmall" width="25%">36</td>
            <td class="td_standardSmall" style="text-align:left;">��� ���� ���� (������� ����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '37');" onclick="selectOpCode(this, '37');">
            <td class="td_standardSmall" width="25%">37</td>
            <td class="td_standardSmall" style="text-align:left;">PE / PM ����</td>
        </tr>
    </table>
</div>

<div id="opGroup_4" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '43');" onclick="selectOpCode(this, '43');">
            <td class="td_standardSmall" width="25%">43</td>
            <td class="td_standardSmall" style="text-align:left;">������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '44');" onclick="selectOpCode(this, '44');">
            <td class="td_standardSmall" width="25%">44</td>
            <td class="td_standardSmall" style="text-align:left;">�߻����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '45');" onclick="selectOpCode(this, '45');">
            <td class="td_standardSmall" width="25%">45</td>
            <td class="td_standardSmall" style="text-align:left;">�ÿ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '48');" onclick="selectOpCode(this, '48');">
            <td class="td_standardSmall" width="25%">48</td>
            <td class="td_standardSmall" style="text-align:left;">���� CHECK</td>
        </tr>
    </table>
</div>

<div id="opGroup_5" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5A');" onclick="selectOpCode(this, '5A');">
            <td class="td_standardSmall" width="25%">5A</td>
            <td class="td_standardSmall" style="text-align:left;">RULE �������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5B');" onclick="selectOpCode(this, '5B');">
            <td class="td_standardSmall" width="25%">5B</td>
            <td class="td_standardSmall" style="text-align:left;">��缭 �������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5C');" onclick="selectOpCode(this, '5C');">
            <td class="td_standardSmall" width="25%">5C</td>
            <td class="td_standardSmall" style="text-align:left;">���/�۵� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5D');" onclick="selectOpCode(this, '5D');">
            <td class="td_standardSmall" width="25%">5D</td>
            <td class="td_standardSmall" style="text-align:left;">����/�ⷮ/�������/���ۿ�� ���غ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5E');" onclick="selectOpCode(this, '5E');">
            <td class="td_standardSmall" width="25%">5E</td>
            <td class="td_standardSmall" style="text-align:left;">���Ǻ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5F');" onclick="selectOpCode(this, '5F');">
            <td class="td_standardSmall" width="25%">5F</td>
            <td class="td_standardSmall" style="text-align:left;">���õ� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5G');" onclick="selectOpCode(this, '5G');">
            <td class="td_standardSmall" width="25%">5G</td>
            <td class="td_standardSmall" style="text-align:left;">ǥ��/�ڷ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5H');" onclick="selectOpCode(this, '5H');">
            <td class="td_standardSmall" width="25%">5H</td>
            <td class="td_standardSmall" style="text-align:left;">������������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5I');" onclick="selectOpCode(this, '5I');">
            <td class="td_standardSmall" width="25%">5I</td>
            <td class="td_standardSmall" style="text-align:left;">������ ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5J');" onclick="selectOpCode(this, '5J');">
            <td class="td_standardSmall" width="25%">5J</td>
            <td class="td_standardSmall" style="text-align:left;">���谳�� �� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5K');" onclick="selectOpCode(this, '5K');">
            <td class="td_standardSmall" width="25%">5K</td>
            <td class="td_standardSmall" style="text-align:left;">�������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5L');" onclick="selectOpCode(this, '5L');">
            <td class="td_standardSmall" width="25%">5L</td>
            <td class="td_standardSmall" style="text-align:left;">���� ������û</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5M');" onclick="selectOpCode(this, '5M');">
            <td class="td_standardSmall" width="25%">5M</td>
            <td class="td_standardSmall" style="text-align:left;">MAKER ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5N');" onclick="selectOpCode(this, '5N');">
            <td class="td_standardSmall" width="25%">5N</td>
            <td class="td_standardSmall" style="text-align:left;">���� ��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5O');" onclick="selectOpCode(this, '5O');">
            <td class="td_standardSmall" width="25%">5O</td>
            <td class="td_standardSmall" style="text-align:left;">���ֿ䱸</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5P');" onclick="selectOpCode(this, '5P');">
            <td class="td_standardSmall" width="25%">5P</td>
            <td class="td_standardSmall" style="text-align:left;">���� ��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5Q');" onclick="selectOpCode(this, '5Q');">
            <td class="td_standardSmall" width="25%">5Q</td>
            <td class="td_standardSmall" style="text-align:left;">���޿䱸</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5R');" onclick="selectOpCode(this, '5R');">
            <td class="td_standardSmall" width="25%">5R</td>
            <td class="td_standardSmall" style="text-align:left;">�ÿ����� ����</td>
        </tr>
    </table>
</div>

<div id="opGroup_5B" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5A');" onclick="selectOpCode(this, '5AB');">
            <td class="td_standardSmall" width="25%">5AB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : RULE �������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5B');" onclick="selectOpCode(this, '5BB');">
            <td class="td_standardSmall" width="25%">5BB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ��缭 �������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5C');" onclick="selectOpCode(this, '5CB');">
            <td class="td_standardSmall" width="25%">5CB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���/�۵� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5D');" onclick="selectOpCode(this, '5DB');">
            <td class="td_standardSmall" width="25%">5DB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ����/�ⷮ/�������/���ۿ�� ���غ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5E');" onclick="selectOpCode(this, '5EB');">
            <td class="td_standardSmall" width="25%">5EB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���Ǻ���</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5F');" onclick="selectOpCode(this, '5FB');">
            <td class="td_standardSmall" width="25%">5FB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���õ� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5G');" onclick="selectOpCode(this, '5GB');">
            <td class="td_standardSmall" width="25%">5GB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ǥ��/�ڷ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5H');" onclick="selectOpCode(this, '5HB');">
            <td class="td_standardSmall" width="25%">5HB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ������������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5I');" onclick="selectOpCode(this, '5IB');">
            <td class="td_standardSmall" width="25%">5IB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ������ ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5J');" onclick="selectOpCode(this, '5JB');">
            <td class="td_standardSmall" width="25%">5JB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���谳�� �� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5K');" onclick="selectOpCode(this, '5KB');">
            <td class="td_standardSmall" width="25%">5KB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : �������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5L');" onclick="selectOpCode(this, '5LB');">
            <td class="td_standardSmall" width="25%">5LB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���� ������û</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5M');" onclick="selectOpCode(this, '5MB');">
            <td class="td_standardSmall" width="25%">5MB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : MAKER ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5N');" onclick="selectOpCode(this, '5NB');">
            <td class="td_standardSmall" width="25%">5NB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���� ��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5O');" onclick="selectOpCode(this, '5OB');">
            <td class="td_standardSmall" width="25%">5OB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���ֿ䱸</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5P');" onclick="selectOpCode(this, '5PB');">
            <td class="td_standardSmall" width="25%">5PB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���� ��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5Q');" onclick="selectOpCode(this, '5QB');">
            <td class="td_standardSmall" width="25%">5QB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : ���޿䱸</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '5R');" onclick="selectOpCode(this, '5RB');">
            <td class="td_standardSmall" width="25%">5RB</td>
            <td class="td_standardSmall" style="text-align:left;">BOM ���� : �ÿ����� ����</td>
        </tr>
    </table>
</div>





<div id="opGroup_6" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; <%if(!isNonProject){%>display:none;<%}%>">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '61');" onclick="selectOpCode(this, '61');">
            <td class="td_standardSmall" width="25%">61</td>
            <td class="td_standardSmall" style="text-align:left;">�������� (����� �� �����ۼ�)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '62');" onclick="selectOpCode(this, '62');">
            <td class="td_standardSmall" width="25%">62</td>
            <td class="td_standardSmall" style="text-align:left;">��� ��ȹ ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '63');" onclick="selectOpCode(this, '63');">
            <td class="td_standardSmall" width="25%">63</td>
            <td class="td_standardSmall" style="text-align:left;">���� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '65');" onclick="selectOpCode(this, '65');">
            <td class="td_standardSmall" width="25%">65</td>
            <td class="td_standardSmall" style="text-align:left;">�������� (�系)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '66');" onclick="selectOpCode(this, '66');">
            <td class="td_standardSmall" width="25%">66</td>
            <td class="td_standardSmall" style="text-align:left;">�������� (���)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '67');" onclick="selectOpCode(this, '67');">
            <td class="td_standardSmall" width="25%">67</td>
            <td class="td_standardSmall" style="text-align:left;">�������� ����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '68');" onclick="selectOpCode(this, '68');">
            <td class="td_standardSmall" width="25%">68</td>
            <td class="td_standardSmall" style="text-align:left;">�Ϲݰ��� (��ȹ, ����, ���� ��)</td>
        </tr>
    </table>
</div>

<div id="opGroup_7" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '71');" onclick="selectOpCode(this, '71');">
            <td class="td_standardSmall" width="25%">71</td>
            <td class="td_standardSmall" style="text-align:left;">��������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '72');" onclick="selectOpCode(this, '72');">
            <td class="td_standardSmall" width="25%">72</td>
            <td class="td_standardSmall" style="text-align:left;">���ȸ�� �� ���� (�系��)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '73');" onclick="selectOpCode(this, '73');">
            <td class="td_standardSmall" width="25%">73</td>
            <td class="td_standardSmall" style="text-align:left;">����</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '74');" onclick="selectOpCode(this, '74');">
            <td class="td_standardSmall" width="25%">74</td>
            <td class="td_standardSmall" style="text-align:left;">ǥ��ȭ</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '75');" onclick="selectOpCode(this, '75');">
            <td class="td_standardSmall" width="25%">75</td>
            <td class="td_standardSmall" style="text-align:left;">�Ϲ� ����ȭ (OA��)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '77');" onclick="selectOpCode(this, '77');">
            <td class="td_standardSmall" width="25%">77</td>
            <td class="td_standardSmall" style="text-align:left;">����Ȱ�� (TFT. Ȱ��)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '78');" onclick="selectOpCode(this, '78');">
            <td class="td_standardSmall" width="25%">78</td>
            <td class="td_standardSmall" style="text-align:left;">���� (������, �Ϲݱ���)</td>
        </tr>
    </table>
</div>

<div id="opGroup_8" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '81');" onclick="selectOpCode(this, '81');">
            <td class="td_standardSmall" width="25%">81</td>
            <td class="td_standardSmall" style="text-align:left;">�Ϲ�����(���������ȸ, ���̳� ����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '82');" onclick="selectOpCode(this, '82');">
            <td class="td_standardSmall" width="25%">82</td>
            <td class="td_standardSmall" style="text-align:left;">�Ϲ�ȸ��</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '84');" onclick="selectOpCode(this, '84');">
            <td class="td_standardSmall" width="25%">84</td>
            <td class="td_standardSmall" style="text-align:left;">�������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '86');" onclick="selectOpCode(this, '86');">
            <td class="td_standardSmall" width="25%">86</td>
            <td class="td_standardSmall" style="text-align:left;">�⹫</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '87');" onclick="selectOpCode(this, '87');">
            <td class="td_standardSmall" width="25%">87</td>
            <td class="td_standardSmall" style="text-align:left;">5S � (�ǰ�����)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '88');" onclick="selectOpCode(this, '88');">
            <td class="td_standardSmall" width="25%">88</td>
            <td class="td_standardSmall" style="text-align:left;">��ȸ</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '89');" onclick="selectOpCode(this, '89');">
            <td class="td_standardSmall" width="25%">89</td>
            <td class="td_standardSmall" style="text-align:left;">����, �޽�, ��</td>
        </tr>
    </table>
</div>

<div id="opGroup_9" STYLE="background-color:#ffffff; width:100%; height:79%; overflow:auto; position:relative; display:none;">
    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
        <tr height="15" bgcolor="#e5e5e5">
            <td class="td_standard">OP CODE</td>
            <td class="td_standard">�� ��</td>
        </tr>

        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '91');" onclick="selectOpCode(this, '91');">
            <td class="td_standardSmall" width="25%">91</td>
            <td class="td_standardSmall" style="text-align:left;">õ������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '92');" onclick="selectOpCode(this, '92');">
            <td class="td_standardSmall" width="25%">92</td>
            <td class="td_standardSmall" style="text-align:left;">�����Ʒ� (4H)</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '98');" onclick="selectOpCode(this, '98');">
            <td class="td_standardSmall" width="25%">98</td>
            <td class="td_standardSmall" style="text-align:left;">����, ������</td>
        </tr>
        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '99');" onclick="selectOpCode(this, '99');">
            <td class="td_standardSmall" width="25%">99</td>
            <td class="td_standardSmall" style="text-align:left;">���</td>
        </tr>
    </table>
</div>

<table width="100%" cellPadding="3" border="1" align="center">
    <tr height="45">
        <td style="vertical-align:middle;text-align:right;">
            <input type="button" value="Ȯ��" class="button_simple" onclick="selectSubmit();">&nbsp;&nbsp;
            <input type="button" value="���" class="button_simple" onclick="javascript:window.close();">&nbsp;
        </td>
    </tr>
</table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    function changeSelectedOpGroup(targetTD, targetDiv) 
    {
        if (document.all.opSelectGroup_1 != null) document.all.opSelectGroup_1.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_2 != null) document.all.opSelectGroup_2.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_3 != null) document.all.opSelectGroup_3.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_4 != null) document.all.opSelectGroup_4.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_5 != null) document.all.opSelectGroup_5.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_5B != null) document.all.opSelectGroup_5B.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_6 != null) document.all.opSelectGroup_6.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_7 != null) document.all.opSelectGroup_7.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_8 != null) document.all.opSelectGroup_8.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_9 != null) document.all.opSelectGroup_9.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_1R != null) document.all.opSelectGroup_1R.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_2R != null) document.all.opSelectGroup_2R.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_3R != null) document.all.opSelectGroup_3R.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_4R != null) document.all.opSelectGroup_4R.style.backgroundColor = "#e5e5e5";
        if (document.all.opSelectGroup_5R != null) document.all.opSelectGroup_5R.style.backgroundColor = "#e5e5e5";

        targetTD.style.backgroundColor = "#00ffff";

        if (document.all.opSelectGroup_1 != null) document.all.opGroup_1.style.display = "none";
        if (document.all.opSelectGroup_2 != null) document.all.opGroup_2.style.display = "none";
        if (document.all.opSelectGroup_3 != null) document.all.opGroup_3.style.display = "none";
        if (document.all.opSelectGroup_4 != null) document.all.opGroup_4.style.display = "none";
        if (document.all.opSelectGroup_5 != null) document.all.opGroup_5.style.display = "none";
        if (document.all.opSelectGroup_5B != null) document.all.opGroup_5B.style.display = "none";
        if (document.all.opSelectGroup_6 != null) document.all.opGroup_6.style.display = "none";
        if (document.all.opSelectGroup_7 != null) document.all.opGroup_7.style.display = "none";
        if (document.all.opSelectGroup_8 != null) document.all.opGroup_8.style.display = "none";
        if (document.all.opSelectGroup_9 != null) document.all.opGroup_9.style.display = "none";
        if (document.all.opSelectGroup_1R != null) document.all.opGroup_1R.style.display = "none";
        if (document.all.opSelectGroup_2R != null) document.all.opGroup_2R.style.display = "none";
        if (document.all.opSelectGroup_3R != null) document.all.opGroup_3R.style.display = "none";
        if (document.all.opSelectGroup_4R != null) document.all.opGroup_4R.style.display = "none";
        if (document.all.opSelectGroup_5R != null) document.all.opGroup_5R.style.display = "none";

        document.getElementById(targetDiv).style.display = "";
        selectOpCode(null, '');
    }

    function selectOpCode(trObj, opCode)
    {
        if (selectedTR != null) selectedTR.style.backgroundColor = "#ffffff";
        
        selectedOpCode = opCode;
        selectedTR = trObj;
        if (selectedTR != null) selectedTR.style.backgroundColor = "ffff00";
    }

    function selectOpCodeAndClose(trObj, opCode)
    {
        selectOpCode(trObj, opCode);    
        selectSubmit();
    }

    function selectSubmit()
    {
        if (selectedOpCode == '') {
            alert('���õ� OP CODE�� �����ϴ�!');
            return;
        }
        window.returnValue = selectedOpCode;
        window.close();
    }

</script>


</html>