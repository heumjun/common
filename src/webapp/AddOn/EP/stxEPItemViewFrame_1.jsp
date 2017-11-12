<%--  
§DESCRIPTION: EP 부품표준서 메인 프레임 (전체보기)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPItemViewFrame_1.jsp
--%>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%  // 품목 부품표준서 view Frame 

    String loginID = request.getParameter("loginID");
    //loginID = "207309";
	
	String frameTop  	    = "stxEPInfoItemTopInclude.jsp?loginID="+loginID;
	String frameSearch  	= "stxEPItemViewSearch.jsp?loginID="+loginID;
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
.title_1			{font-family:"굴림체"; font-Size: 12pt; font-weight: bold;}
.title_2			{font-family:"굴림체"; font-Size: 11pt; font-weight: bold;}
.title_3			{font-family:"굴림체"; font-Size: 10pt; font-weight: bold;}
.title_4			{font-family:"굴림체"; font-Size: 9pt; font-weight: bold;}
.title_5			{font-family:"굴림체"; font-Size: 11pt;}
.title_6			{font-family:"굴림체"; font-Size: 10pt;}
.title_7			{font-family:"굴림체"; font-Size: 9pt;}
.title_8			{font-family:"굴림체"; font-Size: 8pt;}
.button_simple {font-size: 9pt;	font-weight: bold; height: 23px; width: 90px; }
</style>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">

<form name="frmFrame" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="100%">
    <tr height="30">
        <td>
            <iframe name="FRAME_TOP" src="<%=frameTop%>" width="100%" height="28" frameborder="0" scrolling=no>  </iframe> 
        </td>
    </tr>

    <tr height="44">
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="2%">&nbsp;</td>
                    <td align="left">        
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td height="5" colspan="2"></td>
                            </tr>
                            <tr height="30"> 
                                <td style="padding-left:0" valign="middle" width="12">
                                    <img src="images/title_icon.gif">
                                </td>
                                <td class="title_1" style="padding-left:3" valign="middle">
                                    &nbsp;STX조선해양 부품표준서  
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <input type="button" class="button_simple" name="searchMode" value="분류별보기" onclick="searchModePageLoad();">    
                                </td>            

                            </tr>
                            <tr height="4" >
                                <td background="images/title_line.gif" colspan="2"></td>
                            </tr>
                            <tr>
                                <td height="5" colspan="2"></td>
                            </tr>
                        </table>
                    </td>
                 </tr>
            </table>
        </td>
    </tr>

    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td width="2%">&nbsp;</td>
                    <td>
                        <iframe name="FRAME_SEARCH" src="<%=frameSearch%>" width="100%" height="550" frameborder="0"></iframe> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>



</form>
</body>
</html>

<script language="javascript">
    function searchModePageLoad()
    {
        var url = "stxEPItemViewFrame.jsp?loginID=<%=loginID%>";
        document.location.href = url;
    }
</script>