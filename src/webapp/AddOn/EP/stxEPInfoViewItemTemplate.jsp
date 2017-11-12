<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - Template 리스트 조회
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemTemplate.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!
    // TEMPLATE 코드 추출
    private ArrayList searchItemTemplate() throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT *                                            \n");
            queryStr.append("  FROM STX_STD_EP_TEMPLATE_CODE_V                   \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("TEMPLATE_NAME", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("TEMPLATE_DESC", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("TEMPLATE_ID", rset.getString(3) == null ? "" : rset.getString(3));
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

    // 선택된 TEMPLATE의 세부 내용 추출
    private ArrayList searchItemTemplateCodeList(String template_name) throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT TEMPLATE_GROUP,TEMPLATE_CODE_NAME,TEMPLATE_CODE_VALUE  \n");
            queryStr.append("  FROM STX_STD_EP_ITEM_TEMPLATE_V                             \n");
            queryStr.append(" WHERE TEMPLATE_ID = "+template_name+"                        \n");

            System.out.println("~~ queryStr  : searchItemTemplateCodeList = "+queryStr.toString());

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("TEMPLATE_GROUP", rset.getString(1) == null ? "" : rset.getString(1));
				resultMap.put("TEMPLATE_CODE_NAME", rset.getString(2) == null ? "" : rset.getString(2));
                resultMap.put("TEMPLATE_CODE_VALUE", rset.getString(3) == null ? "" : rset.getString(3));
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
    String select_template_name = request.getParameter("template_name");
    if(select_template_name==null || "".equals(select_template_name))
    {
        select_template_name = "";
    }

    ArrayList itemTemplate = searchItemTemplate();
    ArrayList itemTemplateCodeList = new ArrayList();
    if(!"".equals(select_template_name))
    {
        itemTemplateCodeList = searchItemTemplateCodeList(select_template_name);
    }
    
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
    var template_value = frmTemplate.template_name.value;
    if(template_value=="")
    {
        alert("SELECT TEMPLATE !!!");
        return;
    }    

    frmTemplate.action = "stxEPInfoViewItemTemplate.jsp";
    frmTemplate.method = "post";
    frmTemplate.submit();
}
</script>


<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmTemplate" method="post" >
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
                    <td class="title_2" align="left"><img src="images/bullet01.gif" style="vertical-align:middle;">&nbsp;품목 분류표 - ITEM TEMPLATE</td>
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
        <td class="title_3" width="680"><img src="images/sheet_dot.gif">&nbsp;TEMPLATE&nbsp;&nbsp;&nbsp;
            <select name="template_name" style="width:530;">
                <option value="">&nbsp;</option>
                <%
                for (int i = 0; i < itemTemplate.size(); i++) {
                    Map itemTemplateMap = (Map)itemTemplate.get(i);
                    String template_name = (String)itemTemplateMap.get("TEMPLATE_NAME");
                    String template_desc = (String)itemTemplateMap.get("TEMPLATE_DESC");
                    String template_id = (String)itemTemplateMap.get("TEMPLATE_ID");
                    String templateStr = template_name + "&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;" + template_desc;
                    String selected = "";
                    if(template_id.equals(select_template_name)) selected = "selected";
                       
                    %>
                    <option value="<%=template_id%>" <%=selected%>><%=templateStr%></option>
                    <%
                }
                %>
            </select>
        
        </td>
        <td width="70" align="right" ><input type="button" name="buttonSearch" value='조 회' class="button_simple" onClick="actionSearch();"></td>
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
                    <td width="30%">GROUP</td>
                    <td width="40%">ATTRIBUTE</td>
                    <td width="30%">VALUE</td>
                </tr>
            </table>
           <div style="width:847; height:380; overflow-y:auto; position:relative;">
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
            <%
            for(int i=0; i<itemTemplateCodeList.size(); i++)
            {
                Map itemTemplateCodeListMap = (Map)itemTemplateCodeList.get(i);
                String template_group = (String)itemTemplateCodeListMap.get("TEMPLATE_GROUP");
                String template_code_name = (String)itemTemplateCodeListMap.get("TEMPLATE_CODE_NAME");
                String template_code_value = (String)itemTemplateCodeListMap.get("TEMPLATE_CODE_VALUE");

            %>
                <tr class="title_8" height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                    <td width="30%">&nbsp;&nbsp;<%=template_group%></td>
                    <td width="40%">&nbsp;&nbsp;<%=template_code_name%></td>
                    <td width="30%">&nbsp;&nbsp;<%=template_code_value%></td>
                 </tr>
            <%
            }
            %>
            </table>
            </div>
        </td>
    </tr>
</table>