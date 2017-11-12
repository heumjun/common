
<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("UTF-8");%>
<%!
%>
<%	
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
	
	String SHIPTYPE 	= request.getParameter("SHIPTYPE");
	String REQUESTER_NM = request.getParameter("REQUESTER_NM");
	String AREA 		= request.getParameter("AREA");
	String SYSTEM 		= request.getParameter("SYSTEM");
	String ITEM 		= request.getParameter("ITEM");
	String OUTPUT 	= request.getParameter("OUTPUT");
	String ACTIVITY		= request.getParameter("ACTIVITY");
	String DWGDEPTCODE		= request.getParameter("DWGDEPTCODE");
	String PROJECT		= request.getParameter("PROJECT");
	Map mapParam = new HashMap();
	mapParam.put("USER"			,USER);
	mapParam.put("REQUESTER_NM"	,REQUESTER_NM);
	mapParam.put("SHIPTYPE"		,SHIPTYPE);
	mapParam.put("AREA"			,AREA);
	mapParam.put("SYSTEM"		,SYSTEM);
	mapParam.put("ITEM"			,ITEM);
	mapParam.put("OUTPUT"		,OUTPUT);
	mapParam.put("ACTIVITY"		,ACTIVITY);
	mapParam.put("DWGDEPTCODE"	,DWGDEPTCODE);
	mapParam.put("PROJECT"		,PROJECT);
	mapParam.put("SORT"			,"true");
	ArrayList mlList = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_ACT_APP",preSQL(mapParam) );
%>


<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 

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
	<script language="javascript" type="text/javascript" src="../common/showCalendar.js"></script>
	<script type="text/javascript" src="scripts/stxAjax.js"></script>
	<script type="text/javascript" src="scripts/stxDynamicTable.js"></script>
			
	<script type="text/javascript">
	
	function fnOnload()
	{
		if(parent.headerFrame.fnProgressOff)
		{
			parent.headerFrame.fnProgressOff();
		}
	}
	function checkDataShow(obj)
	{
		checkData(obj)
		obj = null;
	}
	
	function fnChkAll(obj)
	{
		var arrChkData = document.getElementsByName("chkData");
		for(var i=0;i<arrChkData.length;i++)
		{
			arrChkData[i].checked = obj.checked;
			checkDataShow(arrChkData[i])
		}
		arrChkData = null;
		obj = null;
	}
	
	function fnChkData()
	{
		var rArr = new Array();
		var arrChkData = document.getElementsByName("chkData");
		for(var i=0;i<arrChkData.length;i++)
		{
			if(arrChkData[i].checked)rArr[rArr.length] = arrChkData[i];
		}
		return rArr;
	}
	
	function fnGetFileView(PROJECT,PIPING_IO_ID)
	{
		var url = "../stxcentral/stxPipingIOFileUpload.jsp?";
		url += "&PIPING_IO_ID="+PIPING_IO_ID
		url += "&PROJECT="+PROJECT
		
		showModalDialog(url, 500, 500);
	}

	</script>
</head>
<body onload="fnOnload()">
	<form name="listForm" method="post">
			<table>
				<tr>
					<td>
					<div id="listDiv" STYLE="width:100%; height:500; overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
	         				<table id="dataTable" width="1200" cellSpacing="1" cellpadding="0" border="0" align="left" style="table-layout:fiexed;">
		              			<tr>
		              				<td class="td_header" colspan="" width="3%" rowspan="2"><input type="checkbox" name="chkAll" onclick="fnChkAll(this)"></td>
	         						<td class="td_header" colspan="" width="5%" rowspan="2">승인요청자</td>
	         						<td class="td_header" colspan="" width="5%" rowspan="2">도면부서</td>
	         						<td class="td_header" colspan="4">DESIGN SUBJECT</td>
									<td class="td_header" colspan="2">INPUT DATA</td>
									<td class="td_header" rowspan="2">OUTPUT DATA</td>
									<td class="td_header" rowspan="2">DESCRIPTION</td>
									<td class="td_header" colspan="3">PROCESSING</td>
									<td class="td_header" colspan="2">STATUS</td>
	         					</tr>
	         					<tr>
									<td class="td_header" width="3%" >호선</td>
									<td class="td_header" width="5%" >AREA</td>
									<td class="td_header" width="5%" >SYSTEM</td>
									<td class="td_header" width="5%" >ITEM</td>
									<td class="td_header" width="5%" >DETAILS</td>
									<td class="td_header" width="5%" >CONSIDER<br>ATIONS</td>
									<td class="td_header" width="5%" >DESIGN BASIS</td>
									<td class="td_header" width="25%" >ACTIVITY</td>
									<td class="td_header" width="5%" >GUIDE<br>File</td>
									<td class="td_header" width="5%" >DUE DATE</td>
									<td class="td_header" width="5%" >ACTION DATE</td>
		              			</tr>
	                	<%
	                	int iTotalSize = mlList.size();
	                	int pageSize = 100;
	                	int currentPage = 0;
	                	if(request.getParameter("currentPage") != null)currentPage = Integer.parseInt(request.getParameter("currentPage"));
						for (int i = pageSize * currentPage; mlList != null && i < mlList.size() && i < pageSize * (currentPage+1); i++) {
							Map mapResult = (Map) mlList.get(i);
							
							String sTRClass = "odd";
		                    if(i%2==0)
		                    {
		                    	sTRClass = "even";
		                    }
						%>
							<tr edit="false" class="<%=sTRClass%>" PIPING_IO_ID="<%=mapResult.get("PIPING_IO_ID")%>" PROJECT="<%=mapResult.get("PROJECT")%>" >
								<td class="data" align="center" alias="chk" >
									<input type="checkbox" onclick="checkDataShow(this)" name="chkData" value="<%=mapResult.get("PIPING_IO_ID")%>">
								</td>
								<td class="data" align="center" alias="REQUESTER_NM" >
									<%=mapResult.get("REQUESTER_NM")%>
								</td>
								<td class="data" align="center" alias="DWGDEPTCODE" >
									<%=mapResult.get("DWGDEPTNM")%>
								</td>
								<td class="data" align="center" alias="PROJECT" >
									<%=mapResult.get("PROJECT")%>
								</td>
								<td class="data" align="center" alias="AREA" >
									<%=mapResult.get("AREA")%>
								</td>
								<td class="data" align="left" alias="SYSTEM" >
									<%=mapResult.get("SYSTEM")%>
								</td>
								<td class="data" align="left" alias="ITEM" >
									<%=mapResult.get("ITEM")%>
								</td>
								<td class="data" align="left" alias="DETAILS" >
									<%=mapResult.get("DETAILS")%>
								</td>
								<td class="data" align="left" alias="CONDERATIONS" >
									<%=mapResult.get("CONDERATIONS")%>
								</td>
								<td class="data" align="left" alias="OUTPUT" >
									<%=mapResult.get("OUTPUT")%>
								</td>
								<td class="data" align="left" alias="DESCRIPTION" >
									<%=mapResult.get("DESCRIPTION")%>
								</td>
								<td class="data" align="left" alias="DESIGN_BASIS" >
									<%=mapResult.get("DESIGN_BASIS")%>
								</td>
								<td class="data" align="left" alias="ACTIVITY" >
									<%=mapResult.get("ACTIVITY")%>
								</td>
								<td class="data" align="center" alias="DESIGN_GUIDANCE" ondblclick="fnGetFileView('DB','<%=mapResult.get("PIPING_IO_ID")%>')" >
									<%=mapResult.get("CNT_FILE")%>
								</td>
								<td class="data" align="left" alias="DUE_DATE" >
									<%=mapResult.get("DUE_DATE")%>
								</td>
								<td class="data" align="left" alias="ACTION_DATE" >
									<%=mapResult.get("ACTION_DATE")%>
								</td>
							</tr>
						<%
						}
						%>
						</table>
					</div>
				</td>
				</tr>
			</table>
			<%=setListPaging(iTotalSize,pageSize,currentPage)%>
		<table id="hiddenTable">
			<tr id="hiddenRow">
			</tr>
		</table>
	</form>
	<form name="submitForm" method="post">
		<table id="submitTbl">
		</table>
		<input type="hidden" name="NEW_ROW" 					value="0" >
		<input type="hidden" name="EDIT_ROW" 					value="0" >
	</form>
</body>
</html>
