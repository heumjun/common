<%@include file="include/stx_renderer.jspf"%>
<%@include file="include/stx_jdbc_util.jspf"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%request.setCharacterEncoding("euc-kr");%>
<%!
%>
<%	
	Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String USER = (String)loginUser.get("user_id");
	Map mapParam = new HashMap();
	mapParam.put("EMPLOYEE_NUM",USER);
	ArrayList mlDept = SQLSourceUtil.executeSelect("SDPS","PRJCPOINT.selectUserDept",mapParam);
	String sDWGDept = "";
	if(mlDept.size() > 0)
	{
		sDWGDept = (String)((HashMap)mlDept.get(0)).get("DWGDEPTCODE");
	}
%>
<script type="text/javascript">
</script>
<%@page import="java.util.*"%>
<%@page import="com.stx.common.interfaces.DBConnect"%>
<%@page import="com.stx.common.interfaces.SQLSourceUtil"%>
<html>
	<head>
		<title>Project Design I/O Data Management</title>
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
				searchForm.DWGDEPTCODE.value = '<%=sDWGDept%>';
				fnProgressOff();
			}
			
			function fnSearch(vPage)
			{
				fnProgressOn();
				var vUrl = "stxPipingIOList.jsp?";
				vUrl += "&PROJECT="+searchForm.PROJECT.value.encodeURI();
				vUrl += "&OUTPUT="+searchForm.OUTPUT.value.encodeURI();
				vUrl += "&AREA="+searchForm.AREA.value.encodeURI();
				vUrl += "&ACTIVITY="+searchForm.ACTIVITY.value.encodeURI();
				vUrl += "&ITEM="+searchForm.ITEM.value.encodeURI();
				vUrl += "&SYSTEM="+searchForm.SYSTEM.value.encodeURI();
				vUrl += "&DWGDEPTCODE="+searchForm.DWGDEPTCODE.value.encodeURI();
				vUrl += "&DESCRIPTION="+searchForm.DESCRIPTION.value.encodeURI();
				vUrl += "&SORTCOL="+searchForm.SORTCOL.value.encodeURI();
				vUrl += "&QUERYON=true";
				if(vPage)
				{
					vUrl += "&currentPage=" + vPage;
				}
				parent.listFrame.location.href = vUrl;
			}
			
		  	function fnExcelUp(){
		  		showModalDialog("stxPipingIOExcelUpload.jsp", 600, 300);
		  	}
		  	
		  	function fnApplyProject()
		  	{
		  		showModalDialog("stxPipingIOApplyProject.jsp", 300, 300);
		  	}
		  	
		  	function fnSave()
			{
				var param = parent.listFrame.fnEditDataParam();
				if(param == "")
				{
					alert("���������� �����ϴ�.")
					return;
				}
				fnProgressOn();
				
				var objAjax = new stxAjax("stxPipingIOAjax.jsp?mode=editPIPINGIO");
				objAjax.setPost();
				var vReturn = objAjax.executeSync(true,param);
				
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("���� �Ǿ����ϴ�.")
					fnSetDefaultOption();
					fnSearch();
				} else {
					alert(fnGetDocRecordValue(vReturn.documentElement,"errorMsg"));
					fnSearch();
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
				var DWGDEPTCODE = searchForm.DWGDEPTCODE.value;
				var OUTPUT = searchForm.OUTPUT.value;
				var AREA = searchForm.AREA.value;
				var PROJECT = searchForm.PROJECT.value;
				var SYSTEM = searchForm.SYSTEM.value;
				var ITEM = searchForm.ITEM.value;
				
				fnRemoveAllOptionSelect(searchForm.DWGDEPTCODE)
				fnGetOption(searchForm.DWGDEPTCODE,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"DWGDEPTCODE");
				fnRemoveAllOptionSelect(searchForm.OUTPUT)
				fnGetOption(searchForm.OUTPUT,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"OUTPUT");
				fnRemoveAllOptionSelect(searchForm.AREA)
				fnGetOption(searchForm.AREA,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"AREA");
				fnRemoveAllOptionSelect(searchForm.PROJECT)
				fnGetOption(searchForm.PROJECT,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"PROJECT");
				fnRemoveAllOptionSelect(searchForm.SYSTEM)
				fnGetOption(searchForm.SYSTEM,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"SYSTEM");
				fnRemoveAllOptionSelect(searchForm.ITEM)
				fnGetOption(searchForm.ITEM,"stxPipingIOAjax.jsp?mode=selectGetIOOption&COL="+"ITEM");
				
				searchForm.DWGDEPTCODE.value = DWGDEPTCODE;
				searchForm.OUTPUT.value = OUTPUT;
				searchForm.AREA.value = AREA;
				searchForm.PROJECT.value = PROJECT;
				searchForm.SYSTEM.value = SYSTEM;
				searchForm.ITEM.value = ITEM;
				
				DWGDEPTCODE = null;
				OUTPUT = null;
				PROJECT = null;
				SYSTEM = null;
				ITEM = null;
				DWGDEPTCODE = null;
			}
			
			function fnApprove(APPROVED_TYPE)
			{
				if(!confirm('���� ���� �Ͻðڽ��ϱ�?'))
				{
					return;
				}
				
				var arrCheck = parent.listFrame.fnChkData();
				if(arrCheck.length==0)
				{
					alert("���ο�û �� ����� �����Ͻʽÿ�.");
					return;
				}
				
				fnProgressOn();
				
				var url = "stxPipingIOAjax.jsp?mode=approvePIPINGIO&ISFIRST=TRUE&APPROVED_TYPE="+APPROVED_TYPE;
				for(var i = 0;i<arrCheck.length;i++)
				{
					url += "&PIPING_IO_ID="+arrCheck[i].parentNode.parentNode.PIPING_IO_ID;
					url += "&PROJECT="+arrCheck[i].parentNode.parentNode.PROJECT;
				}
				
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("ó�� �Ǿ����ϴ�.")
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
			
			function fnWithdraw()
			{
				if(!confirm('���� ȸ�� �Ͻðڽ��ϱ�?'))
				{
					return;
				}
				
				var arrCheck = parent.listFrame.fnChkData();
				if(arrCheck.length==0)
				{
					alert("ȸ�� �� ����� �����Ͻʽÿ�.");
					return;
				}
				
				fnProgressOn();
				
				var url = "stxPipingIOAjax.jsp?mode=withdrawPIPINGIO";
				for(var i = 0;i<arrCheck.length;i++)
				{
					url += "&PIPING_IO_ID="+arrCheck[i].parentNode.parentNode.PIPING_IO_ID;
					url += "&PROJECT="+arrCheck[i].parentNode.parentNode.PROJECT;
				}
				
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("ó�� �Ǿ����ϴ�.")
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
			
			function fnDel()
			{
				if(!confirm('���� �Ͻðڽ��ϱ�?'))
				{
					return;
				}
				
				var arrCheck = parent.listFrame.fnChkData();
				if(arrCheck.length==0)
				{
					alert("������ ����� �����Ͻʽÿ�.");
					return;
				}
				
				fnProgressOn();
				
				var url = "stxPipingIOAjax.jsp?mode=delPIPINGIO";
				for(var i = 0;i<arrCheck.length;i++)
				{
					url += "&PIPING_IO_ID="+arrCheck[i].parentNode.parentNode.PIPING_IO_ID;
					url += "&PROJECT="+arrCheck[i].parentNode.parentNode.PROJECT;
				}
				
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("���� �Ǿ����ϴ�.")
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
			
			function fnExcelDown(){
		  		var vUrl = "stxPipingIOExcelDown.jsp?QUERYON=true";
				vUrl += "&PROJECT="+searchForm.PROJECT.value.encodeURI();
				vUrl += "&OUTPUT="+searchForm.OUTPUT.value.encodeURI();
				vUrl += "&AREA="+searchForm.AREA.value.encodeURI();
				vUrl += "&ACTIVITY="+searchForm.ACTIVITY.value.encodeURI();
				vUrl += "&ITEM="+searchForm.ITEM.value.encodeURI();
				vUrl += "&SYSTEM="+searchForm.SYSTEM.value.encodeURI();
				vUrl += "&DWGDEPTCODE="+searchForm.DWGDEPTCODE.value.encodeURI();
				vUrl += "&DESCRIPTION="+searchForm.DESCRIPTION.value.encodeURI();
				vUrl += "&SORTCOL="+searchForm.SORTCOL.value.encodeURI();
				vUrl += "&QUERYON=true";
		  		showModalDialog(vUrl, 300, 300);
		  	}
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
	<%
		ArrayList mlButton = new ArrayList();
		mlButton = setButtonRenderer(mlButton,"��ȸ","fnSearch()");
		mlButton = setButtonRenderer(mlButton,"����","fnSave()");
		mlButton = setButtonRenderer(mlButton,"����","fnDel()");
		mlButton = setButtonRenderer(mlButton,"������ �ϰ� ����","parent.listFrame.fnChangeDesignerAll()");
		mlButton = setButtonRenderer(mlButton,"���� ���� ����","parent.listFrame.fnRefConstructionDate()");
		mlButton = setButtonRenderer(mlButton,"<img src='../common/images/iconActionPromote.gif' border='0' alt='���ο�û' vspace='0'>","fnApprove('APPROVE')",true);
		mlButton = setButtonRenderer(mlButton,"<img src='../common/images/iconActionDemote.gif' border='0' alt='����ȸ��' vspace='0'>","fnWithdraw()",false);
		mlButton = setButtonRenderer(mlButton,"<img src='../common/images/buttonContextExport.gif' border='0' alt='' vspace='0'>","fnExcelDown()",false);
	%>
	<%=setPageHeaderRenderer("Project Design I/O Data Management",mlButton)%>
		<table border="0" cellspacing="2" cellpadding="0" width="100%">
			<tr>
				<td width="99%">
					<form id="searchForm" method="post">
						<table border="0" cellspacing="2" cellpadding="3" width="100%">
							<input type="hidden" name="hidden" value="">
							<tr>
								<td class="label">
									ȣ��
								</td>
								<td class="field">
									<select name="PROJECT" style="width:200px;height:15px;">
									</select>
								</td>
								<td class="label">
									AREA
								</td>
								<td class="field">
									<select name="AREA" style="width:200px;height:15px;">
									</select>
								</td>
								<td class="label">
									SYSTEM
								</td>
								<td class="field">
									<select name="SYSTEM" style="width:200px;height:15px;">
									</select>
								</td>
							</tr>
							<tr>
								<td class="label">
									ITEM
								</td>
								<td class="field">
									<select name="ITEM" style="width:350px;height:15px;">
									</select>
								</td>
								<td class="label">
									OUTPUT DATA
								</td>
								<td class="field">
									<select name="OUTPUT" style="width:350px;height:15px;">
									</select>
								</td>
								<td class="label">
									ACTIVITY
								</td>
								<td class="field">
									<input type="text" name="ACTIVITY" style="width:200px;height:15px;" value="">
								</td>
							</tr>
							<tr>
								<td class="label">
									�μ�
								</td>
								<td class="field" >
									<select name="DWGDEPTCODE" style="width:200px;height:15px;">
									</select>
								</td>
								<td class="label">
									DESCRIPTION
								</td>
								<td class="field">
									<input type="text" name="DESCRIPTION" style="width:200px;height:15px;" value="">
								</td>
								<td class="label">
									SORTING ����
								</td>
								<td class="field">
									<select	name="SORTCOL" style="width:200px;">
										<option value="DEFAULT"></option>
										<option value="PROJECT">PROJECT</option>
										<option value="AREA">AREA</option>
										<option value="SYSTEM">SYSTEM</option>
										<option value="ITEM">ITEM</option>
										<option value="DETAILS">DETAILS</option>
										<option value="CONDERATIONS">CONDERATIONS</option>
										<option value="OUTPUT">OUTPUT</option>
										<option value="DESIGN_BASIS">DESIGNBASIS</option>
										<option value="ACTIVITY">ACTIVITY</option>
										<option value="DUE_DATE">DUE DATE</option>
										<option value="DESCRIPTION">DESCRIPTION</option>
										<option value="STATUS">���α���</option>
									</select>
								</td>
							</tr>
						</table>
						</table>
					</form>
				</td>
			</tr>
		</table>
	</body>
</html>
<iframe id="headerHidden" name="headerHidden" style="display:none"></iframe>