<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%
	ArrayList mlList = new ArrayList();
	
	String processUrl = request.getParameter("processUrl");
	String postFunction = request.getParameter("postFunction");
	String postFunctionParam = request.getParameter("postFunctionParam");

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
	Map mapParam = new HashMap();
	mapParam.put("EMPLOYEE_NUM",sLoginUser);
	ArrayList mlDept = SQLSourceUtil.executeSelect("SDPS","PRJCPOINT.selectUserDept",mapParam); 
	String sDWGDept = "";
	if(mlDept.size() > 0)
	{
		sDWGDept = (String)((HashMap)mlDept.get(0)).get("DWGDEPTCODE");
	}
%>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%>
<html>
	<head>
		<title>담당자 지정/변경</title>
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
				fnGetDept("<%=sDWGDept%>");
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
			
			function fnGetDept(DEFAULT_CODE)
			{
				searchForm.DWGDEPTCODE.options[0] = new Option("","");
				fnGetOption(searchForm.DWGDEPTCODE,"stxSelectSempleSearchAjax.jsp?mode=getDwgDept&condition=",DEFAULT_CODE);
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
				
				if(searchForm.NAME.value == '' && searchForm.DWGDEPTCODE.value == '')
				{
					alert("검색 조건을 넣어 주십시요.")
					return;
				}
				
				var url = "stxSelectSempleSearchAjax.jsp?&mode=getDPUser";
				url += "&NAME=" + searchForm.NAME.value.encodeURI();
				url += "&DWGDEPTCODE=" + searchForm.DWGDEPTCODE.value.encodeURI();
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				
				var nodeResult = vReturn.getElementsByTagName("RESULTRECORD");
				
				var doc = document;
				fnRemoveTblAll(doc.getElementById("dataTable"));
				fnCreateHeader(doc.getElementById("dataTable"));
				for(var index=0 ;index<nodeResult.length;index++)
				{
					var nodeColumn = nodeResult[index];
					
					var ATTRIBUTE1 			= fnGetDocRecordValue(nodeColumn,"ATTRIBUTE1");
					var NAME 			= fnGetDocRecordValue(nodeColumn,"NAME");
					var EMPLOYEE_NUM 	= fnGetDocRecordValue(nodeColumn,"EMPLOYEE_NUM");
					var POSITION 	= fnGetDocRecordValue(nodeColumn,"POSITION");
					var DWGDEPTNM 	= fnGetDocRecordValue(nodeColumn,"DWGDEPTNM");
					
					fnCreateData(doc.getElementById("dataTable"),ATTRIBUTE1,NAME,EMPLOYEE_NUM,POSITION,DWGDEPTNM)
					nodeColumn = null;
					ATTRIBUTE1 = null;
					NAME = null;
					EMPLOYEE_NUM = null;
					POSITION = null;
					DWGDEPTNM = null;
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
				addNewCellSimple(oRow.insertCell(),"소속","td_header","20%");
				addNewCellSimple(oRow.insertCell(),"직급","td_header","10%");
				addNewCellSimple(oRow.insertCell(),"성명","td_header","20%");
				addNewCellSimple(oRow.insertCell(),"내선번호","td_header","20%");
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
					if(vPostFunction && vPostFunction != "null" && vPostFunction != "")eval("opener.<%=postFunction%>('<%=postFunctionParam%>','"+oObj.parentNode.value+"|"+oObj.parentNode.EMPLOYEE_NAME+"')")
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
			
			function fnCreateData(oTbl,ATTRIBUTE1,NAME,EMPLOYEE_NUM,POSITION,DWGDEPTNM)
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
				oRow.value = EMPLOYEE_NUM;
				oRow.EMPLOYEE_NAME = NAME;
				addNewCellSimple(oRow.insertCell(),DWGDEPTNM,"data");
				addNewCellSimple(oRow.insertCell(),POSITION,"data");
				addNewCellSimple(oRow.insertCell(),NAME,"data");
				addNewCellSimple(oRow.insertCell(),ATTRIBUTE1,"data");
				rownum = null;
				doc = null;
				oTbl = null;
				oRow = null;
				DWGDEPTNM = null;
				POSITION = null;
				NAME = null;
				ATTRIBUTE1 = null;
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
		<%=setPageHeaderRenderer("담당자 지정/변경",mlButton)%>
		<form name="searchForm" onSubmit="return false;">
			<table border="0" cellspacing="2" cellpadding="3" width="100%">
				<tr>
					<td class="labelRequired">
						부서
					</td>
					<td class="field">
						<select name="DWGDEPTCODE"	style="width:180px; background-color:#FFFFFF;" onchange="">
						</select>
					</td>
					<td class="label">
						이름
					</td>
					<td class="field">
						<input TYPE="text" name="NAME" >
					</td>
				</tr>
			</table>
		</form>
 		<form name="listForm" method="post">
		<input type="hidden" value="" name="DesId" id="DesId">
			<table>
				<tr><td>
					<div id="listDiv" STYLE="width:100%; height:280; overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
         				<table id="dataTable" width="500" cellSpacing="1" cellpadding="0" border="0" align="left" style="table-layout:fiexed;">
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
