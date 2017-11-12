<%@ include file = "stxPECGetParameter_Include.inc" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>

</HEAD>

<%
  String initSource   = emxGetParameter(request,"initSource"); 
  if (initSource == null){
      initSource = "";
  }
  String jsTreeID             = emxGetParameter(request,"jsTreeID");
  String suiteKey             = emxGetParameter(request,"suiteKey");

  // Specify URL to come in middle of frameset
  String contentUpperURL = "stxPECBuyerClassLetterFaxReceiveManagerExcelUploadDialog.jsp";
  String contentLowerURL = "b.jsp";
%>

<FRAMESET ROWS="15%,85%" border="0">
	<FRAME SRC="<%=contentUpperURL%>" NAME="UpdateUpper" noresize scrolling="auto">
	<FRAME SRC="<%=contentLowerURL%>" NAME="UpdateLower" noresize scrolling="auto">
</FRAMESET>
<script language="javascript">
	function setExcelValue(setName , setValue)
	{
		alert(setname +" | "+ setValue);
		var win = window.dialogArguments; 
		alert(win);
		var pform = win.document.receiveManagerForm;
		alert(pform);
		pform.elements[setName].value = setValue;
	}
	
	function test()
	{
		alert("2");
	}
	
</script>
</HTML>


