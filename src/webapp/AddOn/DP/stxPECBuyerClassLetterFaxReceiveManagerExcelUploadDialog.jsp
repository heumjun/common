
<% 
	String languageStr = request.getHeader("Accept-Language");
%>	

<script language="javascript">
	function checkInput()
	{
		var jsFile = document.importForm.fileName.value;
		if(jsFile==null || jsFile=='') {
			alert("Please select excel file to update.");
			return
		}
		
		document.importForm.btn_Clear.disabled = false;
		document.importForm.btn_Upload.disabled = true;
		
		document.importForm.action = "stxPECBuyerClassLetterFaxReceiveManagerExcelUploadToDB.jsp";
		document.importForm.target = "UpdateLower";
		
		document.importForm.submit();
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
	}

	function reset() {
		document.importForm.fileName.value = "";
	}	

</script>

<form name="importForm" method="post" action="stxPECBuyerClassLetterFaxReceiveManagerExcelUploadToDB.jsp" target="" onsubmit=""  enctype="multipart/form-data">
<table width="100%" border="0" cellpadding="0" cellspacing="3">
<tr>
	<td class="pageHeader" width="70%">Upload Buyer Class Receive Data.</td> 
</tr>
<tr>
	<td class="inputField">
		<input type="file" size="40" name="fileName" onClick="javascript:enableUpload()">
		
		<input type="button" name="btn_Upload" style="WIDTH: 80pt; HEIGHT: 15pt" value="UPLOAD"  disabled="true" onClick="javascript:checkInput()">
		
		<input type="button" name="btn_Clear" style="WIDTH: 70pt; HEIGHT: 15pt" value="CLEAR" disabled="true" onClick="javascript:clearFile();reset();">
		
		<input type="button" value="CLOSE" style="WIDTH: 70pt; HEIGHT: 15pt" onclick="parent.window.close()">
	</td>
</tr>
</table>
</form>
</body>


