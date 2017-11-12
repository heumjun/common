<%--  
§DESCRIPTION: EP 부품표준서 조회 - 소분류(부품표준서 정보)
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECSearchStandardItemDrawingLevel_3.jsp
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	<style type="text/css">
		tr,td {font-family:"맑은 고딕","verdana","arial"; font-size: 9pt ; text-decoration: none; color:#1A1A1A;}
		.header {font-family:"맑은 고딕","verdana","arial"; font-size: 13pt ; text-decoration: none; color:#1A1A1A; font-weight : bold;}
		.even {background-color:#eeeeee}
		.odd {background-color:#ffffff}
		
		A:link {color:black; text-decoration: none}
		A:visited {color:black; text-decoration: none}
		A:active {color:green; text-decoration: none ; font-weight : bold;}
		A:hover {color:red;text-decoration:underline font-weight : bold;}
	</style>
</head>
<body>

<form name="frmLevel_3" method="post" >
<table border="0" cellpadding="0" cellspacing="2" width="100%" height="100%" bgcolor="#336699">
    <tr>
        <td>
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="2" bgcolor="white">                  

            	<c:forEach var="item" items="${list}" varStatus="status"> 
                    <tr class="<c:if test="${status.count%2 == 1 }">even</c:if>" height="24">

                        <td width="10%" align="center" 
                            style="cursor:pointer"
                            onClick="hiddenFrame.go_pdfView('${loginID}','${item.view_flag}','${item.PART_SEQ_ID}','${item.item_catalog_group_id}');">
                            <img src="images/pdf_icon.gif" border="0">
                        </td>
                        <td width="16%" align="center">
                            ${item.catalog_S}
                        </td>
                        <td width="*" align="left" style="cursor:pointer"  
                        		onmouseover="this.style.color='red'; this.style.textDecoration='underline';"
                        		onmouseout="this.style.color='black'; this.style.textDecoration='none';"
                        		onclick="hiddenFrame.go_pdfView('${loginID}','${item.view_flag}','${item.PART_SEQ_ID}','${item.item_catalog_group_id}');">
                            ${item.name_S}
                        </td>
                    </tr> 
                  </c:forEach>   

                <tr class="" height="*">
                    <td colspan="3">&nbsp;</td>
                </tr>                      
            </table>
        </td>
    </tr>
</table>
</form>
<iframe id="hiddenFrame" name="hiddenFrame" src="AddOn/EP/stxDSView.jsp" style="display:none"></iframe>
</body>
</html>

