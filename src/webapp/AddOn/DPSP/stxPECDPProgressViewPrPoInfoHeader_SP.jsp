<%--  
§DESCRIPTION: 공정 조회 Maker(Vendor) 도면 - PR, PO 세부 정보 View
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECDPProgressViewPrPoInfo_SP.jsp
§CHANGING HISTORY: 
§    2014-05-29: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include_SP.jspf" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

	// 해당 도면의 전체 PR 리스트 추출 (본PR, 추가 PR)
	private ArrayList getPrNoList(String projectNo,String drawingNo) throws Exception
	{
		if (StringUtil.isNullString(projectNo)) throw new Exception("Project No. is null");
        if (StringUtil.isNullString(drawingNo)) throw new Exception("drawingNo is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("ERP_APPS");
			//PRHA.AUTHORIZATION_STATUS AS AUTHORIZATION_STATUS
            StringBuffer strQuery = new StringBuffer();
            strQuery.append("SELECT SPED.PR_NO                                        \n"); 
            strQuery.append("      ,SPED.ORIGINAL_PR_FLAG                             \n"); 
            strQuery.append("      ,PRHA.AUTHORIZATION_STATUS                         \n"); 
            strQuery.append("  FROM STX_PO_EQUIPMENT_DP        SPED                   \n"); 
            strQuery.append("      ,PO_REQUISITION_HEADERS_ALL PRHA                   \n"); 
            strQuery.append(" WHERE SPED.PR_NO = PRHA.SEGMENT1                        \n");
            strQuery.append("   AND SPED.PROJECT_NUMBER   = '"+projectNo+"'           \n");
            strQuery.append("   AND SPED.DRAWING_NO       = '"+drawingNo+"'           \n");
            strQuery.append(" ORDER BY SPED.ORIGINAL_PR_FLAG DESC                     \n");
            strQuery.append("         ,SPED.PR_NO                                     \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(strQuery.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("PR_NO", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("ORIGINAL_PR_FLAG", rset.getString(2) == null ? "" : rset.getString(2));
				resultMap.put("AUTHORIZATION_STATUS", rset.getString(3) == null ? "" : rset.getString(3));
                resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }	
	
%>


<%--========================== JSP =========================================--%>
<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String drawingNo = StringUtil.setEmptyExt(emxGetParameter(request, "drawingNo")); 

    String errStr = "";

    ArrayList prNoList = new ArrayList();

    try {    	

	    prNoList = getPrNoList(projectNo, drawingNo);        // 해당 도면의 전체 PR 리스트 추출

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
<script language="javascript">

   // 20140527 Kang seonjung : 기자재 발주 관리 및 DP일정 통합관리 등록 PR, PO 세부 정보 view
	function searchPrPoInfo(prNo)
	{
        var urlStr = "stxPECDPProgressViewPrPoInfo_SP.jsp?projectNo=" + frm.projectNo.value;
        urlStr += "&drawingNo=" + frm.drawingNo.value;
        urlStr += "&prNo=" + prNo;
        
        parent.FRAME_MAIN.location = urlStr;
	} 
</script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#f5f5f5">
<form name="frm" method="post">


<table width="100%" height="50" border="0" cellpadding="0" cellspacing="0">
   <tr> 
	   <td>&nbsp;
	   </td>
   </tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="1" style="table-layout:fixed;" bgcolor="#cccccc">	       
   <tr height="40" bgcolor="#e5e5e5">
	   <td width="80" class="td_standardSmall">PR No.</td>
   </tr>
<%
for(int i=0; i<prNoList.size(); i++)
{
	Map prNoListMap = (Map)prNoList.get(i);
	String tempPR_NO = (String)prNoListMap.get("PR_NO");
	String tempORIGINAL_PR_FLAG = (String)prNoListMap.get("ORIGINAL_PR_FLAG");
	String tempAUTHORIZATION_STATUS = (String)prNoListMap.get("AUTHORIZATION_STATUS");			
	
	String original_pr_flag_desc = "";

	if("Y".equals(tempORIGINAL_PR_FLAG))
	{
		original_pr_flag_desc = "(본)";
	} else {
		original_pr_flag_desc = "(추)";
	}

	String pr_authorization_status_desc = "";
	String bgcolor = "";
	if("INCOMPLETE".equals(tempAUTHORIZATION_STATUS))
	{
		pr_authorization_status_desc = "("+"미완료"+")";
		bgcolor = "red";
	} else if("PRE-APPROVED".equals(tempAUTHORIZATION_STATUS))
	{
		pr_authorization_status_desc = "("+"사전승인"+")";
		bgcolor = "cyan";
	} else if("APPROVED".equals(tempAUTHORIZATION_STATUS))
	{
		pr_authorization_status_desc = "("+"승인됨"+")";
		bgcolor = "yellowgreen";
	} else if("CANCELLED".equals(tempAUTHORIZATION_STATUS))
	{
		pr_authorization_status_desc = "("+"취소"+")";
		bgcolor = "red";
	} else if("REJECTED".equals(tempAUTHORIZATION_STATUS))
	{
		pr_authorization_status_desc = "("+"거절"+")";
		bgcolor = "orange";
	} else {
		pr_authorization_status_desc = "";
	}

	if(!"Y".equals(tempORIGINAL_PR_FLAG) && "APPROVED".equals(tempAUTHORIZATION_STATUS))
	{
		bgcolor = "yellow";
	}
	%>
	<tr height="40">
		<td width="80" class="td_standardSmall" bgcolor="<%=bgcolor%>" style="cursor:hand;" onclick="searchPrPoInfo('<%=tempPR_NO%>');">
			<%=tempPR_NO%>&nbsp;&nbsp;<%=original_pr_flag_desc%><br><%=pr_authorization_status_desc%>
		</td>
	</tr>		           	
<%    
}
%>
</table>

<input type="hidden" name="projectNo" value="<%=projectNo%>">
<input type="hidden" name="drawingNo" value="<%=drawingNo%>">

</form>
</body>

</html>