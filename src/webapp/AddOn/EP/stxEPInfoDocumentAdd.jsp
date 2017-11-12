<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - 메뉴얼 및 양식지 추가 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoDocumentAdd.jsp
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    String loginID = request.getParameter("loginID");
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
    function saveDocument()
    {
        var frm = document.frmDocumentAdd;
        if(confirm("저장하시겠습니까?"))
        {
            frm.encoding = "multipart/form-data";
            frm.target = "_self";
            frm.action = "stxEPInfoDocumentAddSave.jsp";
            frm.submit();    
        }
    }
</script>

<html>
<body style="background-color:#f5f5f5">
<form name="frmDocumentAdd"  method="post">

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>

    <table width="500" cellspacing="1" cellpadding="0">
       <tr height="30">
           <td class="title_2"><br><font color="darkblue"><img src="images/sheet_dot.gif"><b>&nbsp;문서 - 추가</b></font> </td>
       </tr>
    </table>
    <br>

    <table width="500" cellspacing="1" cellpadding="0" bgcolor="#cccccc">
        <tr height="35" align="center">
            <td class="title_3" style="background-color:#336699;" width="60"><font color="#ffffff">파일</font></td>
            <td>
                <input type="file" name="fileName" style="width:400" onKeyDown="return false;"> 
            </td>
        </tr>
    </table>

    <br>
    <table width="500" cellspacing="1" cellpadding="1">
        <tr height="45">
            <td style="text-align:right;">
                <hr>
                <input type="button" value="저장" class="button_simple_1" onclick="javascript:saveDocument();"> &nbsp;&nbsp;&nbsp;
                <input type="button" value="닫기" class="button_simple_1" onclick="javascript:window.close();">&nbsp;
            </td>
        </tr>
    </table>
</td>
</tr>
</table>
<input type="hidden" name="loginID" value="<%=loginID%>">
</form>
</body>
</html>