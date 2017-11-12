<%--  
§DESCRIPTION: 공정 지연현황 조회 - 호선 선택 창
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPProgressDeviationView_ProjectSelect.jsp
§CHANGING HISTORY: 
§    2009-05-25: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ include file = "stxPECGetParameter_Include.inc" %>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>
<%
    String projectNo = StringUtil.setEmptyExt(emxGetParameter(request, "projectNo"));
    String dwgCode = StringUtil.setEmptyExt(emxGetParameter(request, "dwgCode"));
    String isEditable = StringUtil.setEmptyExt(emxGetParameter(request, "isEditable"));
    String designerId = StringUtil.setEmptyExt(emxGetParameter(request, "designerId"));
    String sDESC = "";
    
    ArrayList mlDesc = getPLM_ACTIVITY_DEVIATIONDesc(projectNo,dwgCode);
    if(mlDesc.size()>0)
    {
    	Map map = (Map)mlDesc.get(0);
    	sDESC = (String)map.get("DELAYREASON_DESC");
    }
    
    System.out.println(sDESC);
%>


<%--========================== HTML HEAD ===================================--%>
<html>
<head>
    <title>특기사항</title>
</head>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>

<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>

<%--========================== HTML BODY ===================================--%>
<body style="background-color:#e5e5e5">
<form name=submitForm>

<table width="100%" cellSpacing="6" border="1" align="center">
	<tr>
		<td>
			<textarea name="DELAYREASON_DESC" rows="15" cols="50" <%if (isEditable == null || !isEditable.equals("true")) {%>readonly<%} %> ><%=sDESC%></textarea>
		</td>
	</tr>
	<tr align='right'>
		<td>
			<%if (isEditable != null && isEditable.equals("true")) {%><input type="button" value="저장" onClick="saveDesc()"><%} %> 
		</td>
	</tr>
</table>

</form>
</body>

<%--========================== SCRIPT ======================================--%>
<script language="javascript">

    function saveDesc() 
    {
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();
		
		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=saveDELAYREASON_DESC&projectNo=<%=projectNo%>&dwgCode=<%=dwgCode%>&designerId=<%=designerId%>&DELAYREASON_DESC="+submitForm.DELAYREASON_DESC.value.encodeURI(), false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;

                if (resultMsg != null)resultMsg = resultMsg.trim();
                
                if(resultMsg && resultMsg != '')
		        {
		        	alert(resultMsg);
		        	window.returnValue = 'error';
		        } else {
		        	alert("수정되었습니다.")
		        	window.returnValue = 'ok';
		        }
        		window.close();
                
            } else alert(resultMsg);
        } else alert(resultMsg);
    }
</script>
</html>