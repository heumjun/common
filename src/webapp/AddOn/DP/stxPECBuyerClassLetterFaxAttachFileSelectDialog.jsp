
<%
	String languageStr 	= request.getHeader("Accept-Language");
	String refNo 		= request.getParameter("refNo");
	String mode 		= request.getParameter("mode");
%>	
<script language="JavaScript" type="text/javascript" src="scripts/stxHeader.js"></script>
<script language="javascript">

	isDone = false;
	function doSubmit() 
	{
		
		var jsFile = document.importForm.fileName0.value;
		if(jsFile==null || jsFile=='') {
			alert("Please select excel file to update.");
			return
		}
		alert("It takes a long time.\\nPlease wait for a while it is completed.");
		document.importForm.btn_Update.disabled = true;
		var objForm = document.importForm;
		objForm.action = "stxPECTPIInterfaceElecCableUpdateDB.jsp";
		objForm.target = "UpdateLower";
		objForm.submit();
		isDone = true;
		//fnProgressOn();
	}

	function checkInput()
	{
		var jsFile = document.importForm.fileName0.value;
		if(jsFile==null || jsFile=='') {
			alert("Please select excel file to update.");
			return
		}
		var fileSplit = jsFile.split(".");
		var fileSplitCnt = fileSplit.size
		
		var refNo = document.importForm.refNo.value;
		var mode = document.importForm.mode.value;
		document.importForm.action = "stxPECBuyerClassLetterFaxAttachFileToFTP.jsp?refNo="+refNo.replace("&","%26")+"&mode="+mode;
		document.importForm.target = "UpdateLower";
		document.importForm.submit();
		isDone = true;
		//fnProgressOn();
		//document.importForm.btn_Update.disabled = false;
		document.importForm.btn_Clear.disabled = true;
		document.importForm.btn_Upload.disabled = true;
	}

	function enableUpload(){
		document.importForm.btn_Upload.disabled = false;
		document.importForm.btn_Clear.disabled = false;
	}

	function clearFile(){


		document.importForm.action = "b.jsp";
		document.importForm.target = "UpdateLower";
		document.importForm.submit();
				
		document.importForm.btn_Clear.disabled = true;
		document.importForm.btn_Upload.disabled = true;
		//document.importForm.btn_Update.disabled = true;
		isDone = true;
		//fnProgressOn();		
	}

	function reset() {
		document.importForm.fileName0.value = "";
		document.importForm.fileName1.value = "";
		document.importForm.fileName2.value = "";
		document.importForm.fileName3.value = "";
		document.importForm.fileName4.value = "";
		document.importForm.fileName5.value = "";
		document.importForm.fileName6.value = "";
		document.importForm.fileName7.value = "";
		document.importForm.fileName8.value = "";
		document.importForm.fileName9.value = "";
		
	}
	
	function closeDialog(){
		top.parent.window.close();
	}
</script>

<!--

<form name="importForm" method="post" action="stxUploadToDB.jsp" target="UpdateLower" onsubmit="javascript:checkInput(); return false"  enctype="multipart/form-data">
-->
<form name="importForm" method="post" action="" target="" onsubmit=""  enctype="multipart/form-data">
	<table width="100%" border="0" cellpadding="0" cellspacing="3">
		<tr>
			<td class="pageHeader" width="70%">Upload <%=refNo%> Document.</td> 
		</tr>
		<tr>
			<td class="inputField">
				<input type="file" size="40" name="fileName0" onclick="javascript:enableUpload()">
		
				<input type="button" name="btn_Upload" value="UPLOAD"  disabled="true" onClick="javascript:checkInput()">
		
				<input type="button" name="btn_Clear" value="CLEAR" disabled="true" onClick="javascript:clearFile();reset();">
				
				<input type="button" name="btn_Close" value="CLOSE" onClick="javascript:closeDialog();">
				
			</td>
		</tr>
		<%if("ref".equals(mode)){ %>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName1" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName2" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName3" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName4" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName5" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName6" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName7" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName8" onclick="javascript:enableUpload()">		
				</td>
			</tr>
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName9" onclick="javascript:enableUpload()">		
				</td>
			</tr>
		<%} %>
	</table>
	<input type="hidden" name="refNo" value="<%=refNo%>">
	<input type="hidden" name="mode" value="<%=mode%>">
</form>

<iframe name="submitFrame" style="display:none"></iframe> 



