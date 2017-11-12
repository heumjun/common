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
				실행 권한이 없습니다.<br><br>
				권한 정의가 문제가 있으면 설계계획시스템(SDPS) 관리자 (기술기획팀-기술계획P) 에게 문의하십시오.
			</td>
		</tr>
	</table>
</body>

</html>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="stxPECDP_CommonScript_SP.js"></script>

<script language="javascript">
    document.onkeydown = keydownHandler;
</script>

