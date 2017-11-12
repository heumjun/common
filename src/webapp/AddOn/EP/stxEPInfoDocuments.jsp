<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 리스트 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocuments.jsp
--%>

<%@ page import = "com.stx.common.interfaces.DBConnect" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%!
    private ArrayList searchdocumentList() throws Exception
    {
		java.sql.Connection conn = null;
        java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

		ArrayList resultMapList = new ArrayList();        

		try {
			conn = DBConnect.getDBConnection("ERP_APPS");

			StringBuffer queryStr = new StringBuffer();

			queryStr.append("SELECT *                                            \n");
            queryStr.append("  FROM STX_PLM_EP_INFO_DOCUMENTS                    \n");
            queryStr.append(" WHERE DISABLE_DATE IS NULL                         \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next()) {
				HashMap resultMap = new HashMap();
				resultMap.put("FILE_ID", rset.getString(1));
				resultMap.put("FILE_NAME", rset.getString(2));
                resultMap.put("ENTITY_NAME", rset.getString(3));
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
    String loginID = request.getParameter("loginID");
    
    ArrayList documentList = searchdocumentList();

    // ADMIN일 경우 문서 추가 및 삭제 기능 사용
    boolean adminFlag = false;
    if("209452".equals(loginID) || "211524".equals(loginID) || "207026".equals(loginID) || "209495".equals(loginID) || "206285".equals(loginID))
    {
        adminFlag = true;
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
.button_simple_1
{
	font-size: 10pt;
	height: 26px;
	width: 50px;
}

</style>

<script language="javascript">
function go_Add()
{
     //var loginID = parent.INFO_FRAME_TOP.frmInfoItemTopInclude.loginID.value;

    var loginID = document.frmDocument.loginID.value;
    var url = "stxEPInfoDocumentAdd.jsp?";
    url += "loginID="+loginID;
    
	window.open(url,"","width=520px,height=250px,top=300,left=400,resizable=no,scrollbars=auto,status=no");    
}

function go_Delete()
{
    var someSelected = false;
    var frm = document.frmDocument;

    for(var i = 1; i < frm.elements.length; i++)
    {    
        if(frm.elements[i].type == "radio" && frm.elements[i].checked == true)
        {
            someSelected = true;
            frm.select_value.value = frm.elements[i].value;
            break;
        }
    }
    if(!someSelected)
    {
        alert("선택된 항목이 없습니다.");
        return;
    }

    if(confirm("삭제하시겠습니까?"))
    {
        frm.action = "stxEPInfoDocumentDelete.jsp";
        frm.submit();    
    }


}

// 문서 열기 및 다운로드
function fileView(file_id)
{
    var attURL = "stxEPInfoDocumentView.jsp?";
    attURL += "file_id="+file_id;

    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';

    //window.showModalDialog(attURL,"",sProperties);
    window.open(attURL,"",sProperties);
    //window.open(attURL,"","width=400, height=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no");

}
</script>

<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
<form name="frmDocument" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="2%">&nbsp;</td>
        <td align="left">        
            <table width="100%" cellpadding="0" cellspacing="0" border="0" >
                <tr>
                    <td height="4" colspan="2"></td>
                </tr>
                <tr height="30"> 
                    <td>
                        <table width="810" cellpadding="0" cellspacing="0" border="0" >
                            <tr>                        
                                <td class="title_2" align="left"><img src="images/bullet01.gif" style="vertical-align:middle;">&nbsp;양식지 & 메뉴얼</td>
                                <td align="right">
                                <% if(adminFlag) { %>
                                    <input class="button_simple_1" type="button" value="추가" onClick="go_Add();">&nbsp;
                                    <input class="button_simple_1" type="button" value="삭제" onClick="go_Delete();">   
                                <% } %>
                                </td>
                            </tr>
                        </table>
                    </td>
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
        <td width="3%">&nbsp;</td>
        <td>
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
                <tr class="title_7" align="center" height="28" bgcolor="#e5e5e5">
                    <td width="10%">&nbsp;</td>
                    <td width="10%">NO.</td>
                    <td width="70%">문서명</td>
                    <td width="10%">파일</td>
                </tr>
            </table>
           <div style="width:847; height:380; overflow-y:auto; position:relative;">
            <table width="830" border="0" cellpadding="0" cellspacing="1" bgcolor="#cccccc" style="table-layout:fixed;">
            <%
            for(int i=0; i<documentList.size(); i++)
            {
               // sRowClass = ( ((i+1) % 2 ) == 0  ? "tr_blue" : "tr_white");
                Map documentListMap = (Map)documentList.get(i);
                String file_id = (String)documentListMap.get("FILE_ID");
                String file_name = (String)documentListMap.get("FILE_NAME");
                String entity_name = (String)documentListMap.get("ENTITY_NAME");


            %>
                <tr class="title_8" height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
                    <td width="10%" align="center"><input type="radio" name="file_id" value="<%=file_id%>"></td>
                    <td width="10%" align="center"><%=i+1%></td>
                    <td width="70%">&nbsp;&nbsp;<%=file_name%></td>
                    <td width="10%" align="center"><img src="images/icon_file.gif" border="0" style="cursor:hand;vertical-align:middle;" onclick="fileView('<%=file_id%>')"></td>
                 </tr>
            <%
            }
            %>
            </table>
            </div>
        </td>
    </tr>
</table>
<input type="hidden" name="select_value">
<input type="hidden" name="loginID" value="<%=loginID%>">
</form>
</body>
</html>
