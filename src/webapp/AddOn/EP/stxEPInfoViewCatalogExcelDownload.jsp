<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 카탈로그 리스트 엑셀 다운로드 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewCatalogExcelDownload.jsp
--%>

<%@ page contentType="application/vnd.ms-excel;charset=euc-kr" %> 
<%  // 웹페이지의 내용을 엑셀로 변환하기 위한 구문
	//response.setContentType("application/msexcel");
	response.setHeader("Content-Disposition", "attachment; filename=ExcelDownload.xls"); 
	response.setHeader("Content-Description", "JSP Generated Data"); 

%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>


<% request.setCharacterEncoding("euc-kr"); %>


<%--========================== JSP =========================================--%>
<%!
    // Catalog 엑셀 Export 시 추출 data
	private ArrayList searchCatalogList(String sort_type, String catalog_name) throws Exception
	{
        java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT CATEGORY_CODE,                      \n");
			queryStr.append("       CATALOG_CODE,                       \n");
			queryStr.append("       ITEM_LIST_CODE,                     \n");
			queryStr.append("       ITEM_LIST_DESC,                     \n");
			queryStr.append("       L_CATALOG_CODE,                     \n");
			queryStr.append("       L_CATALOG_DESC,                     \n");
			queryStr.append("       M_CATALOG_CODE,                     \n");
			queryStr.append("       M_CATALOG_DESC,                     \n");
			queryStr.append("       S_CATALOG_CODE,                     \n");
			queryStr.append("       S_CATALOG_DESC,                     \n");
			queryStr.append("       UOM_CODE,                           \n");
			queryStr.append("       ELE_NAME_1,                         \n");
			queryStr.append("       ELE_NAME_2,                         \n");
			queryStr.append("       ELE_NAME_3,                         \n");
			queryStr.append("       ELE_NAME_4,                         \n");
			queryStr.append("       ELE_NAME_5,                         \n");
			queryStr.append("       ELE_NAME_6,                         \n");
			queryStr.append("       ELE_NAME_7,                         \n");
			queryStr.append("       ELE_NAME_8,                         \n");
			queryStr.append("       ELE_NAME_9,                         \n");
			queryStr.append("       ELE_NAME_10,                        \n");
			queryStr.append("       ELE_NAME_11,                        \n");
			queryStr.append("       ELE_NAME_12,                        \n");
			queryStr.append("       ELE_NAME_13,                        \n");
			queryStr.append("       ELE_NAME_14,                        \n");
			queryStr.append("       ELE_NAME_15,                        \n");
			queryStr.append("       DISABLE_CODE,                       \n");
			queryStr.append("       SORT_TYPE,                          \n");
			queryStr.append("       FULL_LEAD_TIME,                     \n");
			queryStr.append("       SP_FULL_LEAD_TIME,                  \n");
			queryStr.append("       MRP_PLANNING_DESC,                  \n");
			queryStr.append("       MRP_PLANNING_CODE,                  \n");
			queryStr.append("       SP_MRP_PLANNING_DESC,               \n");
			queryStr.append("       SP_MRP_PLANNING_CODE,               \n");
			queryStr.append("       DWG_FLAG                            \n");
            queryStr.append("  FROM STX_STD_EP_LIST_V                   \n");
            queryStr.append(" WHERE 1=1                                 \n");

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
                resultMap.put("UOM_CODE", rset.getString(11) == null ? "" : rset.getString(11));
                resultMap.put("ELE_NAME_1", rset.getString(12) == null ? "" : rset.getString(12));
                resultMap.put("ELE_NAME_2", rset.getString(13) == null ? "" : rset.getString(13));
                resultMap.put("ELE_NAME_3", rset.getString(14) == null ? "" : rset.getString(14));
                resultMap.put("ELE_NAME_4", rset.getString(15) == null ? "" : rset.getString(15));
                resultMap.put("ELE_NAME_5", rset.getString(16) == null ? "" : rset.getString(16));
                resultMap.put("ELE_NAME_6", rset.getString(17) == null ? "" : rset.getString(17));
                resultMap.put("ELE_NAME_7", rset.getString(18) == null ? "" : rset.getString(18));
                resultMap.put("ELE_NAME_8", rset.getString(19) == null ? "" : rset.getString(19));
                resultMap.put("ELE_NAME_9", rset.getString(20) == null ? "" : rset.getString(20));
                resultMap.put("ELE_NAME_10", rset.getString(21) == null ? "" : rset.getString(21));
                resultMap.put("ELE_NAME_11", rset.getString(22) == null ? "" : rset.getString(22));
                resultMap.put("ELE_NAME_12", rset.getString(23) == null ? "" : rset.getString(23));
                resultMap.put("ELE_NAME_13", rset.getString(24) == null ? "" : rset.getString(24));
                resultMap.put("ELE_NAME_14", rset.getString(25) == null ? "" : rset.getString(25));
                resultMap.put("ELE_NAME_15", rset.getString(26) == null ? "" : rset.getString(26));
                resultMap.put("DISABLE_CODE", rset.getString(27) == null ? "" : rset.getString(27));
                resultMap.put("SORT_TYPE", rset.getString(28) == null ? "" : rset.getString(28));
                resultMap.put("FULL_LEAD_TIME", rset.getString(29) == null ? "" : rset.getString(29));
                resultMap.put("SP_FULL_LEAD_TIME", rset.getString(30) == null ? "" : rset.getString(30));
                resultMap.put("MRP_PLANNING_DESC", rset.getString(31) == null ? "" : rset.getString(31));
                resultMap.put("MRP_PLANNING_CODE", rset.getString(32) == null ? "" : rset.getString(32));
                resultMap.put("SP_MRP_PLANNING_DESC", rset.getString(33) == null ? "" : rset.getString(33));
                resultMap.put("SP_MRP_PLANNING_CODE", rset.getString(34) == null ? "" : rset.getString(34));                
                resultMap.put("DWG_FLAG", rset.getString(35) == null ? "" : rset.getString(35));

				resultMapList.add(resultMap);
			}
		}finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        //System.out.println("~~~ resultMapList = "+resultMapList);
        return resultMapList;
        
    }
%>

<%--========================== HTML HEAD ===================================--%>

<%--========================== SCRIPT ======================================--%>


<%--========================== HTML BODY ===================================--%>
<%
    String sort_type = request.getParameter("sort_type");
    String catalog_name = request.getParameter("catalog_name");


    if(sort_type==null || "".equals(sort_type))
    {
        sort_type = "S";  // Default value
    }

    if(catalog_name==null || "".equals(catalog_name))
        catalog_name = "";

    ArrayList catalogList = searchCatalogList(sort_type, catalog_name);
    
%>
    

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=euc-kr"/>
</head>
<body>
<form name="frmCatalog" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr><td>&nbsp;</td></tr>
    <tr><td>품목 분류표 - CATALOG</td></tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td>
            <table width="100%" border="1" cellpadding="0" cellspacing="1">
                <tr align="center" style="color:#ffffff" bgcolor="#006699">
                    <td>CATEGORY</td>
                    <td>CATALOG</td>
                    <td>CODE</td>
                    <td>ITEM구분</td>
                    <td>CODE</td>
                    <td>대분류</td>
                    <td>CODE</td>
                    <td>중분류</td>
                    <td>CODE</td>
                    <td>DESCRIPTION</td>
                    <td>도면연계</td>
                    <td>UOM</td>
                    <td>L/T</td>
                    <td>MRP</td>
                    <td>L/T(특수선)</td>
                    <td>MRP(특수선)</td>                    
                    <td>물성값1</td>
                    <td>물성값2</td>
                    <td>물성값3</td>
                    <td>물성값4</td>
                    <td>물성값5</td>
                    <td>물성값6</td>
                    <td>물성값7</td>
                    <td>물성값8</td>
                    <td>물성값9</td>
                    <td>물성값10</td>
                    <td>물성값11</td>
                    <td>물성값12</td>
                    <td>물성값13</td>
                    <td>물성값14</td>
                    <td>물성값15</td>
                </tr>
            </table>

            <table width="100%" border="1" cellpadding="0" cellspacing="1">
            <%
            for(int i=0; i<catalogList.size(); i++)
            {
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
                String uom_code = (String)catalogListMap.get("UOM_CODE");
                String ele_name_1 = (String)catalogListMap.get("ELE_NAME_1");
                String ele_name_2 = (String)catalogListMap.get("ELE_NAME_2");
                String ele_name_3 = (String)catalogListMap.get("ELE_NAME_3");
                String ele_name_4 = (String)catalogListMap.get("ELE_NAME_4");
                String ele_name_5 = (String)catalogListMap.get("ELE_NAME_5");
                String ele_name_6 = (String)catalogListMap.get("ELE_NAME_6");
                String ele_name_7 = (String)catalogListMap.get("ELE_NAME_7");
                String ele_name_8 = (String)catalogListMap.get("ELE_NAME_8");
                String ele_name_9 = (String)catalogListMap.get("ELE_NAME_9");
                String ele_name_10 = (String)catalogListMap.get("ELE_NAME_10");
                String ele_name_11 = (String)catalogListMap.get("ELE_NAME_11");
                String ele_name_12 = (String)catalogListMap.get("ELE_NAME_12");
                String ele_name_13 = (String)catalogListMap.get("ELE_NAME_13");
                String ele_name_14 = (String)catalogListMap.get("ELE_NAME_14");
                String ele_name_15 = (String)catalogListMap.get("ELE_NAME_15");
                String disable_code = (String)catalogListMap.get("DISABLE_CODE");
                //String sort_type = (String)catalogListMap.get("SORT_TYPE");
                String full_lead_time = (String)catalogListMap.get("FULL_LEAD_TIME");
                String sp_full_lead_time = (String)catalogListMap.get("SP_FULL_LEAD_TIME");
                String mrp_planning_desc = (String)catalogListMap.get("MRP_PLANNING_DESC");
                String mrp_planning_code = (String)catalogListMap.get("MRP_PLANNING_CODE");
                String sp_mrp_planning_desc = (String)catalogListMap.get("SP_MRP_PLANNING_DESC");
                String sp_mrp_planning_code = (String)catalogListMap.get("SP_MRP_PLANNING_CODE");                
                String dwg_flag = (String)catalogListMap.get("DWG_FLAG");
            %>
                <tr bgcolor="#ffffff">
                    <td align="center"><%=category_code%></td>
                    <td align="center" style = "mso-number-format:\@"><%=catalog_code%></td>
                    <td align="center"><%=item_list_code%></td>
                    <td>&nbsp;<%=item_list_desc%></td>
                    <td align="center" style = "mso-number-format:\@"><%=l_catalog_code%></td>
                    <td>&nbsp;<%=l_catalog_desc%></td>
                    <td align="center" style = "mso-number-format:\@"><%=m_catalog_code%></td>
                    <td>&nbsp;<%=m_catalog_desc%></td>
                    <td align="center" style = "mso-number-format:\@"><%=s_catalog_code%></td>
                    <td>&nbsp;<%=s_catalog_desc%></td>
                    <td align="center"><%=dwg_flag%></td>
                    <td>&nbsp;<%=uom_code%></td>
                    <td><%=full_lead_time%></td>
                    <td><%=mrp_planning_desc%></td>
                    <td align="center"><%=sp_full_lead_time%></td>
                    <td align="center"><%=sp_mrp_planning_desc%></td>
                    <td>&nbsp;<%=ele_name_1%></td>
                    <td>&nbsp;<%=ele_name_2%></td>
                    <td>&nbsp;<%=ele_name_3%></td>
                    <td>&nbsp;<%=ele_name_4%></td>
                    <td>&nbsp;<%=ele_name_5%></td>
                    <td>&nbsp;<%=ele_name_6%></td>
                    <td>&nbsp;<%=ele_name_7%></td>
                    <td>&nbsp;<%=ele_name_8%></td>
                    <td>&nbsp;<%=ele_name_9%></td>
                    <td>&nbsp;<%=ele_name_10%></td>
                    <td>&nbsp;<%=ele_name_11%></td>
                    <td>&nbsp;<%=ele_name_12%></td>
                    <td>&nbsp;<%=ele_name_13%></td>
                    <td>&nbsp;<%=ele_name_14%></td>
                    <td>&nbsp;<%=ele_name_15%></td>
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