<%--  
��DESCRIPTION: ����ü��Է� - OP CODE ���� â 
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECDPInputNew_OpSelect.jsp
��CHANGING HISTORY: 
��    2014-12-10: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include.inc" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%
    String projectNo = request.getParameter("projectNo");
    boolean isNonProject = false;
    boolean isMultiProject = false;
    boolean isRealProject = false;

    String defaultGRT = "";
    String defaultMID = "";
    // ȣ���� S000�� �����ȣ��, ȣ���� �ϳ��� ���, �ټ� ȣ���� ���õ� ���(,�� ȣ�����е�)
    if (projectNo.equals("S000")) 
    {
    	isNonProject = true;
    	defaultGRT = "C";
    	defaultMID = "1";
    } else if (projectNo.indexOf(",") > -1) {
    	isMultiProject = true;
    	defaultGRT = "B";
    	defaultMID = "1";
    } else {
    	isRealProject = true;
    	defaultGRT = "A";
    	defaultMID = "1";
    }
    
    
    ArrayList opCodeListGRT = null;    // OP CODE ��з�
    ArrayList opCodeListMID = null;    // OP CODE �ߺз�
    ArrayList opCodeListSUB = null;    // OP CODE �Һз�
    
    String errStr = "";
    
    try {
    	//opCodeListGRT = getOpCodeListGRT(isNonProject, isMultiProject, isRealProject);
    	opCodeListMID = getOpCodeListMID(isNonProject, isMultiProject, isRealProject);
    	opCodeListSUB = getOpCodeListSUB(isNonProject, isMultiProject, isRealProject);
    	
    	
    }
    catch (Exception e) {
        errStr = e.toString();
    }    
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
	<tr height="20">
		<% //2015-02-03 : Hard coding���� ó�� %>		
		<%if(isNonProject) {%>
			<td align="center" colspan="<%=opCodeListMID.size()%>">�����ü�</td>
		<%} else if(isMultiProject) {%>
			<td align="center" colspan="<%=opCodeListMID.size()%>">�񵵸�ü� (���������)</td>
		<%} else {%>
			<td align="center" colspan="5">����ü� (��������)</td>
			<td align="center" colspan="6">�񵵸�ü� (���������)</td>
		<%} %>
	</tr>
	

    <tr height="16">
        <%  for (int i = 0; i < opCodeListMID.size(); i++) 
            {
        		Map map = (Map)opCodeListMID.get(i);
                String GRT_CODE = (String)map.get("GRT_CODE");
                String MID_CODE = (String)map.get("MID_CODE");
                String MID_DESC = (String)map.get("MID_DESC");
                
                String styleStr = "";
                if(GRT_CODE.equals(defaultGRT) && MID_CODE.equals(defaultMID))
                {
                	styleStr = "background-color:#00ffff;";                	
                }
        %>
            <td id="opSelectGroup_<%=GRT_CODE+MID_CODE%>" style="<%=styleStr%>" class="td_opselect" onclick="changeSelectedOpGroup(this, 'opGroup_<%=GRT_CODE+MID_CODE%>');"><%=MID_DESC%></td>

        <% } %>
    </tr>
    <tr height="6"><td colspan="<%=opCodeListMID.size()%>"></td></tr>
</table>




<%
String opSelectGroupList = "";     // OP CODE GROUP ��� ���� KEY���� ��Ƶд�.
for (int k = 0; k < opCodeListMID.size(); k++) 
{
     Map opCodeListMIDmap = (Map)opCodeListMID.get(k);
     String GRT_CODE = (String)opCodeListMIDmap.get("GRT_CODE");
     String MID_CODE = (String)opCodeListMIDmap.get("MID_CODE");
     
     if("".equals(opSelectGroupList))
     {
    	 opSelectGroupList += GRT_CODE+MID_CODE;   	 
     } else {
    	 opSelectGroupList += ","+GRT_CODE+MID_CODE;    	 
     }
     
     String displayStr = "display:none;";
     if(GRT_CODE.equals(defaultGRT) && MID_CODE.equals(defaultMID))
     {
     	displayStr = "";       	
     }

%>
	<div id="opGroup_<%=GRT_CODE+MID_CODE%>" STYLE="background-color:#ffffff; width:100%; height:69%; overflow:auto; position:relative; <%=displayStr%>">
	    <table width="99%" cellSpacing="1" cellpadding="2" border="0" align="center" bgcolor="#cccccc">
	        <tr height="15" bgcolor="#e5e5e5">
	            <td class="td_standard">OP CODE</td>
	            <td class="td_standard">�� ��</td>
	        </tr>
	    <%  for (int i = 0; i < opCodeListSUB.size(); i++) 
	        {
	    		Map map = (Map)opCodeListSUB.get(i);
	            String OP_CODE = (String)map.get("OP_CODE");
	            String tempGRT_CODE = (String)map.get("GRT_CODE");
	            String tempMID_CODE = (String)map.get("MID_CODE");
	            String SUB_DESC = (String)map.get("SUB_DESC");
	            //System.out.println("tempGRT_CODE = "+tempGRT_CODE +", tempMID_CODE = "+tempMID_CODE);
	            if(!GRT_CODE.equals(tempGRT_CODE) || !MID_CODE.equals(tempMID_CODE)) continue;
	    %>
		        <tr height="15" bgcolor="#ffffff" ondblclick="selectOpCodeAndClose(this, '<%=OP_CODE%>');" onclick="selectOpCode(this, '<%=OP_CODE%>');">
		            <td class="td_standardSmall" width="25%"><%=OP_CODE%></td>
		            <td class="td_standardSmall" style="text-align:left;"><%=SUB_DESC%></td>
		        </tr>            
	
	        <% } %>
	    </table>
	</div>
<%} %>
<input type="hidden" name="opSelectGroupList" value="<%=opSelectGroupList%>">



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
		// OPCODEGROUP ID KEY���� ������ �ش� ID�� STYLE �ʱ�ȭ (backgroundColor, display)
    	var opSelectGroupList = document.all.opSelectGroupList.value;

		var aSplit = new Array();
        aSplit = opSelectGroupList.split(",");
        for (var sc=0; sc < aSplit.length; sc++) {
        	var opSelectGroupID = 'opSelectGroup_'+aSplit[sc];	
        	var opGroupID = 'opGroup_'+aSplit[sc];	
        	document.getElementById(opSelectGroupID).style.backgroundColor = "#e5e5e5";
        	document.getElementById(opGroupID).style.display= "none";
        }

        targetTD.style.backgroundColor = "#00ffff";   
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