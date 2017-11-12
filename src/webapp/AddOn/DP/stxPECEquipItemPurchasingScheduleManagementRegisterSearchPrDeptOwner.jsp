<%--  
§DESCRIPTION: 기자재 발주 관리 및 DP일정 통합관리 등록 견적기획 PR 발행 도면의 경우 담당 설계부서 인원 지정 화면
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECEquipItemPurchasingScheduleManagementRegisterSearchPrDeptOwner.jsp
§CHANGING HISTORY: 
§    2010-03-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.util.*" %>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

    private ArrayList searchPrDeptOwner(String drawingNo) throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT DEPT_NAME, EMP_NO, USER_NAME, POSITION_NAME                                \n");
            queryStr.append("  FROM STX_COM_INSA_USER@STXERP                                                   \n");
            queryStr.append(" WHERE DEPT_CODE IN (  SELECT DEPTCODE                                            \n");
            queryStr.append("                         FROM DCC_DEPTCODE                                        \n");
            queryStr.append("                        WHERE DWGDEPTCODE IN ( SELECT DWG_DEPT_CODE               \n");
            queryStr.append("                                                 FROM PLM_VENDOR_DWG_PR_INFO      \n");
            queryStr.append("                                                WHERE DWG_CODE='"+drawingNo+"')   \n");
            queryStr.append("                    )                                                             \n");
            queryStr.append("   AND DEL_DATE IS NULL                                                           \n");
            queryStr.append(" ORDER BY DEPT_NAME, EMP_NO                                                       \n");
           // System.out.println("queryStr = "+queryStr.toString());
  
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
                if ( rset.getString(2).startsWith("P") || rset.getString(2).startsWith("M")  ) continue;
				HashMap resultMap = new HashMap();
				resultMap.put("DEPT_NAME", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("EMP_NO", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("USER_NAME", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("POSITION_NAME", rset.getString(4) == null ? "" : rset.getString(4));
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

   // request.setCharacterEncoding("euc-kr"); 

    String index = emxGetParameter(request, "index");
    String drawingNo = emxGetParameter(request, "drawingNo");

    String errStr = "";

    ArrayList prDeptOwnerList = null;
    try {
        prDeptOwnerList = searchPrDeptOwner(drawingNo);
       // System.out.println("~~ prDeptOwnerList = "+prDeptOwnerList.toString());
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
<form name="frmSearchPrDeptOwner">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="670" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp; 견적 PR 발행 도면 설계부서 담당자 지정</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="670" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="10%">&nbsp;</td>
            <td class="td_standardBold" style="background-color:#336699;" width="45%"><font color="#ffffff">부 서</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">사 번</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">성 명</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">직 급</font></td>
        </tr>
    </table>

        <div STYLE="width:670; height:300; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="670" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%            
            for(int i=0; i<prDeptOwnerList.size(); i++)
            {
                Map prDeptOwnerMap = (Map)prDeptOwnerList.get(i);
                String dept_name = (String)prDeptOwnerMap.get("DEPT_NAME");
                String emp_no = (String)prDeptOwnerMap.get("EMP_NO");
                String user_name = (String)prDeptOwnerMap.get("USER_NAME");
                String position_name = (String)prDeptOwnerMap.get("POSITION_NAME"); 
            %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="10%"><input type="radio" name="emp_no" value="<%=emp_no%>"></td>
                    <td class="td_standard" width="45%"><%=dept_name%></td> 
                    <td class="td_standard" width="15%"><%=emp_no%></td>
                    <td class="td_standard" width="15%"><%=user_name%></td>
                    <td class="td_standard" width="15%"><%=position_name%></td>
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
<input type="hidden" name="index" value="<%=index%>">
</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

function savePerson()
{
    var someSelected = false;
    var mainForm = document.frmSearchPrDeptOwner;
    var index = mainForm.index.value;
    var checkPerson = ""

    for(var i = 1; i < mainForm.elements.length; i++)
    {    
        if(mainForm.elements[i].type == "radio" && mainForm.elements[i].checked == true)
        {
            someSelected = true;
            checkPerson = mainForm.elements[i].value;
            break;
        }
    }

    if(!someSelected)
    {
        var msg = "Please Make A Selection";
        alert(msg);
        return;
    }    
    parent.window.opener.document.frmEquipItemPurchasingManagementMain.elements['pr_dept_changeable_owner'+index].value = checkPerson;
    parent.window.opener.document.frmEquipItemPurchasingManagementMain.elements['pr_dept_changeable_ownerView'+index].value = checkPerson;    
    window.close();
}
</script>


</html>