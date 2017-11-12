<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 헤더 (리스트 조회 항목 선택)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewHeader.jsp
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    String loginID = request.getParameter("loginID");
%>
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
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
</style>

<body bgcolor="white" leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">

<form name="frm" method="post" >

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="2%">&nbsp;</td>
        <td align="left">        
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td height="5" colspan="2"></td>
                </tr>
                <tr height="30"> 
                    <td style="padding-left:0" valign="middle" width="12">
                        <img src="images/title_icon.gif">
                    </td>
                    <td class="title_1" style="padding-left:3" valign="middle">
                        &nbsp;STX조선해양 품목분류표                    
                    </td>
                </tr>
                <tr height="4" >
                    <td background="images/title_line.gif" colspan="2"></td>
                </tr>
                <tr>
                    <td height="5" colspan="2"></td>
                </tr>
            </table>
        </td>
     </tr>
</table>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr>
        <td width="5%">&nbsp;</td>
        <td width="90%">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td>  
                        <table width="100%" cellpadding="3" cellspacing="0" border="0">
                            <tr>
                                <td class="title_2" align="left" colspan="3"><img src="images/sheet_dot.gif">&nbsp;분류표 조회 </td>
                            </tr>
                            <tr class="title_6">
                                <td width="30%">&nbsp;&nbsp;<img src="images/menu_icon.gif" style="vertical-align:middle;"><a href="stxEPInfoViewCatalog.jsp" target="INFO_FRAME_MAIN">&nbsp;CATALOG</a></td>
                                <td width="30%">&nbsp;&nbsp;<img src="images/menu_icon.gif" style="vertical-align:middle;"><a href="stxEPInfoViewCategory.jsp" target="INFO_FRAME_MAIN">&nbsp;CATEGORY</td>
                                <td width="40%">&nbsp;</a></td>
                            </tr>
                            <tr class="title_6">
                                <td width="30%">&nbsp;&nbsp;<img src="images/menu_icon.gif" style="vertical-align:middle;"><a href="stxEPInfoViewItemType.jsp" target="INFO_FRAME_MAIN">&nbsp;TYPE</td>
                                <td width="30%">&nbsp;&nbsp;<img src="images/menu_icon.gif" style="vertical-align:middle;"><a href="stxEPInfoViewItemTemplate.jsp" target="INFO_FRAME_MAIN">&nbsp;TEMPLATE</td>
                                <td width="40%">&nbsp;</td>
                            </tr>
                            <tr class="title_6">
                                <td colspan="2">&nbsp;&nbsp;<img src="images/menu_icon.gif" style="vertical-align:middle;"><a href="stxEPInfoViewItemList.jsp" target="INFO_FRAME_MAIN">&nbsp;구매요청/비용성품목/BSI/GSI</td>
                                <td width="40%">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        <td>&nbsp;</td>
    </tr>
</table>

</body>
</html>