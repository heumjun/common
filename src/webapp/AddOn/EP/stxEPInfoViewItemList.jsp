<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 구매요청/비용성/BSI/GSI 항목 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemList.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

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

<%
    String select_type = request.getParameter("select_type");

    String checked_select_type_PRDP = "";
    String checked_select_type_C_PRDP = "";
    String checked_select_type_GS = "";
    String checked_select_type_BS = "";

    if(select_type==null || "".equals(select_type) || "PRDP".equals(select_type))
    {
        checked_select_type_PRDP = "checked";
        select_type = "PRDP";  // Default value
    } else if("C_PRDP".equals(select_type)) {
        checked_select_type_C_PRDP = "checked";
    } else if("GS".equals(select_type)) {
        checked_select_type_GS = "checked";
    } else if("BS".equals(select_type)) {
        checked_select_type_BS = "checked";
    }

    ArrayList itemList = searchItemList(select_type);
    
%>

<style type="text/css">
A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"굴림체"; font-Size: 11pt;}
.title_6			{font-family:"굴림체"; font-Size: 10pt;}
.title_7			{font-family:"굴림체"; font-Size: 9pt;}
.title_8			{font-family:"굴림체"; font-Size: 8pt;}
.button_simple
{
	font-size: 10pt;
	height: 26px;
	width: 70px;
}

</style>

<script language="javascript">
function actionSearch()
{
    frmItemList.action = "stxEPInfoViewItemList.jsp";
    frmItemList.method = "post";
    frmItemList.submit();
}

// 엑셀 다운로드
function excelDownload()
{
   frmItemList.action="stxEPInfoViewItemListExcelDownload.jsp";
   frmItemList.target="_self";
   frmItemList.submit();

}

</script>


<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmItemList" method="post" >
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
                    <td class="title_2" align="left"><img src="images/bullet01.gif" style="vertical-align:middle;">&nbsp;품목 분류표 - 구매요청/비용성품목/BSI/GSI</td>
                </tr>
                <tr>
                    <td height="4" colspan="2"></td>
                </tr>
            </table>
        </td>
     </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr height="25">
        <td width="3%">&nbsp</td>
        <td class="title_3" width="500"><img src="images/sheet_dot.gif">&nbsp;조회항목&nbsp;&nbsp;&nbsp;
            <input type="radio" name="select_type" value="PRDP" <%=checked_select_type_PRDP%>>구매요청
            <input type="radio" name="select_type" value="C_PRDP" <%=checked_select_type_C_PRDP%>>비용성            
            <input type="radio" name="select_type" value="BS" <%=checked_select_type_BS%>>BSI
            <input type="radio" name="select_type" value="GS" <%=checked_select_type_GS%>>GSI
        </td>
        <td width="70" align="right" ><input type="button" name="buttonSearch" value='조 회' class="button_simple" onClick="actionSearch();"></td>
        <td width="230" align="right">
            <input type="button" name="buttonReport" value='Excel' class="button_simple" onclick="excelDownload();">
        </td>
                <td>&nbsp;</td>
    </tr>

    <tr height="4">
        <td>&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="2%" colspan="10">&nbsp;</td>
        <td>
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                <tr class="title_7" align="center" height="28" bgcolor="#e5e5e5">
                    <td width="10%">CATALOG</td>
                    <td width="10%">CATEGORY</td>
                    <td width="20%">ITEM CODE</td>
                    <td width="40%">DESCRIPTION</td>
                    <td width="20%">TEMPLATE</td>
                </tr>
            </table>
           <div style="width:847; height:350; overflow-y:auto; position:relative;">
            <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
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
                <tr class="title_8" height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                    <td width="10%" align="center"><%=catalog%></td>
                    <td width="10%" align="center"><%=category%></td>
                    <td width="20%" align="center"><%=part_no%></td>
                    <td width="40%">&nbsp;<%=description%></td>
                    <td width="20%" align="center"><%=template%></td>
                 </tr>
            <%
            }
            %>
            </table>
            </div>
        </td>
    </tr>
</table>
                  
</body>
</html>