<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%!
%>
<%

%>
<html>
	<head>
		<title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
		<link href="styles/stxDataTable.css" rel="stylesheet" type="text/css" />
		<link href="styles/emxUIDefault.css" rel="stylesheet" type="text/css" />
		<link href="styles/emxUIToolbar.css" rel="stylesheet" type="text/css" />
		<link href="styles/emxUIList.css" rel="stylesheet" type="text/css" />
		<link href="styles/emxUIForm.css" rel="stylesheet" type="text/css" />	
		<script language="javascript" type="text/javascript" src="scripts/emxUICore.js"></script>
		<script language="javascript" type="text/javascript" src="scripts/emxUIModal.js"></script>	
		<script language="JavaScript" type="text/javascript" src="scripts/calendarDate.js"></script>
		<script type="text/javascript" src="scripts/stxAjax.js"></script>
		<script type="text/javascript" src="scripts/stxDynamicTable.js"></script>
		<script>
			function fnOnload()
			{	
				//fnGetOption(searchForm.DWGDEPTCODE,"stxPipingIOAjax.jsp?mode=selectDWGDEPTCODE");
				fnProgressOff();
			}
			
			function fnDone()
			{
				fnProgressOn();
				searchForm.target = "UploadHiddenFrame";
				searchForm.action = "stxPipingIOExcelUploadProcess.jsp?";
				searchForm.submit();
			}
			
			function fnDownLoadFile(FILE_ID)
			{
				var attURL = "stxPRJCPointFileView.jsp?FILE_ID="+FILE_ID;
				showModalDialog(attURL,50,50);
			}
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
		<%
			ArrayList mlButton = new ArrayList();
		%>
		<%=setPageHeaderRenderer("Excel Upload",mlButton)%>
		<form id="searchForm" enctype="multipart/form-data" method="post">
			<table width="100%">
				<tr><td class="requiredNotice" align="center" nowrap  ></td></tr>
			</table>
			<table border="0" cellspacing="2" cellpadding="0" width="100%">
				<tr>
					<td width="99%">
						<table border="0" cellspacing="2" cellpadding="3" width="100%">
							<tr>
								<td class="label">Upload File</td>
								<td class="field">
									<input type="file" name="uploadfile" >
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<%
			ArrayList mlFooterButton = new ArrayList();
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"Upload","fnDone()","../common/images/buttonSearchNext.gif");
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"Ãë¼Ò","top.close()","../common/images/buttonSearchCancel.gif");
		%>
		<%=setPageFooterRenderer(mlFooterButton)%>
	</body>
</html>
<iframe id="UploadHiddenFrame" name="UploadHiddenFrame" style="display:none"></iframe>
