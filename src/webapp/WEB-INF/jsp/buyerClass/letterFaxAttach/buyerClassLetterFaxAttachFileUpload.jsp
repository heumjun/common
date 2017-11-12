<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page contentType="text/html; charset=utf-8" %>

<%--========================== JSP =========================================--%>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
<%
	String languageStr 	= request.getHeader("Accept-Language");
	String refNo 		= request.getParameter("refNo");
	String mode 		= request.getParameter("mode");
%>

<%--========================== SCRIPT ======================================--%>	
<script language="JavaScript" type="text/javascript" src="scripts/stxHeader.js"></script>
<script language="javascript">
	
	isDone = false;
	/* function doSubmit() 
	{
		
		var jsFile = document.importForm.fileName0.value;
		if(jsFile==null || jsFile=='') {
			alert("Please select excel file to update.");
			return
		}
		alert("It takes a long time.\\nPlease wait for a while it is completed.");
		//document.importForm.btn_Update.disabled = true;
		fn_buttonDisabled([ "#btn_Upload"]);
		var objForm = document.importForm;
		objForm.action = "stxPECTPIInterfaceElecCableUpdateDB.jsp";
		objForm.target = "UpdateLower";
		objForm.submit();
		isDone = true;
		//fnProgressOn();
	} */

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
		document.importForm.action = "buyerClassLetterFaxAttachFileToFTP.do?refNo="+refNo.replace("&","%26")+"&mode="+mode;
		document.importForm.target = "submitFrame";
		document.importForm.submit();
		isDone = true;
		//fnProgressOn();
		//document.importForm.btn_Update.disabled = false;
		//document.importForm.btn_Clear.disabled = true;
		//document.importForm.btn_Upload.disabled = true;
		fn_buttonDisabled([ "#btn_Upload", "#btn_Clear"]);
	}

	function enableUpload(){
		fn_buttonEnable([ "#btn_Upload", "#btn_Clear" ]);
		//document.importForm.btn_Upload.disabled = false;
		//document.importForm.btn_Clear.disabled = false;
	}

	function clearFile(){


		//document.importForm.action = "b.jsp";
		//document.importForm.target = "UpdateLower";
		//document.importForm.submit();
				
		//document.importForm.btn_Clear.disabled = true;
		//document.importForm.btn_Upload.disabled = true;
		fn_buttonDisabled([ "#btn_Upload", "#btn_Clear"]);
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
	
	function resultMsg(data){
		alert(data);
		var returnValue = 'ok';
		window.returnValue = returnValue;
		self.close();
	}
</script>

<!--

<form name="importForm" method="post" action="stxUploadToDB.jsp" target="UpdateLower" onsubmit="javascript:checkInput(); return false"  enctype="multipart/form-data">
-->
<div id="mainDiv" class="mainDiv">
	<div class="subtitle">
		Upload <%=refNo%> Document.
	</div>
	<form  id="upload" name="importForm" method="post" action="" target="" enctype="multipart/form-data">
		<table width="100%" border="0" cellpadding="0" cellspacing="3">
			<tr>
				<td class="inputField">
					<input type="file" size="40" name="fileName0" onclick="javascript:enableUpload()">
			
					<input type="button" class="btn_gray" name="btn_Upload" id="btn_Upload" value="UPLOAD"  disabled="true" onClick="javascript:checkInput()">
			
					<input type="button" class="btn_gray" name="btn_Clear"  id="btn_Clear" value="CLEAR" disabled="true" onClick="javascript:clearFile();reset();">
					
					<input type="button"  class="btn_blue" name="btn_Close" value="CLOSE" onClick="javascript:closeDialog();">
					
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
	
	<iframe name="submitFrame" style="display:none">
		
	</iframe> 
</div>



