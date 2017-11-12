<%--  
§DESCRIPTION: EP 부품표준서 조회 - 전체보기
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPItemViewSearch.jsp
--%>

<%@ page import = "com.stx.common.util.*"%>
<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<script type="text/javascript" src="scripts/stxAjax.js"></script>
<script language="javascript" src="scripts/SecurePM3AX2.js"></script>
<script language="javascript" src="http://dwgprint.stxons.com/dsv/DSViewerAX.js"></script>
<script type="text/javascript">
	SecurePM3AXControl();
	DSViewerAXControl();
</script>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!
private ArrayList searchItemViewList(String loginID, String sItemName) throws Exception
{
    ArrayList resultMapList = new ArrayList();
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
        sql.append("           AND (S_CATALOG_CODE   like ? OR S_CATALOG_DESC   like ? )                                        \n");
        sql.append("      GROUP BY SV.L_CATALOG_CODE                                           \n");
        sql.append("              ,SV.M_CATALOG_CODE                                           \n");
        sql.append("              ,SV.S_CATALOG_CODE                                           \n");
        sql.append("              ,SV.S_CATALOG_DESC                                           \n");
        sql.append("              ,SV.ITEM_CATALOG_GROUP_ID                                    \n");
        sql.append("       )                           SP                                      \n");
        sql.append("      ,STX_DWG_PART_LIST_INDEX     SDPL                                    \n");
        sql.append(" WHERE SP.ITEM_CATALOG_GROUP_ID = SDPL.ITEM_CATALOG_GROUP_ID               \n");
        sql.append("   AND SP.PART_REV_NO           = SDPL.PART_REV_NO                         \n");
        
        query = sql.toString();
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, loginID);
        pstmt.setString(2, "%"+sItemName+"%");
        pstmt.setString(3, "%"+sItemName+"%");
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
            resultMapList.add(map);
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
    return resultMapList;
}
%>
<%
    String sItemName = request.getParameter("sItemName");
    String loginID = request.getParameter("loginID");

    ArrayList itemViewList = new ArrayList();

    if(sItemName != null)
    {
        itemViewList = searchItemViewList(loginID, sItemName);
    }

    if("".equals(sItemName) || sItemName == null)
    {
        sItemName = "";
    }

%>

<style type="text/css">
tr,td {font-family:"돋움","verdana","arial"; font-size: 8pt ; text-decoration: none; color:#1A1A1A;}
.header {font-family:"돋움","verdana","arial"; font-size: 13pt ; text-decoration: none; color:#1A1A1A; font-weight : bold;}
.even {background-color:#eeeeee}
.odd {background-color:#ffffff}
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

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmSearch" method="post">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr height="4">
            <td>&nbsp;</td>
        </tr>
        <tr height="25">
            <td width="3%">&nbsp</td>
            <td class="title_3" width="150"><img src="images/sheet_dot.gif">&nbsp;CATALOG명 검색
            <td class="title_6" width="200"><input type="text" name="sItemName" value="<%=sItemName%>" size="25" onKeyUp="javascript:this.value=this.value.toUpperCase();"></td>
            <td width="150" align="right" ><input type="button" name="buttonSearch" value='조 회' class="button_simple" onClick="actionSearch();"></td>
            <td>&nbsp;</td>
        </tr>
        <tr height="4">
            <td>&nbsp;</td>
        </tr>
    </table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                    <tr align="center" height="28" bgcolor="#e5e5e5">
                        <td class="title_6" width="15%">Catalog</td>
                        <td class="title_6" width="73%">Name</td>
                        <td class="title_6" width="12%">File</td>
                    </tr>
                </table>

               <div style="width:847; height:380; overflow-y:auto; position:relative;">
               <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                <%
                    String sRowClass = "odd";
                    int iOddEven = 1;
                    for(int i=0; i< itemViewList.size(); i++)
                    {
                        iOddEven++;
                        sRowClass = ((iOddEven % 2) == 0 ? "even" : "odd");
                        Map itemViewListMap = (Map)itemViewList.get(i);
                %>
                        <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                            <td width="15%" align="center">
                                <%=itemViewListMap.get("catalog_S")%>
                            </td>
                            <td width="73%" align="left">
                                &nbsp;&nbsp;
                                <%=itemViewListMap.get("name_S")%>
                            </td>
                            <td width="12%" align="center" 
                                onMouseOver="this.style.cursor='hand'"
                                onClick="go_pdfView('<%=itemViewListMap.get("view_flag")%>','<%=itemViewListMap.get("PART_SEQ_ID")%>','<%=itemViewListMap.get("item_catalog_group_id")%>');">
                                <img src="images/pdf_icon.gif" border="0">
                            </td>
                        </tr> 
                <%
                    }
                    iOddEven++;
                    sRowClass = ((iOddEven % 2) == 0 ? "even" : "odd");
                %>
               </table>
               </div>
            </td>
        </tr>
	</table>
    <input type="hidden" name="loginID" value="<%=loginID%>">
</form>
</body>
</html>

<script language="javascript" type="text/javascript">

function actionSearch()
{
 /*   if(frmSearch.sItemName.value == "" || frmSearch.sItemName.value == null)
    {
        alert("검색할 Catalog 명을 입력해주세요.");
        return;
    }
*/
    frmSearch.action = "stxEPItemViewSearch.jsp";
    frmSearch.method = "post";
    frmSearch.submit();
}

    
    function go_pdfView(view_flag,PART_SEQ_ID,item_catalog_group_id)
    {
    	DSViewerAXCtl.Language = 'AUTO';
    	if(view_flag && view_flag == 'Y')
    	{
    		var objAjax = new stxAjax("stxViewDocXMLAjax.jsp?loginID=<%=loginID%>&p_PART_SEQ_ID="+PART_SEQ_ID+"&p_ITEM_CATALOG_GROUP_ID="+item_catalog_group_id);
			var vReturn = objAjax.executeSync();
			
			DSViewerAXCtl.ClearOptions(); //기존에 설정된 값들은 제거한다.
			 
			DSViewerAXCtl.SetOption( "XML", vReturn ); //XML 값 설정
		 
			DSViewerAXCtl.SetOption( "MnuOpenFiles", "enable" ); // "Open Files" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuOpenXml", "enable" );   // "Open XML" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuDocInfo", "enable" );   // "Document Information" 메뉴 제어( enable, diable )
		 
			DSViewerAXCtl.SetOption( "MnuPrint", "enable" );     // "Print" 메뉴 제어 ( enable, diable )
			DSViewerAXCtl.SetOption( "MaxCopies", "3" );         // 최대 복사 매수 설정 ( -1이면 복사매수 제한 없음 )
		 
			DSViewerAXCtl.SetOption( "MnuBookmark", "enable" );  // "Bookmark" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuFileList", "enable" );  // "File List" 메뉴 제어( enable, diable )
			DSViewerAXCtl.SetOption( "MnuThumbnail", "enable" ); // "Thumbnail" 메뉴 제어( enable, diable ) 
		 
			DSViewerAXCtl.ShowViewer();
    	} else {
    		alert("도면 View 권한이 없습니다.");
    	}
    }

</script>
