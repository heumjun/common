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
				fnProgressOff();
			}
			
			function fnDone()
			{

				fnProgressOn();
				var url = "stxPipingIOAjax.jsp?mode=createPIPINGIODB"
				url += "&SHIPTYPE=" + searchForm.SHIPTYPE.value;
				url += "&AREA=" + searchForm.AREA.value;
				url += "&SYSTEM=" + searchForm.SYSTEM.value;
				url += "&ITEM=" + searchForm.ITEM.value;
				url += "&DETAILS=" + searchForm.DETAILS.value;
				url += "&SHIPTYPE=" + searchForm.SHIPTYPE.value;
				url += "&CONSIDERATIONS=" + searchForm.CONSIDERATIONS.value;
				url += "&DESIGN_BASIS=" + searchForm.DESIGN_BASIS.value;
				url += "&ACTIVITY=" + searchForm.ACTIVITY.value;
				url += "&OUTPUT=" + searchForm.OUTPUT.value;
				url += "&EVENT=" + searchForm.EVENT.value;
				url += "&FACTOR=" + searchForm.FACTOR.value;
				url += "&IMPORTANCE=" + searchForm.IMPORTANCE.value;
				var objAjax = new stxAjax(url);
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
		<%=setPageHeaderRenderer("Master Design I/O DATA Manual Upload",mlButton)%>
		<form id="searchForm"  method="post">
			<table width="100%">
				<tr><td class="requiredNotice" align="center" nowrap  >※  Master Design I/O DATA 정보를 입력하십시요..</td></tr>
			</table>
			<div id="listDiv" STYLE="width:100%; height:125; overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
			<table border="0" cellspacing="2" cellpadding="0" width="100%">
				<tr>
					<td width="99%">
						<table border="0" cellspacing="2" cellpadding="3" width="100%">
							<tr>
								<td class="td_header" width="5%" >선종</td>
								<td class="td_header" width="5%" >AREA</td>
								<td class="td_header" width="5%" >SYSTEM</td>
								<td class="td_header" width="5%" >ITEM</td>
								<td class="td_header" width="5%" >DETAILS</td>
								<td class="td_header" width="5%" >CONSIDERATIONS</td>
								<td class="td_header" width="5%" >OUTPUT</td>
								<td class="td_header" width="5%" >DESIGN BASIS</td>
								<td class="td_header" width="5%" >ACTIVITY</td>
								<td class="td_header" width="5%" >참조 EVENT</td>
								<td class="td_header" width="5%" >FACTOR</td>
								<td class="td_header" width="5%" >중요도</td>
							</tr>
								<td class="field" align="center">
									<input type="text" style="width:80" name="SHIPTYPE">
								</td>
								<td class="field" align="center">
									<input type="text" style="width:80" name="AREA">
								</td>
								<td class="field" align="center">
									<input type="text" style="width:80" name="SYSTEM">
								</td>
								<td class="field" align="center">
									<input type="text" style="width:80" name="ITEM">
								</td>
								<td class="field" align="center">
									<textarea rows="4" name="DETAILS" style="width:90" ></textarea>
								</td>
								<td class="field" align="center">
									<textarea rows="4" name="CONSIDERATIONS" style="width:90" ></textarea>
								</td>
								<td class="field" align="center">
									<input type="text" style="width:80" name="OUTPUT">
								</td>
								<td class="field" align="center">
									<textarea rows="4" name="DESIGN_BASIS" style="width:90"  ></textarea>
								</td>
								<td class="field" align="center">
									<textarea rows="2" name="ACTIVITY" style="width:200"  ></textarea>
								</td>
								<td class="field" align="center">
									<input type="text" style="width:80" name="EVENT">
								</td>
								<td class="field" align="center">
									<select name="FACTOR">
									<option value=""></option>
									<%for(int inx=-50;inx<11;inx++){ %>
										<option value="<%=inx%>" ><%=inx%></option>
									<%}%>
									</select>
								</td>
								<td class="field" align="center">
									<select name="IMPORTANCE">
									<option value=""></option>
									<option value="H" >H</option>
									<option value="M" >M</option>
									<option value="L" >L</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</div>
		</form>
		<%
			ArrayList mlFooterButton = new ArrayList();
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"추가","fnDone()","../common/images/buttonSearchNext.gif");
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"취소","top.close()","../common/images/buttonSearchCancel.gif");
		%>
		<%=setPageFooterRenderer(mlFooterButton)%>
	</body>
</html>
<iframe id="UploadHiddenFrame" name="UploadHiddenFrame" style="display:none"></iframe>
