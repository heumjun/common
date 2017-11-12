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
				fnCreateHeader(document.getElementById("dataTable"))
				fnSearch()
				fnProgressOff();
			}
			
			function fnDone()
			{
				fnProgressOn();
				searchForm.target = "UploadHiddenFrame";
				searchForm.action = "stxPipingIOFileUploadProcess.jsp";
				searchForm.submit();
			}
			
			function fnDownLoad()
			{
				
			}
			
			function fnCreateHeader(oTbl)
			{
				var doc = document;
				var oRow = oTbl.insertRow(oTbl.rows.length);
				addNewCellSimple(oRow.insertCell(),"NO.","td_header","10%");
				addNewCellSimple(oRow.insertCell(),"파일명","td_header","40%");
				addNewCellSimple(oRow.insertCell(),"일시","td_header","10%");
				addNewCellSimple(oRow.insertCell(),"담당자","td_header","10%");
				addNewCellSimple(oRow.insertCell(),"삭제","td_header","10%");
				doc = null;
				oTbl = null;
				oRow = null;
			}
			
			function fnSearch()
			{
				fnProgressOn();
				var url = "stxPipingIOAjax.jsp?&mode=getPipingIOFile";
				url += "&PIPING_IO_ID=" + searchForm.PIPING_IO_ID.value;
				url += "&PROJECT=" + searchForm.PROJECT.value;
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				var nodeResult = vReturn.getElementsByTagName("RESULTRECORD");
				
				var doc = document;
				fnRemoveTblAll(doc.getElementById("dataTable"));
				fnCreateHeader(doc.getElementById("dataTable"));
				for(var index=0 ;index<nodeResult.length;index++)
				{
					var nodeColumn = nodeResult[index];
					
					var PROJECT 		= fnGetDocRecordValue(nodeColumn,"PROJECT");
					var PIPING_IO_ID 	= fnGetDocRecordValue(nodeColumn,"PIPING_IO_ID");
					var FILEID 			= fnGetDocRecordValue(nodeColumn,"FILEID");
					var FILENAME 		= fnGetDocRecordValue(nodeColumn,"FILENAME");
					var CREATED_DATE	= fnGetDocRecordValue(nodeColumn,"CREATED_DATE");
					var CREATED_BY 		= fnGetDocRecordValue(nodeColumn,"CREATED_BY");
					var CREATED_NAME 	= fnGetDocRecordValue(nodeColumn,"CREATED_NAME");
					
					fnCreateData(doc.getElementById("dataTable"),PROJECT,PIPING_IO_ID,FILEID,FILENAME,CREATED_DATE,CREATED_BY,CREATED_NAME)
					nodeColumn = null;
					FILE_NAME = null;
					FILE_ID = null;
					PROJECT_NO = null;
					ACTIVITY_CODE = null;
					CREATOR = null;
					CREATION_DATE = null;
				}
				
				doc = null;
				url = null;
				objAjax = null;
				vReturn = null;
				nodeResult = null;
				fnProgressOff();
			}
			
			function fnCreateData(oTbl,PROJECT,PIPING_IO_ID,FILEID,FILENAME,CREATED_DATE,CREATED_BY,CREATED_NAME)
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
				addNewCellSimple(oRow.insertCell(),rownum,"data");
				addNewCellSimple(oRow.insertCell(),"<a href=\"javascript:fnDownLoadFile('"+FILEID+"')\">"+FILENAME+"</a>","data");
				addNewCellSimple(oRow.insertCell(),CREATED_DATE,"data");
				addNewCellSimple(oRow.insertCell(),CREATED_NAME,"data");
				addNewCellSimple(oRow.insertCell(),"<img src=\"../common/images/iconActionDelete.gif\" onclick=\"fnDeleteFile('"+FILEID+"')\" border=\"0\" alt=\"\"  vspace=\"0\">","data");
				rownum = null;
				doc = null;
				oTbl = null;
				oRow = null;
				oTbl = null;
				PROJECT = null;
				PIPING_IO_ID = null;
				FILEID = null;
				FILENAME = null;
				CREATED_DATE = null;
				CREATED_BY = null;
				CREATED_NAME = null;
			}
			
			function fnDownLoadFile(FILEID)
			{
				var attURL = "stxPipingIOFileView.jsp?FILEID="+FILEID;
				showModalDialog(attURL,50,50);
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
			
			function fnDeleteFile(FILEID)
			{
				var url = "stxPipingIOAjax.jsp?&mode=deleteFile";
				url += "&FILEID=" + FILEID;
				var objAjax = new stxAjax(url);
				var vReturn = objAjax.executeSync(true);
				objAjax = null;
				
				if(fnGetDocRecordValue(vReturn.documentElement,"isSuccess") == "true")
				{
					alert("삭제 되었습니다.")
					fnSearch()
				} else {
					alert(fnGetDocRecordValue(vReturn.documentElement,"errorMsg"));
				}
				
				vReturn = null;
			}
	</script>
	</head>
	<body topmargin="10" marginheight="10" onload="fnOnload()">
		<%
			ArrayList mlButton = new ArrayList();
			mlButton = setButtonRenderer(mlButton,"조회","fnSearch()");
		%>
		<%=setPageHeaderRenderer("File Upload",mlButton)%>
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
									<input type="hidden" name="PIPING_IO_ID" value="<%=request.getParameter("PIPING_IO_ID")%>">
									<input type="hidden" name="PROJECT" value="<%=request.getParameter("PROJECT")%>">
									<input type="button" value="Upload" onclick="fnDone()">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<form name="listForm" method="post">
		<input type="hidden" value="" name="DesId" id="DesId">
			<table>
				<tr><td>
					<div id="listDiv" STYLE="width:100%; height:200; overflow-x:scroll;overflow-y:scroll;  left:1; top:20;"> 
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
			mlFooterButton = setFooterButtonRenderer(mlFooterButton,"취소","top.close()","../common/images/buttonSearchCancel.gif");
		%>
		<%=setPageFooterRenderer(mlFooterButton)%>
	</body>
</html>
<iframe id="UploadHiddenFrame" name="UploadHiddenFrame" style="display:none"></iframe>
