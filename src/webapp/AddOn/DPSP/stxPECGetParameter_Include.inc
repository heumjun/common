<%--  
§DESCRIPTION: request에서 parameter 값 추출. matrix emxGetParameter 처리 위함.
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECGetParameter_Include.inc
§CHANGING HISTORY: 
§    2015-01-22: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>


<%--========================== JSP =========================================--%>
<%!
	public String emxGetParameter(HttpServletRequest request, String paramName)
	{
		String paramValue = "";
		paramValue = request.getParameter(paramName);
		return paramValue;		
	}	
%>