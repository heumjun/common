<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("UTF-8");%>
<%!
	public static String getListToSelectOptionHtml(ArrayList mlList, String DEFAULT) throws Exception
	{
		StringBuffer sbHtml = new StringBuffer();
		Iterator itr = mlList.iterator();
		while(itr.hasNext())
		{
			Map mapOption = (Map)itr.next();
			String SELECTED = "";
			if(DEFAULT != null && DEFAULT.equals(mapOption.get("VALUE")))SELECTED = "selected";
			sbHtml.append("<option value='"+mapOption.get("VALUE")+"' "+SELECTED+">"+mapOption.get("DISPLAY")+"</option>");
		}
		return sbHtml.toString();
	}

%>
<%	

	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");	
	String QUERYON 		= request.getParameter("QUERYON");
	String SHIPTYPE 	= request.getParameter("SHIPTYPE");
	String AREA 		= request.getParameter("AREA");
	String SYSTEM 		= request.getParameter("SYSTEM");
	String ITEM 		= request.getParameter("ITEM");
	String OUTPUT 	= request.getParameter("OUTPUT");
	String ACTIVITY		= request.getParameter("ACTIVITY");
	String DWGDEPTCODE		= request.getParameter("DWGDEPTCODE");
	String SORTCOL		= request.getParameter("SORTCOL");
	Map mapParam = new HashMap();
	mapParam.put("USER"			,USER);
	mapParam.put("SHIPTYPE"	,SHIPTYPE);
	mapParam.put("AREA"			,AREA);
	mapParam.put("SYSTEM"		,SYSTEM);
	mapParam.put("ITEM"			,ITEM);
	mapParam.put("OUTPUT"	,OUTPUT);
	mapParam.put("ACTIVITY"		,ACTIVITY);
	mapParam.put("DWGDEPTCODE"		,DWGDEPTCODE);
	mapParam.put("SORT_" + SORTCOL		,"true");
	
	ArrayList mlList = new ArrayList();
	if(QUERYON != null && !QUERYON.equals(""))	mlList = SQLSourceUtil.executeSelect("PLM","PIPINGIO.selectSTX_PIPING_IO_ACT_DB",preSQL(mapParam)); 
	
	Map mapDWGDEPTParam = new HashMap();
	mapDWGDEPTParam.put("SORT","true");
	ArrayList mlDWGDeptOption = SQLSourceUtil.executeSelect("PLM","DEPT.selectDWGDept",mapDWGDEPTParam);
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
	
	function fnGetCheckPIPINGIOParam()
	{
		var rParam = "";
		var arrChkData = document.getElementsByName("chkData");
		for(var i=0;i<arrChkData.length;i++)
		{
			if(arrChkData[i].checked)rParam+="&PIPING_IO_ID="+arrChkData[i].parentNode.parentNode.PIPING_IO_ID
		}
		arrChkData = null;
		obj = null;
		return rParam;
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
				var val = oCell.firstChild.value;
				if(oCell.firstChild.type=="checkbox"&&!oCell.firstChild.checked)val = "";
				param += "&" + oCell.alias + "=" + val.encodeURI();
				val = null;
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
					if(row.cells[j].alias == "APP1")
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
	</script>
</head>
<body onload="fnOnload()">
	<form name="listForm" method="post">
			<table>
				<tr>
					<td>
					<div id="listDiv" STYLE="width:100%;height:expression(window.document.body.clientHeight-50); overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
	         				<table id="dataTable" cellSpacing="1" cellpadding="0" border="0" align="left" style="width:expression(window.document.body.clientWidth-50);table-layout:fiexed;">
	         					<tr>
	         						<td class="td_header_fix" colspan="" style="width:10" rowspan="2"><input type="checkbox" name="chkAll" onclick="fnChkAll(this)"></td>
	         						<td class="td_header" colspan="4">DESIGN SUBJECT</td>
									<td class="td_header" colspan="2">INPUT DATA</td>
									<td class="td_header" rowspan="2" width="500">OUTPUT DATA</td>
									<td class="td_header" colspan="3">PROCESSING</td>
									<td class="td_header" colspan="3">LIFECYCLE</td>
									<td class="td_header" colspan="1" rowspan="2">EVENT</td>
									<td class="td_header" colspan="1" rowspan="2">FACTOR</td>
									<td class="td_header" colspan="1" rowspan="2">중요도</td>
	         					</tr>
	         					<tr>
									<td class="td_header" width="500" >선종</td>
									<td class="td_header" width="500" >AREA</td>
									<td class="td_header" width="500" >SYSTEM</td>
									<td class="td_header" width="500" >ITEM</td>
									<td class="td_header" width="500" >DETAILS</td>
									<td class="td_header" width="500" >CONSIDER<br>ATIONS</td>
									<td class="td_header" width="500" >DESIGN BASIS</td>
									<td class="td_header" width="500" >ACTIVITY</td>
									<td class="td_header" width="500" ><img src="../common/images/iconAttachment.gif" border="0" alt="" vspace="0"></td>
									<td class="td_header" width="500" >승인<br>요청</td>
									<td class="td_header" width="500" >파트장</td>
									<td class="td_header" width="500" >MANAGER</td>
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
		                    
		                    String ImportantStyle = "";
		                    if(mapResult.get("IMPORTANCE").equals("H"))ImportantStyle = ";font-weight:bold;color:#FF0000;";
		                    if(mapResult.get("IMPORTANCE").equals("M"))ImportantStyle = ";font-weight:bold;color:#000000;";
						%>
							<tr edit="false" class="<%=sTRClass%>" PIPING_IO_ID="<%=mapResult.get("PIPING_IO_ID")%>" PROJECT="DB" OWNER="<%=mapResult.get("OWNER")%>" APP0="<%=mapResult.get("APP0")%>" APP1="<%=mapResult.get("APP1")%>" APP2="<%=mapResult.get("APP2")%>" STATUS="<%=mapResult.get("STATUS")%>" >
								<td class="data_fix" align="center" alias="chk" >
									<input type="checkbox" onclick="checkDataShow(this)" name="chkData" value="<%=mapResult.get("PIPING_IO_ID")%>">
								</td>
								<td class="data" align="center" alias="SHIPTYPE" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:50<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("SHIPTYPE")%></textarea>
								</td>
								<td class="data" align="center" alias="AREA" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:100<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("AREA")%></textarea>
								</td>
								<td class="data" align="center" alias="SYSTEM" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:100<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("SYSTEM")%></textarea>
								</td>
								<td class="data" align="center" alias="ITEM" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:100<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("ITEM")%></textarea>
								</td>
								<td class="data" align="center" alias="DETAILS" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:150<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("DETAILS")%></textarea>
								</td>
								<td class="data" align="center" alias="CONDERATIONS" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:150<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("CONDERATIONS")%></textarea>
								</td>
								<td class="data" align="center" alias="OUTPUT" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:100<%=ImportantStyle%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("OUTPUT")%></textarea>
								</td>
								<td class="data" align="center" alias="DESIGN_BASIS" checkEdit="true">
									<textarea rows="4"  class="inputtrans" style="width:100" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("DESIGN_BASIS")%></textarea>
								</td>
								<td class="data" align="center" alias="ACTIVITY" checkEdit="true">
									<textarea rows="4" class="inputtrans" style="width:300" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" ><%=mapResult.get("ACTIVITY")%></textarea>
								</td>
								<td class="data" align="center" alias="DESIGN_GUIDANCE" ondblclick="fnGetFileView('DB','<%=mapResult.get("PIPING_IO_ID")%>')"  >
									<%=mapResult.get("CNT_FILE")%>
								</td>
								<td class="data" align="center" alias="OWNER_NM" >
									<%=mapResult.get("OWNER_NM")%>
									<BR>
									<%=mapResult.get("APPROVED_DATE0")%>
								</td>
								<td class="data" align="center" alias="APP0_NM" >
									<%=mapResult.get("APP0_NM")%>
									<BR>
									<%=mapResult.get("APPROVED_DATE1")%>
								</td>
								<td class="data" align="center" alias="APP1"  checkEdit="true" >
									<input type="text" alias="APP1"  value="<%=(mapResult.get("APP1") == null ||mapResult.get("APP1").equals(""))?"":mapResult.get("APP1")+"|"+mapResult.get("APP1_NM")%>" onkeydown="fnSetPreVal(this)" onkeyup="fnCheckPostVal(this)" size="12">
									<input type="button" value="사용자 검색" onclick="fnChangeDesigner(this,'DB','<%=mapResult.get("PIPING_IO_ID")%>')">
								</td>
								<td class="data" align="center" alias="EVENT" checkEdit="true">
									<select onchange="fnSetRowEdit(this)">
									<option value=""></option>
									<option value="SC" <%if("SC".equals(mapResult.get("EVENT"))){%>selected<%}%>>SC</option>
									<option value="KL" <%if("KL".equals(mapResult.get("EVENT"))){%>selected<%}%>>KL</option>
									<option value="LC" <%if("LC".equals(mapResult.get("EVENT"))){%>selected<%}%>>LC</option>
									<option value="DL" <%if("DL".equals(mapResult.get("EVENT"))){%>selected<%}%>>DL</option>
									<option value="DS" <%if("DS".equals(mapResult.get("EVENT"))){%>selected<%}%>>DS</option>
									<option value="생산" <%if("생산".equals(mapResult.get("EVENT"))){%>selected<%}%>>생산</option>
									</select>
								</td>
								<td class="data" align="center" alias="FACTOR" checkEdit="true">
									<select onchange="fnSetRowEdit(this)">
									<option value=""></option>
									<%for(int inx=-50;inx<11;inx++){ %>
										<option value="<%=inx%>" <%if((inx+"").equals(mapResult.get("FACTOR"))){%>selected<%}%>><%=inx%></option>
									<%}%>
									</select>
								</td>
								<td class="data" align="center" alias="IMPORTANCE" checkEdit="true">
									<select onchange="fnSetRowEdit(this)">
									<option value=""></option>
									<option value="H" <%if("H".equals(mapResult.get("IMPORTANCE"))){%>selected<%}%>>H</option>
									<option value="M" <%if("M".equals(mapResult.get("IMPORTANCE"))){%>selected<%}%>>M</option>
									<option value="L" <%if("L".equals(mapResult.get("IMPORTANCE"))){%>selected<%}%>>L</option>
									</select>
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
