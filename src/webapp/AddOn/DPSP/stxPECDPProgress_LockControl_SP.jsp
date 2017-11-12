<%--  
��DESCRIPTION: �������� - ���� �Է� LOCK ���� ȭ��
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPProgress_LockControl.jsp
��CHANGING HISTORY: 
��    2009-09-19: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String loginID = emxGetParameter(request, "loginID");
    String errStr = "";

    ArrayList dpProgressLockList = null;
    try {
        dpProgressLockList = getDPProgressLockList();
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>���� �Է����� ����</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>
<script language="javascript" type="text/javascript" src="stxPECDP_GeneralAjaxScript_SP.js"></script>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name="DPProgressLockList">

<div id="lockListDiv" STYLE="height:300; width:390; overflow:auto; position:absolute; left:4; top:6;">
    <table width="100%" cellSpacing="0" cellpadding="0" border="1" align="center">
        <tr height="20">
            <td class="td_standardBold" style="background-color:#336699;" width="30"><font color="#ffffff">NO</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="70"><font color="#ffffff">�μ��ڵ�</font></td>
            <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">�μ���</font></td>
            <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">�Է°�����</font></td>
        </tr>
            
        <%
        for (int i = 0; dpProgressLockList != null && i < dpProgressLockList.size(); i++) 
        {
            Map map = (Map)dpProgressLockList.get(i);
            String deptCode = (String)map.get("DEPT_CODE");
            String deptName = (String)map.get("DEPT_NAME");
            String lockDate = (String)map.get("LOCK_DATE");
            String colorStr = "#ffffff";
            /*if (StringUtil.isNullString(lockDate))*/ colorStr = "#ffffe0";
            %>
            <tr height="20" style="background-color:#ffffff">
                <td class="td_standard"><%=i + 1%></td>
                <td class="td_standard"><%=deptCode%></td>
                <td class="td_standard" style="text-align:left;"><%=deptName%></td>
                <td class="td_standard" style="width:100px;padding:0;">
                    <input type="text" value="<%=lockDate%>" 
                           style="width:100px;border:0;background-color:<%=colorStr%>;text-align:center;" 
                           onchange="onLockValueChanged('<%=deptCode%>', this);" />
                </td>
            </tr>
            <%
        }
        %>
    </table>
</div>

<div id="lockListDiv" STYLE="overflow:auto; position:absolute; left:4; top:300;">
    <table width="100%">
        <tr height="50">
            <td style="text-align:right;">
                <input type="button" value="����" class="button_simple" onclick="updateDPProgressLockList();">&nbsp;&nbsp;
                <input type="button" value="�ݱ�" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</div>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    // ���ڸ� �����ϴ��� üũ
    function containsNumberOnly(input) 
    {
        var chars = "0123456789";
        for (var inx = 0; inx < input.length; inx++) {
           if (chars.indexOf(input.charAt(inx)) == -1)
               return false;
        }
        return true;
    }  

    // ����� ���� ����
    var changedList = new Array();

    // �Է°����� �� ���� �� ó��
    function onLockValueChanged(deptCode, inputObj)
    {
        var str = inputObj.value.trim();
        if (str != "" && str.indexOf("-") != 0) str = "-" + str;
        inputObj.value = str;

        if (str != "" && !containsNumberOnly(str.substring(1))) {
            inputObj.value = "";
            alert("���ڸ� �Է��Ͻʽÿ�!");
            inputObj.focus();
        }

        // ���� ��Ͽ� �̹� ������ ������Ʈ, ������ �߰�
        var isExist = false;
        for (var i = 0; i < changedList.length; i++) {
            var tempStr = changedList[i];
            if (tempStr.indexOf(deptCode + "|") >= 0) {
                changedList[i] = deptCode + "|" + str;
                isExist = true;
                break;
            }
        }
        if (!isExist) changedList[changedList.length] = deptCode + "|" + str;

        inputObj.style.backgroundColor = "#fff0f5";
    }

    // ��������� ����(DB�� ����)
    function updateDPProgressLockList()
    {
        if (changedList.length <= 0) {
            alert("��������� �ϳ��� �����ϴ�!");
            return;
        }
        
        var params = "";
        for (var i = 0; i < changedList.length; i++) {
            if (i > 0) params += ",";
            params += changedList[i];
        }

        var resultMsg = callDPCommonAjaxProc("UpdateDPProgressLockList", "params", params);
        if (resultMsg == "ERROR") alert("������ �߻��Ͽ� ���忡 �����߽��ϴ�!");
        else alert("����Ϸ�!");
    }

</script>


</html>