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
  String jsTreeID	= emxGetParameter(request,"jsTreeID");
  String suiteKey	= emxGetParameter(request,"suiteKey");
  
  String refNo		= emxGetParameter(request,"refNo");
  String mode		= emxGetParameter(request,"mode");

  // Specify URL to come in middle of frameset
  String contentUpperURL = "stxPECBuyerClassLetterFaxAttachFileSelectDialog.jsp?refNo="+refNo+"&mode="+mode;
  String contentLowerURL = "b.jsp";
%>

<FRAMESET ROWS="85%,15%" border="0">
	<FRAME SRC="<%=contentUpperURL%>" NAME="UpdateUpper" noresize scrolling="no">
	<FRAME SRC="<%=contentLowerURL%>" NAME="UpdateLower" noresize scrolling="no">
</FRAMESET>

</HTML>


