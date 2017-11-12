<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%!
%>
<%
	String[] PIPING_IO_IDS = request.getParameterValues("PIPING_IO_ID");
	String paramPIPING_IO_IDS = "";
	for(int index=0;index<PIPING_IO_IDS.length;index++)
	{
		paramPIPING_IO_IDS += paramPIPING_IO_IDS.equals("")?PIPING_IO_IDS[index]:"|" + PIPING_IO_IDS[index];
	}
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
				fnProgressOff();
			}
			
			function fnDone()
			{
				if(searchForm.PROJECT.value == "")
				{
					alert("생성할 호선을 입력하십시요")
					return;
				}
				fnProgressOn();
				var objAjax = new stxAjax("stxPipingIOAjax.jsp?mode=createPIPINGIOPRJ&PROJECT="+searchForm.PROJECT.value+"&DESCRIPTION="+searchForm.DESCRIPTION.value.encodeURI()+"&PIPING_IO_IDS=<%=paramPIPING_IO_IDS%>");
				var vReturn = objAjax.executeSync(true);
				
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("생성 되었습니다.");
				} else {
					alert(fnGetDocRecordValue(vReturn.documentElement,"errorMsg"))
					objAjax = null;
					vReturn = null;
					fnProgressOff();
					return;
				}
				
				objAjax = null;
				vReturn = null;
				opener.fnProgressOn();
				opener.fnSearch();
				top.close();
			}
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
		<%
			ArrayList mlButton = new ArrayList();
		%>
		<%=setPageHeaderRenderer("Master Design I/O Database 호선 적용",mlButton)%>
		<form id="searchForm"  method="post">
			<table width="100%">
				<tr><td class="requiredNotice" align="center" nowrap  >※  Project I/O DATA를 생성할 호선을 입력하십시요..</td></tr>
			</table>
			<table border="0" cellspacing="2" cellpadding="0" width="100%">
				<tr>
					<td width="99%">
						<table border="0" cellspacing="2" cellpadding="3" width="100%">
							<tr>
								<td class="label">호선</td>
								<td class="field">
									<input type="text" name="PROJECT">
								</td>
								<td class="label">DESCRIPTION</td>
								<td class="field">
									<input type="text" name="DESCRIPTION">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<%
			ArrayList mlFooterButton = new ArrayList();
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"호선 적용","fnDone()","../common/images/buttonSearchNext.gif");
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"취소","top.close()","../common/images/buttonSearchCancel.gif");
		%>
		<%=setPageFooterRenderer(mlFooterButton)%>
	</body>
</html>
<iframe id="UploadHiddenFrame" name="UploadHiddenFrame" style="display:none"></iframe>
