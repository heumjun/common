<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 구매요청/비용성/BSI/GSI 항목 엑셀 다운로드
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemListExcelDownload.jsp
--%>

<%  // 웹페이지의 내용을 엑셀로 변환하기 위한 구문
	//response.setContentType("application/vnd.ms-excel; charset=UTF-8");
	response.setContentType("application/msexcel");
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 
%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
    private ArrayList searchItemList(String select_type) throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT *                                        \n");
            queryStr.append("  FROM STX_STD_EP_ITEM_LIST_V                   \n");
            queryStr.append(" WHERE 1=1                                      \n");
            queryStr.append("AND ITEM_TYPE='" + select_type + "'             \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("PART_NO", rset.getString(1));
				resultMap.put("DESCRIPTION", rset.getString(2));
                resultMap.put("CATALOG", rset.getString(3));
                resultMap.put("CATEGORY", rset.getString(4));
				resultMap.put("ITEM_TYPE", rset.getString(5));
                resultMap.put("TEMPLATE", rset.getString(6));

				resultMapList.add(resultMap);
			}
		}
		finally {
			if (rset != null) rset.close();
			if (stmt != null) stmt.close();
			DBConnect.closeConnection(conn);
		}

		return resultMapList;
	}
%>

<%--========================== HTML HEAD ===================================--%>

<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<%
    String select_type = request.getParameter("select_type");

    if(select_type==null || "".equals(select_type) || "PRDP".equals(select_type))
    {
        select_type = "PRDP";  // Default value
    }

    ArrayList itemList = searchItemList(select_type);
    
%>
    

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body>
<form name="frmCatalog" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr><td>&nbsp;</td></tr>
    <tr><td>품목 분류표 - 구매요청/비용성품목/BSI/GSI</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td>
            <table width="100%" border="1" cellpadding="0" cellspacing="1">
                <tr align="center" style="color:#ffffff" bgcolor="#006699">
                    <td>CATALOG</td>
                    <td>CATEGORY</td>
                    <td>ITEM CODE</td>
                    <td>DESCRIPTION</td>
                    <td>TEMPLATE</td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="1">
            <%
            for(int i=0; i<itemList.size(); i++)
            {
                Map itemListMap = (Map)itemList.get(i);
                String part_no = (String)itemListMap.get("PART_NO");
                String description = (String)itemListMap.get("DESCRIPTION");
                String catalog = (String)itemListMap.get("CATALOG");
                String category = (String)itemListMap.get("CATEGORY");
                String template = (String)itemListMap.get("TEMPLATE");  

            %>
                <tr class="title_8" height="24" bgcolor="#ffffff">
                    <td align="center" style = "mso-number-format:\@"><%=catalog%></td>
                    <td align="center"><%=category%></td>
                    <td align="center"><%=part_no%></td>
                    <td>&nbsp;&nbsp;<%=description%></td>
                    <td align="center"><%=template%></td>
                 </tr>
            <%
            }
            %>
            </table>

        </td>
    </tr>
</table>
                  
</body>
</html>