<%--  
��DESCRIPTION: request���� parameter �� ����. matrix emxGetParameter ó�� ����. 
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECGetParameter_Include.inc
��CHANGING HISTORY: 
��    2015-01-22: Initiative
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