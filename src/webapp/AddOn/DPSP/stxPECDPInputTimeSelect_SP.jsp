<%--  
��DESCRIPTION: ����ü��Է� ȭ�� �޴� �κ�((�ð�/�׸� ����)
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPInputTimeSelect.jsp
��CHANGING HISTORY: 
��    2009-04-07: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color: #E8E8E8;">
<form name="DPInputTimeSelect">

<table width="100%" height="100%" cellSpacing="2" cellpadding="1" border="1" align="center">
    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="3" border="0" align="center">
                <tr height="12">
                    <td></td>
                </tr>
                <tr height="20">
                    <td class="td_timeselect"><font color="gray">A.M</font></td>
                    <td class="td_timeselect"><font color="gray">P.M</font></td>
                    <td class="td_timeselect"><font color="gray">����</font></td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" style="cursor:default;">08:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1300');">13:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1800');">18:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0830');">08:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1330');">13:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1830');">18:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0900');">09:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1400');">14:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1900');">19:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('0930');">09:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1430');">14:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1930');">19:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1000');">10:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1500');">15:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2000');">20:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1030');">10:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1530');">15:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2030');">20:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1100');">11:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1600');">16:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2100');">21:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1130');">11:30</td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1630');">16:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2130');">21:30</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1200');">12:00</td>
                    <td class="td_timeselect2" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1700');">17:00</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2200');">22:00</td>
                </tr>
                <tr height="16">
                    <td class="td_timeselect3" style="cursor:default;"><!--12:30--></td>
                    <td class="td_timeselect3" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('1730');">17:30</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2230');">22:30</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2300');">23:00</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect3_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2330');">23:30</td>
                </tr>
                <tr height="16">
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td class="td_timeselect2_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="timeSelected('2400');">24:00</td>
                </tr>
            </table>
        </td>
    </tr>

    <!--
    <tr height="8" valign="top">
        <td></td>
    </tr>
    -->

    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="2" border="1" align="center">
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWork();">���</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarly();">����</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarlyAfterSeaTrial();">�ÿ��� �� �������(����)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="finishWorkEarlyAfterSeaTrial('���� �� �������(����)');">���� �� �������(����)</td>
                </tr>
            </table>
        </td>
    </tr>

    <!--
    <tr height="4" valign="top">
        <td></td>
    </tr>
    -->

    <tr height="16">
        <td class="td_timeselect" style="font-size:10pt;border:#D8D8D8 0px solid;vertical-align:bottom;font-weight:bold;">
        1 �� �̻�<br><font style="font-size:8pt;">[�̷� ���� �Է� ����]</font>
        </td>
    </tr>

    <tr valign="top">
        <td width="100%">
            <table width="100%" cellSpacing="0" cellpadding="2" border="1" align="center">
                <!--
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'">���� �� �������</td>
                </tr>
                -->
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('97');">����</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('94');">Ư���ް�</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJobWithProject('36');">��� ���� ����<br>(������� ����)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJob('72');">���ȸ�� �� ����<br>(�系��)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsOneDayOverJob('81');">�Ϲ�����<br>(���������ȸ, ���̳�)</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsSeaTrial();">�ÿ���</td>
                </tr>
                <tr height="18">
                    <td class="td_timeselect4" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="saveAsVacationOrMilitaryTraining('93');">���� �Ʒ�(9H)</td>
                </tr>
                <!--
                <tr height="18">
                    <td class="td_timeselect4_1" OnMouseOver="this.style.backgroundColor='#BFFFEF'" OnMouseOut="this.style.backgroundColor='#E8E8E8'" onClick="copyYesterdayMH();">���Ͻü� COPY</td>
                </tr>
                -->
            </table>
        </td>
    </tr>

    <tr height="4" valign="top">
        <td></td>
    </tr>

    <tr valign="top">
        <td width="100%" style="font-family:���� ���,����ü;font-size:8pt;">
            <table width="100%" cellSpacing="0" cellpadding="1" style="border:#000000 1px solid;background-color:#cccccc;">
                <tr>
                    <td colspan="3" style="text-align:center;">�����</td>
                </tr>
                <tr>
                    <td>����&nbsp;</td>
                    <td>�Ѱ��� �븮</td>
                    <td>T.#62+3220</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>������ ����</td>
                    <td>T.#62+5780</td>
                </tr>
                <tr>
                    <td>�ؾ�&nbsp;</td>
                    <td>������ ����</td>
                    <td>T.#60+2163</td>
                </tr>
            </table>
        </td>
    </tr>

    <tr height="100%" valign="top">
        <td ></td>
    </tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">

    // Docuemnt�� Keydown �ڵ鷯 ���� - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ���� ��
    document.onkeydown = keydownHandler;

    // �ü� ���� ���� ���翩�� üũ
    function checkMHConfirmYN()
    {
        if (parent.DP_HEADER.DPInputHeader.isAdmin.value != "true" && parent.DP_MAIN.DPInputMain.MHConfirmYN.value == "Y") {
            alert("���簡 �Ϸ�� �����Դϴ�!\n\n�ü��Է� ������ �����Ϸ��� ���� �����ڿ��� ������Ҹ� ��û�Ͻʽÿ�.");
            return true;
        }
        return false;
    }

    //// �ش� ���� + Work Day 2���� ����Ǿ����� üũ => �� üũ�� Header���� ��¥ ���� �� üũ�ǹǷ� ����
    //function checkWorkdaysGap()
    //{
    //    if (parent.DP_HEADER.DPInputHeader.isAdmin.value != "true" && 
    //        (parent.DP_MAIN.DPInputMain.workdaysGap.value == -1 || parent.DP_MAIN.DPInputMain.workdaysGap.value >= 3)) {
    //        alert("�Է� ��ȿ����(�ش����� + Workday 2��)�� ����Ǿ����ϴ�.\n\n�����ڿ��� LOCK ������ ��û�Ͻʽÿ�.");
    //        return true;
    //    }
    //    return false;
    //}
    
    // �ü��Է��� ������ �������� üũ
    function isInvalidConditions()
    {
        var b;
        b = checkMHConfirmYN();
        //if (!b) b = checkWorkdaysGap();

        return b;
    }

    // �ð� ����(Ŭ��) �� �ü��Է� â�� �ݿ�
    function timeSelected(timeKey)
    {
        if (!isInvalidConditions()) parent.DP_MAIN.timeSelected(timeKey);
    }

    // 1 �� �̻�(ȣ������ ����) - ����, Ư���ް�, �����Ʒ�
    function saveAsVacationOrMilitaryTraining(opCode)
    {
        parent.DP_MAIN.saveAsVacationProc(opCode);
    }

    // 1 �� �̻�(ȣ������ ����) - ���ȸ�� �� ����, �Ϲ����� 
    function saveAsOneDayOverJob(opCode)
    {
        parent.DP_MAIN.saveAsOneDayOverJob(opCode); // DP_MAIN �κ� �ڵ忡�� �������� üũ��
    }

    // 1 �� �̻�(ȣ������ ����) - ��� ���� ����
    function saveAsOneDayOverJobWithProject(opCode)
    {
        parent.DP_MAIN.saveAsOneDayOverJobWithProject(opCode); // DP_MAIN �κ� �ڵ忡�� �������� üũ��
    }

    // ���
    function finishWork()
    {
        if (!isInvalidConditions()) {
            parent.DP_MAIN.finishWork();
        }
    }

    // ����
    function finishWorkEarly()
    {
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value == "����") {
                alert("���� ����� ������ ��쿡�� �����մϴ�.");
                return;
            }
            parent.DP_MAIN.finishWorkEarly();
        }
    }

    // �ÿ���
    function saveAsSeaTrial()
    {
        parent.DP_MAIN.saveAsSeaTrial(); // �ÿ����� DP_MAIN �κ� �ڵ忡�� �������� üũ��
    }

    // �ÿ��� �� �������(����)
    function finishWorkEarlyAfterSeaTrial(comments)
    {
    	if(!comments)comments = '�ÿ��� �� �������';
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value == "����") {
                alert("'"+comments+"' ����� ������ ��쿡�� �����մϴ�.");
                return;
            }
            parent.DP_MAIN.finishWorkEarlyAfterSeaTrial(comments);
        }
    }

    // ���Ͻü� COPY
    function copyYesterdayMH()
    {
        if (!isInvalidConditions()) {
            if (parent.DP_MAIN.DPInputMain.workingDayYN.value != "����") {
                alert("'���Ͻü� COPY'�� ������ ��쿡�� �����մϴ�.");
                return;
            }
            parent.DP_MAIN.copyYesterdayMH();
        }
    }

</script>


</html>