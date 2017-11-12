<%--  
§DESCRIPTION: EP 부품표준서 조회 - 중분류 선택
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECSearchStandardItemDrawingLevel_2.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE & SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
	<style type="text/css">
		tr,td,table {font-family:"맑은 고딕","verdana","arial"; font-size: 9pt ; text-decoration: none; color:#1A1A1A;}
		.header {font-family:"맑은 고딕","verdana","arial"; font-size: 13pt ; text-decoration: none; color:#1A1A1A; font-weight : bold;}
		.tableborder {border-width:"1px"; border-color:blue;}
		.even {background-color:#eeeeee}
		.odd {background-color:#ffffff}
		
		A:link {color:black; text-decoration: none}
		A:visited {color:black; text-decoration: none}
		A:active {color:green; text-decoration: none ; font-weight : bold;}
		A:hover {color:red;text-decoration:underline font-weight : bold;}
		.active_tr {background-color: rgb(94, 129, 152); }
		.active_tr td{color: white;}
		.hover_tr {background-color: rgb(94, 129, 152); }
		.hover_tr td{color: white;}
	</style>
	<script language="javascript">

	    function go_level_3(catalog_L,catalog_M)
	    {         
	        var loginID = parent.frmFrame.loginID.value;
	        var url = "itemStandardViewLevel3.do?";
	        url += "loginID="+loginID;
	        url += "&catalog_L="+catalog_L+"&catalog_M="+catalog_M;
	        parent.FRAME_LEVEL_3.location.href = url;
	    }
	    function init(){
			var obj = $("#list_table").find("tr:eq(0)");
			hover_tr(obj);
			obj.click();
		}
		function hover_tr(tr_obj){
			$("#list_table").find("tr").removeClass("active_tr");
			$(tr_obj).addClass("active_tr");
		}
		function hover_on_tr(tr_obj){
			$("#list_table").find("tr").removeClass("hover_tr");
			$(tr_obj).addClass("hover_tr");
		}
		function hover_off_tr(){
			$("#list_table").find("tr").removeClass("hover_tr");
		}
		
		$(document).ready(function (){
			init();
		});
	</script>
</head>

<body>
<form name="frmLevel_2" method="post" >
<table border="0" cellpadding="0" cellspacing="2" width="100%" height="100%" bgcolor="#336699">
    <tr>
        <td>
            <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="2" bgcolor="white" id="list_table" onmouseout="hover_off_tr()">
            <c:forEach var="item" items="${list}" varStatus="status"> 
                    <tr class="<c:if test="${status.count%2 == 1 }">even</c:if>" height="24" onmouseover="hover_on_tr(this);" onclick="hover_tr(this);go_level_3('${item.catalog_L}','${item.catalog_M}');" style="cursor: pointer;">
                        <td align="left">&nbsp;
                        ${item.name_M}
                        </td>                        
                    </tr>                     
            </c:forEach>
                <tr class="" height="*">
                    <td>&nbsp;</td>
                </tr>                      
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

