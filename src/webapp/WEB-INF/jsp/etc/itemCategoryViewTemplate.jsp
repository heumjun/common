<%--  
§DESCRIPTION: EP 품목 기준정보 조회 - Template 리스트 조회
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxEPInfoViewItemTemplate.jsp
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
				$('#contentdiv').css('height', $(window).height()-70);
			 }).trigger('resize');	
			parent.loadingBox.remove();
		});
		
		function actionSearch()
		{
		    var template_value = frmTemplate.template_name.value;
		    if(template_value=="")
		    {
		        alert("TEMPLATE을 선택해 주세요.");
		        return;
		    }    
	
		    frmTemplate.action = "itemCategoryViewTemplate.do";
		    frmTemplate.method = "post";
		    frmTemplate.submit();
		}
	</script>
</head>

<body leftmargin="0" marginwidth="0" topmargin="0" marginheight="0">
	<form name="frmTemplate" method="post" >
		<div style="margin:2px 2px;">
			<div class="ct_sc conSearch" style="height:33px;">
				<strong class="pop_tit mgl10" style="vertical-align: middle;">TEMPLATE</strong>
				<select name="template_name" style="width:530;">
	                <option value="">- Template을 선택해주세요. -</option>
	                <c:forEach var="item" items="${codeList}" varStatus="status"> 
	                    <option value="${item.template_id}" <c:if test="${template_name == item.template_id}">selected</c:if> >${item.template_desc}</option>
	                </c:forEach>
	            </select>
				<div class="button endbox">
					<input type="button" name="buttonSearch" value='조 회' class="btn_blue" onClick="actionSearch();">
					&nbsp;
				</div>
			</div>	
			<table class="insertArea"  style="table-layout:fixed;">
		         <tr align="center">
		             <th width="30%">GROUP</th>
		             <th width="40%">ATTRIBUTE</th>
		             <th width="30%">VALUE</th>
		             <th width="16px">&nbsp;</th>
		         </tr>
		     </table>
			<div id="contentdiv" style="overflow-y:scroll; position:relative;">
		        <table class="insertArea"  style="table-layout:fixed;">
		        	<c:forEach var="item" items="${list}" varStatus="status"> 
			            <tr height="24" bgcolor="#ffffff" onMouseOver="this.style.backgroundColor='#E6E5E5'" OnMouseOut="this.style.backgroundColor='#FFFFFF'">
			                <td width="30%">&nbsp;&nbsp;${item.template_group}</td>
			                <td width="40%">&nbsp;&nbsp;${item.template_code_name}</td>
			                <td width="30%">&nbsp;&nbsp;${item.template_code_value}</td>
			             </tr>
		       		</c:forEach>	
		        </table>
	        </div>
		</div>
	</form>
</body>
</html>