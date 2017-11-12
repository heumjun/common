<%--  
§DESCRIPTION: EP 품목 기준정보, 부품표준서 메뉴 선택 화면 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoItemTopInclude.jsp
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%
    String loginID = request.getParameter("loginID");
%>

<HTML>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<link rel=StyleSheet HREF="include/stx.css" type=text/css title=STX>

<style type="text/css">
.menu			{font-family:"굴림체"; font-Size: 9pt; color: #363636;  font-weight: bold; text-decoration: none;}
.menu a:link		{font-family:"굴림체"; color: #363636; text-decoration: font-weight: bold; none;}
.menu a:visited	{font-family:"굴림체"; color: #363636; text-decoration: font-weight: bold; none;}
.menu a:active	{font-family:"굴림체"; color: #363636; text-decoration: font-weight: bold; none;}
.menu a:hover	{font-family:"굴림체"; color: #363636; text-decoration: font-weight: bold; none;}

</style>


<script>

function OpenUrl(url){
    var loginID = document.frmInfoItemTopInclude.loginID.value;
    url += "loginID="+loginID;
	parent.document.location.href = url;
}

function OpenUrl_1(url){
    var loginID = document.frmInfoItemTopInclude.loginID.value;
    url += "loginID="+loginID;


	var nwidth = 1030;
	var nheight = 820;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes";

	window.open(url,"",sProperties);
}

function OpenUrl_2(url){
    var loginID = document.frmInfoItemTopInclude.loginID.value;
    url += "loginID="+loginID;


	var nwidth = 1530;
	var nheight = 850;
	var LeftPosition = (screen.availWidth-nwidth)/2;
	var TopPosition = (screen.availHeight-nheight)/2;

	var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight+",scrollbars=yes,resizable=yes,directories=yes";

	window.open(url,"",sProperties);
}

</script>
<BODY leftmargin="0" marginwidth="0" topmargin="0" marginheight="0" >

<form name="frmInfoItemTopInclude" method="post" >
<table border=0 width="100%" >
    <tr>
      <td>&nbsp;</td>
      	
      <td>
        
          <table width="98%" cellpadding="0" cellspacing="0" border="0">
          <tr height="25">
          	<td width="5"><img src="images/menu_left.gif"></td>
          	<td width="100%" bgcolor="#d9d9d9" align="right" style="padding-right:20"">
          		<table cellpadding="2" cellspacing="0" border="0">
          		<tr>
          			<td class="menu" Onclick="OpenUrl_2('/ematrix/emsDbMain.tbc?')" >
          				<a href="#"><img src="images/menu_icon.gif" align="absmiddle"> 기자재 통합 기준정보 관리</a>
          			</td> 
          			<td style="padding:0,15,0,15"><img src="images/menu_line.gif"></td>          		
          			<td class="menu" Onclick="OpenUrl_1('/ematrix/tbcItemTrans.tbc?')" >
          				<a href="#"><img src="images/menu_icon.gif" align="absmiddle"> 기준정보 등록요청</a>
          			</td>      
          			<td style="padding:0,15,0,15"><img src="images/menu_line.gif"></td>    		
          			<td class="menu" Onclick="OpenUrl('stxEPItemViewFrame.jsp?')" >
          				<a href="#"><img src="images/menu_icon.gif" align="absmiddle"> 부품표준서</a>
          			</td>
          			<td style="padding:0,15,0,15"><img src="images/menu_line.gif"></td>
          			<td class="menu" Onclick="OpenUrl('stxEPInfoViewFrame.jsp?')">
          				<a href="#"><img src="images/menu_icon.gif" align="absmiddle"> 품목분류표</a>
          			</td>
          			<td style="padding:0,15,0,15"><img src="images/menu_line.gif"></td>
          			<td class="menu" Onclick="OpenUrl('stxEPDocumentViewFrame.jsp?')">
          				<a href="#"><img src="images/menu_icon.gif" align="absmiddle"> 양식지&메뉴얼</a>
          			</td>
          		</tr>
          		</table>
          	</td>
          	<td width="5"><img src="images/menu_right.gif"></td>
          </tr>
          </table>
        
                	
			<!-- 타이틀 바 끝 -->
      </td>
	</tr>
</table>
<input type="hidden" name="loginID" value="<%=loginID%>">
</form>

</BODY>
</HTML>

