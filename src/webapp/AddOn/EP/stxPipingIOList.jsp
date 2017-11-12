<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>

<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("UTF-8");%>
<%!
%>
<%	

	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
	String PROJECT = request.getParameter("PROJECT");
	String OUTPUT = request.getParameter("OUTPUT");
	String AREA = request.getParameter("AREA");
	String ACTIVITY = request.getParameter("ACTIVITY");
	String ITEM = request.getParameter("ITEM");
	String SYSTEM = request.getParameter("SYSTEM");
	String DWGDEPTCODE = request.getParameter("DWGDEPTCODE");
	String QUERYON 		= request.getParameter("QUERYON");
	String SORTCOL 		= request.getParameter("SORTCOL");
	String DESCRIPTION 		= request.getParameter("DESCRIPTION");
	
	
	Map mapParam = new HashMap();
	mapParam.put("USER",USER);
	mapParam.put("PROJECT",PROJECT);
	mapParam.put("OUTPUT",OUTPUT);
	mapParam.put("AREA",AREA);
	mapParam.put("ACTIVITY",ACTIVITY);
	mapParam.put("ITEM",ITEM);
	mapParam.put("SYSTEM",SYSTEM);
	mapParam.put("DWGDEPTCODE",DWGDEPTCODE);
	mapParam.put("DESCRIPTION",DESCRIPTION);
	mapParam.put("SORT_" + SORTCOL		,"true");
	
	ArrayList mlList = new ArrayList();
	if(QUERYON != null && !QUERYON.equals(""))	mlList = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_ACT",preSQL(mapParam));
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
	
	var preVal = "";
	
	function fnSetPreVal(obj)
	{
		preVal = obj.value;
	}
	
	function fnCheckPostVal(obj)
	{
		if(preVal != obj.value)
		{
			fnSetRowEdit(obj)
		}
	}
	
	function fnSetRowEdit(obj)
	{
		obj.parentNode.parentNode.edit = "true";
	}
	
	function fnEditDataParam()
	{
		var param = "";
		var oTbl = document.getElementById('dataTable');
		for(var i=2;i< oTbl.rows.length ;i++)
		{
			var oRow = oTbl.rows[i];
			if(oRow.edit == "true")
			{
				param += "&PIPING_IO_ID="+oRow.PIPING_IO_ID;
				param += "&PROJECT="+oRow.PROJECT;
				param += fnEditCellParam(oRow);
			}
			oRow = null;
		}
		oTbl = null;
		return param;
	}
	
	function fnEditCellParam(oRow)
	{
		var param = "";
		for(var i=0;i< oRow.cells.length ;i++)
		{
			var oCell = oRow.cells[i];
			if(oCell.checkEdit=="true")
			{
				param += "&" + oCell.alias + "=" + oCell.firstChild.value.encodeURI();
			}
			oCell = null;
		}
		oRow = null
		return param;
	}
	
	function fnGetFileView(PROJECT,PIPING_IO_ID)
	{
		var url = "stxPipingIOFileUpload.jsp?";
		url += "&PIPING_IO_ID="+PIPING_IO_ID
		url += "&PROJECT="+PROJECT
		
		showModalDialog(url, 500, 500);		
	}
	
	var tObjInput = null;
	function fnChangeDesigner(obj,PROJECT,PIPING_IO_ID)
	{
		tObjInput = obj.parentNode.firstChild;
		var url = "stxDPPersonSearch.jsp?";
		url += "&PIPING_IO_ID="+PIPING_IO_ID
		url += "&PROJECT="+PROJECT
		url += "&postFunction=fnSetUser"
		
		showModalDialog(url, 500, 550);		
	}
	
	function fnSetUser(oParam,USERID)
	{
		fnSetRowEdit(tObjInput)
		tObjInput.value = USERID;
	}
	
	function fnChangeDesignerAll()
	{
		var url = "stxDPPersonSearch.jsp?";
		url += "&postFunction=fnSetUserAll"
		showModalDialog(url, 500, 550);		
	}
	
	function fnSetUserAll(oParam,USERID)
	{
		var oTbl = document.getElementById('dataTable');
		for(var i=2;i<oTbl.rows.length;i++)
		{
			var row = oTbl.rows[i];
			if(row.firstChild.firstChild.checked)
			{
				for(var j=0;j<row.cells.length;j++)
				{
					if(row.cells[j].alias == "APP0")
					{
						row.cells[j].firstChild.value = USERID;
						fnSetRowEdit(row.cells[j].firstChild);
					}
				}
			}
			row = null;
		}
		oTbl = null;
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

	function showCalendar(strFormName, strInputName, strInitialDate, blnRemember, fnCallback)
	{
	    var objForm = document.forms[strFormName];
		
	    var url = "../common/calendar1.jsp?strFormName="+strFormName+"&strInputName="+strInputName;

        var nwidth = 221;
        var nheight = 300;
        var LeftPosition = (screen.availWidth-nwidth)/2;
        var TopPosition = (screen.availHeight-nheight)/2;

        var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;	   
	    window.open(url, null, sProperties);

	    if( !(fnCallback=='' || fnCallback==null ))
	    {
	    	fnCallback();
	    }
	} 	

	var currentInputName = null;
    // 달력창 Show
    function showCalendarWin(inputObj, inputForm, inputName)
    {
    	currentInputName = document.getElementById(inputName);    	
  	
        showCalendar(inputForm, inputName, '', false, dateChanged);
    }	
	
	function dateChanged()
    {    
   		fnSetRowEdit(currentInputName);
   		currentInputName=null;
    }
    
    function formatDateStr(dateStr)
	{
		if (dateStr.indexOf(".") > 0) { 
			var returnStr = dateStr.substring(0, 4);
			dateStr = dateStr.substring(6, dateStr.length);
			var dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
			if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
			returnStr += "-" + dateStr2;
			dateStr = dateStr.substring(dateStr.indexOf(".") + 2, dateStr.length);
			dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
			if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
			returnStr += "-" + dateStr2;
			return returnStr;
		}
		else return dateStr;
	}
	
 	function fnRefConstructionDate()
 	{
 	
 		var PROJECT = "";
 		var oTbl = document.getElementById('dataTable');
		for(var i=2;i<oTbl.rows.length;i++)
		{
			var row = oTbl.rows[i];
			if(row.firstChild.firstChild.checked)
			{
				PROJECT = row.PROJECT
			}
			row = null;
		}
		oTbl = null;
		
		if(PROJECT == "")
		{
			alert("일자적용 대상 I/O를 선택해주십시요.");
			return;
		}
		
 		var url = "stxConstructionDateSearch.jsp?MODE=getConstructionDate&PROJECTNO=" + PROJECT;
		url += "&postFunction=fnSetDateAll"
		showModalDialog(url, 600, 550);	
		
 	}
 	
 	function fnSetDateAll(oParam,DATE)
	{
		var oTbl = document.getElementById('dataTable');
		for(var i=2;i<oTbl.rows.length;i++)
		{
			var row = oTbl.rows[i];
			if(row.firstChild.firstChild.checked)
			{
				for(var j=0;j<row.cells.length;j++)
				{
					if(row.cells[j].alias == "DUE_DATE")
					{
						row.cells[j].firstChild.value = DATE;
						fnSetRowEdit(row.cells[j].firstChild);
					}
				}
			}
			row = null;
		}
		oTbl = null;
	}

	</script>
</head>
<body onload="fnOnload()">
	<form name="listForm" method="post">
			<table>
				<tr>
					<td>
					<div id="listDiv" STYLE="width:100%; height:expression(window.document.body.clientHeight-70); overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
	         				<table id="dataTable" cellSpacing="1" cellpadding="0" border="0" align="left" style="width:expression(window.document.body.clientWidth-50);table-layout:fiexed;">
	         					<tr>
	         						<td class="td_header_fix" colspan="" width="30" rowspan="2"><input type="checkbox" name="chkAll" onclick="fnChkAll(this)"></td>
	         						<td class="td_header" colspan="4">DESIGN SUBJECT</td>
									<td class="td_header" colspan="2">INPUT DATA</td>
									<td class="td_header" rowspan="2" width="100">OUTPUT DATA</td>
									<td class="td_header" rowspan="2" width="100">DESCRIPTION</td>
									<td class="td_header" colspan="3">PROCESSING</td>
									<td class="td_header" colspan="2">STATUS</td>
									<td class="td_header" colspan="4">LIFECYCLE</td>
	         					</tr>
	         					<tr>
									<td class="td_header" width="100" >호선</td>
									<td class="td_header" width="100" >AREA</td>
									<td class="td_header" width="100" >SYSTEM</td>
									<td class="td_header" width="100" >ITEM</td>
									<td class="td_header" width="250" >DETAILS</td>
									<td class="td_header" width="100" >CONSIDER<br>ATIONS</td>
									<td class="td_header" width="100" >DESIGN BASIS</td>
									<td class="td_header" width="400" >ACTIVITY</td>
									<td class="td_header" width="30" ><img src="../common/images/iconAttachment.gif" border="0" alt="" vspace="0"></td>
									<td class="td_header" width="150" >DUE DATE</td>
									<td class="td_header" width="150" >ACTION DATE</td>
									<td class="td_header" width="200" >승인<br>요청</td>
									<td class="td_header" width="200" >라인장</td>
									<td class="td_header" width="200" >파트장</td>
									<td class="td_header"  >팀장</td>
		              			</tr>
	                	<%
	                	int iTotalSize = mlList.size();
	                	int pageSize = 50;
	                	int currentPage = 0;
	                	if(request.getParameter("currentPage") != null)currentPage = Integer.parseInt(request.getParameter("currentPage"));
						for (int i = pageSize * currentPage; mlList != null && i < mlList.size() && i < pageSize * (currentPage+1); i++) {
							Map mapResult = (Map) mlList.get(i);
							
							String sTRClass = "odd";
		                    if(i%2==0)
		                    {
		                    	sTRClass = "even";
		                    }
		                    
		                    String ImportantStyle = "";
		                    if(mapResult.get("MAX_APP").equals("3"))ImportantStyle = ";font-weight:bold;color:#FF0000;";
		                    if(mapResult.get("MAX_APP").equals("2"))ImportantStyle = ";font-weight:bold;color:#000000;";
						%>
							<tr class="<%=sTRClass%>" PIPING_IO_ID="<%=mapResult.get("PIPING_IO_ID")%>" PROJECT="<%=mapResult.get("PROJECT")%>" OWNER="<%=mapResult.get("OWNER")%>" APP0="<%=mapResult.get("APP0")%>" APP1="<%=mapResult.get("APP1")%>" APP2="<%=mapResult.get("APP2")%>" STATUS="<%=mapResult.get("STATUS")%>" >
								<td class="data_fix" align="center" alias="chk" >
									<input type="checkbox" onclick="checkDataShow(this)" name="chkData" value="<%=mapResult.get("PIPING_IO_ID")%>">
								</td>
								<td class="data" align="center" alias="PROJECT" style="<%=ImportantStyle%>" >
									<%=mapResult.get("PROJECT")%>
								</td>
								<td class="data" align="center" alias="AREA" style="<%=ImportantStyle%>" >
									<%=mapResult.get("AREA")%>
								</td>
								<td class="data" align="center" alias="SYSTEM" style="<%=ImportantStyle%>" >
									<%=mapResult.get("SYSTEM")%>
								</td>
								<td class="data" align="center" alias="ITEM" style="<%=ImportantStyle%>" >
									<%=mapResult.get("ITEM")%>
								</td>
								<td class="data" align="center" alias="DETAILS" style="<%=ImportantStyle%>" >
									<%=mapResult.get("DETAILS")%>
								</td>
								<td class="data" align="center" alias="CONDERATIONS" style="<%=ImportantStyle%>" >
									<%=mapResult.get("CONDERATIONS")%>
								</td>
								<td class="data" align="center" alias="OUTPUT" style="<%=ImportantStyle%>" >
									<%=mapResult.get("OUTPUT")%>
								</td>
								<td class="data" align="center" alias="DESCRIPTION" style="<%=ImportantStyle%>" checkEdit="true">
									<textarea rows="4" class="inputtrans" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" style="width:100"><%=mapResult.get("DESCRIPTION")%></textarea>
								</td>
								<td class="data" align="center" alias="DESIGN_BASIS" >
									<%=mapResult.get("DESIGN_BASIS")%>
								</td>
								<td class="data" align="center" alias="ACTIVITY" >
									<textarea rows="4" class="inputtrans" readonly="true" style="width:300"><%=mapResult.get("ACTIVITY")%></textarea>
								</td>
								<td class="data" align="center" alias="DESIGN_GUIDANCE"  ondblclick="fnGetFileView('DB','<%=mapResult.get("PIPING_IO_ID")%>')">
									<%=mapResult.get("CNT_FILE")%>
								</td>
								<td class="data" align="center" alias="DUE_DATE" checkEdit="true">
									<input type="text" name="DDATE<%=mapResult.get("PIPING_IO_ID")%>_<%=mapResult.get("PROJECT")%>"  value="<%=mapResult.get("DUE_DATE")%>" size="10"  readonly="readonly">
									<a href="javascript:showCalendarWin(this,'listForm', 'DDATE<%=mapResult.get("PIPING_IO_ID")%>_<%=mapResult.get("PROJECT")%>')" ><img src="images/iconCalendar.gif" border=0></a>
								</td>
								<td class="data" align="center" alias="ACTION_DATE" checkEdit="true">
									<input type="text" name="DATE<%=mapResult.get("PIPING_IO_ID")%>_<%=mapResult.get("PROJECT")%>"  value="<%=mapResult.get("ACTION_DATE")%>" size="10"  readonly="readonly">
									<a href="javascript:showCalendarWin(this,'listForm', 'DATE<%=mapResult.get("PIPING_IO_ID")%>_<%=mapResult.get("PROJECT")%>')" ><img src="images/iconCalendar.gif" border=0></a>
								</td>
								
								<td class="data" align="center" alias="OWNER_NM"  >
									<%=mapResult.get("OWNER_NM")%>
									<BR>
									<%=mapResult.get("APPROVED_DATE0")%>
									<span style="color:red;"><%=mapResult.get("APPROVED_REQUIRED0")%></span>
								</td>
								<td class="data" align="center" alias="APP0" checkEdit="true">
									<input type="text" alias="APP0"  value="<%=(mapResult.get("APP0") == null ||mapResult.get("APP0").equals(""))?"":mapResult.get("APP0")+"|"+mapResult.get("APP0_NM")%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" size="12">
									<input type="button" value="사용자 검색" onclick="fnChangeDesigner(this,'<%=mapResult.get("PROJECT")%>','<%=mapResult.get("PIPING_IO_ID")%>')">
									<BR>
									<%=mapResult.get("APPROVED_DATE1")%>
									<span style="color:red;"><%=mapResult.get("APPROVED_REQUIRED1")%></span>
								</td>
								<td class="data" align="center" alias="APP1_NM"  >
									<%=mapResult.get("APP1_NM")%>
									<BR>
									<%=mapResult.get("APPROVED_DATE2")%>
									<span style="color:red;"><%=mapResult.get("APPROVED_REQUIRED2")%></span>
								</td>
								<td class="data" align="center" alias="APP2_NM"  >
									<%=mapResult.get("APP2_NM")%>
									<BR>
									<%=mapResult.get("APPROVED_DATE3")%>
									<span style="color:red;"><%=mapResult.get("APPROVED_REQUIRED3")%></span>
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
