<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 카탈로그 리스트 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewCatalog.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!
    private ArrayList searchCatalogList(String sort_type, String catalog_name) throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT CATEGORY_CODE,                     \n");
            queryStr.append("       CATALOG_CODE,                      \n");
            queryStr.append("       ITEM_LIST_CODE,                    \n");
            queryStr.append("       ITEM_LIST_DESC,                    \n");
            queryStr.append("       L_CATALOG_CODE,                    \n");
            queryStr.append("       L_CATALOG_DESC,                    \n");
            queryStr.append("       M_CATALOG_CODE,                    \n");
            queryStr.append("       M_CATALOG_DESC,                    \n");
            queryStr.append("       S_CATALOG_CODE,                    \n");
            queryStr.append("       S_CATALOG_DESC,                    \n");
            queryStr.append("       DWG_FLAG,                          \n");
            queryStr.append("       MRP_PLANNING_DESC,                 \n");
            queryStr.append("       SP_MRP_PLANNING_DESC               \n");
            queryStr.append("  FROM STX_STD_EP_LIST_V                  \n");
            queryStr.append(" WHERE 1=1                                \n");

            if(!"ALL".equals(sort_type))
            {
                queryStr.append("AND SORT_TYPE='" + sort_type + "'    \n");
            }

            if(!"".equals(catalog_name))
            {
                queryStr.append("AND ( L_CATALOG_DESC like '%" + catalog_name + "%'    \n");
                queryStr.append("   OR M_CATALOG_DESC like '%" + catalog_name + "%'    \n");
                queryStr.append("   OR S_CATALOG_DESC like '%" + catalog_name + "%'    \n");
                queryStr.append("   OR CATALOG_CODE like '%" + catalog_name + "%' )    \n");
            }


            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("CATEGORY_CODE", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("CATALOG_CODE", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("ITEM_LIST_CODE", rset.getString(3) == null ? "" : rset.getString(3));
                resultMap.put("ITEM_LIST_DESC", rset.getString(4) == null ? "" : rset.getString(4));
				resultMap.put("L_CATALOG_CODE", rset.getString(5) == null ? "" : rset.getString(5));
                resultMap.put("L_CATALOG_DESC", rset.getString(6) == null ? "" : rset.getString(6));
                resultMap.put("M_CATALOG_CODE", rset.getString(7) == null ? "" : rset.getString(7));
                resultMap.put("M_CATALOG_DESC", rset.getString(8) == null ? "" : rset.getString(8));
                resultMap.put("S_CATALOG_CODE", rset.getString(9) == null ? "" : rset.getString(9));
                resultMap.put("S_CATALOG_DESC", rset.getString(10) == null ? "" : rset.getString(10));
                resultMap.put("DWG_FLAG", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("MRP_PLANNING_DESC", rset.getString(12) == null ? "" : rset.getString(12));
                resultMap.put("SP_MRP_PLANNING_DESC", rset.getString(13) == null ? "" : rset.getString(13));
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
    String sort_type = request.getParameter("sort_type");
    String catalog_name = request.getParameter("catalog_name");

    String checked_sort_type_ALL = "";
    String checked_sort_type_V = "";
    String checked_sort_type_S = "";
    String checked_sort_type_M = "";
    String checked_sort_type_E = "";

    if(sort_type==null || "".equals(sort_type) || "S".equals(sort_type))
    {
        checked_sort_type_S = "checked";
        sort_type = "S";  // Default value
    } else if("ALL".equals(sort_type)) {
        checked_sort_type_ALL = "checked";
    } else if("V".equals(sort_type)) {
        checked_sort_type_V = "checked";
    } else if("M".equals(sort_type)) {
        checked_sort_type_M = "checked";
    } else if("E".equals(sort_type)) {
        checked_sort_type_E = "checked";
    }

    if(catalog_name==null || "".equals(catalog_name))
        catalog_name = "";

    ArrayList catalogList = searchCatalogList(sort_type, catalog_name);
    
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
    frmCatalog.action = "stxEPInfoViewCatalog.jsp";
    frmCatalog.method = "post";
    frmCatalog.submit();
}

// 엑셀 다운로드
function excelDownload()
{
   frmCatalog.action="stxEPInfoViewCatalogExcelDownload.jsp";
   frmCatalog.target="_self";
   frmCatalog.submit();

}
</script>


<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmCatalog" method="post" >
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
                    <td class="title_2" align="left"><img src="images/bullet01.gif" style="vertical-align:middle;">&nbsp;품목 분류표 - CATALOG</td>
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
        <td class="title_3" width="150"><img src="images/sheet_dot.gif">&nbsp;정렬항목
        <td class="title_6" width="500" colspan="2" >
            <input type="radio" name="sort_type" value="ALL" <%=checked_sort_type_ALL%>>ALL
            <input type="radio" name="sort_type" value="V" <%=checked_sort_type_V%>>VIRTUAL
            <input type="radio" name="sort_type" value="S" <%=checked_sort_type_S%>>일반호선자재
            <input type="radio" name="sort_type" value="M" <%=checked_sort_type_M%>>MRO
            <input type="radio" name="sort_type" value="E" <%=checked_sort_type_E%>>비용성품목
        </td>
        <td>&nbsp;</td>
    </tr>

    <tr height="25">
        <td width="3%">&nbsp</td>
        <td class="title_3" width="150"><img src="images/sheet_dot.gif">&nbsp;CATALOG명 검색
        <td class="title_6" width="200"><input type="text" name="catalog_name" value="<%=catalog_name%>" size="25" onKeyUp="javascript:this.value=this.value.toUpperCase();"></td>
        <td width="250" align="right" ><input type="button" name="buttonSearch" value='조 회' class="button_simple" onClick="actionSearch();"></td>
        <td width="230" align="right">
            <input type="button" name="buttonReport" value='Excel' class="button_simple" onclick="excelDownload();">
        </td>
        <td>&nbsp;</td>
    </tr>
    <tr height="4">
        <td>&nbsp;</td>
    </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="98%">
    <tr>
        <td width="2%" colspan="11">&nbsp;</td>
        <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                <tr class="title_7" align="center" height="28" bgcolor="#e5e5e5">
                    <td width="6%">CATALOG</td>
                    <td width="3%">CODE</td>
                    <td width="12%">ITEM 구분</td>
                    <td width="3%">CODE</td>
                    <td width="17%">대분류</td>
                    <td width="3%">CODE</td>
                    <td width="17%">중분류</td>
                    <td width="3%">CODE</td>
                    <td width="18%">DESCRIPTION</td>
                    <td width="4%">도면<BR>연계</td>
                    <td width="7%">MRP계획</td>
                    <td width="7%">MRP계획<BR>(특수선)</td>
                </tr>
            </table>
           <div style="width:101.7%; height:350; overflow-y:auto; position:relative;">
            <table width="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
            <%
            for(int i=0; i<catalogList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map catalogListMap = (Map)catalogList.get(i);
                String category_code = (String)catalogListMap.get("CATEGORY_CODE");
                String catalog_code = (String)catalogListMap.get("CATALOG_CODE");
                String item_list_code = (String)catalogListMap.get("ITEM_LIST_CODE");
                String item_list_desc = (String)catalogListMap.get("ITEM_LIST_DESC");
                String l_catalog_code = (String)catalogListMap.get("L_CATALOG_CODE");
                String l_catalog_desc = (String)catalogListMap.get("L_CATALOG_DESC");
                String m_catalog_code = (String)catalogListMap.get("M_CATALOG_CODE");
                String m_catalog_desc = (String)catalogListMap.get("M_CATALOG_DESC");
                String s_catalog_code = (String)catalogListMap.get("S_CATALOG_CODE");
                String s_catalog_desc = (String)catalogListMap.get("S_CATALOG_DESC");
                String dwg_flag = (String)catalogListMap.get("DWG_FLAG");
                String mrp_planning_desc = (String)catalogListMap.get("MRP_PLANNING_DESC");
                String sp_mrp_planning_desc = (String)catalogListMap.get("SP_MRP_PLANNING_DESC");

            %>
                <tr class="title_8" height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                    <td width="6%" align="center"><%=catalog_code%></td>
                    <td width="3%" align="center"><%=item_list_code%></td>
                    <td width="12%">&nbsp;<%=item_list_desc%></td>
                    <td width="3%" align="center"><%=l_catalog_code%></td>
                    <td width="17%">&nbsp;<%=l_catalog_desc%></td>
                    <td width="3%" align="center"><%=m_catalog_code%></td>
                    <td width="17%">&nbsp;<%=m_catalog_desc%></td>
                    <td width="3%" align="center"><%=s_catalog_code%></td>
                    <td width="18%">&nbsp;<%=s_catalog_desc%></td>
                    <td width="4%" align="center"><%=dwg_flag%></td>
                    <td width="7%">&nbsp;<%=mrp_planning_desc%></td>
                    <td width="7%">&nbsp;<%=sp_mrp_planning_desc%></td>

                 </tr>
            <%
            }
            %>
            </table>
            </div>
        </td>
    </tr>
</table>

<input type="hidden" name="sort_type" value="<%=sort_type%>">
<input type="hidden" name="catalog_name" value="<%=catalog_name%>">

</form>                 
</body>
</html>