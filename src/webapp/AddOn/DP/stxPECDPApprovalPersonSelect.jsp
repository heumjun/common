<%--  
��DESCRIPTION: ����ü����� ȭ�� �޴� �κ� (������ ���� �� ������ �� ��� ���� ��� �κ�)
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDPApprovalPersonSelect.jsp
��CHANGING HISTORY: 
��    2009-04-08: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>
<%@ page import="java.net.URLDecoder"%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String deptCode = StringUtil.setEmptyExt(emxGetParameter(request, "deptCode"));
    String deptName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "deptName")),"UTF-8");
    String dateSelected = StringUtil.setEmptyExt(emxGetParameter(request, "dateSelected"));
    String loginID = emxGetParameter(request, "loginID");

    String errStr = "";
    int listCount = 0;

    ArrayList personList = new ArrayList();
    try {
        if (!deptCode.equals("")) {
            personList = getPartPersonDPConfirms(deptCode, dateSelected);
            listCount = personList.size();
        }
    }
    catch (Exception e) {
        errStr = e.toString();
    }

    float workTimeSum = 0;
    float normalTimeSum = 0;
    float overtimeSum = 0;
    float specialTimeSum = 0;
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
<body style="background-color:#ffffff">
<form name="DPApprovalPersonSelect">

    <input type="hidden" name="listCount" value="<%=listCount%>" />
    <!-- <input type="hidden" name="dataChanged" value="false" /> -->


    <table width="100%" cellSpacing="1" cellpadding="0" border="0">
        <tr height="15">
            <td class="td_standard" style="text-align:left;color:#A4AAA7;font-size:8pt;">
                <%=deptName%>&nbsp;:&nbsp;<%=dateSelected%>
            </td>
        </tr>
    </table>


    <%
    if (!errStr.equals("")) 
    {
    %>
        <table width="100%" cellSpacing="1" cellpadding="4" border="0">
            <tr>
                <td class="td_standard" style="text-align:left;color:#ff0000;">
                    �۾� �߿� ������ �߻��Ͽ����ϴ�. IT ����ڿ��� �����Ͻñ� �ٶ��ϴ�.<br>
                    �ؿ��� �޽���: <%=errStr%>                
                </td>
            </tr>
        </table>
    <%
    }
    else
    {
    %>
        <table width="95%" cellSpacing="1" cellpadding="0" border="0" align="left" bgcolor="#eeeeee">
            <tr height="20" bgcolor="#e5e5e5">
                <!--<td width="8" class="td_standard">&nbsp;</td>-->
                <td width="20" class="td_standard">No</td>
                <td width="60" class="td_standard">���</td>
                <td width="60" class="td_standard">����</td>
                <td width="40" class="td_standard">�ü�</td>
                <td width="30" class="td_standard">FCT.</td>
                <td width="38" class="td_standard">�Ϸ�</td>
                <td width="30" class="td_standard">����</td>
            </tr>

            <%
            for (int i = 0; i < personList.size(); i++) 
            {
                Map map = (Map)personList.get(i);
                String empNo = (String)map.get("EMPLOYEE_NO");
                String empName = (String)map.get("EMPLOYEE_NAME");
                String workTime = (String)map.get("WORKTIME");
                String normalTime = (String)map.get("NORMAL");
                String overtime = (String)map.get("OVERTIME");
                String specialTime = (String)map.get("SPECIAL");
                String inputDoneYN = (String)map.get("INPUTDONE_YN");
                String confirmYN = (String)map.get("CONFIRM_YN");
                String mhFactor = (String)map.get("MH_FACTOR");
                if (mhFactor.equals("1.0")) mhFactor = "1";
                else if (mhFactor.equals("0.0")) mhFactor = "0";

                if (!workTime.equals("")) workTimeSum += Float.parseFloat(workTime);
                if (!normalTime.equals("")) normalTimeSum += Float.parseFloat(normalTime);
                if (!overtime.equals("")) overtimeSum += Float.parseFloat(overtime);
                if (!specialTime.equals("")) specialTimeSum += Float.parseFloat(specialTime);

                String disabled = "";
                String bgColor="";
                String checked = "";

                if (!inputDoneYN.equals("Y")) {
                    disabled = "disabled";
                    bgColor = "#BFFFEF";
                }
                if (confirmYN.equals("Y")) checked = "checked";  
                %>
                <tr height="20" bgcolor="#ffffff" class="td_personselect" 
                    OnMouseOver="this.style.backgroundColor='#ffff00'" OnMouseOut="this.style.backgroundColor='#ffffff'" 
                    onclick="viewDPInputs('<%=empNo%>', '<%=empName%>');">
                    <!--<td width="8" class="td_standard" bgcolor="#e5e5e5">&nbsp;</td>-->
                    <td class="td_standard"><%=i + 1%></td>
                    <td class="td_standard"><font color="blue"><%=empNo%></font></td>
                    <td class="td_standard"><%=empName%></td>
                    <td class="td_standard"><%=workTime%></td>
                    <td class="td_standard" style="color:silver;"><%=mhFactor%></td>
                    <td class="td_standard" style="background-color='<%=bgColor%>'"><%=inputDoneYN%></td>
                    <td class="td_standard"><input type="checkbox" name="check<%=i%>" value="<%=empNo%>" <%=disabled%> <%=checked%> 
                                                   style="cursor:default;" onClick="releaseHeaderCheck();"/></td>
                </tr>    
                <%
            }
            %>
        </table>
    <%
    }
    %>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">

    alert("��ȸ �Ϸ�");

	// Docuemnt�� Keydown �ڵ鷯 - �齺���̽� Ŭ�� �� History back �Ǵ� ���� ����     
	document.onkeydown = keydownHandler;

    // Header�� �μ�����(�μ��� �ü� �հ�)�� ������Ʈ
    if (DPApprovalPersonSelect.listCount.value > 0) {
        parent.DP_APPR_HEADER.DPApprovalHeader.workTimeTotal.value = '<%=workTimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.normalTimeTotal.value = '<%=normalTimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.overtimeTotal.value = '<%=overtimeSum%>';
        parent.DP_APPR_HEADER.DPApprovalHeader.specialTimeTotal.value = '<%=specialTimeSum%>';
    }

    // üũ�ڽ� ��� ����
    function checkAll()
    {
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = DPApprovalPersonSelect.all("check" + i);
            if (ctrlObj.disabled != true) ctrlObj.checked = true;
        }
    }

    // üũ�ڽ� ��� ���� ����
    function unCheckAll()
    {
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = DPApprovalPersonSelect.all("check" + i);
            if (ctrlObj.disabled != true) ctrlObj.checked = false;
        }
    }

    // ����� ��ü���� '����', '����' üũ�ڽ��� üũ�� ����... Unused
    function releaseHeaderCheck()
    {
        /*
        parent.DP_APPR_HEADER.DPApprovalHeader.all('ApprovalAllSelect')[0].checked = false;
        parent.DP_APPR_HEADER.DPApprovalHeader.all('ApprovalAllSelect')[1].checked = false;
        */
    }

    // ���õ� �������� �ü��Է� ������ ����ȭ�鿡 ǥ���Ѵ�
    function viewDPInputs(empNo, empName)
    {
        // ȭ���� ���� �׸� �ʱ�ȭ
        parent.DP_APPR_HEADER.DPApprovalHeader.personInfo.value = "";
        parent.DP_APPR_HEADER.DPApprovalHeader.personWorkTime.value = "";
        parent.DP_APPR_HEADER.DPApprovalHeader.personNormalTime.value = "";
        parent.DP_APPR_HEADER.DPApprovalHeader.personOvertime.value = "";
        parent.DP_APPR_HEADER.DPApprovalHeader.personSpecialTime.value = "";

        // �������� �ü��Է� ������ ����
        var urlStr = "stxPECDPApprovalMain.jsp?empNo=" + empNo + "&empName=" + escape(encodeURIComponent(empName)) + "&dateSelected=<%=dateSelected%>";
        urlStr += "&deptCode=<%=deptCode%>";
        parent.DP_APPR_MAIN.location = urlStr;
    }

    // �ü����� ������ ����
    function saveApprovals()
    {
        var toApplyStrs = "";
        for (var i = 0; i < DPApprovalPersonSelect.listCount.value; i++) {
            var ctrlObj = DPApprovalPersonSelect.all("check" + i);
            if (ctrlObj.disabled != true) { 
                if (toApplyStrs != "") toApplyStrs += ",";
                toApplyStrs += ctrlObj.value + "|" + (ctrlObj.checked ? "Y" : "N");
            }
        }

        if (toApplyStrs == "") {
            alert("������ ����� �ϳ��� �����ϴ�!\n\n�۾��� ��ҵǾ����ϴ�.");
            return;
        }

        var allChecked = parent.DP_APPR_HEADER.DPApprovalHeader.all('ApprovalAllSelect')[0].checked ? "Y" : "N";
        
        // ���� ������ ��û
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=SaveApprovals&applyStrs=" + toApplyStrs + 
                            "&dateStr=<%=dateSelected%>&loginID=<%=loginID%>&deptCode=<%=deptCode%>&allChecked=" + allChecked, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;

                if (resultMsg != null && resultMsg.trim() == "") {
                    alert("�ü����� ���� �Ϸ�");
                }
                else if (resultMsg != null && resultMsg.trim() != "") {
                    alert("�ü����� ���� �Ϸ�\n\n" + resultMsg.trim());
                    parent.DP_APPR_HEADER.viewPartPersons();
                }
                else alert("ERROR");
            }
            else alert("ERROR"); 
        }
        else alert("ERROR"); 
    }


</script>

</html>