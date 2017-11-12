<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - ITEM TYPE 리스트 조회 
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemType.jsp
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>WORLD BEST STX OFFSHORE  SHIPBUILDING</title>
    <jsp:include page="../common/commonStyle.jsp" flush="false"></jsp:include>
    
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
		.button_simple
		{
			font-size: 10pt;
			height: 26px;
			width: 70px;
		}
	
	</style>
	<script language="javascript" type="text/javascript">
		$(document).ready(function(){
			$(window).bind('resize', function() {
				$('#contentdiv').css('height', $(window).height()-30);
			 }).trigger('resize');	
			parent.loadingBox.remove();
		});
	</script>
</head>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
	<div style="margin:2px 2px;">
		<form name="frmCategory" method="post" >
			<table class="insertArea"  style="table-layout:fixed;">
			    <tr align="center" height="28">
			        <th width="30%">SYSTEM CODE</th>
			        <th width="30%">TEMPLATE NAME</th>
			        <th width="40%">DESCRIPTION</th>
			        <th width="16px">&nbsp;</th>
			    </tr>
			</table>
			<div id="contentdiv" style="overflow-y:scroll; position:relative;">
	            <table class="insertArea"  style="table-layout:fixed;">
	           		<c:forEach var="item" items="${list}" varStatus="status"> 
		                <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
		                    <td width="30%">&nbsp;&nbsp;${item.item_type}</td>
		                    <td width="30%">&nbsp;&nbsp;${item.item_type_meaning}</td>
		                    <td width="40%">&nbsp;&nbsp;${item.item_type_desc}</td>
		                 </tr>
	            	</c:forEach>
	            </table>
	        </div>
		</form>
	</div>
</body>
</html>