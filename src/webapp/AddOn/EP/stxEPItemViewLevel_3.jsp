<%--  
§DESCRIPTION: EP 부품표준서 조회 - 소분류(부품표준서 정보)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECSearchStandardItemDrawingLevel_3.jsp
--%>

<%@ page import = "com.stx.common.util.*"%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>
<%
    String catalog_L =request.getParameter("catalog_L");  
    String catalog_M =request.getParameter("catalog_M");  
    String loginID = request.getParameter("loginID");

    if("".equals(catalog_L) || catalog_L == null)
    {
        catalog_L = "1";
    }
    if("".equals(catalog_M) || catalog_M == null)
    {
        catalog_M = "1";
    }    

    ArrayList resultList = new ArrayList();
    Connection conn           = null;
    conn = DBConnect.getDBConnection("ERP_APPS");

    PreparedStatement pstmt = null;
    ResultSet rset = null; 
    StringBuffer sql = new StringBuffer();
    String query = "";

    try{
        sql.append("SELECT SP.L_CATALOG_CODE                        AS L_CATALOG_CODE          \n");
        sql.append("      ,SP.M_CATALOG_CODE                        AS M_CATALOG_CODE          \n");
        sql.append("      ,SP.S_CATALOG_CODE                        AS S_CATALOG_CODE          \n");
        sql.append("      ,SP.S_CATALOG_DESC                        AS S_CATALOG_DESC          \n");
        sql.append("      ,SP.ITEM_CATALOG_GROUP_ID                 AS ITEM_CATALOG_GROUP_ID   \n");
        sql.append("      ,SDPL.FILE_NAME                           AS FILE_NAME               \n");
        sql.append("      ,STX_DWG_ITEM_URL_F(SP.S_CATALOG_CODE, SDPL.FILE_NAME) AS FILE_URL   \n");
        sql.append("      ,NVL((SELECT 'Y'                                                     \n");
        sql.append("              FROM STX_DWG_PART_DISTRIBUTION   SDPD                        \n");
        sql.append("                  ,STX_DWG_PART_DEPT_MANAGER   SDPDM                       \n");
        sql.append("                  ,STX_DWG_PART_DEPT_MAPPING   SDPDD                       \n");
        sql.append("                  ,STX_COM_INSA_USER           SCIU                        \n");
        sql.append("             WHERE SDPL.ITEM_CATALOG_GROUP_ID = SDPD.ITEM_CATALOG_GROUP_ID \n");
        sql.append("               AND SDPD.ENABLE_FLAG           = 'Y'                        \n");
        sql.append("               AND SDPD.DWG_APPL_DEPT_ID      = SDPDM.DEPT_ID              \n");
        sql.append("               AND SDPDM.DEPT_ID              = SDPDD.DEPT_ID              \n");
        sql.append("               AND SDPDD.DEPT_CODE            = SCIU.DEPT_CODE             \n");
        sql.append("               AND SCIU.EMP_NO                = ?                          \n");
        sql.append("       ),'N')                                   AS VIEW_FLAG               \n");
        sql.append("      ,SDPL.PART_SEQ_ID                         AS PART_SEQ_ID             \n");
        sql.append("  FROM (                                                                   \n");
        sql.append("        SELECT SV.L_CATALOG_CODE                AS L_CATALOG_CODE          \n");
        sql.append("              ,SV.M_CATALOG_CODE                AS M_CATALOG_CODE          \n");
        sql.append("              ,SV.S_CATALOG_CODE                AS S_CATALOG_CODE          \n");
        sql.append("              ,SV.S_CATALOG_DESC                AS S_CATALOG_DESC          \n");
        sql.append("              ,SV.ITEM_CATALOG_GROUP_ID         AS ITEM_CATALOG_GROUP_ID   \n");
        sql.append("              ,MAX(SDP.PART_REV_NO)             AS PART_REV_NO             \n");
        sql.append("          FROM STX_DWG_PART_LIST_CATEGORY_S_V   SV                         \n");
        sql.append("              ,STX_DWG_PART_LIST_INDEX          SDP                        \n");
        sql.append("         WHERE SV.ITEM_CATALOG_GROUP_ID = SDP.ITEM_CATALOG_GROUP_ID        \n");
        sql.append("           AND SDP.CONFIRM_FLAG = 'Y'                                      \n");
        sql.append("           AND L_CATALOG_CODE   = ?                                        \n");
        sql.append("           AND M_CATALOG_CODE   = ?                                        \n");
        sql.append("      GROUP BY SV.L_CATALOG_CODE                                           \n");
        sql.append("              ,SV.M_CATALOG_CODE                                           \n");
        sql.append("              ,SV.S_CATALOG_CODE                                           \n");
        sql.append("              ,SV.S_CATALOG_DESC                                           \n");
        sql.append("              ,SV.ITEM_CATALOG_GROUP_ID                                    \n");
        sql.append("       )                           SP                                      \n");
        sql.append("      ,STX_DWG_PART_LIST_INDEX     SDPL                                    \n");
        sql.append(" WHERE SP.ITEM_CATALOG_GROUP_ID = SDPL.ITEM_CATALOG_GROUP_ID               \n");
        sql.append("   AND SP.PART_REV_NO           = SDPL.PART_REV_NO                         \n");
        sql.append(" ORDER BY SP.S_CATALOG_CODE                                                \n");


        query = sql.toString();
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, loginID);
        pstmt.setString(2, catalog_L);
        pstmt.setString(3, catalog_M);
        rset = pstmt.executeQuery();

        while(rset.next())
        {
            HashMap map = new HashMap();
            map.put("catalog_L", rset.getString(1));
            map.put("catalog_M", rset.getString(2));
            map.put("catalog_S", rset.getString(3));
            map.put("name_S", rset.getString(4));
            map.put("item_catalog_group_id", rset.getString(5));
            map.put("file_name", rset.getString(6));
            map.put("file_url", rset.getString(7));
            map.put("view_flag", rset.getString(8));
            map.put("PART_SEQ_ID", rset.getString(9));
            resultList.add(map);
        }
    } catch( Exception ex ) {
        ex.printStackTrace();
    }finally{
        try {
            if ( rset != null ) rset.close();
            if ( pstmt != null ) pstmt.close();
            DBConnect.closeConnection( conn );
        } catch( Exception ex ) { }
    }
    
    
%>

<style type="text/css">
tr,td {font-family:"돋움","verdana","arial"; font-size: 8pt ; text-decoration: none; color:#1A1A1A;}
.header {font-family:"돋움","verdana","arial"; font-size: 13pt ; text-decoration: none; color:#1A1A1A; font-weight : bold;}
.even {background-color:#eeeeee}
.odd {background-color:#ffffff}

A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
</style>

<html>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmLevel_3" method="post" >
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" height="7%">
    <tr>
        <td class="header" align="center">소분류</td>
    </tr>
</table>
<table border="0" cellpadding="0" cellspacing="2" width="100%" height="92%" bgcolor="#336699">
    <tr>
        <td>
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="2" bgcolor="white">                  

            <%
                String sRowClass = "odd";
                int iOddEven = 1;
                for(int i=0; i< resultList.size(); i++)
                {
                    iOddEven++;
                    sRowClass = ((iOddEven % 2) == 0 ? "even" : "odd");
                    Map resultMap = (Map)resultList.get(i);
            %>
                    <tr class="<%=sRowClass%>" height="24">

                        <td width="10%" align="center" 
                            onMouseOver="this.style.cursor='hand'"
                            onClick="hiddenFrame.go_pdfView('<%=loginID%>','<%=resultMap.get("view_flag")%>','<%=resultMap.get("PART_SEQ_ID")%>','<%=resultMap.get("item_catalog_group_id")%>');">
                            <img src="images/pdf_icon.gif" border="0">
                        </td>
                        <td width="16%" align="center">
                            <%=resultMap.get("catalog_S")%>
                        </td>
                        <td width="74%" align="left">
                            &nbsp;
                            <%=resultMap.get("name_S")%>
                        </td>
                    </tr> 
            <%
                }
                iOddEven++;
                sRowClass = ((iOddEven % 2) == 0 ? "even" : "odd");
            %>                                   

                <tr class="<%=sRowClass%>" height="*">
                    <td colspan="3">&nbsp;</td>
                </tr>                      
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
<iframe id="hiddenFrame" name="hiddenFrame" src="stxDSView.jsp" style="display:none"></iframe>
