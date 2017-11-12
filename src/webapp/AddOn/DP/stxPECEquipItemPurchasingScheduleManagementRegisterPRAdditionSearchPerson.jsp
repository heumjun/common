<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 추가 PR 등록화면 : 추가예산 담당자 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterPRAdditionSearchPerson.jsp
§CHANGING HISTORY: 
§    2013-11-29: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>



<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// 접수자의 팀원 리스트를 가져온다.
    private ArrayList searchProcessPerson() throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT BB.EMP_NO, BB.USER_NAME, BB.DEPT_CODE, BB.DEPT_NAME, BB.POSITION_NAME        \n");
            queryStr.append("  FROM STX_COM_INSA_USER BB                                                          \n");
			queryStr.append(" WHERE 1=1                                                                          \n");
			queryStr.append("   AND BB.DEL_DATE IS NULL                                                          \n");
			queryStr.append("   AND DEPT_CODE='249000'     -- 경영예산팀 인원만                                 \n");
			queryStr.append(" ORDER BY BB.USER_NAME,BB.DEPT_CODE                                                 \n");
            //System.out.println("queryStr = "+queryStr.toString());
  
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("EMP_NO", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("USER_NAME", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("DEPT_CODE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("DEPT_NAME", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("POSITION_NAME", rset.getString(5) == null ? "" : rset.getString(5));
                resultArrayList.add(resultMap);
            }
		}
		finally {
            if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}
		return resultArrayList;
    }


%>


<%--========================== JSP =========================================--%>
<%

	//System.out.println("workUser = "+workUser);
    String errStr = "";

    ArrayList searchProcessPersonList = null;
    try {
        searchProcessPersonList = searchProcessPerson();
        //System.out.println("~~ searchProcessPersonList = "+searchProcessPersonList.toString());
    }
    catch (Exception e) {
        errStr = e.toString();
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
<form name="frmSearchProcessPerson">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="670" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp; 추가예산내용 수신 담당자 지정</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="670" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="10%">&nbsp;</td>            
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">사 번</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">성 명</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">직 급</font></td>
			<td class="td_standardBold" style="background-color:#336699;" width="45%"><font color="#ffffff">부 서</font></td>
        </tr>
    </table>

        <div STYLE="width:670; height:300; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="670" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%            
            for(int i=0; i<searchProcessPersonList.size(); i++)
            {
                Map searchProcessPersonListMap = (Map)searchProcessPersonList.get(i);
                String emp_no = (String)searchProcessPersonListMap.get("EMP_NO");
                String user_name = (String)searchProcessPersonListMap.get("USER_NAME");                
				String position_name = (String)searchProcessPersonListMap.get("POSITION_NAME"); 
                String dept_name = (String)searchProcessPersonListMap.get("DEPT_NAME");
				String dept_code = (String)searchProcessPersonListMap.get("DEPT_CODE"); 
				String keyUserInfo = emp_no+"|"+user_name;

            %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="10%"><input type="checkbox" name="emp_no<%=i%>" value="<%=keyUserInfo%>"></td>                    
                    <td class="td_standard" width="15%"><%=emp_no%></td>
                    <td class="td_standard" width="15%"><%=user_name%></td>
                    <td class="td_standard" width="15%"><%=position_name%></td>
					<td class="td_standard" width="45%"><%=dept_name%></td> 
                </tr>
            <%
            }
            %>
        </table>
        </div>
<br><br>
    <table width="650" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td style="text-align:right;">
                <hr>
                <input type="button" value="확인" class="button_simple" onclick="javascript:savePerson();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="button" value="닫기" class="button_simple" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

function savePerson()
{
    var someSelected = false;
    var mainForm = document.frmSearchProcessPerson;

    var emp_no_list = "";
	var user_name_list = "";

    for(var i = 0; i < mainForm.elements.length; i++)
    {    
        if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
        {
            someSelected = true;
            var tempcheckPerson = mainForm.elements[i].value;

			var splitCheckPerson = tempcheckPerson.split('|');
			var emp_no = splitCheckPerson[0];
			var user_name = splitCheckPerson[1];

			if(emp_no_list=="" || emp_no_list==null)
			{
				emp_no_list += emp_no;
				user_name_list += user_name;
	
			} else {
				emp_no_list += ","+emp_no;
				user_name_list += ","+user_name;
			}
        }
    }


    if(!someSelected)
    {
        var msg = "Please make a selection.";
        alert(msg);
        return;
    }

    parent.window.opener.document.frmEquipItemPurchasingManagementPRAddition.addChargeReceiver.value = emp_no_list;
    parent.window.opener.document.frmEquipItemPurchasingManagementPRAddition.addChargeReceiverName.value = user_name_list;

    window.close();
}
</script>


</html>