<%--  
��DESCRIPTION: EP ǰ�� �������� ���������� 
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxEPInfoViewFrame.jsp
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%  // ǰ�� �������� view Frame 
	
    String loginID = request.getParameter("loginID");
    //loginID = "207309";

	String frameTop  	= "stxEPInfoItemTopInclude.jsp?loginID="+loginID;
	String frameHeader	= "stxEPInfoViewHeader.jsp?loginID="+loginID;
    String frameMain   	= "stxEPInfoViewCatalog.jsp";
%>


<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
</head>
<style type="text/css">
A:link {color:black; text-decoration: none}
A:visited {color:black; text-decoration: none}
A:active {color:green; text-decoration: none ; font-weight : bold;}
A:hover {color:red;text-decoration:underline font-weight : bold;}
.title_1			{font-family:"����ü"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"����ü"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"����ü"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"����ü"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"����ü"; font-Size: 11pt;}
.title_6			{font-family:"����ü"; font-Size: 10pt;}
.title_7			{font-family:"����ü"; font-Size: 9pt;}
.title_8			{font-family:"����ü"; font-Size: 8pt;}
</style>
<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">

<form name="frmFrame" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr height="30">
        <td>
            <iframe name="INFO_FRAME_TOP" src="<%=frameTop%>" width="100%" height="28" frameborder="0" scrolling=no>  </iframe> 
        </td>
    </tr>

    <tr>
        <td>
            <iframe name="INFO_FRAME_HEADER" src="<%=frameHeader%>" width="100%" height="140" frameborder="0"  scrolling=no>  </iframe> 
        </td>
    </tr>

    <tr>
        <td>
            <iframe name="INFO_FRAME_MAIN" src="<%=frameMain%>" width="100%" height="490" frameborder="0" scrolling=no></iframe> 

        </td>
    </tr>
</table>



</form>
</body>
</html>