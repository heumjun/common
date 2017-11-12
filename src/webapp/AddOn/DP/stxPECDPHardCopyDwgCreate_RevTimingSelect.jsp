<%--  
��DESCRIPTION: ���� �⵵����(Hard Copy) �׸� ��� - �⵵�ñ� ���� ȭ��
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPHardCopyDwgCreate_RevTimingSelect.jsp
��CHANGING HISTORY: 
��    2010-05-13: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>



<%--========================== JSP =========================================--%>
<%
    String dwgCategory = emxGetParameter(request, "dwgCategory");
    String departCode = emxGetParameter(request, "departCode");
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>Distribution Time</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5; padding:10px;10px;10px;10px;">
<form name="DPDwgRevTimingForm">

<table width="100%" cellSpacing="0" cellpadding="6" border="1" align="center">
    <tr height="20">
        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Group</font></td>
        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Distribution Time</font></td>
    </tr>
    
    <%
    // �⺻��
    if (dwgCategory.equals("B"))    
    {
        %>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                Impact of Afterwards Design
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_2[0].checked=true;" />
                Pre-Design
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" />
                Post-Design
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                Impact of Production
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="���� ��" />
                Pre-Production
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="���� ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_1[1].checked=true;"/>
                Post-Production
            </td>
        </tr>
        <%
    }
    // ������ & �ؾ缱ü������
    else if (departCode.equals("983000"))
    {
        %>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                STEEL CUTTING
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_2[0].checked=true;"/>
                Pre-Cutting
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" />
                Post-Cutting
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                Production
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="�ð� ��" />
                Pre-Production
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="�ð� ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_1[1].checked=true;"/>
                Post-Production
            </td>
        </tr>
        <%
    }
    // ������ & �ؾ缱ü������ ��
    else
    {
        %>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                Manufacture
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_2[0].checked=true;"/>
                Pre-Manufacture
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_1" value="���� ��" />
                Post-Manufacture
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standard" rowspan="2">
                Installation
            </td>
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="��ġ ��" />
                Pre-Installation
            </td>
        </tr>
        <tr style="background-color:#ffffff;">
            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="revTimingCheck_2" value="��ġ ��" 
                       onclick="DPDwgRevTimingForm.revTimingCheck_1[1].checked=true;"/>
                Post-Installation
            </td>
        </tr>
        <%
    }
    %>

    <tr height="55">
        <td colspan="2" style="vertical-align:middle;text-align:right;">
            <input type="button" name="okButton" value="OK" class="button_simple" onclick="okButtonClicked();">
            <input type="button" name="cancelButton" value="Cancel" class="button_simple" onclick="window.close();">
        </td>
    </tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // �⵵�ñ� ���û����� ����
    function okButtonClicked()
    {
        revTimingCheck1Val = "";
        revTimingCheck2Val = "";

        if (DPDwgRevTimingForm.revTimingCheck_1[0].checked) revTimingCheck1Val = DPDwgRevTimingForm.revTimingCheck_1[0].value;
        if (DPDwgRevTimingForm.revTimingCheck_1[1].checked) revTimingCheck1Val = DPDwgRevTimingForm.revTimingCheck_1[1].value;
        if (DPDwgRevTimingForm.revTimingCheck_2[0].checked) revTimingCheck2Val = DPDwgRevTimingForm.revTimingCheck_2[0].value;
        if (DPDwgRevTimingForm.revTimingCheck_2[1].checked) revTimingCheck2Val = DPDwgRevTimingForm.revTimingCheck_2[1].value;

        if (revTimingCheck1Val == "" || revTimingCheck2Val == "") {
            alert("Please select 'Distribution Time' items!");
            return;
        }

        window.returnValue = revTimingCheck1Val + "," + revTimingCheck2Val;
        window.close();
    }

</script>


</html>