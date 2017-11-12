<%--  
§DESCRIPTION: EP 부품표준서 조회 - 대분류 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECSearchStandardItemDrawingLevel_1.jsp
--%>


<%@ page import = "com.stx.common.util.*"%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>
<%

    ArrayList resultList = new ArrayList();
   // List<HashMap>  resultList = new ArrayList();
  // ArrayList<HashMap<String, String>> resultList = new ArrayList<HashMap<String, String>>();
        
    Connection conn           = null;
    conn = DBConnect.getDBConnection("ERP_APPS");

    PreparedStatement pstmt = null;
    ResultSet rset = null; 
    StringBuffer sql = new StringBuffer();
    String query = "";

    try{
        sql.append("SELECT *                                 \n");
        sql.append("  FROM STX_DWG_PART_LIST_CATEGORY_L_V    \n");
        sql.append(" ORDER BY L_CATALOG_CODE ASC             \n");

        query = sql.toString();
        pstmt = conn.prepareStatement(query);   

        rset = pstmt.executeQuery();

        while(rset.next())
        {
            HashMap map = new HashMap();
            map.put("catalog_L", rset.getString(1));
            map.put("name_L", rset.getString(2));
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
.header {font-family:"굴림체"; font-Size: 13pt; font-weight: bold; text-decoration: none; color:#1A1A1A;}
.tableborder {border-width:"1px"; border-color:blue;}
.even {background-color:#eeeeee}
.odd {background-color:#ffffff}

A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
</style>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmLevel_1" method="post" >
<TABLE border="0" cellpadding="0" cellspacing="0" width="100%" height="7%">
    <tr>
        <td class="header" align="center">대분류</td>
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
                        <td align="left">&nbsp;
                            <a href="javascript:go_level_2('<%=resultMap.get("catalog_L")%>')"><%=resultMap.get("name_L")%></a>
                        </td>                        
                    </tr>                     
            <%
                }
                iOddEven++;
                sRowClass = ((iOddEven % 2) == 0 ? "even" : "odd");
            %>
                <tr class="<%=sRowClass%>" height="*">
                    <td>&nbsp;</td>
                </tr>             
            </table>
        </td>
    </tr>

</table>
</form>
</body>
</html>

<script language="javascript">

    function go_level_2(catalog_L)
    {         
        var url = "stxEPItemViewLevel_2.jsp?catalog_L="+catalog_L;
        parent.FRAME_LEVEL_2.location.href = url;
    }

</script>