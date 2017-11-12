<%--  
§DESCRIPTION: 설계계획시스템에 허용된 권한자가 아닌 경우 표시되는 페이지
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDP_LoginFailed2.jsp
§CHANGING HISTORY: 
§    2009-05-19: Initiative
--%>


<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>



<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<body>
	<table width="100%" cellSpacing="1" cellpadding="20" border="0">
		<tr>
			<td class="td_standard" style="text-align:left;color:#ff0000;font-size:12pt;font-weight:bold;">
				지금은 테스트 기간으로 관리자(ADMIN.)만 사용 가능합니다.<br><br>
				테스트 완료 후에는 관리자 외 파트장 권한자에게 오픈될 예정입니다.
			</td>
		</tr>
	</table>
</body>

</html>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<script language="javascript">
    document.onkeydown = keydownHandler;
</script>

