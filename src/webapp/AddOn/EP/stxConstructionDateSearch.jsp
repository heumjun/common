<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%
	ArrayList mlList = new ArrayList();
	
	String processUrl = request.getParameter("processUrl");
	String postFunction = request.getParameter("postFunction");
	String postFunctionParam = request.getParameter("postFunctionParam");
	String PROJECTNO = request.getParameter("PROJECTNO");

	String sParam = "";
	Enumeration enum1 =  request.getParameterNames();
	while(enum1.hasMoreElements())
	{
		String sParamName = enum1.nextElement().toString();
		String sValue = request.getParameter(sParamName);
		sParam = sParam + "&" +sParamName + "=" + sValue;
	}
		
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String sLoginUser = (String)loginUser.get("user_id");		
%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%> 
<html>
	<head>
		<title>공정 일정 검색</title>
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
				var doc = document;
				fnCreateHeader(doc.getElementById("dataTable"));
				fnProgressOff();
				doc.attachEvent("onkeydown",fnKeyDown)
				doc = null;
			}
			
			function fnKeyDown(oEvent)
			{
				if(oEvent.keyCode == 13)
				{
					fnSearch();
				}
			}
			
			function fnSaveHiddenSubmit(oParent)
			{
				for(var i=0;i<oParent.children.length;i++)
				{
					submitForm.appendChild(fnAddHiddenInput(oParent.children[i].name,oParent.children[i].value))
				}
			}
			
			function fnDone()
			{
				var vParam = "";
				var arrRowCheck = getCheckBoxArray("mainRowCheck")
				var checkLength = 0;
				for(var i=0;i<arrRowCheck.length;i++)
				{
					if(arrRowCheck[i].checked)
					{
						vParam += fnGetParam(arrRowCheck[i].parentNode);
						vParam += fnGetRowDataUrl(arrRowCheck[i].parentNode);
						checkLength++;
					}
				}
				
				if(checkLength < 1)
				{
					alert("추가 하실 Item을 선택해주십시요.");
					return ;
				}
			}
			
			function fnSearch()
			{
				fnProgressOn();
				
				if(searchForm.BLOCKNO.value == '')
				{
					alert("검색할 BLOCK을 넣어주십시요.")
					fnProgressOff();
					return;
				}
				
				var url = "stxSelectSempleSearchAjax.jsp?&mode=getConstructionDate";
				url += "&PROJECTNO=" + searchForm.PROJECTNO.value.encodeURI();
				url += "&BLOCKNO=" + searchForm.BLOCKNO.value.encodeURI();
				url += "&ACTIVITYDESC=" + searchForm.ACTIVITYDESC.value.encodeURI();
				url += "&FACTOR=" + searchForm.FACTOR.value.encodeURI();
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				
				var nodeResult = vReturn.getElementsByTagName("RESULTRECORD");
				
				var doc = document;
				fnRemoveTblAll(doc.getElementById("dataTable"));
				fnCreateHeader(doc.getElementById("dataTable"));
				for(var index=0 ;index<nodeResult.length;index++)
				{
					var nodeColumn = nodeResult[index];
					
					var ACTIVITYDESC 		= fnGetDocRecordValue(nodeColumn,"ACTIVITYDESC");
					var BLOCKNO 			= fnGetDocRecordValue(nodeColumn,"BLOCKNO");
					var PLANSTARTDATE 		= fnGetDocRecordValue(nodeColumn,"PLANSTARTDATE");
					var PLANFINISHDATE 		= fnGetDocRecordValue(nodeColumn,"PLANFINISHDATE");
					var BUILDING_TAG 		= fnGetDocRecordValue(nodeColumn,"BUILDING_TAG");
					var BUILDING_TAG_DESC 	= fnGetDocRecordValue(nodeColumn,"BUILDING_TAG_DESC");
					
					fnCreateData(doc.getElementById("dataTable"),ACTIVITYDESC,BLOCKNO,PLANSTARTDATE,PLANFINISHDATE,BUILDING_TAG_DESC)
					nodeColumn = null;
					ACTIVITYDESC = null;
					BLOCKNO = null;
					PLANSTARTDATE = null;
					PLANFINISHDATE = null;
					BUILDING_TAG = null;
					BUILDING_TAG_DESC = null;
				}
				
				doc = null;
				url = null;
				objAjax = null;
				vReturn = null;
				nodeResult = null;
				fnProgressOff();
			}
			
			function fnCreateHeader(oTbl)
			{
				var doc = document;
				var oRow = oTbl.insertRow(oTbl.rows.length);
				addNewCellSimple(oRow.insertCell(),"공정명","td_header","20%");
				addNewCellSimple(oRow.insertCell(),"BLOCK","td_header","10%");
				if(searchForm.START_FINISH_FIX.value=="S")addNewCellSimple(oRow.insertCell(),"계획시작일","td_header","20%");
				if(searchForm.START_FINISH_FIX.value=="F")addNewCellSimple(oRow.insertCell(),"계획종료일","td_header","20%");
				doc = null;
				oTbl = null;
				oRow = null;
			}
			
			function fnondblclick(oEvent)
			{
				var oObj = oEvent.srcElement;
				fnProgressOn();
				var vProcessURL = "<%=processUrl%>";
				var vPostFunction = "<%=postFunction%>";
				if(!vProcessURL || vProcessURL == "null" || vProcessURL == "")
				{
					var vReturn = "";
					if(searchForm.START_FINISH_FIX.value=="S")vReturn = oObj.parentNode.PLANSTARTDATE;
					if(searchForm.START_FINISH_FIX.value=="F")vReturn = oObj.parentNode.PLANFINISHDATE;
					if(vPostFunction && vPostFunction != "null" && vPostFunction != "")eval("opener.<%=postFunction%>('<%=postFunctionParam%>','"+vReturn+"')")
					fnProgressOff();
					window.close();
					oObj = null;
					oEvent = null;
					return;
				}
				var url = "<%=processUrl%>.jsp?&USER_ID="+oObj.parentNode.value;
				url += "<%=sParam%>";
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				
				objAjax = null;
				
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("완료 되었습니다.")
					eval("opener.<%=postFunction%>('<%=postFunctionParam%>','"+oObj.parentNode.value+"')")
					fnProgressOff();
					vReturn = null;
					oObj = null;
					oEvent = null;
					window.close();
				} else {
					alert(fnGetDocRecordValue(vReturn.documentElement,"errorMsg"));
					vReturn = null;
					oObj = null;
					oEvent = null;
					fnProgressOff();
				}
				vReturn = null;
				oObj = null;
				oEvent = null;
			}
			
			function fnonmouseover(oEvent)
			{
				var oObj = oEvent.srcElement.parentNode;
				oObj.backup = oObj.style.backgroundColor;
				oObj.style.backgroundColor='#efd6d1'
				oObj = null;
				oEvent = null;
			}
			
			function fnonmouseout(oEvent)
			{
				var oObj = oEvent.srcElement.parentNode;;
				oObj.style.backgroundColor=oObj.backup
				oObj = null;
				oEvent = null;
			}
			
			function fnCreateData(oTbl,ACTIVITYDESC,BLOCKNO,PLANSTARTDATE,PLANFINISHDATE,BUILDING_TAG_DESC)
			{
				var doc = document;
				var rownum = oTbl.rows.length;
				var oRow = oTbl.insertRow(rownum);
				
				var trClass = "odd";
                if(rownum%2==0)
                {
                	trClass = "even";
                }
                oRow.className = trClass;
                oRow.attachEvent("ondblclick",fnondblclick)
                oRow.attachEvent("onmouseover",fnonmouseover)
                oRow.attachEvent("onmouseout",fnonmouseout)
				oRow.ACTIVITYDESC = ACTIVITYDESC;
				oRow.BLOCKNO = BLOCKNO;
				oRow.PLANSTARTDATE = PLANSTARTDATE;
				oRow.PLANFINISHDATE = PLANFINISHDATE;
				oRow.BUILDING_TAG_DESC = BUILDING_TAG_DESC;
				addNewCellSimple(oRow.insertCell(),ACTIVITYDESC,"data",null,"left");
				addNewCellSimple(oRow.insertCell(),BLOCKNO,"data");
				if(searchForm.START_FINISH_FIX.value=="S")addNewCellSimple(oRow.insertCell(),PLANSTARTDATE,"data");
				if(searchForm.START_FINISH_FIX.value=="F")addNewCellSimple(oRow.insertCell(),PLANFINISHDATE,"data");
				rownum = null;
				doc = null;
				oTbl = null;
				oRow = null;
				ACTIVITYDESC = null;
				BLOCKNO = null;
				PLANSTARTDATE = null;
				PLANFINISHDATE = null;
				BUILDING_TAG_DESC = null;
			}
			
			function fnRemoveTblAll(oTbl)
			{
				for(i=oTbl.rows.length-1;i>-1;i--)
				{
					oTbl.deleteRow(i)
				}
				i = null;
				oTbl = null;
			}
			
			function fnSelectOptionAllSerial(oSelect)
			{
				var vReturn = "";
				for(var i=0;i<oSelect.options.length;i++)
				{
					vReturn += (vReturn=='')?oSelect.options[i].value:"|"+oSelect.options[i].value;
				}
				return vReturn;
			}
			
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
		<%
			ArrayList mlButton = new ArrayList();
			setButtonRenderer(mlButton,"조회","fnSearch()");
		%>
		<%=setPageHeaderRenderer("공정 일정 검색",mlButton)%>
		<form name="searchForm" onSubmit="return false;">
			<table width="100%">
				<tr><td class="requiredNotice" align="center" nowrap  >
				</td></tr>
			</table>
			<table border="0" cellspacing="2" cellpadding="3" width="100%">
				<tr>
					<td class="labelRequired">
						호선
					</td>
					<td class="field">
						<input TYPE="text" name="PROJECTNO" size="10" value="<%=PROJECTNO%>" readonly >
					</td>
					<td class="label">
						BLOCK
					</td>
					<td class="field">
						<input TYPE="text" name="BLOCKNO" size="10" >
					</td>
					<td class="label">
						FACTOR
					</td>
					<td class="field">
						<select name="FACTOR" >
							<%for(int inx=-20;inx<21;inx++){ %>
								<option value="<%=inx%>" <%if(inx==0){%>selected<%}%>><%=inx%></option>
							<%}%>
						</select>
					</td>
				</tr>
				<tr>
					<td class="label">
						공정
					</td>
					<td class="field" colspan="5">
						<input TYPE="text" name="ACTIVITYDESC" size="30">
						<input type="radio" name="START_FINISH" value="S" onclick="if(this.checked)searchForm.START_FINISH_FIX.value='S'" CHECKED>시작
						<input type="radio" name="START_FINISH" value="F" onclick="if(this.checked)searchForm.START_FINISH_FIX.value='F'" >종료
						<input type="hidden" name="START_FINISH_FIX" value="S">
					</td>
				</tr>
			</table>
		</form>
 		<form name="listForm" method="post">
		<input type="hidden" value="" name="DesId" id="DesId">
			<table>
				<tr><td>
					<div id="listDiv" STYLE="width:100%; height:280; overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
         				<table id="dataTable" width="550" cellSpacing="1" cellpadding="0" border="0" align="left" style="table-layout:fiexed;">
						</table>
					</div>
				</td></tr>
			</table>
			<table id="hiddenTable">
				<tr id="hiddenRow">
				</tr>
			</table>
		</form>
		<%
			ArrayList mlFooterButton = new ArrayList();
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"추가","fnDone()","../common/images/buttonSearchNext.gif");
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"취소","top.close()","../common/images/buttonSearchCancel.gif");
		%>
		<%=setPageFooterRenderer(mlFooterButton)%>
	</body>
	<form name="submitForm" action="">
	</form>
</html>
