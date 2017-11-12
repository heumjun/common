<html>

<%
	//String languageStr 		= request.getHeader("Accept-Language");
	String buyerClassCommentResultManagementHead = "";
	String buyerClassCommentResultManagementBody	= "";

	buyerClassCommentResultManagementHead = "stxPECBuyerClassCommentResultManagementHead.jsp";
	buyerClassCommentResultManagementBody = "stxPECBuyerClassCommentResultManagementBody.jsp";

	
	String framesetRows = "27%,73%";
	

	%>

	<frameset rows="<%=framesetRows%>" framespacing="0" frameborder="no" border="0">
		<frame name="COMMENT_RESULT_MANAGEMENT_HEAD" src="<%=buyerClassCommentResultManagementHead%>" marginheight="10" marginwidth="10" border="0" scrolling="auto"/>
		<frame name="COMMENT_RESULT_MANAGEMENT_BODY" src="<%=buyerClassCommentResultManagementBody%>" marginheight="10" marginwidth="10" border="0" scrolling="auto"/>
	</frameset>
</html>
