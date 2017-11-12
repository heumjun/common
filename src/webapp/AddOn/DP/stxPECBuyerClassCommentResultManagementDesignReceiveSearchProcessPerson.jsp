<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 설계 접수 : 처리담당자 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignReceiveSearchProcessPerson.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// 접수자의 팀원 리스트를 가져온다.
    private ArrayList searchProcessPerson(String workUser) throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT BB.EMP_NO, BB.USER_NAME, BB.DEPT_CODE, BB.DEPT_NAME, BB.POSITION_NAME        \n");
            queryStr.append("  FROM                                                                              \n");
            queryStr.append("  (   SELECT DEPT_CODE                                                              \n");
            queryStr.append("        FROM STX_COM_INSA_DEPT                                                      \n");
            queryStr.append("       WHERE TEAM_CODE =                                                            \n");
            queryStr.append("                       ( SELECT DEPT.TEAM_CODE                                      \n");
            queryStr.append("                           FROM STX_COM_INSA_USER INSA,                             \n");
            queryStr.append("                                STX_COM_INSA_DEPT DEPT                              \n");
            queryStr.append("                          WHERE INSA.DEPT_CODE = DEPT.DEPT_CODE                     \n");
            queryStr.append("                            AND INSA.EMP_NO = '" +workUser +"' )                    \n");
			queryStr.append("     --    AND DEPT_CODE != TEAM_CODE                                               \n");
			queryStr.append("   ) AA,                                                                            \n");
			queryStr.append("   STX_COM_INSA_USER BB                                                             \n");
			queryStr.append(" WHERE 1=1                                                                          \n");
			queryStr.append("   AND AA.DEPT_CODE = BB.DEPT_CODE                                                  \n");
			queryStr.append("   AND BB.DEL_DATE IS NULL                                                          \n");
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

	String workUser = StringUtil.setEmptyExt(emxGetParameter(request, "workUser"));
	String selectType = StringUtil.setEmptyExt(emxGetParameter(request, "selectType"));
	String processUser = StringUtil.setEmptyExt(emxGetParameter(request, "processUser"));	
	
	//System.out.println("workUser = "+workUser);
    String errStr = "";

    ArrayList searchProcessPersonList = null;
    try {
        searchProcessPersonList = searchProcessPerson(workUser);
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
           <td><br><font color="darkblue"><b>&nbsp;&nbsp; Comment 처리 담당자 지정</b></font> </td>
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
				String keyUserInfo = emp_no+"|"+user_name+"|"+dept_name;

            %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="10%">
                    	<%if(selectType.equals("Single")){ %>
                    		<input type="radio" name="radioUser" value="<%=keyUserInfo%>" <%if(emp_no.equals(processUser)){%>checked="checked"<%} %>>
                    	<%}else{ %>
                    		<input type="checkbox" name="checkbox<%=i%>" value="<%=keyUserInfo%>">
                    	<%} %>
	                    
                    </td>
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
   // var checkPerson = ""
    var emp_no_list = "";
	var user_name_list = "";
	var dept_name_list = "";
	
	if(mainForm.elements[0].type == "radio"){
		someSelected = true;
		for(var i=0; i < mainForm.radioUser.length; i++){
			if(mainForm.radioUser[i].checked){
				var checkPerson = mainForm.radioUser[i].value;
			}	
		}
		var splitCheckPerson = checkPerson.split('|');
		var emp_no = splitCheckPerson[0];
		var user_name = splitCheckPerson[1];
		var dept_name = splitCheckPerson[2];
		
        emp_no_list = emp_no;
        user_name_list = user_name+ " ("+dept_name+")";
            
	}else{
	    for(var i = 0; i < mainForm.elements.length; i++)
	    {   
	        if(mainForm.elements[i].type == "checkbox" && mainForm.elements[i].checked == true)
	        {
	            someSelected = true;
	            var checkPerson = mainForm.elements[i].value;
	            //break;
	
				var splitCheckPerson = checkPerson.split('|');
				var emp_no = splitCheckPerson[0];
				var user_name = splitCheckPerson[1];
				var dept_name = splitCheckPerson[2];
	
	            if(emp_no_list=="" || emp_no_list==null)
	            {
	                emp_no_list += emp_no;
	                user_name_list += user_name+ " ("+dept_name+")";
		
	            } else {
	                emp_no_list += ","+emp_no;
	                user_name_list += "\n"+user_name+ " ("+dept_name+")";
	            }
	
	        }
	    }
    }

    if(!someSelected)
    {
        var msg = "Please make a selection.";
        alert(msg);
        return;
    }	

    parent.window.opener.document.designReceiveForm.processPerson.value = emp_no_list;
    parent.window.opener.document.designReceiveForm.processPersonInfo.value = user_name_list;    
    parent.window.opener.focus();
    window.close();
}
</script>


</html>