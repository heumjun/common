<%--  
¡×DESCRIPTION: EP Ç°¸ñ ±âÁØÁ¤º¸ Á¶È¸ - Ä«Å»·Î±× ¸®½ºÆ® Á¶È¸
¡×AUTHOR (MODIFIER): Kang seonjung
¡×FILENAME: stxEPInfoViewCategory.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!
    private ArrayList searchCategoryList() throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT *                                            \n");
            queryStr.append("  FROM STX_STD_EP_CATEGORY_LIST_V                   \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("CATEGORY_CODE", rset.getString(1));
				resultMap.put("CATEGORY_DESC", rset.getString(2));
                resultMap.put("TEMPLATE_NAME", rset.getString(3));
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

<%
    ArrayList categoryList = searchCategoryList();
   
%>

<style type="text/css">
A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
.title_1			{font-family:"±¼¸²Ã¼"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"±¼¸²Ã¼"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"±¼¸²Ã¼"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"±¼¸²Ã¼"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"±¼¸²Ã¼"; font-Size: 11pt;}
.title_6			{font-family:"±¼¸²Ã¼"; font-Size: 10pt;}
.title_7			{font-family:"±¼¸²Ã¼"; font-Size: 9pt;}
.title_8			{font-family:"±¼¸²Ã¼"; font-Size: 8pt;}
.button_simple
{
	font-size: 10pt;
	height: 26px;
	width: 70px;
}

</style>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmCategory" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="2%">&nbsp;</td>
        <td align="left">        
            <table width="100%" cellpadding="0" cellspacing="0" border="0" >
                <tr height="4" >
                    <td background="images/title_line.gif" colspan="2"></td>
                </tr>
                <tr>
                    <td height="4" colspan="2"></td>
                </tr>
                <tr height="25"> 
                    <td class="title_2" align="left"><img src="images/bullet01.gif" style="vertical-align:middle;">&nbsp;Ç°¸ñ ºÐ·ùÇ¥ - CATEGORY</td>
                </tr>
                <tr>
                    <td height="4" colspan="2"></td>
                </tr>
            </table>
        </td>
     </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="2%" colspan="3">&nbsp;</td>
        <td>
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                <tr class="title_7" align="center" height="28" bgcolor="#e5e5e5">
                    <td width="10%">CATEGORY</td>
                    <td width="40%">TEMPLATE</td>
                    <td width="50%">MEANING</td>
                </tr>
            </table>
           <div style="width:847; height:380; overflow-y:auto; position:relative;">
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
            <%
            for(int i=0; i<categoryList.size(); i++)
            {
                Map categoryListMap = (Map)categoryList.get(i);
                String category_code = (String)categoryListMap.get("CATEGORY_CODE");
                String template_name = (String)categoryListMap.get("TEMPLATE_NAME");
                String category_desc = (String)categoryListMap.get("CATEGORY_DESC");

            %>
                <tr class="title_8" height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                    <td width="10%" align="center"><%=category_code%></td>
                    <td width="40%">&nbsp;&nbsp;<%=template_name%></td>
                    <td width="50%">&nbsp;&nbsp;<%=category_desc%></td>
                 </tr>
            <%
            }
            %>
            </table>
            </div>
        </td>
    </tr>
</table>