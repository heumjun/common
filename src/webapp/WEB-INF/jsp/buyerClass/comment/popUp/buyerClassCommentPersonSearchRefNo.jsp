<%--  
§DESCRIPTION: 수신문서 접수 및 실적 관리 - 실적 등록 : 발송문서(Ref No) 조회 및 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentPersonSearchRefNo.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.text.*"%>


<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>


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

	String workUser = StringUtil.setEmptyExt(request.getParameter("workUser"));
	String project = StringUtil.setEmptyExt(request.getParameter("project"));
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
<!-- <link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css> -->
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<STYLE> 
.tr_blue {background-color:#f0f8ff}
.tr_white {background-color:#ffffff}
</STYLE> 

<head>
<title>발송문서 선택</title>
</head>

<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body>
	<form name="frmSearchRefNo">
		<div class="subtitle">
			발송문서 선택
		</div>
		<table class="searchArea conSearch">
		   <tr height="30">
			   <td>
					<div class="button endbox">
						<input type="button" value="확인" class="btn_blue2" onclick="javascript:selectRefNo();">&nbsp;&nbsp;
                		<input type="button" value="닫기" class="btn_blue2" onclick="javascript:window.close();">
					</div>
			   </td>
		   </tr>
		</table>
		<div id="list_head" style="overflow-y: scroll; overflow-x: hidden;">
			<table class="insertArea">
				<tr>
					<th width="10%">선택</th>
					<th width="20%">REF NO</th>
					<th width="45%">제 목</th>
					<th width="10%">타 입</th>
					<th width="15%">생성일</th>
				</tr>
			</table>
		</div>
		<div id="list_body" style="height:370px;overflow-y:scroll;overflow-x:hidden;">
			<table class="insertArea">
				<%            
	            for(int i=0; i<searchRefNoList.size(); i++)
	            {
	                Map searchRefNoListMap = (Map)searchRefNoList.get(i);
	                String owner_class_type = (String)searchRefNoListMap.get("OWNER_CLASS_TYPE");
	                String ref_no = (String)searchRefNoListMap.get("REF_NO");                
					String subject = (String)searchRefNoListMap.get("SUBJECT"); 
	                String send_receive_date = (String)searchRefNoListMap.get("SEND_RECEIVE_DATE");
	
	            %>
	                <tr height="25">
	                    <td width="10%"><input type="radio" name="ref_no" value="<%=ref_no%>"></td>                    
	                    <td width="20%"><%=ref_no%></td>
						<td width="45%"><%=subject%></td> 
	                    <td width="10%"><%=owner_class_type%></td>
	                    <td width="15%"><%=send_receive_date%></td>
						
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