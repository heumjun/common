<%--  
§DESCRIPTION: 도면 출도대장(Hard Copy) 항목 등록 - 원인코드 선택 화면
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPHardCopyDwgCreate_CodeSelect.jsp
§CHANGING HISTORY: 
§    2010-03-30: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!

    private ArrayList getDeployReasonCodeList() throws Exception
    {
		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultArrayList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("SDPS");

			StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT B.KEY,                                   ");
            queryStr.append("       B.VALUE,                                 ");
            queryStr.append("       (SELECT COUNT(1)                         ");
            queryStr.append("         FROM PLM_CODE_TBL                      ");
            queryStr.append("        WHERE CATEGORY = 'ECO_CODE'             ");
            queryStr.append("          AND SUBSTR(KEY, 1, 1) = B.KEY         ");
            queryStr.append("       ) AS CNT,                                ");
            queryStr.append("       A.KEY,                                   ");
            queryStr.append("       A.VALUE                                  ");
            queryStr.append("  FROM PLM_CODE_TBL A,                          ");
            queryStr.append("       PLM_CODE_TBL B                           ");
            queryStr.append(" WHERE A.CATEGORY = 'ECO_CODE'                  ");
            queryStr.append("   AND B.CATEGORY = 'ECO_GROUP'                 ");
            queryStr.append("   AND SUBSTR(A.KEY, 1, 1) = B.KEY              ");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				java.util.HashMap resultMap = new java.util.HashMap();
                resultMap.put("GRP_KEY", rset.getString(1));
                resultMap.put("GRP_VALUE", rset.getString(2));
                resultMap.put("CODE_CNT", rset.getString(3));
                resultMap.put("CODE_KEY", rset.getString(4));
                resultMap.put("CODE_VALUE", rset.getString(5));
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
    String errStr = "";

    ArrayList reasonCodeList = null;
    try {
        reasonCodeList = getDeployReasonCodeList();
    }
    catch (Exception e) {
        errStr = e.toString();
    }
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>Category of Change</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>


<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5; padding:10px;10px;10px;10px;">
<form name="DPDwgRevHistoryForm">

<table width="100%" cellSpacing="0" cellpadding="6" border="1" align="center">
    <tr height="20">
        <td class="td_standardBold" style="background-color:#336699;" width="40"><font color="#ffffff">Group</font></td>
        <td class="td_standardBold" style="background-color:#336699;" width="70"><font color="#ffffff">Desc.</font></td>
        <td class="td_standardBold" style="background-color:#336699;"><font color="#ffffff">Category of Change</font></td>
    </tr>
    
    <%
    String currentGrpKey = "";

    for (int i = 0; i < reasonCodeList.size(); i++) 
    {
        java.util.Map map = (java.util.Map)reasonCodeList.get(i);

        String grpKey = (String)map.get("GRP_KEY");
        String grpValue = (String)map.get("GRP_VALUE");
        String codeCnt = (String)map.get("CODE_CNT");
        String codeKey = (String)map.get("CODE_KEY");
        String codeValue = (String)map.get("CODE_VALUE");
        %>

        <tr style="background-color:#ffffff;">

        <%
        if (!currentGrpKey.equals(grpKey)) 
        {
            currentGrpKey = grpKey;
            %>
                <td class="td_standard" rowspan="<%=codeCnt%>">
                    <%=grpKey%>
                </td>
                <td class="td_standard" rowspan="<%=codeCnt%>">
                    <%=grpValue%>
                </td>
            <%
        }
        %>

            <td class="td_standardLeft" style="padding:1px 2px 1px 2px;"
                onmouseover="this.style.backgroundColor='yellow';" onmouseout="this.style.backgroundColor='#ffffff';">
                <input type="radio" name="" value="" onclick="window.returnValue='<%=codeKey%>'; window.close();" />
                <%=codeKey%> (<%=codeValue%>)
            </td>
        </tr>
        <%
    }
    %>

</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">
</script>


</html>