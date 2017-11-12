<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.util.FrameworkUtil"%>
<%@ page import="java.util.*" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%!

    private ArrayList searchDeptMapList() throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList deptMapList = new ArrayList();


		try {
			conn = DBConnect.getDBConnection("SDPS");    
            stmt = conn.createStatement();

            StringBuffer queryStr = new StringBuffer();
			queryStr.append("select DWGDEPTNM ");
			queryStr.append("  from dcc_dwgdeptcode ");
			queryStr.append(" where DWGDEPTFG = 'T' ");
			queryStr.append(" order by DWGDEPTNM ");

            rset = stmt.executeQuery(queryStr.toString());

			while(rset.next()){
				
				String dept = rset.getString(1)==null?"":rset.getString(1);
				
				Map deptMap = new HashMap();
				
				deptMap.put("deptName" , dept);
				
				deptMapList.add(deptMap);
			}

		} catch (Exception e) {
            e.printStackTrace();
        }

		finally {
            if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return deptMapList;
    }


%>

<%
 	String languageStr = request.getHeader("Accept-Language");	
	String formName = emxGetParameter(request,"formName");
	String fieldName = emxGetParameter(request,"fieldName");
	String fieldName2 = emxGetParameter(request,"fieldName2");
	
	ArrayList deptMapList = new ArrayList();
    
    try {
        deptMapList = searchDeptMapList();
    }
    catch (Exception e) {    	

    }	
%>

<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<STYLE> 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#f5f5f5">
<form name="resultForm">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="670" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp;Department</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="670" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">            
            <td class="td_standardBold" style="background-color:#336699;" width="20%"><font color="#ffffff">수신부서</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="20%"><font color="#ffffff">참조부서</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="60%"><font color="#ffffff">Name</font></td>
        </tr>
    </table>

        <div STYLE="width:670; height:300; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="670" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%
            //String sRowClass = "";
            int count = 0;
            for(int i=0; i<deptMapList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map deptMapListMap = (Map)deptMapList.get(i);
                String tempDeptName = (String)deptMapListMap.get("deptName"); 

             %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="20%"><input type="checkbox" name="selectedReceiveDept<%=count%>" value="<%=tempDeptName%>"></td>
                    <td class="td_standard" width="20%"><input type="checkbox" name="selectedRefDept<%=count%>" value="<%=tempDeptName%>"></td>  		
                    <td class="td_standard" width="60%"><%=tempDeptName%></td>
                </tr>
            <%
            	count++;
            }
            %>
        </table>
        </div>
<br><br>
    <table width="650" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td style="text-align:right;">
                <hr>
                <input type="button" value="확인" class="button_simple" onclick="javascript:deptSubmit();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>

</form>
</body>


<script language="JavaScript">

function deptSubmit() {

	var someSelected = false;

	for(var i = 0; i < document.resultForm.elements.length; i++)
	{
		if(document.resultForm.elements[i].type == "checkbox") 
		{
			if(document.resultForm.elements[i].checked == true)
			{
				someSelected = true;
				break;
			}
		}
	}

	if(!someSelected)
	{
		//warning message: Internationalized
		var msg = "Please Make A Selection";
		alert(msg);
		return;
	} else {
		var receiveDept = "";
		var refDept = "";
		
		for(var i = 0; i<document.resultForm.elements.length; i++)
		{
			var obj = document.resultForm.elements[i];
			if(obj.type == "checkbox" && obj.checked == true && obj.name.indexOf("selectedReceiveDept")>-1)
			{
				if(receiveDept == "")
					receiveDept = obj.value;
				else
					receiveDept = receiveDept + "," + obj.value;
			}
			if(obj.type == "checkbox" && obj.checked == true && obj.name.indexOf("selectedRefDept")>-1)
			{
				if(refDept == "")
					refDept = obj.value;
				else
					refDept = refDept + "," + obj.value;
			}
		}

		parent.window.opener.document.forms['<%=formName%>'].elements['<%=fieldName%>'].value = receiveDept;
		parent.window.opener.document.forms['<%=formName%>'].elements['<%=fieldName2%>'].value = refDept;
		//parent.window.opener.document.forms[0].ECOType.value = jsObjName;
		//parent.window.opener.document.forms[0].ECOTypeDesc.value = jsObjDesc;
		//parent.window.opener.document.forms[0].CategoryofChangeDisp.value = jsObjName2;
		//parent.window.opener.document.forms[0].CategoryofChange.value = jsObjName2;
		//parent.window.opener.document.forms[0].CategoryofChangeDesc.value = jsObjDesc2;
		parent.window.close();		
	}
}
</script>
