<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 설계 접수 : 처리담당자 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentReceiveSearchProcessPerson.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>


<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>


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
			queryStr.append(" UNION                                                                              \n");
            queryStr.append("SELECT BB.EMP_NO, BB.USER_NAME, BB.DEPT_CODE, BB.DEPT_NAME, BB.POSITION_NAME        \n");
            queryStr.append("  FROM                                                                              \n");
            queryStr.append("  (   SELECT DEPT_CODE                                                              \n");
            queryStr.append("        FROM STX_COM_INSA_DEPT                                                      \n");
            queryStr.append("       WHERE DEPT_CODE =                                                            \n");
            queryStr.append("                       ( SELECT DEPT.DEPT_CODE                                      \n");
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
			queryStr.append(" ORDER BY USER_NAME, DEPT_CODE                                                 \n");
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

	String workUser = StringUtil.setEmptyExt(request.getParameter("workUser"));
	String selectType = StringUtil.setEmptyExt(request.getParameter("selectType"));
	String processUser = StringUtil.setEmptyExt(request.getParameter("processUser"));	
	
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
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<STYLE> 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body>

<div class="subtitle">
	Comment 처리 담당자 지정
</div>
<table class="searchArea conSearch">
   <tr height="30">
	   <td>
			<div class="button endbox">
				<input type="button" value="확인" class="btn_blue" onclick="javascript:savePerson();">
                <input type="button" value="닫기" class="btn_blue" onclick="javascript:window.close();">
			</div>
	   </td>
   </tr>
</table>
<form name="frmSearchProcessPerson">
<div id="list_head" style="overflow-y:scroll;overflow-x:hidden;">
	<table class="insertArea">
		<tr>
		    <th width="10%">선택</th>            
			<th width="15%">사 번</th>
			<th width="15%">성 명</th>
			<th width="15%">직 급</th>
			<th width="45%">부 서</th>
	    </tr>
	</table>
</div>
<div id="list_body" style="height:370px;overflow-y:scroll;overflow-x:hidden;border:1px solid #c3c3c3;">
	<table class="insertArea">          
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
	<tr>
	    <td width="10%">
	    	<%if(selectType.equals("Single")){ %>
			<input type="radio" name="radioUser" value="<%=keyUserInfo%>" <%if(emp_no.equals(processUser)){%>checked="checked"<%} %>>
			<%}else{ %>
			<input type="checkbox" name="checkbox<%=i%>" value="<%=keyUserInfo%>">
			<%} %>
		</td>
		<td width="15%"><input type="text" readonly style="border:0px;width:0px"><%=emp_no%></td>
		<td width="15%"><input type="text" readonly style="border:0px;width:0px"><%=user_name%></td>
		<td width="15%"><input type="text" readonly style="border:0px;width:0px"><%=position_name%></td>
		<td width="45%"><input type="text" readonly style="border:0px;width:0px"><%=dept_name%></td> 
	</tr>
	<%
	}
	%>
	</table>
</div>

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
				break;
			}	
		}
		var splitCheckPerson = checkPerson.split('|');
		var emp_no = splitCheckPerson[0];
		var user_name = splitCheckPerson[1];
		var dept_name = splitCheckPerson[2];
		
        emp_no_list = emp_no;
        user_name_list = user_name+ " ("+dept_name+")";
            
	} else {
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