<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%!
%>

<script type="text/javascript">
</script>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<html>
	<head>
		<title>MASTER I/O DATA APPROVAL</title>

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
				fnProgressOn();
				fnSetDefaultOption();
				fnProgressOff();
			}
			
			function fnSearch(vPage)
			{
				fnProgressOn();
				var vUrl = "stxPipingIODBAppList.jsp?";
				vUrl += "&SHIPTYPE="+searchForm.SHIPTYPE.value.encodeURI();
				vUrl += "&REQUESTER_NM="+searchForm.REQUESTER_NM.value.encodeURI();
				vUrl += "&AREA="+searchForm.AREA.value.encodeURI();
				vUrl += "&SYSTEM="+searchForm.SYSTEM.value.encodeURI();
				vUrl += "&ITEM="+searchForm.ITEM.value.encodeURI();
				vUrl += "&OUTPUT="+searchForm.OUTPUT.value.encodeURI();
				vUrl += "&ACTIVITY="+searchForm.ACTIVITY.value.encodeURI();
				vUrl += "&DWGDEPTCODE="+searchForm.DWGDEPTCODE.value.encodeURI();
				if(vPage)
				{
					vUrl += "&currentPage=" + vPage;
				}
				parent.listFrame.location.href = vUrl;
			}
			
			function fnApprove(APPROVED_TYPE)
			{
				var arrCheck = parent.listFrame.fnChkData();
				if(arrCheck.length==0)
				{
					alert("결재대상을 선택하십시요.");
					return;
				}
				
				fnProgressOn();
				
				var url = "stxPipingIOAjax.jsp?mode=approvePIPINGIO&APPROVED_TYPE="+APPROVED_TYPE;
				for(var i = 0;i<arrCheck.length;i++)
				{
					url += "&PIPING_IO_ID="+arrCheck[i].parentNode.parentNode.PIPING_IO_ID;
					url += "&PROJECT="+arrCheck[i].parentNode.parentNode.PROJECT;
				}
				
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("처리 되었습니다.")
					fnSearch();
				} else {
					alert(fnGetDocRecordValue(vReturn.documentElement,"errorMsg"))
					objAjax = null;
					vReturn = null;
					fnProgressOff();
					return;
				}
				
				objAjax = null;
				vReturn = null;
				fnProgressOff();
			}
		  	
		  	function fnSetDefaultOption()
			{
				fnRemoveAllOptionSelect(searchForm.DWGDEPTCODE)
				fnGetOption(searchForm.DWGDEPTCODE,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"DWGDEPTCODE");
				fnRemoveAllOptionSelect(searchForm.OUTPUT)
				fnGetOption(searchForm.OUTPUT,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"OUTPUT");
				fnRemoveAllOptionSelect(searchForm.AREA)
				fnGetOption(searchForm.AREA,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"AREA");
				fnRemoveAllOptionSelect(searchForm.SHIPTYPE)
				fnGetOption(searchForm.SHIPTYPE,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"SHIPTYPE");
				fnRemoveAllOptionSelect(searchForm.SYSTEM)
				fnGetOption(searchForm.SYSTEM,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"SYSTEM");
				fnRemoveAllOptionSelect(searchForm.ITEM)
				fnGetOption(searchForm.ITEM,"stxPipingIOAjax.jsp?mode=selectGetOption&COL="+"ITEM");
			}
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
	<%
		ArrayList mlButton = new ArrayList();
		mlButton = setButtonRenderer(mlButton,"조회","fnSearch()");
		mlButton = setButtonRenderer(mlButton,"승인","fnApprove('APPROVE')");
		mlButton = setButtonRenderer(mlButton,"반려","fnApprove('REJECT')");
	%>
	<%=setPageHeaderRenderer("MASTER I/O DATA APPROVAL",mlButton)%>
		<table border="0" cellspacing="2" cellpadding="0" width="100%">
			<tr>
				<td width="99%">
					<form id="searchForm" method="post">
						<table border="0" cellspacing="2" cellpadding="3" width="100%">
							<input type="hidden" name="hidden" value="">
							<tr>
								<td class="label">
									SHIP TYPE
								</td>
								<td class="field">
									<select name="SHIPTYPE" style="width:200px;">
									</select>
								</td>
								<td class="label">
									AREA
								</td>
								<td class="field">
									<select name="AREA" style="width:200px;">
									</select>
								</td>
								<td class="label">
									SYSTEM
								</td>
								<td class="field">
									<select name="SYSTEM" style="width:200px;">
									</select>
								</td>
							</tr>
							<tr>
								<td class="label">
									ITEM
								</td>
								<td class="field">
									<select name="ITEM" style="width:350px;">
									</select>
								</td>
								<td class="label">
									OUTPUT DATA
								</td>
								<td class="field">
									<select name="OUTPUT" style="width:350px;">
									</select>
								</td>
								<td class="label">
									ACTIVITY
								</td>
								<td class="field">
									<input type="text" name="ACTIVITY" style="width:200px;" value="">
								</td>
							</tr>
							<tr>
								<td class="label">
									부서
								</td>
								<td class="field" >
									<select name="DWGDEPTCODE" style="width:200px;">
									</select>
								</td>
								<td class="label">
									요청자
								</td>
								<td class="field" colspan="3">
									<input type="text" name="REQUESTER_NM" style="width:200px;" value="">
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
	</body>
</html>
<iframe id="headerHidden" name="headerHidden" style="display:none"></iframe>