<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적 등록 : 발송문서(Ref No) 조회 및 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignPersonSearchRefNo.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.text.*"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
	// 처리자가 생성한 발송 문서(REF NO) 리스트를 추출한다.
    private ArrayList searchRefNo(String workUser, String project, String fromDate, String toDate) throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT OWNER_CLASS_TYPE,                                                                 \n");
			queryStr.append("       REF_NO,                                                                           \n");
			queryStr.append("       SUBJECT,                                                                          \n");
			queryStr.append("       TO_CHAR(SEND_RECEIVE_DATE,'YYYY-MM-DD')  AS SEND_RECEIVE_DATE                     \n");
            queryStr.append("  FROM stx_oc_document_list                                                              \n");  
			queryStr.append(" WHERE 1=1                                                                               \n");
			queryStr.append("   AND SEND_RECEIVE_DATE >= TO_DATE('" + fromDate + "','YYYY-MM-DD')                     \n");
			queryStr.append("   AND SEND_RECEIVE_DATE <= (TO_DATE('" + toDate + "','YYYY-MM-DD')+1)                   \n");
			queryStr.append("   AND SEND_RECEIVE_TYPE='send'                                                          \n");
			queryStr.append("   AND SENDER_NO='" + workUser + "'                                                      \n");
			queryStr.append("   AND PROJECT='" + project +"'                                                          \n");
			queryStr.append(" ORDER BY  REF_NO                                                                        \n");
  
            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
				HashMap resultMap = new HashMap();
				resultMap.put("OWNER_CLASS_TYPE", rset.getString(1) == null ? "" : rset.getString(1));
                resultMap.put("REF_NO", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("SUBJECT", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("SEND_RECEIVE_DATE", rset.getString(4) == null ? "" : rset.getString(4));
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
	String project = StringUtil.setEmptyExt(emxGetParameter(request, "project"));
	//System.out.println("workUser = "+workUser);

	Calendar cal_today = Calendar.getInstance(); 
	Calendar cal_fromday = Calendar.getInstance(); 
	cal_today.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR));
	cal_fromday.set(Calendar.DAY_OF_YEAR, cal_fromday.get(Calendar.DAY_OF_YEAR) - 30);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  

	String toDate = sdf.format(cal_today.getTime());  // today
	String fromDate = sdf.format(cal_fromday.getTime());  // today - 30day

    String errStr = "";

    ArrayList searchRefNoList = null;
    try {
        searchRefNoList = searchRefNo(workUser, project, fromDate, toDate);
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
<form name="frmSearchRefNo">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="670" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td><br><font color="darkblue"><b>&nbsp;&nbsp; 발송문서 선택</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="670" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="25">
            <td class="td_standardBold" style="background-color:#336699;" width="10%">&nbsp;</td>            
            <td class="td_standardBold" style="background-color:#336699;" width="20%"><font color="#ffffff">REF NO</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="45%"><font color="#ffffff">제 목</font></td>
            <td class="td_standardBold" style="background-color:#336699;" width="10%"><font color="#ffffff">타 입</font></td>
			<td class="td_standardBold" style="background-color:#336699;" width="15%"><font color="#ffffff">생성일</font></td>
        </tr>
    </table>

        <div STYLE="width:670; height:300; overflow-y:auto; position:relative; background-color:#ffffff">
        <table width="670" cellSpacing="1" cellpadding="0" border="0" align="center" bgcolor="#cccccc">            
            <%            
            for(int i=0; i<searchRefNoList.size(); i++)
            {
                Map searchRefNoListMap = (Map)searchRefNoList.get(i);
                String owner_class_type = (String)searchRefNoListMap.get("OWNER_CLASS_TYPE");
                String ref_no = (String)searchRefNoListMap.get("REF_NO");                
				String subject = (String)searchRefNoListMap.get("SUBJECT"); 
                String send_receive_date = (String)searchRefNoListMap.get("SEND_RECEIVE_DATE");

            %>
                <tr height="25" bgcolor="#f5f5f5">
                    <td class="td_standard" width="10%"><input type="radio" name="ref_no" value="<%=ref_no%>"></td>                    
                    <td class="td_standard" width="20%"><%=ref_no%></td>
					<td class="td_standard" width="45%"><%=subject%></td> 
                    <td class="td_standard" width="10%"><%=owner_class_type%></td>
                    <td class="td_standard" width="15%"><%=send_receive_date%></td>
					
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
                <input type="button" value="확인" class="button_simple" onclick="javascript:selectRefNo();"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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

function selectRefNo()
{
    var someSelected = false;
    var mainForm = document.frmSearchRefNo;
    var checkRefNo = "";

    for(var i = 0; i < mainForm.elements.length; i++)
    {    
        if(mainForm.elements[i].type == "radio" && mainForm.elements[i].checked == true)
        {
            someSelected = true;
            checkRefNo = mainForm.elements[i].value;
            break;
        }
    }

    if(!someSelected)
    {
        var msg = "Please make a selection.";
        alert(msg);
        return;
    }

    opener.document.designProcessForm.send_ref_no.value = checkRefNo;
    window.close();
}
</script>


</html>