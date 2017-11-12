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

  // Specify URL to come in middle of frameset
  String contentUpperURL = "stxPECBuyerClassLetterFaxViewFileDialog.jsp?refNo="+refNo;
  String contentLowerURL = "b.jsp";
%>

<FRAMESET ROWS="100%,0" border="0">
	<FRAME SRC="<%=contentUpperURL%>" NAME="UpdateUpper" noresize scrolling="no">
	<FRAME SRC="<%=contentLowerURL%>" NAME="UpdateLower" noresize scrolling="no">
</FRAMESET>

</HTML>


